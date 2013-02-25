Attribute VB_Name = "Filters_Layers"
'***************************************************************************
'Layer Filters Module
'Copyright �2012-2013 by Tanner Helland
'Created: 15/February/13
'Last updated: 15/Feburary/13
'Last update: initial build
'
'Some filters in PhotoDemon are capable of operating "on-demand" on any supplied layers.  In a perfect world, *all*
' filters would work this way - but alas I did not design the program very well up front.  Going forward I will be
' moving more filters to an "on-demand" model.
'
'The benefit of filters like this is that any function can call them.  This means that a tool like "gaussian blur"
' need only be written once, and then any other function can use it at will.  This is useful for stacking multiple
' filters to create more complex effects.  It also cuts down on code maintenance because I need only perfect a
' formula once, then call it externally.
'
'***************************************************************************

Option Explicit

'Constants required for creating a gamma curve from .1 to 10
Private Const MAXGAMMA As Double = 1.8460498941512
Private Const MIDGAMMA As Double = 0.68377223398334
Private Const ROOT10 As Double = 3.16227766

'Given two layers, fill one with a median-filtered version of the other
Public Sub CreateMedianLayer(ByVal mRadius As Long, ByVal mPercent As Double, ByRef srcLayer As pdLayer, ByRef dstLayer As pdLayer, Optional ByVal suppressMessages As Boolean = False, Optional ByVal modifyProgBarMax As Long = -1, Optional ByVal modifyProgBarOffset As Long = 0)

    'Create a local array and point it at the pixel data of the current image
    Dim dstImageData() As Byte
    Dim dstSA As SAFEARRAY2D
    prepSafeArray dstSA, dstLayer
    CopyMemory ByVal VarPtrArray(dstImageData()), VarPtr(dstSA), 4
    
    'Create a second local array.  This will contain the a copy of the current image, and we will use it as our source reference
    ' (This is necessary to prevent medianred pixel values from spreading across the image as we go.)
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    prepSafeArray srcSA, srcLayer
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = 0
    initY = 0
    finalX = srcLayer.getLayerWidth - 1
    finalY = srcLayer.getLayerHeight - 1
    
    'Just to be safe, make sure the radius isn't larger than the image itself
    If (finalY - initY) < (finalX - initX) Then
        If mRadius > (finalY - initY) Then mRadius = finalY - initY
    Else
        If mRadius > (finalX - initX) Then mRadius = finalX - initX
    End If
        
    mPercent = mPercent / 100
        
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, QuickValInner As Long, QuickY As Long, qvDepth As Long
    qvDepth = srcLayer.getLayerColorDepth \ 8
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    If modifyProgBarMax = -1 Then
        SetProgBarMax finalX
    Else
        SetProgBarMax modifyProgBarMax
    End If
    progBarCheck = findBestProgBarValue()
    
    'The number of pixels in the current median box are tracked dynamically.
    Dim NumOfPixels As Long
    NumOfPixels = 0
            
    'Median filtering takes a lot of variables
    Dim rValues(0 To 255) As Long, gValues(0 To 255) As Long, bValues(0 To 255) As Long
    Dim lbX As Long, lbY As Long, ubX As Long, ubY As Long
    Dim obuX As Boolean, obuY As Boolean, oblY As Boolean
    Dim i As Long, j As Long
    Dim cutoffTotal As Long
    Dim r As Long, g As Long, b As Long
    Dim midR As Long, midG As Long, midB As Long
    
    Dim atBottom As Boolean
    atBottom = True
    
    Dim startY As Long, stopY As Long, yStep As Long
    
    NumOfPixels = 0
    
    'Generate an initial array of median data for the first pixel
    For x = initX To initX + mRadius - 1
        QuickVal = x * qvDepth
    For y = initY To initY + mRadius '- 1
    
        r = srcImageData(QuickVal + 2, y)
        g = srcImageData(QuickVal + 1, y)
        b = srcImageData(QuickVal, y)
        rValues(r) = rValues(r) + 1
        gValues(g) = gValues(g) + 1
        bValues(b) = bValues(b) + 1
        
        'Increase the pixel tally
        NumOfPixels = NumOfPixels + 1
        
    Next y
    Next x
                
    'Loop through each pixel in the image, tallying median values as we go
    For x = initX To finalX
            
        QuickVal = x * qvDepth
        
        'Determine the bounds of the current median box in the X direction
        lbX = x - mRadius
        If lbX < 0 Then lbX = 0
        ubX = x + mRadius
        
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
            ubY = mRadius
        Else
            lbY = finalY - mRadius
            ubY = finalY
        End If
        
        'Remove trailing values from the median box if they lie outside the processing radius
        If lbX > 0 Then
        
            QuickValInner = (lbX - 1) * qvDepth
        
            For j = lbY To ubY
                r = srcImageData(QuickValInner + 2, j)
                g = srcImageData(QuickValInner + 1, j)
                b = srcImageData(QuickValInner, j)
                rValues(r) = rValues(r) - 1
                gValues(g) = gValues(g) - 1
                bValues(b) = bValues(b) - 1
                NumOfPixels = NumOfPixels - 1
            Next j
        
        End If
        
        'Add leading values to the median box if they lie inside the processing radius
        If Not obuX Then
        
            QuickValInner = ubX * qvDepth
            
            For j = lbY To ubY
                r = srcImageData(QuickValInner + 2, j)
                g = srcImageData(QuickValInner + 1, j)
                b = srcImageData(QuickValInner, j)
                rValues(r) = rValues(r) + 1
                gValues(g) = gValues(g) + 1
                bValues(b) = bValues(b) + 1
                NumOfPixels = NumOfPixels + 1
            Next j
            
        End If
        
        'Depending on the direction we are moving, remove a line of pixels from the median box
        ' (because the interior loop will add it back in).
        If atBottom Then
                
            For i = lbX To ubX
                QuickValInner = i * qvDepth
                r = srcImageData(QuickValInner + 2, mRadius)
                g = srcImageData(QuickValInner + 1, mRadius)
                b = srcImageData(QuickValInner, mRadius)
                rValues(r) = rValues(r) - 1
                gValues(g) = gValues(g) - 1
                bValues(b) = bValues(b) - 1
                NumOfPixels = NumOfPixels - 1
            Next i
        
        Else
        
            QuickY = finalY - mRadius
        
            For i = lbX To ubX
                QuickValInner = i * qvDepth
                r = srcImageData(QuickValInner + 2, QuickY)
                g = srcImageData(QuickValInner + 1, QuickY)
                b = srcImageData(QuickValInner, QuickY)
                rValues(r) = rValues(r) - 1
                gValues(g) = gValues(g) - 1
                bValues(b) = bValues(b) - 1
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
            lbY = y - mRadius
            If lbY < 0 Then lbY = 0
            
            ubY = y + mRadius
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
                    r = srcImageData(QuickValInner + 2, QuickY)
                    g = srcImageData(QuickValInner + 1, QuickY)
                    b = srcImageData(QuickValInner, QuickY)
                    rValues(r) = rValues(r) - 1
                    gValues(g) = gValues(g) - 1
                    bValues(b) = bValues(b) - 1
                    NumOfPixels = NumOfPixels - 1
                Next i
                        
            End If
                    
            'Add leading values
            If Not obuY Then
            
                For i = lbX To ubX
                    QuickValInner = i * qvDepth
                    r = srcImageData(QuickValInner + 2, ubY)
                    g = srcImageData(QuickValInner + 1, ubY)
                    b = srcImageData(QuickValInner, ubY)
                    rValues(r) = rValues(r) + 1
                    gValues(g) = gValues(g) + 1
                    bValues(b) = bValues(b) + 1
                    NumOfPixels = NumOfPixels + 1
                Next i
            
            End If
            
        'The exact same code as above, but in the opposite direction
        Else
        
            lbY = y - mRadius
            If lbY < 0 Then
                oblY = True
                lbY = 0
            Else
                oblY = False
            End If
            
            ubY = y + mRadius
            If ubY > finalY Then ubY = finalY
                                
            If ubY < finalY Then
            
                QuickY = ubY + 1
            
                For i = lbX To ubX
                    QuickValInner = i * qvDepth
                    r = srcImageData(QuickValInner + 2, QuickY)
                    g = srcImageData(QuickValInner + 1, QuickY)
                    b = srcImageData(QuickValInner, QuickY)
                    rValues(r) = rValues(r) - 1
                    gValues(g) = gValues(g) - 1
                    bValues(b) = bValues(b) - 1
                    NumOfPixels = NumOfPixels - 1
                Next i
                        
            End If
                    
            If Not oblY Then
            
                For i = lbX To ubX
                    QuickValInner = i * qvDepth
                    r = srcImageData(QuickValInner + 2, lbY)
                    g = srcImageData(QuickValInner + 1, lbY)
                    b = srcImageData(QuickValInner, lbY)
                    rValues(r) = rValues(r) + 1
                    gValues(g) = gValues(g) + 1
                    bValues(b) = bValues(b) + 1
                    NumOfPixels = NumOfPixels + 1
                Next i
            
            End If
        
        End If
                
        'With the median box successfully calculated, we can now find the actual median for this pixel.
        
        'Loop through each color component histogram, until we've passed the desired percentile of pixels
        midR = 0
        midG = 0
        midB = 0
        cutoffTotal = mPercent * NumOfPixels
        If cutoffTotal = 0 Then cutoffTotal = 1
        
        i = 0
        Do
            If rValues(i) <> 0 Then midR = midR + rValues(i)
            i = i + 1
        Loop While (midR < cutoffTotal)
        midR = i - 1
        
        i = 0
        Do
            If gValues(i) <> 0 Then midG = midG + gValues(i)
            i = i + 1
        Loop While (midG < cutoffTotal)
        midG = i - 1
        
        i = 0
        Do
            If bValues(i) <> 0 Then midB = midB + bValues(i)
            i = i + 1
        Loop While (midB < cutoffTotal)
        midB = i - 1
                
        'Finally, apply the results to the image.
        dstImageData(QuickVal + 2, y) = midR
        dstImageData(QuickVal + 1, y) = midG
        dstImageData(QuickVal, y) = midB
        
    Next y
        atBottom = Not atBottom
        If Not suppressMessages Then
            If (x And progBarCheck) = 0 Then SetProgBarVal x + modifyProgBarOffset
        End If
    Next x
        
    'With our work complete, point both ImageData() arrays away from their DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    
    CopyMemory ByVal VarPtrArray(dstImageData), 0&, 4
    Erase dstImageData

End Sub

'White balance a given layer
Public Sub WhiteBalanceLayer(ByVal percentIgnore As Double, ByRef srcLayer As pdLayer, Optional ByVal suppressMessages As Boolean = False, Optional ByVal modifyProgBarMax As Long = -1, Optional ByVal modifyProgBarOffset As Long = 0)

    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepSafeArray tmpSA, srcLayer
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = 0
    initY = 0
    finalX = srcLayer.getLayerWidth - 1
    finalY = srcLayer.getLayerHeight - 1
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = srcLayer.getLayerColorDepth \ 8
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    If modifyProgBarMax = -1 Then
        SetProgBarMax finalX
    Else
        SetProgBarMax modifyProgBarMax
    End If
    progBarCheck = findBestProgBarValue()
    
    'Color values
    Dim r As Long, g As Long, b As Long
    
    'Maximum and minimum values, which will be detected by our initial histogram run
    Dim rMax As Byte, gMax As Byte, bMax As Byte
    Dim rMin As Byte, gMin As Byte, bMin As Byte
    rMax = 0: gMax = 0: bMax = 0
    rMin = 255: gMin = 255: bMin = 255
    
    'Shrink the percentIgnore value down to 1% of the value we are passed (you'll see why in a moment)
    percentIgnore = percentIgnore / 100
    
    'Prepare histogram arrays
    Dim rCount(0 To 255) As Long, gCount(0 To 255) As Long, bCount(0 To 255) As Long
    For x = 0 To 255
        rCount(x) = 0
        gCount(x) = 0
        bCount(x) = 0
    Next x
    
    'Build the image histogram
    For x = initX To finalX
        QuickVal = x * qvDepth
    For y = initY To finalY
        r = ImageData(QuickVal + 2, y)
        g = ImageData(QuickVal + 1, y)
        b = ImageData(QuickVal, y)
        rCount(r) = rCount(r) + 1
        gCount(g) = gCount(g) + 1
        bCount(b) = bCount(b) + 1
    Next y
    Next x
    
     'With the histogram complete, we can now figure out how to stretch the RGB channels. We do this by calculating a min/max
    ' ratio where the top and bottom 0.05% (or user-specified value) of pixels are ignored.
    
    Dim foundYet As Boolean
    foundYet = False
    
    Dim NumOfPixels As Long
    NumOfPixels = (finalX + 1) * (finalY + 1)
    
    Dim wbThreshold As Long
    wbThreshold = NumOfPixels * percentIgnore
    
    r = 0: g = 0: b = 0
    
    Dim rTally As Long, gTally As Long, bTally As Long
    rTally = 0: gTally = 0: bTally = 0
    
    'Find minimum values of red, green, and blue
    Do
        If rCount(r) + rTally < wbThreshold Then
            r = r + 1
            rTally = rTally + rCount(r)
        Else
            rMin = r
            foundYet = True
        End If
    Loop While foundYet = False
        
    foundYet = False
        
    Do
        If gCount(g) + gTally < wbThreshold Then
            g = g + 1
            gTally = gTally + gCount(g)
        Else
            gMin = g
            foundYet = True
        End If
    Loop While foundYet = False
    
    foundYet = False
    
    Do
        If bCount(b) + bTally < wbThreshold Then
            b = b + 1
            bTally = bTally + bCount(b)
        Else
            bMin = b
            foundYet = True
        End If
    Loop While foundYet = False
    
    'Now, find maximum values of red, green, and blue
    foundYet = False
    
    r = 255: g = 255: b = 255
    rTally = 0: gTally = 0: bTally = 0
    
    Do
        If rCount(r) + rTally < wbThreshold Then
            r = r - 1
            rTally = rTally + rCount(r)
        Else
            rMax = r
            foundYet = True
        End If
    Loop While foundYet = False
        
    foundYet = False
        
    Do
        If gCount(g) + gTally < wbThreshold Then
            g = g - 1
            gTally = gTally + gCount(g)
        Else
            gMax = g
            foundYet = True
        End If
    Loop While foundYet = False
    
    foundYet = False
    
    Do
        If bCount(b) + bTally < wbThreshold Then
            b = b - 1
            bTally = bTally + bCount(b)
        Else
            bMax = b
            foundYet = True
        End If
    Loop While foundYet = False
    
    'Finally, calculate the difference between max and min for each color
    Dim rdif As Long, Gdif As Long, Bdif As Long
    rdif = CLng(rMax) - CLng(rMin)
    Gdif = CLng(gMax) - CLng(gMin)
    Bdif = CLng(bMax) - CLng(bMin)
    
    'We can now build a final set of look-up tables that contain the results of every possible color transformation
    Dim rFinal(0 To 255) As Byte, gFinal(0 To 255) As Byte, bFinal(0 To 255) As Byte
    
    For x = 0 To 255
        If rdif <> 0 Then r = 255 * ((x - rMin) / rdif) Else r = x
        If Gdif <> 0 Then g = 255 * ((x - gMin) / Gdif) Else g = x
        If Bdif <> 0 Then b = 255 * ((x - bMin) / Bdif) Else b = x
        If r > 255 Then r = 255
        If r < 0 Then r = 0
        If g > 255 Then g = 255
        If g < 0 Then g = 0
        If b > 255 Then b = 255
        If b < 0 Then b = 0
        rFinal(x) = r
        gFinal(x) = g
        bFinal(x) = b
    Next x
    
    'Now we can loop through each pixel in the image, converting values as we go
    For x = initX To finalX
        QuickVal = x * qvDepth
    For y = initY To finalY
            
        'Adjust white balance in a single pass (thanks to the magic of look-up tables)
        ImageData(QuickVal + 2, y) = rFinal(ImageData(QuickVal + 2, y))
        ImageData(QuickVal + 1, y) = gFinal(ImageData(QuickVal + 1, y))
        ImageData(QuickVal, y) = bFinal(ImageData(QuickVal, y))
        
    Next y
        If Not suppressMessages Then
            If (x And progBarCheck) = 0 Then SetProgBarVal x + modifyProgBarOffset
        End If
    Next x
    
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
End Sub

'Given two layers, fill one with an artistically contoured (edge detect) version of the other
Public Sub CreateContourLayer(ByVal blackBackground As Boolean, ByRef srcLayer As pdLayer, ByRef dstLayer As pdLayer, Optional ByVal suppressMessages As Boolean = False, Optional ByVal modifyProgBarMax As Long = -1, Optional ByVal modifyProgBarOffset As Long = 0)
 
    'Create a local array and point it at the pixel data of the current image
    Dim dstImageData() As Byte
    Dim dstSA As SAFEARRAY2D
    prepSafeArray dstSA, dstLayer
    CopyMemory ByVal VarPtrArray(dstImageData()), VarPtr(dstSA), 4
    
    'Create a second local array.  This will contain the a copy of the current image, and we will use it as our source reference
    ' (This is necessary to prevent already embossed pixels from screwing up our results for later pixels.)
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    prepSafeArray srcSA, srcLayer
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, z As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = 1
    initY = 1
    finalX = srcLayer.getLayerWidth - 2
    finalY = srcLayer.getLayerHeight - 2
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, QuickValRight As Long, QuickValLeft As Long, qvDepth As Long
    qvDepth = srcLayer.getLayerColorDepth \ 8
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    If modifyProgBarMax = -1 Then
        SetProgBarMax finalX
    Else
        SetProgBarMax modifyProgBarMax
    End If
    progBarCheck = findBestProgBarValue()
    
    'Color variables
    Dim tmpColor As Long, tMin As Long
        
    'Loop through each pixel in the image, converting values as we go
    For x = initX To finalX
        QuickVal = x * qvDepth
        QuickValRight = (x + 1) * qvDepth
        QuickValLeft = (x - 1) * qvDepth
    For y = initY To finalY
        For z = 0 To 2
    
            tMin = 255
            tmpColor = srcImageData(QuickValRight + z, y)
            If tmpColor < tMin Then tMin = tmpColor
            tmpColor = srcImageData(QuickValRight + z, y - 1)
            If tmpColor < tMin Then tMin = tmpColor
            tmpColor = srcImageData(QuickValRight + z, y + 1)
            If tmpColor < tMin Then tMin = tmpColor
            tmpColor = srcImageData(QuickValLeft + z, y)
            If tmpColor < tMin Then tMin = tmpColor
            tmpColor = srcImageData(QuickValLeft + z, y - 1)
            If tmpColor < tMin Then tMin = tmpColor
            tmpColor = srcImageData(QuickValLeft + z, y + 1)
            If tmpColor < tMin Then tMin = tmpColor
            tmpColor = srcImageData(QuickVal + z, y)
            If tmpColor < tMin Then tMin = tmpColor
            tmpColor = srcImageData(QuickVal + z, y - 1)
            If tmpColor < tMin Then tMin = tmpColor
            tmpColor = srcImageData(QuickVal + z, y + 1)
            If tmpColor < tMin Then tMin = tmpColor
            
            If tMin > 255 Then tMin = 255
            If tMin < 0 Then tMin = 0
            
            If blackBackground Then
                dstImageData(QuickVal + z, y) = srcImageData(QuickVal + z, y) - tMin
            Else
                dstImageData(QuickVal + z, y) = 255 - (srcImageData(QuickVal + z, y) - tMin)
            End If
            
            'The edges of the image will always be missed, so manually check for and correct that
            If x = initX Then dstImageData(QuickValLeft + z, y) = dstImageData(QuickVal + z, y)
            If x = finalX Then dstImageData(QuickValRight + z, y) = dstImageData(QuickVal + z, y)
            If y = initY Then dstImageData(QuickVal + z, y - 1) = dstImageData(QuickVal + z, y)
            If y = finalY Then dstImageData(QuickVal + z, y + 1) = dstImageData(QuickVal + z, y)
        
        Next z
    Next y
        If Not suppressMessages Then
            If (x And progBarCheck) = 0 Then SetProgBarVal x + modifyProgBarOffset
        End If
    Next x
    
    'With our work complete, point both ImageData() arrays away from their DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    
    CopyMemory ByVal VarPtrArray(dstImageData), 0&, 4
    Erase dstImageData
    
End Sub

'Make shadows, midtone, and/or highlight adjustments to a given layer
Public Sub AdjustLayerShadowHighlight(ByVal shadowClipping As Double, ByVal highlightClipping As Double, ByVal targetMidtone As Long, ByRef srcLayer As pdLayer, Optional ByVal suppressMessages As Boolean = False, Optional ByVal modifyProgBarMax As Long = -1, Optional ByVal modifyProgBarOffset As Long = 0)

    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepSafeArray tmpSA, srcLayer
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = 0
    initY = 0
    finalX = srcLayer.getLayerWidth - 1
    finalY = srcLayer.getLayerHeight - 1
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = srcLayer.getLayerColorDepth \ 8
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    If modifyProgBarMax = -1 Then
        SetProgBarMax finalX
    Else
        SetProgBarMax modifyProgBarMax
    End If
    progBarCheck = findBestProgBarValue()
    
    'Color values
    Dim r As Long, g As Long, b As Long
    
    'Maximum and minimum values, which will be detected by our initial histogram run
    Dim rMax As Byte, gMax As Byte, bMax As Byte
    Dim rMin As Byte, gMin As Byte, bMin As Byte
    rMax = 0: gMax = 0: bMax = 0
    rMin = 255: gMin = 255: bMin = 255
    
    'Shrink the percentIgnore value down to 1% of the value we are passed (you'll see why in a moment)
    shadowClipping = shadowClipping / 100
    highlightClipping = highlightClipping / 100
    
    'Prepare histogram arrays
    Dim rCount(0 To 255) As Long, gCount(0 To 255) As Long, bCount(0 To 255) As Long
    For x = 0 To 255
        rCount(x) = 0
        gCount(x) = 0
        bCount(x) = 0
    Next x
    
    'Build the image histogram
    For x = initX To finalX
        QuickVal = x * qvDepth
    For y = initY To finalY
        r = ImageData(QuickVal + 2, y)
        g = ImageData(QuickVal + 1, y)
        b = ImageData(QuickVal, y)
        rCount(r) = rCount(r) + 1
        gCount(g) = gCount(g) + 1
        bCount(b) = bCount(b) + 1
    Next y
    Next x
    
     'With the histogram complete, we can now figure out how to stretch the RGB channels. We do this by calculating a min/max
    ' ratio where the top and bottom 0.05% (or user-specified value) of pixels are ignored.
    
    Dim foundYet As Boolean
    foundYet = False
    
    Dim NumOfPixels As Long
    NumOfPixels = (finalX + 1) * (finalY + 1)
    
    Dim shadowThreshold As Long
    shadowThreshold = NumOfPixels * shadowClipping
    
    Dim highlightThreshold As Long
    highlightThreshold = NumOfPixels * highlightClipping
    
    r = 0: g = 0: b = 0
    
    Dim rTally As Long, gTally As Long, bTally As Long
    rTally = 0: gTally = 0: bTally = 0
    
    'Find minimum values of red, green, and blue
    Do
        If rCount(r) + rTally < shadowThreshold Then
            r = r + 1
            rTally = rTally + rCount(r)
        Else
            rMin = r
            foundYet = True
        End If
    Loop While foundYet = False
        
    foundYet = False
        
    Do
        If gCount(g) + gTally < shadowThreshold Then
            g = g + 1
            gTally = gTally + gCount(g)
        Else
            gMin = g
            foundYet = True
        End If
    Loop While foundYet = False
    
    foundYet = False
    
    Do
        If bCount(b) + bTally < shadowThreshold Then
            b = b + 1
            bTally = bTally + bCount(b)
        Else
            bMin = b
            foundYet = True
        End If
    Loop While foundYet = False
    
    'Now, find maximum values of red, green, and blue
    foundYet = False
    
    r = 255: g = 255: b = 255
    rTally = 0: gTally = 0: bTally = 0
    
    Do
        If rCount(r) + rTally < highlightThreshold Then
            r = r - 1
            rTally = rTally + rCount(r)
        Else
            rMax = r
            foundYet = True
        End If
    Loop While foundYet = False
        
    foundYet = False
        
    Do
        If gCount(g) + gTally < highlightThreshold Then
            g = g - 1
            gTally = gTally + gCount(g)
        Else
            gMax = g
            foundYet = True
        End If
    Loop While foundYet = False
    
    foundYet = False
    
    Do
        If bCount(b) + bTally < highlightThreshold Then
            b = b - 1
            bTally = bTally + bCount(b)
        Else
            bMax = b
            foundYet = True
        End If
    Loop While foundYet = False
    
    'Finally, calculate the difference between max and min for each color
    Dim rdif As Long, Gdif As Long, Bdif As Long
    rdif = CLng(rMax) - CLng(rMin)
    Gdif = CLng(gMax) - CLng(gMin)
    Bdif = CLng(bMax) - CLng(bMin)
    
    'We can now build a final set of look-up tables that contain the results of every possible color transformation
    Dim rFinal(0 To 255) As Byte, gFinal(0 To 255) As Byte, bFinal(0 To 255) As Byte
    
    For x = 0 To 255
        If rdif <> 0 Then r = 255 * ((x - rMin) / rdif) Else r = x
        If Gdif <> 0 Then g = 255 * ((x - gMin) / Gdif) Else g = x
        If Bdif <> 0 Then b = 255 * ((x - bMin) / Bdif) Else b = x
        If r > 255 Then r = 255
        If r < 0 Then r = 0
        If g > 255 Then g = 255
        If g < 0 Then g = 0
        If b > 255 Then b = 255
        If b < 0 Then b = 0
        rFinal(x) = r
        gFinal(x) = g
        bFinal(x) = b
    Next x
    
    'Now it is time to handle the target midtone calculation.  Start by extracting the red, green, and blue components
    Dim targetRed As Long, targetGreen As Long, targetBlue As Long
    targetRed = 255 - ExtractR(targetMidtone)
    targetGreen = 255 - ExtractG(targetMidtone)
    targetBlue = 255 - ExtractB(targetMidtone)
    
    'We now re-use some logic from the Levels tool to remap midtones according to the target color we've been given.
    
    'Look-up tables for the midtone (gamma) leveled values
    Dim lValues(0 To 255) As Double
    
    'WARNING: This next chunk of code is a lot of messy math.  Don't worry too much
    ' if you can't make sense of it ;)
    
    'Fill the gamma table with appropriate gamma values (from 10 to .1, ranged quadratically)
    ' NOTE: This table is constant, and could theoretically be loaded from file instead of generated
    ' every time we run this function.
    Dim gStep As Double
    gStep = (MAXGAMMA + MIDGAMMA) / 127
    For x = 0 To 127
        lValues(x) = (CDbl(x) / 127) * MIDGAMMA
    Next x
    For x = 128 To 255
        lValues(x) = MIDGAMMA + (CDbl(x - 127) * gStep)
    Next x
    For x = 0 To 255
        lValues(x) = 1 / ((lValues(x) + 1 / ROOT10) ^ 2)
    Next x
    
    'Calculate a look-up table of gamma-corrected values based on the midtones scrollbar
    Dim rValues(0 To 255) As Byte, gValues(0 To 255) As Byte, bValues(0 To 255) As Byte
    Dim tmpRed As Double, tmpGreen As Double, tmpBlue As Double
    For x = 0 To 255
        tmpRed = CDbl(x) / 255
        tmpGreen = CDbl(x) / 255
        tmpBlue = CDbl(x) / 255
        tmpRed = tmpRed ^ (1 / lValues(targetRed))
        tmpGreen = tmpGreen ^ (1 / lValues(targetGreen))
        tmpBlue = tmpBlue ^ (1 / lValues(targetBlue))
        tmpRed = tmpRed * 255
        tmpGreen = tmpGreen * 255
        tmpBlue = tmpBlue * 255
        If tmpRed > 255 Then tmpRed = 255
        If tmpRed < 0 Then tmpRed = 0
        If tmpGreen > 255 Then tmpGreen = 255
        If tmpGreen < 0 Then tmpGreen = 0
        If tmpBlue > 255 Then tmpBlue = 255
        If tmpBlue < 0 Then tmpBlue = 0
        rValues(x) = tmpRed
        gValues(x) = tmpGreen
        bValues(x) = tmpBlue
    Next x
    
    'Now we can loop through each pixel in the image, converting values as we go
    For x = initX To finalX
        QuickVal = x * qvDepth
    For y = initY To finalY
            
        'Adjust white balance in a single pass (thanks to the magic of look-up tables)
        ImageData(QuickVal + 2, y) = rValues(rFinal(ImageData(QuickVal + 2, y)))
        ImageData(QuickVal + 1, y) = gValues(gFinal(ImageData(QuickVal + 1, y)))
        ImageData(QuickVal, y) = bValues(bFinal(ImageData(QuickVal, y)))
        
    Next y
        If Not suppressMessages Then
            If (x And progBarCheck) = 0 Then SetProgBarVal x + modifyProgBarOffset
        End If
    Next x
    
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
End Sub

'Given two layers, fill one with a gaussian-blur version of the other.
Public Sub CreateGaussianBlurLayer(ByVal gRadius As Long, ByRef srcLayer As pdLayer, ByRef dstLayer As pdLayer, Optional ByVal suppressMessages As Boolean = False, Optional ByVal modifyProgBarMax As Long = -1, Optional ByVal modifyProgBarOffset As Long = 0)
            
    'Create a local array and point it at the pixel data of the destination image
    Dim dstImageData() As Byte
    Dim dstSA As SAFEARRAY2D
    prepSafeArray dstSA, dstLayer
    CopyMemory ByVal VarPtrArray(dstImageData()), VarPtr(dstSA), 4
    
    'Do the same for the source image
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    prepSafeArray srcSA, srcLayer
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
        
    'Create one more local array.  This will contain the intermediate copy of the gaussian blur, as it must be done in two passes.
    Dim gaussLayer As pdLayer
    Set gaussLayer = New pdLayer
    gaussLayer.createFromExistingLayer srcLayer
    
    Dim GaussImageData() As Byte
    Dim gaussSA As SAFEARRAY2D
    prepSafeArray gaussSA, gaussLayer
    CopyMemory ByVal VarPtrArray(GaussImageData()), VarPtr(gaussSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = 0
    initY = 0
    finalX = srcLayer.getLayerWidth - 1
    finalY = srcLayer.getLayerHeight - 1
    
    'Make sure we were passed a valid radius
    If gRadius < 1 Then gRadius = 1
    If finalX > finalY Then
        If gRadius > finalX Then gRadius = finalX
    Else
        If gRadius > finalY Then gRadius = finalY
    End If
        
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, QuickValInner As Long, qvDepth As Long
    qvDepth = srcLayer.getLayerColorDepth \ 8
    
    Dim chkAlpha As Boolean
    If qvDepth = 4 Then chkAlpha = True Else chkAlpha = False
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    If modifyProgBarMax = -1 Then
        SetProgBarMax finalY + finalY
    Else
        SetProgBarMax modifyProgBarMax
    End If
    progBarCheck = findBestProgBarValue()
    
    'Create a one-dimensional Gaussian kernel using the requested radius
    Dim gKernel() As Single
    ReDim gKernel(-gRadius To gRadius) As Single
    
    Dim numPixels As Long
    numPixels = (gRadius * 2) + 1
    
    'Calculate a standard deviation (sigma) using the GIMP formula:
    Dim stdDev As Double, stdDev2 As Double, stdDev3 As Double
    If gRadius > 1 Then
        stdDev = Sqr(-(gRadius * gRadius) / (2 * Log(1# / 255#)))
    'Note that this is my addition - for a radius of 1 the GIMP formula results in too small of a sigma value
    Else
        stdDev = 0.5
    End If
    stdDev2 = stdDev * stdDev
    stdDev3 = stdDev * 3
    
    'Populate the kernel using that sigma
    Dim i As Long
    Dim curVal As Double, sumVal As Double
    sumVal = 0
    
    For i = -gRadius To gRadius
        curVal = (1 / (Sqr(PI_DOUBLE) * stdDev)) * (EULER ^ (-1 * ((i * i) / (2 * stdDev2))))
        
        'Ignore values less than 3 sigma
        If curVal < stdDev3 Then
            sumVal = sumVal + curVal
            gKernel(i) = curVal
        Else
            gKernel(i) = 0
        End If
    Next i
    
    'Find new bounds, which may exist if parts of the kernel lie outside the 3-sigma relevance limit
    Dim gLB As Long, gUB As Long
    
    gLB = -gRadius
    gUB = gRadius
    If gRadius > 1 Then
        For i = gLB To 0
            If gKernel(i) = 0 Then gLB = i + 1
        Next i
   
        For i = gUB To 0 Step -1
            If gKernel(i) = 0 Then gUB = i - 1
        Next i
   
    End If
        
    'Finally, normalize the kernel so that all values sum to 1
    For i = gLB To gUB
        gKernel(i) = gKernel(i) / sumVal
    Next i
        
    'We now have a normalized 1-dimensional gaussian kernel available for convolution.
    
    'TEST!!
    'Generate a specialized sum value for the low end of the gaussian kernel
    Dim gLookupLow() As Single
    ReDim gLookupLow(gLB To gUB) As Single
    
    Dim runningSum As Double
    runningSum = 0
    
    For i = gLB To 0
        runningSum = runningSum + gKernel(i)
        gLookupLow(i) = runningSum
    Next i
    
    'Do the same for the high end
    runningSum = 0
    
    For i = gUB To 1 Step -1
        runningSum = runningSum + gKernel(i)
        gLookupLow(i) = runningSum
    Next i
    
    
    'Color variables - in this case, sums for each color component
    Dim rSum As Double, gSum As Double, bSum As Double, aSum As Double
    
    'To increase speed, we now build a look-up table of gaussian values.  This can be used in place of floating-point multiplication.
    Dim glLookup() As Single
    ReDim glLookup(0 To 255, gLB To gUB) As Single
    For x = gLB To gUB
        For y = 0 To 255
            glLookup(y, x) = y * gKernel(x)
        Next y
    Next x
        
    'Next, prepare 1D arrays that will be used to point at source and destination pixel data.  VB accesses 1D arrays more quickly
    ' than 2D arrays, and this technique shaves precious time off the final calculation.
    Dim scanlineSize As Long
    scanlineSize = srcLayer.getLayerArrayWidth
    Dim origDIBPointer As Long
    origDIBPointer = srcLayer.getLayerDIBits
    Dim dstDIBPointer As Long
    dstDIBPointer = gaussLayer.getLayerDIBits
    
    Dim tmpImageData() As Byte
    Dim tmpSA As SAFEARRAY1D
    With tmpSA
        .cbElements = 1
        .cDims = 1
        .lBound = 0
        .cElements = scanlineSize
        .pvData = origDIBPointer
    End With
        
    Dim tmpDstImageData() As Byte
    Dim tmpDstSA As SAFEARRAY1D
    With tmpDstSA
        .cbElements = 1
        .cDims = 1
        .lBound = 0
        .cElements = scanlineSize
        .pvData = dstDIBPointer
    End With
    
    'We now convolve the image twice - once in the horizontal direction, then again in the vertical direction.  This is
    ' referred to as "separable" convolution, and it's much faster than than traditional convolution, especially for
    ' large radii (the exact speed gain for a P x Q kernel is PQ/(P + Q) - so for a radius of 4 (which is an actual kernel
    ' of 9x9) the processing time is 4.5x faster).
    
    'First, perform a horizontal convolution.
        
    Dim chkX As Long, finalChkX As Long
    finalChkX = finalX * qvDepth
    
    'Loop through each pixel in the image, converting values as we go
    For y = 0 To finalY
        
        'Accessing multidimensional arrays in VB is slow.  We cheat this by pointing a one-dimensional array
        ' at the current source and destination lines, then using that to access pixel data.
        tmpSA.pvData = origDIBPointer + scanlineSize * y
        CopyMemory ByVal VarPtrArray(tmpImageData()), VarPtr(tmpSA), 4
        
        tmpDstSA.pvData = dstDIBPointer + scanlineSize * y
        CopyMemory ByVal VarPtrArray(tmpDstImageData()), VarPtr(tmpDstSA), 4
                
    For x = initX To finalX
        
        QuickVal = x * qvDepth
    
        rSum = 0
        gSum = 0
        bSum = 0
                
        'Apply the convolution to the intermediate gaussian array
        For i = gLB To gUB
                        
            chkX = x + i
            
            'We need to give special treatment to pixels that lie off the image
            If chkX >= initX Then
                If chkX < finalX Then
                    QuickValInner = chkX * qvDepth
                    rSum = rSum + glLookup(tmpImageData(QuickValInner + 2), i)
                    gSum = gSum + glLookup(tmpImageData(QuickValInner + 1), i)
                    bSum = bSum + glLookup(tmpImageData(QuickValInner), i)
                Else
                    chkX = i
                    rSum = rSum + tmpImageData(finalChkX + 2) * gLookupLow(chkX)
                    gSum = gSum + tmpImageData(finalChkX + 1) * gLookupLow(chkX)
                    bSum = bSum + tmpImageData(finalChkX) * gLookupLow(chkX)
                    Exit For
                End If
            Else
                chkX = gLB + Abs(chkX)
                rSum = tmpImageData(2) * gLookupLow(chkX)
                gSum = tmpImageData(1) * gLookupLow(chkX)
                bSum = tmpImageData(0) * gLookupLow(chkX)
                i = chkX
            End If
                   
        Next i
        
        'We now have sums for each of red, green, blue (and potentially alpha).  Apply those values to the source array.
        tmpDstImageData(QuickVal + 2) = rSum
        tmpDstImageData(QuickVal + 1) = gSum
        tmpDstImageData(QuickVal) = bSum
        
        'If alpha must be checked, do it now
        If chkAlpha Then
            
            aSum = 0
            
            For i = gLB To gUB
            
                'curFactor = gKernel(i)
                chkX = x + i
                If chkX < initX Then chkX = initX
                If chkX > finalX Then chkX = finalX
                aSum = aSum + glLookup(tmpImageData(chkX * qvDepth + 3), i)
                
            Next i
            
            tmpDstImageData(QuickVal + 3) = aSum
            
        End If
        
    Next x
        If Not suppressMessages Then
            If (y And progBarCheck) = 0 Then SetProgBarVal y + modifyProgBarOffset
        End If
    Next y
    
    CopyMemory ByVal VarPtrArray(tmpImageData()), 0&, 4
    CopyMemory ByVal VarPtrArray(tmpDstImageData()), 0&, 4
    
    dstDIBPointer = dstLayer.getLayerDIBits
    tmpDstSA.pvData = dstDIBPointer
    
    'The source array now contains a horizontally convolved image.  We now need to convolve it vertically.
    Dim chkY As Long
    
    For y = initY To finalY
    
        'Accessing multidimensional arrays in VB is slow.  We cheat this by pointing a one-dimensional array
        ' at the current destination line, then using that to access pixel data.
        tmpDstSA.pvData = dstDIBPointer + scanlineSize * y
        CopyMemory ByVal VarPtrArray(tmpDstImageData()), VarPtr(tmpDstSA), 4
    
    For x = initX To finalX
    
        QuickVal = x * qvDepth
    
        rSum = 0
        gSum = 0
        bSum = 0
        
        'Apply the convolution to the destination array, using the gaussian array as the source.
        For i = gLB To gUB
        
            chkY = y + i
            
            'We need to give special treatment to pixels that lie off the image
            If chkY >= initY Then
                If chkY > finalY Then chkY = finalY
                rSum = rSum + glLookup(GaussImageData(QuickVal + 2, chkY), i)
                gSum = gSum + glLookup(GaussImageData(QuickVal + 1, chkY), i)
                bSum = bSum + glLookup(GaussImageData(QuickVal, chkY), i)
            Else
                chkY = gLB + Abs(chkY)
                rSum = GaussImageData(QuickVal + 2, 0) * gLookupLow(chkY)
                gSum = GaussImageData(QuickVal + 1, 0) * gLookupLow(chkY)
                bSum = GaussImageData(QuickVal, 0) * gLookupLow(chkY)
                i = chkY
            End If
                                
        Next i
        
        'We now have sums for each of red, green, blue (and potentially alpha).  Apply those values to the source array.
        tmpDstImageData(QuickVal + 2) = rSum
        tmpDstImageData(QuickVal + 1) = gSum
        tmpDstImageData(QuickVal) = bSum
        
        'If alpha must be checked, do it now
        If chkAlpha Then
        
            aSum = 0
        
            'Apply the convolution to the destination array, using the gaussian array as the source.
            For i = gLB To gUB
                'curFactor = gKernel(i)
                chkY = y + i
                If chkY < initY Then chkY = initY
                If chkY > finalY Then chkY = finalY
                aSum = aSum + glLookup(GaussImageData(QuickVal + 3, chkY), i)
            Next i
        
            tmpDstImageData(QuickVal + 3) = aSum
        
        End If
                
    Next x
        If Not suppressMessages Then
            If (y And progBarCheck) = 0 Then SetProgBarVal (y + finalY) + modifyProgBarOffset
        End If
    Next y
        
    'With our work complete, point all ImageData() arrays away from their DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(tmpDstImageData()), 0&, 4
    
    CopyMemory ByVal VarPtrArray(GaussImageData), 0&, 4
    Erase GaussImageData
    
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    
    CopyMemory ByVal VarPtrArray(dstImageData), 0&, 4
    Erase dstImageData
    
    'We can also erase our intermediate gaussian layer
    gaussLayer.eraseLayer
    Set gaussLayer = Nothing
        
End Sub
