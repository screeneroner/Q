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


; Initialize the variable
Global ENCRYPTYING_PASSWORD
global EditText
ENCRYPTION_PASSWORD := ""

DecryptText(Text, Pwd) {
    Output := ""
    Loop, Parse, Text
        Output .= Chr((Asc(A_LoopField) - 0xAC00) ^ Asc(SubStr(Pwd, (Pwd_Pos := (Pwd_Pos >= StrLen(Pwd)) ? 1 : Pwd_Pos + 1), 1)))
    return Output
}

EncryptText(Text, Pwd) {
    Output := ""
    Loop, Parse, Text
        Output .= Chr((Asc(A_LoopField) ^ Asc(SubStr(Pwd, (Pwd_Pos := (Pwd_Pos >= StrLen(Pwd)) ? 1 : Pwd_Pos + 1), 1))) + 0xAC00)
    return Output
}


Wallet_Prompt() 
{
	Global ENCRYPTYING_PASSWORD
    InputBox, input, Enter Password,  , hide , 180,100
		if ErrorLevel
			return
		else
			ENCRYPTYING_PASSWORD := input
}

Wallet_Lock()
{
	Global ENCRYPTYING_PASSWORD
	ENCRYPTYING_PASSWORD := ""
    Gui, Destroy
}

Wallet_Show() {
	Global ENCRYPTYING_PASSWORD
	if (ENCRYPTYING_PASSWORD = "")
		Wallet_Prompt()
	if (ENCRYPTYING_PASSWORD = "")
		return

	ShowPasswordsMenu()
}

Wallet_Edit() {
	Global ENCRYPTYING_PASSWORD
	global EditText

	if (ENCRYPTYING_PASSWORD = "")
		Wallet_Prompt()
	if (ENCRYPTYING_PASSWORD = "")
		return

	if FileExist("Q.wallet") {
		FileRead, fileContent, Q.wallet
		fileContent := DecryptText(fileContent, ENCRYPTYING_PASSWORD)
	} else { ; Create an empty file if it's absent		
		FileAppend, , Q.wallet
		fileContent := 
	}

	Gui, Add, Edit, vEditText w800 h600, %fileContent%
	Gui, Add, Button, gSaveToFile, Save
	Gui, Add, Button, gWallet_Lock, Lock Wallet
	Gui, Add, Button, gShowGuide, Guide
	Gui +Resize -MaximizeBox  
	; Modify font and font size of the EditText control
	Gui, Font, s10, Consolas  
	GuiControl, Font, EditText 
	Gui, Show		

    ; Get rid of selecting all text in edit box
    ControlFocus, Edit, ahk_id %GuiEditText%
    SendInput, ^{Home}
}

ShowGuide() {
	guide =
(
Use following syntax to create an item:

   label:value

where:
   – label - is text of the menu item
   – value - any string valid for Autohotkey's Send

If value starting with 'http', it's treated as a web address 
to be opened in browser. 

Items without ':' are shown as a disabled menu item	

Start line with: 
   '>' to start sub-menu
   '-' to create divider
   '<' to return to root menu after sub-menu

If label starting with the digit enclosed in [] 
this number will be treated as an icon number 
from the system library shell32.dll 
and displayed in front of the label text.

WARNING: ALL LABELS MUST BE UNIQUE!


EXAMPLE:
   Open My site:https://mysite.com/login
   My site login:user
   My site password:qwerty123
   >New sub-menu with icons
   [161]Sub-menu login:admin
   [245]Sub-menu password:qwerty
   [157]Sub-menu email:admin@company.com
   [166]Sub-menu autologin:user{Tab}qwerty{Tab}{Enter}
   -
   Item after divider:foo
   < returning to root menu
   Disabled text used like a title
   Google:https://google.com

)
	MsgBox, 64, Wallet Syntax Guide, %guide%
}

GuiSize()
{
	global EditText
	If A_EventInfo = 1  ; The window has been minimized.  No action needed.
    Return
  	; Otherwise, the window has been resized or maximized. Resize the controls to match.
    GuiControl Move, EditText, % "x0 y0 h" . (A_GuiHeight - 50) . " w" . (A_GuiWidth)
    GuiControl Move, Save, % "x10 y" . (A_GuiHeight - 40) . " h30 w100"
    GuiControl Move, Lock Wallet, % "x120 y" . (A_GuiHeight - 40) . " h30 w150"
    GuiControl Move, Guide, % "x280 y" . (A_GuiHeight - 40) . " h30 w100"
}

SaveToFile()
{
	global EditText
    Gui, Submit, NoHide ; Get the edited text
	
	;MsgBox % EditText
	EditText := EncryptText(EditText, ENCRYPTYING_PASSWORD) 
	;MsgBox % EditText
		
    FileDelete, Q.wallet ; Delete the existing Q.wallet file
    FileAppend, %EditText%, Q.wallet, CP65001 ; Write the edited text to Q.wallet
    Gui, Destroy
}

GuiClose() {
    Gui, Destroy
}









;--------------------------------------------------------------------------------------------------

InsertSelectedPassword(ItemName, ItemPos, MenuName)
{	
	;Global DecryptedContent
	global PasswordPairs

	;MenuItems := StrSplit(DecryptedContent,"`n")
	; Retrieve the corresponding value for the selected label
    SelectedLabel := A_ThisMenuItem
    SelectedValue := PasswordPairs[SelectedLabel]

	;p := InStr(MenuItems[ItemPos],":") 
	;m_value := SubStr(MenuItems[ItemPos],p+1) 	

	if SubStr(SelectedValue,1,4) = "http" ; it may be URI - pass it to cmd
	{
		Run, "%SelectedValue%"
	}
	else
		Send, %SelectedValue%
}


ShowPasswordsMenu()
{
    Global ENCRYPTYING_PASSWORD
    Global DecryptedContent
	global PasswordPairs

	if StrLen(ENCRYPTYING_PASSWORD) = 0 
		InputBox, ENCRYPTYING_PASSWORD, Enter Decrypting password, , hide, 220, 110 
	if StrLen(ENCRYPTYING_PASSWORD) = 0 
		return

	if FileExist("Q.wallet") {
		FileRead, EncryptedContent, Q.wallet
		DecryptedContent := DecryptText(EncryptedContent, ENCRYPTYING_PASSWORD)
	} else { ; Create an empty file if it's absent		
		FileAppend, , Q.wallet
		DecryptedContent := 
		Wallet_Edit()
		return
	}

    Variants := "root"
	
    Menu, %Variants%, Add
    Menu, %Variants%, DeleteAll

    ; Create an object to store pairs of label and value
    PasswordPairs := {}
    ; Create an array to store collected variant names
    VariantNames := []

    MenuItems := StrSplit(DecryptedContent,"`n")
    for index, element in MenuItems
    {
        if(Trim(element) = "") 
			continue
        else
        {
			; check for icon code. it should be decimal number enclosed into [] 
			; of the icon in the %SystemRoot%\System32\shell32.dll

			; Check if the label contains "[" and extract the icon code if present
			iconCode := ""
			label := element
			iconPos := InStr(element, "[")
			if (iconPos > 0)
			{
				iconEndPos := InStr(element, "]", iconPos)
				if (iconEndPos > 0)
				{
					iconCode := SubStr(element, iconPos + 1, iconEndPos - iconPos - 1) ; Extract the icon code
					element := SubStr(element, iconEndPos + 1) ; Extract the label without brackets
				}
			}
			if SubStr(element,1,1) = "<" {  ; this is returning to the root after submenu
				; Add collected variant names to the root menu before return
				for _, VariantName in VariantNames {
					Menu, root, Add, %VariantName%, :%VariantName%
				}
				Variants := "root"
				continue
			}
			if SubStr(element,1,1) = ">" {  ; this is start of new sub menu
				Variants := SubStr(element,2)					
				VariantNames.Push(Variants) ; Collect the variant names to add them later as submenus
				; clear possible tails from the previous menu building
				Menu, %Variants%, Add, Foo, InsertSelectedPassword
				Menu, %Variants%, DeleteAll
				continue
			}
			if (SubStr(element,1,1) = "-" ) { ; add divider
				Menu, %Variants%, Add
				continue
			}

			m_Url := 0
			p := InStr(element,":") 
			if p > 0 
			{
				m_label := SubStr(element,1,p-1) 
				m_value := SubStr(element,p+1)
				m_disabled := 0
				PasswordPairs[m_label] := m_value ; Store the pair in the object
			} 
			else  ; label without value - just decorative disbled text
			{
				m_label := element
				m_disabled := 1
			}
			if SubStr(m_value,1,4) = "http" 
                m_Url := 1

			m_label := SubStr(m_label,1,200) ; cut off too long for menu items texts

			Menu, %Variants%, Add, %m_label%, InsertSelectedPassword
			if (iconCode != "")
				Menu, %Variants%, Icon, %m_label%, %SystemRoot%\System32\shell32.dll, %iconCode%			

            if (m_Url = 1 and iconCode = "")
				Menu, %Variants%, Icon, %m_label%, %SystemRoot%\System32\shell32.dll,264
            if m_disabled = 1 ; label without value - just decorative disbled text
                Menu, %Variants%, Disable, %m_label% 
        }
    }

    ; Add collected variant names to the root menu
    for _, VariantName in VariantNames {
        Menu, root, Add, %VariantName%, :%VariantName%
    }

    ; Add Lock Passwords
    Menu, root, Add
    Menu, root, Add, Lock Wallet, Wallet_Lock
	Menu, root, Icon, Lock Wallet, %SystemRoot%\System32\shell32.dll,48
	Menu, root, Add, Edit Wallet, Wallet_Edit
	Menu, root, Icon, Edit Wallet, %SystemRoot%\System32\shell32.dll,271

    Menu, root, Show, %A_CaretX%, %A_CaretY%
    return
}

