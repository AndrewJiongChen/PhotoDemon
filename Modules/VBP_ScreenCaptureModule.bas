Attribute VB_Name = "Screen_Capture"
'***************************************************************************
'Screen Capture Interface
'Copyright 1999-2015 by Tanner Helland
'Created: 12/June/99
'Last updated: 27/June/14
'Last update: sanitize window titles before converting them to filenames; otherwise, subsequent Save/Save As functions may fail
'
'Description: this module captures the screen.  The options are fairly minimal - it only captures
'             the entire screen, but it does give the user the option to minimize the form first.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'Various API calls required for screen capturing
Public Declare Function GetDesktopWindow Lib "user32" () As Long
Public Declare Function GetDC Lib "user32" (ByVal hWnd As Long) As Long
Public Declare Function ReleaseDC Lib "user32" (ByVal hWnd As Long, ByVal hDC As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function BitBlt Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function PrintWindow Lib "user32" (ByVal hWnd As Long, ByVal hDC As Long, ByVal nFlags As Long) As Long
Private Declare Function GetWindowRect Lib "user32" (ByVal hndWindow As Long, ByRef lpRect As winRect) As Long
Private Declare Function GetClientRect Lib "user32" (ByVal hndWindow As Long, ByRef lpRect As winRect) As Long
Private Const PW_CLIENTONLY As Long = &H1

Private Declare Function IsWindowVisible Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function GetParent Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long
Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hWnd As Long, ByVal lpString As String, ByVal cch As Long) As Long

'Constant used to determine window owner.
Private Const GWL_HWNDPARENT = (-8)

'Listbox messages
Private Const LB_ADDSTRING = &H180
Private Const LB_SETITEMDATA = &H19A

'ShowWindow is used to minimize and restore the PhotoDemon window, if requested.  Using VB's internal .WindowState
' command doesn't notify the window manager (I have no idea why) so this necessary to prevent parts of the toolbar
' client areas from disappearing upon restoration.
Private Const SW_MINIMIZE As Long = 6
Private Const SW_RESTORE As Long = 9
Private Declare Function ShowWindow Lib "user32" (ByVal hndWindow As Long, ByVal nCmdShow As Long) As Long

'Simple routine for capturing the screen and loading it as an image
Public Sub CaptureScreen(ByVal captureFullDesktop As Boolean, ByVal minimizePD As Boolean, ByVal alternateWindowHwnd As Long, ByVal includeChrome As Boolean, Optional ByVal windowName As String)
    
    Message "Capturing screen..."
        
    'If the user wants us to minimize the form, obey their orders
    If captureFullDesktop And minimizePD Then ShowWindow FormMain.hWnd, SW_MINIMIZE
    
    'The capture happens so quickly that the message box prompting the capture will be caught in the snapshot.  Sleep for 1/2 of a second
    ' to give the message box time to disappear
    Sleep 500
    
    'Use the getDesktopAsDIB function to copy the requested screen contents into a temporary DIB
    Dim tmpDIB As pdDIB
    Set tmpDIB = New pdDIB
    
    If captureFullDesktop Then
        getDesktopAsDIB tmpDIB
    Else
        If Not getHwndContentsAsDIB(tmpDIB, alternateWindowHwnd, includeChrome) Then
            Message "Could not retrieve program window - the program appears to have been unloaded."
            Exit Sub
        End If
    End If
    
    'If we minimized the main window, now's the time to return it to normal size
    If captureFullDesktop And minimizePD Then
        ShowWindow FormMain.hWnd, SW_RESTORE
        g_WindowManager.refreshAllWindows
    End If
    
    'Set the picture of the form to equal its image
    Dim tmpFilename As String
    tmpFilename = g_UserPreferences.GetTempPath & PROGRAMNAME & " Screen Capture.tmp"
    
    'Ask the DIB to write out its data to file in BMP format
    tmpDIB.writeToBitmapFile tmpFilename
        
    'We are now done with the temporary DIB, so free it up
    tmpDIB.eraseDIB
    Set tmpDIB = Nothing
        
    'Once the capture is saved, load it up like any other bitmap
    ' NOTE: Because LoadFileAsNewImage requires an array of strings, create an array to send to it
    Dim sFile(0) As String
    sFile(0) = tmpFilename
    
    Dim sTitle As String
    If captureFullDesktop Then
        sTitle = g_Language.TranslateMessage("Screen Capture")
    Else
        sTitle = windowName
    End If
    
    'Sanitize the calculated string to remove any potentially invalid characters
    Dim cFile As pdFSO
    Set cFile = New pdFSO
    
    sTitle = cFile.MakeValidWindowsFilename(sTitle)
    
    Dim sTitlePlusDate As String
    sTitlePlusDate = sTitle & " (" & Day(Now) & " " & MonthName(Month(Now)) & " " & Year(Now) & ")"
    
    LoadFileAsNewImage sFile, False, sTitle, sTitlePlusDate
    
    'Erase the temp file
    If cFile.FileExist(tmpFilename) Then cFile.KillFile tmpFilename
    
    Message "Screen capture complete."
    
End Sub

'Use this function to return a copy of the current desktop in DIB format
Public Sub getDesktopAsDIB(ByRef dstDIB As pdDIB)

    'Use the g_Displays object to detect VIRTUAL screen size.  This will capture all monitors on a multimonitor arrangement,
    ' not just the primary one.
    Dim screenLeft As Long, screenTop As Long
    Dim screenWidth As Long, screenHeight As Long
    
    screenLeft = g_Displays.getDesktopLeft
    screenTop = g_Displays.getDesktopTop
    screenWidth = g_Displays.getDesktopWidth
    screenHeight = g_Displays.getDesktopHeight
    
    #If DEBUGMODE = 1 Then
        pdDebug.LogAction "Preparing to capture screen using rect (" & screenLeft & ", " & screenTop & ")x(" & screenWidth & ", " & screenHeight & ")"
    #End If
    
    'Retrieve an hWnd and DC for the screen
    Dim screenHwnd As Long, desktopDC As Long
    screenHwnd = GetDesktopWindow()
    desktopDC = GetDC(screenHwnd)
    
    'Copy the bitmap into the specified DIB
    dstDIB.createBlank screenWidth, screenHeight, 32
    BitBlt dstDIB.getDIBDC, 0, 0, screenWidth, screenHeight, desktopDC, 0, 0, vbSrcCopy
    
    'Release everything we generated for the capture, then exit
    ReleaseDC screenHwnd, desktopDC

End Sub

'Use this function to return a subsection of the current desktop in DIB format.
' IMPORTANT NOTE: the source rect should be in *desktop coordinates*, which may not be zero-based on a multimonitor system.
Public Sub getPartialDesktopAsDIB(ByRef dstDIB As pdDIB, ByRef srcRect As RECTL)

    'Use the g_Displays object to detect VIRTUAL screen size.  This will capture all monitors on a multimonitor arrangement,
    ' not just the primary one.
    Dim screenLeft As Long, screenTop As Long
    Dim screenWidth As Long, screenHeight As Long
    
    screenLeft = g_Displays.getDesktopLeft
    screenTop = g_Displays.getDesktopTop
    screenWidth = g_Displays.getDesktopWidth
    screenHeight = g_Displays.getDesktopHeight
    
    'Retrieve an hWnd and DC for the screen
    Dim screenHwnd As Long, desktopDC As Long
    screenHwnd = GetDesktopWindow()
    desktopDC = GetDC(screenHwnd)
    
    'BitBlt the relevant portion of the screen into the specified DIB
    dstDIB.createBlank srcRect.Right - srcRect.Left, srcRect.Bottom - srcRect.Top, 24
    BitBlt dstDIB.getDIBDC, 0, 0, srcRect.Right - srcRect.Left, srcRect.Bottom - srcRect.Top, desktopDC, srcRect.Left, srcRect.Top, vbSrcCopy
    
    'Release everything we generated for the capture, then exit
    ReleaseDC screenHwnd, desktopDC
    
End Sub

'Copy the visual contents of any hWnd into a DIB; window chrome can be optionally included, if desired
Public Function getHwndContentsAsDIB(ByRef dstDIB As pdDIB, ByVal targetHwnd As Long, Optional ByVal includeChrome As Boolean = True) As Boolean

    'Start by retrieving the necessary dimensions from the target window
    Dim targetRect As winRect
    
    If includeChrome Then
        GetWindowRect targetHwnd, targetRect
    Else
        GetClientRect targetHwnd, targetRect
    End If
    
    'Check to make sure the window hasn't been unloaded
    If (targetRect.x2 - targetRect.x1 = 0) Or (targetRect.y2 - targetRect.y1 = 0) Then
        getHwndContentsAsDIB = False
        Exit Function
    End If
    
    'Prepare the DIB at the proper size
    dstDIB.createBlank targetRect.x2 - targetRect.x1, targetRect.y2 - targetRect.y1
    
    'Ask the window in question to paint itself into our DIB
    If includeChrome Then
        PrintWindow targetHwnd, dstDIB.getDIBDC, 0
    Else
        PrintWindow targetHwnd, dstDIB.getDIBDC, PW_CLIENTONLY
    End If
    
    getHwndContentsAsDIB = True
    
End Function

'The EnumWindows API call will call this function repeatedly until it exhausts the full list of open windows.
' We apply additional checks to the windows it returns to make sure there are no unwanted additions (hidden windows, etc).
Public Function EnumWindowsProc(ByVal hWnd As Long, ByVal lParam As Long) As Long

    Static WindowText As String
    Static nRet As Long
    
    'Only return visible windows
    If IsWindowVisible(hWnd) Then
    
        'Only return windows without parents (to exclude toolbars, etc)
        If GetParent(hWnd) = 0 Then
            
            'Only return windows with a size larger than 0
            Dim tmpRect As winRect
            GetWindowRect hWnd, tmpRect
            
            If ((tmpRect.x2 - tmpRect.x1) > 0) And ((tmpRect.y2 - tmpRect.y1) > 0) Then
            
                'Only return windows with a client size larger than 0
                GetClientRect hWnd, tmpRect
                
                If ((tmpRect.x2 - tmpRect.x1) > 0) And ((tmpRect.y2 - tmpRect.y1) > 0) Then
                    
                    'Retrieve the window's caption
                    WindowText = Space$(256)
                    nRet = GetWindowText(hWnd, WindowText, Len(WindowText))
                    
                    'If window text was obtained, trim it and add this entry to the list
                    If nRet Then
                    
                        WindowText = Left$(WindowText, nRet)
                        nRet = SendMessageA(lParam, LB_ADDSTRING, ByVal 0&, ByVal WindowText)
                        Call SendMessageA(lParam, LB_SETITEMDATA, nRet, ByVal hWnd)
                    
                    End If
                    
                End If
            End If
        End If
    End If
    
    'Return True, which instructs the function to continue enumerating window entries.
    EnumWindowsProc = True

End Function
