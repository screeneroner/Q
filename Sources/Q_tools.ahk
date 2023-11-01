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


;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: ShowColor
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Retrieves the color of the pixel under the mouse cursor and displays it as either a hexadecimal or decimal value.
;
; PARAMETERS:
; - copymode (boolean): Indicates whether to copy the color value to the clipboard (true) or not (false).
; - hex_mode (boolean): Indicates whether to display the color in hexadecimal format (true) or decimal format (false).
;----------------------------------------------------------------------------------------------------------------------
ColorShowHTML() {
	ShowColor(true, false)    ; show HEX HTML color under cursor
}
ColorShowRGB() {
	ShowColor(false, false)    ; show RGB color under cursor
}
ColorCopyHTML() {
	ShowColor(true, true)  ; copy HEX HTML color under cursor
}
ColorCopyRGB() {
	ShowColor(false, true)  ; copy RGB color under cursor
}

ShowColor(hex_mode, copymode)  
{
	MouseGetPos, MouseX, MouseY
	PixelGetColor, color, %MouseX%, %MouseY%
	StringMid, R, color, 7,2
	StringMid, G, color, 5,2
	StringMid, B, color, 3,2
	RD := hex2Dec(R)
	GD := hex2Dec(G)
	BD := hex2Dec(B)
	if hex_mode {
    	color = %R%%G%%B% 
		ToolTip, #%color%
	} else {
    	color = %RD%,%GD%,%BD% 
		ToolTip, RGB(%color%)
	}
	
	KeyWait, LButton 
	if copymode 
	{	
		clipboard = %color%
		ToolTip Copied
		Sleep 1000
	}
	ToolTip
	return
}
hex2Dec(str){
    static _0:=0,_1:=1,_2:=2,_3:=3,_4:=4,_5:=5,_6:=6,_7:=7,_8:=8,_9:=9,_a:=10,_b:=11,_c:=12,_d:=13,_e:=14,_f:=15
    str:=trim(str,"#0x `t`n`r"),   len := StrLen(str),  ret:=0
    Loop,Parse,str
      ret += _%A_LoopField%*(16**(len-A_Index))
    return ret
}
	
;----------------------------------------------------------------------------------------------------------------------
; Send color code from clipboard to the standard Color picker dialog
;----------------------------------------------------------------------------------------------------------------------
; This command is for using in standard color selector dialog.
; It assumes that clipboard contains color code in HTML or RGB formats.
; To 'paste' color from clipboard into color selector - place cursor in the first
; field (Red) and press Win+Insert.
; 
; If the clipboard text starts with "#", it is assumed to be in "#RRGGBB" format,
; where RR, GG, and BB are hexadecimal color codes. These codes are converted to
; decimal and the resulting values are sent as keystrokes to the keyboard after
; selecting the content of the clipboard with Ctrl+A.
; 
; If the clipboard text doesn't start with "#", commas in the text are replaced
; with the Tab key. The modified text is then sent to the keyboard after selecting
; the content of the clipboard with Ctrl+A.
;----------------------------------------------------------------------------------------------------------------------
ColorPaste() { ; 'paste' color into 3 RGB fiedls of the standard windows color picker dialog
    ; Retrieve the text from clipboard
    Clipboard := StrReplace(Clipboard, " ", "")
    Clipboard := StrReplace(Clipboard, "#", "")
    
    ; Check if text don't contains coma and exactly 6 chars length
    if (InStr(Clipboard, ",") <= 0 and StrLen(Trim(Clipboard)) = 6) {
        ; Extract and convert RGB values from hexadecimal to decimal
        Clipboard := hex2Dec(SubStr(Clipboard, 1, 2)) . "," . hex2Dec(SubStr(Clipboard, 3, 2)) . "," . hex2Dec(SubStr(Clipboard, 5, 2))
    }

    ; Replace commas with Tab key
    OutputText := StrReplace(Clipboard, ",", "{Tab}")
    
    ; Send Ctrl+A and the processed text
    Send, ^a
    SendInput, %OutputText%    
}


	
;----------------------------------------------------------------------------------------------------------------------
; Stamps: Generates timestamp menu with various date and time formats.
; Months names are generating in the currently selected language.
;----------------------------------------------------------------------------------------------------------------------
Stamps() {
	Now := A_Now
	Menu, StampsMenu, Add
	Menu, StampsMenu, Delete

	Menu, StampsMenu, Add, % FormatDate(Now, "yyyyMM"),  StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyyMMdd"),  StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyyMMddHHmm"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyyMMddHHmmss"), StampsMenuSelect
	Menu, StampsMenu, Add
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyyMMdd-HHmm"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyyMMdd-HHmmss"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyyMMdd_HHmm"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyyMMdd_HHmmss"), StampsMenuSelect

	Menu, StampsMenu, Add, % FormatDate(Now, "yyyy-MM"), StampsMenuSelect, +BarBreak
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyy-MM-dd"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyy-MM-dd-HH-mm"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyy-MM-dd-HH-mm-ss"), StampsMenuSelect
	Menu, StampsMenu, Add
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyy_MM"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyy_MM_dd"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyy_MM_dd_HH_mm"), StampsMenuSelect
	Menu, StampsMenu, Add, % FormatDate(Now, "yyyy_MM_dd_HH_mm_ss"), StampsMenuSelect

	Menu, StampsMenu, Add, % NowLocal("MMMM ") . NowLocal("dd"),  StampsMenuSelect, +BarBreak
	Menu, StampsMenu, Add, % NowLocal("dd MMMM"),  StampsMenuSelect, 
	Menu, StampsMenu, Add, % NowLocal("dddd, MMMM ") . NowLocal("dd"),  StampsMenuSelect
	Menu, StampsMenu, Add, % NowLocal("dddd, dd MMMM"),  StampsMenuSelect 
	Menu, StampsMenu, Add
	Menu, StampsMenu, Add, % NowLocal("MMMM ") . NowLocal("dd, ") . NowLocal("yyyy"),  StampsMenuSelect
	Menu, StampsMenu, Add, % NowLocal("dd MMMM yyyy"),  StampsMenuSelect 
	Menu, StampsMenu, Add, % NowLocal("dddd, MMMM ") . NowLocal("dd, ") . NowLocal("yyyy"),  StampsMenuSelect
	Menu, StampsMenu, Add, % NowLocal("dddd, dd MMMM yyyy"),  StampsMenuSelect 

    Menu, StampsMenu, Show
    Return
}
FormatDate(DateObj, Format) {
    FormatTime, FormattedDate, % DateObj, % Format
    return FormattedDate
}
StampsMenuSelect() {
    FormattedStamp := A_ThisMenuItem
    SendInput % FormattedStamp
}
;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: GetActiveWindowLanguageCode
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: This function retrieves the country code associated with the language of the currently active window.
;
; PARAMETERS: None
;
; RETURNS: A string representing the country code of the language associated with the active window.
;----------------------------------------------------------------------------------------------------------------------
GetActiveWindowLanguageCode() {
	lng := GetLanguages()
	active_LCID := GetActiveWindowLid() 
	Loop, % lng.MaxIndex() {
        if (lng[A_Index].LCID = active_LCID) {
            return lng[A_Index].LanguageCode
        }
    }    
    return lng[1].LanguageCode ; Return first language if not found
}
;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: NowLocal
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Retrieves the current date and time in the locale of the active window and formats it based on the specified format.
;
; PARAMETERS:
; - Format (string): Optional. The format for displaying the date and time (default is "MMMM").
;
; RETURNS:
; - The formatted date and time as a string.
; - False if formatting was unsuccessful.
;----------------------------------------------------------------------------------------------------------------------
NowLocal(Format := "MMMM")
{
    ; Get the locale name of the active window.
    c_code := GetActiveWindowLanguageCode()
    
    ; Get the current date and time.
    Stamp := A_Now

    ; Prepare the SystemTime structure to hold date and time components.
    VarSetCapacity(SystemTime, 16, 0)
    NumPut(SubStr(Stamp,  1, 4), SystemTime,  0, "ushort") ; Year
    NumPut(SubStr(Stamp,  5, 2), SystemTime,  2, "ushort") ; Month
    NumPut(SubStr(Stamp,  7, 2), SystemTime,  6, "ushort") ; Day
    NumPut(SubStr(Stamp,  9, 2), SystemTime,  8, "ushort") ; Hour
    NumPut(SubStr(Stamp, 11, 2), SystemTime, 10, "ushort") ; Minutes
    NumPut(SubStr(Stamp, 13, 2), SystemTime, 12, "ushort") ; Seconds

    ; Format the date using the specified locale and format.
    if (Size := DllCall("GetDateFormatEx", "str", c_code, "uint", 0, "ptr", &SystemTime, "ptr", (Format ? &Format : 0), "ptr", 0, "int", 0, "ptr", 0))
    {
        ; Create a buffer to hold the formatted date string.
        VarSetCapacity(DateStr, Size << !!A_IsUnicode, 0)
        
        ; Populate the DateStr buffer with the formatted date string.
        if (DllCall("GetDateFormatEx", "str", c_code, "uint", 0, "ptr", &SystemTime, "ptr", (Format ? &Format : 0), "str", DateStr, "int", Size, "ptr", 0))
        {
            ; Convert the date string to lowercase for consistency.
            StringLower DateStr, DateStr, T
            
            ; Return the formatted date string.
            return DateStr
        }
    }
    
    ; Return false if formatting was unsuccessful.
    return false
}

;-----------------------------------------------------------------------------
; --- Paste from clipboard without formatting 
;-----------------------------------------------------------------------------
PastePlainText() {
	originalClipboard := ClipboardAll ; Save the current clipboard content	
	ClipBoard = %ClipBoard%           ; Convert to text
	StringReplace, ClipBoard, ClipBoard, `r, , All
	Send +{Ins} 
	Sleep 250                         ; Don't change clipboard while it is pasting! (Sleep > 0)
	ClipBoard := originalClipboard    ; Restore original ClipBoard
}

RemoveClipboardFormatting() {
    Clipboard = %Clipboard%  ; Convert to text
}

