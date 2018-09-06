; Main

#NoTrayIcon
#SingleInstance force

; Paste as plain text

^#v::
    originalClipboard = %ClipBoardAll%
    ClipBoard = %ClipBoard%
    Send ^v
    Sleep 1000
    ClipBoard = %originalClipboard%
    VarSetCapacity(originalClipboard, 0)
    return

; Toggle window always on top

^#a::
    Winset, AlwaysOnTop,, A
    return
