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
; FUNCTION: Transliterate
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Transliterates text from one character set to another based on provided indices.
; Transliterating chars must be typed in the transliterating.txt file, one line per language
; Lines order must follow language order in the system, and contain so many lines,
; as many languages installed.
;
; PARAMETERS:
; - i_from (integer): Number of the character set line to transliterate from.
; - i_to (integer): Number of the character set line to transliterate to.
;
; RETURNS: None.
;----------------------------------------------------------------------------------------------------------------------
Transliterate(i_from, i_to)
{
    ; `1234567890-=qwertyuiop[]\asdfghjkl;'zxcvbnm,./~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?
    global second_lid
    originalClipboard := ClipboardAll ; Save the current clipboard content

    ; 1) get transliterating strings
    t_lines := [] 
    line := 1
    while true 
    {
        IniRead, l_chars, Q.ini, Transliterating, %line%
        if (l_chars != "" and l_chars != "ERROR")
        {
            t_lines.Push(l_chars)
            l_chars := ""
        }
        else
            break

        line++
    }


    ; 2) Check if items present and all items in 't_lines' have the same length.
    if (t_lines.Length() < 2)
    {
        MsgBox, 16, ERROR IN TRANSLITERATION DATA, The [Transliteration] section is absent in the Q.ini`ror have incorrect tranliterating data set., 
        return
    }
    itemLength := StrLen(t_lines[1])  ; Get the length of the first item.
    for i, item in t_lines
    {
        if ((item != "") and (StrLen(item) != itemLength)) ; item != "" to skip possible last empty line
        {
            MsgBox, 16, ERROR IN TRANSLITERATION DATA, The [Transliteration] section lines must have the same length, 
            return
        }
    }

    ; 3) Check selected text for transliterating into clipboard
    ; temporary disble clipboard monitoring if it was set
    IniRead, hk, Q.ini, Clipboard
    if (hk != "ERROR" and hk!="") 
       OnClipboardChange("ClipboardChanged", 0) 
     
    Clipboard = ; Empty the clipboard (important for consistency)
    Send ^{Ins} 
	ClipWait, 1 

    ; if nothing selected - try to get one word left from the cursor
    if ErrorLevel {
        Send ^+{Left} ; select word left
        Send ^{Ins} ; copy it
        ClipWait, 1 
        if ErrorLevel ; still nothing copied - exiting
        goto exiting_transliterating
    }

    
    ; 4) Tranliterate - replace characters from the i_from line with the corresponding character from i_to one.
    ; If char was not found in i_from - keep the original char.
    wrong_text := Clipboard ; Assign the clipboard content to the variable
    transliterated_text := ""
    Loop, Parse, wrong_text
        transliterated_text .= (i := InStr(t_lines[i_from], A_LoopField,True)) ? SubStr(t_lines[i_to], i, 1) : A_LoopField

    ; 6) Replace selected text by pasting it via clipboard (it's faster than just typing)
    SetLanguage(i_to)  ; to make consistent spell check and ...
    if (i_to > 1) ; switch second language lid
        second_lid := i_to
    Clipboard := transliterated_text ; Set the translated text to the clipboard
    Send {Del}+{Ins}   ; Delete selected text and Send a paste command (Shift+Insert)
    SLEEP, 200 ; give some time to 'type' text  
    
    exiting_transliterating:
    ; restore temporary disble clipboard monitoring if it was set
    if (hk != "ERROR" and hk!="") 
        OnClipboardChange("ClipboardChanged") 

	Clipboard := originalClipboard ; restore original clipboard
}

;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: TransliterateFirstSecond
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Checks if transliteration is possible and performs it from the first language to the second.
;----------------------------------------------------------------------------------------------------------------------
TransliterateFirstSecond()
{
    lng := GetLanguages()
    active_LCID := GetActiveWindowLid() 
    i_from := (lng[1].LCID = active_LCID) ? 1 : second_lid
    i_to   := (lng[1].LCID = active_LCID) ? second_lid : 1
    Transliterate(i_from, i_to)
}

;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: TransliterateSeconds
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Checks if transliteration is possible and performs it from the alternate (second) language to another.
;
; PARAMETERS: None.
;
; RETURNS: None.
;----------------------------------------------------------------------------------------------------------------------
TransliterateSeconds()
{
    lng := GetLanguages()
    if (lng.Length() = 3) {
        i_from := second_lid
        i_to   := (lng[2].LCID = GetActiveWindowLid()) ? 3 : 2
        Transliterate(i_from, i_to)    
    }
    if (lng.Length() > 3) {
        i_from := second_lid
        i_to := ShowLanguageSelectorMenu()
        Transliterate(i_from, i_to)    
    }
}

