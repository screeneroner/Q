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
; FUNCTION: debug
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Displays debugging messages as tooltips or message boxes.
;
; PARAMETERS:
; - msg (string): The debugging message to display.
; - xpos (float): Optional. The x-coordinate position for the tooltip (0-1).
; - ypos (float): Optional. The y-coordinate position for the tooltip (0-1).
; - wait_sec (integer): Optional. The duration to display the tooltip (seconds).
;   - If wait_sec is 0, the tooltip will be displayed indefinitely until cleared.
;   - If wait_sec is positive, the tooltip will be displayed for that duration (in seconds).
;   - If wait_sec is negative, a message box will be displayed, and the tooltip will be cleared when the message box is closed.
;
; RETURNS: None.
;----------------------------------------------------------------------------------------------------------------------
debug(msg, xpos := 0, ypos := 1, wait_sec := -1) {
    CoordMode, ToolTip, Screen
    if (msg = "") 
        ToolTip
    else {
        ToolTip, %msg%, (A_ScreenWidth) * xpos, (A_ScreenHeight) * ypos
        if (wait_sec > 0) {
            Sleep, % (wait_sec * 1000)
            ToolTip
        }
        if (wait_sec < 0) {
            MsgBox, 0, DEBUG, Press OK to continue
            ToolTip
        }
    }
}
