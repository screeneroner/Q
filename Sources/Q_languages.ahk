;----------------------------------------------------------------------------------------------------------------------
; This program is free software: you can redistribute it and/or modify  it under the terms of the 
; version 3 GNU General Public License as published by the Free Software Foundation.
; 
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY without even 
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
; LCIDToLocaleName: Converts an LCID (Locale Identifier) to its corresponding locale name.
; LCID: The LCID to convert.
; Flags (optional): Additional flags (default is 0).
; Returns the locale name as a UTF-16 string.
;----------------------------------------------------------------------------------------------------------------------
LCIDToLocaleName(LCID, Flags := 0) {
    VarSetCapacity(out, 100)
    DllCall("LCIDToLocaleName", "UInt", LCID, "Ptr", &out, "UInt", 100, "UInt", Flags)
    return StrGet(&out, "UTF-16")
}

;----------------------------------------------------------------------------------------------------------------------
; LCIDToLanguageName: Retrieves the language name associated with an LCID.
; LCID: The LCID to retrieve the language name for.
; Returns the language name as a UTF-16 string.
;----------------------------------------------------------------------------------------------------------------------
LCIDToLanguageName(LCID) {
    VarSetCapacity(out, 100)
    DllCall("kernel32\GetLocaleInfoW", "UInt", LCID, "UInt", 0x2, "Ptr", &out, "Int", 100)
    return StrGet(&out, "UTF-16")
}

;----------------------------------------------------------------------------------------------------------------------
; GetLanguages: Retrieves a list of languages and associated information for all installed keyboards.
; Returns an array of objects, where each object contains the following properties:
;   - LCID: The LCID of the language.
;   - LanguageCode: The language code (e.g., "en").
;   - CountryCode: The country code (e.g., "US").
;   - LanguageName: The language name (e.g., "English").
;   - CountryName: The country name (e.g., "United States").
;----------------------------------------------------------------------------------------------------------------------
GetLanguages() {    
    lng := []
		
    kbdl := DllCall("GetKeyboardLayoutList", "UInt", 0, "Ptr", 0)
    VarSetCapacity(List, A_PtrSize * kbdl)
    kbdl := DllCall("GetKeyboardLayoutList", "UInt", kbdl, "Str", List)
    
    Loop % kbdl {
        LCID := NumGet(List, A_PtrSize * (A_Index - 1)) & 0xFFFF
        LocaleID := LCIDToLocaleName(LCID)
        LanguageID := LCIDToLanguageName(LCID)
        
        SplitPos := InStr(LocaleID, "-")
        LanguageCode := SplitPos ? SubStr(LocaleID, 1, SplitPos - 1) : LanguageCode
        CountryCode := SplitPos ? SubStr(LocaleID, SplitPos + 1, 2) : ""
        
        SplitPos := InStr(LanguageID, " (")
        LanguageName := SplitPos ? SubStr(LanguageID, 1, SplitPos - 1) : LanguageID
        CountryName := SplitPos ? SubStr(LanguageID, SplitPos + 2, -1) : ""

        lng.Push({LCID: LCID, LanguageCode: LanguageCode, CountryCode: CountryCode, LanguageName: LanguageName, CountryName: CountryName})

    }
    
    return lng
}

;----------------------------------------------------------------------------------------------------------------------
; GetActiveWindowLanguage: Retrieves the language and associated information for the active window.
; Returns an object with the following properties:
;   - LCID: The LCID of the language.
;   - LanguageCode: The language code (e.g., "en").
;   - CountryCode: The country code (e.g., "US").
;   - LanguageName: The language name (e.g., "English").
;   - CountryName: The country name (e.g., "United States").
;----------------------------------------------------------------------------------------------------------------------
GetActiveWindowLanguage() {        
    DetectHiddenWindows, On

    Win := DllCall("GetForegroundWindow")
    Pid := DllCall("GetWindowThreadProcessId", "UInt", Win, "Ptr", 0)
    LCID := DllCall("GetKeyboardLayout", "UInt", Pid) & 0x0000FFFF ; Strip high bytes

	LocaleID := LCIDToLocaleName(LCID)
	LanguageID := LCIDToLanguageName(LCID)
		
	SplitPos := InStr(LocaleID, "-")
	LanguageCode := SplitPos ? SubStr(LocaleID, 1, SplitPos - 1) : LanguageCode
	CountryCode := SplitPos ? SubStr(LocaleID, SplitPos + 1, 2) : ""
		
	SplitPos := InStr(LanguageID, " (")
	LanguageName := SplitPos ? SubStr(LanguageID, 1, SplitPos - 1) : LanguageID
	CountryName := SplitPos ? SubStr(LanguageID, SplitPos + 2, -1) : ""

    ; Find the language's id from the full list
    allLanguages := GetLanguages()
    id := 0 
    Loop % allLanguages.Length() {
        if (allLanguages[A_Index].LCID = LCID) {
            id := A_Index
            break
        }
    }        

    return {id: id, LCID: LCID, LanguageCode: LanguageCode, CountryCode: CountryCode, LanguageName: LanguageName, CountryName: CountryName}
}

;----------------------------------------------------------------------------------------------------------------------
; SetLanguage: Set the language for the active control/window/entire system - whatever will work.
; The all cases are required because some applications may have a veeery unusual input control with a strange behavior,
; and that is why we will try to switch language trying all possible way to do it one-by-one.
;   - id: The id of the language we want to switch to.
;----------------------------------------------------------------------------------------------------------------------
SetLanguage(id) {
    ; Ensure 'id' is within valid bounds
    lng := GetLanguages() ; Retrieve the list of installed languages   
    if (id < 0)
        id := 0
    if (id > lng.Length())
        id := lng.Length()
    if (GetActiveWindowLanguage().id = id) {
        ShowLanguageToolTip()
        return
    }

    ; Retrieve the LCID for the current and target locale
    initialLCID := GetActiveWindowLanguage().LCID    
    targetLCID := lng[id].LCID

    ; Load the new keyboard layout associated with the target locale
    Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", targetLCID), "Int", 0)


    ; 1) Send language switch messages to the control with focus
    DetectHiddenWindows, On
    WinExist("A")
    ControlGetFocus, CtrlInFocus
    SendMessage, 0x50, 0, %Lan%, %CtrlInFocus%
    SendMessage, 0x51, 0, %Lan%, %CtrlInFocus%

    ; 2) Send language switch messages to the active window
    WinGet, activeWindow, IDLast, A
    SendMessage 0x50, 0, %Lan%, , % "ahk_id " activeWindow ; Request to change input language in window
    SendMessage 0x51, 0, %Lan%, , % "ahk_id " activeWindow ; Signal that input language was changed

    ; 3) Send language switch messages to the entire system
    DllCall("ActivateKeyboardLayout", "UInt", Lan, "UInt", 0)

    ; 4) Change the default input language using SystemParametersInfo
    VarSetCapacity(Lan%targetLCID%, 4, 0)
    NumPut(targetLCID, Lan%targetLCID%) 
    DllCall("SystemParametersInfo", "UInt", 0x005A, "UInt", 0, "UPtr", &Lan%targetLCID%, "UInt", 2)
    
    /* THIS MAY BE HELPFUL IN SOME CASES, HOWEVER, IT ALSO MAY RAISE SOME ISSUES, SO - THIS PART IS COMMENTED!
    ; last attempt - send system language switching hotkey
    if (GetActiveWindowLanguage().id != id) { 
        ; 5) Send buitin languages swithcing hotkeys Win+Space   
        switchKey := "{LWin Down}{Space}{LWin UP}" 

        SetKeyDelay, -1 ; Requred to prevent appearing of the system popup with languages list !!!
        while (GetActiveWindowLanguage().LCID != targetLCID) {
            Send %switchKey%
            Sleep 450 ; this must be less then KeyWait, RControl, T 0.5 in SetSecondLanguge() !!!
            if (GetActiveWindowLanguage().LCID = initialLCID && initialLCID != targetLCID)
                break
        }
    }
    */
    ShowLanguageToolTip()
}

; Show actual language name of the active window as a short tolltip at the caret position
ShowLanguageToolTip() {
    hint := GetActiveWindowLanguage().LanguageName
    Tooltip, %hint%, %A_CaretX%, %A_CaretY%
    sleep, 10
    while (GetKeyState("RShift", "P") or GetKeyState("RControl", "P") or GetKeyState("RAlt", "P"))
        sleep, 10
    Sleep, 300 ; Duration to display the tooltip
    Tooltip ; Hide the tooltip
}

;----------------------------------------------------------------------------------------------------------------------
; GetActiveWindowLid: Retrieves the Language ID (LID) of the active window's keyboard layout.
;----------------------------------------------------------------------------------------------------------------------
GetActiveWindowLid() {
    SetFormat, IntegerFast, Hex
    Win := DllCall("GetForegroundWindow")
    Pid := DllCall("GetWindowThreadProcessId", "UInt", Win, "Ptr", 0)
    Lid := DllCall("GetKeyboardLayout", "UInt", Pid)
    Lid := Lid & 0x0000FFFF . "" ; Strip high bytes
    SetFormat, IntegerFast, Dec
    return Lid 
}

;----------------------------------------------------------------------------------------------------------------------
; ShowLanguageSelectorMenu: Displays a context menu with language options to switch to the second
; language defined in the language definition file.
;----------------------------------------------------------------------------------------------------------------------
global SelectedIndex ; direct init here is not working in some cases, so, ...
SelectedIndex := 0   ; ...assign it explicitly
ShowLanguageSelectorMenu() {
    global SelectedIndex
    lng := GetLanguages()
    Loop, % lng.Length()-1
        Menu, LangMenu, Add, % lng[A_Index + 1].LanguageName, SaveSelectedIndex

    Menu, LangMenu, Show, %A_CaretX%, %A_CaretY% ; Show the menu at the current caret position
    Menu, LangMenu, DeleteAll
    return SelectedIndex+1 ; Index of the selected menu item (+1 to match lng array index). 1 - means ESC pressed
}

SaveSelectedIndex() {
    global SelectedIndex
    SelectedIndex := A_ThisMenuItemPos
}


SetFirstLanguage() {
    RShiftPressed := GetKeyState("RShift", "P")
    SetLanguage(1)
    if (RShiftPressed)
        KeyWait, RShift ; Wait until long pressed RShift will be actually released
} 

global second_lid ; direct init here is not working in some cases, so, ...
second_lid := 2   ; ...assign it explicitly
SetSecondLanguage() {
    global second_lid

    lng := GetLanguages()
    lng_cnt := lng.Length()

    if (lng_cnt > 1) { ; we have something to switch
        KeyWait, RControl, T 0.5
        if ErrorLevel { ; long press - set NEW second language
            ; KeyWait, RControl ; Wait HEAR until long pressed RControl will be actually released to prevent appearing system languages popup

            if (lng_cnt = 2) 
                second_lid := 2 ; there only 2 languages - switch to second
            else if (lng_cnt = 3) 
            {
                ;second_lid :=  ShowLanguageSelectorMenu() ; to debug menu for 3 languages case 
                second_lid :=  GetActiveWindowLid() = lng[2].LCID ? 3 : 2 
            }
            else {
                second_lid := ShowLanguageSelectorMenu()
            }
        }
        SetLanguage(second_lid) ; actually set new language
        KeyWait, RControl ; Wait until long pressed RControl will be actually released
    }
}    

