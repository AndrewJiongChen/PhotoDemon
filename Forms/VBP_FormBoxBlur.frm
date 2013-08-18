VERSION 5.00
Begin VB.Form FormBoxBlur 
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   " Box Blur"
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
   StartUpPosition =   1  'CenterOwner
   Begin PhotoDemon.sliderTextCombo sltWidth 
      Height          =   495
      Left            =   6000
      TabIndex        =   5
      Top             =   2280
      Width           =   5895
      _ExtentX        =   10398
      _ExtentY        =   873
      Min             =   1
      Max             =   500
      Value           =   2
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
      TabIndex        =   0
      Top             =   120
      Width           =   5625
      _ExtentX        =   9922
      _ExtentY        =   9922
   End
   Begin PhotoDemon.smartCheckBox chkUnison 
      Height          =   480
      Left            =   6120
      TabIndex        =   4
      Top             =   3840
      Width           =   2880
      _ExtentX        =   5080
      _ExtentY        =   847
      Caption         =   "keep both dimensions in sync"
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
   Begin PhotoDemon.sliderTextCombo sltHeight 
      Height          =   495
      Left            =   6000
      TabIndex        =   6
      Top             =   3240
      Width           =   5895
      _ExtentX        =   10398
      _ExtentY        =   873
      Min             =   1
      Max             =   500
      Value           =   2
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
   Begin PhotoDemon.commandBar cmdBar 
      Align           =   2  'Align Bottom
      Height          =   750
      Left            =   0
      TabIndex        =   7
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
   Begin VB.Label lblHeight 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "box height:"
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
      TabIndex        =   3
      Top             =   2880
      Width           =   1215
   End
   Begin VB.Label lblWidth 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "box width:"
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
      TabIndex        =   2
      Top             =   1920
      Width           =   1140
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
      Height          =   975
      Left            =   6000
      TabIndex        =   1
      Top             =   4440
      Visible         =   0   'False
      Width           =   5775
      WordWrap        =   -1  'True
   End
End
Attribute VB_Name = "FormBoxBlur"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'Box Blur Tool
'Copyright �2000-2013 by Tanner Helland
'Created: some time 2000
'Last updated: 24/April/13
'Last update: greatly simplified code by using the new slider/text custom control
'
'This is a heavily optimized box blur.  An "accumulation" technique is used instead of the standard sliding
' window mechanism.  (See http://web.archive.org/web/20060718054020/http://www.acm.uiuc.edu/siggraph/workshops/wjarosz_convolution_2001.pdf)
' This allows the algorithm to perform extremely well, despite being written in pure VB.
'
'That said, it is still unfortunately slow in the IDE.  I STRONGLY recommend compiling the project before
' applying any box blur of a large radius.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://www.tannerhelland.com/photodemon/#license
'
'***************************************************************************

Option Explicit

'When previewing, we need to modify the strength to be representative of the final filter.  This means dividing by the
' original image dimensions in order to establish the right ratio.
Dim iWidth As Long, iHeight As Long

'Custom tooltip class allows for things like multiline, theming, and multiple monitor support
Dim m_ToolTip As clsToolTip

Private Sub chkUnison_Click()
    If CBool(chkUnison) Then syncScrollBars True
End Sub

'Convolve an image using a gaussian kernel (separable implementation!)
'Input: radius of the blur (min 1, no real max - but the scroll bar is maxed at 200 presently)
Public Sub BoxBlurFilter(ByVal hRadius As Long, ByVal vRadius As Long, Optional ByVal toPreview As Boolean = False, Optional ByRef dstPic As fxPreviewCtl)
    
    If toPreview = False Then Message "Applying box blur to image..."
        
    'Create a local array and point it at the pixel data of the current image
    Dim dstImageData() As Byte
    Dim dstSA As SAFEARRAY2D
    prepImageData dstSA, toPreview, dstPic
    CopyMemory ByVal VarPtrArray(dstImageData()), VarPtr(dstSA), 4
    
    'Create a second local array.  This will contain the a copy of the current image, and we will use it as our source reference
    ' (This is necessary to prevent blurred pixel values from spreading across the image as we go.)
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    
    Dim srcLayer As pdLayer
    Set srcLayer = New pdLayer
    srcLayer.createFromExistingLayer workingLayer
    
    prepSafeArray srcSA, srcLayer
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curLayerValues.Left
    initY = curLayerValues.Top
    finalX = curLayerValues.Right
    finalY = curLayerValues.Bottom
        
    'If this is a preview, we need to adjust the kernel radius to match the size of the preview box
    If toPreview Then
        hRadius = (hRadius / iWidth) * curLayerValues.Width
        vRadius = (vRadius / iHeight) * curLayerValues.Height
        If hRadius = 0 Then hRadius = 1
        If vRadius = 0 Then vRadius = 1
    End If
    
    Dim xRadius As Long, yRadius As Long
    xRadius = hRadius
    yRadius = vRadius
    
    'Just to be safe, make sure the radius isn't larger than the image itself
    If xRadius > (finalX - initX) Then xRadius = finalX - initX
    If yRadius > (finalY - initY) Then yRadius = finalY - initY
        
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, QuickValInner As Long, QuickY As Long, qvDepth As Long
    qvDepth = curLayerValues.BytesPerPixel
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
    
    'The number of pixels in the current blur box are tracked dynamically.
    Dim NumOfPixels As Long
    NumOfPixels = 0
            
    'Blurring takes a lot of variables
    Dim rTotal As Long, gTotal As Long, bTotal As Long, aTotal As Long
    Dim lbX As Long, lbY As Long, ubX As Long, ubY As Long
    Dim obuX As Boolean, obuY As Boolean, oblY As Boolean
    Dim i As Long, j As Long
    
    Dim atBottom As Boolean
    atBottom = True
    
    Dim startY As Long, stopY As Long, yStep As Long
    
    rTotal = 0: gTotal = 0: bTotal = 0: aTotal = 0
    NumOfPixels = 0
    
    'Generate an initial array of blur data for the first pixel
    For x = initX To initX + xRadius - 1
        QuickVal = x * qvDepth
    For y = initY To initY + yRadius '- 1
    
        rTotal = rTotal + srcImageData(QuickVal + 2, y)
        gTotal = gTotal + srcImageData(QuickVal + 1, y)
        bTotal = bTotal + srcImageData(QuickVal, y)
        If qvDepth = 4 Then aTotal = aTotal + srcImageData(QuickVal + 3, y)
        
        'Increase the pixel tally
        NumOfPixels = NumOfPixels + 1
        
    Next y
    Next x
                
    'Loop through each pixel in the image, tallying blur values as we go
    For x = initX To finalX
            
        QuickVal = x * qvDepth
        
        'Determine the bounds of the current blur box in the X direction
        lbX = x - xRadius
        If lbX < 0 Then lbX = 0
        ubX = x + xRadius
        
        If ubX > finalX Then
            obuX = True
            ubX = finalX
        Else
            obuX = False
        End If
                
        'As part of my accumulation algorithm, I swap the inner loop's direction with each iteration.
        ' Set y-related loop variables depending on the direction of the next cycle.
        If atBottom Then
            lbY = 0
            ubY = yRadius
        Else
            lbY = finalY - yRadius
            ubY = finalY
        End If
        
        'Remove trailing values from the blur box if they lie outside the processing radius
        If lbX > 0 Then
        
            QuickValInner = (lbX - 1) * qvDepth
        
            For j = lbY To ubY
                rTotal = rTotal - srcImageData(QuickValInner + 2, j)
                gTotal = gTotal - srcImageData(QuickValInner + 1, j)
                bTotal = bTotal - srcImageData(QuickValInner, j)
                If qvDepth = 4 Then aTotal = aTotal - srcImageData(QuickValInner + 3, j)
                NumOfPixels = NumOfPixels - 1
            Next j
        
        End If
        
        'Add leading values to the blur box if they lie inside the processing radius
        If Not obuX Then
        
            QuickValInner = ubX * qvDepth
            
            For j = lbY To ubY
                rTotal = rTotal + srcImageData(QuickValInner + 2, j)
                gTotal = gTotal + srcImageData(QuickValInner + 1, j)
                bTotal = bTotal + srcImageData(QuickValInner, j)
                If qvDepth = 4 Then aTotal = aTotal + srcImageData(QuickValInner + 3, j)
                NumOfPixels = NumOfPixels + 1
            Next j
            
        End If
        
        'Depending on the direction we are moving, remove a line of pixels from the blur box
        ' (because the interior loop will add it back in).
        If atBottom Then
                
            For i = lbX To ubX
                QuickValInner = i * qvDepth
                rTotal = rTotal - srcImageData(QuickValInner + 2, yRadius)
                gTotal = gTotal - srcImageData(QuickValInner + 1, yRadius)
                bTotal = bTotal - srcImageData(QuickValInner, yRadius)
                If qvDepth = 4 Then aTotal = aTotal - srcImageData(QuickValInner + 3, yRadius)
                NumOfPixels = NumOfPixels - 1
            Next i
        
        Else
        
            QuickY = finalY - yRadius
        
            For i = lbX To ubX
                QuickValInner = i * qvDepth
                rTotal = rTotal - srcImageData(QuickValInner + 2, QuickY)
                gTotal = gTotal - srcImageData(QuickValInner + 1, QuickY)
                bTotal = bTotal - srcImageData(QuickValInner, QuickY)
                If qvDepth = 4 Then aTotal = aTotal - srcImageData(QuickValInner + 3, QuickY)
                NumOfPixels = NumOfPixels - 1
            Next i
        
        End If
        
        'Based on the direction we're traveling, reverse the interior loop boundaries as necessary.
        If atBottom Then
            startY = 0
            stopY = finalY
            yStep = 1
        Else
            startY = finalY
            stopY = 0
            yStep = -1
        End If
            
    'Process the next column.  This step is pretty much identical to the row steps above (but in a vertical direction, obviously)
    For y = startY To stopY Step yStep
            
        'If we are at the bottom and moving up, we will REMOVE rows from the bottom and ADD them at the top.
        'If we are at the top and moving down, we will REMOVE rows from the top and ADD them at the bottom.
        'As such, there are two copies of this function, one per possible direction.
        If atBottom Then
        
            'Calculate bounds
            lbY = y - yRadius
            If lbY < 0 Then lbY = 0
            
            ubY = y + yRadius
            If ubY > finalY Then
                obuY = True
                ubY = finalY
            Else
                obuY = False
            End If
                                
            'Remove trailing values from the box
            If lbY > 0 Then
            
                QuickY = lbY - 1
            
                For i = lbX To ubX
                    QuickValInner = i * qvDepth
                    rTotal = rTotal - srcImageData(QuickValInner + 2, QuickY)
                    gTotal = gTotal - srcImageData(QuickValInner + 1, QuickY)
                    bTotal = bTotal - srcImageData(QuickValInner, QuickY)
                    If qvDepth = 4 Then aTotal = aTotal - srcImageData(QuickValInner + 3, QuickY)
                    NumOfPixels = NumOfPixels - 1
                Next i
                        
            End If
                    
            'Add leading values
            If Not obuY Then
            
                For i = lbX To ubX
                    QuickValInner = i * qvDepth
                    rTotal = rTotal + srcImageData(QuickValInner + 2, ubY)
                    gTotal = gTotal + srcImageData(QuickValInner + 1, ubY)
                    bTotal = bTotal + srcImageData(QuickValInner, ubY)
                    If qvDepth = 4 Then aTotal = aTotal + srcImageData(QuickValInner + 3, ubY)
                    NumOfPixels = NumOfPixels + 1
                Next i
            
            End If
            
        'The exact same code as above, but in the opposite direction
        Else
        
            lbY = y - yRadius
            If lbY < 0 Then
                oblY = True
                lbY = 0
            Else
                oblY = False
            End If
            
            ubY = y + yRadius
            If ubY > finalY Then ubY = finalY
                                
            If ubY < finalY Then
            
                QuickY = ubY + 1
            
                For i = lbX To ubX
                    QuickValInner = i * qvDepth
                    rTotal = rTotal - srcImageData(QuickValInner + 2, QuickY)
                    gTotal = gTotal - srcImageData(QuickValInner + 1, QuickY)
                    bTotal = bTotal - srcImageData(QuickValInner, QuickY)
                    If qvDepth = 4 Then aTotal = aTotal - srcImageData(QuickValInner + 3, QuickY)
                    NumOfPixels = NumOfPixels - 1
                Next i
                        
            End If
                    
            If Not oblY Then
            
                For i = lbX To ubX
                    QuickValInner = i * qvDepth
                    rTotal = rTotal + srcImageData(QuickValInner + 2, lbY)
                    gTotal = gTotal + srcImageData(QuickValInner + 1, lbY)
                    bTotal = bTotal + srcImageData(QuickValInner, lbY)
                    If qvDepth = 4 Then aTotal = aTotal + srcImageData(QuickValInner + 3, lbY)
                    NumOfPixels = NumOfPixels + 1
                Next i
            
            End If
        
        End If
                
        'With the blur box successfully calculated, we can finally apply the results to the image.
        dstImageData(QuickVal + 2, y) = rTotal \ NumOfPixels
        dstImageData(QuickVal + 1, y) = gTotal \ NumOfPixels
        dstImageData(QuickVal, y) = bTotal \ NumOfPixels
        If qvDepth = 4 Then dstImageData(QuickVal + 3, y) = aTotal \ NumOfPixels
    
    Next y
        atBottom = Not atBottom
        If toPreview = False Then
            If (x And progBarCheck) = 0 Then
                If userPressedESC() Then Exit For
                SetProgBarVal x
            End If
        End If
    Next x
        
    'With our work complete, point both ImageData() arrays away from their DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    
    CopyMemory ByVal VarPtrArray(dstImageData), 0&, 4
    Erase dstImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData toPreview, dstPic

End Sub

Private Sub cmdBar_OKClick()
    Process "Box blur", , buildParams(sltWidth, sltHeight)
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
        lblIDEWarning.Caption = g_Language.TranslateMessage("WARNING!  This tool has been heavily optimized, but at high radius values it will still be quite slow inside the IDE.  Please compile before applying or previewing any radius larger than 20.")
        lblIDEWarning.Visible = True
    End If
    
    'Draw a preview of the effect
    updatePreview
    
End Sub

Private Sub Form_Load()

    'Note the current image's width and height, which will be needed to adjust the preview effect
    If pdImages(CurrentImage).selectionActive Then
        iWidth = pdImages(CurrentImage).mainSelection.boundWidth
        iHeight = pdImages(CurrentImage).mainSelection.boundHeight
    Else
        iWidth = pdImages(CurrentImage).Width
        iHeight = pdImages(CurrentImage).Height
    End If
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseFormTheming Me
End Sub

'Keep the two scroll bars in sync.  Some extra work has to be done to makes sure scrollbar max values aren't exceeded.
Private Sub syncScrollBars(ByVal srcHorizontal As Boolean)
    
    If sltWidth.Value = sltHeight.Value Then Exit Sub
    
    Dim tmpVal As Long
    
    If srcHorizontal Then
        tmpVal = sltWidth.Value
        If tmpVal < sltHeight.Max Then sltHeight.Value = sltWidth.Value Else sltHeight.Value = sltHeight.Max
    Else
        tmpVal = sltHeight.Value
        If tmpVal < sltWidth.Max Then sltWidth.Value = sltHeight.Value Else sltWidth.Value = sltWidth.Max
    End If
    
End Sub
Private Sub updatePreview()
    If cmdBar.previewsAllowed Then BoxBlurFilter sltWidth, sltHeight, True, fxPreview
End Sub

Private Sub sltHeight_Change()
    If CBool(chkUnison) Then syncScrollBars False
    updatePreview
End Sub

Private Sub sltWidth_Change()
    If CBool(chkUnison) Then syncScrollBars True
    updatePreview
End Sub
