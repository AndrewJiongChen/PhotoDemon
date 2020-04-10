VERSION 5.00
Begin VB.Form FormCurves 
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   " Curves"
   ClientHeight    =   8205
   ClientLeft      =   -15
   ClientTop       =   225
   ClientWidth     =   13095
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   547
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   873
   ShowInTaskbar   =   0   'False
   Begin PhotoDemon.pdCommandBar cmdBar 
      Align           =   2  'Align Bottom
      Height          =   750
      Left            =   0
      TabIndex        =   0
      Top             =   7455
      Width           =   13095
      _ExtentX        =   23098
      _ExtentY        =   1323
   End
   Begin PhotoDemon.pdFxPreviewCtl pdFxPreview 
      Height          =   5625
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   5625
      _ExtentX        =   9922
      _ExtentY        =   9922
   End
   Begin PhotoDemon.pdButtonStrip btsOptions 
      Height          =   960
      Left            =   6030
      TabIndex        =   3
      Top             =   6360
      Width           =   6795
      _ExtentX        =   11986
      _ExtentY        =   1693
      Caption         =   "display"
   End
   Begin PhotoDemon.pdLabel lblExplanation 
      Height          =   1440
      Left            =   240
      Top             =   5910
      Width           =   5535
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   ""
      ForeColor       =   4210752
      Layout          =   1
   End
   Begin PhotoDemon.pdContainer picContainer 
      Height          =   6150
      Index           =   0
      Left            =   5880
      TabIndex        =   4
      Top             =   60
      Width           =   7215
      _ExtentX        =   0
      _ExtentY        =   0
      Begin VB.PictureBox picDraw 
         Appearance      =   0  'Flat
         AutoRedraw      =   -1  'True
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   5160
         Left            =   120
         ScaleHeight     =   344
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   464
         TabIndex        =   6
         Top             =   0
         Width           =   6960
      End
      Begin PhotoDemon.pdButtonStrip btsChannel 
         Height          =   960
         Left            =   150
         TabIndex        =   7
         Top             =   5160
         Width           =   6795
         _ExtentX        =   11986
         _ExtentY        =   1693
         Caption         =   "channel"
      End
   End
   Begin PhotoDemon.pdContainer picContainer 
      Height          =   6150
      Index           =   1
      Left            =   5880
      TabIndex        =   5
      Top             =   60
      Width           =   7215
      _ExtentX        =   0
      _ExtentY        =   0
      Begin PhotoDemon.pdButtonStrip btsHistogram 
         Height          =   1080
         Left            =   120
         TabIndex        =   9
         Top             =   840
         Width           =   6795
         _ExtentX        =   11986
         _ExtentY        =   1905
         Caption         =   "histogram overlay"
      End
      Begin PhotoDemon.pdButtonStrip btsGrid 
         Height          =   1080
         Left            =   120
         TabIndex        =   2
         Top             =   2100
         Width           =   6795
         _ExtentX        =   11986
         _ExtentY        =   1905
         Caption         =   "grid"
      End
      Begin PhotoDemon.pdButtonStrip btsDiagonalLine 
         Height          =   1080
         Left            =   120
         TabIndex        =   8
         Top             =   3420
         Width           =   6795
         _ExtentX        =   11986
         _ExtentY        =   1905
         Caption         =   "original curve (diagonal line)"
      End
   End
End
Attribute VB_Name = "FormCurves"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'Image Curves Adjustment Dialog
'Copyright 2008-2020 by Tanner Helland
'Created: sometime 2008
'Last updated: 17/May/19
'Last update: simplify display options (histogram is now an on/off toggle)
'
'Standard luminosity adjustment via curves.  This dialog is based heavily on similar tools in other photo editors, but
' with a few neat options of its own.  The curve rendering area has received a great deal of attention; small touches
' like full-AA, dynamic node highlighting, and background histogram are nice improvements over other Curves tools.  I
' have also used some trickery with the picture box that handles the curve edit area - note that the edit area sits
' well within the borders of the picture box.  This is necessary so that nodes at the edge of the histogram are not
' cut-off by the picture box boundaries.  Even when highlighted, nodes at the edges are fully rendered.
'
'As the on-dialog instructions state, the LMB can be used to add new nodes or drag existing nodes.  RMB will delete
' nodes.  There is no hard-coded upper limit on nodes, but because each horizontal pixel can only belong to a single
' node, nodes will be automatically removed if the count exceeds the pixel width of the curve box.  (Never gonna happen,
' but I coded against it anyway!)
'
'The function that actually applies the curve to the image is fully ParamString compatible, meaning this function
' works beautifully with the macro tool despite the complex parameters it requires.  I have also heavily optimized the
' render function to make it extremely quick, and it is currently comparable to brightness/contrast adjustment in speed
' (e.g. VERY FAST!).
'
'Unless otherwise noted, all source code in this file is shared under a simplified BSD license.
' Full license details are available in the LICENSE.md file, or at https://photodemon.org/license/
'
'***************************************************************************

Option Explicit

'Floating-point coordinate type
Private Type fPoint
    pX As Double
    pY As Double
End Type

'This array will store all curve control nodes, including those added by the user at run-time
Private m_numOfNodes() As Long
Private m_curveNodes() As fPoint

'Track mouse status between MouseDown and MouseMove events
Private m_MouseDown As Boolean

'Currently selected node in the workspace area
Private m_selectedNode As Long

'Current mouse position
Private m_MouseX As Single, m_MouseY As Single

'Current channel ([0, 3] where 0 = red, 1 = green, 2 = blue, 3 = luminance)
Private m_curChannel As Long

'Two additional arrays are needed to generate the cubic spline used for the curve function
Private m_p() As Double
Private m_u() As Double

'The final curve is used to fill this array, which will contain the actual spline points for each location
' in the spline.  It will be dynamically resized to match the width of the curve preview picture box.
Private m_CurveResults() As Double

'It is difficult to see the results of the curve if they lie directly on the preview box border.  To circumvent this
' problem, we render the curve dialog to the center of the picture box, with this value specifying the size of the
' blank border used.
Private Const PREVIEW_BORDER_PX As Long = 10

'These five arrays will hold histogram data for the current image.  They are filled when the form is activated, and
' not modified again unless the form is unloaded and reopened.
Private m_hData() As Long
Private m_hDataLog() As Double
Private m_hMax() As Long
Private m_hMaxLog() As Double
Private m_hMaxPosition() As Byte

'An image of the current image histogram is drawn once each for regular and logarithmic, then stored to these DIBs.
Private m_hDIB() As pdDIB

'The current mouse coordinates are rendered to this DIB, which is then overlaid atop the curve box
Private m_mouseCoordFont As pdFont
Private m_mouseCoordDIB As pdDIB

'When the active channel is changed, redraw the curve display
Private Sub btsChannel_Click(ByVal buttonIndex As Long)

    m_curChannel = buttonIndex
    
    'Reset the selected node and mouse position
    m_selectedNode = -1
    m_MouseX = -1
    m_MouseY = -1
    
    'Redraw the current preview (and curve interaction box)
    UpdatePreview

End Sub

Private Sub btsDiagonalLine_Click(ByVal buttonIndex As Long)
    UpdatePreview
End Sub

Private Sub btsGrid_Click(ByVal buttonIndex As Long)
    UpdatePreview
End Sub

Private Sub btsHistogram_Click(ByVal buttonIndex As Long)
    UpdatePreview
End Sub

'Apply four potential curves to an image; one each for RED, GREEN, BLUE, and LUMINANCE/RGB
' Input: four lists of 256 values, one list for channel, with each channel explicitly stating the look-up values
'         for each entry in that channel.
Public Sub ApplyCurveToImage(ByRef listOfPoints As String, Optional ByVal toPreview As Boolean = False, Optional ByRef dstPic As pdFxPreviewCtl)

    If (Not toPreview) Then Message "Applying new curve to image..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim imageData() As Byte, tmpSA As SafeArray2D
    EffectPrep.PrepImageData tmpSA, toPreview, dstPic
    CopyMemory ByVal VarPtrArray(imageData()), VarPtr(tmpSA), 4
    
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curDIBValues.Left
    initY = curDIBValues.Top
    finalX = curDIBValues.Right
    finalY = curDIBValues.Bottom
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    If (Not toPreview) Then ProgressBars.SetProgBarMax finalY
    progBarCheck = ProgressBars.FindBestProgBarValue()
    
    'Color variables
    Dim r As Long, g As Long, b As Long
    
    'Take the list of curve points we were passed (in string format) and convert them into a numeric array.
    Dim cHistogram(0 To 3, 0 To 255) As Long
    
    'Our curves correction can be easily applied using a look-up table; the processed param string will be stored
    ' in this table.
    Dim rMap() As Byte, gMap() As Byte, bMap() As Byte, rgbMap() As Byte
    ReDim rMap(0 To 255) As Byte: ReDim gMap(0 To 255) As Byte: ReDim bMap(0 To 255) As Byte: ReDim rgbMap(0 To 255) As Byte
    
    Dim tmpTransfer As Long
    
    Dim cParams As pdSerialize
    Set cParams = New pdSerialize
    cParams.SetParamString listOfPoints
    
    Dim i As Long
    
    'Repeat our calculations for each channel; note that values are stored in RGBL order in the param string, with 256
    ' unique entries for each channel (one each for each potential byte value).
    For i = 0 To 3
        
        'Determine the correct name for this channel
        Dim channelName As String
        If (i = 0) Then channelName = "blue"
        If (i = 1) Then channelName = "green"
        If (i = 2) Then channelName = "red"
        If (i = 3) Then channelName = "rgb"
        
        For x = 0 To 255
            cHistogram(i, x) = cParams.GetDouble(channelName & Trim$(Str$(x)), x / 255) * 255#
        Next x
        
        For x = 0 To 255
            
            'Perform one final failsafe clamp check
            tmpTransfer = Int(cHistogram(i, x))
            If (tmpTransfer < 0) Then tmpTransfer = 0
            If (tmpTransfer > 255) Then tmpTransfer = 255
            
            If (i = 0) Then bMap(x) = tmpTransfer
            If (i = 1) Then gMap(x) = tmpTransfer
            If (i = 2) Then rMap(x) = tmpTransfer
            If (i = 3) Then rgbMap(x) = tmpTransfer
            
        Next x
        
    Next i
        
    'Loop through each pixel in the image, converting values as we go
    initX = initX * 4
    finalX = finalX * 4
    
    For y = initY To finalY
    For x = initX To finalX Step 4
    
        'Get the source pixel color values
        b = bMap(imageData(x, y))
        g = gMap(imageData(x + 1, y))
        r = rMap(imageData(x + 2, y))
        
        'Assign the new values to each color channel
        imageData(x, y) = rgbMap(b)
        imageData(x + 1, y) = rgbMap(g)
        imageData(x + 2, y) = rgbMap(r)
        
    Next x
        If (Not toPreview) Then
            If (y And progBarCheck) = 0 Then
                If Interface.UserPressedESC() Then Exit For
                SetProgBarVal y
            End If
        End If
    Next y
    
    'Safely deallocate imageData()
    workingDIB.UnwrapArrayFromDIB imageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    EffectPrep.FinalizeImageData toPreview, dstPic
        
End Sub

'The bottom button bar toggle which panel is visible
Private Sub btsOptions_Click(ByVal buttonIndex As Long)
    picContainer(0).Visible = (buttonIndex = 0)
    picContainer(1).Visible = (buttonIndex <> 0)
End Sub

'Nodes from the Curves dialog must be manually added to the preset file when requested.  This event will be raised
' whenever the command bar needs custom data from us.
Private Sub cmdBar_AddCustomPresetData()
    
    'Next, place all node data in one giant string.
    ' UPDATE 03 Dec 2013: instead of storing absolute coordinates, store relative ones per the size of the
    '                     curve box.  This fixes an extremely rare error when the user changes DPI for their
    '                     monitor while having a previously stored set of curve coordinates.
    Dim nodeBoxWidth As Long, nodeBoxHeight As Long
    nodeBoxWidth = picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2
    nodeBoxHeight = picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2
    
    Dim i As Long, j As Long
    
    Dim cParams As pdSerialize
    Set cParams = New pdSerialize
    
    Dim newNodeName As String
    
    For i = 0 To 3
    
        'Write the number of nodes for this array to file
        cmdBar.AddPresetData "NodeCount_" & i, Trim$(Str$(m_numOfNodes(i)))
        
        cParams.Reset
        
        'Compile all nodes into a single string, with coordinate pairs separated by "|" and x/y values separated by ";"
        For j = 1 To m_numOfNodes(i)
            newNodeName = Trim$(Str$(i)) & "_" & Trim$(Str$(j)) & "_x"
            cParams.AddParam newNodeName, Trim$(Str$((m_curveNodes(i, j).pX - PREVIEW_BORDER_PX) / nodeBoxWidth))
            newNodeName = Trim$(Str$(i)) & "_" & Trim$(Str$(j)) & "_y"
            cParams.AddParam newNodeName, Trim$(Str$((m_curveNodes(i, j).pY - PREVIEW_BORDER_PX) / nodeBoxHeight))
        Next j
    
        cmdBar.AddPresetData "NodeData_" & i, cParams.GetParamString()
    
    Next i
    
End Sub

'Randomizing the curves array is a bit more complicated than normal tools, because we have to randomize it ourselves.
Private Sub cmdBar_RandomizeClick()

    Randomize Timer
    
    Dim i As Long, j As Long
    
    'Reset the node array.  Note that in order to simplify our code, we limit the node count to 513 unique points.  In reality,
    ' nowhere near this many will ever be used, but it doesn't hurt to err on the side of safety.
    ReDim m_curveNodes(0 To 3, 0 To 512) As fPoint
    
    'Initialize each control to somewhere between 3 and 6 randomly distributed points
    For i = 0 To 3
    
        'Set a random number of nodes for this location
        m_numOfNodes(i) = Int(Rnd * 4) + 3
        
        'Start by equally spacing the nodes
        
        For j = 0 To m_numOfNodes(i)
            m_curveNodes(i, j).pX = (j - 1) * ((picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2) / (m_numOfNodes(i) - 1))
            m_curveNodes(i, j).pY = (picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2) - (m_curveNodes(i, j).pX / (picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2)) * (picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2)
            m_curveNodes(i, j).pX = m_curveNodes(i, j).pX + PREVIEW_BORDER_PX
            m_curveNodes(i, j).pY = m_curveNodes(i, j).pY + PREVIEW_BORDER_PX
        Next j
        
        'Finally, move all nodes a random amount up or down, left or right
        For j = 0 To m_numOfNodes(i)
            
            m_curveNodes(i, j).pX = m_curveNodes(i, j).pX + Int(-20 + Rnd * 41)
            If m_curveNodes(i, j).pX < PREVIEW_BORDER_PX Then m_curveNodes(i, j).pX = PREVIEW_BORDER_PX
            If m_curveNodes(i, j).pX > (picDraw.ScaleWidth - PREVIEW_BORDER_PX) Then m_curveNodes(i, j).pX = (picDraw.ScaleWidth - PREVIEW_BORDER_PX)
            
            m_curveNodes(i, j).pY = m_curveNodes(i, j).pY + Int(-40 + Rnd * 81)
            If m_curveNodes(i, j).pY < PREVIEW_BORDER_PX Then m_curveNodes(i, j).pY = PREVIEW_BORDER_PX
            If m_curveNodes(i, j).pY > (picDraw.ScaleHeight - PREVIEW_BORDER_PX) Then m_curveNodes(i, j).pY = (picDraw.ScaleHeight - PREVIEW_BORDER_PX)
            
        Next j
    
    Next i
    
    'Don't change the active panel during a randomize event
    btsOptions.ListIndex = 0
    
End Sub

'When a preset is loaded from file, we need to retrieve the custom curve information alongside it
Private Sub cmdBar_ReadCustomPresetData()
    
    'Erase the m_curveNodes array in preparation for receiving the preset data from file
    ReDim m_numOfNodes(0 To 3) As Long
    ReDim m_curveNodes(0 To 3, 0 To 512) As fPoint
    
    'UPDATE 03 Dec 2013: instead of storing absolute coordinates, we now store relative ones per the size of
    '                    the curve box.  This fixes an extremely rare error when the user changes DPI for
    '                    their monitor while having a previously stored set of curve coordinates.
    Dim nodeBoxWidth As Long, nodeBoxHeight As Long
    nodeBoxWidth = picDraw.ScaleWidth - (PREVIEW_BORDER_PX * 2)
    nodeBoxHeight = picDraw.ScaleHeight - (PREVIEW_BORDER_PX * 2)
    
    Dim tmpString As String
    
    Dim cParams As pdSerialize
    Set cParams = New pdSerialize
    
    Dim i As Long, j As Long
    For i = 0 To 3
    
        'Retrieve the number of nodes for this channel
        tmpString = cmdBar.RetrievePresetData("NodeCount_" & i)
        
        'If no node data is found for this entry, reset all node data and exit immediately
        If (Len(tmpString) = 0) Then
            ResetCurvePoints
            Exit Sub
        End If
        
        m_numOfNodes(i) = CLng(tmpString)
    
        'Retrieve the string that contains the actual node coordinates
        tmpString = cmdBar.RetrievePresetData("NodeData_" & i)
    
        'With the help of a paramString class, parse out individual coordinates into the m_curveNodes array
        cParams.SetParamString tmpString
        
        'Iterate through all nodes in the list, copying them into our m_curveNodes array as we go
        For j = 1 To m_numOfNodes(i)
            
            'Retrieve this node's x and y values
            If cParams.DoesParamExist(Trim$(Str$(i)) & "_" & Trim$(Str$(j)) & "_x") Then
                m_curveNodes(i, j).pX = cParams.GetDouble(Trim$(Str$(i)) & "_" & Trim$(Str$(j)) & "_x")
                m_curveNodes(i, j).pY = cParams.GetDouble(Trim$(Str$(i)) & "_" & Trim$(Str$(j)) & "_y")
            Else
                ResetCurvePoints
                Exit Sub
            End If
            
            'Old preset values may store the node values as absolutes rather than relatives.  Check for this, and
            ' adjust node values accordingly.
            If m_curveNodes(i, j).pX > 1 Then
            
                If m_curveNodes(i, j).pX > nodeBoxWidth Then m_curveNodes(i, j).pX = nodeBoxWidth
                If m_curveNodes(i, j).pY > nodeBoxHeight Then m_curveNodes(i, j).pY = nodeBoxHeight
            
            Else
            
                m_curveNodes(i, j).pX = m_curveNodes(i, j).pX * nodeBoxWidth
                m_curveNodes(i, j).pY = m_curveNodes(i, j).pY * nodeBoxHeight
            
            End If
            
            'Add the preview border offset to all incoming values as well
            m_curveNodes(i, j).pX = m_curveNodes(i, j).pX + PREVIEW_BORDER_PX
            m_curveNodes(i, j).pY = m_curveNodes(i, j).pY + PREVIEW_BORDER_PX
                    
        Next j
        
    Next i
    
End Sub

Private Sub cmdBar_RequestPreviewUpdate()
    UpdatePreview
End Sub

Private Sub cmdBar_OKClick()
    Process "Curves", , GetLocalParamString(), UNDO_Layer
End Sub

'Reset the curve to three points in a straight line
Private Sub cmdBar_ResetClick()

    ResetCurvePoints
    
    'Also, reset will automatically select the first entry in a button strip, which isn't ideal for this control.
    btsChannel.ListIndex = 3
    btsHistogram.ListIndex = 0
    
End Sub

Private Sub Form_Load()
    
    'Disable previews until the form has finished initializing
    cmdBar.SetPreviewStatus False
    
    'Populate the channel selector
    btsChannel.AddItem "red", 0
    btsChannel.AddItem "green", 1
    btsChannel.AddItem "blue", 2
    btsChannel.AddItem "RGB", 3
    
    Dim btnImageSize As Long, btnImageSizeGroup As Long
    btnImageSize = Interface.FixDPI(16)
    btnImageSizeGroup = Interface.FixDPI(24)
    btsChannel.AssignImageToItem 0, , Interface.GetRuntimeUIDIB(pdri_ChannelRed, btnImageSize, 2), btnImageSize, btnImageSize
    btsChannel.AssignImageToItem 1, , Interface.GetRuntimeUIDIB(pdri_ChannelGreen, btnImageSize, 2), btnImageSize, btnImageSize
    btsChannel.AssignImageToItem 2, , Interface.GetRuntimeUIDIB(pdri_ChannelBlue, btnImageSize, 2), btnImageSize, btnImageSize
    btsChannel.AssignImageToItem 3, , Interface.GetRuntimeUIDIB(pdri_ChannelRGB, btnImageSizeGroup, 2), btnImageSizeGroup, btnImageSizeGroup
    
    'Populate the histogram display options
    btsHistogram.AddItem "on", 0
    btsHistogram.AddItem "off", 1
    btsHistogram.ListIndex = 0
    
    'Populate the grid on/off selector
    btsGrid.AddItem "on", 0
    btsGrid.AddItem "off", 1
    btsGrid.ListIndex = 0
    picContainer(0).Visible = True
    picContainer(1).Visible = False
    
    'Populate the original curve (diagonal line) selector
    btsDiagonalLine.AddItem "on", 0
    btsDiagonalLine.AddItem "off", 1
    btsDiagonalLine.ListIndex = 0
    
    'Populate the options selector
    btsOptions.AddItem "tool", 0
    btsOptions.AddItem "options", 1
    btsOptions.ListIndex = 0
    
    'Initialize the dynamic mouse coordinate font and DIB display
    Set m_mouseCoordDIB = New pdDIB
    Set m_mouseCoordFont = New pdFont
    
    With m_mouseCoordFont
        .SetFontColor RGB(25, 25, 25)
        .SetFontBold True
        .SetFontSize 10
        .CreateFontObject
        .SetTextAlignment vbLeftJustify
    End With
    
    'Make the RGB button pressed by default; this will be overridden by the user's last-used settings, if any exist
    m_curChannel = 3
    btsChannel.ListIndex = 3
    
    'Populate the explanation label
    Dim addInstructions As String
    addInstructions = g_Language.TranslateMessage("instructions:")
    addInstructions = addInstructions & vbCrLf
    addInstructions = addInstructions & "  + " & g_Language.TranslateMessage("left-click to add new nodes or drag existing nodes")
    addInstructions = addInstructions & vbCrLf
    addInstructions = addInstructions & "  + " & g_Language.TranslateMessage("right-click to remove nodes")
    
    lblExplanation.Caption = addInstructions
    
    'Mark the mouse as not being down
    m_MouseDown = False
    
    'Fill the histogram arrays
    Histograms.FillHistogramArrays m_hData, m_hDataLog, m_hMax, m_hMaxLog, m_hMaxPosition, True
    
    'Generate matching overlay images
    Histograms.GenerateHistogramImages m_hData, m_hMax, m_hDIB, picDraw.ScaleWidth - (PREVIEW_BORDER_PX * 2) - 1, picDraw.ScaleHeight - (PREVIEW_BORDER_PX * 2) - 1
        
    'Apply translations and visual themes
    ApplyThemeAndTranslations Me
    
    cmdBar.SetPreviewStatus True
    UpdatePreview
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseFormTheming Me
End Sub

'Redraw the on-screen preview of the transformed image
Private Sub UpdatePreview(Optional ByVal recalculateCurves As Boolean = True)
    
    If cmdBar.PreviewsAllowed Then
    
        'If we need to calculate new curve formulas, do so now
        If recalculateCurves Then
            FillResultsArray
            RedrawPreviewBox
        End If
        
        'Redraw the image effect preview
        ApplyCurveToImage GetLocalParamString(), True, pdFxPreview
        
    End If
    
End Sub

'TODO: rewrite this monstrosity against pd2D, and render to a persistent DIB instead of directly to the picture box (ugh)
Private Sub RedrawPreviewBox()

    If (Not cmdBar.PreviewsAllowed) Or (Not PDMain.IsProgramRunning()) Then Exit Sub

    picDraw.Picture = LoadPicture(vbNullString)
    
    'Prepare a target DIB at the same dimensions as the on-screen picture box
    Dim dstDIB As pdDIB
    Set dstDIB = New pdDIB
    
    'Start by copying the proper histogram image into the picture box
    On Error GoTo SkipHistogramRender
    
    Select Case btsHistogram.ListIndex
    
        'Histogram overlay on
        Case 0
            m_hDIB(m_curChannel).AlphaBlendToDC picDraw.hDC, , PREVIEW_BORDER_PX + 1, PREVIEW_BORDER_PX + 1
        
        'Overlay off
        Case 1
            
    End Select
    
    'Next, draw a grid that separates the image into 16 segments; this helps orient the user, and it also provides a
    ' border for the drawing area (important since that area sits well within the picture box itself).
SkipHistogramRender:
    picDraw.DrawWidth = 1
    picDraw.ForeColor = RGB(172, 172, 172)
    
    Dim i As Long
    Dim loopUpperLimit As Long
    
    If btsGrid.ListIndex = 0 Then loopUpperLimit = 4 Else loopUpperLimit = 1
    
    For i = 0 To loopUpperLimit
        picDraw.Line (PREVIEW_BORDER_PX + (i / loopUpperLimit) * (picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2), PREVIEW_BORDER_PX)-(PREVIEW_BORDER_PX + (i / loopUpperLimit) * (picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2), picDraw.ScaleHeight - PREVIEW_BORDER_PX)
        picDraw.Line (PREVIEW_BORDER_PX, PREVIEW_BORDER_PX + (i / loopUpperLimit) * (picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2))-(picDraw.ScaleWidth - PREVIEW_BORDER_PX, PREVIEW_BORDER_PX + (i / loopUpperLimit) * (picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2))
    Next i
    
    'Next, draw a diagonal per the user's request
    If btsDiagonalLine.ListIndex = 0 Then
        GDIPlusDrawLineToDC picDraw.hDC, PREVIEW_BORDER_PX, picDraw.ScaleHeight - PREVIEW_BORDER_PX, picDraw.ScaleWidth - PREVIEW_BORDER_PX, PREVIEW_BORDER_PX, RGB(127, 127, 127), 127
    End If
    
    'Use the previously created spline array (m_CurveResults) to draw the cubic spline onto picDraw, while using GDI+ for antialiasing
    For i = PREVIEW_BORDER_PX + 1 To picDraw.ScaleWidth - PREVIEW_BORDER_PX
        GDIPlusDrawLineToDC picDraw.hDC, i, m_CurveResults(m_curChannel, i), i - 1, m_CurveResults(m_curChannel, i - 1), RGB(0, 0, 0), 210, 2
    Next i
    
    'Next, render the spline control points.
    Dim circRadius As Long
    circRadius = FixDPI(8)
    
    Dim circAlpha As Long
    circAlpha = 190
    
    'The curves function requires an input of 256 points - one for each level of the histogram.
    'NOTE: this function requires fillResultsArray() to have been called immediately prior.  Otherwise, the
    '       m_CurveResults array will not contain the entries necessary to generate a parameter list.
    For i = 1 To m_numOfNodes(m_curChannel)
        GDIPlusFillEllipseToDC picDraw.hDC, m_curveNodes(m_curChannel, i).pX - (circRadius / 2), m_curveNodes(m_curChannel, i).pY - (circRadius / 2), circRadius, circRadius, RGB(32, 32, 64), True
    Next i
    
    'Render a special highlight around the currently selected node
    If m_selectedNode > 0 Then
        GDIPlusDrawCanvasCircle picDraw.hDC, m_curveNodes(m_curChannel, m_selectedNode).pX, m_curveNodes(m_curChannel, m_selectedNode).pY, circRadius, circAlpha
    End If
    
    'Finally, display a live coordinate overlay for the current mouse position.  If a node is selected, the coordinate display
    ' will reflect that node; otherwise, it will display the interpolated value of the curve at the current mouse position.
    If (m_selectedNode > 0) Or ((m_MouseX > PREVIEW_BORDER_PX) And (m_MouseX < picDraw.ScaleWidth - PREVIEW_BORDER_PX) And (m_MouseY > PREVIEW_BORDER_PX) And (m_MouseY < picDraw.ScaleHeight - PREVIEW_BORDER_PX)) Then
    
        'Generate input and output node coordinate strings first; we do these separately, because we want to calculate
        ' width independently for each string, and use the larger of the two as our bounding rect for the coordinate overlay.
        Dim coordString As String, coordStringI As String, coordStringO As String
        
        Dim coordActualX As Double, coordActualY As Double
        Dim coordRelativeX As Double, coordRelativeY As Double
        
        'If a node is currently being hovered/clicked, lock the mouse position to that node.  Otherwise, use the interpolated
        ' curve value at this location.
        If (m_selectedNode > 0) Then
            coordActualX = m_curveNodes(m_curChannel, m_selectedNode).pX
            coordActualY = m_curveNodes(m_curChannel, m_selectedNode).pY
        Else
            coordActualX = m_MouseX
            coordActualY = m_CurveResults(m_curChannel, m_MouseX)
        End If
        
        'Draw lines at the current curve position, to help orient the user
        GDIPlusDrawLineToDC picDraw.hDC, CLng(coordActualX), CLng(PREVIEW_BORDER_PX), CLng(coordActualX), CLng(picDraw.ScaleHeight - PREVIEW_BORDER_PX), RGB(32, 32, 64), 172
        GDIPlusDrawLineToDC picDraw.hDC, CLng(PREVIEW_BORDER_PX), CLng(coordActualY), CLng(picDraw.ScaleWidth - PREVIEW_BORDER_PX), CLng(coordActualY), RGB(32, 32, 64), 172
        
        'From the physical x/y position of the mouse cursor, generate relative x/y values in the [0,255] range, which will be the
        ' values actually displayed to the user.
        coordRelativeX = (coordActualX - PREVIEW_BORDER_PX) / (picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2)
        coordRelativeX = coordRelativeX * 255
        
        coordRelativeY = (coordActualY - PREVIEW_BORDER_PX) / (picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2)
        coordRelativeY = coordRelativeY * 255
        
        'Use those coordinates to generate an actual input and output string, with translations applied
        coordStringI = g_Language.TranslateMessage("input:") & " " & CLng(coordRelativeX)
        coordStringO = g_Language.TranslateMessage("output:") & " " & CLng(255 - coordRelativeY)
        
        'Find the larger of the two strings
        Dim maxStringWidth As Long
        maxStringWidth = m_mouseCoordFont.GetWidthOfString(coordStringI)
        If m_mouseCoordFont.GetWidthOfString(coordStringO) > maxStringWidth Then maxStringWidth = m_mouseCoordFont.GetWidthOfString(coordStringO)
        
        'Concatenate the input and output strings
        coordString = coordStringI & vbCrLf & coordStringO
        
        'Calculate the size of the concatenated input/output string (in pixels, both width and height, with the width limited
        ' to the larger of the original two strings)
        Dim coordStringWidth As Long, coordStringHeight As Long
        coordStringWidth = maxStringWidth
        coordStringHeight = m_mouseCoordFont.GetHeightOfWordwrapString(coordString, coordStringWidth + 1)
        
        'Create a new DIB at the size of the string (with a slight bit of padding on all sides)
        Dim coordBoxWidth As Long, coordBoxHeight As Long
        coordBoxWidth = coordStringWidth + FixDPI(8)
        coordBoxHeight = coordStringHeight + FixDPI(5)
        
        If (m_mouseCoordDIB Is Nothing) Then
            m_mouseCoordDIB.CreateBlank coordBoxWidth, coordBoxHeight, 24, RGB(255, 255, 255)
        Else
            If (m_mouseCoordDIB.GetDIBWidth <> coordBoxWidth) Or (m_mouseCoordDIB.GetDIBHeight <> coordBoxHeight) Then
                m_mouseCoordDIB.CreateBlank coordBoxWidth, coordBoxHeight, 24, RGB(255, 255, 255)
            Else
                m_mouseCoordDIB.ResetDIB 255
            End If
        End If
        
        'Render the coordinate string onto the temporary DIB
        m_mouseCoordFont.AttachToDC m_mouseCoordDIB.GetDIBDC
        m_mouseCoordFont.FastRenderMultilineText FixDPI(4), FixDPI(2), coordString
        m_mouseCoordFont.ReleaseFromDC
        
        'Render a 1px border around the coordinate overlay
        GDIPlusDrawRectOutlineToDC m_mouseCoordDIB.GetDIBDC, 0, 0, m_mouseCoordDIB.GetDIBWidth - 1, m_mouseCoordDIB.GetDIBHeight - 1, RGB(25, 25, 25)
        
        'Calculate render coordinates for the coordinate box.  Normally these will be placed below and to the right of a
        ' given node, but if that location lies off-image, move the overlay in-bounds.
        Dim coordX As Long, coordY As Long
        
        coordX = coordActualX + FixDPI(3)
        If (coordX < 0) Then coordX = 0
        If (coordX + m_mouseCoordDIB.GetDIBWidth > picDraw.ScaleWidth) Then coordX = picDraw.ScaleWidth - m_mouseCoordDIB.GetDIBWidth
        
        coordY = coordActualY + FixDPI(3)
        If (coordY < 0) Then coordY = 0
        If (coordY + m_mouseCoordDIB.GetDIBHeight > picDraw.ScaleHeight) Then coordY = picDraw.ScaleHeight - m_mouseCoordDIB.GetDIBHeight
        
        'Render the completed coordinate overlay DIB onto the main curve box
        m_mouseCoordDIB.AlphaBlendToDC picDraw.hDC, 192, coordX, coordY
        
    End If
    
    'Lock the image, force a refresh, and our work here is done
    picDraw.Picture = picDraw.Image
    picDraw.Refresh
    
End Sub

Private Sub picDraw_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    
    'If the mouse is over a point, mark it as the active point
    m_selectedNode = CheckClick(x, y)
    
    'Different actions are initiated for left vs right clicks (left to add/move points, right to remove)
    If ((Button And vbLeftButton) <> 0) Then
    
        m_MouseDown = True
        
        'If this click was not over an existing point, add a new one to the point list!
        If (m_selectedNode = -1) Then
        
            'Find the appropriate location in the array for this point.
            Dim i As Long
            
            Dim pointFound As Long
            pointFound = -1
            
            For i = 0 To m_numOfNodes(m_curChannel)
                If (m_curveNodes(m_curChannel, i).pX > x) Then
                    pointFound = i
                    Exit For
                End If
            Next i
        
            m_numOfNodes(m_curChannel) = m_numOfNodes(m_curChannel) + 1
            
            'If a neighboring point was found, use that location to insert the new point
            If (pointFound > -1) Then
                
                'Shift all points "above" this one to the right
                For i = m_numOfNodes(m_curChannel) To pointFound + 1 Step -1
                    m_curveNodes(m_curChannel, i).pX = m_curveNodes(m_curChannel, i - 1).pX
                    m_curveNodes(m_curChannel, i).pY = m_curveNodes(m_curChannel, i - 1).pY
                Next i
                
                'Store the new point
                m_curveNodes(m_curChannel, pointFound).pX = x
                m_curveNodes(m_curChannel, pointFound).pY = y
                
                'Make sure the new point falls within acceptable boundaries
                If (m_curveNodes(m_curChannel, pointFound).pX < PREVIEW_BORDER_PX) Then m_curveNodes(m_curChannel, pointFound).pX = PREVIEW_BORDER_PX
                If (m_curveNodes(m_curChannel, pointFound).pX > picDraw.ScaleWidth - PREVIEW_BORDER_PX) Then m_curveNodes(m_curChannel, pointFound).pX = picDraw.ScaleWidth - PREVIEW_BORDER_PX
                If (m_curveNodes(m_curChannel, pointFound).pY < PREVIEW_BORDER_PX) Then m_curveNodes(m_curChannel, pointFound).pY = PREVIEW_BORDER_PX
                If (m_curveNodes(m_curChannel, pointFound).pY > picDraw.ScaleHeight - PREVIEW_BORDER_PX) Then m_curveNodes(m_curChannel, pointFound).pY = picDraw.ScaleHeight - PREVIEW_BORDER_PX
                
                'Perform a fail-safe check of the array to make sure there are no duplicate x-values
                For i = m_numOfNodes(m_curChannel) To 1 Step -1
                    If (m_curveNodes(m_curChannel, i).pX = m_curveNodes(m_curChannel, i - 1).pX) Then m_curveNodes(m_curChannel, i - 1).pX = m_curveNodes(m_curChannel, i - 1).pX - 1
                Next i
                
                'And finally, perform an additional fail-safe to remove any x-values that now occur outside acceptable boundaries
                ' (e.g. points pushed off the left of the curve)
                For i = m_numOfNodes(m_curChannel) To 1 Step -1
                    If (m_curveNodes(m_curChannel, i).pX < PREVIEW_BORDER_PX) Then DeleteCurveNode i
                Next i
                
                'Mark this node as the currently selected one
                m_selectedNode = pointFound
            
            'If no neighboring point was found, this point should be inserted at the end of the curve
            Else
                m_curveNodes(m_curChannel, m_numOfNodes(m_curChannel)).pX = x
                m_curveNodes(m_curChannel, m_numOfNodes(m_curChannel)).pY = y
                m_selectedNode = m_numOfNodes(m_curChannel)
            End If
            
            'Request a full redraw of the curve
            UpdatePreview
        
        End If
        
    'On right-clicks, remove the selected point
    ElseIf ((Button And vbRightButton) <> 0) Then
    
        'Only erase a point if one was actually clicked; then request a redraw
        If (m_selectedNode > -1) Then
            DeleteCurveNode m_selectedNode
            UpdatePreview
        End If
        
    End If
    
End Sub

'Delete the specified node from the curve.  This function assumes that the passed nodeIndex is a valid entry.
Private Sub DeleteCurveNode(ByVal nodeIndex As Long)

    'Only erase a node if more than two nodes will be left after the operation
    If (m_numOfNodes(m_curChannel) > 2) Then
    
        'Start by shifting all nodes "above" the current one to the left
        Dim i As Long
        For i = nodeIndex To m_numOfNodes(m_curChannel) - 1
            m_curveNodes(m_curChannel, i).pX = m_curveNodes(m_curChannel, i + 1).pX
            m_curveNodes(m_curChannel, i).pY = m_curveNodes(m_curChannel, i + 1).pY
        Next i
        
        'Reduce the point count and resize the main point array
        m_numOfNodes(m_curChannel) = m_numOfNodes(m_curChannel) - 1
        'ReDim Preserve m_curveNodes(0 To m_numOfNodes) As fPoint
    
        m_selectedNode = -1
    
    End If

End Sub

Private Sub picDraw_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)

    'Store the current mouse position in module-level variables.  The render function may use these to display a coordinate overlay.
    m_MouseX = x
    m_MouseY = y

    'If the mouse is *not* down, indicate to the user that points can be moved
    If (Not m_MouseDown) Then
        
        'If the user is close to a knot, change the mousepointer to 'move'
        If (CheckClick(x, y) > -1) Then
            If (picDraw.MousePointer <> 5) Then picDraw.MousePointer = 5
            m_selectedNode = CheckClick(x, y)
        Else
            If (picDraw.MousePointer <> 0) Then picDraw.MousePointer = 0
            m_selectedNode = -1
        End If
        
        'Redraw just the preview box, with the selected node highlighted
        FillResultsArray
        RedrawPreviewBox
            
    'If the mouse *is* down, move the current point and redraw the preview
    Else
    
        If (m_selectedNode > 0) Then
        
            m_curveNodes(m_curChannel, m_selectedNode).pX = x
            m_curveNodes(m_curChannel, m_selectedNode).pY = y
            
            'Perform basic bounds-checking.  Points are not allowed to cross over each other, and they cannot lie
            ' outside the bounds of the curve preview box.
            If (m_selectedNode < m_numOfNodes(m_curChannel)) Then
                If (m_curveNodes(m_curChannel, m_selectedNode).pX >= m_curveNodes(m_curChannel, m_selectedNode + 1).pX) Then m_curveNodes(m_curChannel, m_selectedNode).pX = m_curveNodes(m_curChannel, m_selectedNode + 1).pX - 1
            End If
            
            'Because legitimate points start at index position 1, we don't need to worry about "if m_selectedNode > 0"
            ' as that statement is already handled at the top of this segment.
            If (m_curveNodes(m_curChannel, m_selectedNode).pX <= m_curveNodes(m_curChannel, m_selectedNode - 1).pX) Then
                m_curveNodes(m_curChannel, m_selectedNode).pX = m_curveNodes(m_curChannel, m_selectedNode - 1).pX + 1
            End If
            
            If (m_curveNodes(m_curChannel, m_selectedNode).pX < PREVIEW_BORDER_PX) Then m_curveNodes(m_curChannel, m_selectedNode).pX = PREVIEW_BORDER_PX
            If (m_curveNodes(m_curChannel, m_selectedNode).pX > picDraw.ScaleWidth - PREVIEW_BORDER_PX) Then m_curveNodes(m_curChannel, m_selectedNode).pX = picDraw.ScaleWidth - PREVIEW_BORDER_PX
            If (m_curveNodes(m_curChannel, m_selectedNode).pY < PREVIEW_BORDER_PX) Then m_curveNodes(m_curChannel, m_selectedNode).pY = PREVIEW_BORDER_PX
            If (m_curveNodes(m_curChannel, m_selectedNode).pY > picDraw.ScaleHeight - PREVIEW_BORDER_PX) Then m_curveNodes(m_curChannel, m_selectedNode).pY = picDraw.ScaleHeight - PREVIEW_BORDER_PX
            
            UpdatePreview
            
        Else
            FillResultsArray
            RedrawPreviewBox
        End If
    
    End If

End Sub

Private Sub picDraw_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    m_MouseDown = False
    m_selectedNode = -1
End Sub

'Simple distance routine to see if a location on the picture box is near an existing point
Private Function CheckClick(ByVal x As Long, ByVal y As Long) As Long
    
    'Returning -1 says we're not close to an existing point
    CheckClick = -1
    
    Dim pDist As Double, minDistance As Double, minIndex As Long
    minDistance = picDraw.ScaleWidth
    
    'Find the node nearest the current point
    Dim i As Long
    For i = 1 To m_numOfNodes(m_curChannel)
    
        pDist = PDMath.DistanceTwoPoints(x, y, m_curveNodes(m_curChannel, i).pX, m_curveNodes(m_curChannel, i).pY)
        
        If (pDist < minDistance) Then
            minDistance = pDist
            minIndex = i
        End If
        
    Next i
    
    'If the closest node is more than (g_MouseAccuracy) away, return it
    If (minDistance < g_MouseAccuracy) Then CheckClick = minIndex
    
End Function

'Original required spline function:
Private Function GetCurvePoint(ByVal curChannel As Long, ByVal i As Long, ByVal v As Double) As Double
    Dim t As Double
    t = (v - m_curveNodes(curChannel, i).pX) / m_u(i)
    GetCurvePoint = t * m_curveNodes(curChannel, i + 1).pY + (1 - t) * m_curveNodes(curChannel, i).pY + m_u(i) * m_u(i) * (CalcSpline(t) * m_p(i + 1) + CalcSpline(1 - t) * m_p(i)) / 6#
End Function

'Original required spline function:
Private Function CalcSpline(ByVal x As Double) As Double
        CalcSpline = x * x * x - x
End Function

'Original required spline function:
Private Sub SetPandU(ByVal channelID As Long)
    
    Dim i As Long
    Dim d() As Double
    Dim w() As Double
    ReDim d(0 To m_numOfNodes(channelID)) As Double
    ReDim w(0 To m_numOfNodes(channelID)) As Double
    
    'Routine to compute the parameters of our cubic spline.  Based on equations derived from some basic facts...
    'Each segment must be a cubic polynomial.  Curve segments must have equal first and second derivatives
    'at knots they share.  General algorithm taken from a book which has long since been lost.
    
    'The math that derived this stuff is pretty messy...  expressions are isolated and put into
    'arrays.  we're essentially trying to find the values of the second derivative of each polynomial
    'at each knot within the curve.  That's why theres only N-2 p's (where N is # points).
    'later, we use the p's and u's to calculate curve points...
    
    '06 May '14 addition: repeat the calculations for all color channels, instead of just luminance...
    For i = 2 To m_numOfNodes(channelID) - 1
        d(i) = 2 * (m_curveNodes(channelID, i + 1).pX - m_curveNodes(channelID, i - 1).pX)
    Next
    For i = 1 To m_numOfNodes(channelID) - 1
        m_u(i) = m_curveNodes(channelID, i + 1).pX - m_curveNodes(channelID, i).pX
    Next
    For i = 2 To m_numOfNodes(channelID) - 1
        w(i) = 6# * ((m_curveNodes(channelID, i + 1).pY - m_curveNodes(channelID, i).pY) / m_u(i) - (m_curveNodes(channelID, i).pY - m_curveNodes(channelID, i - 1).pY) / m_u(i - 1))
    Next
    For i = 2 To m_numOfNodes(channelID) - 2
        w(i + 1) = w(i + 1) - w(i) * m_u(i) / d(i)
        d(i + 1) = d(i + 1) - m_u(i) * m_u(i) / d(i)
    Next
    m_p(1) = 0#
    For i = m_numOfNodes(channelID) - 1 To 2 Step -1
        m_p(i) = (w(i) - m_u(i) * m_p(i + 1)) / d(i)
    Next
    m_p(m_numOfNodes(channelID)) = 0#
            
End Sub

'By default, three points are provided: one at each corner, and one in the middle of the diagonal
Private Sub ResetCurvePoints()

    Dim i As Long, j As Long
    ReDim m_numOfNodes(0 To 3) As Long
    ReDim m_curveNodes(0 To 3, 0 To 512) As fPoint
    
    For i = 0 To 3
        m_numOfNodes(i) = 3
        
        For j = 0 To m_numOfNodes(i)
            m_curveNodes(i, j).pX = (j - 1) * ((picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2) / (m_numOfNodes(i) - 1))
            m_curveNodes(i, j).pY = (picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2) - (m_curveNodes(i, j).pX / (picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2)) * (picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2)
            m_curveNodes(i, j).pX = m_curveNodes(i, j).pX + PREVIEW_BORDER_PX
            m_curveNodes(i, j).pY = m_curveNodes(i, j).pY + PREVIEW_BORDER_PX
        Next j
    
    Next i

End Sub

'Generates a spline from the current set of control points, and fills the results array with the relevant values
Private Sub FillResultsArray()
    
    'Clear the results array and reset the max/min variables
    Dim picWidth As Long
    picWidth = picDraw.ScaleWidth
    
    If (Not VBHacks.IsArrayInitialized(m_CurveResults)) Then ReDim m_CurveResults(0 To 3, -1 To picWidth) As Double
    
    Dim i As Long, j As Long
    For i = 0 To 3
        For j = -1 To picWidth
            m_CurveResults(i, j) = -1
        Next j
    Next i
    
    Dim minX(0 To 3) As Double, maxX(0 To 3) As Double
    
    For i = 0 To 3
        minX(i) = picWidth
        maxX(i) = -1
    Next i
    
    'Now run a loop through the knots, calculating spline values as we go
    Dim xPos As Long, yPos As Single
    
    For i = 0 To 3
    
        ReDim m_p(0 To m_numOfNodes(i)) As Double
        ReDim m_u(0 To m_numOfNodes(i)) As Double
        
        SetPandU i
        
        For j = 1 To m_numOfNodes(i) - 1
            For xPos = m_curveNodes(i, j).pX To m_curveNodes(i, j + 1).pX
                yPos = GetCurvePoint(i, j, xPos)
                If (xPos < minX(i)) Then minX(i) = xPos
                If (xPos > maxX(i)) Then maxX(i) = xPos
                If (yPos > picDraw.ScaleHeight - PREVIEW_BORDER_PX) Then yPos = picDraw.ScaleHeight - PREVIEW_BORDER_PX
                If (yPos < PREVIEW_BORDER_PX) Then yPos = PREVIEW_BORDER_PX
                m_CurveResults(i, xPos) = yPos
            Next xPos
        Next j
        
        'm_CurveResults() now contains the y-coordinate of the spline for every x-coordinate in picDraw that falls between the
        ' initial point and the final point.  Points outside this range are treated as flat lines with values matching
        ' the nearest end point, and we fill those values now.
        For j = PREVIEW_BORDER_PX - 1 To minX(i) - 1
            m_CurveResults(i, j) = m_CurveResults(i, minX(i))
        Next j
                
        For j = picDraw.ScaleWidth - PREVIEW_BORDER_PX To maxX(i) + 1 Step -1
            m_CurveResults(i, j) = m_CurveResults(i, maxX(i))
        Next j
    
    Next i
    
    'm_CurveResults is now complete.  Its primary dimension is the width of the picture box, and each entry in the array
    ' contains the y-value of the spline at that x-position.  This can be used to easily render the spline on-screen,
    ' and also to apply the curve to the image.

End Sub

'If the user changes the position and/or zoom of the preview viewport, the entire preview must be redrawn.
Private Sub pdFxPreview_ViewportChanged()
    UpdatePreview False
End Sub

'Once m_CurveResults has been filled (via FillResultsArray), this function can convert the curve data into
' a list of histogram points, in PD string parameter format.
Private Function GetLocalParamString() As String
    
    Dim cParams As pdSerialize
    Set cParams = New pdSerialize
    
    Dim i As Long, j As Long
    
    'We need to convert curve data from a UI coordinate space (which is how this form stores it), to a universal format
    ' that the actual curve function can understand.
    Dim cEntry As Long
    
    Dim cHistogram() As Double
    ReDim cHistogram(0 To 255) As Double
    
    'Our ultimate goal is a histogram array filled with a list of values in the range [0.0, 1.0].
    ' Note that we must repeat all calculations 4x - once for each channel (red, green, blue, and luminance/RGB).
    For i = 0 To 3
        
        'Convert all curve points for this color, and store the results in our temporary cHistogram() table.
        For j = 0 To 255
            cEntry = PREVIEW_BORDER_PX + (CDbl(j) / 255#) * (picDraw.ScaleWidth - PREVIEW_BORDER_PX * 2#)
            cHistogram(j) = 1# - (m_CurveResults(i, cEntry) - PREVIEW_BORDER_PX) / (picDraw.ScaleHeight - PREVIEW_BORDER_PX * 2#)
        Next j
        
        'Add all the finished values to our curve list
        Dim channelName As String
        If (i = 0) Then
            channelName = "red"
        ElseIf (i = 1) Then
            channelName = "green"
        ElseIf (i = 2) Then
            channelName = "blue"
        ElseIf (i = 3) Then
            channelName = "rgb"
        End If
        
        'We now need to convert the histogram array into a "|"-delimited string that can be passed through the
        ' software processor.  Generate it automatically.
        For j = 0 To 255
            cParams.AddParam channelName & Trim$(Str$(j)), cHistogram(j)
        Next j
        
    Next i
    
    GetLocalParamString = cParams.GetParamString()
    
End Function
