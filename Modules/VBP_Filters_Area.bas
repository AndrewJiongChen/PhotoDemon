Attribute VB_Name = "Filters_Area"
'***************************************************************************
'Filter (Area) Interface
'Copyright �2001-2014 by Tanner Helland
'Created: 12/June/01
'Last updated: 02/June/13
'Last update: remove Soften, Soften More, Blur, and Blur More filters.  These have all been superseded by the far
'              superior Gaussian Blur and Box Blur implementations.
'Still needs: interpolation for isometric conversion
'
'Holder for generalized area filters, including most of the project's convolution filters.
' Also contains the DoFilter routine, which is central to running custom filters
' (as well as many of the intrinsic PhotoDemon ones, like blur/sharpen/etc).
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'These constants are related to saving/loading custom filters to/from a file
Public Const CUSTOM_FILTER_ID As String * 4 = "DScf"
Public Const CUSTOM_FILTER_VERSION_2003 = &H80000000
Public Const CUSTOM_FILTER_VERSION_2012 = &H80000001
Public Const CUSTOM_FILTER_VERSION_2014 As String = "8.2014"

'The omnipotent DoFilter routine - it takes whatever is in g_FM() - the "filter matrix" and applies it to the image
'REWRITING AUGUST 2014:
' DoFilter will now use a param string, like everything else.  Custom save/load code is also disappearing in favor of
' the standard save/load preset manager.
' ParamString format is as follows:
'    Name: String.  Can't be blank, but can be a single space
'    Invert: boolean
'    Divisor: Double
'    Offset: Long
'    25 Double-type values, which correspond to entries in a 5x5 convolution matrix

Public Sub DoFilter(ByVal fullParamString As String, Optional ByVal toPreview As Boolean = False, Optional ByRef dstPic As fxPreviewCtl)
        
    'Prepare a param parser
    Dim cParams As pdParamString
    Set cParams = New pdParamString
    cParams.setParamString fullParamString
        
    'Note that the only purpose of the FilterType string is to display this message
    If Not toPreview Then Message "Applying %1 filter...", cParams.GetString(1)
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA, toPreview, dstPic
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, x2 As Long, y2 As Long
    Dim initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curDIBValues.Left
    initY = curDIBValues.Top
    finalX = curDIBValues.Right
    finalY = curDIBValues.Bottom
    
    Dim checkXMin As Long, checkXMax As Long, checkYMin As Long, checkYMax As Long
    checkXMin = curDIBValues.minX
    checkXMax = curDIBValues.maxX
    checkYMin = curDIBValues.MinY
    checkYMax = curDIBValues.MaxY
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = curDIBValues.BytesPerPixel
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
    
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long
    
    'We can now parse out the relevant filter values from the param string
    Dim invertResult As Boolean
    invertResult = cParams.GetBool(2)
    
    Dim FilterWeightA As Double, FilterBiasA As Double
    FilterWeightA = cParams.GetDouble(3)
    FilterBiasA = cParams.GetDouble(4)
    
    Dim iFM(-2 To 2, -2 To 2) As Double
    For x = -2 To 2
    For y = -2 To 2
        iFM(x, y) = cParams.GetDouble((x + 2) + (y + 2) * 5 + 5)
    Next y
    Next x
        
    'FilterWeightTemp will be reset for every pixel, and decremented appropriately when attempting to calculate the value for pixels
    ' outside the image perimeter
    Dim FilterWeightTemp As Double
    
    'Temporary calculation variables
    Dim CalcX As Long, CalcY As Long
    
    'Create a temporary DIB and resize it to the same size as the current image
    Dim tmpDIB As pdDIB
    Set tmpDIB = New pdDIB
    tmpDIB.createFromExistingDIB workingDIB
    
    'Create a local array and point it at the pixel data of our temporary DIB.  This will be used to access the current pixel data
    ' without modifications, while the actual image data will be modified by the filter as it's processed.
    Dim tmpData() As Byte
    Dim tSA As SAFEARRAY2D
    prepSafeArray tSA, tmpDIB
    CopyMemory ByVal VarPtrArray(tmpData()), VarPtr(tSA), 4
    
    'QuickValInner is like QuickVal below, but for sub-loops
    Dim QuickValInner As Long
        
    'Apply the filter
    For x = initX To finalX
        QuickVal = x * qvDepth
    For y = initY To finalY
        
        'Reset our values upon beginning analysis on a new pixel
        r = 0
        g = 0
        b = 0
        FilterWeightTemp = FilterWeightA
        
        'Run a sub-loop around the current pixel
        For x2 = x - 2 To x + 2
            QuickValInner = x2 * qvDepth
        For y2 = y - 2 To y + 2
        
            CalcX = x2 - x
            CalcY = y2 - y
            
            'If no filter value is being applied to this pixel, ignore it (GoTo's aren't generally a part of good programming,
            ' but because VB does not provide a "continue next" type mechanism, GoTo's are all we've got.)
            If iFM(CalcX, CalcY) = 0 Then GoTo NextCustomFilterPixel
            
            'If this pixel lies outside the image perimeter, ignore it and adjust g_FilterWeight accordingly
            If x2 < checkXMin Or y2 < checkYMin Or x2 > checkXMax Or y2 > checkYMax Then
                FilterWeightTemp = FilterWeightTemp - iFM(CalcX, CalcY)
                GoTo NextCustomFilterPixel
            End If
            
            'Adjust red, green, and blue according to the values in the filter matrix (FM)
            r = r + (tmpData(QuickValInner + 2, y2) * iFM(CalcX, CalcY))
            g = g + (tmpData(QuickValInner + 1, y2) * iFM(CalcX, CalcY))
            b = b + (tmpData(QuickValInner, y2) * iFM(CalcX, CalcY))

NextCustomFilterPixel:  Next y2
        Next x2
        
        'If a weight has been set, apply it now
        If (FilterWeightTemp <> 1) Then
            If (FilterWeightTemp <> 0) Then
                r = r / FilterWeightTemp
                g = g / FilterWeightTemp
                b = b / FilterWeightTemp
            Else
                r = 0
                g = 0
                b = 0
            End If
        End If
        
        'If a bias has been specified, apply it now
        If FilterBiasA <> 0 Then
            r = r + FilterBiasA
            g = g + FilterBiasA
            b = b + FilterBiasA
        End If
        
        'Make sure all values are between 0 and 255
        If r < 0 Then
            r = 0
        ElseIf r > 255 Then
            r = 255
        End If
        
        If g < 0 Then
            g = 0
        ElseIf g > 255 Then
            g = 255
        End If
        
        If b < 0 Then
            b = 0
        ElseIf b > 255 Then
            b = 255
        End If
        
        'If inversion is specified, apply it now
        If invertResult Then
            r = 255 - r
            g = 255 - g
            b = 255 - b
        End If
        
        'Finally, remember the new value in our tData array
        ImageData(QuickVal + 2, y) = r
        ImageData(QuickVal + 1, y) = g
        ImageData(QuickVal, y) = b
        
    Next y
        If Not toPreview Then
            If (x And progBarCheck) = 0 Then
                If userPressedESC() Then Exit For
                SetProgBarVal x
            End If
        End If
    Next x
    
    'With our work complete, point ImageData() and tmpData() away from their respective DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    CopyMemory ByVal VarPtrArray(tmpData), 0&, 4
    Erase tmpData
    
    'Erase our temporary DIB
    tmpDIB.eraseDIB
    Set tmpDIB = Nothing
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData toPreview, dstPic
    
End Sub

'Apply a grid blur to an image; basically, blur every vertical line, then every horizontal line, then average the results
Public Sub FilterGridBlur()

    Message "Generating grids..."

    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curDIBValues.Left
    initY = curDIBValues.Top
    finalX = curDIBValues.Right
    finalY = curDIBValues.Bottom
    
    Dim iWidth As Long, iHeight As Long
    iWidth = curDIBValues.Width
    iHeight = curDIBValues.Height
            
    Dim NumOfPixels As Long
    NumOfPixels = iWidth + iHeight
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = curDIBValues.BytesPerPixel
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
    
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long
    Dim rax() As Long, gax() As Long, bax() As Long
    Dim ray() As Long, gay() As Long, bay() As Long
    ReDim rax(0 To iWidth) As Long, gax(0 To iWidth) As Long, bax(0 To iWidth) As Long
    ReDim ray(0 To iHeight) As Long, gay(0 To iHeight), bay(0 To iHeight)
    
    'Generate the averages for vertical lines
    For x = initX To finalX
        r = 0
        g = 0
        b = 0
        QuickVal = x * qvDepth
        For y = initY To finalY
            r = r + ImageData(QuickVal + 2, y)
            g = g + ImageData(QuickVal + 1, y)
            b = b + ImageData(QuickVal, y)
        Next y
        rax(x) = r
        gax(x) = g
        bax(x) = b
    Next x
    
    'Generate the averages for horizontal lines
    For y = initY To finalY
        r = 0
        g = 0
        b = 0
        For x = initX To finalX
            QuickVal = x * qvDepth
            r = r + ImageData(QuickVal + 2, y)
            g = g + ImageData(QuickVal + 1, y)
            b = b + ImageData(QuickVal, y)
        Next x
        ray(y) = r
        gay(y) = g
        bay(y) = b
    Next y
    
    Message "Applying grid blur..."
        
    'Apply the filter
    For x = initX To finalX
        QuickVal = x * qvDepth
    For y = initY To finalY
        
        'Average the horizontal and vertical values for each color component
        r = (rax(x) + ray(y)) \ NumOfPixels
        g = (gax(x) + gay(y)) \ NumOfPixels
        b = (bax(x) + bay(y)) \ NumOfPixels
        
        'The colors shouldn't exceed 255, but it doesn't hurt to double-check
        If r > 255 Then r = 255
        If g > 255 Then g = 255
        If b > 255 Then b = 255
        
        'Assign the new RGB values back into the array
        ImageData(QuickVal + 2, y) = r
        ImageData(QuickVal + 1, y) = g
        ImageData(QuickVal, y) = b
        
    Next y
        If (x And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal x
        End If
    Next x
        
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData

End Sub

'Convert an image to its isometric equivalent.  This can be very useful for developers of isometric games.
Public Sub FilterIsometric()

    'If a selection is active, remove it.  (This is not the most elegant solution, but we can fix it at a later date.)
    If pdImages(g_CurrentImage).selectionActive Then
        pdImages(g_CurrentImage).selectionActive = False
        pdImages(g_CurrentImage).mainSelection.lockRelease
    End If
    
    'Create a local array and point it at the pixel data of the current image
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    prepImageData srcSA
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
    
    'Make note of the current image's width and height
    Dim hWidth As Double
    Dim oWidth As Long, oHeight As Long
    oWidth = curDIBValues.Width - 1
    oHeight = curDIBValues.Height - 1
    hWidth = oWidth / 2
    
    Dim nWidth As Long, nHeight As Long
    nWidth = oWidth + oHeight + 1
    nHeight = nWidth \ 2
    
    'Create a second local array.  This will contain the pixel data of the new isometric image
    Dim dstImageData() As Byte
    Dim dstSA As SAFEARRAY2D
    
    Dim dstDIB As pdDIB
    Set dstDIB = New pdDIB
    dstDIB.createBlank nWidth + 1, nHeight + 1, pdImages(g_CurrentImage).mainDIB.getDIBColorDepth
    
    prepSafeArray dstSA, dstDIB
    CopyMemory ByVal VarPtrArray(dstImageData()), VarPtr(dstSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curDIBValues.Left
    initY = curDIBValues.Top
    finalX = curDIBValues.Right
    finalY = curDIBValues.Bottom
    
    Dim srcX As Double, srcY As Double
    
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim dstQuickVal As Long, qvDepth As Long
    qvDepth = curDIBValues.BytesPerPixel
        
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    SetProgBarMax nWidth
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
        
    'Interpolated loop calculation
    Dim lOffset As Long
        
    Message "Converting image to isometric view..."
        
    'Run through the destination image pixels, converting to isometric as we go
    For x = 0 To nWidth
        dstQuickVal = x * qvDepth
    For y = 0 To nHeight
        
        srcX = getIsometricX(x, y, hWidth)
        srcY = getIsometricY(x, y, hWidth)
                
        'If the pixel is inside the image, reverse-map it using bilinear interpolation.
        ' (Note: this will also reverse-map alpha values if they are present in the image.)
        If (srcX >= 0 And srcX < oWidth And srcY >= 0 And srcY < oHeight) Then
            
            For lOffset = 0 To qvDepth - 1
                dstImageData(dstQuickVal + lOffset, y) = getInterpolatedVal(srcX, srcY, srcImageData, lOffset, qvDepth)
            Next lOffset
                    
        'Out-of-bound pixels don't need interpolation - just set them manually
        Else
            'If the image is 32bpp, set outlying pixels as fully transparent
            If qvDepth = 4 Then dstImageData(dstQuickVal + 3, y) = 0
            dstImageData(dstQuickVal + 2, y) = 255
            dstImageData(dstQuickVal + 1, y) = 255
            dstImageData(dstQuickVal, y) = 255
        End If
        
    
    Next y
        If (x And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal x
        End If
    Next x
    
    'With our work complete, point both ImageData() arrays away from their respective DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    CopyMemory ByVal VarPtrArray(dstImageData), 0&, 4
    Erase dstImageData
    
    'If the action was canceled, exit before copying the processed image over
    If cancelCurrentAction Then
        dstDIB.eraseDIB
        Message "Action canceled."
        SetProgBarVal 0
        Exit Sub
    End If
    
    'If the original image was 32bpp, we need to re-apply premultiplication (because prepImageData above removed it)
    If dstDIB.getDIBColorDepth = 32 Then dstDIB.fixPremultipliedAlpha True
    
    'dstImageData now contains the isometric image.  We need to transfer that back into the current image.
    pdImages(g_CurrentImage).mainDIB.eraseDIB
    pdImages(g_CurrentImage).mainDIB.createFromExistingDIB dstDIB
    
    'With that transfer complete, we can erase our temporary DIB
    dstDIB.eraseDIB
    Set dstDIB = Nothing
    
    'Update the current image size
    pdImages(g_CurrentImage).updateSize
    DisplaySize pdImages(g_CurrentImage).Width, pdImages(g_CurrentImage).Height
    
    Message "Finished. "
    
    'Redraw the image
    FitOnScreen
    
    'Reset the progress bar to zero
    SetProgBarVal 0

End Sub

'These two functions translate a normal (x,y) coordinate to an isometric plane
Private Function getIsometricX(ByVal xc As Long, ByVal yc As Long, ByVal tWidth As Long) As Double
    getIsometricX = (xc / 2) - yc + tWidth
End Function

Private Function getIsometricY(ByVal xc As Long, ByVal yc As Long, ByVal tWidth As Long) As Double
    getIsometricY = (xc / 2) + yc - tWidth
End Function

'This function takes an x and y value - as floating-point - and uses their position to calculate an interpolated value
' for an imaginary pixel in that location.  Offset (r/g/b/alpha) and image color depth are also required.
Public Function getInterpolatedVal(ByVal x1 As Double, ByVal y1 As Double, ByRef iData() As Byte, ByRef iOffset As Long, ByRef iDepth As Long) As Byte
        
    'Retrieve the four surrounding pixel values
    Dim topLeft As Double, topRight As Double, bottomLeft As Double, bottomRight As Double
    topLeft = iData(Int(x1) * iDepth + iOffset, Int(y1))
    topRight = iData(Int(x1 + 1) * iDepth + iOffset, Int(y1))
    bottomLeft = iData(Int(x1) * iDepth + iOffset, Int(y1 + 1))
    bottomRight = iData(Int(x1 + 1) * iDepth + iOffset, Int(y1 + 1))
    
    'Calculate blend ratios
    Dim yBlend As Double
    Dim xBlend As Double, xBlendInv As Double
    yBlend = y1 - Int(y1)
    xBlend = x1 - Int(x1)
    xBlendInv = 1 - xBlend
    
    'Blend in the x-direction
    Dim topRowColor As Double, bottomRowColor As Double
    topRowColor = topRight * xBlend + topLeft * xBlendInv
    bottomRowColor = bottomRight * xBlend + bottomLeft * xBlendInv
    
    'Blend in the y-direction
    getInterpolatedVal = bottomRowColor * yBlend + topRowColor * (1 - yBlend)

End Function

'This function takes an x and y value - as floating-point - and uses their position to calculate an interpolated value
' for an imaginary pixel in that location.  Offset (r/g/b/alpha) and image color depth are also required.
Public Function getInterpolatedValWrap(ByVal x1 As Double, ByVal y1 As Double, ByVal xMax As Long, yMax As Long, ByRef iData() As Byte, ByRef iOffset As Long, ByRef iDepth As Long) As Byte
        
    'Retrieve the four surrounding pixel values
    Dim topLeft As Double, topRight As Double, bottomLeft As Double, bottomRight As Double
    topLeft = iData(Int(x1) * iDepth + iOffset, Int(y1))
    If Int(x1) = xMax Then
        topRight = iData(0 + iOffset, Int(y1))
    Else
        topRight = iData(Int(x1 + 1) * iDepth + iOffset, Int(y1))
    End If
    If Int(y1) = yMax Then
        bottomLeft = iData(Int(x1) * iDepth + iOffset, 0)
    Else
        bottomLeft = iData(Int(x1) * iDepth + iOffset, Int(y1 + 1))
    End If
    
    If Int(x1) = xMax Then
        If Int(y1) = yMax Then
            bottomRight = iData(0 + iOffset, 0)
        Else
            bottomRight = iData(0 + iOffset, Int(y1 + 1))
        End If
    Else
        If Int(y1) = yMax Then
            bottomRight = iData(Int(x1 + 1) * iDepth + iOffset, 0)
        Else
            bottomRight = iData(Int(x1 + 1) * iDepth + iOffset, Int(y1 + 1))
        End If
    End If
    
    'Calculate blend ratios
    Dim yBlend As Double
    Dim xBlend As Double, xBlendInv As Double
    yBlend = y1 - Int(y1)
    xBlend = x1 - Int(x1)
    xBlendInv = 1 - xBlend
    
    'Blend in the x-direction
    Dim topRowColor As Double, bottomRowColor As Double
    topRowColor = topRight * xBlend + topLeft * xBlendInv
    bottomRowColor = bottomRight * xBlend + bottomLeft * xBlendInv
    
    'Blend in the y-direction
    getInterpolatedValWrap = bottomRowColor * yBlend + topRowColor * (1 - yBlend)

End Function

