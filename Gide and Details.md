
# What is Q ?
**Q is a Language Switcher and Keyboard Toolbox** for Windows with several **text processing tools** that you need if you want to get at least one of the benefits below.

## Q Benefits

### Basic Features

- MULTILINGUAL - you are **working with one primary/first language** (usually English) and **one or several additional languages** (typically several languages in a multilingual country or your native language and the language of the non-English country where you reside).

- TRANSLATOR - you are **not a fluent in all used languages** and sometime **need translator**.

- TRANSLITERATION - you are **frequently forget to switch languages** during typing and end up with gibberish on your screen after a long typing.

- TEXT CASE FIXING - you are accidentally, from time to time,  **toggling Caps Lock** on/off when you don't need it.

- CLIPBOARD EXTENDING - you are **frequently reuse the same pieces of text** from various places and find it tiresome to switch back and forth to recopy text you had previously already copied.

- TIME STAMPS - you are **using current date/time as the time-stamps** like yyyy-mm-dd or yyyymmdd_hhmm, or similar in your documents or as a part of the file name.

- SCREEN COLORS - you **want to capture colors** from elements on screen to replicate them later in your text and/or graphics documents.

- CREDENTIAL WALLET - you are **understand the imprudence of storing login credentials in OneNote or plain text files** but continue to do so because... you know why  ; - )

### Additional Features

- SOUND CONTROL - you often **adjusting sound volume** during meetings or while listening to music.

- MOUSE MOVEMENT – you need to **precisely move mouse cursor by 1px**.

## Q Benefits Explained

- MULTILINGUAL - Q does **not switch between** languages. Instead, it **switches on** them. When using Q, you no longer need to remember how many clicks it takes to switch from one of your languages to another. If you want to type something in your first language, just **press Right Shift, and you'll write in the first language** - even if your keyboard was already set to the first language. To 'switch' to the second language, just **press Right Ctrl, and you'll write in the second language**.

- TRANSLATOR - If you are **writing in a foreign language** and **don't know how to write a particular word or phrase**, just switch to your native language, type your word or phrase, select it, and press the (configurable) hotkey (Win+Alt+T by default). The text will be **translated** for you using Google Translator **without the need to open additional windows or copy/paste translations**. If your word has only one translation, it will be automatically replaced. If there are **several possible translations** that Google offers, you will see **all of them in a popup menu** and be able to **choose the most suitable** one.

- TRANSLITERATION - But even if you forget to switch the language and end up with gibberish after typing a large amount of text, simply select the incorrectly typed text and press the (configurable) hotkey (Win+Alt+Backspace by default). The text will be **transliterated** to the proper language according to the transliterated strings you have prepared in the Q configuration file to **adapt to any keyboard layout**.

- TEXT CASE FIXING - The same applies to text case. No more rewriting in the proper case! Select improper text, use the (configurable) hotkey (Win+Alt+(U/L/C/I) by default), and the text will be fixed from **incorrect upper, LOWER, cAMEL cASE** to the **correct UPPER, lower, Camel Case**.

- CLIPBOARD EXTENDING -This feature is a boon for code and text writers. It allows you to select and copy pieces of text from various sources and locations. At any time, you can press the (configurable) hotkey (Win+Alt+DownArrow by default) to **display a popup menu containing previously copied texts**. This enables you to quickly choose any text from your collected history and effortlessly paste it in the blink of an eye!
In addition there is an ability to paste current **clipboard without formatting** by pressing hot keys defined in the **PastePlainText** and **RemoveClipboardFormatting** in the [Tools] section of the Q.ini file. 

- TIME STAMPS - There are lot of scenarios where you may need **timestamps in texts**. They may include a timestamp in a file name for backup purposes, allowing you to recall when the copy was made. Alternatively, you may need to insert a timestamp into an agreement document to denote the current date and time. To achieve this, simply press the (configurable) hotkey (Win+Alt+S by default), and you will be presented with a selection of items displaying the **current date-time** in various formats, such as **20230621, 2023-06-21 12-23, or even June 21, 2023**. Notably, the last format will be **localized to the currently selected language** in your typing window!

- SCREEN COLORS - There are many cases where you may need to **"replicate" a color you see on your screen**. For instance, you might want to use the exact color you see in a logo or any other part of an image or document for typing headers. To accomplish this, simply **hover your mouse over the desired color on the screen and press the (configurable) hotkey (Win+Alt+LButton by default)**. You will then see the color code displayed in the tooltip, available in **HTML (#rrggbb) or RGB(rrr,ggg,bbb) formats**.
By pressing another hotkey, this code will be **copied to your clipboard**, allowing you to paste it later into a color setting dialog. This works even in the **standard system Color Picker dialog**, where you usually have to enter RGB values into three separate fields. In this case, just place the cursor into the first field (red), press the hotkey, and Q will automatically fill in all three fields, tabbing between them as needed.

- CREDENTIAL WALLET - Built-in wallet as the passwords manager. Yes, it's important to note that **Q is NOT a secure and bulletproof password manager** for handling vital information. For highly sensitive data, it's essential to use one of the approved, audited, and trusted password managers. However, Q provides a more secure alternative to **replace your sticky notes on your monitor or plain text files you might have considered safe enough to store your passwords**. Unlike the last ones, Q stores your passwords in an encrypted format and never displays them on your screen in any way, ensuring that they remain confidential and protected from accidental exposure.

- SOUND CONTROL - And finally, the last but certainly not the least feature, which may not have a direct relation to keyboard and text typing but is used so frequently during text typing that I've decided to include it in the Q. It's all about volume and music control tasks when you're writing texts or participating in a meeting. Simply **hover your mouse over any part of the system taskbar and scroll the mouse wheel**. You'll see a convenient volume meter that smoothly adjusts system volume as your scroll your mouse wheel. This is a **must-have feature** for situations where you want to **quickly reduce music volume in your headphones** when someone came to your desk or **increase the volume during a meeting to better hear a colleague with a poor microphone**.

- ALT PUNCTUATIONS – some **punctuation chars from the English language layout** (. , ; : ' " \< > ? /) can be entered **on any second layout** without switching to English. Just **press right AltGr key** and desired punctuation char to get it.


# What in a basket?

To use Q, you need the only Q.exe file. It's using Q.ini file that automatically created if it's absent. The credentials wallet can be created any time once, you call it for the first time.

## Q Configuration

All Q configuration stored in the file Q.ini that should be located in the same folder with Q.exe. If it's missing you may re-create it any time from the Q icon in the system tray context menu - it will create Q.ini with all features enabled and default hotkeys assignments. If yo don't need and want explicitly exclude some features you may remove its section from the Q.ini file and this feature will be completely disabled and removed from displayed help.

<details><summary>Q.ini example </summary>This is an example with all features enabled and English, German, and French transliteration.
```
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
Show = <#!W
Lock = <#!Q

[Clipboard]
Show = <#!Down
Colunms = 3
ItemsInColunm = 30
ItemVisibleLength = 50

[Transliterating]
TransliterateFirstSecond = <#!BS
TransliterateSeconds = <#^BS
1 = `1234567890-=qwertyuiop[]\asdfghjkl;'zxcvbnm,./~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?
2 = ^1234567890ß´qwertzuiopü+#asdfghjklöäyxcvbnm,.-°!"§$%&/()=?`QWERTZUIOPÜ*'ASDFGHJKLÖÄYXCVBNM;:_
3 = ²&é"'(-è_çà)=azertyuiop^$*qsdfghjklmùwxcvbn,;:²!1234567890°+AZERTYUIOP¨£µQSDFGHJKLM%WXCVBN?./§
```
</details><details><summary>Hotkeys in Q.ini</summary>Regardless that default hot keys assignments looks reasonable, you may the other ones. To change default hot keys for more convenient for you take a look on the Autohotkey documentation page 
https://www.autohotkey.com/docs/v1/Hotkeys.htm
Actually, the syntax is quite simple - it's a list of the char-codes for keys and their modifiers:

- \# – Windows key
- ! – Alt
- ^ – Ctrl
- \+ – Shift

For the keys above you may also use clarification chars:
- < – left side key
- \> – right side key

So, if you want to change the default translation hotkey **<#!T** which is means *Left Windows+Alt+T* and re-assign it to the *Ctrl+Shift+T* you should use **^+T** as a value for the **Translate** key in the section **Tools** in the Q.ini file.

</details><details><summary>Transliteration</summary>This is the only section that requires your fine-tuning. The transliteration logic is straightforward. It assumes that you are typing the correct keys but using the wrong language. To rectify incorrectly written text, you should replace characters from one language with characters from another. The easiest way to **prepare the transliteration strings* is to type in the **same order each symbol key on your keyboard** initially without pressing the Shift key, and then, with the Shift key pressed. You should do this for every language you use in your system to generate the following section in the Q.ini file. 

> WARNING: line numbers must be the same as the numbers in order of the languages installed in your system!

The **TransliterateSeconds** hotkey is used in cases where you believe you are typing in one secondary language but are, in fact, using another. This hotkey facilitates transliteration between two secondary languages. It operates seamlessly when you work with three languages. If you have **more than three languages**, you can select the appropriate secondary language from the **popup menu**.
</details><details><summary>Clipboard formatting</summary>
Paste clipboard content as a plain text without formatting can be done by pressing Shift+Win+Insert (by default). It's like usual Shift+Insert, but with additionally pressed Win key. If this doesn't work, you may at first remove formatting directly in the clipboard (Win+Alt+F by default) and then paste it in usual way - it will be inserted without formatting, because it was removed.
</details><details open><summary>Clipboard monitoring</summary>If the Clipboard feature is enabled, Q will monitor all your text that you are copying. Once you press the clipboard hotkey (Win+Alt+DownArrow by default), Q will show a popup menu with **ItemsInColunm** items in **Colunms** from the [Clipboard] section of the Q.ini file. In this menu will be shown the first **ItemVisibleLength** chars of the previously copied texts. 

Selecting some menu item will invoke inserting text, which header was clicked. 

If, by an accident, you copied some text that should not be exposed in this menu, just select it with the **Shift** key pressed down, and selected item will be removed from the list.

This list is stored **in the memory only** and have no any tails on the disk. So, each time you (re)start Q, the clipboard history will be empty.

</details>
# Credentials Wallet

Use hotkey (Win+Alt+W by default) to bring a popup menu with the wallet data. First time you use this feature, you should use the 'Edit Wallet" menu item to create your own wallet file.

Here is a sample:
```
   Open My site:https://mysite.com/login
   My site login:user
   My site password:qwerty123
   >New sub-menu with icons
   [161]Sub-menu login:admin
   [245]Sub-menu password:admin
   [157]Sub-menu email:admin@company.com
   [166]Sub-menu autologin:user{Tab}qwerty123{Tab}{Enter}
   -
   Item after divider:foo
   Disabled text used like a title
```
that producing the following menu hierarchy:
```
[URL icon] Open My site
My site login
My site password
New sub-menu with icons >
    [icon161] Sub-menu login
    [icon245] Sub-menu password
    [icon157] Sub-menu email
    [icon166] Sub-menu autologin
    ------------------
    Item after divider
    Disabled text used like a title
```


## Wallet content syntax

The **wallet content** is stored **in the file Q.wallet** in the **encrypted** form. First time you create or open it, you will be asked for the password to encrypt the wallet content. The shifted xor algorithm is used for encrypting. It's NOT a real encrypting! It's just the text 'hider', good enough to prevent the peeking of your passwords by somebody behind of your shoulders.

> WARNING: The wallet password is stored **in memory only** and **nowhere on the disk**. 
> There is **no any way to restore it** if you forgot it!

Each row should be a menu item definition. One line per item **lavel:value** where:
  – label - is text of the menu item
  – value - any string valid for Autohotkey's Send

If value starting with 'http', it's treated as a web address to be opened in browser. 

You may also start item with: 
  – '>' to start sub-menu
  – '-' to create divider

If label starting with the digit enclosed in [] this number will be treated as an icon number from the system library system32.dll and displayed in front of the label text.

Items without ':' are shown as a disabled menu item	

## Wallet password verification and resetting

Usually you will be asked for the wallet password first time you will call it. There is no any code (for the source code simplicity) that verify the password correctness. If you will enter incorrect password - you will see a garbage instead of your texts. To enter a new correct password hit <#!Q hotkey. This will lock your wallet, and, next time you will call it, you will be prompted for the password again to type it properly this time.

# Q Security

The keyboard software is one of the most critical part in the security chain. Potentially it may have the backdoors, and keyloggers that may compromise your sensitive information. To prevent any speculations about this, I published all source code on GitHub (http://TBD!!!!). Even minimal understanding of way of writing source codes may allow you to easily verify that there are no any 'surprises' in my code, that it's doing no more than I declare, and doing exactly as described. 

Exe-files I provided is built from these sources. Even if still don't trust any exe-file from external sources, you may rebuilt it from my sources by using the Autohotkey version 1 compiler as it described here - https://www.autohotkey.com/docs/v1/Scripts.htm#ahk2exe. Here is a code I'm using to build my exe-flies:
```
<PathToCompiler>\Ahk2Exe.exe /in Q.ahk /out Q.exe /icon Q.ico /bin <PathToCompiler>\Unicode 64-bit.bin /compress 2
```


# Warning To Users and Modders

This code is free software: you can redistribute it and/or modify  it under the terms of the version 3 GNU General Public License as published by the Free Software Foundation.

This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details (https://www.gnu.org/licenses/gpl-3.0.html)

This script contains "Buy me a coffee" links to honor the author's hard work and dedication in creating all the features present in this code. Removing or altering these links not only violates the GPL license but also disregards the significant effort put into making this script valuable for the community.

If you find value in this script and would like to show appreciation to the author, kindly consider visiting the site below and treating the author to a couple-triple cups of coffee here: https://www.buymeacoffee.com/screeneroner. Your honor and gratitude is greatly appreciated.


# Why did I call it Q?
 1. It's the name of an almost all-powerful creature in the Star Trek universe, capable do absolutely everything in the blink of an eye, much like what you can achieve with your texts when using Q.
 2. Q is the (replacement for) all words in the language from the planet Pliuck (as well as acceptable swearing) in the movie Kindzadza, and by using Q, you'll never need an additional translator to quickly prepare your texts.