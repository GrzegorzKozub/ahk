; Main

if (GetDaysSinceLastBackup() == 0) {
    ExitApp
}
SplitPath A_ScriptName,,,, fileName
Menu Tray, Icon, %fileName%.ico
Menu Tray, NoStandard
Menu Tray, Add, Start backup, StartBackup
Menu Tray, Add, Exit
Menu Tray, Default, Start backup
Menu Tray, Click, 1
DisplayToolTip()
return

; Hotkeys

^#b::
    GoSub StartBackup
    return

; Labels

StartBackup:
    Loop {
        if (IsDriveConnected("Backup")) {
            Run C:\Program Files (x86)\SyncBackPro\SyncBackPro.exe
            ExitApp
        } else {
            MsgBox 53, %A_ScriptName%, The drive labeled Backup is not connected. Attach it and hit Retry.
            IfMsgBox Cancel
            {
                ExitApp
            }
        }
    }
    return

Exit:
    ExitApp

; Functions

GetDaysSinceLastBackup() {
    backupSettingsFilePath := USERPROFILE . "\AppData\Local\2BrightSparks\SyncBackPro\" . A_ComputerName . "_Settings.ini"
    FileGetTime lastBackupDate, %backupSettingsFilePath%
    result := %A_Now%
    EnvSub result, %lastBackupDate%, days
    return result
}

DisplayToolTip() {
    daysSinceLastBackup := GetDaysSinceLastBackup()
    if (daysSinceLastBackup <= 3) {
        icon := 1
    } else if (daysSinceLastBackup >= 7) {
        icon := 3
    } else {
        icon := 2
    }
    TrayTip %A_ScriptName%, Last backup taken %daysSinceLastBackup% day(s) ago., 30, %icon%
}

IsDriveConnected(label) {
    DriveGet connectedDrives, List, FIXED
    Loop Parse, connectedDrives
    {
        DriveGet currentLabel, Label, %A_LoopField%:
        if (currentLabel = label) {
            return True
        }
    }
    return False
}

