VERSION 5.00
Begin VB.Form toolbar_Options 
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   " Tools"
   ClientHeight    =   1455
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   15045
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
   ScaleHeight     =   97
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1003
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox picTools 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1575
      Index           =   1
      Left            =   0
      ScaleHeight     =   105
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   998
      TabIndex        =   1
      Top             =   15
      Visible         =   0   'False
      Width           =   14970
      Begin PhotoDemon.buttonStrip btsMoveOptions 
         Height          =   855
         Left            =   120
         TabIndex        =   50
         Top             =   420
         Width           =   2415
         _ExtentX        =   4895
         _ExtentY        =   1508
      End
      Begin PhotoDemon.pdLabel lblOptions 
         Height          =   240
         Index           =   8
         Left            =   120
         Top             =   60
         Width           =   2700
         _ExtentX        =   1164
         _ExtentY        =   503
         Caption         =   "display:"
      End
      Begin VB.PictureBox picMoveContainer 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1455
         Index           =   0
         Left            =   3000
         ScaleHeight     =   97
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   801
         TabIndex        =   56
         Top             =   0
         Width           =   12015
         Begin PhotoDemon.pdComboBox cboLayerResizeQuality 
            Height          =   300
            Left            =   5190
            TabIndex        =   65
            Top             =   420
            Width           =   2775
            _ExtentX        =   4895
            _ExtentY        =   529
         End
         Begin PhotoDemon.textUpDown tudLayerMove 
            Height          =   345
            Index           =   0
            Left            =   120
            TabIndex        =   57
            Top             =   420
            Width           =   2055
            _ExtentX        =   3625
            _ExtentY        =   609
         End
         Begin PhotoDemon.pdLabel lblOptions 
            Height          =   240
            Index           =   9
            Left            =   120
            Top             =   60
            Width           =   2370
            _ExtentX        =   4180
            _ExtentY        =   503
            Caption         =   "layer position (x, y):"
         End
         Begin PhotoDemon.pdLabel lblOptions 
            Height          =   240
            Index           =   10
            Left            =   2640
            Top             =   60
            Width           =   2370
            _ExtentX        =   4180
            _ExtentY        =   503
            Caption         =   "layer size (w, h):"
         End
         Begin PhotoDemon.textUpDown tudLayerMove 
            Height          =   345
            Index           =   1
            Left            =   120
            TabIndex        =   58
            Top             =   840
            Width           =   2055
            _ExtentX        =   3625
            _ExtentY        =   609
         End
         Begin PhotoDemon.textUpDown tudLayerMove 
            Height          =   345
            Index           =   2
            Left            =   2640
            TabIndex        =   59
            Top             =   420
            Width           =   2055
            _ExtentX        =   3625
            _ExtentY        =   609
         End
         Begin PhotoDemon.textUpDown tudLayerMove 
            Height          =   345
            Index           =   3
            Left            =   2640
            TabIndex        =   60
            Top             =   840
            Width           =   2055
            _ExtentX        =   3625
            _ExtentY        =   609
         End
         Begin PhotoDemon.pdButtonToolbox cmdLayerMove 
            Height          =   570
            Index           =   0
            Left            =   8400
            TabIndex        =   63
            Top             =   420
            Width           =   660
            _ExtentX        =   1164
            _ExtentY        =   1005
            AutoToggle      =   -1  'True
         End
         Begin PhotoDemon.pdButtonToolbox cmdLayerMove 
            Height          =   570
            Index           =   1
            Left            =   9240
            TabIndex        =   64
            Top             =   420
            Width           =   660
            _ExtentX        =   1164
            _ExtentY        =   1005
            AutoToggle      =   -1  'True
         End
         Begin PhotoDemon.pdLabel lblOptions 
            Height          =   240
            Index           =   11
            Left            =   5190
            Top             =   60
            Width           =   3090
            _ExtentX        =   5450
            _ExtentY        =   503
            Caption         =   "non-destructive resize quality:"
         End
         Begin PhotoDemon.pdLabel lblOptions 
            Height          =   240
            Index           =   12
            Left            =   8400
            Top             =   60
            Width           =   3360
            _ExtentX        =   5927
            _ExtentY        =   503
            Caption         =   "non-destructive resize options:"
         End
      End
      Begin VB.PictureBox picMoveContainer 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1455
         Index           =   1
         Left            =   3000
         ScaleHeight     =   97
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   801
         TabIndex        =   51
         Top             =   0
         Width           =   12015
         Begin PhotoDemon.pdLabel lblOptions 
            Height          =   240
            Index           =   0
            Left            =   120
            Top             =   60
            Width           =   5370
            _ExtentX        =   9472
            _ExtentY        =   503
            Caption         =   "interaction options:"
         End
         Begin PhotoDemon.smartCheckBox chkAutoActivateLayer 
            Height          =   330
            Left            =   120
            TabIndex        =   52
            Top             =   450
            Width           =   5370
            _ExtentX        =   9472
            _ExtentY        =   582
            Caption         =   "automatically activate layer beneath mouse"
         End
         Begin PhotoDemon.smartCheckBox chkIgnoreTransparent 
            Height          =   330
            Left            =   120
            TabIndex        =   53
            Top             =   900
            Width           =   5370
            _ExtentX        =   9472
            _ExtentY        =   582
            Caption         =   "ignore transparent pixels when auto-activating layers"
         End
         Begin PhotoDemon.smartCheckBox chkLayerBorder 
            Height          =   330
            Left            =   5640
            TabIndex        =   54
            Top             =   450
            Width           =   5370
            _ExtentX        =   9472
            _ExtentY        =   582
            Caption         =   "show layer borders"
         End
         Begin PhotoDemon.smartCheckBox chkLayerNodes 
            Height          =   330
            Left            =   5640
            TabIndex        =   55
            Top             =   900
            Width           =   5370
            _ExtentX        =   9472
            _ExtentY        =   582
            Caption         =   "show layer transform nodes"
         End
         Begin PhotoDemon.pdLabel lblOptions 
            Height          =   240
            Index           =   1
            Left            =   5640
            Top             =   60
            Width           =   5370
            _ExtentX        =   9472
            _ExtentY        =   503
            Caption         =   "display options:"
         End
      End
   End
   Begin VB.PictureBox picTools 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1455
      Index           =   3
      Left            =   0
      ScaleHeight     =   97
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   1230
      TabIndex        =   15
      TabStop         =   0   'False
      Top             =   15
      Visible         =   0   'False
      Width           =   18450
      Begin PhotoDemon.pdComboBox cboSelSmoothing 
         Height          =   375
         Left            =   2760
         TabIndex        =   3
         Top             =   390
         Width           =   2415
         _ExtentX        =   4260
         _ExtentY        =   635
      End
      Begin PhotoDemon.pdComboBox cboSelRender 
         Height          =   375
         Left            =   120
         TabIndex        =   6
         Top             =   390
         Width           =   2415
         _ExtentX        =   4260
         _ExtentY        =   635
      End
      Begin PhotoDemon.colorSelector csSelectionHighlight 
         Height          =   375
         Left            =   120
         TabIndex        =   16
         Top             =   840
         Width           =   2445
         _ExtentX        =   3916
         _ExtentY        =   661
      End
      Begin PhotoDemon.sliderTextCombo sltSelectionFeathering 
         CausesValidation=   0   'False
         Height          =   495
         Left            =   2640
         TabIndex        =   17
         Top             =   840
         Visible         =   0   'False
         Width           =   2670
         _ExtentX        =   4710
         _ExtentY        =   873
         Max             =   100
      End
      Begin PhotoDemon.pdLabel lblSelection 
         Height          =   240
         Index           =   13
         Left            =   2760
         Top             =   60
         Width           =   2445
         _ExtentX        =   0
         _ExtentY        =   503
         Caption         =   "smoothing"
      End
      Begin PhotoDemon.pdLabel lblSelection 
         Height          =   240
         Index           =   8
         Left            =   120
         Top             =   60
         Width           =   2445
         _ExtentX        =   0
         _ExtentY        =   503
         Caption         =   "appearance"
      End
      Begin VB.PictureBox picSelectionSubcontainer 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1470
         Index           =   0
         Left            =   5340
         ScaleHeight     =   98
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   665
         TabIndex        =   20
         Top             =   0
         Width           =   9975
         Begin PhotoDemon.pdComboBox cboSelArea 
            Height          =   375
            Index           =   0
            Left            =   120
            TabIndex        =   46
            Top             =   390
            Width           =   2415
            _ExtentX        =   4260
            _ExtentY        =   635
         End
         Begin PhotoDemon.sliderTextCombo sltSelectionBorder 
            CausesValidation=   0   'False
            Height          =   495
            Index           =   0
            Left            =   0
            TabIndex        =   21
            Top             =   840
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Min             =   1
            Max             =   10000
            Value           =   1
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   0
            Left            =   2820
            TabIndex        =   23
            Top             =   375
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   1
            Left            =   2820
            TabIndex        =   24
            Top             =   885
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   2
            Left            =   4380
            TabIndex        =   25
            Top             =   375
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   3
            Left            =   4380
            TabIndex        =   26
            Top             =   885
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.sliderTextCombo sltCornerRounding 
            CausesValidation=   0   'False
            Height          =   495
            Left            =   5760
            TabIndex        =   49
            Top             =   345
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Max             =   1
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   5
            Left            =   5880
            Top             =   60
            Width           =   2445
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "corner rounding"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   1
            Left            =   2820
            Top             =   60
            Width           =   1395
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "position (x, y)"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   2
            Left            =   4380
            Top             =   60
            Width           =   1395
            _ExtentX        =   2461
            _ExtentY        =   503
            Caption         =   "size (w, h)"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   4
            Left            =   120
            Top             =   60
            Width           =   2415
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "area"
         End
      End
      Begin VB.PictureBox picSelectionSubcontainer 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1470
         Index           =   5
         Left            =   5340
         ScaleHeight     =   98
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   665
         TabIndex        =   8
         Top             =   0
         Width           =   9975
         Begin PhotoDemon.pdComboBox cboWandCompare 
            Height          =   375
            Left            =   3270
            TabIndex        =   10
            Top             =   855
            Width           =   2445
            _ExtentX        =   4313
            _ExtentY        =   635
         End
         Begin PhotoDemon.buttonStrip btsWandArea 
            Height          =   825
            Left            =   120
            TabIndex        =   13
            Top             =   405
            Width           =   2895
            _ExtentX        =   4366
            _ExtentY        =   1455
         End
         Begin PhotoDemon.sliderTextCombo sltWandTolerance 
            CausesValidation=   0   'False
            Height          =   495
            Left            =   3120
            TabIndex        =   14
            Top             =   360
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Max             =   255
            SigDigits       =   1
         End
         Begin PhotoDemon.buttonStrip btsWandMerge 
            Height          =   825
            Left            =   6120
            TabIndex        =   18
            Top             =   405
            Width           =   2895
            _ExtentX        =   5106
            _ExtentY        =   1455
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   16
            Left            =   6120
            Top             =   60
            Width           =   2895
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "sampling area"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   6
            Left            =   3240
            Top             =   60
            Width           =   2595
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "tolerance"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   14
            Left            =   120
            Top             =   60
            Width           =   2895
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "area"
         End
      End
      Begin VB.PictureBox picSelectionSubcontainer 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1470
         Index           =   4
         Left            =   5340
         ScaleHeight     =   98
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   665
         TabIndex        =   19
         Top             =   0
         Width           =   9975
         Begin PhotoDemon.pdComboBox cboSelArea 
            Height          =   375
            Index           =   4
            Left            =   120
            TabIndex        =   22
            Top             =   390
            Width           =   2415
            _ExtentX        =   4260
            _ExtentY        =   635
         End
         Begin PhotoDemon.sliderTextCombo sltSelectionBorder 
            CausesValidation=   0   'False
            Height          =   495
            Index           =   4
            Left            =   0
            TabIndex        =   27
            Top             =   840
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Min             =   1
            Max             =   10000
            Value           =   1
         End
         Begin PhotoDemon.sliderTextCombo sltSmoothStroke 
            CausesValidation=   0   'False
            Height          =   495
            Left            =   2760
            TabIndex        =   28
            Top             =   360
            Visible         =   0   'False
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Max             =   1
            SigDigits       =   2
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   19
            Left            =   2910
            Top             =   60
            Visible         =   0   'False
            Width           =   2550
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "stroke smoothing"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   12
            Left            =   120
            Top             =   60
            Width           =   2415
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "area"
         End
      End
      Begin VB.PictureBox picSelectionSubcontainer 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1470
         Index           =   3
         Left            =   5340
         ScaleHeight     =   98
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   665
         TabIndex        =   47
         Top             =   0
         Width           =   9975
         Begin PhotoDemon.pdComboBox cboSelArea 
            Height          =   375
            Index           =   3
            Left            =   120
            TabIndex        =   35
            Top             =   390
            Width           =   2415
            _ExtentX        =   4260
            _ExtentY        =   635
         End
         Begin PhotoDemon.sliderTextCombo sltSelectionBorder 
            CausesValidation=   0   'False
            Height          =   495
            Index           =   3
            Left            =   0
            TabIndex        =   48
            Top             =   840
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Min             =   1
            Max             =   10000
            Value           =   1
         End
         Begin PhotoDemon.sliderTextCombo sltPolygonCurvature 
            CausesValidation=   0   'False
            Height          =   495
            Left            =   2760
            TabIndex        =   36
            Top             =   360
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Max             =   1
            SigDigits       =   2
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   17
            Left            =   2910
            Top             =   60
            Width           =   2490
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "curvature"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   15
            Left            =   120
            Top             =   60
            Width           =   2415
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "area"
         End
      End
      Begin VB.PictureBox picSelectionSubcontainer 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1470
         Index           =   2
         Left            =   5340
         ScaleHeight     =   98
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   665
         TabIndex        =   38
         Top             =   0
         Width           =   9975
         Begin PhotoDemon.pdComboBox cboSelArea 
            Height          =   375
            Index           =   2
            Left            =   120
            TabIndex        =   37
            Top             =   390
            Width           =   2415
            _ExtentX        =   4260
            _ExtentY        =   635
         End
         Begin PhotoDemon.sliderTextCombo sltSelectionBorder 
            CausesValidation=   0   'False
            Height          =   495
            Index           =   2
            Left            =   0
            TabIndex        =   39
            Top             =   840
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Min             =   1
            Max             =   10000
            Value           =   1
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   8
            Left            =   2820
            TabIndex        =   40
            Top             =   375
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   9
            Left            =   2820
            TabIndex        =   41
            Top             =   885
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   10
            Left            =   4380
            TabIndex        =   42
            Top             =   375
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   11
            Left            =   4380
            TabIndex        =   43
            Top             =   885
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.sliderTextCombo sltSelectionLineWidth 
            CausesValidation=   0   'False
            Height          =   495
            Left            =   5880
            TabIndex        =   44
            Top             =   360
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Min             =   1
            Max             =   10000
            Value           =   1
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   18
            Left            =   6000
            Top             =   60
            Width           =   2505
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "line width"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   11
            Left            =   120
            Top             =   60
            Width           =   2415
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "area"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   10
            Left            =   4380
            Top             =   60
            Width           =   1425
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "2nd point (x, y)"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   9
            Left            =   2820
            Top             =   60
            Width           =   1485
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "1st point (x, y)"
         End
      End
      Begin VB.PictureBox picSelectionSubcontainer 
         Appearance      =   0  'Flat
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1470
         Index           =   1
         Left            =   5340
         ScaleHeight     =   98
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   665
         TabIndex        =   29
         Top             =   0
         Width           =   9975
         Begin PhotoDemon.pdComboBox cboSelArea 
            Height          =   375
            Index           =   1
            Left            =   120
            TabIndex        =   45
            Top             =   390
            Width           =   2415
            _ExtentX        =   4260
            _ExtentY        =   635
         End
         Begin PhotoDemon.sliderTextCombo sltSelectionBorder 
            CausesValidation=   0   'False
            Height          =   495
            Index           =   1
            Left            =   0
            TabIndex        =   30
            Top             =   840
            Width           =   2670
            _ExtentX        =   4710
            _ExtentY        =   873
            Min             =   1
            Max             =   10000
            Value           =   1
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   4
            Left            =   2820
            TabIndex        =   31
            Top             =   375
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   5
            Left            =   2820
            TabIndex        =   32
            Top             =   885
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   6
            Left            =   4380
            TabIndex        =   33
            Top             =   375
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.textUpDown tudSel 
            Height          =   345
            Index           =   7
            Left            =   4380
            TabIndex        =   34
            Top             =   885
            Width           =   1320
            _ExtentX        =   2328
            _ExtentY        =   714
            Min             =   -30000
            Max             =   30000
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   7
            Left            =   120
            Top             =   60
            Width           =   2415
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "area"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   3
            Left            =   4380
            Top             =   60
            Width           =   3435
            _ExtentX        =   6059
            _ExtentY        =   503
            Caption         =   "size (w, h)"
         End
         Begin PhotoDemon.pdLabel lblSelection 
            Height          =   240
            Index           =   0
            Left            =   2820
            Top             =   60
            Width           =   1395
            _ExtentX        =   0
            _ExtentY        =   503
            Caption         =   "position (x, y)"
         End
      End
   End
   Begin VB.PictureBox picTools 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      ForeColor       =   &H80000008&
      Height          =   1575
      Index           =   0
      Left            =   0
      ScaleHeight     =   105
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   1230
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   15
      Visible         =   0   'False
      Width           =   18450
   End
   Begin VB.PictureBox picTools 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1575
      Index           =   2
      Left            =   0
      ScaleHeight     =   105
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   1230
      TabIndex        =   2
      Top             =   15
      Visible         =   0   'False
      Width           =   18450
      Begin PhotoDemon.pdButtonToolbox cmdQuickFix 
         Height          =   570
         Index           =   0
         Left            =   13290
         TabIndex        =   61
         Top             =   120
         Width           =   660
         _ExtentX        =   1164
         _ExtentY        =   1005
      End
      Begin PhotoDemon.sliderTextCombo sltQuickFix 
         CausesValidation=   0   'False
         Height          =   495
         Index           =   0
         Left            =   1530
         TabIndex        =   4
         Top             =   165
         Width           =   2670
         _ExtentX        =   4710
         _ExtentY        =   873
         Min             =   -2
         Max             =   2
         SigDigits       =   2
         SliderTrackStyle=   2
      End
      Begin PhotoDemon.sliderTextCombo sltQuickFix 
         CausesValidation=   0   'False
         Height          =   495
         Index           =   1
         Left            =   1530
         TabIndex        =   5
         Top             =   780
         Width           =   2670
         _ExtentX        =   4710
         _ExtentY        =   873
         Min             =   -100
         Max             =   100
      End
      Begin PhotoDemon.sliderTextCombo sltQuickFix 
         CausesValidation=   0   'False
         Height          =   495
         Index           =   2
         Left            =   5520
         TabIndex        =   7
         Top             =   165
         Width           =   2670
         _ExtentX        =   4710
         _ExtentY        =   873
         Min             =   -100
         Max             =   100
      End
      Begin PhotoDemon.sliderTextCombo sltQuickFix 
         CausesValidation=   0   'False
         Height          =   495
         Index           =   3
         Left            =   5520
         TabIndex        =   9
         Top             =   780
         Width           =   2670
         _ExtentX        =   4710
         _ExtentY        =   873
         Min             =   -100
         Max             =   100
      End
      Begin PhotoDemon.sliderTextCombo sltQuickFix 
         CausesValidation=   0   'False
         Height          =   495
         Index           =   4
         Left            =   9660
         TabIndex        =   11
         Top             =   165
         Width           =   2670
         _ExtentX        =   4710
         _ExtentY        =   873
         Min             =   -100
         Max             =   100
         SliderTrackStyle=   3
         GradientColorLeft=   16752699
         GradientColorRight=   2990335
         GradientColorMiddle=   16777215
      End
      Begin PhotoDemon.sliderTextCombo sltQuickFix 
         CausesValidation=   0   'False
         Height          =   495
         Index           =   5
         Left            =   9660
         TabIndex        =   12
         Top             =   780
         Width           =   2670
         _ExtentX        =   4710
         _ExtentY        =   873
         Min             =   -100
         Max             =   100
         SliderTrackStyle=   3
         GradientColorLeft=   15102446
         GradientColorRight=   8253041
         GradientColorMiddle=   16777215
      End
      Begin PhotoDemon.pdLabel lblOptions 
         Height          =   240
         Index           =   7
         Left            =   8190
         Top             =   270
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   503
         Alignment       =   1
         Caption         =   "temperature:"
      End
      Begin PhotoDemon.pdLabel lblOptions 
         Height          =   240
         Index           =   6
         Left            =   8190
         Top             =   885
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   503
         Alignment       =   1
         Caption         =   "tint:"
      End
      Begin PhotoDemon.pdLabel lblOptions 
         Height          =   240
         Index           =   5
         Left            =   4050
         Top             =   885
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   503
         Alignment       =   1
         Caption         =   "vibrance:"
      End
      Begin PhotoDemon.pdLabel lblOptions 
         Height          =   240
         Index           =   4
         Left            =   4050
         Top             =   270
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   503
         Alignment       =   1
         Caption         =   "clarity:"
      End
      Begin PhotoDemon.pdLabel lblOptions 
         Height          =   240
         Index           =   3
         Left            =   120
         Top             =   885
         Width           =   1155
         _ExtentX        =   2037
         _ExtentY        =   503
         Alignment       =   1
         Caption         =   "contrast:"
      End
      Begin PhotoDemon.pdLabel lblOptions 
         Height          =   240
         Index           =   2
         Left            =   120
         Top             =   270
         Width           =   1155
         _ExtentX        =   2037
         _ExtentY        =   503
         Alignment       =   1
         Caption         =   "exposure:"
      End
      Begin PhotoDemon.pdButtonToolbox cmdQuickFix 
         Height          =   570
         Index           =   1
         Left            =   13290
         TabIndex        =   62
         Top             =   720
         Width           =   660
         _ExtentX        =   1164
         _ExtentY        =   1005
      End
      Begin PhotoDemon.pdLabel lblOptions 
         Height          =   240
         Index           =   13
         Left            =   12360
         Top             =   270
         Width           =   795
         _ExtentX        =   1402
         _ExtentY        =   503
         Alignment       =   1
         Caption         =   "all:"
      End
   End
   Begin VB.Line lnSeparatorTop 
      BorderColor     =   &H80000002&
      X1              =   0
      X2              =   5000
      Y1              =   0
      Y2              =   0
   End
End
Attribute VB_Name = "toolbar_Options"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'PhotoDemon Tools Toolbox
'Copyright 2013-2015 by Tanner Helland
'Created: 03/October/13
'Last updated: 16/October/14
'Last update: rework all selection interface code to use the new property dictionary functions
'
'This form was initially integrated into the main MDI form.  In fall 2013, PhotoDemon left behind the MDI model,
' and all toolbars were moved to their own forms.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

'The value of all controls on this form are saved and loaded to file by this class
Private WithEvents lastUsedSettings As pdLastUsedSettings
Attribute lastUsedSettings.VB_VarHelpID = -1

'Whether or not non-destructive FX can be applied to the image
Private m_NonDestructiveFXAllowed As Boolean

'If external functions want to disable automatic non-destructive FX syncing, then can do so via this function
Public Sub setNDFXControlState(ByVal newNDFXState As Boolean)
    m_NonDestructiveFXAllowed = newNDFXState
End Sub

'Two sub-panels are available on the "move options" panel
Private Sub btsMoveOptions_Click(ByVal buttonIndex As Long)
    picMoveContainer(buttonIndex).Visible = True
    picMoveContainer(1 - buttonIndex).Visible = False
End Sub

Private Sub btsWandArea_Click(ByVal buttonIndex As Long)
    
    'If a selection is already active, change its type to match the current option, then redraw it
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_WAND_SEARCH_MODE, buttonIndex
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
    
End Sub

Private Sub btsWandMerge_Click(ByVal buttonIndex As Long)

    'If a selection is already active, change its type to match the current option, then redraw it
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_WAND_SAMPLE_MERGED, buttonIndex
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If

End Sub

Private Sub cboLayerResizeQuality_Click()
    
    'If tool changes are not allowed, exit.
    ' NOTE: this will also check tool busy status, via Tool_Support.getToolBusyState
    If Not Tool_Support.canvasToolsAllowed Then Exit Sub
    
    'Mark the tool engine as busy
    Tool_Support.setToolBusyState True
    
    'Apply the new quality mode
    pdImages(g_CurrentImage).getActiveLayer.setLayerResizeQuality cboLayerResizeQuality.ListIndex
    
    'Free the tool engine
    Tool_Support.setToolBusyState False
    
    'Redraw the viewport
    Viewport_Engine.Stage2_CompositeAllLayers pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    
End Sub

Private Sub cboSelArea_Click(Index As Integer)

    If cboSelArea(Index).ListIndex = sBorder Then
        sltSelectionBorder(Index).Visible = True
    Else
        sltSelectionBorder(Index).Visible = False
    End If
    
    'If a selection is already active, change its type to match the current selection, then redraw it
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_AREA, cboSelArea(Index).ListIndex
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_BORDER_WIDTH, sltSelectionBorder(Index).Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
    
End Sub

Private Sub cboSelRender_Click()

    'Show or hide the color selector, as appropriate
    If cboSelRender.ListIndex = SELECTION_RENDER_HIGHLIGHT Then
        csSelectionHighlight.Visible = True
    Else
        csSelectionHighlight.Visible = False
    End If
    
    'Redraw the viewport
    If selectionsAllowed(False) Then Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)

End Sub

Private Sub cboSelSmoothing_Click()

    updateSelectionPanelLayout
    
    'If a selection is already active, change its type to match the current selection, then redraw it
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_SMOOTHING, cboSelSmoothing.ListIndex
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_FEATHERING_RADIUS, sltSelectionFeathering.Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If

End Sub

Private Sub cboWandCompare_Click()
    
    'Limit the accuracy of the tolerance for certain comparison methods.
    If cboWandCompare.ListIndex > 1 Then
        sltWandTolerance.SigDigits = 0
    Else
        sltWandTolerance.SigDigits = 1
    End If
    
    'If a selection is already active, change its type to match the current option, then redraw it
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_WAND_COMPARE_METHOD, cboWandCompare.ListIndex
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
    
End Sub

Private Sub chkAutoActivateLayer_Click()
    If CBool(chkAutoActivateLayer) Then
        If Not chkIgnoreTransparent.Enabled Then chkIgnoreTransparent.Enabled = True
    Else
        If chkIgnoreTransparent.Enabled Then chkIgnoreTransparent.Enabled = False
    End If
End Sub

'Show/hide layer borders while using the move tool
Private Sub chkLayerBorder_Click()
    Viewport_Engine.Stage1_InitializeBuffer pdImages(g_CurrentImage), FormMain.mainCanvas(0), "Layer border toggle"
End Sub

'Show/hide layer transform nodes while using the move tool
Private Sub chkLayerNodes_Click()
    Viewport_Engine.Stage1_InitializeBuffer pdImages(g_CurrentImage), FormMain.mainCanvas(0), "Layer nodes toggle"
End Sub

Private Sub cmdLayerMove_Click(Index As Integer)
    
    Select Case Index
    
        'Reset layer to original size
        Case 0
            Process "Reset layer size", , buildParams(pdImages(g_CurrentImage).getActiveLayerIndex), UNDO_LAYERHEADER
        
        'Make non-destructive resize permanent
        Case 1
            Process "Make layer size permanent", , buildParams(pdImages(g_CurrentImage).getActiveLayerIndex), UNDO_LAYER
    
    End Select
    
End Sub

Private Sub cmdQuickFix_Click(Index As Integer)

    'Do nothing unless an image has been loaded
    If pdImages(g_CurrentImage) Is Nothing Then Exit Sub
    If Not pdImages(g_CurrentImage).loadedSuccessfully Then Exit Sub

    Dim i As Long

    'Regardless of the action we're applying, we start by disabling all auto-refreshes
    setNDFXControlState False
    
    Select Case Index
    
        'Reset quick-fix settings
        Case 0
            
            'Resetting does not affect the Undo/Redo chain, so simply reset all sliders, then redraw the screen
            For i = 0 To sltQuickFix.Count - 1
                
                sltQuickFix(i).Value = 0
                pdImages(g_CurrentImage).getActiveLayer.setLayerNonDestructiveFXState i, 0
                
            Next i
            
        'Make quick-fix settings permanent
        Case 1
            
            'First, make sure at least one or more quick-fixes are active
            If pdImages(g_CurrentImage).getActiveLayer.getLayerNonDestructiveFXState Then
                
                'Back-up the current quick-fix settings (because they will be reset after being applied to the image)
                evaluateImageCheckpoint
                
                'Now we do something odd; we reset all sliders, then forcibly set an image checkpoint.  This prevents PD's internal
                ' processor from auto-detecting the slider resets and applying *another* entry to the Undo/Redo chain.
                For i = 0 To sltQuickFix.Count - 1
                    sltQuickFix(i).Value = 0
                Next i
                
                setImageCheckpoint
                
                'Ask the central processor to permanently apply the quick-fix changes
                Process "Make quick-fixes permanent", , , UNDO_LAYER
                                
            End If
    
    End Select
    
    'After one of these buttons has been used, all quick-fix values will be reset - so we can disable the buttons accordingly.
    For i = 0 To cmdQuickFix.Count - 1
        If cmdQuickFix(i).Enabled Then cmdQuickFix(i).Enabled = False
    Next i
    
    'Re-enable auto-refreshes
    setNDFXControlState True
    
    'Redraw the viewport
    Viewport_Engine.Stage2_CompositeAllLayers pdImages(g_CurrentImage), FormMain.mainCanvas(0)

End Sub

Private Sub csSelectionHighlight_ColorChanged()
    
    'Redraw the viewport
    If selectionsAllowed(False) Then Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    
End Sub

Private Sub Form_Load()

    Dim i As Long
        
    'Tool initialization happens in a few different steps.
        
    'First, we must manually populate the many dropdowns contained in the dialog.  Note that as of v6.6, PD's custom drop down
    ' control manages its own translations.  As such, we don't need to manually handle translations; the dropdown does that for us.
        
        'Move tool panels
        btsMoveOptions.AddItem "tool", 0
        btsMoveOptions.AddItem "options", 1
        btsMoveOptions.ListIndex = 0
        btsMoveOptions_Click 0
        
        cmdLayerMove(0).AssignImage "CMDBAR_RESET", , 50
        cmdLayerMove(1).AssignImage "TO_APPLY", , 50
        
        cmdLayerMove(0).assignTooltip "Reset layer to original size"
        cmdLayerMove(1).assignTooltip "Make current layer size permanent.  This action is never required, but if viewport rendering is sluggish, it may improve performance."
        
        cboLayerResizeQuality.Clear
        cboLayerResizeQuality.AddItem "Nearest neighbor", 0
        cboLayerResizeQuality.AddItem "Bilinear", 1
        cboLayerResizeQuality.AddItem "Bicubic", 2
        cboLayerResizeQuality.ListIndex = 2
        
        'Quick-fix tools
        cmdQuickFix(0).AssignImage "CMDBAR_RESET", , 50
        cmdQuickFix(1).AssignImage "TO_APPLY", , 50
        
        cmdQuickFix(0).assignTooltip "Reset all quick-fix adjustment values"
        cmdQuickFix(1).assignTooltip "Make quick-fix adjustments permanent.  This action is never required, but if viewport rendering is sluggish and many quick-fix adjustments are active, it may improve performance."
        
        'Selection visual styles (Highlight, Lightbox, or Outline)
        toolbar_Options.cboSelRender.Clear
        toolbar_Options.cboSelRender.AddItem " Highlight", 0
        toolbar_Options.cboSelRender.AddItem " Lightbox", 1
        toolbar_Options.cboSelRender.AddItem " Outline", 2
        toolbar_Options.cboSelRender.ListIndex = 0
        
        csSelectionHighlight.Color = RGB(255, 58, 72)
        csSelectionHighlight.Visible = True
        
        'Selection smoothing (currently none, antialiased, fully feathered)
        toolbar_Options.cboSelSmoothing.Clear
        toolbar_Options.cboSelSmoothing.AddItem " None", 0
        toolbar_Options.cboSelSmoothing.AddItem " Antialiased", 1
        toolbar_Options.cboSelSmoothing.AddItem " Feathered", 2
        toolbar_Options.cboSelSmoothing.ListIndex = 1
        
        'Selection types (currently interior, exterior, border)
        For i = 0 To cboSelArea.Count - 1
            toolbar_Options.cboSelArea(i).AddItem " Interior", 0
            toolbar_Options.cboSelArea(i).AddItem " Exterior", 1
            toolbar_Options.cboSelArea(i).AddItem " Border", 2
            toolbar_Options.cboSelArea(i).ListIndex = 0
        Next i
        
        'Magic wand options
        btsWandMerge.AddItem "image", 0
        btsWandMerge.AddItem "layer", 1
        btsWandMerge.ListIndex = 0
        
        btsWandArea.AddItem "contiguous", 0
        btsWandArea.AddItem "global", 1
        btsWandArea.ListIndex = 0
        
        cboWandCompare.Clear
        cboWandCompare.AddItem " Composite", 0
        cboWandCompare.AddItem " Color", 1
        cboWandCompare.AddItem " Luminance", 2, True
        cboWandCompare.AddItem " Red", 3
        cboWandCompare.AddItem " Green", 4
        cboWandCompare.AddItem " Blue", 5
        cboWandCompare.AddItem " Alpha", 6
        cboWandCompare.ListIndex = 1
        
    'Load any last-used settings for this form
    Set lastUsedSettings = New pdLastUsedSettings
    lastUsedSettings.setParentForm Me
    lastUsedSettings.loadAllControlValues
        
    'Update everything against the current theme.  This will also set tooltips for various controls.
    updateAgainstCurrentTheme
    
    'Allow non-destructive effects
    m_NonDestructiveFXAllowed = True

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)

    'Save all last-used settings to file
    lastUsedSettings.saveAllControlValues

End Sub

Private Sub lastUsedSettings_ReadCustomPresetData()
    
    'Reset the selection coordinate boxes to 0
    Dim i As Long
    For i = 0 To tudSel.Count - 1
        tudSel(i) = 0
    Next i

End Sub

'Toolbars can never be unloaded, EXCEPT when the whole program is going down.  Check for the program-wide closing flag prior
' to exiting; if it is not found, cancel the unload and simply hide this form.  (Note that the toggleToolbarVisibility sub
' will also keep this toolbar's Window menu entry in sync with the form's current visibility.)
Private Sub Form_Unload(Cancel As Integer)
    
    If g_ProgramShuttingDown Then
        ReleaseFormTheming Me
        g_WindowManager.unregisterForm Me
    Else
        Cancel = True
        toggleToolbarVisibility TOOLS_TOOLBOX
    End If
    
End Sub

Private Sub sltCornerRounding_Change()
    If selectionsAllowed(True) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_ROUNDED_CORNER_RADIUS, sltCornerRounding.Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
End Sub

Private Sub sltPolygonCurvature_Change()
    If selectionsAllowed(True) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_POLYGON_CURVATURE, sltPolygonCurvature.Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
End Sub

'Non-destructive effect changes will force an immediate redraw of the viewport
Private Sub sltQuickFix_Change(Index As Integer)

    If (Not pdImages(g_CurrentImage) Is Nothing) And m_NonDestructiveFXAllowed Then
        
        'Check the state of the layer's non-destructive FX tracker before making any changes
        Dim initFXState As Boolean
        initFXState = pdImages(g_CurrentImage).getActiveLayer.getLayerNonDestructiveFXState
        
        'The index of sltQuickFix controls aligns exactly with PD's constants for non-destructive effects.  This is by design.
        pdImages(g_CurrentImage).getActiveLayer.setLayerNonDestructiveFXState Index, sltQuickFix(Index).Value
        
        'Redraw the viewport
        Viewport_Engine.Stage2_CompositeAllLayers pdImages(g_CurrentImage), FormMain.mainCanvas(0)
        
        'If the layer now has non-destructive effects active, enable the quick fix buttons (if they aren't already)
        Dim i As Long
        
        If pdImages(g_CurrentImage).getActiveLayer.getLayerNonDestructiveFXState Then
        
            For i = 0 To cmdQuickFix.Count - 1
                If Not cmdQuickFix(i).Enabled Then cmdQuickFix(i).Enabled = True
            Next i
        
        Else
            
            For i = 0 To cmdQuickFix.Count - 1
                If cmdQuickFix(i).Enabled Then cmdQuickFix(i).Enabled = False
            Next i
        
        End If
        
        'Even though this action is not destructive, we want to allow the user to save after making non-destructive changes.
        If pdImages(g_CurrentImage).getSaveState(pdSE_AnySave) And (pdImages(g_CurrentImage).getActiveLayer.getLayerNonDestructiveFXState <> initFXState) Then
            pdImages(g_CurrentImage).setSaveState False, pdSE_AnySave
            syncInterfaceToCurrentImage
        End If
        
    End If

End Sub

Private Sub sltSelectionBorder_Change(Index As Integer)
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_BORDER_WIDTH, sltSelectionBorder(Index).Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
End Sub

Private Sub sltSelectionFeathering_Change()
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_FEATHERING_RADIUS, sltSelectionFeathering.Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
End Sub

Private Sub sltSelectionLineWidth_Change()
    If selectionsAllowed(True) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_LINE_WIDTH, sltSelectionLineWidth.Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
End Sub

'When certain selection settings are enabled or disabled, corresponding controls are shown or hidden.  To keep the
' panel concise and clean, we move other controls up or down depending on what controls are visible.
Public Sub updateSelectionPanelLayout()

    'Display the feathering slider as necessary
    If cboSelSmoothing.ListIndex = sFullyFeathered Then
        sltSelectionFeathering.Visible = True
    Else
        sltSelectionFeathering.Visible = False
    End If
    
    'Display the border slider as necessary
    If (Selection_Handler.getSelectionSubPanelFromCurrentTool < cboSelArea.Count - 1) And (Selection_Handler.getSelectionSubPanelFromCurrentTool > 0) Then
        If cboSelArea(Selection_Handler.getSelectionSubPanelFromCurrentTool).ListIndex = sBorder Then
            sltSelectionBorder(Selection_Handler.getSelectionSubPanelFromCurrentTool).Visible = True
        Else
            sltSelectionBorder(Selection_Handler.getSelectionSubPanelFromCurrentTool).Visible = False
        End If
    End If
    
    'Finally, the magic wand selection type is unique because it cannot display an outline.  (This might someday be possible,
    ' but we would need to construct the border region ourselves - and I'm not a huge fan of the work involved.)
    ' As such, when activating that tool, we need to remove the Outline option, and when switching to a different tool, we need
    ' to restore the option.
    If g_CurrentTool = SELECT_WAND Then
    
        'See if the combo box is already modified
        If cboSelRender.ListCount = 3 Then
            
            'Remove the "outline" option
            If toolbar_Options.cboSelRender.ListIndex = 2 Then toolbar_Options.cboSelRender.ListIndex = 0
            toolbar_Options.cboSelRender.RemoveItem 2
            
        End If
    
    Else
    
        'See if the combo box is missing an entry
        If cboSelRender.ListCount = 2 Then
            toolbar_Options.cboSelRender.AddItem " Outline", 2
        End If
    
    End If
    
End Sub

Private Sub sltSmoothStroke_Change()
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_SMOOTH_STROKE, sltSmoothStroke.Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
End Sub

Private Sub sltWandTolerance_Change()
    If selectionsAllowed(False) Then
        pdImages(g_CurrentImage).mainSelection.setSelectionProperty SP_WAND_TOLERANCE, sltWandTolerance.Value
        Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
    End If
End Sub

Private Sub tudLayerMove_Change(Index As Integer)
    
    'If tool changes are not allowed, exit.
    ' NOTE: this will also check tool busy status, via Tool_Support.getToolBusyState
    If Not Tool_Support.canvasToolsAllowed Then Exit Sub
    
    'Mark the tool engine as busy
    Tool_Support.setToolBusyState True
    
    Select Case Index
    
        'Layer position (x)
        Case 0
            pdImages(g_CurrentImage).getActiveLayer.setLayerOffsetX tudLayerMove(Index).Value
        
        'Layer position (y)
        Case 1
            pdImages(g_CurrentImage).getActiveLayer.setLayerOffsetY tudLayerMove(Index).Value
        
        'Layer width
        Case 2
            pdImages(g_CurrentImage).getActiveLayer.setLayerCanvasXModifier tudLayerMove(Index).Value / pdImages(g_CurrentImage).getActiveLayer.getLayerWidth(False)
            
        'Layer height
        Case 3
            pdImages(g_CurrentImage).getActiveLayer.setLayerCanvasYModifier tudLayerMove(Index).Value / pdImages(g_CurrentImage).getActiveLayer.getLayerHeight(False)
        
    End Select
    
    'Free the tool engine
    Tool_Support.setToolBusyState False
    
    'Redraw the viewport
    Viewport_Engine.Stage2_CompositeAllLayers pdImages(g_CurrentImage), FormMain.mainCanvas(0)

End Sub

'Non-destructive resizing requires the synchronization of several menus, as well.  Because it's time-consuming to invoke
' syncInterfaceToCurrentImage, we only call it when the user releases the mouse.
Private Sub tudLayerMove_FinalChange(Index As Integer)
    
    'If tool changes are not allowed, exit.
    ' NOTE: this will also check tool busy status, via Tool_Support.getToolBusyState
    If Not Tool_Support.canvasToolsAllowed Then Exit Sub
    
    Select Case Index
        
        Case 2, 3
            syncInterfaceToCurrentImage
        
        Case Else
        
    End Select
    
End Sub

'When the selection text boxes are updated, change the scrollbars to match
Private Sub tudSel_Change(Index As Integer)
    updateSelectionsValuesViaText
End Sub

Private Sub updateSelectionsValuesViaText()
    If selectionsAllowed(True) Then
        If Not pdImages(g_CurrentImage).mainSelection.rejectRefreshRequests Then
            pdImages(g_CurrentImage).mainSelection.updateViaTextBox
            Viewport_Engine.Stage4_CompositeCanvas pdImages(g_CurrentImage), FormMain.mainCanvas(0)
        End If
    End If
End Sub

'Updating against the current theme accomplishes a number of things:
' 1) All user-drawn controls are redrawn according to the current g_Themer settings.
' 2) All tooltips and captions are translated according to the current language.
' 3) MakeFormPretty is called, which redraws the form itself according to any theme and/or system settings.
'
'This function is called at least once, at Form_Load, but can be called again if the active language or theme changes.
Public Sub updateAgainstCurrentTheme()
    
    'Start by redrawing the form according to current theme and translation settings.  (This function also takes care of
    ' any common controls that may still exist in the program.)
    makeFormPretty Me
    
    'Tooltips must be manually re-assigned according to the current language.  This is a necessary evil, if the user switches
    ' between two non-English languages at run-time.
    toolbar_Options.cboSelRender.assignTooltip "Click to change the way selections are rendered onto the image canvas.  This has no bearing on selection contents - only the way they appear while editing."
    toolbar_Options.cboSelSmoothing.assignTooltip "This option controls how smoothly a selection blends with its surroundings."
        
    Dim i As Long
    For i = 0 To cboSelArea.Count - 1
        toolbar_Options.cboSelArea(i).assignTooltip "These options control the area affected by a selection.  The selection can be modified on-canvas while any of these settings are active.  For more advanced selection adjustments, use the Select menu."
        toolbar_Options.sltSelectionBorder(i).assignTooltip "This option adjusts the width of the selection border."
    Next i
    
    toolbar_Options.sltSelectionFeathering.assignTooltip "This feathering slider allows for immediate feathering adjustments.  For performance reasons, it is limited to small radii.  For larger feathering radii, please use the Select -> Feathering menu."
    toolbar_Options.sltCornerRounding.assignTooltip "This option adjusts the roundness of a rectangular selection's corners."
    toolbar_Options.sltSelectionLineWidth.assignTooltip "This option adjusts the width of a line selection."
    
    toolbar_Options.sltPolygonCurvature.assignTooltip "This option adjusts the curvature, if any, of a polygon selection's sides."
    toolbar_Options.sltSmoothStroke.assignTooltip "This option increases the smoothness of a hand-drawn lasso selection."
    toolbar_Options.sltWandTolerance.assignTooltip "Tolerance controls how similar two pixels must be before adding them to a magic wand selection."
    
    toolbar_Options.btsWandMerge.assignTooltip "The magic wand can operate on the entire image, or just the active layer."
    toolbar_Options.btsWandArea.assignTooltip "Normally, the magic wand will spread out from the target pixel, adding neighboring pixels to the selection as it goes.  You can alternatively set it to search the entire image, without regards for continuity."
    
    cboWandCompare.assignTooltip "This option controls which criteria the magic wand uses to determine whether a pixel should be added to the current selection."
    
    'The top separator line is colored according to the current shadow accent color
    If Not g_Themer Is Nothing Then
        lnSeparatorTop.BorderColor = g_Themer.getThemeColor(PDTC_GRAY_SHADOW)
    Else
        lnSeparatorTop.BorderColor = vbHighlight
    End If
    
End Sub

