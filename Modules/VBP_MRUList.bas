Attribute VB_Name = "MRU_List_Handler"
'***************************************************************************
'MRU (Most Recently Used) List Handler
'Copyright �2005-2013 by Tanner Helland
'Created: 22/May/05
'Last updated: 25/September/13
'Last update: allow MRU accelerators (Ctrl + menu index) in the IDE, since we now use IDE-safe subclassing.
'
'Handles the creation and maintenance of the program's MRU list.  The MRU list is stored in the user preferences file.
'
'Special thanks to Randy Birch for the original version of the path shrinking code. You can download his original
' version from this link (good as of 22 Nov '12): http://vbnet.mvps.org/index.html?code/fileapi/pathcompactpathex.htm
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'MRUlist will contain string entries of all the most recently used files
Private MRUlist() As String

'Current number of entries in the MRU list
Private numEntries As Long

'Number of recent files to be tracked
Public Const RECENT_FILE_COUNT As Long = 9

'This function is used to shrink a long path down to a minimum number of characters
Private Declare Function PathCompactPathEx Lib "shlwapi.dll" Alias "PathCompactPathExA" (ByVal pszOut As String, ByVal pszSrc As String, ByVal cchMax As Long, ByVal dwFlags As Long) As Long
Private Declare Function lstrlenW Lib "kernel32" (ByVal lpString As Long) As Long
Private Const MAX_PATH As Long = 260
Public Const maxMRULength As Long = 64

'Because we need to hash MRU names to generate icon save locations, and hashing is computationally expensive, store all
' calculated hashes in a table.
Private Type mruHash
    mruInitPath As String
    mruHashPath As String
End Type

Private mruHashes() As mruHash

Private numOfMRUHashes As Long

'Return the path to an MRU thumbnail file (in PNG format)
Public Function getMRUThumbnailPath(ByVal mruIndex As Long) As String
    If (mruIndex >= 0) And (mruIndex <= numEntries) Then
        getMRUThumbnailPath = g_UserPreferences.getIconPath & getMRUHash(MRUlist(mruIndex)) & ".png"
    Else
        getMRUThumbnailPath = ""
    End If
End Function

Private Function doesMRUHashExist(ByVal filePath As String) As String

    'Check to see if this file has been requested before.  If it has, return our previous
    ' hash instead of recalculating one from scratch.  If it does not exist, return "".
    If numOfMRUHashes > 0 Then
    
        'Loop through all previous hashes from this session
        Dim i As Long
        For i = 0 To numOfMRUHashes - 1
        
            'If this file path matches one we've already calculated, return that instead of calculating it again
            If StrComp(mruHashes(i).mruInitPath, filePath, vbTextCompare) = 0 Then
                doesMRUHashExist = mruHashes(i).mruHashPath
                Exit Function
            End If
        
        Next i
    
    End If
    
    doesMRUHashExist = ""

End Function

'Return a 16-character hash of a specific MRU entry.  (This is used to generate unique menu icon filenames.)
Private Function getMRUHash(ByVal filePath As String) As String
    
    'Check to see if this hash already exists
    Dim prevHash As String
    prevHash = doesMRUHashExist(filePath)
    
    'If it does, return it.
    If prevHash <> "" Then
        getMRUHash = prevHash
        Exit Function
    
    'If no correlating hash was found, calculate one from scratch.
    Else
    
        'Prepare an SHA-256 hash calculator
        Dim cSHA2 As CSHA256
        Set cSHA2 = New CSHA256
            
        Dim hString As String
        hString = cSHA2.SHA256(filePath)
                
        'The SHA-256 function returns a 64 character string (256 / 8 = 32 bytes, but 64 characters due to hex representation).
        ' This is too long for a filename, so take only the first sixteen characters of the hash.
        hString = Left(hString, 16)
        
        'Save this hash to our hashes array
        mruHashes(numOfMRUHashes).mruInitPath = filePath
        mruHashes(numOfMRUHashes).mruHashPath = hString
        numOfMRUHashes = numOfMRUHashes + 1
        ReDim Preserve mruHashes(0 To numOfMRUHashes) As mruHash
        
        'Return this as the hash value
        getMRUHash = hString
    
    End If
    
End Function

'Return the MRU entry at a specific location (used to load MRU files)
Public Function getSpecificMRU(ByVal mIndex As Long) As String

    If (mIndex <= numEntries) And (mIndex >= 0) Then
        getSpecificMRU = MRUlist(mIndex)
    Else
        getSpecificMRU = ""
    End If

End Function

'Load the MRU list from the user's preference file
Public Sub MRU_LoadFromFile()

    'Reset the hash storage
    ReDim mruHashes(0) As mruHash
    numOfMRUHashes = 0
    
    'Get the number of MRU entries from the preferences file
    numEntries = g_UserPreferences.GetPref_Long("MRU", "Number Of Entries", RECENT_FILE_COUNT)
    
    'Only load entries if MRU data exists
    If numEntries > 0 Then
        ReDim MRUlist(0 To numEntries) As String
        
        Dim x As Long
        
        'Loop through each MRU entry, loading them onto the menu as we go
        For x = 0 To numEntries - 1
            MRUlist(x) = g_UserPreferences.GetPref_String("MRU", "f" & x, "")
            If x <> 0 Then
                Load FormMain.mnuRecDocs(x)
            Else
                FormMain.mnuRecDocs(x).Enabled = True
            End If
            
            'Based on the user's preference for captioning, display either the full path or just the filename
            If g_UserPreferences.GetPref_Long("Interface", "MRU Caption Length", 0) = 0 Then
                FormMain.mnuRecDocs(x).Caption = getFilename(MRUlist(x))
            Else
                FormMain.mnuRecDocs(x).Caption = getShortMRU(MRUlist(x))
            End If
            
            'Shortcuts are not displayed on XP, because they end up smashed into the caption itself.
            'If g_IsVistaOrLater Then FormMain.mnuRecDocs(x).Caption = FormMain.mnuRecDocs(x).Caption & vbTab & "Ctrl+" & x Else FormMain.mnuRecDocs(x).Caption = FormMain.mnuRecDocs(x).Caption & "   "
            FormMain.mnuRecDocs(x).Caption = FormMain.mnuRecDocs(x).Caption & vbTab & "Ctrl+" & x
            
        Next x
        
        'Make the "Clear MRU" option visible
        FormMain.MnuRecentSepBar1.Visible = True
        FormMain.MnuClearMRU.Visible = True
     
    'If no MRU entries are available, hide all MRU-related menu entries
    Else
        ReDim MRUlist(0) As String
        MRUlist(0) = ""
        FormMain.mnuRecDocs(0).Caption = "Empty"
        FormMain.mnuRecDocs(0).Enabled = False
        FormMain.MnuRecentSepBar1.Visible = False
        FormMain.MnuClearMRU.Visible = False
    End If
        
End Sub

'Save the current MRU list to file (currently done at program close)
Public Sub MRU_SaveToFile()

    'Save the number of current entries
    g_UserPreferences.SetPref_Long "MRU", "Number Of Entries", numEntries
    
    Dim x As Long
    
    'Only save entries if MRU data exists
    If numEntries <> 0 Then
        For x = 0 To numEntries - 1
            g_UserPreferences.SetPref_String "MRU", "f" & x, MRUlist(x)
        Next x
    End If
    
    'Unload all corresponding menu entries.  (This doesn't matter when the program is closing, but we also use this
    ' routine to refresh the MRU list after changing the caption preference - and for that an unload is required.)
    If numEntries <> 0 Then
        For x = FormMain.mnuRecDocs.Count - 1 To 1 Step -1
            Unload FormMain.mnuRecDocs(x)
        Next x
        'DoEvents
    End If
    
    'Finally, scan the MRU icon directory to make sure there are no orphaned PNG files.  (Multiple instances of PhotoDemon
    ' running simultaneously can lead to this.)  Delete any PNG files that don't correspond to current MRU entries.
    Dim chkFile As String
    chkFile = Dir(g_UserPreferences.getIconPath & "*.png", vbNormal)
    
    Dim fileOK As Boolean
    
    Do While chkFile <> ""
        
        fileOK = False
        
        'Compare this file to the hash for all current MRU entries
        If numEntries <> 0 Then
            For x = 0 To numEntries - 1
                
                'If this hash matches one on file, mark it as OK.
                If StrComp(g_UserPreferences.getIconPath & chkFile, getMRUThumbnailPath(x), vbTextCompare) = 0 Then
                    fileOK = True
                    Exit For
                End If
                
            Next x
        Else
            fileOK = False
        End If
        
        'If an MRU hash does not exist for this file, delete it
        If fileOK = False Then
            If FileExist(g_UserPreferences.getIconPath & chkFile) Then Kill g_UserPreferences.getIconPath & chkFile
        End If
    
        'Retrieve the next file and repeat
        chkFile = Dir
    
    Loop
    
End Sub

'Add another file to the MRU list
Public Sub MRU_AddNewFile(ByVal newFile As String, ByRef srcImage As pdImage)

    'Locators
    Dim alreadyThere As Boolean
    alreadyThere = False
    
    Dim curLocation As Long
    curLocation = -1
    
    Dim x As Long
    
    'First, check to see if our entry currently exists in the MRU list
    For x = 0 To numEntries - 1
        'If we find this entry in the list, then special measures must be taken
        If MRUlist(x) = newFile Then
            alreadyThere = True
            curLocation = x
            GoTo MRUEntryFound
        End If
    Next x
    
MRUEntryFound:
    
    'File already exists in the MRU list somewhere...
    If alreadyThere = True Then
        
        If curLocation <> 0 Then
            'Move every path before this file DOWN
            For x = curLocation To 1 Step -1
                MRUlist(x) = MRUlist(x - 1)
            Next x
        End If
    
    'File doesn't exist in the MRU list...
    Else

        numEntries = numEntries + 1
        
        'Cap the number of MRU files at a certain value (currently 9)
        If numEntries > RECENT_FILE_COUNT Then
            numEntries = RECENT_FILE_COUNT
            
            'Also, because we are about to purge the MRU list, we need to delete the last entry's image (if it exists).
            ' If we don't do this, the icons directory will eventually fill up with icons of old files.
            If FileExist(getMRUThumbnailPath(numEntries - 1)) Then Kill getMRUThumbnailPath(numEntries - 1)
        End If
        
        ReDim Preserve MRUlist(0 To numEntries) As String
    
        If numEntries > 1 Then
            For x = numEntries To 1 Step -1
                MRUlist(x) = MRUlist(x - 1)
            Next x
        End If
        
    End If
    
    MRUlist(0) = newFile
    
    'Redraw the MRU menu based on the current list
    If (FormMain.mnuRecDocs(0).Caption = g_Language.TranslateMessage("Empty")) Then
        FormMain.mnuRecDocs(0).Enabled = True
        FormMain.MnuRecentSepBar1.Visible = True
        FormMain.MnuClearMRU.Visible = True
    End If
    
    'Based on the user's preference, display just the filename or the entire file path (up to the max character length)
    If g_UserPreferences.GetPref_Long("Core", "MRU Caption Length", 0) = 0 Then
        FormMain.mnuRecDocs(0).Caption = getFilename(newFile)
    Else
        FormMain.mnuRecDocs(0).Caption = getShortMRU(newFile)
    End If
    
    'On Vista or later, display the corresponding accelerator.  XP truncates this, so just add some blank spaces for aesthetics.
    'If g_IsVistaOrLater Then FormMain.mnuRecDocs(0).Caption = FormMain.mnuRecDocs(0).Caption & vbTab & "Ctrl+0" Else FormMain.mnuRecDocs(0).Caption = FormMain.mnuRecDocs(0).Caption & "   "
    FormMain.mnuRecDocs(0).Caption = FormMain.mnuRecDocs(0).Caption & vbTab & "Ctrl+0"
    
    If numEntries > 1 Then
        'Unload existing menus...
        For x = FormMain.mnuRecDocs.Count - 1 To 1 Step -1
            Unload FormMain.mnuRecDocs(x)
        Next x
        'DoEvents
        'Load new menus...
        For x = 1 To numEntries - 1
            Load FormMain.mnuRecDocs(x)
            
            'Based on the user's preference, display just the filename or the entire file path (up to the max character length)
            If g_UserPreferences.GetPref_Long("Core", "MRU Caption Length", 0) = 0 Then
                FormMain.mnuRecDocs(x).Caption = getFilename(MRUlist(x))
            Else
                FormMain.mnuRecDocs(x).Caption = getShortMRU(MRUlist(x))
            End If
            
            'If g_IsVistaOrLater Then FormMain.mnuRecDocs(x).Caption = FormMain.mnuRecDocs(x).Caption & vbTab & "Ctrl+" & x Else FormMain.mnuRecDocs(x).Caption = FormMain.mnuRecDocs(x).Caption & "   "
            FormMain.mnuRecDocs(x).Caption = FormMain.mnuRecDocs(x).Caption & vbTab & "Ctrl+" & x
            
        Next x
    End If
    
    'Save a thumbnail of this image to file.
    saveMRUThumbnail newFile, srcImage
    
    'The icons in the MRU sub-menu need to be reset after this action
    resetMenuIcons

End Sub

'Saves a thumbnail PNG of a pdImage object.  The thumbnail is saved to the /Data/Icons directory
Private Sub saveMRUThumbnail(ByRef iPath As String, ByRef tImage As pdImage)

    'Right now, the save process is reliant on FreeImage.  Disable thumbnails if FreeImage is not present
    If g_ImageFormats.FreeImageEnabled Then
    
        Message "Saving recent file menu thumbnail..."
    
        'First, generate a path at which to save the file in question
        Dim sFilename As String
        sFilename = g_UserPreferences.getIconPath & getMRUHash(iPath) & ".png"
        
        'Request a thumbnail from the current image, and store it in a temporary layer
        Dim mruThumb As pdLayer
        Set mruThumb = New pdLayer
        If g_IsVistaOrLater Then
            tImage.requestThumbnail mruThumb, 64
        Else
            tImage.requestThumbnail mruThumb, 16
        End If
        
        'Load FreeImage into memory
        Dim hLib As Long
        hLib = LoadLibrary(g_PluginPath & "FreeImage.dll")
        
        'Convert the temporary layer to a FreeImage-type DIB
        Dim fi_DIB As Long
        fi_DIB = FreeImage_CreateFromDC(mruThumb.getLayerDC)
    
        'Use that handle to save the image to PNG format
        If fi_DIB <> 0 Then
            Dim fi_Check As Long
            
            'Output the PNG file at the proper color depth
            Dim fi_OutputColorDepth As FREE_IMAGE_COLOR_DEPTH
            If mruThumb.getLayerColorDepth = 24 Then
                fi_OutputColorDepth = FICD_24BPP
            Else
                fi_OutputColorDepth = FICD_32BPP
            End If
            
            fi_Check = FreeImage_SaveEx(fi_DIB, sFilename, FIF_PNG, FISO_PNG_Z_BEST_SPEED, fi_OutputColorDepth, , , , FILTER_BILINEAR, True)
            If fi_Check Then Message "Thumbnail saved successfully." Else Message "MRU thumbnail save failed (FreeImage_SaveEx silent fail). Please report this error using Help -> Submit Bug Report."
            
        Else
            Message "Thumbnail save failed (FreeImage returned blank handle). Please report this error using Help -> Submit Bug Report."
        End If
        
        'Release FreeImage from memory
        FreeLibrary hLib
        
        'Delete our temporary layer
        mruThumb.eraseLayer
        Set mruThumb = Nothing
    
    End If

End Sub

'Empty the entire MRU list and clear the menu of all entries
Public Sub MRU_ClearList()
    
    Dim i As Long
    
    'Delete all menu items
    For i = FormMain.mnuRecDocs.Count - 1 To 1 Step -1
        Unload FormMain.mnuRecDocs(i)
    Next i
    FormMain.mnuRecDocs(0).Caption = g_Language.TranslateMessage("Empty")
    FormMain.mnuRecDocs(0).Enabled = False
    FormMain.MnuRecentSepBar1.Visible = False
    FormMain.MnuClearMRU.Visible = False
    
    'If thumbnails exist, delete them
    Dim tmpFilename As String
    
    For i = 0 To numEntries
        tmpFilename = getMRUThumbnailPath(i)
        If FileExist(tmpFilename) Then Kill tmpFilename
    Next i
    
    'Reset the number of entries in the MRU list
    numEntries = 0
    ReDim MRUlist(0) As String
    
    'Clear all entries in the preferences file
    For i = 0 To RECENT_FILE_COUNT - 1
        g_UserPreferences.SetPref_String "MRU", "f" & i, ""
    Next i
    
    'Reset the MRU count in the preferences file
    g_UserPreferences.SetPref_Long "MRU", "Number Of Entries", 0
    
    'The icons in the MRU sub-menu need to be reset after this action
    resetMenuIcons

End Sub

'Return how many MRU entries are currently in the menu
Public Function MRU_ReturnCount() As Long
    MRU_ReturnCount = numEntries
End Function

'Truncates a path to a specified number of characters by replacing path components with ellipses.
' (Originally written by Randy Birch @ http://vbnet.mvps.org/index.html?code/fileapi/pathcompactpathex.htm)
Private Function getShortMRU(ByVal sPath As String) As String

    Dim ret As Long
    Dim buff As String
      
    buff = Space$(MAX_PATH)
    ret = PathCompactPathEx(buff, sPath, maxMRULength + 1, 0&)
   
    getShortMRU = TrimNull(buff)
   
End Function

'Remove null characters from a string
Private Function TrimNull(ByVal sString As String) As String
   TrimNull = Left$(sString, lstrlenW(StrPtr(sString)))
End Function

