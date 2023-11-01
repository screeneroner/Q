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


clipboardHistory := [] 
;CollectClipboard := true
;MenuColunmsCnt   := 3
;ItemsInColunm:= 30
ClipboardHistoryLen := 30
CollectClipboard := True

; Intercept clipboard changes only if this explicitly set in the configuration file
IniRead, hk, Q.ini, Clipboard
if (hk != "ERROR" and hk!="") 
    OnClipboardChange("ClipboardChanged") 

; ----------------------------------------------------------------------------------------------------
; ClipboardChanged: Monitors changes in the clipboard content and manages clipboard history.
; In history will be saved the only text-type copies.
; ----------------------------------------------------------------------------------------------------
ClipboardChanged(Type) {
    global ClipboardHistory, ClipboardHistoryLen, CollectClipboard

    if (CollectClipboard) {    
        ; Get the current clipboard content
        currentClipboard := Clipboard

        ; Insert the current clipboard content at the beginning of clipboardHistory
        clipboardHistory.InsertAt(1, currentClipboard)

        ; Loop in reverse order to remove duplicate entries of the first clipboard content (if any)
        Loop, % clipboardHistory.MaxIndex() - 1 {
            index := clipboardHistory.MaxIndex() - A_Index + 1
            if (index > 1 && clipboardHistory[index] = currentClipboard) 
                clipboardHistory.Remove(index)
        }

        ; Maintain clipboard history within the defined length
        if (clipboardHistory.MaxIndex() > ClipboardHistoryLen) { 
            clipboardHistory.Remove((ClipboardHistoryLen+1))
        }
    }
}




; ----------------------------------------------------------------------------------------------------
; ShowClipboardHistoryMenu: Creates and displays a context menu with clipboard history items to select one and insert.
; At the end of the history items there will be the trigger to turn on and off clipboard history monitoring.
; ----------------------------------------------------------------------------------------------------
ShowClipboardHistoryMenu() {
    global clipboardHistory, Collectclipboard, ClipboardHistoryLen

    IniRead, hk, Q.ini, Clipboard, ItemVisibleLength
    ItemVisibleLength := (hk != "ERROR" and hk!="") ? hk : 30
    IniRead, hk, Q.ini, Clipboard, Colunms
    Colunms := (hk != "ERROR" and hk!="") ? hk : 1
    IniRead, hk, Q.ini, Clipboard, ItemsInColunm
    ItemsInColunm := (hk != "ERROR" and hk!="") ? hk : 30
    ClipboardHistoryLen := ItemsInColunm * Colunms - 3  ; -3 for separator and monitoring toggle checkbox and clear history item

    Menu, ClipboardMenu, Add
    Menu, ClipboardMenu, DeleteAll ; Clear the menu
    
    items := {}
    Loop, % clipboardHistory.MaxIndex() {
        OriginalItem := Trim(clipboardHistory[A_Index])
        TruncatedItem := SubStr(OriginalItem, 1, ItemVisibleLength)
        
        NewMenuItem := (StrLen(OriginalItem) > 60) ? TruncatedItem . "..." : TruncatedItem
                
        NewMenuItem := StrReplace(NewMenuItem,"`n", " | ", 0, -1)
        NewMenuItem := StrReplace(NewMenuItem,"`t", " ", 0, -1)
        NewMenuItem := StrReplace(NewMenuItem,"  ", " ", 0, -1) 
        NewMenuItem := StrReplace(NewMenuItem,"&", "&&&", 0, -1)  ; Ampersands require double-escaping.
                
        if !items.HasKey(NewMenuItem) {
            items[NewMenuItem] := 0
        } else {
            items[NewMenuItem]++
            NewMenuItem := NewMenuItem "`t'" items[NewMenuItem] ""
        }

        if (Trim(NewMenuItem, OmitChars := " `t`r`n") = "") ; no text - nothing to add (and create delimiter)
            NewMenuItem := "|"

        if (Mod(A_Index, ItemsInColunm) == 1) && (A_Index != 1)
            Menu, ClipboardMenu, Add, %NewMenuItem%, PasteClipboardHistoryItem, +BarBreak
        else 
            Menu, ClipboardMenu, Add, %NewMenuItem%, PasteClipboardHistoryItem
    }
    
		
    ; Add the menu item with toggle action
    Menu, ClipboardMenu, Add
    Menu, ClipboardMenu, Add, Collect Clipboard History, ToggleCollectClipboard
    Menu, ClipboardMenu, Add, Clear Clipboard History, ClearClipboardHistory

    ; Check or uncheck based on the value of CollectClipboard
    if (CollectClipboard) 
        Menu, ClipboardMenu, Check, Collect Clipboard History
    else 
        Menu, ClipboardMenu, UnCheck, Collect Clipboard History

    Menu, ClipboardMenu, Show, %A_CaretX%, %A_CaretY% ; Show the menu at the current caret position
}

ToggleCollectClipboard() {
    global CollectClipboard
    CollectClipboard := !CollectClipboard ; Toggle the value
}

ClearClipboardHistory() {
    global clipboardHistory
    clipboardHistory := [] 
}



; ----------------------------------------------------------------------------------------------------
; PasteClipboardHistoryItem: Inserts a selected clipboard history item into the clipboard.
; To delete existing item from the history (like accidentally copied password - press Shift+Enter
;
; There only short header of the copied text will be shown in the history menu.
; If several item have exactly the same headers, they will be marked with (N) suffixes in menu
; ----------------------------------------------------------------------------------------------------
PasteClipboardHistoryItem() {
    global clipboardHistory
    ; Delete menu item if clicked with Shift key pressed
    if GetKeyState("Shift", "P") {
        clipboardHistory.RemoveAt(A_ThisMenuItemPos)
        Menu, ClipboardMenu, Delete, %A_ThisMenuItem%
        ShowClipboardHistoryMenu()
        return
    }

    Clipboard := clipboardHistory[A_ThisMenuItemPos]
    Send +{Ins} 
    Sleep, 500 ; give some time to finish text inserting
}
