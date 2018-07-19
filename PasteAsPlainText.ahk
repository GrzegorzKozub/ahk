; Main

#NoTrayIcon
#SingleInstance force

; Hotkeys

^#v::
    originalClipboard = %ClipBoardAll%
    ClipBoard = %ClipBoard%
    Send ^v
    Sleep 1000
    ClipBoard = %originalClipboard%
    VarSetCapacity(originalClipboard, 0)
    return

