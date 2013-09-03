VERSION 5.00
Begin VB.Form FormPreferences 
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   " PhotoDemon Options"
   ClientHeight    =   7620
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   11265
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
   ScaleHeight     =   508
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   751
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdReset 
      Caption         =   "Reset all options"
      Height          =   495
      Left            =   2670
      TabIndex        =   92
      Top             =   6990
      Width           =   2580
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   495
      Left            =   8280
      TabIndex        =   0
      Top             =   6990
      Width           =   1365
   End
   Begin VB.CommandButton CmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   9750
      TabIndex        =   1
      Top             =   6990
      Width           =   1365
   End
   Begin PhotoDemon.jcbutton cmdCategory 
      Height          =   780
      Index           =   0
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   1376
      ButtonStyle     =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColor       =   -2147483643
      Caption         =   "Interface"
      ForeColor       =   4210752
      ForeColorHover  =   4194304
      Mode            =   1
      Value           =   -1  'True
      HandPointer     =   -1  'True
      PictureNormal   =   "VBP_FormPreferences.frx":0000
      PictureAlign    =   0
      PictureEffectOnDown=   0
      DisabledPictureMode=   1
      CaptionEffects  =   0
      TooltipTitle    =   "Interface Options"
      ColorScheme     =   3
   End
   Begin PhotoDemon.jcbutton cmdCategory 
      Height          =   780
      Index           =   6
      Left            =   120
      TabIndex        =   5
      Top             =   5160
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   1376
      ButtonStyle     =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColor       =   -2147483643
      Caption         =   "Updates"
      ForeColor       =   4210752
      ForeColorHover  =   4194304
      Mode            =   1
      HandPointer     =   -1  'True
      PictureNormal   =   "VBP_FormPreferences.frx":1052
      PictureAlign    =   0
      PictureEffectOnDown=   0
      DisabledPictureMode=   1
      CaptionEffects  =   0
      TooltipTitle    =   "Update Options"
      ColorScheme     =   3
   End
   Begin PhotoDemon.jcbutton cmdCategory 
      Height          =   780
      Index           =   4
      Left            =   120
      TabIndex        =   3
      Top             =   3480
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   1376
      ButtonStyle     =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColor       =   -2147483643
      Caption         =   "Tools"
      ForeColor       =   4210752
      ForeColorHover  =   4194304
      Mode            =   1
      HandPointer     =   -1  'True
      PictureNormal   =   "VBP_FormPreferences.frx":20A4
      PictureAlign    =   0
      PictureEffectOnDown=   0
      DisabledPictureMode=   1
      CaptionEffects  =   0
      TooltipTitle    =   "Tool Options"
      ColorScheme     =   3
   End
   Begin PhotoDemon.jcbutton cmdCategory 
      Height          =   780
      Index           =   7
      Left            =   120
      TabIndex        =   6
      Top             =   6000
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   1376
      ButtonStyle     =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColor       =   -2147483643
      Caption         =   "Advanced"
      ForeColor       =   4210752
      ForeColorHover  =   4194304
      Mode            =   1
      HandPointer     =   -1  'True
      PictureNormal   =   "VBP_FormPreferences.frx":30F6
      PictureAlign    =   0
      PictureEffectOnDown=   0
      DisabledPictureMode=   1
      CaptionEffects  =   0
      TooltipTitle    =   "Advanced Options"
      ColorScheme     =   3
   End
   Begin PhotoDemon.jcbutton cmdCategory 
      Height          =   780
      Index           =   5
      Left            =   120
      TabIndex        =   4
      Top             =   4320
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   1376
      ButtonStyle     =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColor       =   -2147483643
      Caption         =   "Transparency"
      ForeColor       =   4210752
      ForeColorHover  =   4194304
      Mode            =   1
      HandPointer     =   -1  'True
      PictureNormal   =   "VBP_FormPreferences.frx":4148
      PictureAlign    =   0
      PictureEffectOnDown=   0
      DisabledPictureMode=   1
      CaptionEffects  =   0
      TooltipTitle    =   "Transparency Options"
      ColorScheme     =   3
   End
   Begin PhotoDemon.jcbutton cmdCategory 
      Height          =   780
      Index           =   1
      Left            =   120
      TabIndex        =   32
      Top             =   960
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   1376
      ButtonStyle     =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColor       =   -2147483643
      Caption         =   "Loading"
      ForeColor       =   4210752
      ForeColorHover  =   4194304
      Mode            =   1
      HandPointer     =   -1  'True
      PictureNormal   =   "VBP_FormPreferences.frx":519A
      PictureAlign    =   0
      PictureEffectOnDown=   0
      DisabledPictureMode=   1
      CaptionEffects  =   0
      TooltipTitle    =   "Load (Import) Options"
      ColorScheme     =   3
   End
   Begin PhotoDemon.jcbutton cmdCategory 
      Height          =   780
      Index           =   2
      Left            =   120
      TabIndex        =   49
      Top             =   1800
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   1376
      ButtonStyle     =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColor       =   -2147483643
      Caption         =   "Saving"
      ForeColor       =   4210752
      ForeColorHover  =   4194304
      Mode            =   1
      HandPointer     =   -1  'True
      PictureNormal   =   "VBP_FormPreferences.frx":61EC
      PictureAlign    =   0
      PictureEffectOnDown=   0
      DisabledPictureMode=   1
      CaptionEffects  =   0
      TooltipTitle    =   "Save (Export) Options"
      ColorScheme     =   3
   End
   Begin PhotoDemon.jcbutton cmdCategory 
      Height          =   780
      Index           =   3
      Left            =   120
      TabIndex        =   51
      Top             =   2640
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   1376
      ButtonStyle     =   7
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackColor       =   -2147483643
      Caption         =   "File formats"
      ForeColor       =   4210752
      ForeColorHover  =   4194304
      Mode            =   1
      HandPointer     =   -1  'True
      PictureNormal   =   "VBP_FormPreferences.frx":723E
      PictureAlign    =   0
      PictureEffectOnDown=   0
      DisabledPictureMode=   1
      CaptionEffects  =   0
      TooltipTitle    =   "File Format Options"
      ColorScheme     =   3
   End
   Begin VB.PictureBox picContainer 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6480
      Index           =   2
      Left            =   2760
      MousePointer    =   1  'Arrow
      ScaleHeight     =   432
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   553
      TabIndex        =   50
      Top             =   240
      Width           =   8295
      Begin PhotoDemon.smartCheckBox chkConfirmUnsaved 
         Height          =   480
         Left            =   240
         TabIndex        =   113
         ToolTipText     =   "Check this if you want to be warned when you try to close an image with unsaved changes"
         Top             =   360
         Width           =   5445
         _ExtentX        =   9604
         _ExtentY        =   847
         Caption         =   "when closing images, warn me me about unsaved changes"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.ComboBox cmbSaveBehavior 
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
         Style           =   2  'Dropdown List
         TabIndex        =   109
         Top             =   5925
         Width           =   7980
      End
      Begin VB.ComboBox cmbExportColorDepth 
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
         Style           =   2  'Dropdown List
         TabIndex        =   64
         Top             =   1740
         Width           =   7980
      End
      Begin VB.ComboBox cmbMetadata 
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
         Style           =   2  'Dropdown List
         TabIndex        =   61
         Top             =   4530
         Width           =   7980
      End
      Begin VB.ComboBox cmbDefaultSaveFormat 
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
         Style           =   2  'Dropdown List
         TabIndex        =   54
         Top             =   3135
         Width           =   7980
      End
      Begin VB.Label lblSubheader 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "when saving images that originally contained metadata:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Index           =   3
         Left            =   240
         TabIndex        =   110
         Top             =   4140
         Width           =   4785
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "metadata (EXIF, GPS, comments, etc.)"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   1
         Left            =   0
         TabIndex        =   108
         Top             =   3690
         Width           =   4065
      End
      Begin VB.Label lblSubheader 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "set outgoing color depth:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Index           =   0
         Left            =   240
         TabIndex        =   66
         Top             =   1350
         Width           =   2145
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "color depth of saved images"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   17
         Left            =   0
         TabIndex        =   65
         Top             =   930
         Width           =   2985
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "save behavior: overwrite vs make a copy"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   16
         Left            =   0
         TabIndex        =   63
         Top             =   5085
         Width           =   4320
      End
      Begin VB.Label lblSubheader 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "when ""Save"" is used:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Index           =   2
         Left            =   240
         TabIndex        =   62
         Top             =   5535
         Width           =   1830
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "closing unsaved images"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   11
         Left            =   0
         TabIndex        =   57
         Top             =   0
         Width           =   2505
      End
      Begin VB.Label lblSubheader 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "when using the ""Save As"" command, set the default file format according to:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Index           =   1
         Left            =   240
         TabIndex        =   56
         Top             =   2730
         Width           =   6585
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "default file format when saving"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   10
         Left            =   0
         TabIndex        =   55
         Top             =   2310
         Width           =   3285
      End
   End
   Begin VB.PictureBox picContainer 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6465
      Index           =   1
      Left            =   2760
      MousePointer    =   1  'Arrow
      ScaleHeight     =   431
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   553
      TabIndex        =   33
      Top             =   240
      Width           =   8295
      Begin VB.ComboBox cmbMultiImage 
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
         Left            =   360
         Style           =   2  'Dropdown List
         TabIndex        =   45
         Top             =   5250
         Width           =   7920
      End
      Begin VB.ComboBox cmbLargeImages 
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
         Left            =   360
         Style           =   2  'Dropdown List
         TabIndex        =   34
         Top             =   2250
         Width           =   7920
      End
      Begin PhotoDemon.smartCheckBox chkInitialColorDepth 
         Height          =   480
         Left            =   360
         TabIndex        =   111
         Top             =   840
         Width           =   6765
         _ExtentX        =   11933
         _ExtentY        =   847
         Caption         =   "count unique colors in incoming images (to determine optimal color depth)"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin PhotoDemon.smartCheckBox chkToneMapping 
         Height          =   480
         Left            =   360
         TabIndex        =   112
         Top             =   3720
         Width           =   6885
         _ExtentX        =   12144
         _ExtentY        =   847
         Caption         =   "apply tone mapping to imported HDR and RAW images (48, 64, 96, 128bpp)"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "color depth"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   15
         Left            =   180
         TabIndex        =   60
         Top             =   480
         Width           =   1200
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "global load options"
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
         Index           =   14
         Left            =   0
         TabIndex        =   59
         Top             =   0
         Width           =   2025
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "load options for specific image types"
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
         Index           =   13
         Left            =   0
         TabIndex        =   58
         Top             =   2880
         Width           =   3870
      End
      Begin VB.Label lblFreeImageWarning 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   615
         Left            =   120
         TabIndex        =   47
         Top             =   5760
         Width           =   8175
      End
      Begin VB.Label lblMultiImages 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "if a file contains multiple images: "
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Left            =   360
         TabIndex        =   46
         Top             =   4860
         Width           =   2895
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "multi-image files (animated GIF, multipage TIFF)"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   8
         Left            =   180
         TabIndex        =   44
         Top             =   4380
         Width           =   5205
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "high-dynamic range (HDR) files"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   6
         Left            =   180
         TabIndex        =   43
         Top             =   3360
         Width           =   3345
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "initial viewport"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00505050&
         Height          =   285
         Index           =   5
         Left            =   180
         TabIndex        =   42
         Top             =   1440
         Width           =   1560
      End
      Begin VB.Label lblImgOpen 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "set initial image zoom to: "
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Left            =   360
         TabIndex        =   35
         Top             =   1875
         Width           =   2235
      End
   End
   Begin VB.PictureBox picContainer 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6480
      Index           =   4
      Left            =   2760
      MousePointer    =   1  'Arrow
      ScaleHeight     =   432
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   553
      TabIndex        =   12
      Top             =   240
      Width           =   8295
      Begin PhotoDemon.smartCheckBox chkSelectionClearCrop 
         Height          =   480
         Left            =   240
         TabIndex        =   105
         Top             =   480
         Width           =   6480
         _ExtentX        =   11430
         _ExtentY        =   847
         Caption         =   "automatically clear the active selection after ""Crop to Selection"" is used"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.Label lblTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "selections"
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
         Index           =   1
         Left            =   0
         TabIndex        =   13
         Top             =   0
         Width           =   1020
      End
   End
   Begin VB.PictureBox picContainer 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6480
      Index           =   7
      Left            =   2760
      MousePointer    =   1  'Arrow
      ScaleHeight     =   432
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   553
      TabIndex        =   17
      Top             =   240
      Width           =   8295
      Begin PhotoDemon.smartCheckBox chkGDIPlusTest 
         Height          =   480
         Left            =   240
         TabIndex        =   107
         Top             =   5160
         Width           =   2130
         _ExtentX        =   3757
         _ExtentY        =   847
         Caption         =   "enable GDI+ support"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin PhotoDemon.smartCheckBox chkLogMessages 
         Height          =   480
         Left            =   240
         TabIndex        =   106
         Top             =   360
         Width           =   3195
         _ExtentX        =   5636
         _ExtentY        =   847
         Caption         =   "log all program messages to file "
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.TextBox TxtTempPath 
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
         Height          =   375
         Left            =   240
         Locked          =   -1  'True
         TabIndex        =   20
         Text            =   "automatically generated at run-time"
         ToolTipText     =   "Folder used for temporary files"
         Top             =   1440
         Width           =   6975
      End
      Begin VB.CommandButton cmdTmpPath 
         Caption         =   "..."
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   7320
         TabIndex        =   19
         ToolTipText     =   "Click to open a browse-for-folder dialog"
         Top             =   1440
         Width           =   765
      End
      Begin VB.Label lblMemoryUsageMax 
         BackStyle       =   0  'Transparent
         Caption         =   "memory usage will be displayed here"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00804040&
         Height          =   480
         Left            =   240
         TabIndex        =   69
         Top             =   3870
         Width           =   7965
         WordWrap        =   -1  'True
      End
      Begin VB.Label lblMemoryUsageCurrent 
         BackStyle       =   0  'Transparent
         Caption         =   "memory usage will be displayed here"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00804040&
         Height          =   480
         Left            =   240
         TabIndex        =   68
         Top             =   3360
         Width           =   7965
         WordWrap        =   -1  'True
      End
      Begin VB.Label lblTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "memory diagnostics"
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
         Index           =   5
         Left            =   0
         TabIndex        =   67
         Top             =   2880
         Width           =   2130
      End
      Begin VB.Label lblRuntimeSettings 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "temporary file location"
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
         Index           =   1
         Left            =   0
         TabIndex        =   48
         Top             =   960
         Width           =   2385
      End
      Begin VB.Label lblTempPathWarning 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   495
         Left            =   240
         TabIndex        =   31
         Top             =   2040
         Width           =   7695
         WordWrap        =   -1  'True
      End
      Begin VB.Label lblRuntimeSettings 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "run-time testing options (NOTE: these are not saved to the INI file)"
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
         Index           =   0
         Left            =   0
         TabIndex        =   30
         Top             =   4680
         Width           =   7155
      End
      Begin VB.Label lblTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "debugging"
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
         Index           =   4
         Left            =   0
         TabIndex        =   18
         Top             =   0
         Width           =   1125
      End
   End
   Begin VB.PictureBox picContainer 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6480
      Index           =   6
      Left            =   2760
      MousePointer    =   1  'Arrow
      ScaleHeight     =   432
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   553
      TabIndex        =   14
      Top             =   240
      Width           =   8295
      Begin PhotoDemon.smartCheckBox chkPromptPluginDownload 
         Height          =   480
         Left            =   240
         TabIndex        =   94
         Top             =   1080
         Width           =   5280
         _ExtentX        =   9313
         _ExtentY        =   847
         Caption         =   "if core plugins cannot be located, offer to download them"
         Value           =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin PhotoDemon.smartCheckBox chkProgramUpdates 
         Height          =   480
         Left            =   240
         TabIndex        =   93
         ToolTipText     =   "If this is disabled, you can visit tannerhelland.com/photodemon to manually download the latest version of PhotoDemon"
         Top             =   480
         Width           =   5130
         _ExtentX        =   9049
         _ExtentY        =   847
         Caption         =   "automatically check for software updates every 10 days"
         Value           =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.Label lblTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "update options"
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
         Index           =   3
         Left            =   0
         TabIndex        =   15
         Top             =   0
         Width           =   1575
      End
      Begin VB.Label lblExplanation 
         BackStyle       =   0  'Transparent
         Caption         =   "(disclaimer populated at run-time)"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   4095
         Left            =   240
         TabIndex        =   16
         Top             =   1800
         Width           =   7935
      End
   End
   Begin VB.PictureBox picContainer 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6480
      Index           =   0
      Left            =   2760
      MousePointer    =   1  'Arrow
      ScaleHeight     =   432
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   553
      TabIndex        =   7
      Top             =   240
      Width           =   8295
      Begin PhotoDemon.smartCheckBox chkFancyFonts 
         Height          =   480
         Left            =   240
         TabIndex        =   98
         ToolTipText     =   "This setting uses ""Segoe UI"" as the PhotoDemon interface font. Leaving it unchecked defaults to ""Tahoma""."
         Top             =   5400
         Width           =   7425
         _ExtentX        =   13097
         _ExtentY        =   847
         Caption         =   "render PhotoDemon text with modern typefaces (only available on Vista or newer)"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin PhotoDemon.smartCheckBox chkWindowLocation 
         Height          =   480
         Left            =   240
         TabIndex        =   97
         ToolTipText     =   "If selected, this setting will ensure that PhotoDemon starts up in the on-screen location where you last left it."
         Top             =   4920
         Width           =   5820
         _ExtentX        =   10266
         _ExtentY        =   847
         Caption         =   "remember main window's on-screen location between sessions"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin PhotoDemon.smartCheckBox chkTaskBarIcon 
         Height          =   480
         Left            =   240
         TabIndex        =   96
         Top             =   4440
         Width           =   5175
         _ExtentX        =   9128
         _ExtentY        =   847
         Caption         =   "dynamically update taskbar icon to match current image"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin PhotoDemon.smartCheckBox chkDropShadow 
         Height          =   480
         Left            =   240
         TabIndex        =   95
         ToolTipText     =   "This setting helps images stand out from the canvas behind them"
         Top             =   1230
         Width           =   4380
         _ExtentX        =   7726
         _ExtentY        =   847
         Caption         =   "draw drop shadow between image and canvas"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.ComboBox cmbMRUCaption 
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
         Style           =   2  'Dropdown List
         TabIndex        =   39
         Top             =   3480
         Width           =   8055
      End
      Begin VB.ComboBox cmbImageCaption 
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
         Style           =   2  'Dropdown List
         TabIndex        =   36
         ToolTipText     =   "Image windows tend to be large, so feel free to display each image's full location in the image window title bars."
         Top             =   2640
         Width           =   8055
      End
      Begin VB.ComboBox cmbCanvas 
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
         Style           =   2  'Dropdown List
         TabIndex        =   10
         Top             =   810
         Width           =   6615
      End
      Begin VB.PictureBox picCanvasColor 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   405
         Left            =   6960
         MouseIcon       =   "VBP_FormPreferences.frx":8290
         MousePointer    =   99  'Custom
         ScaleHeight     =   25
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   85
         TabIndex        =   9
         TabStop         =   0   'False
         Top             =   780
         Width           =   1305
      End
      Begin VB.Label lblMRUText 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "recently used file shortcuts should be: "
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Left            =   240
         TabIndex        =   40
         Top             =   3120
         Width           =   3315
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "captions"
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
         Index           =   4
         Left            =   0
         TabIndex        =   38
         Top             =   1800
         Width           =   870
      End
      Begin VB.Label lblImageText 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "image window titles should be: "
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Left            =   240
         TabIndex        =   37
         Top             =   2250
         Width           =   2730
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "miscellaneous"
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
         Index           =   2
         Left            =   0
         TabIndex        =   29
         Top             =   4080
         Width           =   1470
      End
      Begin VB.Label lblCanvasFX 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "image canvas background:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Left            =   240
         TabIndex        =   11
         Top             =   450
         Width           =   2295
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "canvas appearance"
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
         Index           =   0
         Left            =   0
         TabIndex        =   8
         Top             =   0
         Width           =   1980
      End
   End
   Begin VB.PictureBox picContainer 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6480
      Index           =   5
      Left            =   2760
      MousePointer    =   1  'Arrow
      ScaleHeight     =   432
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   553
      TabIndex        =   21
      Top             =   240
      Width           =   8295
      Begin PhotoDemon.smartCheckBox chkValidateAlpha 
         Height          =   480
         Left            =   360
         TabIndex        =   99
         Top             =   3240
         Width           =   4635
         _ExtentX        =   8176
         _ExtentY        =   847
         Caption         =   "automatically validate all incoming alpha channels"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.ComboBox cmbAlphaCheckSize 
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
         Style           =   2  'Dropdown List
         TabIndex        =   27
         Top             =   2010
         Width           =   5895
      End
      Begin VB.ComboBox cmbAlphaCheck 
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
         Style           =   2  'Dropdown List
         TabIndex        =   25
         Top             =   900
         Width           =   5895
      End
      Begin VB.PictureBox picAlphaOne 
         Appearance      =   0  'Flat
         BackColor       =   &H00808080&
         ForeColor       =   &H80000008&
         Height          =   360
         Left            =   6240
         MouseIcon       =   "VBP_FormPreferences.frx":83E2
         MousePointer    =   99  'Custom
         ScaleHeight     =   22
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   53
         TabIndex        =   24
         TabStop         =   0   'False
         Top             =   900
         Width           =   825
      End
      Begin VB.PictureBox picAlphaTwo 
         Appearance      =   0  'Flat
         BackColor       =   &H00C0C0C0&
         ForeColor       =   &H80000008&
         Height          =   360
         Left            =   7200
         MouseIcon       =   "VBP_FormPreferences.frx":8534
         MousePointer    =   99  'Custom
         ScaleHeight     =   22
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   53
         TabIndex        =   23
         TabStop         =   0   'False
         Top             =   900
         Width           =   825
      End
      Begin VB.Label lblTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "validation"
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
         Index           =   0
         Left            =   0
         TabIndex        =   41
         Top             =   2760
         Width           =   1020
      End
      Begin VB.Label lblAlphaCheckSize 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "transparency checkerboard size:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Left            =   240
         TabIndex        =   28
         Top             =   1590
         Width           =   2790
      End
      Begin VB.Label lblAlphaCheck 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "transparency checkerboard colors:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   240
         Left            =   240
         TabIndex        =   26
         Top             =   480
         Width           =   2970
      End
      Begin VB.Label lblTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "appearance"
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
         Index           =   2
         Left            =   0
         TabIndex        =   22
         Top             =   0
         Width           =   1200
      End
   End
   Begin VB.PictureBox picContainer 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6495
      Index           =   3
      Left            =   2760
      MousePointer    =   1  'Arrow
      ScaleHeight     =   433
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   553
      TabIndex        =   52
      Top             =   240
      Width           =   8295
      Begin VB.ComboBox cmbFiletype 
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
         Left            =   600
         Style           =   2  'Dropdown List
         TabIndex        =   79
         Top             =   960
         Width           =   7395
      End
      Begin VB.PictureBox picFileContainer 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   3735
         Index           =   0
         Left            =   240
         ScaleHeight     =   249
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   529
         TabIndex        =   81
         Top             =   1680
         Width           =   7935
         Begin PhotoDemon.smartCheckBox chkBMPRLE 
            Height          =   480
            Left            =   360
            TabIndex        =   104
            Top             =   600
            Width           =   4890
            _ExtentX        =   8625
            _ExtentY        =   847
            Caption         =   "use RLE compression when saving 8bpp BMP images"
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
         Begin VB.Label lblInterfaceTitle 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "BMP (Bitmap) options"
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
            Index           =   19
            Left            =   120
            TabIndex        =   82
            Top             =   120
            Width           =   2295
         End
      End
      Begin VB.PictureBox picFileContainer 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   3735
         Index           =   4
         Left            =   240
         ScaleHeight     =   249
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   529
         TabIndex        =   73
         Top             =   1680
         Width           =   7935
         Begin PhotoDemon.smartCheckBox chkTIFFCMYK 
            Height          =   480
            Left            =   360
            TabIndex        =   100
            Top             =   1560
            Width           =   4230
            _ExtentX        =   7461
            _ExtentY        =   847
            Caption         =   " save TIFFs as separated CMYK (for printing)"
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
         Begin VB.ComboBox cmbTIFFCompression 
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
            Left            =   360
            Style           =   2  'Dropdown List
            TabIndex        =   74
            Top             =   960
            Width           =   7335
         End
         Begin VB.Label lblInterfaceTitle 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "TIFF (Tagged Image File Format) options"
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
            Index           =   7
            Left            =   120
            TabIndex        =   77
            Top             =   120
            Width           =   4395
         End
         Begin VB.Label lblFileStuff 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "when saving, compress TIFFs using:"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00404040&
            Height          =   240
            Index           =   0
            Left            =   360
            TabIndex        =   75
            Top             =   645
            Width           =   3135
         End
      End
      Begin VB.PictureBox picFileContainer 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   3855
         Index           =   2
         Left            =   240
         ScaleHeight     =   257
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   529
         TabIndex        =   70
         Top             =   1680
         Width           =   7935
         Begin VB.ComboBox cmbPPMFormat 
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
            Left            =   480
            Style           =   2  'Dropdown List
            TabIndex        =   71
            Top             =   960
            Width           =   7335
         End
         Begin VB.Label lblInterfaceTitle 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "PPM (Portable Pixmap) options"
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
            Index           =   12
            Left            =   120
            TabIndex        =   78
            Top             =   120
            Width           =   3285
         End
         Begin VB.Label lblPPMEncoding 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "export PPM files using:"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00404040&
            Height          =   240
            Left            =   240
            TabIndex        =   72
            Top             =   600
            Width           =   1950
         End
      End
      Begin VB.PictureBox picFileContainer 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   4335
         Index           =   1
         Left            =   240
         ScaleHeight     =   289
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   529
         TabIndex        =   83
         Top             =   1680
         Width           =   7935
         Begin PhotoDemon.smartCheckBox chkPNGBackground 
            Height          =   480
            Left            =   360
            TabIndex        =   102
            Top             =   2520
            Width           =   4830
            _ExtentX        =   8520
            _ExtentY        =   847
            Caption         =   "preserve file's original background color, if available"
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
         Begin PhotoDemon.smartCheckBox chkPNGInterlacing 
            Height          =   480
            Left            =   360
            TabIndex        =   101
            Top             =   2040
            Width           =   2430
            _ExtentX        =   4286
            _ExtentY        =   847
            Caption         =   "use interlacing (Adam7)"
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
         Begin VB.HScrollBar hsPNGCompression 
            Height          =   330
            Left            =   360
            Max             =   9
            TabIndex        =   85
            Top             =   1080
            Value           =   9
            Width           =   7095
         End
         Begin VB.Label lblPNGCompression 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "maximum compression"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   -1  'True
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00404040&
            Height          =   195
            Index           =   1
            Left            =   5625
            TabIndex        =   88
            Top             =   1560
            Width           =   1590
         End
         Begin VB.Label lblPNGCompression 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "no compression"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   -1  'True
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00404040&
            Height          =   195
            Index           =   0
            Left            =   600
            TabIndex        =   87
            Top             =   1560
            Width           =   1110
         End
         Begin VB.Label lblFileStuff 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "when saving, compress PNG files at the following level:"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00404040&
            Height          =   240
            Index           =   1
            Left            =   360
            TabIndex        =   86
            Top             =   720
            Width           =   4725
         End
         Begin VB.Label lblInterfaceTitle 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "PNG (Portable Network Graphic) options"
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
            Index           =   20
            Left            =   120
            TabIndex        =   84
            Top             =   120
            Width           =   4290
         End
      End
      Begin VB.PictureBox picFileContainer 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   3735
         Index           =   3
         Left            =   240
         ScaleHeight     =   249
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   529
         TabIndex        =   89
         Top             =   1680
         Width           =   7935
         Begin PhotoDemon.smartCheckBox chkTGARLE 
            Height          =   480
            Left            =   360
            TabIndex        =   103
            Top             =   600
            Width           =   4410
            _ExtentX        =   7779
            _ExtentY        =   847
            Caption         =   "use RLE compression when saving TGA images"
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
         Begin VB.Label lblInterfaceTitle 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "TGA (Truevision) options"
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
            Index           =   21
            Left            =   120
            TabIndex        =   90
            Top             =   120
            Width           =   2700
         End
      End
      Begin VB.Label lblFileFreeImageWarning 
         BackStyle       =   0  'Transparent
         ForeColor       =   &H000000FF&
         Height          =   495
         Left            =   600
         TabIndex        =   80
         Top             =   5520
         Width           =   7455
      End
      Begin VB.Line lineFiletype 
         BorderColor     =   &H8000000D&
         X1              =   536
         X2              =   16
         Y1              =   103
         Y2              =   103
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "please select a file type:"
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
         Index           =   18
         Left            =   360
         TabIndex        =   76
         Top             =   480
         Width           =   2520
      End
      Begin VB.Label lblInterfaceTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "file format options"
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
         Index           =   9
         Left            =   0
         TabIndex        =   53
         Top             =   0
         Width           =   1950
      End
   End
   Begin VB.Line lneVertical 
      BorderColor     =   &H8000000D&
      X1              =   168
      X2              =   168
      Y1              =   8
      Y2              =   448
   End
   Begin VB.Label lblBackground 
      Height          =   855
      Left            =   0
      TabIndex        =   91
      Top             =   6840
      Width           =   11295
   End
End
Attribute VB_Name = "FormPreferences"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'Program Preferences Handler
'Copyright �2002-2013 by Tanner Helland
'Created: 8/November/02
'Last updated: 22/October/12
'Last update: revamped entire interface; settings are now sorted by category.
'
'Dialog for interfacing with the user's desired program preferences.  Handles reading/writing from/to the persistent
' XML file that actually stores any preferences.
'
'Note that this form interacts heavily with the pdPreferences class.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://www.tannerhelland.com/photodemon/#license
'
'***************************************************************************

Option Explicit

'Used to see if the user physically clicked a combo box, or if VB selected it on its own
Dim userInitiatedColorSelection As Boolean
Dim userInitiatedAlphaSelection As Boolean

'Some settings are odd - I want them to update in real-time, so the user can see the effects of the change.  But if the user presses
' "cancel", the original settings need to be returned.  Thus, remember these settings, and restore them upon canceling
Dim originalg_useFancyFonts As Boolean
Dim originalg_AlphaCheckMode As Long
Dim originalg_AlphaCheckOne As Long
Dim originalg_AlphaCheckTwo As Long
Dim originalg_CanvasBackground As Long

'Custom tooltip class allows for things like multiline, theming, and multiple monitor support
Dim m_ToolTip As clsToolTip

'For this particular box, update the interface instantly
Private Sub chkFancyFonts_Click()

    If Me.Visible Then
        g_UseFancyFonts = CBool(chkFancyFonts)
        makeFormPretty Me
        FormMain.requestMakeFormPretty
    End If

End Sub

'Alpha channel checkerboard selection
Private Sub cmbAlphaCheck_Click()

    'Only respond to user-generated events
    If userInitiatedAlphaSelection = True Then

        'Redraw the sample picture boxes based on the value the user has selected
        g_AlphaCheckMode = cmbAlphaCheck.ListIndex
        Select Case cmbAlphaCheck.ListIndex
        
            'Case 0 - Highlights
            Case 0
                g_AlphaCheckOne = RGB(255, 255, 255)
                g_AlphaCheckTwo = RGB(204, 204, 204)
            
            'Case 1 - Midtones
            Case 1
                g_AlphaCheckOne = RGB(153, 153, 153)
                g_AlphaCheckTwo = RGB(102, 102, 102)
            
            'Case 2 - Shadows
            Case 2
                g_AlphaCheckOne = RGB(51, 51, 51)
                g_AlphaCheckTwo = RGB(0, 0, 0)
            
            'Case 3 - Custom
            Case 3
                g_AlphaCheckOne = RGB(255, 204, 246)
                g_AlphaCheckTwo = RGB(255, 255, 255)
            
        End Select
    
        'Change the picture boxes to match the current selection
        picAlphaOne.backColor = g_AlphaCheckOne
        picAlphaTwo.backColor = g_AlphaCheckTwo
                
    End If

End Sub

'Canvas background selection
Private Sub cmbCanvas_Click()
    
    'Only respond to user-generated events
    If userInitiatedColorSelection = True Then
    
        'Redraw the sample picture box value based on the value the user has selected
        Select Case cmbCanvas.ListIndex
            Case 0
                g_CanvasBackground = vb3DLight
            Case 1
                g_CanvasBackground = vb3DShadow
            Case 2
                'Prompt with a color selection box
                Dim retColor As Long
        
                Dim CD1 As cCommonDialog
                Set CD1 = New cCommonDialog
        
                retColor = picCanvasColor.backColor
        
                'If a color is selected, change the picture box and associated combo box to match
                If CD1.VBChooseColor(retColor, True, True, False, Me.hWnd) Then
                    g_CanvasBackground = retColor
                Else
                    g_CanvasBackground = picCanvasColor.backColor
                End If
        End Select
    
        DrawSampleCanvasBackground
    
    End If
    
End Sub

'When a new filetype is selected on the File Formats settings page, display the matching options
Private Sub cmbFiletype_Click()
    
    Dim ftID As Long
    For ftID = 0 To cmbFiletype.ListCount - 1
        If ftID = cmbFiletype.ListIndex Then picFileContainer(ftID).Visible = True Else picFileContainer(ftID).Visible = False
    Next ftID
    
End Sub

'CANCEL button
Private Sub CmdCancel_Click()
    
    'Restore any settings that may have been changed in real-time
    If g_UseFancyFonts <> originalg_useFancyFonts Then
        g_UseFancyFonts = originalg_useFancyFonts
        FormMain.requestMakeFormPretty
    End If
    
    g_AlphaCheckMode = originalg_AlphaCheckMode
    g_AlphaCheckOne = originalg_AlphaCheckOne
    g_AlphaCheckTwo = originalg_AlphaCheckTwo
    g_CanvasBackground = originalg_CanvasBackground
    
    Unload Me
End Sub

'When the category is changed, only display the controls in that category
Private Sub cmdCategory_Click(Index As Integer)
    
    Dim catID As Long
    For catID = 0 To cmdCategory.Count - 1
        If catID = Index Then
            picContainer(catID).Visible = True
            cmdCategory(catID).Value = True
        Else
            picContainer(catID).Visible = False
            cmdCategory(catID).Value = False
        End If
    Next catID
    
End Sub

'OK button
Private Sub CmdOK_Click()
    
    'First, remember the panel(s) that the user was looking at
    Dim i As Long
    For i = 0 To cmdCategory.Count - 1
        If cmdCategory(i).Value = True Then g_UserPreferences.SetPref_Long "General Preferences", "LastPreferencesPage", i
    Next i
    
    g_UserPreferences.SetPref_Long "General Preferences", "LastFilePreferencesPage", cmbFiletype.ListIndex
    
    'We may need to access a generic "form" object multiple times, so I declare it at the top of this sub.
    Dim tForm As Form
    
    'Save all file format preferences
    
    'BMP RLE
    g_UserPreferences.SetPref_Boolean "General Preferences", "BitmapRLE", CBool(chkBMPRLE.Value)
    
    'PNG compression
    g_UserPreferences.SetPref_Long "General Preferences", "PNGCompression", hsPNGCompression.Value
    
    'PNG interlacing
    g_UserPreferences.SetPref_Boolean "General Preferences", "PNGInterlacing", CBool(chkPNGInterlacing.Value)
    
    'PNG background preservation
    g_UserPreferences.SetPref_Boolean "General Preferences", "PNGBackgroundPreservation", CBool(chkPNGBackground.Value)
    
    'PPM encoding
    g_UserPreferences.SetPref_Long "General Preferences", "PPMExportFormat", cmbPPMFormat.ListIndex
    
    'TGA RLE encoding
    g_UserPreferences.SetPref_Boolean "General Preferences", "TGARLE", CBool(chkTGARLE.Value)
    
    'TIFF compression
    g_UserPreferences.SetPref_Long "General Preferences", "TIFFCompression", cmbTIFFCompression.ListIndex
    
    'TIFF CMYK
    g_UserPreferences.SetPref_Boolean "General Preferences", "TIFFCMYK", CBool(chkTIFFCMYK.Value)
        
    'End file format preferences
    
    'Store whether the user wants to be prompted when closing unsaved images
    g_ConfirmClosingUnsaved = CBool(chkConfirmUnsaved.Value)
    g_UserPreferences.SetPref_Boolean "General Preferences", "ConfirmClosingUnsaved", g_ConfirmClosingUnsaved
    
    If g_ConfirmClosingUnsaved Then
        FormMain.cmdClose.ToolTip = g_Language.TranslateMessage("Close the current image." & vbCrLf & vbCrLf & "If the current image has not been saved, you will receive a prompt to save it before it closes.")
    Else
        FormMain.cmdClose.ToolTip = g_Language.TranslateMessage("Close the current image." & vbCrLf & vbCrLf & "Because you have turned off save prompts (via Tools -> Options), you WILL NOT receive a prompt to save this image before it closes.")
    End If
    
    'Store the user's preferred behavior for outgoing color depth
    g_UserPreferences.SetPref_Long "General Preferences", "OutgoingColorDepth", cmbExportColorDepth.ListIndex
    
    'Store the user's preferred behavior for the "Save" command's behavior
    g_UserPreferences.SetPref_Long "General Preferences", "SaveBehavior", cmbSaveBehavior.ListIndex
        
    'Store the user's preferred behavior for the "Save As" dialog's suggested file format
    g_UserPreferences.SetPref_Long "General Preferences", "DefaultSaveFormat", cmbDefaultSaveFormat.ListIndex
    
    'Store the user's preferred behavior for metadata export
    g_UserPreferences.SetPref_Long "General Preferences", "MetadataExport", cmbMetadata.ListIndex
    
    'Store the user's preference for verifying incoming color depth
    g_UserPreferences.SetPref_Boolean "General Preferences", "VerifyInitialColorDepth", CBool(chkInitialColorDepth.Value)
    
    'Store whether PhotoDemon is allowed to check for updates
    g_UserPreferences.SetPref_Boolean "General Preferences", "CheckForUpdates", CBool(chkProgramUpdates.Value)
    
    'Store whether PhotoDemon is allowed to offer the automatic download of missing core plugins
    g_UserPreferences.SetPref_Boolean "General Preferences", "PromptForPluginDownload", CBool(chkPromptPluginDownload.Value)
    
    'Check to see if the new caption length setting matches the old one.  If it does not, rewrite all form captions to match
    If cmbImageCaption.ListIndex <> g_UserPreferences.GetPref_Long("General Preferences", "ImageCaptionSize", 0) Then
        For Each tForm In VB.Forms
            If tForm.Name = "FormImage" Then
                If cmbImageCaption.ListIndex = 0 Then
                    tForm.Caption = pdImages(tForm.Tag).OriginalFileNameAndExtension
                Else
                    If pdImages(tForm.Tag).LocationOnDisk <> "" Then tForm.Caption = pdImages(tForm.Tag).LocationOnDisk Else tForm.Caption = pdImages(tForm.Tag).OriginalFileNameAndExtension
                End If
            End If
        Next
    End If
    g_UserPreferences.SetPref_Long "General Preferences", "ImageCaptionSize", cmbImageCaption.ListIndex
    
    'Similarly, check to see if the new MRU caption setting matches the old one.  If it doesn't, reload the MRU.
    If cmbMRUCaption.ListIndex <> g_UserPreferences.GetPref_Long("General Preferences", "MRUCaptionSize", 0) Then
        g_UserPreferences.SetPref_Long "General Preferences", "MRUCaptionSize", cmbMRUCaption.ListIndex
        MRU_SaveToFile
        MRU_LoadFromFile
        ResetMenuIcons
    End If
        
    'Store whether PhotoDemon should validate incoming alpha channel data
    g_UserPreferences.SetPref_Boolean "General Preferences", "ValidateAlphaChannels", CBool(chkValidateAlpha.Value)
    
    'Store whether HDR images should be tone-mapped at load time
    g_UserPreferences.SetPref_Boolean "General Preferences", "UseToneMapping", CBool(chkToneMapping.Value)
    
    'Store whether we'll log system messages or not
    g_LogProgramMessages = CBool(chkLogMessages.Value)
    g_UserPreferences.SetPref_Boolean "General Preferences", "LogProgramMessages", g_LogProgramMessages
    
    'Store the preference for rendering a drop shadow onto the canvas surrounding an image
    g_CanvasDropShadow = CBool(chkDropShadow.Value)
    g_UserPreferences.SetPref_Boolean "General Preferences", "CanvasDropShadow", g_CanvasDropShadow
    
    If g_CanvasDropShadow Then g_CanvasShadow.initializeSquareShadow PD_CANVASSHADOWSIZE, PD_CANVASSHADOWSTRENGTH, g_CanvasBackground
    
    'Dynamic taskbar icon preference; if it has changed, reset the main form icon
    If Not CBool(chkTaskBarIcon.Value) And g_UserPreferences.GetPref_Boolean("General Preferences", "DynamicTaskbarIcon", True) Then
        setNewTaskbarIcon origIcon32
        setNewAppIcon origIcon16
    End If
    g_UserPreferences.SetPref_Boolean "General Preferences", "DynamicTaskbarIcon", CBool(chkTaskBarIcon.Value)
    
    'Store the canvas background preference
    g_UserPreferences.SetPref_Long "General Preferences", "CanvasBackground", g_CanvasBackground
        
    'Store the alpha checkerboard preference
    g_UserPreferences.SetPref_Long "General Preferences", "AlphaCheckMode", CLng(cmbAlphaCheck.ListIndex)
    g_UserPreferences.SetPref_Long "General Preferences", "AlphaCheckOne", CLng(picAlphaOne.backColor)
    g_UserPreferences.SetPref_Long "General Preferences", "AlphaCheckTwo", CLng(picAlphaTwo.backColor)
    
    'Store the alpha checkerboard size preference
    g_AlphaCheckSize = cmbAlphaCheckSize.ListIndex
    g_UserPreferences.SetPref_Long "General Preferences", "AlphaCheckSize", g_AlphaCheckSize
    
    'Remember how the user wants multipage images to be handled
    g_UserPreferences.SetPref_Long "General Preferences", "MultipageImagePrompt", cmbMultiImage.ListIndex
    
    'Remember whether or not to autog_Zoom large images
    g_AutosizeLargeImages = cmbLargeImages.ListIndex
    g_UserPreferences.SetPref_Long "General Preferences", "AutosizeLargeImages", g_AutosizeLargeImages
    
    'Verify the temporary path
    If LCase(TxtTempPath.Text) <> LCase(g_UserPreferences.getTempPath) Then g_UserPreferences.setTempPath TxtTempPath.Text
    
    'Remember the run-time only settings in the "Advanced" panel
    If g_ImageFormats.GDIPlusEnabled <> CBool(chkGDIPlusTest.Value) Then
        g_ImageFormats.GDIPlusEnabled = CBool(chkGDIPlusTest.Value)
        g_ImageFormats.generateInputFormats
        g_ImageFormats.generateOutputFormats
    End If
    
    'Store the user's preference regarding interface fonts on modern versions of Windows
    g_UserPreferences.SetPref_Boolean "General Preferences", "UseFancyFonts", g_UseFancyFonts
    
    'Store the user's preference for remembering window location
    g_UserPreferences.SetPref_Boolean "General Preferences", "RememberWindowLocation", CBool(chkWindowLocation.Value)
    
    'Store tool preferences
    
    'Clear selections after "Crop to Selection"
    g_UserPreferences.SetPref_Boolean "Tool Preferences", "ClearSelectionAfterCrop", CBool(chkSelectionClearCrop.Value)
    
    'Because some settings affect the way image canvases are rendered, redraw every active canvas
    Message "Saving preferences..."
    For Each tForm In VB.Forms
        If tForm.Name = "FormImage" Then PrepareViewport tForm
    Next
    Message "Finished."
        
    Unload Me
    
End Sub

'Regenerate the preferences file from scratch.  This can be an effective way to "reset" a PhotoDemon installation.
Private Sub cmdReset_Click()

    'Before resetting, warn the user
    Dim confirmReset As VbMsgBoxResult
    confirmReset = pdMsgBox("This action will reset all preferences to their default values.  It cannot be undone." & vbCrLf & vbCrLf & "Are you sure you want to continue?", vbApplicationModal + vbExclamation + vbYesNo, "Reset all preferences")

    'If the user gives final permission, rewrite the preferences file from scratch and repopulate this form
    If confirmReset = vbYes Then
        g_UserPreferences.resetPreferences
        LoadAllPreferences
    End If

End Sub

'When the "..." button is clicked, prompt the user with a "browse for folder" dialog
Private Sub CmdTmpPath_Click()
    Dim tString As String
    tString = BrowseForFolder(Me.hWnd)
    If tString <> "" Then TxtTempPath.Text = FixPath(tString)
End Sub

'Load all relevant values from the preferences file, and populate their corresponding controls with the user's current settings
Private Sub LoadAllPreferences()
    
    'Prepare the various file type panels and listboxes
    cmbFiletype.Clear
    cmbFiletype.AddItem "BMP - Bitmap", 0
    cmbFiletype.AddItem "PNG - Portable Network Graphics", 1
    cmbFiletype.AddItem "PPM - Portable Pixmap", 2
    cmbFiletype.AddItem "TGA - Truevision (TARGA)", 3
    cmbFiletype.AddItem "TIFF - Tagged Image File Format", 4
    
    cmbFiletype.ListIndex = 0
    
    'Set the check box for 8bpp BMP RLE encoding
    If g_UserPreferences.GetPref_Boolean("General Preferences", "BitmapRLE", False) Then chkBMPRLE.Value = vbChecked Else chkBMPRLE.Value = vbUnchecked
    
    'Set the scroll bar for PNG compression
    hsPNGCompression.Value = g_UserPreferences.GetPref_Long("General Preferences", "PNGCompression", 9)
    
    'Set the check box for PNG interlacing
    If g_UserPreferences.GetPref_Boolean("General Preferences", "PNGInterlacing", False) Then chkPNGInterlacing.Value = vbChecked Else chkPNGInterlacing.Value = vbUnchecked
    
    'Preserve PNG background color
    If g_UserPreferences.GetPref_Boolean("General Preferences", "PNGBackgroundPreservation", True) Then chkPNGBackground.Value = vbChecked Else chkPNGBackground.Value = vbUnchecked
    
    'Populate the combo box for PPM export
    cmbPPMFormat.Clear
    cmbPPMFormat.AddItem " binary encoding (faster, smaller file size)", 0
    cmbPPMFormat.AddItem " ASCII encoding (human-readable, multi-platform)", 1
    cmbPPMFormat.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "PPMExportFormat", 0)
    
    'Set the check box for TGA RLE encoding
    If g_UserPreferences.GetPref_Boolean("General Preferences", "TGARLE", False) Then chkTGARLE.Value = vbChecked Else chkTGARLE.Value = vbUnchecked
    
    'Populate the combo box for TIFF compression
    cmbTIFFCompression.Clear
    cmbTIFFCompression.AddItem " default settings - CCITT Group 4 for 1bpp, LZW for all others", 0
    cmbTIFFCompression.AddItem " no compression", 1
    cmbTIFFCompression.AddItem " Macintosh PackBits (RLE)", 2
    cmbTIFFCompression.AddItem " Official DEFLATE ('Adobe-style')", 3
    cmbTIFFCompression.AddItem " PKZIP DEFLATE (also known as zLib DEFLATE)", 4
    cmbTIFFCompression.AddItem " LZW", 5
    cmbTIFFCompression.AddItem " JPEG - 8bpp grayscale or 24bpp color only", 6
    cmbTIFFCompression.AddItem " CCITT Group 3 fax encoding - 1bpp only", 7
    cmbTIFFCompression.AddItem " CCITT Group 4 fax encoding - 1bpp only", 8
    
    cmbTIFFCompression.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "TIFFCompression", 0)
    
    'Set the check box for TIFF CMYK encoding
    If g_UserPreferences.GetPref_Boolean("General Preferences", "TIFFCMYK", False) Then chkTIFFCMYK.Value = vbChecked Else chkTIFFCMYK.Value = vbUnchecked
    
    'Start with the canvas background (which also requires populating the canvas background combo box)
    userInitiatedColorSelection = False
    cmbCanvas.Clear
    cmbCanvas.AddItem " system theme: light", 0
    cmbCanvas.AddItem " system theme: dark", 1
    cmbCanvas.AddItem " custom color (click box to customize)", 2
        
    'Select the proper combo box value based on the g_CanvasBackground variable
    If g_CanvasBackground = vb3DLight Then
        'System theme: light
        cmbCanvas.ListIndex = 0
    ElseIf g_CanvasBackground = vb3DShadow Then
        'System theme: dark
        cmbCanvas.ListIndex = 1
    Else
        'Custom color
        cmbCanvas.ListIndex = 2
    End If
    
    originalg_CanvasBackground = g_CanvasBackground
    
    'Draw the current canvas background to the sample picture box
    DrawSampleCanvasBackground
    userInitiatedColorSelection = True
    
    'Update the check box for dynamic taskbar icon updating
    If g_UserPreferences.GetPref_Boolean("General Preferences", "DynamicTaskbarIcon", True) Then chkTaskBarIcon.Value = vbChecked Else chkTaskBarIcon.Value = vbUnchecked
    If Not g_ImageFormats.FreeImageEnabled Then
        chkTaskBarIcon.Enabled = False
        chkTaskBarIcon.Caption = g_Language.TranslateMessage(" dynamically update taskbar icon to match current image (FreeImage plugin required)")
    End If
    
    'Populate the combo box for exported color depth
    cmbExportColorDepth.Clear
    cmbExportColorDepth.AddItem " to match the image file's original color depth", 0
    cmbExportColorDepth.AddItem " automatically", 1
    cmbExportColorDepth.AddItem " by asking me what color depth I want to use", 2
    cmbExportColorDepth.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "OutgoingColorDepth", 1)
    
    'Populate the combo box for default save behavior
    cmbSaveBehavior.Clear
    cmbSaveBehavior.AddItem " overwrite the current file (standard behavior)", 0
    cmbSaveBehavior.AddItem " save a new copy, e.g. ""filename (2).jpg"" (safe behavior)", 1
    cmbSaveBehavior.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "SaveBehavior", 0)
    
    'Populate the combo box for default save file format
    cmbDefaultSaveFormat.Clear
    cmbDefaultSaveFormat.AddItem " the current file format of the image being saved", 0
    cmbDefaultSaveFormat.AddItem " the last image format I used in the ""Save As"" screen", 1
    cmbDefaultSaveFormat.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "DefaultSaveFormat", 0)
        
    'Populate the combo box for default metadata export handling
    cmbMetadata.Clear
    cmbMetadata.AddItem " preserve all original metadata, regardless of relevance", 0
    cmbMetadata.AddItem " preserve all relevant metadata", 1
    cmbMetadata.AddItem " preserve all relevant metadata, but remove personal tags (GPS coords, serial #'s, etc)", 2
    cmbMetadata.AddItem " do not preserve metadata", 3
    cmbMetadata.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "MetadataExport", 1)
        
    'Populate the check box for initial color depth calcuations
    If g_UserPreferences.GetPref_Boolean("General Preferences", "VerifyInitialColorDepth", True) Then chkInitialColorDepth.Value = vbChecked Else chkInitialColorDepth.Value = vbUnchecked
    
    'Populate the combo boxes for caption-related preferences
    cmbImageCaption.Clear
    cmbImageCaption.AddItem " compact - file name only", 0
    cmbImageCaption.AddItem " descriptive - full location, including folder(s)", 1
    cmbImageCaption.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "ImageCaptionSize", 0)
    
    cmbMRUCaption.Clear
    cmbMRUCaption.AddItem " compact - file names only", 0
    cmbMRUCaption.AddItem " descriptive - full locations, including folder(s)", 1
    cmbMRUCaption.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "MRUCaptionSize", 0)
    
    'Populate the combo box for multipage image handling
    cmbMultiImage.Clear
    cmbMultiImage.AddItem " ask me how I want to proceed", 0
    cmbMultiImage.AddItem " load only the first image", 1
    cmbMultiImage.AddItem " load all the images in the file", 2
    cmbMultiImage.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "MultipageImagePrompt", 0)
    
    'Next, get the values for alpha-channel checkerboard rendering
    userInitiatedAlphaSelection = False
    cmbAlphaCheck.Clear
    cmbAlphaCheck.AddItem " Highlight checks", 0
    cmbAlphaCheck.AddItem " Midtone checks", 1
    cmbAlphaCheck.AddItem " Shadow checks", 2
    cmbAlphaCheck.AddItem " Custom (click boxes to customize)", 3
    
    cmbAlphaCheck.ListIndex = g_AlphaCheckMode
    originalg_AlphaCheckMode = g_AlphaCheckMode
    
    picAlphaOne.backColor = g_AlphaCheckOne
    picAlphaTwo.backColor = g_AlphaCheckTwo
    originalg_AlphaCheckOne = g_AlphaCheckOne
    originalg_AlphaCheckTwo = g_AlphaCheckTwo
    
    userInitiatedAlphaSelection = True
    
    'Next, get the current alpha-channel checkerboard size value
    cmbAlphaCheckSize.Clear
    cmbAlphaCheckSize.AddItem " Small (4x4 pixels)", 0
    cmbAlphaCheckSize.AddItem " Medium (8x8 pixels)", 1
    cmbAlphaCheckSize.AddItem " Large (16x16 pixels)", 2
    
    cmbAlphaCheckSize.ListIndex = g_AlphaCheckSize
    
    'Assign the check box for validating incoming alpha channels on 32bpp images
    If g_UserPreferences.GetPref_Boolean("General Preferences", "ValidateAlphaChannels", True) Then chkValidateAlpha.Value = vbChecked Else chkValidateAlpha.Value = vbUnchecked
    
    'Assign the check box for using tone mapping on HDR images
    If g_UserPreferences.GetPref_Boolean("General Preferences", "UseToneMapping", True) Then chkToneMapping.Value = vbChecked Else chkToneMapping.Value = vbUnchecked
    
    'Assign the check box for logging program messages
    If g_LogProgramMessages Then chkLogMessages.Value = vbChecked Else chkLogMessages.Value = vbUnchecked
    
    'Assign the check box for prompting about unsaved images
    If g_ConfirmClosingUnsaved Then chkConfirmUnsaved.Value = vbChecked Else chkConfirmUnsaved.Value = vbUnchecked
    
    'Assign the check box for rendering a drop shadow around the image
    If g_CanvasDropShadow Then chkDropShadow.Value = vbChecked Else chkDropShadow.Value = vbUnchecked
    
    'Display the current temporary file path
    TxtTempPath.Text = g_UserPreferences.getTempPath
    
    'We have to pull the "offer to download plugins" value from the preferences file, since we don't track
    ' it internally (it's only accessed when PhotoDemon is first loaded)
    If g_UserPreferences.GetPref_Boolean("General Preferences", "PromptForPluginDownload", True) Then chkPromptPluginDownload.Value = vbChecked Else chkPromptPluginDownload.Value = vbUnchecked
    
    'Same for checking for software updates
    If g_UserPreferences.GetPref_Boolean("General Preferences", "CheckForUpdates", True) Then chkProgramUpdates.Value = vbChecked Else chkProgramUpdates.Value = vbUnchecked
    
    'Same for remember last-used window location
    If g_UserPreferences.GetPref_Boolean("General Preferences", "RememberWindowLocation", True) Then chkWindowLocation.Value = vbChecked Else chkWindowLocation.Value = vbUnchecked
    
    'Populate the "what to do when loading large images" combo box
    cmbLargeImages.Clear
    cmbLargeImages.AddItem " automatically fit the image on-screen", 0
    cmbLargeImages.AddItem " 1:1 (100% zoom, or ""actual size"")", 1
    cmbLargeImages.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "AutosizeLargeImages", 0)
    
    'Hide the modern typefaces box if the user in on XP.  If the user is on Vista or later, set the box according
    ' to the preference stated in their preferences file.
    If Not g_IsVistaOrLater Then
        chkFancyFonts.Caption = g_Language.TranslateMessage("render PhotoDemon text with modern typefaces (only available on Vista or newer)")
        chkFancyFonts.Enabled = False
    Else
        chkFancyFonts.Caption = g_Language.TranslateMessage("render PhotoDemon text with modern typefaces")
        chkFancyFonts.Enabled = True
        If g_UseFancyFonts Then chkFancyFonts.Value = vbChecked Else chkFancyFonts.Value = vbUnchecked
        originalg_useFancyFonts = g_UseFancyFonts
    End If
        
    'Populate and en/disable the run-time only settings in the "Advanced" panel
    If g_ImageFormats.GDIPlusEnabled Then
        chkGDIPlusTest.Caption = g_Language.TranslateMessage(" enable GDI+ support")
        chkGDIPlusTest.Value = vbChecked
    Else
        chkGDIPlusTest.Caption = g_Language.TranslateMessage(" enable GDI+ support (do not enable this if gdiplus.dll is not available)")
        chkGDIPlusTest.Value = vbUnchecked
    End If
    
    'Next, it's time for tool preferences
    
    'Clear selections after "Crop to Selection"
    If g_UserPreferences.GetPref_Boolean("Tool Preferences", "ClearSelectionAfterCrop", True) Then chkSelectionClearCrop.Value = vbChecked Else chkSelectionClearCrop.Value = vbUnchecked

    'If any preferences rely on FreeImage to operate, en/disable them as necessary
    If g_ImageFormats.FreeImageEnabled = False Then
        'chkToneMapping.Value = vbUnchecked
        chkToneMapping.Caption = g_Language.TranslateMessage(" feature disabled due to missing plugin")
        chkToneMapping.Enabled = False
        cmbMultiImage.Clear
        cmbMultiImage.AddItem " feature disabled due to missing plugin", 0
        cmbMultiImage.ListIndex = 0
        cmbMultiImage.Enabled = False
        lblFreeImageWarning.Caption = g_Language.TranslateMessage("NOTE: Some options on this page have been disabled because the FreeImage plugin is missing.  To enable these options, please click on ""Updates"" and select ""if core plugins cannot be located, offer to download them.""  Then restart the program and select ""Yes"" when prompted.")
        lblFreeImageWarning.Visible = True
        lblFileFreeImageWarning.Caption = g_Language.TranslateMessage("NOTE: Many of these file format options require the FreeImage plugin.  Because you do not have the FreeImage plugin installed, these options may not perform as expected.")
        lblFileFreeImageWarning.Visible = True
    Else
        chkToneMapping.Enabled = True
        cmbMultiImage.Enabled = True
        lblFreeImageWarning.Visible = False
        lblFileFreeImageWarning.Visible = False
    End If

    'Finally, display some memory usage information
    lblMemoryUsageCurrent.Caption = g_Language.TranslateMessage("current PhotoDemon memory usage:") & " " & Format(CStr(GetPhotoDemonMemoryUsage()), "###,###,###,###") & " K"
    lblMemoryUsageMax.Caption = g_Language.TranslateMessage("max PhotoDemon memory usage this session:") & " " & Format(CStr(GetPhotoDemonMemoryUsage(True)), "###,###,###,###") & " K"
    If Not g_IsProgramCompiled Then
        lblMemoryUsageCurrent = lblMemoryUsageCurrent.Caption & " (" & g_Language.TranslateMessage("reading not accurate inside IDE") & ")"
        lblMemoryUsageMax = lblMemoryUsageMax.Caption & " (" & g_Language.TranslateMessage("reading not accurate inside IDE") & ")"
    End If

End Sub

'When the form is loaded, populate the various checkboxes and textboxes with the values from the preferences file
Private Sub Form_Load()

    'Populate all controls with their corresponding values
    LoadAllPreferences
    
    'Populate the multi-line tooltips for the category command buttons
        'Interface
        cmdCategory(0).ToolTip = g_Language.TranslateMessage("Interface options include settings for the main PhotoDemon interface, including things like canvas settings, font selection, and positioning.")
        'Loading
        cmdCategory(1).ToolTip = g_Language.TranslateMessage("Load options allow you to customize the way image files enter the application.")
        'Saving
        cmdCategory(2).ToolTip = g_Language.TranslateMessage("Save options allow you to customize the way image files leave the application.")
        'File formats
        cmdCategory(3).ToolTip = g_Language.TranslateMessage("File format options control how PhotoDemon handles certain types of images.")
        'Performance
        'cmdCategory(3).ToolTip = "Performance preferences allow you to specify how aggressively PhotoDemon makes use" & vbCrLf & "of the system's available RAM and hard drive space."
        'Tools
        cmdCategory(4).ToolTip = g_Language.TranslateMessage("Tool options currently include customizable options for the Selection Tool. In the future, PhotoDemon will gain paint tools, and those settings will appear here as well.")
        'Transparency
        cmdCategory(5).ToolTip = g_Language.TranslateMessage("Transparency options control how PhotoDemon displays images that contain alpha channels (e.g. 32bpp images).")
        'Updates
        cmdCategory(6).ToolTip = g_Language.TranslateMessage("Update options control how frequently PhotoDemon checks for updated versions, and how it handles the download of missing plugins.")
        'Advanced
        cmdCategory(7).ToolTip = g_Language.TranslateMessage("Advanced options can be safely ignored by regular users. Testers and developers may, however, find these settings useful.")
    
    'Populate the network access disclaimer in the "Update" panel
        lblExplanation.Caption = g_Language.TranslateMessage("PhotoDemon provides two non-essential features that require Internet access: checking for software updates, and offering to download core plugins if they aren't present in the \App\PhotoDemon\Plugins subdirectory." & vbCrLf & vbCrLf & "The developers of PhotoDemon take privacy very seriously, so no information - statistical or otherwise - is uploaded by these features. Checking for software updates involves downloading a single ""updates.txt"" file containing the latest software version number. Similarly, downloading missing plugins simply involves downloading one or more compressed plugin files from the PhotoDemon server." & vbCrLf & vbCrLf & "If you choose to disable these features, you can always visit tannerhelland.com/photodemon to manually download the most recent version of the program.")
        
    'Populate a few more tooltips.  These are done manually for translation purposes; the tooltips themselves are too long to fit
    ' inside a traditional VB object, so it dumps them to a separate custom .frx resource file where they are difficult to extract.
    ' Rather than mess with that, I manually add the tooltips here so that the automatic translation engine can easily find the text.
        chkTaskBarIcon.ToolTipText = g_Language.TranslateMessage("While multitasking, some find it convenient to have the PhotoDemon task bar icon reflect the image currently being edited.  This option allows PhotoDemon to automatically update the task bar and window icons as necessary.")
        cmbMRUCaption.ToolTipText = g_Language.TranslateMessage("The ""Recent Files"" menu width is limited by Windows.  To prevent this menu from overflowing, PhotoDemon can display image names only instead of full image locations.")
        chkValidateAlpha.ToolTipText = g_Language.TranslateMessage("When checked, this option allows PhotoDemon to automatically remove empty alpha channels from imported images. This improves program performance, reduces RAM usage, and improves file size on exported files.")
        chkBMPRLE.ToolTipText = g_Language.TranslateMessage("Bitmap files only support one type of compression, and they only support it for certain color depths.  PhotoDemon can apply simple RLE compression when saving 8bpp images.")
        chkTGARLE.ToolTipText = g_Language.TranslateMessage("TGA files only support one type of compression.  PhotoDemon can apply simple RLE compression when saving TGA images.")
        chkTIFFCMYK.ToolTipText = g_Language.TranslateMessage("TIFFs support both RGB and CMYK color spaces.  RGB is used by default, but if a TIFF file is going to be used in printed document, CMYK is sometimes required.")
        cmbTIFFCompression.ToolTipText = g_Language.TranslateMessage("TIFFs support a variety of compression techniques.  Some of these techniques are limited to specific color depths, so make sure you pick one that matches the images you plan on saving.")
        chkPNGInterlacing.ToolTipText = g_Language.TranslateMessage("PNG interlacing is similar to ""progressive scan"" on JPEGs.  Interlacing slightly increases file size, but an interlaced image can ""fade-in"" while it downloads.")
        chkPNGBackground.ToolTipText = g_Language.TranslateMessage("PNG files can contain a background color parameter.  This takes up extra space in the file, so feel free to disable it if you don't need background colors.")
        cmbPPMFormat.ToolTipText = g_Language.TranslateMessage("Binary encoding of PPM files is strongly suggested.  (In other words, don't change this setting unless you are certain that ASCII encoding is what you want. :)")
        chkInitialColorDepth.ToolTipText = g_Language.TranslateMessage("This option allows PhotoDemon to scan incoming images to determine the most appropriate color depth on a case-by-case basis (rather than relying on the source image file's color depth, which may have been chosen arbitrarily).")
        chkToneMapping.ToolTipText = g_Language.TranslateMessage("Tone mapping is used to preserve the tonal range of HDR images.  This setting is very useful for RAW photos and scanned documents, but it adds a significant amount of time to the image load process.")
        chkSelectionClearCrop.ToolTipText = g_Language.TranslateMessage("When the ""Crop to Selection"" command is used, the resulting image will always contain a selection the same size as the full image.  There is generally no need to retain this, so PhotoDemon can automatically clear it for you.")
        chkLogMessages.ToolTipText = g_Language.TranslateMessage("If this is checked, PhotoDemon will create a human-readable .log file that contains the text of every message displayed on the progress bar.  This will increase processing time, so only check this option if you really need debugging data.")
        chkPromptPluginDownload.ToolTipText = g_Language.TranslateMessage("PhotoDemon relies on several free, open-source plugins for full functionality. If any of these plugins are missing (for example, if you downloaded PhotoDemon from a 3rd-party site), this option will offer to download the missing plugins for you.")
        cmbExportColorDepth.ToolTipText = g_Language.TranslateMessage("Some image file types support a variety of color depths.  PhotoDemon's developers suggest letting the software choose the best color depth for you, unless you have reason to choose otherwise.")
        cmbSaveBehavior.ToolTipText = g_Language.TranslateMessage("In most photo editors, the ""Save"" command saves the image over its original version, erasing that copy forever.  PhotoDemon provides a ""safer"" option, where each save results in a new copy of the file.")
        cmbDefaultSaveFormat.ToolTipText = g_Language.TranslateMessage("Most photo editors use the format of the current image as the default in the ""Save As"" screen.  When working with RAW images that will eventually be saved to JPEG, it is useful to have PhotoDemon remember that - hence the ""last used"" option.")
        cmbMultiImage.ToolTipText = g_Language.TranslateMessage("Some image formats can hold multiple images in one file.  When these files are encountered, PhotoDemon can ignore the extra images, or it can load them all for you.")
        cmbLargeImages.ToolTipText = g_Language.TranslateMessage("Any photo larger than 2 megapixels is too big to fit on an average computer monitor.  PhotoDemon can automatically zoom out on large photographs so that the entire image is viewable.")
        cmbCanvas.ToolTipText = g_Language.TranslateMessage("The image canvas sits ""behind"" the image on the screen.  Dark colors are generally preferable, as they help the image stand out while you work on it.")
        cmbAlphaCheck.ToolTipText = g_Language.TranslateMessage("If an image has transparent areas, a checkerboard is typically displayed ""behind"" the image.  This box lets you change the checkerboard's colors.")
        cmbAlphaCheckSize.ToolTipText = g_Language.TranslateMessage("If an image has transparent areas, a checkerboard is typically displayed ""behind"" the image.  This box lets you change the checkerboard's size.")
        cmbFiletype.ToolTipText = g_Language.TranslateMessage("Some image file types support additional parameters when importing and exporting.  By default, PhotoDemon will manage these for you, but you can specify different parameters if necessary.")
        picCanvasColor.ToolTipText = g_Language.TranslateMessage("Click to change the image window background color")
        picAlphaOne.ToolTipText = g_Language.TranslateMessage("Click to change the first checkerboard background color for alpha channels")
        picAlphaTwo.ToolTipText = g_Language.TranslateMessage("Click to change the second checkerboard background color for alpha channels")
        cmbMetadata.ToolTipText = g_Language.TranslateMessage("Image metadata is extra data placed in an image file by a camera or photo software.  This data can include things like the make and model of the camera, or the GPS coordinates of the photo's location, or many other items.  To view an image's metadata, use the Image -> Metadata menu.")
       
    'Finally, hide the inactive category panels
    Dim i As Long
    For i = 0 To picContainer.Count - 1
        picContainer(i).Visible = False
        cmdCategory(i).Value = False
    Next i
    For i = 0 To picFileContainer.Count - 1
        picFileContainer(i).Visible = False
    Next i
    
    'Activate the last preferences panel that the user looked at
    picContainer(g_UserPreferences.GetPref_Long("General Preferences", "LastPreferencesPage", 0)).Visible = True
    cmdCategory(g_UserPreferences.GetPref_Long("General Preferences", "LastPreferencesPage", 0)).Value = True
    
    'Also, activate the last file preferences sub-panel that the user looked at
    cmbFiletype.ListIndex = g_UserPreferences.GetPref_Long("General Preferences", "LastFilePreferencesPage", 1)
    picFileContainer(g_UserPreferences.GetPref_Long("General Preferences", "LastFilePreferencesPage", 1)).Visible = True
    
    'Translate and decorate the form; note that a custom tooltip object is passed.  makeFormPretty will automatically
    ' populate this object for us, which allows for themed and multiline tooltips.
    Set m_ToolTip = New clsToolTip
    makeFormPretty Me, m_ToolTip
    
    'For some reason, the container picture boxes automatically acquire the pointer of children objects.
    ' Manually force those cursors to arrows to prevent this.
    For i = 0 To picContainer.Count - 1
        setArrowCursorToObject picContainer(i)
    Next i
    
    For i = 0 To picFileContainer.Count - 1
        setArrowCursorToObject picFileContainer(i)
    Next i
    
End Sub

'Draw a sample of the current background to the PicCanvasColor picture box
Private Sub DrawSampleCanvasBackground()
    
    Me.picCanvasColor.Enabled = True
    Me.picCanvasColor.backColor = ConvertSystemColor(g_CanvasBackground)
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseFormTheming Me
End Sub

'Allow the user to change the first checkerboard color for alpha channels
Private Sub picAlphaOne_Click()
    
    Dim retColor As Long
    
    Dim CD1 As cCommonDialog
    Set CD1 = New cCommonDialog
    
    retColor = picAlphaOne.backColor
    
    'Display a Windows color selection box
    CD1.VBChooseColor retColor, True, True, False, Me.hWnd
    
    'If a color was selected, change the picture box and associated combo box to match
    If retColor > 0 Then
    
        g_AlphaCheckOne = retColor
        picAlphaOne.backColor = retColor
        
        userInitiatedAlphaSelection = False
        cmbAlphaCheck.ListIndex = 3   '3 corresponds to "custom colors"
        userInitiatedAlphaSelection = True
                
    End If
    
End Sub

'Allow the user to change the second checkerboard color for alpha channels
Private Sub picAlphaTwo_Click()
    
    Dim retColor As Long
    
    Dim CD1 As cCommonDialog
    Set CD1 = New cCommonDialog
    
    retColor = picAlphaTwo.backColor
    
    'Display a Windows color selection box
    CD1.VBChooseColor retColor, True, True, False, Me.hWnd
    
    'If a color was selected, change the picture box and associated combo box to match
    If retColor > 0 Then
    
        g_AlphaCheckTwo = retColor
        picAlphaTwo.backColor = retColor
        
        userInitiatedAlphaSelection = False
        cmbAlphaCheck.ListIndex = 3   '3 corresponds to "custom colors"
        userInitiatedAlphaSelection = True
                
    End If
    
End Sub

'Clicking the sample color box allows the user to pick a new color
Private Sub picCanvasColor_Click()
    
    Dim retColor As Long
    
    Dim CD1 As cCommonDialog
    Set CD1 = New cCommonDialog
    
    retColor = picCanvasColor.backColor
    
    'Display a Windows color selection box
    CD1.VBChooseColor retColor, True, True, False, Me.hWnd
    
    'If a color was selected, change the picture box and associated combo box to match
    If retColor >= 0 Then
    
        g_CanvasBackground = retColor
        
        userInitiatedColorSelection = False
        If g_CanvasBackground = vb3DLight Then
            'System theme: light
            cmbCanvas.ListIndex = 0
        ElseIf g_CanvasBackground = vb3DShadow Then
            'System theme: dark
            cmbCanvas.ListIndex = 1
        Else
            'Custom color
            cmbCanvas.ListIndex = 2
        End If
        userInitiatedColorSelection = True
        
        DrawSampleCanvasBackground
        
    End If
    
End Sub

'Test to see if we can determine folder access...
Private Sub TxtTempPath_Change()
    If Not DirectoryExist(TxtTempPath.Text) Then
        lblTempPathWarning.Caption = g_Language.TranslateMessage("WARNING: this folder is invalid (access prohibited).  Please provide a valid folder.  If no new folder is provided, PhotoDemon will use the system's default temp location.")
        lblTempPathWarning.Visible = True
    Else
        lblTempPathWarning.Visible = False
    End If
End Sub

