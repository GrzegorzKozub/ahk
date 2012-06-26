if 0 != 1 
{
    MsgBox % "Didn't pass the path as a parameter."
    ExitApp
}

IfNotExist %1%, {
    MsgBox % "Provided path does not exist."
    ExitApp
}

clipboard = "%1%"

PostMessage 1075, 531, 0, , ahk_class TTOTAL_CMD ; cm_Exchange
PostMessage 1075, 2912, 0, , ahk_class TTOTAL_CMD ; cm_EditPath
Send ^v
Send {Enter}
PostMessage 1075, 531, 0, , ahk_class TTOTAL_CMD ; cm_Exchange