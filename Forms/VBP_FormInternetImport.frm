VERSION 5.00
Begin VB.Form FormInternetImport 
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Download Image"
   ClientHeight    =   2340
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   10050
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
   ScaleHeight     =   156
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   670
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   495
      Left            =   7080
      TabIndex        =   0
      Top             =   1710
      Width           =   1365
   End
   Begin VB.CommandButton CmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   8550
      TabIndex        =   1
      Top             =   1710
      Width           =   1365
   End
   Begin VB.TextBox txtURL 
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800000&
      Height          =   360
      Left            =   240
      TabIndex        =   2
      Text            =   "http://"
      Top             =   720
      Width           =   9615
   End
   Begin VB.Label lblCopyrightWarning 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "Copyright"
      ForeColor       =   &H00808080&
      Height          =   615
      Left            =   240
      TabIndex        =   4
      Top             =   1725
      Width           =   6735
   End
   Begin VB.Label lblBackground 
      Height          =   855
      Left            =   0
      TabIndex        =   5
      Top             =   1560
      Width           =   10095
   End
   Begin VB.Label lblDownloadPath 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "full download path (must begin with ""http://"" or ""ftp://""):"
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
      Left            =   120
      TabIndex        =   3
      Top             =   360
      Width           =   6090
   End
End
Attribute VB_Name = "FormInternetImport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'Internet Interface (for importing images directly from a URL)
'Copyright �2011-2013 by Tanner Helland
'Created: 08/June/12
'Last updated: 03/December/12
'Last update: made some slight modifications to ImportImageFromInternet so it can be used by external callers.
'
'Interface for downloading images directly from the Internet into PhotoDemon.  This code is a heavily
' modified version of publicly available code by Alberto Falossi (http://www.devx.com/vb2themax/Tip/19203).
'
'A number of features have been added to the original version of this code.  The routine checks the file download
' size, and updates the user (via progress bar) on the download progress.  Many checks are in place to protect
' against Internet and download errors.  I'm quite proud of how robust this implementation is, but additional
' testing will be necessary to make sure no possible connectivity errors have been overlooked.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'Custom tooltip class allows for things like multiline, theming, and multiple monitor support
Dim m_ToolTip As clsToolTip

'Import an image from the Internet; all that's required is a valid URL (must be prefaced with http:// or ftp://)
Public Function ImportImageFromInternet(ByVal URL As String) As Boolean

    'First things first - prompt the user for a URL
    If URL = "" Then
        Message "Image download canceled."
        Exit Function
    End If
    
    'Normally changing the cursor is handled by the software processor, but because this function routes
    ' internally, we'll make an exception and change it here. Note that everywhere this function can
    ' terminate (and it's many places - a lot can go wrong while downloading) - the cursor needs to be reset.
    Screen.MousePointer = vbHourglass
    
    'Open an Internet session and assign it a handle
    Dim hInternetSession As Long
    
    Message "Attempting to connect to Internet..."
    hInternetSession = InternetOpen(App.EXEName, INTERNET_OPEN_TYPE_PRECONFIG, vbNullString, vbNullString, 0)
    
    If hInternetSession = 0 Then
        pdMsgBox "%1 could not establish an Internet connection. Please double-check your connection.  If the problem persists, try downloading the image manually using your Internet browser of choice.  Once downloaded, you may open the file in %1 just like any other image file.", vbExclamation + vbApplicationModal + vbOKOnly, "Internet Connection Error", PROGRAMNAME
        ImportImageFromInternet = False
        Screen.MousePointer = 0
        Exit Function
    End If
    
    'Using the new Internet session, attempt to find the URL; if found, assign it a handle
    Message "Verifying image URL (this may take a moment)..."
    
    Dim hUrl As Long
    hUrl = InternetOpenUrl(hInternetSession, URL, vbNullString, 0, INTERNET_FLAG_RELOAD, 0)

    If hUrl = 0 Then
        pdMsgBox "%1 could not locate a valid image at that URL.  Please double-check the path.  If the problem persists, try downloading the image manually using your Internet browser of choice.  Once downloaded, you may open the file in %1 just like any other image file.", vbExclamation + vbApplicationModal + vbOKOnly, "Online Image Not Found", PROGRAMNAME
        If hInternetSession Then InternetCloseHandle hInternetSession
        ImportImageFromInternet = False
        Screen.MousePointer = 0
        Exit Function
    End If
    
    'Check the size of the image to be downloaded...
    Dim downloadSize As Long
    Dim tmpStrBuffer As String
    tmpStrBuffer = String$(1024, 0)
    Call HttpQueryInfo(ByVal hUrl, HTTP_QUERY_CONTENT_LENGTH, ByVal tmpStrBuffer, Len(tmpStrBuffer), 0)
    downloadSize = CLng(Val(tmpStrBuffer))
    SetProgBarVal 0
    If downloadSize <> 0 Then SetProgBarMax downloadSize
    
    'We need a temporary file to house the image; generate it automatically, using the extension of the original image
    Message "Creating temporary file..."
    Dim tmpFilename As String
    tmpFilename = URL
    StripFilename tmpFilename
    makeValidWindowsFilename tmpFilename
    
    Dim tmpFile As String
    tmpFile = g_UserPreferences.getTempPath & tmpFilename
    
    'Open the temporary file and begin downloading the image to it
    Message "Image URL verified.  Downloading image..."
    Dim fileNum As Integer
    fileNum = FreeFile
    Open tmpFile For Binary As fileNum
    
        'Prepare a receiving buffer (this will be used to hold chunks of the image)
        Dim Buffer As String
        Buffer = Space(4096)
   
        'We will need to verify each chunk as its downloaded
        Dim chunkOK As Boolean
   
        'This will track the size of each chunk
        Dim numOfBytesRead As Long
   
        'This will track of how many bytes we've downloaded so far
        Dim totalBytesRead As Long
        totalBytesRead = 0
   
        Do
   
            'Read the next chunk of the image
            chunkOK = InternetReadFile(hUrl, Buffer, Len(Buffer), numOfBytesRead)
   
            'If something went wrong, terminate
            If chunkOK = False Then
                pdMsgBox "%1 lost access to the Internet. Please double-check your Internet connection.  If the problem persists, try downloading the image manually using your Internet browser of choice.  Once downloaded, you may open the file in %1 just like any other image file.", vbExclamation + vbApplicationModal + vbOKOnly, "Internet Connection Error", PROGRAMNAME
                If FileExist(tmpFile) Then
                    Close #fileNum
                    Kill tmpFile
                End If
                If hUrl Then InternetCloseHandle hUrl
                If hInternetSession Then InternetCloseHandle hInternetSession
                SetProgBarVal 0
                ImportImageFromInternet = False
                Screen.MousePointer = 0
                Exit Function
            End If
   
            'If the file is done, exit this loop
            If numOfBytesRead = 0 Then
                Exit Do
            End If
   
            'If we've made it this far, assume we've received legitimate data.  Place that data into the file.
            Put #fileNum, , Left$(Buffer, numOfBytesRead)
   
            totalBytesRead = totalBytesRead + numOfBytesRead
            
            If downloadSize <> 0 Then
                SetProgBarVal totalBytesRead
                Message "Image URL verified.  Downloading image (%1 of %2 bytes received)...", totalBytesRead, downloadSize
            End If
            
            'DoEvents
            
        'Carry on
        Loop
        
    'Close the temporary file
    Close #fileNum
    
    'Close this URL and Internet session
    If hUrl Then InternetCloseHandle hUrl
    If hInternetSession Then InternetCloseHandle hInternetSession
    
    Message "Download complete. Verifying file integrity..."
    
    'Check to make sure the image downloaded; if the size is unreasonably small, we can assume the site
    ' prevented our download.  (Direct downloads are sometimes treated as hotlinking; similarly, some sites
    ' prevent scraping, which a direct download like this may seem to be.)
    If totalBytesRead < 20 Then
        Message "Download canceled.  (Remote server denied access.)"
        Dim domainName As String
        domainName = GetDomainName(URL)
        pdMsgBox "Unfortunately, %1 is preventing %2 from directly downloading this image. (Direct downloads are sometimes mistaken as hotlinking by misconfigured servers.)" & vbCrLf & vbCrLf & "You will need to download this image using your Internet browser of choice, then manually load it into %2." & vbCrLf & vbCrLf & "I sincerely apologize for this inconvenience, but unfortunately there is nothing %2 can do about stingy server configurations.  :(", vbCritical + vbApplicationModal + vbOKOnly, "Download Unsuccessful", domainName, PROGRAMNAME
        If FileExist(tmpFile) Then Kill tmpFile
        If hUrl Then InternetCloseHandle hUrl
        If hInternetSession Then InternetCloseHandle hInternetSession
        SetProgBarVal 0
        ImportImageFromInternet = False
        Screen.MousePointer = 0
        Exit Function
    End If
    
    'If we've made it this far, it's probably safe to assume that download worked.  Attempt to load the image.
    Dim sFile(0) As String
    sFile(0) = tmpFile
    
    PreLoadImage sFile, False, tmpFilename, tmpFilename
    
    'Unique to this particular import is remembering the full filename + extension (because this method of import
    ' actually supplies a file extension, unlike scanning or screen capturing or something else)
    If Not pdImages(g_CurrentImage) Is Nothing Then pdImages(g_CurrentImage).OriginalFileNameAndExtension = tmpFilename
    
    SetProgBarVal 0
    
    'Delete the temporary file
    If FileExist(tmpFile) Then Kill tmpFile
    
    Message "Image download complete. "
    
    Screen.MousePointer = 0
    
    ImportImageFromInternet = True
    
End Function

'CANCEL button
Private Sub CmdCancel_Click()
    Message "Internet import canceled."
    Unload Me
End Sub

'OK Button
Private Sub CmdOK_Click()
    
    'Check to make sure the user followed directions
    Dim fullURL As String
    fullURL = txtURL
    
    If (Left$(fullURL, 7) <> "http://") And (Left$(fullURL, 6) <> "ftp://") Then
        pdMsgBox "This URL is not valid.  Please make sure the URL begins with ""http://"" or ""ftp://"".", vbApplicationModal + vbOKOnly + vbExclamation, "Invalid URL"
        AutoSelectText txtURL
        Exit Sub
    End If
    
    'If we've made it here, assume the URL is valid
    Me.Visible = False
    
    'Attempt to download the image
    Dim downloadSuccessful As Boolean
    downloadSuccessful = ImportImageFromInternet(fullURL)
    
    'If the download failed, show the user this form (so they can try again).  Otherwise, unload this form.
    If downloadSuccessful = False Then Me.Visible = True Else Unload Me
    
End Sub

'When the form is activated, automatically select the text box for the user.  This makes a quick Ctrl+V possible.
Private Sub Form_Activate()
    AutoSelectText txtURL
End Sub

'LOAD form
Private Sub Form_Load()

    lblCopyrightWarning.Caption = g_Language.TranslateMessage("Please be respectful of copyrights when downloading images.  Even if an image is available online, it may not be licensed for use outside a specific website. Thanks!")

    Message "Waiting for user input..."
    
    'Assign the system hand cursor to all relevant objects
    Set m_ToolTip = New clsToolTip
    makeFormPretty Me, m_ToolTip

End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseFormTheming Me
End Sub

