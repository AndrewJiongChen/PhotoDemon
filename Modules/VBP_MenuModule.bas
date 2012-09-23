Attribute VB_Name = "File_Menu"
'***************************************************************************
'File Menu Handler
'Copyright �2000-2012 by Tanner Helland
'Created: 15/Apr/01
'Last updated: 14/June/12
'Last update: moved the bulk of the Open dialog to a standalone routine, so that it can be used elsewhere
'             in the project (specifically, the Batch Convert form). This way it can benefit from the
'             addition of new image filters, without me having to cut-and-paste the code to that form.
'
'Module for controlling standard file menu options.  Currently only handles
'"open image" and "save image".
'
'***************************************************************************

Option Explicit

'This subroutine loads an image - note that the interesting stuff actually happens in PhotoDemon_OpenImageDialog, below
Public Sub MenuOpen()
    
    'String returned from the common dialog wrapper
    Dim sFile() As String
    
    If PhotoDemon_OpenImageDialog(sFile, FormMain.HWnd) Then PreLoadImage sFile

End Sub

'Pass this function a string array, and it will fill it with a list of files selected by the user.
' The commondialog filters are automatically set according to image formats supported by the program.
Public Function PhotoDemon_OpenImageDialog(ByRef listOfFiles() As String, ByVal ownerHWnd As Long) As Boolean

    'Common dialog interface
    Dim CC As cCommonDialog
    
    'Get the last "open image" path from the INI file
    Dim tempPathString As String
    tempPathString = GetFromIni("Program Paths", "MainOpen")
    
    Set CC = New cCommonDialog
    Dim cdfStr As String
    cdfStr = "All Compatible Images|*.bmp;*.jpg;*.jpeg;*.gif;*.ico"
    
    'Only allow PDI loading if the zLib dll was detected at program load
    If zLibEnabled Then cdfStr = cdfStr & ";*.pdi"
    
    'Only allow FreeImage file loading if the FreeImage dll was detected
    If FreeImageEnabled Then
        cdfStr = cdfStr & ";*.png;*.lbm;*.pbm;*.iff;*.jif;*.jfif;*.psd;*.tif;*.tiff;*.wbmp;*.wbm;*.pgm;*.ppm;*.jng;*.mng;*.koa;*.pcd;*.ras;*.dds;*.pict;*.pct;*.pic;*.sgi;*.rgb;*.rgba;*.bw;*.int;*.inta"
    
    'If FreeImage wasn't found but GDI+ was, enable a subset of those image formats (PNG and TIFF, specifically)
    ElseIf GDIPlusEnabled Then
        cdfStr = cdfStr & ";*.png;*.tif;*.tiff;"
    End If
    
    cdfStr = cdfStr & "|"
    cdfStr = cdfStr & "BMP - OS/2 or Windows Bitmap|*.bmp"
    
    If FreeImageEnabled Then cdfStr = cdfStr & "|DDS - DirectDraw Surface|*.dds"
    
    cdfStr = cdfStr & "|GIF - Compuserve|*.gif|ICO - Windows Icon|*.ico"
    
    If FreeImageEnabled Then cdfStr = cdfStr & "|IFF - Amiga Interchange Format|*.iff|JNG - JPEG Network Graphics|*.jng"
    
    cdfStr = cdfStr & "|JPG/JPEG - Joint Photographic Experts Group|*.jpg;*.jpeg;*.jif;*.jfif"
    
    If FreeImageEnabled Then cdfStr = cdfStr & "|KOA/KOALA - Commodore 64|*.koa;*.koala|LBM - Deluxe Paint|*.lbm|MNG - Multiple Network Graphics|*.mng|PBM - Portable Bitmap|*.pbm|PCD - Kodak PhotoCD|*.pcd|PCX - Zsoft Paintbrush|*.pcx"
    
    'Only allow PDI (PhotoDemon's native file format) loading if the zLib dll has been properly detected
    If zLibEnabled Then cdfStr = cdfStr & "|PDI - PhotoDemon Image|*.pdi"
    
    If FreeImageEnabled Then cdfStr = cdfStr & "|PGM - Portable Greymap|*.pgm|PIC/PICT - Macintosh Picture|*.pict;*.pct;*.pic"
    
    'FreeImage or GDIPlus is sufficient for loading PNGs
    If FreeImageEnabled Or GDIPlusEnabled Then cdfStr = cdfStr & "|PNG - Portable Network Graphic|*.png"
    
    If FreeImageEnabled Then cdfStr = cdfStr & "|PPM - Portable Pixmap|*.ppm|PSD - Adobe Photoshop|*.psd|RAS - Sun Raster File|*.ras|SGI/RGB/BW - Silicon Graphics Image|*.sgi;*.rgb;*.rgba;*.bw;*.int;*.inta|TGA - Truevision Targa|*.tga"
    
    If FreeImageEnabled Or GDIPlusEnabled Then cdfStr = cdfStr & "|TIF/TIFF - Tagged Image File Format|*.tif;*.tiff"
    
    If FreeImageEnabled Then cdfStr = cdfStr & "|WBMP - Wireless Bitmap|*.wbmp;*.wbm"
    
    cdfStr = cdfStr & "|All files|*.*"
    
    Dim sFileList As String
    
    'Use Steve McMahon's excellent Common Dialog class to launch a dialog (this way, no OCX is required)
    If CC.VBGetOpenFileName(sFileList, , True, True, False, True, cdfStr, LastOpenFilter, tempPathString, "Open an image", , ownerHWnd, 0) Then
        
        Message "Preparing to load image..."
        
        'Take the return string (a null-delimited list of filenames) and split it out into a string array
        listOfFiles = Split(sFileList, vbNullChar)
        
        'Due to the buffering required by the API call, uBound(listOfFiles) should ALWAYS > 0 but
        ' let's check it anyway (just to be safe)
        If UBound(listOfFiles) > 0 Then
        
            'Remove all empty strings from the array (which are a byproduct of the aforementioned buffering)
            For x = UBound(listOfFiles) To 0 Step -1
                If listOfFiles(x) <> "" Then Exit For
            Next
            
            'With all the empty strings removed, all that's left is legitimate file paths
            ReDim Preserve listOfFiles(0 To x) As String
            
        End If
        
        'If multiple files were selected, we need to do some additional processing to the array
        If UBound(listOfFiles) > 0 Then
        
            'The common dialog function returns a unique array. Index (0) contains the folder path (without a
            ' trailing backslash), so first things first - add a trailing backslash
            Dim imagesPath As String
            imagesPath = FixPath(listOfFiles(0))
            
            'The remaining indices contain a filename within that folder.  To get the full filename, we must
            ' append the path from (0) to the start of each filename.  This will relieve the burden on
            ' whatever function called us - it can simply loop through the full paths, loading files as it goes
            For x = 1 To UBound(listOfFiles)
                listOfFiles(x - 1) = imagesPath & listOfFiles(x)
            Next x
            
            ReDim Preserve listOfFiles(0 To UBound(listOfFiles) - 1)
            
            'Save the new directory as the default path for future usage
            WriteToIni "Program Paths", "MainOpen", imagesPath
            
        'If there is only one file in the array (e.g. the user only opened one image), we don't need to do all
        ' that extra processing - just save the new directory to the INI file
        Else
        
            'Save the new directory as the default path for future usage
            tempPathString = listOfFiles(0)
            StripDirectory tempPathString
        
            WriteToIni "Program Paths", "MainOpen", tempPathString
            
        End If
        
        'Also, remember the file filter for future use (in case the user tends to use the same filter repeatedly)
        WriteToIni "File Formats", "LastOpenFilter", CStr(LastOpenFilter)
        
        'All done!
        PhotoDemon_OpenImageDialog = True
        
    'If the user cancels the commondialog box, simply exit out
    Else
        
        If CC.ExtendedError <> 0 Then MsgBox "An error occurred: " & CC.ExtendedError
    
        PhotoDemon_OpenImageDialog = False
    End If
    
    'Release the common dialog object
    Set CC = Nothing

End Function

'Subroutine for saving an image to file.  This function assumes the image already exists on disk and is simply
' being replaced; if the file does not exist on disk, this routine will automatically transfer control to Save As...
' The imageToSave is a reference to an ID in the pdImages() array.  It can be grabbed from the form.Tag value as well.
Public Function MenuSave(ByVal imageID As Long) As Boolean

    If pdImages(imageID).LocationOnDisk = "" Then
        'This image hasn't been saved before.  Launch the Save As... dialog
        MenuSave = MenuSaveAs(imageID)
    Else
        'This image has been saved before.  Overwrite it.
        MenuSave = PhotoDemon_SaveImage(imageID, pdImages(imageID).LocationOnDisk, False, pdImages(imageID).saveFlag0, pdImages(imageID).saveFlag1)
    End If

End Function

'Subroutine for displaying a commondialog save box, then saving an image to the specified file
Public Function MenuSaveAs(ByVal imageID As Long) As Boolean

    Dim CC As cCommonDialog
    Set CC = New cCommonDialog
    
    'Get the last "save image" path from the INI file
    Dim tempPathString As String
    tempPathString = GetFromIni("Program Paths", "MainSave")
    
    Dim cdfStr As String
    
    cdfStr = "BMP - Windows Bitmap|*.bmp"
    
    If FreeImageEnabled Or GDIPlusEnabled Then cdfStr = cdfStr & "|GIF - Graphics Interchange Format|*.gif|JPG - JPEG - JFIF Compliant|*.jpg"
    
    If zLibEnabled Then cdfStr = cdfStr & "|PDI - PhotoDemon Image (Lossless)|*.pdi"
    
    If FreeImageEnabled Or GDIPlusEnabled Then cdfStr = cdfStr & "|PNG - Portable Network Graphic|*.png"
    
    If FreeImageEnabled Then cdfStr = cdfStr & "|PPM - Portable Pixel Map (ASCII)|*.ppm|TGA - Truevision Targa|*.tga"
    
    If FreeImageEnabled Or GDIPlusEnabled Then cdfStr = cdfStr & "|TIFF - Tagged Image File Format|*.tif"
    
    Dim sFile As String
    sFile = pdImages(imageID).OriginalFileName
    
    'This next chunk of code checks to see if an image with this filename appears in the download location.
    ' If it does, PhotoDemon will append ascending numbers (of the format "_(#)") to the filename until it
    ' finds a unique name.
    If FileExist(tempPathString & sFile & "." & getExtensionFromFilterIndex(LastSaveFilter)) Then
    
        Dim numToAppend As Long
        numToAppend = 2
        
        Do While FileExist(tempPathString & sFile & " (" & numToAppend & ")" & "." & getExtensionFromFilterIndex(LastSaveFilter))
            numToAppend = numToAppend + 1
        Loop
        
        'If the loop has terminated, a unique filename has been found.  Make that the recommended filename.
        sFile = sFile & " (" & numToAppend & ")"
    
    End If
    
    
    If CC.VBGetSaveFileName(sFile, , True, cdfStr, LastSaveFilter, tempPathString, "Save an image", ".bmp|.gif|.jpg|.pcx|.pdi|.png|.ppm|.tga|.tif|.*", FormMain.HWnd, 0) Then
        
        'Save the new directory as the default path for future usage
        tempPathString = sFile
        StripDirectory tempPathString
        WriteToIni "Program Paths", "MainSave", tempPathString
        
        'Also, remember the file filter for future use (in case the user tends to use the same filter repeatedly)
        WriteToIni "File Formats", "LastSaveFilter", CStr(LastSaveFilter)
        
        pdImages(imageID).containingForm.Caption = sFile
        SaveFileName = sFile
        
        'Transfer control to the core SaveImage routine, which will handle file extension analysis and actual saving
        MenuSaveAs = PhotoDemon_SaveImage(imageID, sFile, True)
        
    Else
        MenuSaveAs = False
    End If
    
    'Release the common dialog object
    Set CC = Nothing
    
End Function

'This routine will blindly save the image from the form containing pdImages(imageID) to dstPath.  It is up to
' the calling routine to make sure this is what is wanted. (Note: this routine will erase any existing image
' at dstPath, so BE VERY CAREFUL with what you send here!)
Public Function PhotoDemon_SaveImage(ByVal imageID As Long, ByVal dstPath As String, Optional ByVal loadRelevantForm As Boolean = False, Optional ByVal optionalSaveParameter0 As Long = -1, Optional ByVal optionalSaveParameter1 As Long = -1) As Boolean

    'Used to determine what kind of file the user is trying to open
    Dim FileExtension As String
    FileExtension = UCase(GetExtension(dstPath))
    
    'Only update the MRU if 1) no form is shown (because the user may cancel it), 2) a form was shown and the user
    ' successfully navigated it, and 3) no errors occured during the export process.
    Dim updateMRU As Boolean
    updateMRU = False

    Select Case FileExtension
        Case "JPG", "JPEG", "JPE"
            If loadRelevantForm = True Then
                FormJPEG.Show 1, FormMain
                'If the dialog was canceled, note it
                PhotoDemon_SaveImage = Not saveDialogCanceled
            Else
                'Remember the JPEG quality so we don't have to pester the user for it if they save again
                pdImages(imageID).saveFlag0 = optionalSaveParameter0
                
                'I implement two separate save functions for JPEG images: FreeImage and GDI+.  The system we select is
                ' contingent on a variety of factors, most important of which is - are we in the midst of a batch conversion.
                ' If we are, use GDI+ as it does not need to make a copy of the image before saving it (which is much faster).
                If MacroStatus = MacroBATCH Then
                    If GDIPlusEnabled Then
                        GDIPlusSavePicture imageID, dstPath, ImageJPEG, optionalSaveParameter0
                    ElseIf FreeImageEnabled Then
                        SaveJPEGImage imageID, dstPath, optionalSaveParameter0
                    Else
                        Message "No JPEG encoder found. Save aborted."
                        PhotoDemon_SaveImage = False
                        Exit Function
                    End If
                Else
                    If FreeImageEnabled Then
                        SaveJPEGImage imageID, dstPath, optionalSaveParameter0
                    ElseIf GDIPlusEnabled Then
                        GDIPlusSavePicture imageID, dstPath, ImageJPEG, optionalSaveParameter0
                    Else
                        Message "No JPEG encoder found. Save aborted."
                        PhotoDemon_SaveImage = False
                        Exit Function
                    End If
                End If
                updateMRU = True
            End If
        Case "PDI"
            If zLibEnabled Then
                SavePhotoDemonImage imageID, dstPath
                updateMRU = True
            Else
            'If zLib doesn't exist...
                MsgBox "The zLib compression library (zlibwapi.dll) was marked as missing or corrupted upon program initialization." & vbCrLf & vbCrLf & "To enable PDI saving, please allow " & PROGRAMNAME & " to download plugin updates by going to the Edit Menu -> Program Preferences, and selecting the 'offer to download core plugins' check box.", vbCritical + vbOKOnly + vbApplicationModal, PROGRAMNAME & " PDI Interface Error"
                Message "PDI saving disabled."
            End If
        Case "GIF"
            'GIFs are preferentially exported by FreeImage, then GDI+ (if available)
            If FreeImageEnabled Then
                SaveGIFImage imageID, dstPath
            ElseIf GDIPlusEnabled Then
                GDIPlusSavePicture imageID, dstPath, ImageGIF
            Else
                Message "No GIF encoder found. Save aborted."
                PhotoDemon_SaveImage = False
                Exit Function
            End If
            updateMRU = True
        Case "PNG"
            'PNGs are preferentially exported by FreeImage, then GDI+ (if available)
            If FreeImageEnabled Then
                If optionalSaveParameter0 = -1 Then
                    SavePNGImage imageID, dstPath
                Else
                    SavePNGImage imageID, dstPath, optionalSaveParameter0
                End If
            ElseIf GDIPlusEnabled Then
                GDIPlusSavePicture imageID, dstPath, ImagePNG
            Else
                Message "No PNG encoder found. Save aborted."
                PhotoDemon_SaveImage = False
                Exit Function
            End If
            updateMRU = True
        Case "PPM"
            SavePPMImage imageID, dstPath
            updateMRU = True
        Case "TGA"
            SaveTGAImage imageID, dstPath
            updateMRU = True
        Case "TIF", "TIFF"
            'TIFFs are preferentially exported by FreeImage, then GDI+ (if available)
            If FreeImageEnabled Then
                SaveTIFImage imageID, dstPath
                updateMRU = True
            ElseIf GDIPlusEnabled Then
                GDIPlusSavePicture imageID, dstPath, ImageTIFF
            Else
                Message "No TIFF encoder found. Save aborted."
                PhotoDemon_SaveImage = False
                Exit Function
            End If
        Case Else
            SaveBMP imageID, dstPath
            updateMRU = True
        
    End Select
    
    'UpdateMRU should only be true if the save was successful
    If updateMRU = True Then
        'Add this file to the MRU list
        MRU_AddNewFile dstPath
    
        'Remember the file's location for future saves
        pdImages(imageID).LocationOnDisk = dstPath
        
        'Remember the file's filename
        Dim tmpFileName As String
        tmpFileName = dstPath
        StripFilename tmpFileName
        pdImages(imageID).OriginalFileNameAndExtension = tmpFileName
        StripOffExtension tmpFileName
        pdImages(imageID).OriginalFileName = tmpFileName
        
        'Mark this file as having been saved
        pdImages(imageID).UpdateSaveState True
        
        PhotoDemon_SaveImage = True
    
    Else
        'Was a save dialog called?  If it was, use that value to return "success" or not
        If loadRelevantForm <> True Then PhotoDemon_SaveImage = False
    End If

End Function

'Return a string containing the expected file extension of the supplied commondialog filter index
Private Function getExtensionFromFilterIndex(ByVal FilterIndex As Long) As String

    Select Case FilterIndex
        Case 1
            getExtensionFromFilterIndex = "bmp"
        Case 2
            getExtensionFromFilterIndex = "gif"
        Case 3
            getExtensionFromFilterIndex = "jpg"
        Case 4
            getExtensionFromFilterIndex = "pdi"
        Case 5
            getExtensionFromFilterIndex = "png"
        Case 6
            getExtensionFromFilterIndex = "ppm"
        Case 7
            getExtensionFromFilterIndex = "tga"
        Case 8
            getExtensionFromFilterIndex = "tif"
        Case Else
            getExtensionFromFilterIndex = "undefined"
    End Select
    
End Function
