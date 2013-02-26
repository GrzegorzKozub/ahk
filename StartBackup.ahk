; Main

driveLabel := "Backup"
message := "Do you want to make the backup now?"

Loop {
    MsgBox, 4, %A_ScriptName%, %message%
    IfMsgBox, Yes
    {
        if (IsDriveConnected(driveLabel)) {
            Run, C:\Program Files (x86)\SyncBackPro\SyncBackPro.exe -m "Envy"
            Exit, 0
        } else {
            message := "Is the drive labeled " . driveLabel . " connected?"
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

