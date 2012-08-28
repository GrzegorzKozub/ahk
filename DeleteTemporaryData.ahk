; Settings

_browsers := [ { Title: "Firefox", Executable: "firefox.exe", Confirmation: "PressEnter" }
             , { Title: "Chrome", Executable: LOCALAPPDATA . "\Google\Chrome\Application\chrome.exe", Confirmation: "PressTab11TimesThenEnter" }
             , { Title: "Internet Explorer", Executable: "iexplore.exe", Confirmation: "PressAltD" } ]

_folders := [ TEMP
            , WINDIR . "\Temp"
            , USERPROFILE . "\AppData\LocalLow\Sun\Java\Deployment\cache" 
            , USERPROFILE . "\AppData\LocalLow\Apple Computer\QuickTime\downloads" ]

_files := [ WINDIR . "\MEMORY.DMP"
          , USERPROFILE . "\AppData\Roaming\Microsoft\Windows\Recent\*.lnk" ]

; Main

SetTitleMatchMode 2
GoSub ClearBrowserCache
GoSub ClearFolders
GoSub DeleteFiles
FileRecycleEmpty
return

; Labels

ClearBrowserCache:
    for key, browser in _browsers {
        EmptyBrowserCache(browser.Title, browser.Executable, browser.Confirmation)
    }
return

ClearFolders:
    for key, folderPath in _folders {
        EmptyFolder(folderPath)
    }
return

DeleteFiles:
    for key, filePath in _files {
        FileDelete %filePath%
    }
return

; Functions

EmptyBrowserCache(title, executable, confirmation) {
    Run %executable%,,, processId
    WinWait %title%,, 5
    if ErrorLevel { 
        MsgBox,, %A_ScriptName%, Could not open %title% in time.
        return
    } 
    Sleep 1000
    Send {Ctrl down} {Shift down}
    Send {Del}
    Send {Ctrl up} {Shift up}
    Sleep 1000
    %confirmation%()
    Sleep 5000
    WinClose %title%
    Process WaitClose, %processId%, 5
    if ErrorLevel {
        MsgBox,, %A_ScriptName%, Could not close %title% in time.
        return
    }
}

PressEnter() {
    Send {Enter}
}

PressAltD() {
    Send {Alt down}
    Send {D}
    Send {Alt up}
}

PressTab11TimesThenEnter() {
    Send {Tab 11}
    Send {Enter}
}

EmptyFolder(folderPath) {
    Loop %folderPath%\*, 1 
    {
        IfInString A_LoopFileAttrib, D, {
            FileRemoveDir %A_LoopFileFullPath%, 1
        } else {
            FileDelete %A_LoopFileFullPath%
        }
    }
}

