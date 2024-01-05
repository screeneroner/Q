;----------------------------------------------------------------------------------------------------------------------
; This code is free software: you can redistribute it and/or modify  it under the terms of the 
; version 3 GNU General Public License as published by the Free Software Foundation.
; 
; This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY without even 
; the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
; See the GNU General Public License for more details (https://www.gnu.org/licenses/gpl-3.0.html)
;
; WARNING TO USERS AND MODIFIERS
;
; This script contains "Buy me a coffee" links to honor the author's hard work and dedication in creating
; all the features present in this code. Removing or altering these links not only violates the GPL license
; but also disregards the significant effort put into making this script valuable for the community.
;
; If you find value in this script and would like to show appreciation to the author,
; kindly consider visiting the site below and treating the author to a few cups of coffee:
;
; https://www.buymeacoffee.com/screeneroner
;
; Your honor and gratitude is greatly appreciated.
;----------------------------------------------------------------------------------------------------------------------


#SingleInstance force
#Persistent 
FileEncoding, UTF-8-RAW 
CoordMode, ToolTip, Relative

;#Include, Q_debug.ahk

; this file is required for normal config work, so create it if it is absent
if (!FileExist("Q.ini"))
    CreateConfig()


;----------------------------------------------------------------------------------------------------------------------
; FEATURES AND HELP KITCHEN
;----------------------------------------------------------------------------------------------------------------------
help = 
(
LANGUAGES SWITCHING
         >Alt     –  Show current language
         >Shift  –  First language
         >Ctrl    –  Second language
hold >Ctrl    –  to switch second language`r——————————————————————————
)

IniRead, hk, Q.ini, Tools, Translate
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, Translate_Selection 
    help := help . "`r      " . hk . "  –  Google Translate from current language"
}

; TRANSLITERATE (transliterating strings read every time inside the function call) ____________________________________
IniRead, hk, Q.ini, Transliterating
if (hk != "ERROR" and hk!="") {
    help := help . "`r`rTRANSLITERATING"
}
IniRead, hk, Q.ini, Transliterating, TransliterateFirstSecond
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, TransliterateFirstSecond 
    help := help . "`r      " . hk . "  –  From first to second laguage"
}
IniRead, hk, Q.ini, Transliterating, TransliterateSeconds
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, TransliterateSeconds 
    help := help . "`r      " . hk . "  –  Between seconds laguages"
}


; CASE ________________________________________________________________________________________________________________
IniRead, hk, Q.ini, Case
if (hk != "ERROR" and hk!="") {
    help := help . "`r`rTEXT CASE"
}
IniRead, hk, Q.ini, Case, Upper
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, CaseUpper
    help := help . "`r      " . hk . "  –  UPPER <- upper "
}
IniRead, hk, Q.ini, Case, Lower
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, CaseLower
    help := help . "`r      " . hk . "  –  lower <- LOWER"
}
IniRead, hk, Q.ini, Case, Camel
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, CaseCamel
    help := help . "`r      " . hk . "  –  Camel Case <- CAMEL case"
}
IniRead, hk, Q.ini, Case, Invert
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, CaseInvert
    help := help . "`r      " . hk . "  –  iNVERT cASE <- Invert Case"
}

; COLORS ______________________________________________________________________________________________________________
IniRead, hk, Q.ini, Color
if (hk != "ERROR" and hk!="") {
    help := help . "`r`rSCREEN COLOR"
}
IniRead, hk, Q.ini, Color, ShowHTML
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, ColorShowHTML
    help := help . "`r      " . hk . "  –  Show HTML color (#rrggbb)"
}
IniRead, hk, Q.ini, Color, ShowRGB
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, ColorShowRGB
    help := help . "`r      " . hk . "  –  Show HTML color (rrr,ggg,bbb)"
}
IniRead, hk, Q.ini, Color, CopyHTML
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, ColorCopyHTML
    help := help . "`r      " . hk . "  –  Copy HTML color (#rrggbb)"
}
IniRead, hk, Q.ini, Color, CopyRGB
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, ColorCopyRGB
    help := help . "`r      " . hk . "  –  Copy HTML color (rrr,ggg,bbb)"
}
IniRead, hk, Q.ini, Color, Paste
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, ColorPaste
    help := help . "`r      " . hk . "  –  Paste color into Color Picker Dialog"
}

; WALLET ______________________________________________________________________________________________________________
IniRead, hk, Q.ini, Wallet
if (hk != "ERROR" and hk!="") {
    help := help . "`r`rWALLET"
}
IniRead, hk, Q.ini, Wallet, Show
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, Wallet_Show
    help := help . "`r      " . hk . "  –  Show wallet menu"
}
IniRead, hk, Q.ini, Wallet, Lock
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, Wallet_Lock
    help := help . "`r      " . hk . "  –  Quick lock wallet"
}
; TOOLS __________________________________________________________________________________________________________
IniRead, hk, Q.ini, Tools
if (hk != "ERROR" and hk!="") {
    help := help . "`r`rTOOLS"
}
IniRead, hk, Q.ini, Tools, Stamps
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, Stamps
    help := help . "`r      " . hk . "  –  Date/Time stamps in various formats"
}
; PLAIN TEXT COPYPASTING ______________________________________________________________________________________________
IniRead, hk, Q.ini, Tools, RemoveClipboardFormatting
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, RemoveClipboardFormatting
    help := help . "`r      " . hk . "  –  Remove Clipboard Formatting"
}
IniRead, hk, Q.ini, Tools, PastePlainText
if (hk != "ERROR" and hk!="") {
    Hotkey, % hk, PastePlainText
    help := help . "`r      " . hk . "  –  Paste text only without formatting"
}
; CLIPBOARD MONITORING ________________________________________________________________________________________________
IniRead, hk, Q.ini, Clipboard
if (hk != "ERROR" and hk!="") {
    IniRead, hk, Q.ini, Clipboard, Show
    Hotkey, % hk, ShowClipboardHistoryMenu
    help := help . "`r      " . hk . "  –  Show clipboard history"
    IniRead, hk, Q.ini, Clipboard, Colunms
    Colunms := (hk != "ERROR" and hk!="") ? hk : 1
    IniRead, hk, Q.ini, Clipboard, ItemsInColunm
    ItemsInColunm := (hk != "ERROR" and hk!="") ? hk : 30
    ClipboardHistoryLen := ItemsInColunm * Colunms - 3  ; -3 for separator and monitoring toggle checkbox and clear history item
}

; MOUSE _______________________________________________________________________________________________________________
IniRead, hk, Q.ini, Mouse
if (hk != "ERROR" and hk!="") 
    help := help . "`r`rMOUSE"
IniRead, hk_numpadmouse, Q.ini, Mouse, NumpadMouse
if (hk_numpadmouse="Yes") 
    help := help . "`r      Numpad Arrows  –  Move mouse by 1px. +Shift by 10px"

help := help . "`r`r——————————————————————————`rKeys Legend: +  –  Shift   ^  –  Ctrl   !  –  Alt   #  –  Windows`rModifiers: <  –  Left key   >  –  Right key"


;----------------------------------------------------------------------------------------------------------------------
; INITIAL SETUP OF THE TRAY MENU
;----------------------------------------------------------------------------------------------------------------------
#Include, Q_languages.ahk
#Include, Q_transliterating.ahk 
#Include, Q_translating.ahk
#Include, Q_case.ahk 
#Include, Q_tools.ahk
#Include, Q_wallet.ahk
#Include, Q_clipboard.ahk

SetLanguage(1) ; alway start from First Language

;----------------------------------------------------------------------------------------------------------------------
; INITIAL SETUP OF THE TRAY MENU
;----------------------------------------------------------------------------------------------------------------------
; 2.04 - initial release
; 2.05 - stability improvements
; 2.06 - switched to PostMessage to prevent hanging on sending messages
; 2.07 - added resteart tray menu item to quickly REinit wallet menu if previously was entered wrong password and you see very looooong menu
; 2.08 - fixed UTF-8 typos in help and guides
version := "v2.08  by Screeneroner"
Menu, Tray, NoStandard ; Remove the standard menu items
;Menu, Tray, Icon, Q.ico
Menu, Tray, Tip, Q %version%

;- AUTOSTART MANAGEMENT -----------------------------------------------------------------------------------------------
Menu, Tray, Add, Autostart, ToggleAutostart
Menu, Tray, Add

AppName := SubStr(A_ScriptFullPath, InStr(A_ScriptFullPath, "\") + 1)
RegKeyName := "Q Keyboard Switcher"
RegKey := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"

GetAutoStart()

GetAutoStart() {
    global AppName, RegKey, RegKeyName, AutostartEnabled
    RegRead, AutostartEnabled, %RegKey%, %RegKeyName%
    if (AutostartEnabled = "") 
        Menu, Tray, Uncheck, Autostart
    else 
        Menu, Tray, Check, Autostart    
}
ToggleAutostart() {
    global AppName, RegKey, RegKeyName, AutostartEnabled
    GetAutoStart()
    
    if (AutostartEnabled = "") 
        RegWrite, REG_SZ, %RegKey%, %RegKeyName%, "%A_ScriptFullPath%"
    else 
        RegDelete, %RegKey%, %RegKeyName%
    Sleep, 2000 ; required to rigistry full refresh ?!?!????
    GetAutoStart()
}
;----------------------------------------------------------------------------------------------------------------------

Menu, Tray, Add, Help, ShowHelp 
Menu, Tray, Icon, Help, %SystemRoot%\System32\shell32.dll,155
Menu, Tray, Add, Buy me a coffee, BuyCoffee 
Menu, Tray, Add
Menu, Tray, Add, Restart Q, RestartScript
Menu, Tray, Add, Exit, ExitScript 
Menu, Tray, Default, Buy me a coffee
Menu, Tray, Icon, Buy me a coffee, %SystemRoot%\System32\shell32.dll,44

RestartScript() {
    ThisScriptPath := A_ScriptFullPath
    Run, %ThisScriptPath%
}

; ShowHelp() 

ShowHelp() {
    global help, version
    MsgBox, 64, Q %version%, %help%
}
CreateConfig() {
    FileDelete, Q.ini    
    FileAppend, 
(
[Tools]
Translate = <#!T
RemoveClipboardFormatting = <#!F
PastePlainText = <#+Ins
Stamps = <#!S

[Mouse]
NumpadMouse    = Yes
Multimedia     = Yes
MinDobleClickInterval = 350

[Case]
Upper  = <#!U
Lower  = <#!L
Invert = <#!I
Camel  = <#!C

[Color]
ShowHTML = <#LButton
ShowRGB  = <#!LButton
CopyHTML = <#^LButton
CopyRGB  = <#^!LButton
Paste    = <#^Ins

[Wallet]
Show   = <#!W
Lock   = <#!Q

[Clipboard]
Show = <#!Down
Colunms = 3
ItemsInColunm = 30
ItemVisibleLength = 50

[Transliterating]
TransliterateFirstSecond = <#!BS
TransliterateSeconds = <#^BS
1 = ``1234567890-=qwertyuiop[]\asdfghjkl;'zxcvbnm,./~!@#$`%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?
), Q.ini
    MsgBox  64, Q Configuration, File Q.ini with full set of features turned on created.`rYou may edit it and then reload Q to re-read your changes. , 5
}
BuyCoffee() {
    Run, https://www.buymeacoffee.com/screeneroner
}
ExitScript() {
    ExitApp
}

;----------------------------------------------------------------------------------------------------------------------

#if (hk_numpadmouse="Yes") 
{
    NumpadLeft::MouseMove    -1,   0, 2, R
    NumpadRight::MouseMove    1,   0, 2, R
    NumpadUp::MouseMove       0,  -1, 2, R
    NumpadDown::MouseMove     0,   1, 2, R

    NumpadHome::MouseMove   -1,   -1, 2, R
    NumpadEnd::MouseMove    -1,    1, 2, R
    NumpadPgUp::MouseMove    1,   -1, 2, R
    NumpadPgDn::MouseMove    1,    1, 2, R

    +NumpadLeft::MouseMove  -10,   0, 2, R
    +NumpadRight::MouseMove  10,   0, 2, R
    +NumpadUp::MouseMove      0, -10, 2, R
    +NumpadDown::MouseMove    0,  10, 2, R

    +NumpadHome::MouseMove   -10,   -10, 2, R
    +NumpadEnd::MouseMove    -10,    10, 2, R
    +NumpadPgUp::MouseMove    10,   -10, 2, R
    +NumpadPgDn::MouseMove    10,    10, 2, R    
}

 
;----------------------------------------------------------------------------------------------------------------------
; KEYS ASSIGNMENTS 
;----------------------------------------------------------------------------------------------------------------------
; CORE FEATURES
;----------------------------------------------------------------------------------------------------------------------
; for #Include, Q_languages.ahk ---------------------------------------------------------------------------------------
~RShift:: SetFirstLanguage()  ; Always switch to the first language in the list
~RCtrl:: SetSecondLanguage()  ; Switch to the second language. Long press to select(switch) second one.
~RAlt:: ShowLanguageToolTip() ; just show tooltip with current language

; RAlt + punctuation --------------------------------------------------------------------------------------------------
NumpadDot::.
NumpadDel::.
<^>!,::Send {},
<^>!.::Send {}.
<^>!/::Send {}/
<^>!;::Send {};
<^>!'::Send {}'
+<^>!,::Send {}<
+<^>!.::Send {}>
+<^>!/::Send {}?
+<^>!;::Send {}:
+<^>!'::Send {}"

;----------------------------------------------------------------------------------------------------------------------
; MULTIMEDIA CONTROL: 
; Scroll the mouse wheel when it over taskbar - change volume.
; With Alt - change volume by step 5.
; Whith Shift - switching tracks.
;----------------------------------------------------------------------------------------------------------------------
; WARNING! BECAUSE OF #If DIRECTIVE THIS CODE MUST(!) BE THE LAST IN THE FILE !!!
;----------------------------------------------------------------------------------------------------------------------
#If MouseIsOver("ahk_class Shell_TrayWnd")
  Alt & WheelUp::ChangeVolumeBy(1)
  Alt & WheelDown::ChangeVolumeBy(-1)
  WheelUp::ChangeVolumeBy(5)
  WheelDown::ChangeVolumeBy(-5)
  Shift & WheelUp::Send {Media_Next}
  Shift & WheelDown::Send {Media_Prev}
  MButton::Send {Media_Play_Pause}
#If
MouseIsOver(WinTitle)
{  
    MouseGetPos,,, Win
    Return WinExist(WinTitle . " ahk_id " . Win)
}

ChangeVolumeBy(inc)
{
	SoundGet, vol		
	vol := Min(Max(0,vol+inc),100)
	SoundSet, vol
	bar := "" 
    rep := Floor(vol/3)
	Loop, %rep%
    	bar .= "."
   	bar .= "||"
    rep := 33-rep
	Loop, %rep%
    	bar .= "."
	ToolTip % Format(Chr(0x1F50A) . " {1:s}  {2:d}", bar, vol) 
	SetTimer, RemoveToolTip, -1000
}
RemoveToolTip() {
  ToolTip
}

