Attribute VB_Name = "Drawing"
'***************************************************************************
'PhotoDemon Drawing Routines
'Copyright 2001-2015 by Tanner Helland
'Created: 4/3/01
'Last updated: 01/December/12
'Last update: Added DrawSystemIcon function (previously used for only the "unsaved changes" dialog
'
'Miscellaneous drawing routines that don't fit elsewhere.  At present, this includes rendering preview images,
' drawing the canvas background of image forms, and a gradient-rendering sub (used primarily on the histogram form).
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'The following Enum and two API declarations are used to draw the system information icon
Public Enum SystemIconConstants
    IDI_APPLICATION = 32512
    IDI_HAND = 32513
    IDI_QUESTION = 32514
    IDI_EXCLAMATION = 32515
    IDI_ASTERISK = 32516
    IDI_WINDOWS = 32517
End Enum

Private Declare Function LoadIconByID Lib "user32" Alias "LoadIconA" (ByVal hInstance As Long, ByVal lpIconName As Long) As Long
Private Declare Function DrawIcon Lib "user32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal hIcon As Long) As Long

'GDI drawing functions
Private Const PS_SOLID = 0
Private Const PS_DASH = 1
Private Const PS_DOT = 2
Private Const PS_DASHDOT = 3
Private Const PS_DASHDOTDOT = 4

Private Const RGN_AND = 1
Private Const RGN_OR = 2
Private Const RGN_XOR = 3
Private Const RGN_DIFF = 4
Private Const RGN_COPY = 5

Private Const HS_DIAGCROSS = 5

Private Const NULL_BRUSH = 5

Private Declare Function CreateDIBPatternBrushPt Lib "gdi32" (ByVal dibPointer As Long, ByVal iUsage As Long) As Long
Private Declare Function CreatePatternBrush Lib "gdi32" (ByVal hBitmap As Long) As Long
Private Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function GetStockObject Lib "gdi32" (ByVal nIndex As Long) As Long
Private Declare Function LineTo Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function MoveToEx Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal pointerToRectOfOldCoords As Long) As Long
Private Declare Function PatBlt Lib "gdi32" (ByVal targetDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal dwRop As Long) As Long
Private Declare Function Rectangle Lib "gdi32" (ByVal hDC As Long, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
Private Declare Function SetBrushOrgEx Lib "gdi32" (ByVal targetDC As Long, ByVal nXOrg As Long, ByVal nYOrg As Long, ByVal refToPeviousPoint As Long) As Long
Private Declare Function SetROP2 Lib "gdi32" (ByVal hDC As Long, ByVal nDrawMode As Long) As Long

'DC API functions
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function GetDC Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function ReleaseDC Lib "user32" (ByVal hWnd As Long, ByVal hDC As Long) As Long

'API for converting between hWnd-specific coordinate spaces.  Note that the function technically accepts an
' array of POINTAPI points; the address passed to lpPoints should be the address of the first point in the array
' (e.g. ByRef PointArray(0)), while the cPoints parameter is the number of points in the array.  If two points are
' passed, a special Rect transform may occur on RtL systems; see http://msdn.microsoft.com/en-us/library/dd145046%28v=vs.85%29.aspx
Private Declare Function MapWindowPoints Lib "user32" (ByVal hWndFrom As Long, ByVal hWndTo As Long, ByRef lpPoints As POINTAPI, ByVal cPoints As Long) As Long

'Given a target picture box, draw a hue preview across the horizontal axis.  This is helpful for tools that provide
' a hue slider, so that the user can easily find a color of their choosing.  Optionally, saturation and luminance
' can be provided, though it's generally assumed that those values will both be 1.0.
Public Sub drawHueBox_HSV(ByRef dstPic As PictureBox, Optional ByVal dstSaturation As Double = 1, Optional ByVal dstLuminance As Double = 1)

    'Retrieve the picture box's dimensions
    Dim picWidth As Long, picHeight As Long
    picWidth = dstPic.ScaleWidth
    picHeight = dstPic.ScaleHeight
    
    'Use a DIB to hold the hue box before we render it on-screen.  Why?  So we can color-manage it, of course!
    Dim tmpDIB As pdDIB
    Set tmpDIB = New pdDIB
    tmpDIB.createBlank picWidth, picHeight, 24, 0
    
    Dim tmpR As Double, tmpG As Double, tmpB As Double
    
    'From left-to-right, draw a full hue range onto the DIB
    Dim x As Long
    For x = 0 To tmpDIB.getDIBWidth - 1
        fHSVtoRGB x / tmpDIB.getDIBWidth, dstSaturation, dstLuminance, tmpR, tmpG, tmpB
        drawLineToDC tmpDIB.getDIBDC, x, 0, x, picHeight, RGB(tmpR * 255, tmpG * 255, tmpB * 255)
    Next x
    
    'With the hue box complete, render it onto the destination picture box, with color management applied
    tmpDIB.renderToPictureBox dstPic

End Sub

'Given a target picture box, draw a saturation preview across the horizontal axis.  This is helpful for tools that provide
' a saturation slider, so that the user can easily find a color of their choosing.  Optionally, hue and luminance can be
' provided - hue is STRONGLY recommended, but luminance can safely be assumed to be 1.0 (in most cases).
Public Sub drawSaturationBox_HSV(ByRef dstPic As PictureBox, Optional ByVal dstHue As Double = 1, Optional ByVal dstLuminance As Double = 1)

    'Retrieve the picture box's dimensions
    Dim picWidth As Long, picHeight As Long
    picWidth = dstPic.ScaleWidth
    picHeight = dstPic.ScaleHeight
    
    'Use a DIB to hold the hue box before we render it on-screen.  Why?  So we can color-manage it, of course!
    Dim tmpDIB As pdDIB
    Set tmpDIB = New pdDIB
    tmpDIB.createBlank picWidth, picHeight, 24, 0
    
    Dim tmpR As Double, tmpG As Double, tmpB As Double
    
    'From left-to-right, draw a full hue range onto the DIB
    Dim x As Long
    For x = 0 To tmpDIB.getDIBWidth - 1
        fHSVtoRGB dstHue, x / tmpDIB.getDIBWidth, dstLuminance, tmpR, tmpG, tmpB
        drawLineToDC tmpDIB.getDIBDC, x, 0, x, picHeight, RGB(tmpR * 255, tmpG * 255, tmpB * 255)
    Next x
    
    'With the hue box complete, render it onto the destination picture box, with color management applied
    tmpDIB.renderToPictureBox dstPic

End Sub

'Basic wrapper to line-drawing via the API
Public Sub drawLineToDC(ByVal targetDC As Long, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal crColor As Long)

    'Create a pen with the specified color
    Dim newPen As Long
    newPen = CreatePen(PS_SOLID, 1, crColor)
    
    'Select the pen into the target DC
    Dim oldObject As Long
    oldObject = SelectObject(targetDC, newPen)
    
    'Render the line
    MoveToEx targetDC, x1, y1, 0&
    LineTo targetDC, x2, y2
    
    'Remove the pen and delete it
    SelectObject targetDC, oldObject
    DeleteObject newPen

End Sub

'Simplified pure-VB function for rendering text to an object.
Public Sub drawTextOnObject(ByRef dstObject As Object, ByVal sText As String, ByVal xPos As Long, ByVal yPos As Long, Optional ByVal newFontSize As Long = 12, Optional ByVal newFontColor As Long = 0, Optional ByVal makeFontBold As Boolean = False, Optional ByVal makeFontItalic As Boolean = False)

    dstObject.CurrentX = xPos
    dstObject.CurrentY = yPos
    dstObject.fontSize = newFontSize
    dstObject.ForeColor = newFontColor
    dstObject.fontBold = makeFontBold
    dstObject.fontItalic = makeFontItalic
    dstObject.Print sText

End Sub

'Draw a system icon on the specified device context; this code is adopted from an example by Francesco Balena at http://www.devx.com/vb2themax/Tip/19108
Public Sub DrawSystemIcon(ByVal icon As SystemIconConstants, ByVal hDC As Long, ByVal x As Long, ByVal y As Long)
    Dim hIcon As Long
    hIcon = LoadIconByID(0, icon)
    DrawIcon hDC, x, y, hIcon
End Sub

'Used to draw the main image onto a preview picture box
Public Sub DrawPreviewImage(ByRef dstPicture As PictureBox, Optional ByVal useOtherPictureSrc As Boolean = False, Optional ByRef otherPictureSrc As pdDIB, Optional forceWhiteBackground As Boolean = False)
    
    Dim tmpDIB As pdDIB
    
    'Start by calculating the aspect ratio of both the current image and the previewing picture box
    Dim dstWidth As Double, dstHeight As Double
    dstWidth = dstPicture.ScaleWidth
    dstHeight = dstPicture.ScaleHeight
    
    Dim srcWidth As Double, srcHeight As Double
    
    'The source values need to be adjusted contingent on whether this is a selection or a full-image preview
    If useOtherPictureSrc Then
        srcWidth = otherPictureSrc.getDIBWidth
        srcHeight = otherPictureSrc.getDIBHeight
    Else
        If pdImages(g_CurrentImage).selectionActive Then
            srcWidth = pdImages(g_CurrentImage).mainSelection.boundWidth
            srcHeight = pdImages(g_CurrentImage).mainSelection.boundHeight
        Else
            srcWidth = pdImages(g_CurrentImage).getActiveDIB().getDIBWidth
            srcHeight = pdImages(g_CurrentImage).getActiveDIB().getDIBHeight
        End If
    End If
            
    'Now, use that aspect ratio to determine a proper size for our temporary DIB
    Dim newWidth As Long, newHeight As Long
    
    convertAspectRatio srcWidth, srcHeight, dstWidth, dstHeight, newWidth, newHeight
    
    'Normally this will draw a preview of pdImages(g_CurrentImage).containingForm's relevant image.  However, another picture source can be specified.
    If Not useOtherPictureSrc Then
        
        'Check to see if a selection is active; if it isn't, simply render the full form
        If Not pdImages(g_CurrentImage).selectionActive Then
        
            If pdImages(g_CurrentImage).getActiveDIB().getDIBColorDepth = 32 Then
                Set tmpDIB = New pdDIB
                tmpDIB.createFromExistingDIB pdImages(g_CurrentImage).getActiveDIB(), newWidth, newHeight, True
                If forceWhiteBackground Then tmpDIB.compositeBackgroundColor 255, 255, 255
                tmpDIB.renderToPictureBox dstPicture
            Else
                pdImages(g_CurrentImage).getActiveDIB().renderToPictureBox dstPicture
            End If
        
        Else
        
            'Copy the current selection into a temporary DIB
            Set tmpDIB = New pdDIB
            tmpDIB.createBlank pdImages(g_CurrentImage).mainSelection.boundWidth, pdImages(g_CurrentImage).mainSelection.boundHeight, pdImages(g_CurrentImage).getActiveDIB().getDIBColorDepth
            BitBlt tmpDIB.getDIBDC, 0, 0, pdImages(g_CurrentImage).mainSelection.boundWidth, pdImages(g_CurrentImage).mainSelection.boundHeight, pdImages(g_CurrentImage).getActiveDIB().getDIBDC, pdImages(g_CurrentImage).mainSelection.boundLeft, pdImages(g_CurrentImage).mainSelection.boundTop, vbSrcCopy
        
            'If the image is transparent, composite it; otherwise, render the preview using the temporary object
            If pdImages(g_CurrentImage).getActiveDIB().getDIBColorDepth = 32 Then
                If forceWhiteBackground Then tmpDIB.compositeBackgroundColor 255, 255, 255
            End If
            
            tmpDIB.renderToPictureBox dstPicture
            
        End If
        
    Else
    
        If otherPictureSrc.getDIBColorDepth = 32 Then
            Set tmpDIB = New pdDIB
            tmpDIB.createFromExistingDIB otherPictureSrc, newWidth, newHeight, True
            If forceWhiteBackground Then tmpDIB.compositeBackgroundColor 255, 255, 255
            tmpDIB.renderToPictureBox dstPicture
        Else
            otherPictureSrc.renderToPictureBox dstPicture
        End If
        
    End If
    
End Sub

'Draw a gradient from Color1 to Color 2 (RGB longs) on a specified picture box
Public Sub DrawGradient(ByVal DstPicBox As Object, ByVal Color1 As Long, ByVal Color2 As Long, Optional ByVal drawHorizontal As Boolean = False)

    'Calculation variables (used to interpolate between the gradient colors)
    Dim vR As Double, vG As Double, vB As Double
    Dim x As Long, y As Long
    
    'Red, green, and blue variables for each gradient color
    Dim r As Long, g As Long, b As Long
    Dim r2 As Long, g2 As Long, b2 As Long
    
    'Extract the red, green, and blue values from the gradient colors (which were passed as Longs)
    r = ExtractR(Color1)
    g = ExtractG(Color1)
    b = ExtractB(Color1)
    r2 = ExtractR(Color2)
    g2 = ExtractG(Color2)
    b2 = ExtractB(Color2)
    
    'Width and height variables are faster than repeated access of .ScaleWidth/Height properties
    Dim tmpHeight As Long
    Dim tmpWidth As Long
    tmpWidth = DstPicBox.ScaleWidth
    tmpHeight = DstPicBox.ScaleHeight

    'Create a calculation variable, which will be used to determine the interpolation step between
    ' each gradient color
    If drawHorizontal Then
        vR = Abs(r - r2) / tmpWidth
        vG = Abs(g - g2) / tmpWidth
        vB = Abs(b - b2) / tmpWidth
    Else
        vR = Abs(r - r2) / tmpHeight
        vG = Abs(g - g2) / tmpHeight
        vB = Abs(b - b2) / tmpHeight
    End If
    
    'If a component of the right color is less than the matching component of the left color, make the step negative
    If r2 < r Then vR = -vR
    If g2 < g Then vG = -vG
    If b2 < b Then vB = -vB
    
    'Run a loop across the picture box, changing the gradient color according to the step calculated earlier
    If drawHorizontal Then
        For x = 0 To tmpWidth
            r2 = r + vR * x
            g2 = g + vG * x
            b2 = b + vB * x
            DstPicBox.Line (x, 0)-(x, tmpHeight), RGB(r2, g2, b2)
        Next x
    Else
        For y = 0 To tmpHeight
            r2 = r + vR * y
            g2 = g + vG * y
            b2 = b + vB * y
            DstPicBox.Line (0, y)-(tmpWidth, y), RGB(r2, g2, b2)
        Next y
    End If
    
End Sub

'Draw a horizontal gradient to a specified DIB from x-position xLeft to xRigth,
' using ColorLeft and ColorRight (RGB longs) as the gradient endpoints.
Public Sub DrawHorizontalGradientToDIB(ByVal dstDIB As pdDIB, ByVal xLeft As Long, ByVal xRight As Long, ByVal colorLeft As Long, ByVal colorRight As Long)
    
    Dim x As Long
    
    'Red, green, and blue variables for each gradient color
    Dim rLeft As Long, gLeft As Long, bLeft As Long
    Dim rRight As Long, gRight As Long, Bright As Long
    
    'Extract the red, green, and blue values from the gradient colors (which were passed as Longs)
    rLeft = ExtractR(colorLeft)
    gLeft = ExtractG(colorLeft)
    bLeft = ExtractB(colorLeft)
    rRight = ExtractR(colorRight)
    gRight = ExtractG(colorRight)
    Bright = ExtractB(colorRight)
    
    'Calculate a width for the gradient area
    Dim gradWidth As Long
    gradWidth = xRight - xLeft
    
    Dim blendRatio As Double
    Dim newR As Byte, newG As Byte, newB As Byte
    
    '32bpp DIBs need to use GDI+ instead of GDI, to make sure the alpha channel is supported
    Dim alphaMatters As Boolean
    If dstDIB.getDIBColorDepth = 32 Then alphaMatters = True Else alphaMatters = False
    
    'If alpha is relevant, cache a GDI+ image handle and pen in advance
    Dim hGdipImage As Long, hGdipPen As Long
    If alphaMatters Then hGdipImage = GDI_Plus.getGDIPlusGraphicsFromDC(dstDIB.getDIBDC, False)
    
    'Run a loop across the DIB, changing the gradient color according to the step calculated earlier
    For x = xLeft To xRight
        
        'Calculate a blend ratio for this position
        blendRatio = (x - xLeft) / gradWidth
        
        'Calculate blendd RGB values for this position
        newR = BlendColors(rLeft, rRight, blendRatio)
        newG = BlendColors(gLeft, gRight, blendRatio)
        newB = BlendColors(bLeft, Bright, blendRatio)
        
        'Draw a vertical line at this position, using the calculated color
        If alphaMatters Then
        
            hGdipPen = GDI_Plus.getGDIPlusPenHandle(RGB(newR, newG, newB), 255, 1, LineCapFlat)
            GDI_Plus.GDIPlusDrawLine_Fast hGdipImage, hGdipPen, x, 0, x, dstDIB.getDIBHeight
            GDI_Plus.releaseGDIPlusPen hGdipPen
        
        Else
            drawLineToDC dstDIB.getDIBDC, x, 0, x, dstDIB.getDIBHeight, RGB(newR, newG, newB)
        End If
        
    Next x
    
    'Release our GDI+ handle, if any
    If alphaMatters Then GDI_Plus.releaseGDIPlusGraphics hGdipImage
    
End Sub

'Given a source DIB, fill it with a 2x2 alpha checkerboard pattern matching the user's current preferences.
' (The resulting DIB size is contingent on the user's checkerboard pattern size preference, FYI.)
Public Sub createAlphaCheckerboardDIB(ByRef srcDIB As pdDIB)

    'Retrieve the user's preferred alpha checkerboard colors, and convert the longs into individual RGB components
    Dim chkColorOne As Long, chkColorTwo As Long
    chkColorOne = g_UserPreferences.GetPref_Long("Transparency", "AlphaCheckOne", RGB(255, 255, 255))
    chkColorTwo = g_UserPreferences.GetPref_Long("Transparency", "AlphaCheckTwo", RGB(204, 204, 204))
    
    Dim r1 As Long, g1 As Long, b1 As Long
    Dim r2 As Long, g2 As Long, b2 As Long
    r1 = ExtractR(chkColorOne)
    r2 = ExtractR(chkColorTwo)
    g1 = ExtractG(chkColorOne)
    g2 = ExtractG(chkColorTwo)
    b1 = ExtractB(chkColorOne)
    b2 = ExtractB(chkColorTwo)
    
    'Determine a checkerboard block size based on the current user preference
    Dim chkSize As Long
    chkSize = g_UserPreferences.GetPref_Long("Transparency", "AlphaCheckSize", 1)
    
    Select Case chkSize
    
        'Small (4x4 checks)
        Case 0
            chkSize = 4
            
        'Medium (8x8 checks)
        Case 1
            chkSize = 8
        
        'Large (16x16 checks)
        Case Else
            chkSize = 16
        
    End Select
    
    'Resize the source DIB to fit a 2x2 block pattern of the requested checkerboard pattern
    srcDIB.createBlank chkSize * 2, chkSize * 2
    
    'Point a temporary array directly at the source DIB's bitmap bits.
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    prepSafeArray srcSA, srcDIB
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
    
    'Fill the source DIB with the checkerboard pattern
    Dim x As Long, y As Long, QuickX As Long
    For x = 0 To srcDIB.getDIBWidth - 1
        QuickX = x * 3
    For y = 0 To srcDIB.getDIBHeight - 1
         
        If (((x \ chkSize) + (y \ chkSize)) And 1) = 0 Then
            srcImageData(QuickX + 2, y) = r1
            srcImageData(QuickX + 1, y) = g1
            srcImageData(QuickX, y) = b1
        Else
            srcImageData(QuickX + 2, y) = r2
            srcImageData(QuickX + 1, y) = g2
            srcImageData(QuickX, y) = b2
        End If
        
    Next y
    Next x
    
    'Release our temporary array and exit
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData

End Sub

'Given a source DIB, fill it with the alpha checkerboard pattern.  32bpp images can then be alpha blended onto it.
Public Sub fillDIBWithAlphaCheckerboard(ByRef srcDIB As pdDIB, ByVal x1 As Long, ByVal y1 As Long, ByVal bltWidth As Long, ByVal bltHeight As Long)

    'Create a pattern brush from the public checkerboard image
    Dim hCheckerboard As Long
    hCheckerboard = CreatePatternBrush(g_CheckerboardPattern.getDIBHandle)
    
    'Select the brush into the target DIB's DC
    Dim hOldBrush As Long
    hOldBrush = SelectObject(srcDIB.getDIBDC, hCheckerboard)
    
    'Paint the DIB
    SetBrushOrgEx srcDIB.getDIBDC, x1, y1, 0&
    PatBlt srcDIB.getDIBDC, x1, y1, bltWidth, bltHeight, vbPatCopy
    
    'Remove and delete the brush
    SelectObject srcDIB.getDIBDC, hOldBrush
    DeleteObject hCheckerboard

End Sub

'Given an (x,y) pair on the current viewport, convert the value to coordinates on the image.
Public Function convertCanvasCoordsToImageCoords(ByRef srcCanvas As pdCanvas, ByRef srcImage As pdImage, ByVal canvasX As Double, ByVal canvasY As Double, ByRef imgX As Double, ByRef imgY As Double, Optional ByVal forceInBounds As Boolean = False) As Boolean

    If Not (srcImage.imgViewport Is Nothing) Then
    
        'Get the current zoom value from the source image
        Dim zoomVal As Double
        zoomVal = g_Zoom.getZoomValue(srcImage.currentZoomValue)
                    
        'Because the viewport is no longer assumed at position (0, 0) (due to the status bar and possibly
        ' rulers), add any necessary offsets to the mouse coordinates before further calculations happen.
        canvasY = canvasY - srcImage.imgViewport.getTopOffset
        
        'Calculate image x and y positions, while taking into account zoom and scroll values
        imgX = srcCanvas.getScrollValue(PD_HORIZONTAL) + Int((canvasX - srcImage.imgViewport.targetLeft) / zoomVal)
        imgY = srcCanvas.getScrollValue(PD_VERTICAL) + Int((canvasY - srcImage.imgViewport.targetTop) / zoomVal)
        
        'If the caller wants the coordinates bound-checked, apply it now
        If forceInBounds Then
            If imgX < 0 Then imgX = 0
            If imgY < 0 Then imgY = 0
            If imgX >= srcImage.Width Then imgX = srcImage.Width - 1
            If imgY >= srcImage.Height Then imgY = srcImage.Height - 1
        End If
        
        convertCanvasCoordsToImageCoords = True
        
    Else
        convertCanvasCoordsToImageCoords = False
    End If
    
End Function

'Given an (x,y) pair on the current image, convert the value to coordinates on the current viewport canvas.
Public Sub convertImageCoordsToCanvasCoords(ByRef srcCanvas As pdCanvas, ByRef srcImage As pdImage, ByVal imgX As Double, ByVal imgY As Double, ByRef canvasX As Double, ByRef canvasY As Double, Optional ByVal forceInBounds As Boolean = False)

    If srcImage.imgViewport Is Nothing Then Exit Sub
    
    'Get the current zoom value from the source image
    Dim zoomVal As Double
    zoomVal = g_Zoom.getZoomValue(srcImage.currentZoomValue)
    
    'Calculate canvas x and y positions, while taking into account zoom and scroll values
    canvasX = (imgX - srcCanvas.getScrollValue(PD_HORIZONTAL)) * zoomVal + srcImage.imgViewport.targetLeft
    canvasY = (imgY - srcCanvas.getScrollValue(PD_VERTICAL)) * zoomVal + srcImage.imgViewport.targetTop
    
    'Because the viewport is no longer assumed at position (0, 0) (due to the status bar and possibly
    ' rulers), add any necessary offsets to the mouse coordinates before further calculations happen.
    canvasY = canvasY + srcImage.imgViewport.getTopOffset
    
    'If the caller wants the coordinates bound-checked, apply it now
    If forceInBounds Then
        If canvasX < srcImage.imgViewport.targetLeft Then imgX = srcImage.imgViewport.targetLeft
        If canvasY < srcImage.imgViewport.targetTop Then imgY = srcImage.imgViewport.targetTop
        If canvasX >= srcImage.imgViewport.targetLeft + srcImage.imgViewport.targetWidth Then imgX = srcImage.imgViewport.targetLeft + srcImage.imgViewport.targetWidth - 1
        If canvasY >= srcImage.imgViewport.targetTop + srcImage.imgViewport.targetHeight Then imgY = srcImage.imgViewport.targetTop + srcImage.imgViewport.targetHeight - 1
    End If
    
End Sub

'Given a source hWnd and a destination hWnd, translate a coordinate pair between their unique coordinate spaces.  Note that
' the screen coordinate space will be used as an intermediary in the conversion.
Public Sub convertCoordsBetweenHwnds(ByVal srcHwnd As Long, ByVal dstHwnd As Long, ByVal srcX As Long, ByVal srcY As Long, ByRef dstX As Long, ByRef dstY As Long)
    
    'The API we're using require POINTAPI structs
    Dim tmpPoint As POINTAPI
    
    With tmpPoint
        .x = srcX
        .y = srcY
    End With
    
    'Transform the coordinates
    MapWindowPoints srcHwnd, dstHwnd, tmpPoint, 1
    
    'Report the transformed points back to the user
    dstX = tmpPoint.x
    dstY = tmpPoint.y
    
End Sub

'Given a specific layer, return a RECT filled with that layer's corner coordinates -
' IN THE CANVAS COORDINATE SPACE (hence the function name).
Public Sub getCanvasRectForLayer(ByVal layerIndex As Long, ByRef dstRect As RECT, Optional ByVal useCanvasModifiers As Boolean = False)

    Dim tmpX As Double, tmpY As Double
    
    With pdImages(g_CurrentImage).getLayerByIndex(layerIndex)
        
        'Start with the top-left corner
        convertImageCoordsToCanvasCoords FormMain.mainCanvas(0), pdImages(g_CurrentImage), .getLayerOffsetX, .getLayerOffsetY, tmpX, tmpY
        dstRect.Left = tmpX
        dstRect.Top = tmpY
        
        'End with the bottom-right corner
        convertImageCoordsToCanvasCoords FormMain.mainCanvas(0), pdImages(g_CurrentImage), .getLayerOffsetX + .getLayerWidth(useCanvasModifiers), .getLayerOffsetY + .getLayerHeight(useCanvasModifiers), tmpX, tmpY
        
        'Because layers support sub-pixel positioning, but the canvas rect renderer *does not*, we must manually align the right/bottom coords
        dstRect.Right = Int(tmpX + 0.99)
        dstRect.Bottom = Int(tmpY + 0.99)
        
    End With

End Sub

'Same as above, but using floating-point values
Public Sub getCanvasRectForLayerF(ByVal layerIndex As Long, ByRef dstRect As RECTF, Optional ByVal useCanvasModifiers As Boolean = False)

    Dim tmpX As Double, tmpY As Double
    
    With pdImages(g_CurrentImage).getLayerByIndex(layerIndex)
        
        'Start with the top-left corner
        convertImageCoordsToCanvasCoords FormMain.mainCanvas(0), pdImages(g_CurrentImage), .getLayerOffsetX, .getLayerOffsetY, tmpX, tmpY
        dstRect.Left = tmpX
        dstRect.Top = tmpY
        
        'End with the bottom-right corner
        convertImageCoordsToCanvasCoords FormMain.mainCanvas(0), pdImages(g_CurrentImage), .getLayerOffsetX + .getLayerWidth(useCanvasModifiers), .getLayerOffsetY + .getLayerHeight(useCanvasModifiers), tmpX, tmpY
        dstRect.Width = tmpX - dstRect.Left
        dstRect.Height = tmpY - dstRect.Top
        
    End With

End Sub

'On the current viewport, render lines around the active layer
Public Sub drawLayerBoundaries(ByVal layerIndex As Long)

    'Start by filling a rect with the current layer boundaries, but translated to the canvas coordinate system
    Dim layerCanvasRect As RECT
    getCanvasRectForLayer layerIndex, layerCanvasRect, True
    
    'Next, draw a rectangle to the coordinates we provided
    
    'Store the destination DC to a local variable
    Dim dstDC As Long
    dstDC = FormMain.mainCanvas(0).hDC
    
    'Since we'll be using the API to draw our selection area, we need to initialize several brushes
    Dim hPen As Long, hOldPen As Long
    
    hPen = CreatePen(PS_DOT, 0, RGB(0, 0, 0))
    hOldPen = SelectObject(dstDC, hPen)
    
    'Get a transparent brush
    Dim hBrush As Long, hOldBrush As Long
    hBrush = GetStockObject(NULL_BRUSH)
    hOldBrush = SelectObject(dstDC, hBrush)
    
    'Change the rasterOp to XOR (this will invert the line)
    SetROP2 dstDC, vbSrcInvert
                
    'Draw the rectangle
    With layerCanvasRect
        Rectangle dstDC, .Left, .Top, .Right, .Bottom
    End With
    
    'Restore the normal COPY rOp
    SetROP2 dstDC, vbSrcCopy
    
    'Remove the brush from the DC
    SelectObject dstDC, hOldBrush
    DeleteObject hBrush
    
    'Remove the pen from the DC
    SelectObject dstDC, hOldPen
    DeleteObject hPen

End Sub

'On the current viewport, render standard PD transformation nodes atop the active layer.
' (At present, only the corners are marked.  In the future, rotation may also be added.)
Public Sub drawLayerNodes(ByVal layerIndex As Long)

    'Start by filling a rect with the current layer boundaries, but translated to the canvas coordinate system
    Dim layerCanvasRect As RECTF
    getCanvasRectForLayerF layerIndex, layerCanvasRect, True
    
    'Draw transform nodes around the layer
    Dim circRadius As Long
    circRadius = 7
    
    Dim circAlpha As Long
    circAlpha = 190
    
    'Store the destination DC to a local variable
    Dim dstDC As Long
    dstDC = FormMain.mainCanvas(0).hDC
    
    'Use GDI+ to render four corner circles
    With layerCanvasRect
        GDIPlusDrawCanvasCircle dstDC, .Left, .Top, circRadius, circAlpha
        GDIPlusDrawCanvasCircle dstDC, .Left + .Width, .Top, circRadius, circAlpha
        GDIPlusDrawCanvasCircle dstDC, .Left + .Width, .Top + .Height, circRadius, circAlpha
        GDIPlusDrawCanvasCircle dstDC, .Left, .Top + .Height, circRadius, circAlpha
    End With

End Sub

'Need a quick and dirty DC for something?  Call this.  (Just remember to free the DC when you're done!)
Public Function getTemporaryDC() As Long
    getTemporaryDC = CreateCompatibleDC(0)
End Function

Public Sub freeTemporaryDC(ByVal srcDC As Long)
    DeleteDC srcDC
End Sub
