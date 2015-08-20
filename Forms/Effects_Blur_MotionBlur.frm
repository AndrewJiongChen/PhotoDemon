VERSION 5.00
Begin VB.Form FormMotionBlur 
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   " Motion blur"
   ClientHeight    =   6540
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   12030
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
   ScaleHeight     =   436
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   802
   ShowInTaskbar   =   0   'False
   Begin PhotoDemon.commandBar cmdBar 
      Align           =   2  'Align Bottom
      Height          =   750
      Left            =   0
      TabIndex        =   0
      Top             =   5790
      Width           =   12030
      _ExtentX        =   21220
      _ExtentY        =   1323
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
   Begin PhotoDemon.fxPreviewCtl fxPreview 
      Height          =   5625
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   5625
      _ExtentX        =   9922
      _ExtentY        =   9922
   End
   Begin PhotoDemon.sliderTextCombo sltAngle 
      Height          =   495
      Left            =   6000
      TabIndex        =   4
      Top             =   1440
      Width           =   5895
      _ExtentX        =   10398
      _ExtentY        =   873
      Max             =   359.9
      SigDigits       =   1
   End
   Begin PhotoDemon.smartOptionButton OptInterpolate 
      Height          =   360
      Index           =   0
      Left            =   6120
      TabIndex        =   5
      Top             =   3990
      Width           =   5700
      _ExtentX        =   10054
      _ExtentY        =   635
      Caption         =   "quality"
      Value           =   -1  'True
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin PhotoDemon.smartOptionButton OptInterpolate 
      Height          =   360
      Index           =   1
      Left            =   6120
      TabIndex        =   6
      Top             =   4410
      Width           =   5700
      _ExtentX        =   10054
      _ExtentY        =   635
      Caption         =   "speed"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin PhotoDemon.smartCheckBox chkSymmetry 
      Height          =   300
      Left            =   6120
      TabIndex        =   8
      Top             =   3000
      Width           =   5655
      _ExtentX        =   3413
      _ExtentY        =   582
      Caption         =   "blur symmetrically"
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
   Begin PhotoDemon.sliderTextCombo sltDistance 
      Height          =   495
      Left            =   6000
      TabIndex        =   10
      Top             =   2400
      Width           =   5895
      _ExtentX        =   10398
      _ExtentY        =   873
      Min             =   1
      Max             =   500
      Value           =   5
   End
   Begin VB.Label lblTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "distance:"
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
      Index           =   2
      Left            =   6000
      TabIndex        =   9
      Top             =   2040
      Width           =   945
   End
   Begin VB.Label lblTitle 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "render emphasis:"
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
      Index           =   1
      Left            =   6000
      TabIndex        =   7
      Top             =   3600
      Width           =   1845
   End
   Begin VB.Label lblIDEWarning 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   1215
      Left            =   6000
      TabIndex        =   3
      Top             =   4680
      Visible         =   0   'False
      Width           =   5775
      WordWrap        =   -1  'True
   End
   Begin VB.Label lblTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "angle:"
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
      Index           =   0
      Left            =   6000
      TabIndex        =   1
      Top             =   1080
      Width           =   660
   End
End
Attribute VB_Name = "FormMotionBlur"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'Motion Blur Tool
'Copyright 2013-2015 by Tanner Helland
'Created: 26/August/13
'Last updated: 26/August/13
'Last update: initial build
'
'To my knowledge, this tool is the first of its kind in VB6 - a motion blur tool that supports variable angle
' and strength, while still capable of operating in real-time.  This function is mostly just a wrapper to PD's
' horizontal blur and rotate functions; they do all the heavy lifting, as you can see from the code below.
'
'Performance is pretty good, all things considered, but be careful in the IDE.  I STRONGLY recommend compiling
' the project before applying any actions at a large radius.
'
'If FreeImage is available, it is used to estimate a new size for the rotated image.  This is not the best way
' to estimate that value, but it's easier than doing the trig by hand, and FreeImage's rotate is *very* fast.  :)
'
'All source code in this file is licensed under a modified BSD license. This means you may use the code in your own
' projects IF you provide attribution. For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'Custom tooltip class allows for things like multiline, theming, and multiple monitor support
Dim m_ToolTip As clsToolTip

'Apply motion blur to an image
'Inputs: angle of the blur, distance of the blur
Public Sub MotionBlurFilter(ByVal bAngle As Double, ByVal bDistance As Long, ByVal blurSymmetrically As Boolean, ByVal useBilinear As Boolean, Optional ByVal toPreview As Boolean = False, Optional ByRef dstPic As fxPreviewCtl)
    
    If Not toPreview Then Message "Applying motion blur..."
    
    'Call prepImageData, which will initialize a workingDIB object for us (with all selection tool masks applied)
    Dim dstSA As SAFEARRAY2D
    prepImageData dstSA, toPreview, dstPic
    
    'If this is a preview, we need to adjust the kernel radius to match the size of the preview box
    If toPreview Then
        bDistance = bDistance * curDIBValues.previewModifier
        If bDistance = 0 Then bDistance = 1
    End If
    
    Dim finalX As Long, finalY As Long
    finalX = workingDIB.getDIBWidth
    finalY = workingDIB.getDIBHeight
    
    'Before doing any rotating or blurring, we need to increase the size of the image we're working with.  If we
    ' don't do this, intermediate rotation actions will chop off the image's corners, and the resulting effect
    ' will look terrible.
    Dim hScaleAmount As Long, vScaleAmount As Long
    Dim nWidth As Double, nHeight As Double
    Math_Functions.findBoundarySizeOfRotatedRect finalX, finalY, bAngle, nWidth, nHeight
        
    'Use the rotated size to calculate optimal padding amounts
    hScaleAmount = (nWidth - finalX) \ 2
    vScaleAmount = (nHeight - finalY) \ 2
    
    If hScaleAmount < 0 Then hScaleAmount = 0
    If vScaleAmount < 0 Then vScaleAmount = 0
    
    'I built a separate function to enlarge the image and fill the blank borders with clamped pixels from the source image:
    Dim tmpClampDIB As pdDIB
    Set tmpClampDIB = New pdDIB
    padDIBClampedPixels hScaleAmount, vScaleAmount, workingDIB, tmpClampDIB
    
    'Create a second DIB, which will receive the results of this one
    Dim rotateDIB As pdDIB
    Set rotateDIB = New pdDIB
    
    'PD has a number of different rotation engines available.
    
    'GDI+ code:
    'rotateDIB.createBlank tmpClampDIB.getDIBWidth, tmpClampDIB.getDIBHeight, tmpClampDIB.getDIBColorDepth, 0, 255
    'GDIPlusRotateDIB rotateDIB, 0, 0, rotateDIB.getDIBWidth, rotateDIB.getDIBHeight, tmpClampDIB, 0, 0, tmpClampDIB.getDIBWidth, tmpClampDIB.getDIBHeight, -bAngle, InterpolationModeHighQualityBicubic, WrapModeClamp
    
    'FreeImage code:
    'Plugin_FreeImage_Expanded_Interface.FreeImageRotateDIBFast tmpClampDIB, rotateDIB, -bAngle, False, False
    
    'Internal pure-VB code:
    ' I have chosen to go with this mode for motion blur, because our custom clamping code ensures that no dead pixels
    ' are introduced prior to the blur function, below.
    rotateDIB.createBlank tmpClampDIB.getDIBWidth, tmpClampDIB.getDIBHeight, tmpClampDIB.getDIBColorDepth, 0, 255
    CreateRotatedDIB bAngle, EDGE_CLAMP, True, tmpClampDIB, rotateDIB, 0.5, 0.5, toPreview, tmpClampDIB.getDIBWidth * 3
    
    'Next, apply a horizontal blur, using the blur radius supplied by the user
    Dim rightRadius As Long
    If blurSymmetrically Then rightRadius = bDistance Else rightRadius = 0
        
    If CreateHorizontalBlurDIB(bDistance, rightRadius, rotateDIB, tmpClampDIB, toPreview, tmpClampDIB.getDIBWidth * 3, tmpClampDIB.getDIBWidth) Then
            
        'Finally, rotate the image back to its original orientation, using the opposite parameters of the first conversion.
        ' As before, multiple rotation engines could be used, but GDI+ is presently fastest, and as we don't care about distortion
        ' (because we will manually be cropping out the relevant rect from the center), there is no penalty to using it:
        
        'GDI+ code:
        GDI_Plus.GDIPlusFillDIBRect rotateDIB, 0, 0, rotateDIB.getDIBWidth, rotateDIB.getDIBHeight, 0, 255
        GDIPlusRotateDIB rotateDIB, 0, 0, rotateDIB.getDIBWidth, rotateDIB.getDIBHeight, tmpClampDIB, 0, 0, tmpClampDIB.getDIBWidth, tmpClampDIB.getDIBHeight, bAngle, InterpolationModeHighQualityBicubic, WrapModeClamp
        
        'FreeImage code:
        'Plugin_FreeImage_Expanded_Interface.FreeImageRotateDIBFast tmpClampDIB, rotateDIB, bAngle, False, False
        
        'Internal pure-VB code:
        'GDI_Plus.GDIPlusFillDIBRect rotateDIB, 0, 0, rotateDIB.getDIBWidth, rotateDIB.getDIBHeight, 0, 255
        'CreateRotatedDIB -bAngle, EDGE_CLAMP, True, tmpClampDIB, rotateDIB, 0.5, 0.5, toPreview, tmpClampDIB.getDIBWidth * 3, tmpClampDIB.getDIBWidth * 2
        
        'Erase the temporary clamp DIB
        tmpClampDIB.eraseDIB
        Set tmpClampDIB = Nothing
        
        'rotateDIB now contains the image we want, but it also has all the (now-useless) padding from
        ' the rotate operation.  Chop out the valid section and copy it into workingDIB.
        BitBlt workingDIB.getDIBDC, 0, 0, workingDIB.getDIBWidth, workingDIB.getDIBHeight, rotateDIB.getDIBDC, hScaleAmount, vScaleAmount, vbSrcCopy
        
    End If
    
    'Erase the temporary rotation DIB
    rotateDIB.eraseDIB
    Set rotateDIB = Nothing
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering using the data inside workingDIB
    finalizeImageData toPreview, dstPic
    
End Sub

Private Sub chkSymmetry_Click()
    updatePreview
End Sub

Private Sub cmdBar_OKClick()
    Process "Motion blur", , buildParams(sltAngle, sltDistance, CBool(chkSymmetry), OptInterpolate(0)), UNDO_LAYER
End Sub

Private Sub cmdBar_RequestPreviewUpdate()
    updatePreview
End Sub

Private Sub Form_Activate()

    'Assign the system hand cursor to all relevant objects
    Set m_ToolTip = New clsToolTip
    makeFormPretty Me, m_ToolTip
    
    'If the program is not compiled, display a special warning for this tool
    If Not g_IsProgramCompiled Then
        lblIDEWarning.Caption = g_Language.TranslateMessage("WARNING! This tool is very slow when used inside the IDE. Please compile for best results.")
        lblIDEWarning.Visible = True
    End If
    
    'Draw a preview of the effect
    cmdBar.markPreviewStatus True
    updatePreview
    
End Sub

Private Sub Form_Load()
    
    'Disable previews until the form is fully initialized
    cmdBar.markPreviewStatus False
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseFormTheming Me
End Sub

Private Sub OptInterpolate_Click(Index As Integer)
    updatePreview
End Sub

'Render a new effect preview
Private Sub updatePreview()
    If cmdBar.previewsAllowed Then MotionBlurFilter sltAngle, sltDistance, CBool(chkSymmetry), OptInterpolate(0), True, fxPreview
End Sub

Private Sub sltAngle_Change()
    updatePreview
End Sub

Private Sub sltDistance_Change()
    updatePreview
End Sub

'If the user changes the position and/or zoom of the preview viewport, the entire preview must be redrawn.
Private Sub fxPreview_ViewportChanged()
    updatePreview
End Sub

