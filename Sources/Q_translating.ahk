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
; FUNCTION: Translate_Selection
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Translates the selected text between the active and second languages.
; If nothing selected - the last word left to the cursor will be used
; After translation the second language is automatically set.
;
; PARAMETERS: None.
;
; RETURNS: None.
;----------------------------------------------------------------------------------------------------------------------
Translate_Selection() 
{   
   lng := GetLanguages()
   active_LCID := GetActiveWindowLid() 
	for index, element in lng {
		if lng[index].LCID = active_LCID 
		{		
			l_from := lng[index].LanguageCode
			lti := index > 1 ? 1 : second_lid
			l_to := lng[lti].LanguageCode
			break
		}
	}

	originalClipboard := ClipboardAll ; Save the current clipboard content

   ; temporary disble clipboard monitoring if it was set
   IniRead, hk, Q.ini, Clipboard
   if (hk != "ERROR" and hk!="") 
      OnClipboardChange("ClipboardChanged", 0) 
     
   ; Copy selection to clipboard
	clipboard =
	Send ^{Ins} 
	ClipWait, 1 

   ; if nothing selected - try to get one word left from the cursor
   if ErrorLevel {
      Send ^+{Left} ; select word left
      Send ^{Ins} ; copy it
      ClipWait, 1 
      if ErrorLevel ; still nothing copied - exiting
         goto exiting_translating
   }

	text_to_translate := Clipboard 
   
   if (text_to_translate = "") 
      goto exiting_translating

   translated_text := TranslateTextFromTo(text_to_translate, l_from, l_to)
   if (translated_text = "" or translated_text = text_to_translate) 
      goto exiting_translating

   SetLanguage(lti)
   Clipboard := translated_text ; Set the translated text to the clipboard
   Send +{Ins}                  ; Send a paste command (Shift+Insert)				
   SLEEP, 200 ; give some time to 'type' text  

   exiting_translating:
   ; restore temporary disble clipboard monitoring if it was set
   if (hk != "ERROR" and hk!="") 
      OnClipboardChange("ClipboardChanged") 

	Clipboard := originalClipboard
}




;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: TranslateTextFromTo
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Translates text from one language to another using a translation service.
;
; PARAMETERS:
; - text (string): The text to be translated.
; - lFrom (string): The source language code.
; - lTo (string): The target language code.
;
; RETURNS:
; - The translated text if successful.
; - The original text if no translation was performed or multiple translation options were found.
;----------------------------------------------------------------------------------------------------------------------
TranslateTextFromTo(text, lFrom, lTo)
{
   global ItemSelected
	StringLen, cl, text
	if cl > 0
	{
		gtr := GoogleTranslate(text, lFrom, lTo)
		
		if (InStr(text,"`n") = 0) & (InStr(gtr,"`n") > 0) ; one line source got several results - show chooser menu
		{
         ItemSelected := false
			ShowTranslatesSelector(gtr)
			if ItemSelected
				return SubStr(A_ThisMenuItem,InStr(A_ThisMenuItem," ")+1) ; trim variant number to leave translation only
			else 
				return text ; nothing selected in menu - return original text 
		}
		return %gtr% ; single line source and single line response - just return it
	}
	return text ; nothing returned - return source text
}
;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: ShowTranslatesSelector
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Displays a menu with translation options for user selection.
;
; PARAMETERS:
; - translation (string): The translation options as a multi-line string.
;
; RETURNS: None.
;----------------------------------------------------------------------------------------------------------------------
ShowTranslatesSelector(translation)
{
   global ItemSelected
	Menu, Variants, Add   
	Menu, Variants, DeleteAll 
	prev_element := "not+"
	items := StrSplit(translation,"`n")
	for index, element in items
	{
		if SubStr(element,1,1) != "+"
		{
			if SubStr(prev_element,1,1) == "+" ; create divider
				Menu, Variants, Add, %index%. %element%, DoNothing, +BarBreak
			else 
				Menu, Variants, Add, %index%. %element%, DoNothing 
		}
		prev_element := element
	} 
	Menu, Variants, Show
}
DoNothing() {
   global ItemSelected
   ItemSelected := true
   return
}

;----------------------------------------------------------------------------------------------------------------------
; This codes below were found somewhere/sometime. I don't know its author and have no idea how it work
; and why it's needed. If you know - please let me know. Maybe they may be optimized or implemented in
; another, more efficient and/or shorter way.
;----------------------------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: GoogleTranslate
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Translates text using the Google Translate service.
;
; PARAMETERS:
; - str (string): The text to be translated.
; - from (string): Optional. The source language code (default is "auto").
; - to (string): Optional. The target language code (default is "en").
;
; RETURNS:
; - The translated text if successful.
; - The original text if no translation was performed.
;----------------------------------------------------------------------------------------------------------------------
GoogleTranslate(str, from := "auto", to := "en")  
{
   static JS := CreateScriptObj(), _ := JS.( GetJScript() ) := JS.("delete ActiveXObject; delete GetObject;")
   
   json := SendRequest(JS, str, to, from, proxy := "")
   oJSON := JS.("(" . json . ")")

   if !IsObject(oJSON[1])  {
      Loop % oJSON[0].length
         trans .= oJSON[0][A_Index - 1][0]
   }
   else  {
      MainTransText := oJSON[0][0][0]
      Loop % oJSON[1].length  {
         trans .= "`n+"
         obj := oJSON[1][A_Index-1][1]
         Loop % obj.length  {
            txt := obj[A_Index - 1]
            trans .= (MainTransText = txt ? "" : "`n" txt)
         }
      }
   }
   if !IsObject(oJSON[1])
      MainTransText := trans := Trim(trans, ",+`n ")
   else
      trans := MainTransText . "`n+`n" . Trim(trans, ",+`n ")

   from := oJSON[2]
   trans := Trim(trans, ",+`n ")
   Return trans
}

;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: SendRequest
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Sends a request to the Google Translate service and retrieves the translation result.
;
; PARAMETERS:
; - JS: A JavaScript object for token generation.
; - str (string): The text to be translated.
; - tl (string): The target language code.
; - sl (string): The source language code.
; - proxy (string): Optional. The proxy server to use for the request.
;
; RETURNS:
; - The translation result as a JSON-formatted string.
;----------------------------------------------------------------------------------------------------------------------
SendRequest(JS, str, tl, sl, proxy) 
{
   ComObjError(false)
   http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   ( proxy && http.SetProxy(2, proxy) )
   http.open( "POST", "https://translate.google.com/translate_a/single?client=t&sl="
      . sl . "&tl=" . tl . "&hl=" . tl
      . "&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&ssel=3&tsel=3&pc=1&kc=2"
      . "&tk=" . JS.("tk").(str), 1 )

   http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
   http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
   http.send("q=" . URIEncode(str))
   http.WaitForResponse(-1)
	 ;MsgBox % http.responsetext
   Return http.responsetext
}

;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: URIEncode
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Encodes a string for use in a URI (Uniform Resource Identifier).
;
; PARAMETERS:
; - str (string): The string to be encoded.
; - encoding (string): Optional. The character encoding (default is "UTF-8").
;
; RETURNS:
; - The URI-encoded string.
;----------------------------------------------------------------------------------------------------------------------
URIEncode(str, encoding := "UTF-8")  {
   VarSetCapacity(var, StrPut(str, encoding))
   StrPut(str, &var, encoding)

   While code := NumGet(Var, A_Index - 1, "UChar")  {
      bool := (code > 0x7F || code < 0x30 || code = 0x3D)
      UrlStr .= bool ? "%" . Format("{:02X}", code) : Chr(code)
   }
   Return UrlStr
}

;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: GetJScript
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Generates and returns a JavaScript code snippet used for token generation.
;
; PARAMETERS: None.
;
; RETURNS: A JavaScript code snippet.
;----------------------------------------------------------------------------------------------------------------------
GetJScript()
{
   script =
   (
      var TKK = ((function() {
        var a = 561666268;
        var b = 1526272306;
        return 406398 + '.' + (a + b);
      })());

      function b(a, b) {
        for (var d = 0; d < b.length - 2; d += 3) {
            var c = b.charAt(d + 2),
                c = "a" <= c ? c.charCodeAt(0) - 87 : Number(c),
                c = "+" == b.charAt(d + 1) ? a >>> c : a << c;
            a = "+" == b.charAt(d) ? a + c & 4294967295 : a ^ c
        }
        return a
      }

      function tk(a) {
          for (var e = TKK.split("."), h = Number(e[0]) || 0, g = [], d = 0, f = 0; f < a.length; f++) {
              var c = a.charCodeAt(f);
              128 > c ? g[d++] = c : (2048 > c ? g[d++] = c >> 6 | 192 : (55296 == (c & 64512) && f + 1 < a.length && 56320 == (a.charCodeAt(f + 1) & 64512) ?
              (c = 65536 + ((c & 1023) << 10) + (a.charCodeAt(++f) & 1023), g[d++] = c >> 18 | 240,
              g[d++] = c >> 12 & 63 | 128) : g[d++] = c >> 12 | 224, g[d++] = c >> 6 & 63 | 128), g[d++] = c & 63 | 128)
          }
          a = h;
          for (d = 0; d < g.length; d++) a += g[d], a = b(a, "+-a^+6");
          a = b(a, "+-3^+b+-f");
          a ^= Number(e[1]) || 0;
          0 > a && (a = (a & 2147483647) + 2147483648);
          a `%= 1E6;
          return a.toString() + "." + (a ^ h)
      }
   )
   Return script
}

;----------------------------------------------------------------------------------------------------------------------
; FUNCTION: CreateScriptObj
;----------------------------------------------------------------------------------------------------------------------
; PURPOSE: Creates and returns a script object for executing JavaScript code.
;
; PARAMETERS: None.
;
; RETURNS: A script object.
;----------------------------------------------------------------------------------------------------------------------
CreateScriptObj() 
{
   static doc
   doc := ComObjCreate("htmlfile")
   doc.write("<meta http-equiv='X-UA-Compatible' content='IE=9'>")
   Return ObjBindMethod(doc.parentWindow, "eval")
}