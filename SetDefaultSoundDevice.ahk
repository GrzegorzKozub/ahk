; Main

SetDefaultSoundDevice("Speakers", 1)
return

^#p::
    SetDefaultSoundDevice("Speakers", 1)
    return

^#h::
    SetDefaultSoundDevice("VG248-3", 2)
    return

; Functions

SetDefaultSoundDevice(soundDeviceName, iconIndex) {
    Run NirCmd SetDefaultSoundDevice %soundDeviceName%
    SplitPath A_ScriptName,,,, fileName
    Menu Tray, Icon, %fileName%.icl, %iconIndex%
}

