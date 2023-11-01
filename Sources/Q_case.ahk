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


CaseUpper() {
    ChangeTextCase("U")
}
CaseLower() {
    ChangeTextCase("L")
}
CaseInvert() {
    ChangeTextCase("I")
}
CaseCamel() {
    ChangeTextCase("T") ; CamelCase (that in AHK named as TitleCase)
}

ChangeTextCase(Type)  
{
    ; temporary disble clipboard monitoring if it was set
    IniRead, hk, Q.ini, Clipboard
    if (hk != "ERROR" and hk!="") 
       OnClipboardChange("ClipboardChanged", 0) 
     
    originalClipboard := ClipboardAll ; Save the current clipboard content

    ; Check selected text for transliterating into clipboard
    Clipboard = ; Empty the clipboard (important for consistency)
    Send ^{Ins} 
	ClipWait, 1 

   ; if nothing selected - try to get one word left from the cursor
   if ErrorLevel {
      Send ^+{Left} ; select word left
      Send ^{Ins} ; copy it
      ClipWait, 1 
      if ErrorLevel ; still nothing copied - exiting
         goto exiting_textcase
   }

    
    ; Apply the specified text case change operation
    if (Type = "U") 
        StringUpper Clipboard, Clipboard 
    else if (Type = "L") 
        StringLower Clipboard, Clipboard 
    else if (Type = "I") 
    {
        invertedText := ""
        Loop, Parse, Clipboard
        {
            char := A_LoopField
            if char is Upper
                StringLower char, char
            else if char is Lower
                StringUpper char, char
            invertedText .= char
        }
        Clipboard := invertedText
    }
    else 
        StringLower Clipboard, Clipboard, T 
    
    Send +{Ins}
		SLEEP, 200 ; give some time to 'type' text  

    exiting_textcase:
    ; restore temporary disble clipboard monitoring if it was set
    if (hk != "ERROR" and hk!="") 
        OnClipboardChange("ClipboardChanged") 

    Clipboard := originalClipboard ; restore original clipboard
}



