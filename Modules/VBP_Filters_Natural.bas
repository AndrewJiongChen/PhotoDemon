Attribute VB_Name = "Filters_Natural"
'***************************************************************************
'"Natural" Filters
'Copyright �2002-2013 by Tanner Helland
'Created: 8/April/02
'Last updated: 08/January/13
'Last update: completely rewrote the fog filter.  It now uses Perlin noise for much more realistic fog generation.
'
'Runs all nature-type filters.  Includes water, steel, burn, rainbow, etc.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'Apply a "Rainbow" effect to an image by assigning it an artificial hue gradient
Public Sub MenuRainbow()
    
    Message "Sprinkling image with shimmering rainbows..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
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
    
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long
    Dim h As Double, s As Double, l As Double
    Dim hVal As Double
    
    'Apply the filter
    For X = initX To finalX
        QuickVal = X * qvDepth
        
        'Based on the x-coordinate of a pixel, apply a predetermined hue gradient (stretching between -1 and 5)
        hVal = (X / (finalX - initX)) * 360
        hVal = (hVal - 60) / 60
        
    For Y = initY To finalY
        
        'Get red, green, and blue values from the array
        r = ImageData(QuickVal + 2, Y)
        g = ImageData(QuickVal + 1, Y)
        b = ImageData(QuickVal, Y)
        
        'Use RGB to calculate hue, saturation, and luminance
        tRGBToHSL r, g, b, h, s, l
        
        'Now convert those HSL values back to RGB, but substitute in our artificial hue value (calculated above)
        tHSLToRGB hVal, s, l, r, g, b
        
        'Assign the new RGB values back into the array
        ImageData(QuickVal + 2, Y) = r
        ImageData(QuickVal + 1, Y) = g
        ImageData(QuickVal, Y) = b
        
    Next Y
        If (X And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal X
        End If
    Next X
        
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData
    
End Sub

'As of PhotoDemon 5.4, this fog effect has been rewritten from the ground up.  Perlin noise is now used to generate
' a more dramatic (and realistic) fog effect.
Public Sub MenuFogEffect()

    Message "Generating artificial fog..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curLayerValues.Left
    initY = curLayerValues.Top
    finalX = curLayerValues.Right
    finalY = curLayerValues.Bottom
            
    'Because interpolation may be used, it's necessary to keep pixel values within special ranges
    Dim xLimit As Long, yLimit As Long
    xLimit = finalX
    yLimit = finalY
    
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = curLayerValues.BytesPerPixel
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
          
    'Our etched glass effect requires some specialized variables
        
    'Invert turbulence
    Dim fxTurbulence As Double
    fxTurbulence = 2#
        
    Dim fxScale As Double
    fxScale = (finalX + finalY) / 10
        
    'Sin and cosine look-up tables
    Dim sinTable(0 To 255) As Double, cosTable(0 To 255) As Double
    
    'Populate the look-up tables
    Dim fxAngle As Double
    
    Dim i As Long
    For i = 0 To 255
        fxAngle = (PI_DOUBLE * i) / (256 * fxTurbulence)
        sinTable(i) = -fxScale * Sin(fxAngle)
        cosTable(i) = fxScale * Cos(fxAngle)
    Next i
    
    'Locate a random z-coordinate in the perlin noise space
    Dim zOffset As Double
    Randomize Timer
    zOffset = Rnd
    
    'Source X and Y values, which may or may not be used as part of a bilinear interpolation function
    Dim srcX As Double, srcY As Double
                                  
    'This effect requires a noise function to operate.  I use Steve McMahon's excellent Perlin Noise class for this.
    Dim cPerlin As cPerlin3D
    Set cPerlin = New cPerlin3D
        
    Dim r As Long, g As Long, b As Long
    Dim finalBlend As Double
        
    'Finally, an integer displacement will be used to move pixel values around
    Dim pDisplace As Long
                                  
    'Loop through each pixel in the image, converting values as we go
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
    
        r = ImageData(QuickVal + 2, Y)
        g = ImageData(QuickVal + 1, Y)
        b = ImageData(QuickVal, Y)
    
        'Calculate a displacement for this point
        pDisplace = 127 * (1 + cPerlin.Noise(X / fxScale, Y / fxScale, zOffset))
        If pDisplace < 0 Then pDisplace = 0
        If pDisplace > 255 Then pDisplace = 255
        
        'Calculate a new source pixel using the sin and cos look-up tables and our calculated displacement
        srcX = X + sinTable(pDisplace)
        srcY = Y + sinTable(pDisplace)
        
        'Calculate the distance between our current pixel and the source pixel
        srcX = (srcX - X) / fxScale
        srcY = (srcY - Y) / fxScale
        finalBlend = (srcX + srcY) / 2
        
        'We only want positive values for the blend
        finalBlend = Abs(finalBlend)
        
        'And reduce the total blend amount slightly (as it tends to be quite heavy)
        finalBlend = finalBlend * 0.7
        
        If finalBlend > 1 Then finalBlend = 1
        If finalBlend < 0 Then finalBlend = 0
        
        'For RGB images, blend with gray to create "fog".  For transparent images, adjust the alpha channel.
        If qvDepth = 3 Then
            ImageData(QuickVal + 2, Y) = BlendColors(r, 193, finalBlend)
            ImageData(QuickVal + 1, Y) = BlendColors(g, 190, finalBlend)
            ImageData(QuickVal, Y) = BlendColors(b, 201, finalBlend)
        Else
            ImageData(QuickVal + 3, Y) = BlendColors(ImageData(QuickVal + 3, Y), 0, finalBlend)
        End If
                
    Next Y
        If (X And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal X
        End If
    Next X
    
    'With our work complete, point both ImageData() arrays away from their DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData
    
End Sub

'Apply a "water" effect to an image.  (See the "ocean" effect below for a similar approach.)
Public Sub MenuWater()
    
    Message "Submerging image in artificial water..."
    
    'Create a local array and point it at the pixel data of the current image
    Dim dstImageData() As Byte
    Dim dstSA As SAFEARRAY2D
    prepImageData dstSA
    CopyMemory ByVal VarPtrArray(dstImageData()), VarPtr(dstSA), 4
    
    'Create a second local array.  This will contain the a copy of the current image, and we will use it as our source reference
    ' (This is necessary to prevent diffused pixels from spreading across the image as we go.)
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    
    Dim srcLayer As pdLayer
    Set srcLayer = New pdLayer
    srcLayer.createFromExistingLayer workingLayer
    
    prepSafeArray srcSA, srcLayer
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curLayerValues.Left
    initY = curLayerValues.Top
    finalX = curLayerValues.Right
    finalY = curLayerValues.Bottom
            
    'Because interpolation may be used, it's necessary to keep pixel values within special ranges
    Dim xLimit As Long, yLimit As Long
    xLimit = finalX - 1
    yLimit = finalY - 1
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = curLayerValues.BytesPerPixel
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
          
    'This wave transformation requires specialized variables
    Dim xWavelength As Double
    xWavelength = 31
    
    Dim xAmplitude As Double
    xAmplitude = 10
        
    'Source X and Y values, which may or may not be used as part of a bilinear interpolation function
    Dim srcX As Double, srcY As Double
        
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long, a As Long
    Dim grayVal As Long
    
    'Because gray values are constant, we can use a look-up table to calculate them
    Dim gLookup(0 To 765) As Byte
    For X = 0 To 765
        gLookup(X) = CByte(X \ 3)
    Next X
                 
    'Loop through each pixel in the image, converting values as we go
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
    
        'Calculate new source pixel locations
        srcX = X + Sin(Y / xWavelength) * xAmplitude
        srcY = Y
        
        'Make sure the source coordinates are in-bounds
        If srcX < 0 Then srcX = 0
        If srcX > xLimit Then srcX = xLimit
        If srcY > yLimit Then srcY = yLimit
        
        'Interpolate the source pixel for better results
        r = getInterpolatedVal(srcX, srcY, srcImageData, 2, qvDepth)
        g = getInterpolatedVal(srcX, srcY, srcImageData, 1, qvDepth)
        b = getInterpolatedVal(srcX, srcY, srcImageData, 0, qvDepth)
        If qvDepth = 4 Then a = getInterpolatedVal(srcX, srcY, srcImageData, 3, qvDepth)
            
        'Now, modify the colors to give a bluish-green tint to the image
        grayVal = gLookup(r + g + b)
        
        r = gray - g - b
        g = gray - r - b
        b = gray - r - g
        
        'Keep all values in range
        If r > 255 Then r = 255
        If r < 0 Then r = 0
        If g > 255 Then g = 255
        If g < 0 Then g = 0
        If b > 255 Then b = 255
        If b < 0 Then b = 0
            
        'Write the colors (and alpha, if necessary) out to the destination image's data
        dstImageData(QuickVal + 2, Y) = r
        dstImageData(QuickVal + 1, Y) = g
        dstImageData(QuickVal, Y) = b
        If qvDepth = 4 Then dstImageData(QuickVal + 3, Y) = a
            
    Next Y
        If (X And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal X
        End If
    Next X
    
    'With our work complete, point both ImageData() arrays away from their DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    
    CopyMemory ByVal VarPtrArray(dstImageData), 0&, 4
    Erase dstImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData
    
End Sub

'Apply a hazy, cool color transformation I call an "atmospheric" transform.
Public Sub MenuAtmospheric()

    Message "Creating artificial atmosphere..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
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
    
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long
    Dim newR As Long, newG As Long, newB As Long
        
    'Apply the filter
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
        
        r = ImageData(QuickVal + 2, Y)
        g = ImageData(QuickVal + 1, Y)
        b = ImageData(QuickVal, Y)
        
        newR = (g + b) \ 2
        newG = (r + b) \ 2
        newB = (r + g) \ 2
        
        ImageData(QuickVal + 2, Y) = newR
        ImageData(QuickVal + 1, Y) = newG
        ImageData(QuickVal, Y) = newB
        
    Next Y
        If (X And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal X
        End If
    Next X
        
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData
    
End Sub

'Apple a "freeze" filter to an image.
Public Sub MenuFrozen()

    Message "Dropping image temperature..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
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
    
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long
        
    'Apply the filter
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
        
        r = ImageData(QuickVal + 2, Y)
        g = ImageData(QuickVal + 1, Y)
        b = ImageData(QuickVal, Y)
        
        r = Abs((r - g - b) * 1.5)
        g = Abs((g - b - r) * 1.5)
        b = Abs((b - r - g) * 1.5)
        
        If r < 0 Then r = 0
        If g < 0 Then g = 0
        If b < 0 Then b = 0
        
        If r > 255 Then r = 255
        If g > 255 Then g = 255
        If b > 255 Then b = 255
        
        ImageData(QuickVal + 2, Y) = r
        ImageData(QuickVal + 1, Y) = g
        ImageData(QuickVal, Y) = b
        
    Next Y
        If (X And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal X
        End If
    Next X
        
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData
    
End Sub

'Apply a strange, lava-ish transformation to an image
Public Sub MenuLava()
    
    Message "Exploding imaginary volcano..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
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
    
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long
    Dim grayVal As Long
    
    'Because gray values are constant, we can use a look-up table to calculate them
    Dim gLookup(0 To 765) As Byte
    For X = 0 To 765
        gLookup(X) = CByte(X \ 3)
    Next X
        
    'Apply the filter
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
        
        r = ImageData(QuickVal + 2, Y)
        g = ImageData(QuickVal + 1, Y)
        b = ImageData(QuickVal, Y)
        
        grayVal = gLookup(r + g + b)
        
        r = grayVal
        g = Abs(b - 128)
        b = Abs(b - 128)
        
        ImageData(QuickVal + 2, Y) = r
        ImageData(QuickVal + 1, Y) = g
        ImageData(QuickVal, Y) = b
        
    Next Y
        If (X And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal X
        End If
    Next X
        
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData
    
End Sub

'Ignite an image via this classy "burn" filter
Public Sub MenuBurn()

    Message "Lighting image on fire..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
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
    
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long
    Dim grayVal As Long
    
    'Because gray values are constant, we can use a look-up table to calculate them
    Dim gLookup(0 To 765) As Byte
    For X = 0 To 765
        gLookup(X) = CByte(X \ 3)
    Next X
        
    'Apply the filter
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
        
        r = ImageData(QuickVal + 2, Y)
        g = ImageData(QuickVal + 1, Y)
        b = ImageData(QuickVal, Y)
        
        grayVal = gLookup(r + g + b)
        
        r = grayVal * 3
        g = grayVal
        b = gLookup(grayVal)
        
        If r > 255 Then r = 255
        
        ImageData(QuickVal + 2, Y) = r
        ImageData(QuickVal + 1, Y) = g
        ImageData(QuickVal, Y) = b
        
    Next Y
        If (X And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal X
        End If
    Next X
        
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData
 
End Sub

'Give the image a metallic shimmer with this "steel" filter
Public Sub MenuSteel()

    Message "Pouring smoldering steel onto image..."
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim ImageData() As Byte
    Dim tmpSA As SAFEARRAY2D
    prepImageData tmpSA
    CopyMemory ByVal VarPtrArray(ImageData()), VarPtr(tmpSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
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
    
    'Finally, a bunch of variables used in color calculation
    Dim r As Long, g As Long, b As Long
    Dim grayVal As Long
    
    'Because gray values are constant, we can use a look-up table to calculate them
    Dim gLookup(0 To 765) As Byte
    For X = 0 To 765
        gLookup(X) = CByte(X \ 3)
    Next X
        
    'Apply the filter
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
        
        r = ImageData(QuickVal + 2, Y)
        r = Abs(r - 64)
        g = Abs(r - 64)
        b = Abs(g - 64)
        
        grayVal = gLookup(r + g + b)
        
        r = grayVal + 70
        r = r + (((r - 128) * 100) \ 100)
        g = Abs(grayVal - 6) + 70
        g = g + (((g - 128) * 100) \ 100)
        b = (grayVal + 5) + 70
        b = b + (((b - 128) * 100) \ 100)
        
        If r < 0 Then r = 0
        If g < 0 Then g = 0
        If b < 0 Then b = 0
        
        If r > 255 Then r = 255
        If g > 255 Then g = 255
        If b > 255 Then b = 255
        
        ImageData(QuickVal + 2, Y) = r
        ImageData(QuickVal + 1, Y) = g
        ImageData(QuickVal, Y) = b
        
    Next Y
        If (X And progBarCheck) = 0 Then
            If userPressedESC() Then Exit For
            SetProgBarVal X
        End If
    Next X
        
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(ImageData), 0&, 4
    Erase ImageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    finalizeImageData

End Sub
