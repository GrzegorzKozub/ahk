; Main

driveLabel := "Backup"
message := "The backup will now begin."

Loop {
    MsgBox, 1, %A_ScriptName%, %message%
    IfMsgBox, OK 
    {
        if (IsDriveConnected(driveLabel)) {
            Run, C:\Program Files (x86)\SyncBackPro\SyncBackPro.exe -m "Envy"
            Exit, 0
        } else {
            message := "The drive labeled " . driveLabel . " is not connected."
        }
    } else {
        Exit, 1
    }
}

; Functions

IsDriveConnected(label) {
    DriveGet, connectedDrives, List, FIXED
    Loop, Parse, connectedDrives 
    {
        DriveGet, currentLabel, Label, %A_LoopField%:
        If (currentLabel = label) {
            return True
        }
    }
    return False
}

