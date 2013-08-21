VERSION 5.00
Begin VB.Form FormReduceColors 
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   " Reduce Image Colors"
   ClientHeight    =   6525
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   12315
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
   ScaleWidth      =   821
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin PhotoDemon.smartCheckBox chkDither 
      Height          =   480
      Left            =   6480
      TabIndex        =   14
      Top             =   4620
      Width           =   1485
      _ExtentX        =   2619
      _ExtentY        =   847
      Caption         =   "use dithering"
      Value           =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin PhotoDemon.smartOptionButton optQuant 
      Height          =   330
      Index           =   0
      Left            =   6120
      TabIndex        =   9
      Top             =   600
      Width           =   2355
      _ExtentX        =   4154
      _ExtentY        =   582
      Caption         =   "Xiaolin Wu (automatic)"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   495
      Left            =   9360
      TabIndex        =   0
      Top             =   5910
      Width           =   1365
   End
   Begin VB.CommandButton CmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   10830
      TabIndex        =   1
      Top             =   5910
      Width           =   1365
   End
   Begin PhotoDemon.fxPreviewCtl fxPreview 
      Height          =   5625
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   5625
      _ExtentX        =   9922
      _ExtentY        =   9922
   End
   Begin PhotoDemon.smartOptionButton optQuant 
      Height          =   330
      Index           =   1
      Left            =   6120
      TabIndex        =   10
      Top             =   960
      Width           =   3630
      _ExtentX        =   6403
      _ExtentY        =   582
      Caption         =   "NeuQuant neural network (automatic)"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin PhotoDemon.smartOptionButton optQuant 
      Height          =   330
      Index           =   2
      Left            =   6120
      TabIndex        =   11
      Top             =   1320
      Width           =   3180
      _ExtentX        =   5609
      _ExtentY        =   582
      Caption         =   "PhotoDemon advanced (manual)"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin PhotoDemon.smartCheckBox chkSmartColors 
      Height          =   480
      Left            =   9000
      TabIndex        =   15
      Top             =   4620
      Width           =   2130
      _ExtentX        =   3757
      _ExtentY        =   847
      Caption         =   "use realistic coloring"
      Value           =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin PhotoDemon.sliderTextCombo sltRed 
      Height          =   495
      Left            =   6120
      TabIndex        =   16
      Top             =   2535
      Width           =   6015
      _ExtentX        =   10610
      _ExtentY        =   873
      Min             =   2
      Max             =   64
      Value           =   6
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin PhotoDemon.sliderTextCombo sltGreen 
      Height          =   495
      Left            =   6120
      TabIndex        =   17
      Top             =   3300
      Width           =   6015
      _ExtentX        =   10610
      _ExtentY        =   873
      Min             =   2
      Max             =   64
      Value           =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin PhotoDemon.sliderTextCombo sltBlue 
      Height          =   495
      Left            =   6120
      TabIndex        =   18
      Top             =   4095
      Width           =   6015
      _ExtentX        =   10610
      _ExtentY        =   873
      Min             =   2
      Max             =   64
      Value           =   6
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label lblBlueValues 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "possible blue values:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   270
      Left            =   6120
      TabIndex        =   13
      Top             =   3795
      Width           =   1980
   End
   Begin VB.Label lblGreenValues 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "possible green values:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   270
      Left            =   6120
      TabIndex        =   12
      Top             =   3000
      Width           =   2145
   End
   Begin VB.Label lblBackground 
      Height          =   855
      Left            =   0
      TabIndex        =   7
      Top             =   5760
      Width           =   12375
   End
   Begin VB.Label lblWarning 
      BackStyle       =   0  'Transparent
      Caption         =   "Note: due to missing plugins, some options on this page have been disabled "
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   1095
      Left            =   10200
      TabIndex        =   6
      Top             =   600
      Visible         =   0   'False
      Width           =   1935
      WordWrap        =   -1  'True
   End
   Begin VB.Label lblQuantizationOptions 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "manual quantization options:"
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
      Height          =   285
      Left            =   6000
      TabIndex        =   5
      Top             =   1800
      Width           =   3090
   End
   Begin VB.Label lblRedValues 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "possible red values:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   270
      Left            =   6120
      TabIndex        =   4
      Top             =   2250
      Width           =   1905
   End
   Begin VB.Label lblMaxColors 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Maximum # of colors with these parameters:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   240
      Left            =   6120
      TabIndex        =   3
      Top             =   5160
      Width           =   3885
   End
   Begin VB.Label lblQuantMethod 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "quantization method:"
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
      Top             =   240
      Width           =   2265
   End
End
Attribute VB_Name = "FormReduceColors"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'Color Reduction Form
'Copyright �2000-2013 by Tanner Helland
'Created: 4/October/00
'Last updated: 28/April/13
'Last update: greatly simplify code by relying on new slider/text custom control
'
'In the original incarnation of PhotoDemon, this was a central part of the project. I have since not used
' it much (since the project has become almost entirely centered around 24/32bpp imaging), but the code
' behind this tool is solid and the feature set is large.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://www.tannerhelland.com/photodemon/#license
'
'***************************************************************************

Option Explicit

'SetDIBitsToDevice is used to interact with the FreeImage DLL
Private Declare Function SetDIBitsToDevice Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal dx As Long, ByVal dy As Long, ByVal srcX As Long, ByVal srcY As Long, ByVal Scan As Long, ByVal NumScans As Long, Bits As Any, BitsInfo As Any, ByVal wUsage As Long) As Long

'Custom tooltip class allows for things like multiline, theming, and multiple monitor support
Dim m_ToolTip As clsToolTip

Private Sub chkDither_Click()
    updateReductionPreview
End Sub

Private Sub chkSmartColors_Click()
    updateReductionPreview
End Sub

'CANCEL button
Private Sub CmdCancel_Click()
    Unload Me
End Sub

'OK button
Private Sub CmdOK_Click()

    'Check to see which method the user has requested
    
    'Xiaolin Wu
    If optQuant(0).Value Then
        FormReduceColors.Visible = False
        Process "Reduce colors", , buildParams(REDUCECOLORS_AUTO, FIQ_WUQUANT)
        Unload Me
    
    'NeuQuant
    ElseIf optQuant(1).Value Then
        FormReduceColors.Visible = False
        Process "Reduce colors", , buildParams(REDUCECOLORS_AUTO, FIQ_NNQUANT)
        Unload Me
    
    'Manual
    Else
    
        'Before reducing anything, check to make sure the textboxes have valid input
        If sltRed.IsValid And sltGreen.IsValid And sltBlue.IsValid Then
            
            Me.Visible = False
        
            'Do the appropriate method of color reduction
            If chkDither.Value = vbUnchecked Then
                Process "Reduce colors", , buildParams(REDUCECOLORS_MANUAL, sltRed, sltGreen, sltBlue, CBool(chkSmartColors.Value))
            Else
                Process "Reduce colors", , buildParams(REDUCECOLORS_MANUAL_ERRORDIFFUSION, sltRed, sltGreen, sltBlue, CBool(chkSmartColors.Value))
            End If
            
            Unload Me
        
        End If
        
    End If
    
End Sub

Private Sub Form_Activate()
    
    'Only allow AutoReduction stuff if the FreeImage dll was found.
    If g_ImageFormats.FreeImageEnabled = False Then
        optQuant(0).Enabled = False
        optQuant(1).Enabled = False
        optQuant(2).Value = True
        DisplayManualOptions True
        lblWarning.Visible = True
    Else
        optQuant(0).Value = True
        DisplayManualOptions False
    End If
        
    'Assign the system hand cursor to all relevant objects
    Set m_ToolTip = New clsToolTip
    makeFormPretty Me, m_ToolTip
    
    'Render a preview
    updateColorLabel
    updateReductionPreview
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseFormTheming Me
End Sub

'Enable/disable the manual settings depending on which option button has been selected
Private Sub OptQuant_Click(Index As Integer)
    DisplayManualOptions optQuant(2).Value
    updateReductionPreview
End Sub

'This lets the user know the max number of colors that the current set of quantization parameters will allow for
Private Sub updateColorLabel()
    If sltRed.IsValid And sltGreen.IsValid And sltBlue.IsValid Then
        lblMaxColors = g_Language.TranslateMessage("Maximum # of colors with these parameters:") & " " & sltRed * sltGreen * sltBlue
        updateReductionPreview
    Else
        lblMaxColors = ""
    End If
End Sub

'Enable/disable the manual options depending on which quantization method has been selected
Private Sub DisplayManualOptions(ByVal toDisplay As Boolean)
    
    If toDisplay Then
        lblQuantizationOptions.ForeColor = &H400000
        lblRedValues.ForeColor = &H400000
        lblGreenValues.ForeColor = &H400000
        lblBlueValues.ForeColor = &H400000
        lblMaxColors.ForeColor = &H400000
    Else
        lblQuantizationOptions.ForeColor = RGB(160, 160, 160)
        lblRedValues.ForeColor = RGB(160, 160, 160)
        lblGreenValues.ForeColor = RGB(160, 160, 160)
        lblBlueValues.ForeColor = RGB(160, 160, 160)
        lblMaxColors.ForeColor = RGB(160, 160, 160)
    End If
    
    sltRed.Enabled = toDisplay
    sltGreen.Enabled = toDisplay
    sltBlue.Enabled = toDisplay
    chkDither.Enabled = toDisplay
    chkSmartColors.Enabled = toDisplay
    
End Sub

'Automatic 8-bit color reduction via the FreeImage DLL.
Public Sub ReduceImageColors_Auto(ByVal qMethod As Long, Optional ByVal toPreview As Boolean = False, Optional ByRef dstPic As fxPreviewCtl)

    'If a selection is active, remove it.  (This is not the most elegant solution, but we can fix it at a later date.)
    If pdImages(CurrentImage).selectionActive Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
    End If

    'If this is a preview, we want to perform the color reduction on a temporary image
    If toPreview Then
        Dim tmpSA As SAFEARRAY2D
        prepImageData tmpSA, toPreview, dstPic
    End If

    'Make sure we found the FreeImage plug-in when the program was loaded
    If g_ImageFormats.FreeImageEnabled Then
    
        'Load the FreeImage dll into memory
        Dim hLib As Long
        hLib = LoadLibrary(g_PluginPath & "FreeImage.dll")
        
        If toPreview = False Then Message "Quantizing image using the FreeImage library..."
        
        'Convert our current layer to a FreeImage-type DIB
        Dim fi_DIB As Long
        
        If toPreview Then
            If workingLayer.getLayerColorDepth = 32 Then workingLayer.compositeBackgroundColor 255, 255, 255
            fi_DIB = FreeImage_CreateFromDC(workingLayer.getLayerDC)
        Else
            If pdImages(CurrentImage).mainLayer.getLayerColorDepth = 32 Then pdImages(CurrentImage).mainLayer.compositeBackgroundColor 255, 255, 255
            fi_DIB = FreeImage_CreateFromDC(pdImages(CurrentImage).mainLayer.getLayerDC)
        End If
        
        'Use that handle to save the image to GIF format, with required 8bpp (256 color) conversion
        If fi_DIB <> 0 Then
            
            Dim returnDIB As Long
            
            returnDIB = FreeImage_ColorQuantizeEx(fi_DIB, qMethod, True)
            
            'If this is a preview, render it to the temporary layer.  Otherwise, use the current main layer.
            If toPreview Then
                workingLayer.createBlank workingLayer.getLayerWidth, workingLayer.getLayerHeight, 24
                SetDIBitsToDevice workingLayer.getLayerDC, 0, 0, workingLayer.getLayerWidth, workingLayer.getLayerHeight, 0, 0, 0, workingLayer.getLayerHeight, ByVal FreeImage_GetBits(returnDIB), ByVal FreeImage_GetInfo(returnDIB), 0&
            Else
                pdImages(CurrentImage).mainLayer.createBlank pdImages(CurrentImage).Width, pdImages(CurrentImage).Height, 24
                SetDIBitsToDevice pdImages(CurrentImage).mainLayer.getLayerDC, 0, 0, pdImages(CurrentImage).Width, pdImages(CurrentImage).Height, 0, 0, 0, pdImages(CurrentImage).Height, ByVal FreeImage_GetBits(returnDIB), ByVal FreeImage_GetInfo(returnDIB), 0&
            End If
            
            'With the transfer complete, release the FreeImage DIB and unload the library
            If returnDIB <> 0 Then FreeImage_UnloadEx returnDIB
            FreeLibrary hLib
     
            'If this is a preview, draw the new image to the picture box and exit.  Otherwise, render the new main image layer.
            If toPreview Then
                finalizeImageData toPreview, dstPic
            Else
                ScrollViewport FormMain.ActiveForm
                Message "Image successfully quantized to %1 unique colors. ", 256
            End If
            
        End If
        
    Else
        pdMsgBox "The FreeImage interface plug-in (FreeImage.dll) was marked as missing or disabled upon program initialization." & vbCrLf & vbCrLf & "To enable support for this feature, please copy the FreeImage.dll file into the plug-in directory and reload the program.", vbExclamation + vbOKOnly + vbApplicationModal, " FreeImage Interface Error"
        Exit Sub
    End If
    
End Sub

'Bit RGB color reduction (no error diffusion)
Public Sub ReduceImageColors_BitRGB(ByVal rValue As Byte, ByVal gValue As Byte, ByVal bValue As Byte, Optional ByVal smartColors As Boolean = False, Optional ByVal toPreview As Boolean = False, Optional ByRef dstPic As fxPreviewCtl)

    If toPreview = False Then Message "Applying manual RGB modifications to image..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    
    prepImageData tmpSA, toPreview, dstPic
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curLayerValues.Left
    initY = curLayerValues.Top
    finalX = curLayerValues.Right
    finalY = curLayerValues.Bottom
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = curLayerValues.BytesPerPixel
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
    
    'Color variables
    Dim r As Long, g As Long, b As Long
    Dim mR As Double, mG As Double, mB As Double
    Dim cR As Long, cG As Long, cb As Long
    
    'New code for so-called "Intelligent Coloring"
    Dim rLookup() As Long
    Dim gLookup() As Long
    Dim bLookup() As Long
    Dim countLookup() As Long
    
    ReDim rLookup(0 To rValue, 0 To gValue, 0 To bValue) As Long
    ReDim gLookup(0 To rValue, 0 To gValue, 0 To bValue) As Long
    ReDim bLookup(0 To rValue, 0 To gValue, 0 To bValue) As Long
    ReDim countLookup(0 To rValue, 0 To gValue, 0 To bValue) As Long
    
    'Prepare inputted variables for the requisite maths
    rValue = rValue - 1
    gValue = gValue - 1
    bValue = bValue - 1
    mR = (256 / rValue)
    mG = (256 / gValue)
    mB = (256 / bValue)
    
    'Finally, prepare conversion look-up tables (which will make the actual color reduction much faster)
    Dim rQuick(0 To 255) As Byte, gQuick(0 To 255) As Byte, bQuick(0 To 255) As Byte
    For x = 0 To 255
        rQuick(x) = Int((x / mR) + 0.5)
        gQuick(x) = Int((x / mG) + 0.5)
        bQuick(x) = Int((x / mB) + 0.5)
    Next x
    
    'Loop through each pixel in the image, converting values as we go
    For x = initX To finalX
        QuickVal = x * qvDepth
    For y = initY To finalY
    
        'Get the source pixel color values
        r = ImageData(QuickVal + 2, y)
        g = ImageData(QuickVal + 1, y)
        b = ImageData(QuickVal, y)
        
        'Truncate R, G, and B values (posterize-style) into discreet increments.  0.5 is added for rounding purposes.
        cR = rQuick(r)
        cG = gQuick(g)
        cb = bQuick(b)
        
        'If we're doing Intelligent Coloring, place color values into a look-up table
        If smartColors = True Then
            rLookup(cR, cG, cb) = rLookup(cR, cG, cb) + r
            gLookup(cR, cG, cb) = gLookup(cR, cG, cb) + g
            bLookup(cR, cG, cb) = bLookup(cR, cG, cb) + b
            'Also, keep track of how many colors fall into this bucket (so we can later determine an average color)
            countLookup(cR, cG, cb) = countLookup(cR, cG, cb) + 1
        End If
        
        'Multiply the now-discretely divided R, G, and B values to (0-255) equivalents
        cR = cR * mR
        cG = cG * mG
        cb = cb * mB
        
        If cR > 255 Then cR = 255
        If cR < 0 Then cR = 0
        If cG > 255 Then cG = 255
        If cG < 0 Then cG = 0
        If cb > 255 Then cb = 255
        If cb < 0 Then cb = 0
        
        'If we are not doing Intelligent Coloring, assign the colors now (to avoid having to do another loop at the end)
        If smartColors = False Then
            ImageData(QuickVal + 2, y) = cR
            ImageData(QuickVal + 1, y) = cG
            ImageData(QuickVal, y) = cb
        End If
        
    Next y
        If toPreview = False Then
            If (x And progBarCheck) = 0 Then
                If userPressedESC() Then Exit For
                SetProgBarVal x
            End If
        End If
    Next x
    
    'Intelligent Coloring requires extra work.  Perform a second loop through the image, replacing values with their
    ' computed counterparts.
    If smartColors And (Not cancelCurrentAction) Then
    
        If Not toPreview Then
            SetProgBarVal getProgBarMax
            Message "Applying intelligent coloring..."
        End If
        
        'Find average colors based on color counts
        For r = 0 To rValue
        For g = 0 To gValue
        For b = 0 To bValue
            If countLookup(r, g, b) <> 0 Then
                rLookup(r, g, b) = Int(Int(rLookup(r, g, b)) / Int(countLookup(r, g, b)))
                gLookup(r, g, b) = Int(Int(gLookup(r, g, b)) / Int(countLookup(r, g, b)))
                bLookup(r, g, b) = Int(Int(bLookup(r, g, b)) / Int(countLookup(r, g, b)))
                If rLookup(r, g, b) > 255 Then rLookup(r, g, b) = 255
                If gLookup(r, g, b) > 255 Then gLookup(r, g, b) = 255
                If bLookup(r, g, b) > 255 Then bLookup(r, g, b) = 255
            End If
        Next b
        Next g
        Next r
        
        'Assign average colors back into the picture
        For x = initX To finalX
            QuickVal = x * qvDepth
        For y = initY To finalY
        
            r = ImageData(QuickVal + 2, y)
            g = ImageData(QuickVal + 1, y)
            b = ImageData(QuickVal, y)
            
            cR = rQuick(r)
            cG = gQuick(g)
            cb = bQuick(b)
            
            ImageData(QuickVal + 2, y) = rLookup(cR, cG, cb)
            ImageData(QuickVal + 1, y) = gLookup(cR, cG, cb)
            ImageData(QuickVal, y) = bLookup(cR, cG, cb)
            
        Next y
        Next x
        
    End If
    
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData toPreview, dstPic
    
End Sub

'Error Diffusion dithering to x# shades of color per component
Public Sub ReduceImageColors_BitRGB_ErrorDif(ByVal rValue As Byte, ByVal gValue As Byte, ByVal bValue As Byte, Optional ByVal smartColors As Boolean = False, Optional ByVal toPreview As Boolean = False, Optional ByRef dstPic As fxPreviewCtl)
    
    If toPreview = False Then Message "Applying manual RGB modifications to image..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    
    prepImageData tmpSA, toPreview, dstPic
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curLayerValues.Left
    initY = curLayerValues.Top
    finalX = curLayerValues.Right
    finalY = curLayerValues.Bottom
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = curLayerValues.BytesPerPixel
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    SetProgBarMax finalY
    progBarCheck = findBestProgBarValue()
    
    'Color variables
    Dim r As Long, g As Long, b As Long
    Dim cR As Long, cG As Long, cb As Long
    Dim iR As Long, iG As Long, iB As Long
    Dim mR As Double, mG As Double, mB As Double
    Dim Er As Double, eG As Double, eB As Double
    
    'New code for so-called "Intelligent Coloring"
    Dim rLookup() As Long
    Dim gLookup() As Long
    Dim bLookup() As Long
    Dim countLookup() As Long
    
    ReDim rLookup(0 To rValue, 0 To gValue, 0 To bValue) As Long
    ReDim gLookup(0 To rValue, 0 To gValue, 0 To bValue) As Long
    ReDim bLookup(0 To rValue, 0 To gValue, 0 To bValue) As Long
    ReDim countLookup(0 To rValue, 0 To gValue, 0 To bValue) As Long
    
    'Prepare inputted variables for the requisite maths
    rValue = rValue - 1
    gValue = gValue - 1
    bValue = bValue - 1
    mR = (256 / rValue)
    mG = (256 / gValue)
    mB = (256 / bValue)
    
    'Finally, prepare conversion look-up tables (which will make the actual color reduction much faster)
    Dim rQuick(0 To 255) As Byte, gQuick(0 To 255) As Byte, bQuick(0 To 255) As Byte
    For x = 0 To 255
        rQuick(x) = Int((x / mR) + 0.5)
        gQuick(x) = Int((x / mG) + 0.5)
        bQuick(x) = Int((x / mB) + 0.5)
    Next x
    
    'Loop through each pixel in the image, converting values as we go
    For y = initY To finalY
    For x = initX To finalX
        
        QuickVal = x * qvDepth
    
        'Get the source pixel color values
        iR = ImageData(QuickVal + 2, y)
        iG = ImageData(QuickVal + 1, y)
        iB = ImageData(QuickVal, y)
        
        r = iR + Er
        g = iG + eG
        b = iB + eB
        
        If r > 255 Then r = 255
        If g > 255 Then g = 255
        If b > 255 Then b = 255
        If r < 0 Then r = 0
        If g < 0 Then g = 0
        If b < 0 Then b = 0
        
        'Truncate R, G, and B values (posterize-style) into discreet increments.  0.5 is added for rounding purposes.
        cR = rQuick(r)
        cG = gQuick(g)
        cb = bQuick(b)
        
        'If we're doing Intelligent Coloring, place color values into a look-up table
        If smartColors = True Then
            rLookup(cR, cG, cb) = rLookup(cR, cG, cb) + r
            gLookup(cR, cG, cb) = gLookup(cR, cG, cb) + g
            bLookup(cR, cG, cb) = bLookup(cR, cG, cb) + b
            'Also, keep track of how many colors fall into this bucket (so we can later determine an average color)
            countLookup(cR, cG, cb) = countLookup(cR, cG, cb) + 1
        End If
        
        'Multiply the now-discretely divided R, G, and B values to (0-255) equivalents
        cR = cR * mR
        cG = cG * mG
        cb = cb * mB
        
        'Calculate error
        Er = iR - cR
        eG = iG - cG
        eB = iB - cb
        
        'Diffuse the error further (in a grid pattern) to prevent undesirable lining effects
        If (x + y) And 3 <> 0 Then
            Er = Er \ 2
            eG = eG \ 2
            eB = eB \ 2
        End If
        
        If cR > 255 Then cR = 255
        If cR < 0 Then cR = 0
        If cG > 255 Then cG = 255
        If cG < 0 Then cG = 0
        If cb > 255 Then cb = 255
        If cb < 0 Then cb = 0
        
        'If we are not doing Intelligent Coloring, assign the colors now (to avoid having to do another loop at the end)
        If Not smartColors Then
            ImageData(QuickVal + 2, y) = cR
            ImageData(QuickVal + 1, y) = cG
            ImageData(QuickVal, y) = cb
        End If
        
    Next x
        
        'At the end of each line, reset our error-tracking values
        Er = 0
        eG = 0
        eB = 0
        
        If toPreview = False Then
            If (y And progBarCheck) = 0 Then
                If userPressedESC() Then Exit For
                SetProgBarVal y
            End If
        End If
    Next y
    
    'Intelligent Coloring requires extra work.  Perform a second loop through the image, replacing values with their
    ' computed counterparts.
    If smartColors And (Not cancelCurrentAction) Then
        
        If Not toPreview Then
            SetProgBarVal getProgBarMax
            Message "Applying intelligent coloring..."
        End If
        
        'Find average colors based on color counts
        For r = 0 To rValue
        For g = 0 To gValue
        For b = 0 To bValue
            If countLookup(r, g, b) <> 0 Then
                rLookup(r, g, b) = Int(Int(rLookup(r, g, b)) / Int(countLookup(r, g, b)))
                gLookup(r, g, b) = Int(Int(gLookup(r, g, b)) / Int(countLookup(r, g, b)))
                bLookup(r, g, b) = Int(Int(bLookup(r, g, b)) / Int(countLookup(r, g, b)))
                If rLookup(r, g, b) > 255 Then rLookup(r, g, b) = 255
                If gLookup(r, g, b) > 255 Then gLookup(r, g, b) = 255
                If bLookup(r, g, b) > 255 Then bLookup(r, g, b) = 255
            End If
        Next b
        Next g
        Next r
        
        'Assign average colors back into the picture
        For y = initY To finalY
        For x = initX To finalX
            
            QuickVal = x * qvDepth
        
            iR = ImageData(QuickVal + 2, y)
            iG = ImageData(QuickVal + 1, y)
            iB = ImageData(QuickVal, y)
            
            r = iR + Er
            g = iG + eG
            b = iB + eB
            
            If r > 255 Then r = 255
            If g > 255 Then g = 255
            If b > 255 Then b = 255
            If r < 0 Then r = 0
            If g < 0 Then g = 0
            If b < 0 Then b = 0
            
            cR = rQuick(r)
            cG = gQuick(g)
            cb = bQuick(b)
            
            ImageData(QuickVal + 2, y) = rLookup(cR, cG, cb)
            ImageData(QuickVal + 1, y) = gLookup(cR, cG, cb)
            ImageData(QuickVal, y) = bLookup(cR, cG, cb)
            
            'Calculate the error for this pixel
            cR = cR * mR
            cG = cG * mG
            cb = cb * mB
        
            Er = iR - cR
            eG = iG - cG
            eB = iB - cb
            
            'Diffuse the error further (in a grid pattern) to prevent undesirable lining effects
            If (x + y) And 3 <> 0 Then
                Er = Er \ 2
                eG = eG \ 2
                eB = eB \ 2
            End If
            
        Next x
        
            'At the end of each line, reset our error-tracking values
            Er = 0
            eG = 0
            eB = 0
        
        Next y
        
    End If
    
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData toPreview, dstPic
    
End Sub

Private Sub sltBlue_Change()
    updateColorLabel
End Sub

Private Sub sltGreen_Change()
    updateColorLabel
End Sub

Private Sub sltRed_Change()
    updateColorLabel
End Sub

'Use this sub to update the on-screen preview
Private Sub updateReductionPreview()
    If optQuant(0).Value = True Then
        ReduceImageColors_Auto FIQ_WUQUANT, True, fxPreview
    ElseIf optQuant(1).Value = True Then
        ReduceImageColors_Auto FIQ_NNQUANT, True, fxPreview
    Else
        If sltRed.IsValid And sltGreen.IsValid And sltBlue.IsValid Then
            If chkDither.Value = vbUnchecked Then
                ReduceImageColors_BitRGB sltRed, sltGreen, sltBlue, CBool(chkSmartColors.Value), True, fxPreview
            Else
                ReduceImageColors_BitRGB_ErrorDif sltRed, sltGreen, sltBlue, CBool(chkSmartColors.Value), True, fxPreview
            End If
        End If
    End If
End Sub
