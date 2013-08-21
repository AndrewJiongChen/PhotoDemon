VERSION 5.00
Begin VB.Form FormTile 
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   " Tile Image"
   ClientHeight    =   6525
   ClientLeft      =   -15
   ClientTop       =   225
   ClientWidth     =   11595
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
   ScaleHeight     =   435
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   773
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   495
      Left            =   8640
      TabIndex        =   0
      Top             =   5910
      Width           =   1365
   End
   Begin VB.CommandButton CmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   10110
      TabIndex        =   1
      Top             =   5910
      Width           =   1365
   End
   Begin VB.TextBox TxtWidth 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800000&
      Height          =   360
      Left            =   6720
      TabIndex        =   7
      Text            =   "N/A"
      Top             =   2940
      Width           =   855
   End
   Begin VB.TextBox TxtHeight 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800000&
      Height          =   360
      Left            =   9600
      TabIndex        =   6
      Text            =   "N/A"
      Top             =   2940
      Width           =   855
   End
   Begin VB.VScrollBar VSWidth 
      Height          =   420
      Left            =   7590
      Max             =   32766
      Min             =   1
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   2880
      Value           =   15000
      Width           =   270
   End
   Begin VB.VScrollBar VSHeight 
      Height          =   420
      Left            =   10470
      Max             =   32766
      Min             =   1
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   2880
      Value           =   15000
      Width           =   270
   End
   Begin VB.ComboBox cboTarget 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800000&
      Height          =   360
      Left            =   6240
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   2280
      Width           =   5175
   End
   Begin PhotoDemon.fxPreviewCtl fxPreview 
      Height          =   5625
      Left            =   120
      TabIndex        =   14
      Top             =   120
      Width           =   5625
      _ExtentX        =   9922
      _ExtentY        =   9922
   End
   Begin VB.Label lblBackground 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   0
      TabIndex        =   13
      Top             =   5760
      Width           =   11655
   End
   Begin VB.Label lblDescription 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "The final image will be %1 %3 wide by %2 %3 tall."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   1155
      Left            =   6000
      TabIndex        =   12
      Top             =   3720
      Width           =   5355
      WordWrap        =   -1  'True
   End
   Begin VB.Label lblWidth 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "width:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00400000&
      Height          =   210
      Left            =   6120
      TabIndex        =   11
      Top             =   2985
      Width           =   525
   End
   Begin VB.Label lblHeight 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "height:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00400000&
      Height          =   210
      Left            =   8880
      TabIndex        =   10
      Top             =   2985
      Width           =   585
   End
   Begin VB.Label lblWidthType 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "pixels"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00400000&
      Height          =   210
      Left            =   8010
      TabIndex        =   9
      Top             =   2985
      Width           =   435
   End
   Begin VB.Label lblHeightType 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "pixels"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00400000&
      Height          =   210
      Left            =   10890
      TabIndex        =   8
      Top             =   2985
      Width           =   435
   End
   Begin VB.Label lblAmount 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "render tiled image using:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   405
      Left            =   6000
      TabIndex        =   2
      Top             =   1920
      Width           =   2670
   End
End
Attribute VB_Name = "FormTile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'Tile Rendering Interface
'Copyright �2000-2013 by Tanner Helland
'Created: 25/August/12
'Last updated: 09/September/12
'Last update: rewrote against new layer class.  The tile generation is now much MUCH faster, especially for egregiously large
'              tile sizes.
'
'Render tiled images.  Options are provided for rendering to current wallpaper size, or to a custom size.
' The interface for custom sizes is derived from the Image Size form; ideally, any changes to that
' should be mirrored here.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://www.tannerhelland.com/photodemon/#license
'
'***************************************************************************

Option Explicit

'Used to prevent the scroll bars from getting stuck in update loops
Dim updateWidthBar As Boolean, updateHeightBar As Boolean

'Track the last type of option used; we use this to convert the text box values intelligently
Dim lastTargetMode As Long

'We only want the preview redrawn at certain times; this is used to limit it
Dim redrawPreview As Boolean

'Custom tooltip class allows for things like multiline, theming, and multiple monitor support
Dim m_ToolTip As clsToolTip

'When the combo box is changed, make the appropriate controls visible
Private Sub cboTarget_Click()

    'Suppress previewing while all the variables get set to their proper values
    redrawPreview = False

    Dim iWidth As Long, iHeight As Long
    iWidth = pdImages(CurrentImage).Width
    iHeight = pdImages(CurrentImage).Height

    Select Case cboTarget.ListIndex
        'Wallpaper size
        Case 0
            
            'Determine the current screen size, in pixels; this is used to provide a "render to screen size" option
            Dim cScreenWidth As Long, cScreenHeight As Long
            cScreenWidth = Screen.Width / Screen.TwipsPerPixelX
            cScreenHeight = Screen.Height / Screen.TwipsPerPixelY
            
            'Add one to the displayed width and height, since we store them -1 for loops
            TxtWidth.Text = cScreenWidth
            TxtHeight.Text = cScreenHeight
            
            TxtWidth.Enabled = False
            TxtHeight.Enabled = False
            VSWidth.Enabled = False
            VSHeight.Enabled = False
            lblWidthType = "pixels"
            lblHeightType = "pixels"
        
        'Custom size (in pixels)
        Case 1
            TxtWidth.Enabled = True
            TxtHeight.Enabled = True
            VSWidth.Enabled = True
            VSHeight.Enabled = True
            lblWidthType = "pixels"
            lblHeightType = "pixels"
            
            'If the user was previously measuring in tiles, convert that value to pixels
            If (lastTargetMode = 2) And (NumberValid(TxtWidth)) And (NumberValid(TxtHeight)) Then
                TxtWidth = CLng(TxtWidth) * iWidth
                TxtHeight = CLng(TxtHeight) * iHeight
            End If
            
        'Custom size (as number of tiles)
        Case 2
            TxtWidth.Enabled = True
            TxtHeight.Enabled = True
            VSWidth.Enabled = True
            VSHeight.Enabled = True
            lblWidthType = "tiles"
            lblHeightType = "tiles"
            
            'Since the user will have previously been measuring in pixels, convert that value to tiles
            If NumberValid(TxtWidth) And NumberValid(TxtHeight) Then
                Dim xTiles As Long, yTiles As Long
                xTiles = CLng(CSng(TxtWidth) / CSng(iWidth))
                yTiles = CLng(CSng(TxtHeight) / CSng(iHeight))
                If xTiles < 1 Then xTiles = 1
                If yTiles < 1 Then yTiles = 1
                TxtWidth = xTiles
                TxtHeight = yTiles
            End If
    End Select
    
    'Remember this value for future conversions
    lastTargetMode = cboTarget.ListIndex

    'Re-enable previewing
    redrawPreview = True

    'Finally, draw a preview
    If EntryValid(TxtWidth, 1, 32767, False, False) And EntryValid(TxtHeight, 1, 32767, False, False) Then
        updateDescription
        GenerateTile cboTarget.ListIndex, TxtWidth, TxtHeight, True
    End If

End Sub

'CANCEL button
Private Sub CmdCancel_Click()
    Unload Me
End Sub

'OK button
Private Sub CmdOK_Click()

    'Before rendering anything, check to make sure the text boxes have valid input
    If Not EntryValid(TxtWidth, 1, 32767, True, True) Then
        AutoSelectText TxtWidth
        Exit Sub
    End If
    If Not EntryValid(TxtHeight, 1, 32767, True, True) Then
        AutoSelectText TxtHeight
        Exit Sub
    End If

    Me.Visible = False
    
    'Based on the user's selection, submit the proper processor request
    Process "Tile", , buildParams(cboTarget.ListIndex, TxtWidth, TxtHeight)
    
    Unload Me
    
End Sub

'This routine renders the current image to a new, tiled image (larger than the present image)
' tType is the parameter used for determining how many tiles to draw:
' 0 - current wallpaper size
' 1 - custom size, in pixels
' 2 - custom size, as number of tiles
' The other two parameters are width and height, or tiles in x and y direction
Public Sub GenerateTile(ByVal tType As Byte, Optional xTarget As Long, Optional yTarget As Long, Optional ByVal isPreview As Boolean = False)
        
    'If a selection is active, remove it.  (This is not the most elegant solution, but we can fix it at a later date.)
    If pdImages(CurrentImage).selectionActive Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
    End If
    
    If isPreview = False Then Message "Rendering tiled image..."
    
    'Create a temporary layer to generate the tile and/or tile preview
    Dim tmpLayer As pdLayer
    Set tmpLayer = New pdLayer
        
    'We need to determine a target width and height based on the input parameters
    Dim targetWidth As Long, targetHeight As Long
    
    Dim iWidth As Long, iHeight As Long
    iWidth = pdImages(CurrentImage).Width
    iHeight = pdImages(CurrentImage).Height
        
    Select Case tType
        Case 0
            'Current wallpaper size
            targetWidth = Screen.Width / Screen.TwipsPerPixelX
            targetHeight = Screen.Height / Screen.TwipsPerPixelY
        Case 1
            'Custom size
            targetWidth = xTarget
            targetHeight = yTarget
        Case 2
            'Specific number of tiles; determine the target size in pixels, accordingly
            targetWidth = (iWidth * xTarget)
            targetHeight = (iHeight * yTarget)
    End Select
    
    'Make sure the target width/height isn't too large.  (This limit could be set bigger... I haven't actually tested it to
    ' find a max upper limit.  I'm fairly certain it's only limited by available memory.)
    Dim MaxSize As Long
    MaxSize = 32767
    
    If targetWidth > MaxSize Then targetWidth = MaxSize
    If targetHeight > MaxSize Then targetHeight = MaxSize
    
    'Resize the target picture box to this new size
    tmpLayer.createBlank targetWidth, targetHeight, pdImages(CurrentImage).mainLayer.getLayerColorDepth
        
    'Figure out how many loop intervals we'll need in the x and y direction to fill the target size
    Dim xLoop As Long, yLoop As Long
    xLoop = CLng(CSng(targetWidth) / CSng(iWidth))
    yLoop = CLng(CSng(targetHeight) / CSng(iHeight))
    
    If isPreview = False Then SetProgBarMax xLoop
    
    'Using that loop variable, render the original image to the target picture box that many times
    Dim x As Long, y As Long
    
    For x = 0 To xLoop
    For y = 0 To yLoop
        BitBlt tmpLayer.getLayerDC, x * iWidth, y * iHeight, iWidth, iHeight, pdImages(CurrentImage).mainLayer.getLayerDC, 0, 0, vbSrcCopy
    Next y
        If isPreview = False Then SetProgBarVal x
    Next x
    
    If Not isPreview Then
    
        SetProgBarVal xLoop
    
        'With the tiling complete, copy the temporary layer over the existing layer
        pdImages(CurrentImage).mainLayer.createFromExistingLayer tmpLayer
        
        'Erase the temporary layer to save on memory
        tmpLayer.eraseLayer
        Set tmpLayer = Nothing
        
        'Display the new size
        pdImages(CurrentImage).updateSize
        DisplaySize pdImages(CurrentImage).Width, pdImages(CurrentImage).Height
        
        SetProgBarVal 0
        
        'Render the image on-screen at an automatically corrected zoom
        FitOnScreen
    
        Message "Finished."
        
    Else
    
        'Render the preview and erase the temporary layer to conserve memory
        tmpLayer.renderToPictureBox fxPreview.getPreviewPic
        fxPreview.setFXImage tmpLayer
        
        tmpLayer.eraseLayer
        Set tmpLayer = Nothing
        
    End If

End Sub

Private Sub Form_Activate()
        
    'Populate the combo box
    cboTarget.AddItem "Current screen size", 0
    cboTarget.AddItem "Custom image size (in pixels)", 1
    cboTarget.AddItem "Specific number of tiles", 2
    cboTarget.ListIndex = 0
    'DoEvents
    
    'Give the preview object a copy of this image data so it can show it to the user if requested
    fxPreview.setOriginalImage pdImages(CurrentImage).mainLayer
    
    'Render a preview
    redrawPreview = True
    GenerateTile cboTarget.ListIndex, TxtWidth, TxtHeight, True
    
    'Allow updating via scroll bars (which are masquerading as up/down controls)
    updateWidthBar = True
    updateHeightBar = True
    
    'Assign the system hand cursor to all relevant objects
    Set m_ToolTip = New clsToolTip
    makeFormPretty Me, m_ToolTip
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseFormTheming Me
End Sub

'When the text boxes are changed, keep the scroll bar values in sync
Private Sub TxtHeight_Change()
    textValidate TxtHeight
    If EntryValid(TxtHeight, 1, 32767, False, True) Then
        updateHeightBar = False
        VSHeight.Value = Abs(32767 - CInt(TxtHeight))
        updateHeightBar = True
        If EntryValid(TxtWidth, 1, 32767, False, False) And EntryValid(TxtHeight, 1, 32767, False, False) And redrawPreview Then
            updateDescription
            GenerateTile cboTarget.ListIndex, TxtWidth, TxtHeight, True
        End If
    Else
        AutoSelectText TxtHeight
    End If
End Sub

Private Sub txtHeight_GotFocus()
    AutoSelectText TxtHeight
End Sub

Private Sub txtWidth_Change()
    textValidate TxtWidth
    If EntryValid(TxtWidth, 1, 32767, False, True) Then
        updateWidthBar = False
        VSWidth.Value = Abs(32767 - CInt(TxtWidth))
        updateWidthBar = True
        If EntryValid(TxtWidth, 1, 32767, False, False) And EntryValid(TxtHeight, 1, 32767, False, False) And redrawPreview Then
            updateDescription
            GenerateTile cboTarget.ListIndex, TxtWidth, TxtHeight, True
        End If
    Else
        AutoSelectText TxtWidth
    End If
End Sub

Private Sub txtWidth_GotFocus()
    AutoSelectText TxtWidth
End Sub

'When the scroll bars are changed, keep the text box values in sync
Private Sub VSHeight_Change()
    If updateHeightBar = True Then TxtHeight = Abs(32767 - CStr(VSHeight.Value))
End Sub

Private Sub VSWidth_Change()
    If updateWidthBar = True Then TxtWidth = Abs(32767 - CStr(VSWidth.Value))
End Sub

'Show the user a description of how large the new, tiled image will be
Private Sub updateDescription()

    Dim iWidth As Long, iHeight As Long
    
    iWidth = pdImages(CurrentImage).Width
    iHeight = pdImages(CurrentImage).Height

    Dim xVal As Double, yVal As Double
    Dim xText As String, yText As String
    
    Dim metricText As String
    
    'Generate a descriptive string based on which tiling method will be used
    Select Case cboTarget.ListIndex
        
        'Wallpaper size
        Case 0
            xVal = TxtWidth / iWidth
            yVal = TxtHeight / iHeight
            xText = Format(xVal, "#####.0")
            yText = Format(yVal, "#####.0")
            metricText = g_Language.TranslateMessage("tiles")
            
        'Custom size (in pixels)
        Case 1
            xVal = TxtWidth / iWidth
            yVal = TxtHeight / iHeight
            xText = Format(xVal, "#####.0")
            yText = Format(yVal, "#####.0")
            metricText = g_Language.TranslateMessage("tiles")
            
        'Custom size (in tiles)
        Case 2
            xVal = TxtWidth * iWidth
            yVal = TxtHeight * iHeight
            xText = Format(xVal, "#####")
            yText = Format(yVal, "#####")
            metricText = g_Language.TranslateMessage("pixels")
            
    End Select
    
    lblDescription = g_Language.TranslateMessage("The final image will be %1 %3 wide by %2 %3 tall.", xText, yText, metricText)

End Sub
