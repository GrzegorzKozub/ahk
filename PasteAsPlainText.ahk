#v::
    originalClipboard = %ClipBoardAll%
    ClipBoard = %ClipBoard%
    Send ^v
    Sleep 1000
    ClipBoard = %originalClipboard%
    VarSetCapacity(originalClipboard, 0)
    return

#p::
    ClipBoard = %ClipBoard%
    return

