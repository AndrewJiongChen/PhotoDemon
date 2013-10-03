Attribute VB_Name = "Filters_Transform"
'***************************************************************************
'Image Transformations Interface (including flip/mirror/rotation/crop/etc)
'Copyright �2003-2013 by Tanner Helland
'Created: 25/January/03
'Last updated: 17/May/13
'Last update: CropToSelection now handles non-rectangular selections correctly.  (Unselected areas are made transparent.)
'
'Runs all image transformations, including rotate, flip, mirror and crop at present.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'Automatically crop the image.  An optional threshold can be supplied; pixels must be this close before they will be cropped.
' (The threshold is required for JPEG images; pixels may not be identical due to lossy compression.)
Public Sub AutocropImage(Optional ByVal cThreshold As Long = 15)

    'If the image contains an active selection, disable it before transforming the canvas
    If pdImages(CurrentImage).selectionActive Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
    End If

    'The image will be cropped in four steps.  Each edge will be cropped separately, starting with the top.
    
    Message "Analyzing top edge of image..."
    
    'Make a copy of the current image
    Dim tmpLayer As pdLayer
    Set tmpLayer = New pdLayer
    tmpLayer.createFromExistingLayer pdImages(CurrentImage).mainLayer
    
    'Point an array at the DIB data
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    prepSafeArray srcSA, tmpLayer
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
    
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    finalX = pdImages(CurrentImage).Width - 1
    finalY = pdImages(CurrentImage).Height - 1
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long
    qvDepth = pdImages(CurrentImage).mainLayer.getLayerColorDepth \ 8

    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    SetProgBarMax 4
    
    'Build a grayscale lookup table.  We will only be comparing luminance - not colors - when determining where to crop.
    Dim gLookup(0 To 765) As Long
    For X = 0 To 765
        gLookup(X) = CByte(X \ 3)
    Next X
    
    'The new edges of the image will mark these values for us
    Dim newTop As Long, newBottom As Long, newLeft As Long, newRight As Long
    
    'First, scan the top of the image.
    
    'All edges follow the same formula, so I'm only commenting this first section.
    
    '1-1) Start by determining the color of the top-left pixel.  This will be our baseline.
    Dim initColor As Long, curColor As Long
    initColor = gLookup(CLng(srcImageData(0, 0)) + CLng(srcImageData(1, 0)) + CLng(srcImageData(2, 0)))
    
    Dim colorFails As Boolean
    colorFails = False
    
    'Scan the image, starting at the top-left and moving right
    For Y = 0 To finalY
    For X = 0 To finalX
        QuickVal = X * qvDepth
        curColor = gLookup(CLng(srcImageData(QuickVal, Y)) + CLng(srcImageData(QuickVal + 1, Y)) + CLng(srcImageData(QuickVal + 2, Y)))
        
        'If pixel color DOES NOT match the baseline, keep scanning.  Otherwise, note that we have found a mismatched color
        ' and exit the loop.
        If Abs(curColor - initColor) > cThreshold Then colorFails = True
        
        If colorFails Then Exit For
        
    Next X
        If colorFails Then Exit For
    Next Y
    
    'We have now reached one of two conditions:
    '1) The entire image is one solid color
    '2) The loop progressed part-way through the image and terminated
    
    'Check for case (1) and warn the user if it occurred
    If Not colorFails Then
        CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
        Erase srcImageData
        
        SetProgBarVal 0
        Message "Image is all one color.  Autocrop unnecessary."
        Exit Sub
    
    'Next, check for case (2)
    Else
        newTop = Y
    End If
    
    initY = newTop
    
    'Repeat the above steps, but tracking the left edge instead.  Note also that we will only be scanning from wherever
    ' the top crop failed - this saves processing time.
    colorFails = False
    
    Message "Analyzing left edge of image..."
    initColor = gLookup(CLng(srcImageData(0, initY)) + CLng(srcImageData(1, initY)) + CLng(srcImageData(2, initY)))
    SetProgBarVal 1
    
    For X = 0 To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
    
        curColor = gLookup(CLng(srcImageData(QuickVal, Y)) + CLng(srcImageData(QuickVal + 1, Y)) + CLng(srcImageData(QuickVal + 2, Y)))
        
        'If pixel color DOES NOT match the baseline, keep scanning.  Otherwise, note that we have found a mismatched color
        ' and exit the loop.
        If Abs(curColor - initColor) > cThreshold Then colorFails = True
        
        If colorFails Then Exit For
        
    Next Y
        If colorFails Then Exit For
    Next X
    
    newLeft = X
    
    'Repeat the above steps, but tracking the right edge instead.  Note also that we will only be scanning from wherever
    ' the top crop failed - this saves processing time.
    colorFails = False
    
    Message "Analyzing right edge of image..."
    QuickVal = finalX * qvDepth
    initColor = gLookup(CLng(srcImageData(QuickVal, initY)) + CLng(srcImageData(QuickVal + 1, 0)) + CLng(srcImageData(QuickVal + 2, 0)))
    SetProgBarVal 2
    
    For X = finalX To 0 Step -1
        QuickVal = X * qvDepth
    For Y = initY To finalY
    
        curColor = gLookup(CLng(srcImageData(QuickVal, Y)) + CLng(srcImageData(QuickVal + 1, Y)) + CLng(srcImageData(QuickVal + 2, Y)))
        
        'If pixel color DOES NOT match the baseline, keep scanning.  Otherwise, note that we have found a mismatched color
        ' and exit the loop.
        If Abs(curColor - initColor) > cThreshold Then colorFails = True
        
        If colorFails Then Exit For
        
    Next Y
        If colorFails Then Exit For
    Next X
    
    newRight = X
    
    'Finally, repeat the steps above for the bottom of the image.  Note also that we will only be scanning from wherever
    ' the left and right crops failed - this saves processing time.
    colorFails = False
    initX = newLeft
    finalX = newRight
    QuickVal = initX * qvDepth
    initColor = gLookup(CLng(srcImageData(QuickVal, finalY)) + CLng(srcImageData(QuickVal + 1, finalY)) + CLng(srcImageData(QuickVal + 2, finalY)))
    
    Message "Analyzing bottom edge of image..."
    SetProgBarVal 3
    
    For Y = finalY To initY Step -1
    For X = initX To finalX
        QuickVal = X * qvDepth
        curColor = gLookup(CLng(srcImageData(QuickVal, Y)) + CLng(srcImageData(QuickVal + 1, Y)) + CLng(srcImageData(QuickVal + 2, Y)))
        
        'If pixel color DOES NOT match the baseline, keep scanning.  Otherwise, note that we have found a mismatched color
        ' and exit the loop.
        If Abs(curColor - initColor) > cThreshold Then colorFails = True
        
        If colorFails Then Exit For
        
    Next X
        If colorFails Then Exit For
    Next Y
    
    newBottom = Y
    
    'With our work complete, point ImageData() away from the DIB and deallocate it
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    
    'We now know where to crop the image.  Apply the crop.
    
    If (newTop = 0) And (newBottom = pdImages(CurrentImage).Height - 1) And (newLeft = 0) And (newRight = pdImages(CurrentImage).Width - 1) Then
        SetProgBarVal 0
        Message "Image is already cropped intelligently.  Autocrop abandoned.  (No changes were made to the image.)"
    Else
    
        Message "Cropping image to new dimensions..."
        SetProgBarVal 4
        
        'Resize the current image's main layer
        pdImages(CurrentImage).mainLayer.createBlank newRight - newLeft, newBottom - newTop, tmpLayer.getLayerColorDepth
        
        'Copy the autocropped area to the new main layer
        BitBlt pdImages(CurrentImage).mainLayer.getLayerDC, 0, 0, pdImages(CurrentImage).mainLayer.getLayerWidth, pdImages(CurrentImage).mainLayer.getLayerHeight, tmpLayer.getLayerDC, newLeft, newTop, vbSrcCopy
    
        'Erase the temporary layer
        tmpLayer.eraseLayer
        Set tmpLayer = Nothing
    
        'Update the current image size
        pdImages(CurrentImage).updateSize
        DisplaySize pdImages(CurrentImage).Width, pdImages(CurrentImage).Height
        
        Message "Finished. "
        SetProgBarVal 0
        
        'Redraw the image
        PrepareViewport FormMain.ActiveForm, "Autocrop image"
    
    End If

End Sub

'Crop the image to the current selection
Public Sub MenuCropToSelection()

    'First, make sure there is an active selection
    If Not pdImages(CurrentImage).selectionActive Then
        Message "No active selection found.  Crop abandoned."
        Exit Sub
    End If
    
    Message "Cropping image to selected area..."
    
    'Create a new layer the size of the active selection
    Dim tmpLayer As pdLayer
    Set tmpLayer = New pdLayer
    pdImages(CurrentImage).retrieveProcessedSelection tmpLayer
    
    'NOTE: historically, the entire rectangular bounding region of the selection was included in the crop.  (This is GIMP's behavior.)
    ' I now fully crop the image, which means that for non-square selections, all unselected pixels are set to transparent.  For non-square
    ' selections, this will always result in a 32bpp image.
    '
    'The old code will be left here few a few releases, in case I decide to provide a preference for alternate behavior, per user request.
    ' (Note: comment added for the 6.0 release; consider removing by 6.4 if no complaints received.)
    '
    'Copy the selection area to the temporary layer
    'tmpLayer.createBlank pdImages(CurrentImage).mainSelection.boundWidth, pdImages(CurrentImage).mainSelection.boundHeight, pdImages(CurrentImage).mainLayer.getLayerColorDepth
    'BitBlt tmpLayer.getLayerDC, 0, 0, pdImages(CurrentImage).mainSelection.boundWidth, pdImages(CurrentImage).mainSelection.boundHeight, pdImages(CurrentImage).mainLayer.getLayerDC, pdImages(CurrentImage).mainSelection.boundLeft, pdImages(CurrentImage).mainSelection.boundTop, vbSrcCopy
    
    'Transfer the newly cropped image back into the main layer object
    pdImages(CurrentImage).mainLayer.createFromExistingLayer tmpLayer
    
    'Erase the temporary layer
    tmpLayer.eraseLayer
    Set tmpLayer = Nothing
    
    'Update the current image size
    pdImages(CurrentImage).updateSize
    DisplaySize pdImages(CurrentImage).Width, pdImages(CurrentImage).Height
    
    Message "Finished. "
    
    'Deactivate the current selection, as it's no longer needed
    'Clear selections after "Crop to Selection"
    If g_UserPreferences.GetPref_Boolean("Tools", "Clear Selection After Crop", True) Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
        Message "Crop complete.  (Note: the selected area was automatically unselected.)"
    Else
        pdImages(CurrentImage).mainSelection.lockRelease
        pdImages(CurrentImage).mainSelection.selLeft = 0
        pdImages(CurrentImage).mainSelection.selTop = 0
        pdImages(CurrentImage).mainSelection.selWidth = pdImages(CurrentImage).Width
        pdImages(CurrentImage).mainSelection.selHeight = pdImages(CurrentImage).Height
        pdImages(CurrentImage).mainSelection.lockIn
        Dim i As Long
        For i = 0 To toolbar_Selections.cmbSelRender.Count - 1
            toolbar_Selections.cmbSelRender(i).ListIndex = sHighlightRed
        Next i
        Message "Crop complete.  Selection drawing mode changed to make selection visible."
    End If
    
    'Redraw the image
    PrepareViewport FormMain.ActiveForm, "Crop to selection"

End Sub

'Flip an image vertically
Public Sub MenuFlip()

    'If the image contains an active selection, disable it before transforming the canvas
    If pdImages(CurrentImage).selectionActive Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
    End If
    
    Message "Flipping image..."
    StretchBlt pdImages(CurrentImage).mainLayer.getLayerDC, 0, 0, pdImages(CurrentImage).Width, pdImages(CurrentImage).Height, pdImages(CurrentImage).mainLayer.getLayerDC, 0, pdImages(CurrentImage).Height - 1, pdImages(CurrentImage).Width, -pdImages(CurrentImage).Height, vbSrcCopy
    Message "Finished. "
    
    ScrollViewport FormMain.ActiveForm
    
End Sub

'Flip an image horizontally
Public Sub MenuMirror()

    'If the image contains an active selection, disable it before transforming the canvas
    If pdImages(CurrentImage).selectionActive Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
    End If

    Message "Mirroring image..."
    StretchBlt pdImages(CurrentImage).mainLayer.getLayerDC, 0, 0, pdImages(CurrentImage).Width, pdImages(CurrentImage).Height, pdImages(CurrentImage).mainLayer.getLayerDC, pdImages(CurrentImage).Width - 1, 0, -pdImages(CurrentImage).Width, pdImages(CurrentImage).Height, vbSrcCopy
    Message "Finished. "
    
    ScrollViewport FormMain.ActiveForm
    
End Sub

'Rotate an image 90� clockwise
Public Sub MenuRotate90Clockwise()

    'If a selection is active, remove it.  (This is not the most elegant solution - the elegant solution would be rotating
    ' the selection to match the new image, but we can fix that at a later date.)
    If pdImages(CurrentImage).selectionActive Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
    End If

    Message "Rotating image clockwise..."
    
    'Create a local array and point it at the pixel data of the current image
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    prepImageData srcSA
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
    
    'Create a second local array.  This will contain the pixel data of the new, rotated image
    Dim dstImageData() As Byte
    Dim dstSA As SAFEARRAY2D
    
    Dim dstLayer As pdLayer
    Set dstLayer = New pdLayer
    dstLayer.createBlank pdImages(CurrentImage).mainLayer.getLayerHeight, pdImages(CurrentImage).mainLayer.getLayerWidth, pdImages(CurrentImage).mainLayer.getLayerColorDepth
    
    prepSafeArray dstSA, dstLayer
    CopyMemory ByVal VarPtrArray(dstImageData()), VarPtr(dstSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, i As Long
    Dim initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curLayerValues.Left
    initY = curLayerValues.Top
    finalX = curLayerValues.Right
    finalY = curLayerValues.Bottom
    
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long, QuickValY
    qvDepth = curLayerValues.BytesPerPixel
    
    Dim iWidth As Long, iHeight As Long
    iWidth = finalX * qvDepth
    iHeight = finalY * qvDepth
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
        
    'Rotate the source image into the destination image, using the arrays provided
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
        QuickValY = Y * qvDepth
        
        For i = 0 To qvDepth - 1
            dstImageData(iHeight - QuickValY + i, finalX - X) = srcImageData(iWidth - QuickVal + i, Y)
        Next i
        
    Next Y
        If (X And progBarCheck) = 0 Then SetProgBarVal X
    Next X
    
    'With our work complete, point both ImageData() arrays away from their respective DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    CopyMemory ByVal VarPtrArray(dstImageData), 0&, 4
    Erase dstImageData
    
    'dstImageData now contains the rotated image.  We need to transfer that back into the current image.
    pdImages(CurrentImage).mainLayer.createFromExistingLayer dstLayer
    
    'With that transfer complete, we can erase our temporary layer
    dstLayer.eraseLayer
    Set dstLayer = Nothing
    
    'Update the current image size
    pdImages(CurrentImage).updateSize
    DisplaySize pdImages(CurrentImage).Width, pdImages(CurrentImage).Height
    
    Message "Finished. "
    
    'Redraw the image
    FitWindowToImage
    
    'Reset the progress bar to zero
    SetProgBarVal 0
    
End Sub

'Rotate an image 180�
Public Sub MenuRotate180()

    'If the image contains an active selection, disable it before transforming the canvas
    If pdImages(CurrentImage).selectionActive Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
    End If

    'Fun fact: rotating 180 degrees can be accomplished by flipping and then mirroring it.
    Message "Rotating image..."
        
    StretchBlt pdImages(CurrentImage).mainLayer.getLayerDC, 0, 0, pdImages(CurrentImage).Width, pdImages(CurrentImage).Height, pdImages(CurrentImage).mainLayer.getLayerDC, pdImages(CurrentImage).Width - 1, pdImages(CurrentImage).Height - 1, -pdImages(CurrentImage).Width, -pdImages(CurrentImage).Height, vbSrcCopy
        
    Message "Finished. "
    
    ScrollViewport FormMain.ActiveForm
    
End Sub

'Rotate an image 90� counter-clockwise
Public Sub MenuRotate270Clockwise()

    'If a selection is active, remove it.  (This is not the most elegant solution - the elegant solution would be rotating
    ' the selection to match the new image, but we can fix that at a later date.)
    If pdImages(CurrentImage).selectionActive Then
        pdImages(CurrentImage).selectionActive = False
        pdImages(CurrentImage).mainSelection.lockRelease
        metaToggle tSelection, False
    End If

    Message "Rotating image counter-clockwise..."
    
    'Create a local array and point it at the pixel data of the current image
    Dim srcImageData() As Byte
    Dim srcSA As SAFEARRAY2D
    prepImageData srcSA
    CopyMemory ByVal VarPtrArray(srcImageData()), VarPtr(srcSA), 4
    
    'Create a second local array.  This will contain the pixel data of the new, rotated image
    Dim dstImageData() As Byte
    Dim dstSA As SAFEARRAY2D
    
    Dim dstLayer As pdLayer
    Set dstLayer = New pdLayer
    dstLayer.createBlank pdImages(CurrentImage).mainLayer.getLayerHeight, pdImages(CurrentImage).mainLayer.getLayerWidth, pdImages(CurrentImage).mainLayer.getLayerColorDepth
    
    prepSafeArray dstSA, dstLayer
    CopyMemory ByVal VarPtrArray(dstImageData()), VarPtr(dstSA), 4
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim X As Long, Y As Long, i As Long
    Dim initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curLayerValues.Left
    initY = curLayerValues.Top
    finalX = curLayerValues.Right
    finalY = curLayerValues.Bottom
    
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim QuickVal As Long, qvDepth As Long, QuickValY
    qvDepth = curLayerValues.BytesPerPixel
    
    Dim iWidth As Long
    iWidth = finalX * qvDepth
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    progBarCheck = findBestProgBarValue()
        
    'Rotate the source image into the destination image, using the arrays provided
    For X = initX To finalX
        QuickVal = X * qvDepth
    For Y = initY To finalY
        QuickValY = Y * qvDepth
        
        For i = 0 To qvDepth - 1
            dstImageData(QuickValY + i, X) = srcImageData(iWidth - QuickVal + i, Y)
        Next i
        
    Next Y
        If (X And progBarCheck) = 0 Then SetProgBarVal X
    Next X
    
    'With our work complete, point both ImageData() arrays away from their respective DIBs and deallocate them
    CopyMemory ByVal VarPtrArray(srcImageData), 0&, 4
    Erase srcImageData
    CopyMemory ByVal VarPtrArray(dstImageData), 0&, 4
    Erase dstImageData
    
    'dstImageData now contains the rotated image.  We need to transfer that back into the current image.
    pdImages(CurrentImage).mainLayer.createFromExistingLayer dstLayer
    
    'With that transfer complete, we can erase our temporary layer
    dstLayer.eraseLayer
    Set dstLayer = Nothing
    
    'Update the current image size
    pdImages(CurrentImage).updateSize
    DisplaySize pdImages(CurrentImage).Width, pdImages(CurrentImage).Height
    
    Message "Finished. "
    
    'Redraw the image
    FitWindowToImage
    
    'Reset the progress bar to zero
    SetProgBarVal 0
    
End Sub
