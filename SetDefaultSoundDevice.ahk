; Main

Menu Tray, NoStandard
Menu Tray, Add, Change default sound device, ChangeDefaultSoundDevice
Menu Tray, Add, Exit
Menu Tray, Default, Change default sound device
Menu Tray, Click, 1
GoSub ChangeDefaultSoundDevice
return

; Hotkeys

^#p::
    ChangeDefaultSoundDevice(True)
    return

; Labels

ChangeDefaultSoundDevice:
    ChangeDefaultSoundDevice()
    return

Exit:
    ExitApp

; Functions

ChangeDefaultSoundDevice(displayToolTip := False) {
    global _speakers
    if (_speakers) {
        SetDefaultSoundDevice("VG248-3", 2, displayToolTip)
        _speakers := False
    } else {
        SetDefaultSoundDevice("Speakers", 1, displayToolTip)
        _speakers := True
    }
}

SetDefaultSoundDevice(soundDeviceName, iconIndex, displayToolTip := False) {
    Run NirCmd SetDefaultSoundDevice %soundDeviceName%
    SplitPath A_ScriptName,,,, fileName
    Menu Tray, Icon, %fileName%.icl, %iconIndex%
    if (displayToolTip) {
        TrayTip %A_ScriptName%, Default sound device is now %soundDeviceName%., 5, 1
    }
}

