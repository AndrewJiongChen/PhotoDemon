Attribute VB_Name = "Misc_Uncategorized"
'***************************************************************************
'Miscellaneous Operations Handler
'Copyright 2001-2016 by Tanner Helland
'Created: 6/12/01
'Last updated: 13/June/13
'Last update: removed many functions into new dedicated Math and Color modules
'
'If a function doesn't have a home in a more appropriate module, it gets stuck here. Over time, I'm
' hoping to clear out most of this module in favor of a more organized approach.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'Types and API calls for processing ESC keypresses mid-loop
Private Type winMsg
    hWnd As Long
    sysMsg As Long
    wParam As Long
    lParam As Long
    msgTime As Long
    ptX As Long
    ptY As Long
End Type

'Private Declare Function TranslateMessage Lib "user32" (lpMsg As winMsg) As Long
'Private Declare Function DispatchMessage Lib "user32" Alias "DispatchMessageA" (lpMsg As winMsg) As Long
Private Declare Function GetInputState Lib "user32" () As Long
Private Declare Function PeekMessage Lib "user32" Alias "PeekMessageA" (ByRef lpMsg As winMsg, ByVal hWnd As Long, ByVal wMsgFilterMin As Long, ByVal wMsgFilterMax As Long, ByVal wRemoveMsg As Long) As Long
Private Const WM_KEYFIRST As Long = &H100
Private Const WM_KEYLAST As Long = &H108
Private Const PM_REMOVE As Long = &H1

Public cancelCurrentAction As Boolean

'Wait for (n) milliseconds, while still providing some interactivity via DoEvents.  Thank you to vbforums user "anhn" for the
' original version of this function, available here: http://www.vbforums.com/showthread.php?546633-VB6-Sleep-Function.
' Please note that his original code has been modified for use in PhotoDemon.
Public Sub PauseProgram(ByRef secsDelay As Double)
   
   Dim TimeOut   As Double
   Dim PrevTimer As Double
   
   PrevTimer = Timer
   TimeOut = PrevTimer + secsDelay
   Do While PrevTimer < TimeOut
      Sleep 2 '-- Timer is only updated every 1/128 sec
      DoEvents
      If Timer < PrevTimer Then TimeOut = TimeOut - 86400 '-- pass midnight
      PrevTimer = Timer
   Loop
   
End Sub

'This function will quickly and efficiently check the last unprocessed keypress submitted by the user.  If an ESC keypress was found,
' this function will return TRUE.  It is then up to the calling function to determine how to proceed.
Public Function userPressedESC(Optional ByVal displayConfirmationPrompt As Boolean = True) As Boolean

    Dim tmpMsg As winMsg
    
    'GetInputState returns a non-0 value if key or mouse events are pending.  By Microsoft's own admission, it is much faster
    ' than PeekMessage, so to keep things fast we check it before manually inspecting individual messages
    ' (see http://support.microsoft.com/kb/35605 for more details)
    If GetInputState() Then
    
        'Use the WM_KEYFIRST/LAST constants to explicitly request only keypress messages.  If the user has pressed multiple
        ' keys besides just ESC, this function may not operate as intended.  (Per the MSDN documentation: "...the first queued
        ' message that matches the specified filter is retrieved.")  We could technically parse all keypress messages and look
        ' for just ESC, but this would slow the function without providing any clear benefit.
        PeekMessage tmpMsg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE
        
        'ESC keypress found!
        If tmpMsg.wParam = vbKeyEscape Then
            
            'If the calling function requested a confirmation prompt, display it now; otherwise exit immediately.
            If displayConfirmationPrompt Then
                Dim msgReturn As VbMsgBoxResult
                msgReturn = PDMsgBox("Are you sure you want to cancel %1?", vbInformation + vbYesNo + vbApplicationModal, "Cancel image processing", LastProcess.Id)
                If msgReturn = vbYes Then cancelCurrentAction = True Else cancelCurrentAction = False
            Else
                cancelCurrentAction = True
            End If
            
        Else
            cancelCurrentAction = False
        End If
        
    Else
        cancelCurrentAction = False
    End If
    
    userPressedESC = cancelCurrentAction
    
End Function

'Populate a text box with a given integer value. This is done constantly across the program, so I use a sub to handle it, as
' there may be additional validations that need to be performed, and it's nice to be able to adjust those from a single location.
Public Sub copyToTextBoxI(ByRef dstTextBox As TextBox, ByVal srcValue As Long)

    'Remember the current cursor position
    Dim cursorPos As Long
    cursorPos = dstTextBox.SelStart

    'Overwrite the current text box value with the new value
    dstTextBox = CStr(srcValue)
    dstTextBox.Refresh
    
    'Restore the cursor to its original position
    If cursorPos >= Len(dstTextBox) Then cursorPos = Len(dstTextBox)
    dstTextBox.SelStart = cursorPos

End Sub

'Populate a text box with a given floating-point value. This is done constantly across the program, so I use a sub to handle it, as
' there may be additional validations that need to be performed, and it's nice to be able to adjust those from a single location.
Public Sub copyToTextBoxF(ByVal srcValue As Double, ByRef dstTextBox As TextBox, Optional ByVal numOfSD As Long = 2)

    'Remember the current cursor position
    Dim cursorPos As Long
    cursorPos = dstTextBox.SelStart

    'PhotoDemon never allows more than two significant digits for floating-point text boxes
    If numOfSD = 2 Then
        dstTextBox = Format(Str(srcValue), "#0.00")
    Else
        dstTextBox = Format(Str(srcValue), "#0.0")
    End If
    dstTextBox.Refresh
    
    'Restore the cursor to its original position
    If cursorPos >= Len(dstTextBox) Then cursorPos = Len(dstTextBox)
    dstTextBox.SelStart = cursorPos

End Sub

'Find out whether the mouse pointer is over image contents or just the viewport
Public Function isMouseOverImage(ByVal x1 As Long, ByVal y1 As Long, ByRef srcImage As pdImage) As Boolean

    If srcImage.imgViewport Is Nothing Then
        isMouseOverImage = False
        Exit Function
    End If
    
    'Make sure the image is currently visible in the viewport
    If srcImage.imgViewport.getIntersectState Then
        
        'Remember: the imgViewport's intersection rect contains the intersection of the canvas and the image.
        ' If the target point lies inside this, it's over the image!
        Dim intRect As RECTF
        srcImage.imgViewport.getIntersectRectCanvas intRect
        isMouseOverImage = Math_Functions.isPointInRectF(x1, y1, intRect)
        
    Else
        isMouseOverImage = False
    End If

End Function

'Find out whether the mouse pointer is over a given layer in an image
Public Function isMouseOverLayer(ByVal imgX As Long, ByVal imgY As Long, ByRef srcImage As pdImage, ByRef srcLayerIndex As Long) As Boolean

    If srcImage.imgViewport Is Nothing Then
        isMouseOverLayer = False
        Exit Function
    End If
    
    With srcImage.getLayerByIndex(srcLayerIndex)
    
        If (imgX >= .getLayerOffsetX) And (imgX <= .getLayerOffsetX + .getLayerWidth(False)) Then
            If (imgY >= .getLayerOffsetY) And (imgY <= .getLayerOffsetY + .getLayerHeight(False)) Then
                isMouseOverLayer = True
                Exit Function
            Else
                isMouseOverLayer = False
            End If
            isMouseOverLayer = False
        End If
    
    End With
    
End Function

'Calculate and display the current mouse position.
' INPUTS: x and y coordinates of the mouse cursor, current form, and optionally two Double-type variables to receive the relative
' coordinates (e.g. location on the image) of the current mouse position.
Public Sub displayImageCoordinates(ByVal x1 As Double, ByVal y1 As Double, ByRef srcImage As pdImage, ByRef srcCanvas As pdCanvas, Optional ByRef copyX As Double, Optional ByRef copyY As Double)
    
    'This function simply wraps the relevant Drawing module function
    If Drawing.convertCanvasCoordsToImageCoords(srcCanvas, srcImage, x1, y1, copyX, copyY) Then
        
        'If an image is open, relay the new coordinates to the relevant canvas; it will handle the actual drawing internally
        If g_OpenImageCount > 0 Then srcCanvas.displayCanvasCoordinates copyX, copyY
        
    End If
    
End Sub

'This beautiful little function comes courtesy of coder Merri:
' http://www.vbforums.com/showthread.php?536960-RESOLVED-how-can-i-see-if-the-object-is-array-or-not
Public Function InControlArray(Ctl As Object) As Boolean
    InControlArray = Not Ctl.Parent.Controls(Ctl.Name) Is Ctl
End Function

