Attribute VB_Name = "Toolbar"
'***************************************************************************
'Toolbar Interface
'Copyright �2000-2013 by Tanner Helland
'Created: 4/15/01
'Last updated: 20/November/12
'Last update: Add a constant for toggling an image's color mode between 24bpp and 32bpp
'
'Module for enabling/disabling toolbar buttons and menus.  Note that the toolbar was removed in June '12 in favor of
' the new left-hand bar; this module remains, however, because the code handles menu items and the left-hand bar
' (not just toolbar-related code, regardless of what the name implies :).
'
'***************************************************************************

Option Explicit

Public Const tOpen As Byte = 0
Public Const tSave As Byte = 1
Public Const tSaveAs As Byte = 2
Public Const tCopy As Byte = 3
Public Const tPaste As Byte = 4
Public Const tUndo As Byte = 5
Public Const tImageOps As Byte = 6
Public Const tFilter As Byte = 7
Public Const tRedo As Byte = 8
'Public Const tHistogram As Byte = 9
Public Const tMacro As Byte = 10
Public Const tEdit As Byte = 11
Public Const tRepeatLast As Byte = 12
Public Const tSelection As Byte = 13
Public Const tImgMode32bpp As Byte = 14

'tInit enables or disables a specified button and/or menu item
Public Sub tInit(tButton As Byte, tState As Boolean)
    
    Select Case tButton
        
        'Open (left-hand panel button AND menu item)
        Case tOpen
            If FormMain.MnuOpen.Enabled <> tState Then
                FormMain.cmdOpen.Enabled = tState
                FormMain.MnuOpen.Enabled = tState
            End If
            
        'Save (left-hand panel button AND menu item)
        Case tSave
            If FormMain.MnuSave.Enabled <> tState Then
                FormMain.cmdSave.Enabled = tState
                FormMain.MnuSave.Enabled = tState
            End If
            
        'Save As (menu item only)
        Case tSaveAs
            If FormMain.MnuSaveAs.Enabled <> tState Then
                FormMain.cmdSaveAs.Enabled = tState
                FormMain.MnuSaveAs.Enabled = tState
            End If
        
        'Copy (menu item only)
        Case tCopy
            If FormMain.MnuCopy.Enabled <> tState Then FormMain.MnuCopy.Enabled = tState
        
        'Paste (menu item only)
        Case tPaste
            If FormMain.MnuPaste.Enabled <> tState Then FormMain.MnuPaste.Enabled = tState
        
        'Undo (left-hand panel button AND menu item)
        Case tUndo
            If FormMain.MnuUndo.Enabled <> tState Then
                FormMain.cmdUndo.Enabled = tState
                FormMain.MnuUndo.Enabled = tState
            End If
            'If Undo is being enabled, change the text to match the relevant action that created this Undo file
            If tState = True Then
                FormMain.cmdUndo.ToolTip = GetNameOfProcess(pdImages(CurrentImage).getUndoProcessID)
                FormMain.MnuUndo.Caption = g_Language.TranslateMessage("Undo:") & " " & GetNameOfProcess(pdImages(CurrentImage).getUndoProcessID)
                ResetMenuIcons
            Else
                FormMain.cmdUndo.ToolTip = ""
                FormMain.MnuUndo.Caption = g_Language.TranslateMessage("Undo")
                ResetMenuIcons
            End If
            
        'ImageOps is all Image-related menu items; it enables/disables the Image, Color, View (most items, anyway), and Print menus
        Case tImageOps
            If FormMain.MnuImage.Enabled <> tState Then
                FormMain.MnuImage.Enabled = tState
                'Use this same command to disable other menus
                FormMain.MnuColorTop.Enabled = tState
                FormMain.MnuPrint.Enabled = tState
                FormMain.MnuWindowTop.Enabled = tState
                FormMain.MnuFitOnScreen.Enabled = tState
                FormMain.MnuFitWindowToImage.Enabled = tState
                FormMain.MnuZoomIn.Enabled = tState
                FormMain.MnuZoomOut.Enabled = tState
                
                Dim i As Long
                
                For i = 0 To FormMain.MnuSpecificZoom.Count - 1
                    FormMain.MnuSpecificZoom(i).Enabled = tState
                Next i
                
            End If
        
        'Filter (top-level menu)
        Case tFilter
            If FormMain.MnuFilter.Enabled <> tState Then FormMain.MnuFilter.Enabled = tState
        
        'Redo (left-hand panel button AND menu item)
        Case tRedo
            If FormMain.MnuRedo.Enabled <> tState Then
                FormMain.cmdRedo.Enabled = tState
                FormMain.MnuRedo.Enabled = tState
            End If
            
            'If Redo is being enabled, change the menu text to match the relevant action that created this Undo file
            If tState = True Then
                FormMain.cmdRedo.ToolTip = GetNameOfProcess(pdImages(CurrentImage).getRedoProcessID)
                FormMain.MnuRedo.Caption = g_Language.TranslateMessage("Redo:") & " " & GetNameOfProcess(pdImages(CurrentImage).getRedoProcessID) '& vbTab & "Ctrl+Alt+Z"
                ResetMenuIcons
            Else
                FormMain.cmdRedo.ToolTip = ""
                FormMain.MnuRedo.Caption = g_Language.TranslateMessage("Redo")
                ResetMenuIcons
            End If
            
        'Macro (top-level menu)
        Case tMacro
            If FormMain.mnuTool(2).Enabled <> tState Then FormMain.mnuTool(2).Enabled = tState
        
        'Edit (top-level menu)
        Case tEdit
            If FormMain.MnuEdit.Enabled <> tState Then FormMain.MnuEdit.Enabled = tState
        
        'Repeat last action (menu item only)
        Case tRepeatLast
            If FormMain.MnuRepeatLast.Enabled <> tState Then FormMain.MnuRepeatLast.Enabled = tState
            
        'Selections
        Case tSelection
            FormMain.tudSelLeft.Visible = tState
            FormMain.tudSelTop.Visible = tState
            FormMain.tudSelWidth.Visible = tState
            FormMain.tudSelHeight.Visible = tState
            FormMain.lblSelSize.Visible = tState
            FormMain.lblSelPosition.Visible = tState
            
            'Selection enabling/disabling also affects the Crop to Selection command
            If FormMain.MnuCropSelection.Enabled <> tState Then FormMain.MnuCropSelection.Enabled = tState
            
        '32bpp color mode
        Case tImgMode32bpp
            
            'NOTE: because the corresponding menu entries are "checkable", added images won't render nicely in unthemed environments.
            '       Thus, only activate the checked state if theming IS enabled.
            If g_IsThemingEnabled And g_IsVistaOrLater Then
            
                'tState = True indicates 32bpp mode.
                If tState Then
                    FormMain.MnuImageMode32bpp.Checked = True
                    FormMain.MnuImageMode24bpp.Checked = False
                'tState = False indicates 24bpp mode.
                Else
                    FormMain.MnuImageMode24bpp.Checked = True
                    FormMain.MnuImageMode32bpp.Checked = False
                End If
                
            End If
            
            'Update the menu icons to match.  In unthemed environments, this is the only visual clue they will receive about the present mode.
            updateModeIcon tState
            
    End Select
    
End Sub
