/*
================================================================================
Project: OmniSearch Quick Launcher
Version: 1.0.2
Author: Rifins Dev
Website: https://www.rifins.com
Description: Highlight any text, press Ctrl+Shift+S, and search 
             instantly across Google, YouTube, Reddit, or Wikipedia.
================================================================================
*/
#Requires AutoHotkey v2.0
#SingleInstance Force

; Application Metadata
AppWebsite := "www.rifins.com"
Global SearchTerm := ""

; Initialize Hidden GUI (No title bar for minimalist look)
MyGui := Gui("+AlwaysOnTop -Caption +Border", "OmniSearch")
MyGui.SetFont("s10 bold")
MyGui.Add("Text", "w200 Center", "Search Engine For:")

; FIX: Pengaturan font (ukuran dan warna merah) dipisah ke baris SetFont
MyGui.SetFont("s9 norm cRed")
Global TxtDisplay := MyGui.Add("Text", "w200 Center", "...")

; Platform Buttons
MyGui.SetFont("s9 norm cDefault") ; Mengembalikan warna font ke standar (hitam) untuk tombol
MyGui.Add("Button", "w200 h30", "Google").OnEvent("Click", (*) => ExecuteSearch("Google"))
MyGui.Add("Button", "w200 h30", "YouTube").OnEvent("Click", (*) => ExecuteSearch("YouTube"))
MyGui.Add("Button", "w200 h30", "Reddit").OnEvent("Click", (*) => ExecuteSearch("Reddit"))
MyGui.Add("Button", "w200 h30", "Wikipedia").OnEvent("Click", (*) => ExecuteSearch("Wikipedia"))

; Close GUI manually
MyGui.Add("Button", "w200 h25", "Cancel").OnEvent("Click", (*) => MyGui.Hide())

; Credit Label
MyGui.SetFont("s8 cBlue", "Inter")
MyGui.Add("Text", "w200 Center", AppWebsite).OnEvent("Click", (*) => Run("https://" . AppWebsite))

; Hotkey Trigger: Ctrl + Shift + S
^+s:: 
{
    Global SearchTerm, TxtDisplay
    A_Clipboard := ""
    Send("^c") ; Copy highlighted text
    if !ClipWait(1) {
        MsgBox("Failed to capture text. Please highlight something first.", "Error", "Iconx")
        return
    }
    SearchTerm := Trim(A_Clipboard)
    
    ; Truncate text if it's too long for the UI display
    if (StrLen(SearchTerm) > 25)
        TxtDisplay.Value := SubStr(SearchTerm, 1, 22) . "..."
    else
        TxtDisplay.Value := SearchTerm
    
    MyGui.Show("AutoSize Center")
}

; Logic: Format URL and execute search
ExecuteSearch(Engine) {
    Global SearchTerm
    MyGui.Hide()
    EncodedTerm := StrReplace(SearchTerm, " ", "%20") ; URL Encoding for spaces
    
    if (Engine == "Google")
        Run("https://www.google.com/search?q=" . EncodedTerm)
    else if (Engine == "YouTube")
        Run("https://www.youtube.com/results?search_query=" . EncodedTerm)
    else if (Engine == "Reddit")
        Run("https://www.reddit.com/search/?q=" . EncodedTerm)
    else if (Engine == "Wikipedia")
        Run("https://en.wikipedia.org/wiki/Special:Search?search=" . EncodedTerm)
}
