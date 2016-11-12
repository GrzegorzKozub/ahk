; Settings

_settings := [ Join

    , { HiRes: { Width: 2200, Height: 1300, Center: True }
      , LoRes: { Width: 1650, Height: 1000, Center: True, Maximize: True }
      , Windows: [ "Microsoft SQL Server Management Studio"
                 , "Microsoft Visual Studio"
                 , "Release Management" ] }

    , { HiRes: { Width: 1636, Height: 984, Center: True }
      , LoRes: { Width: 1636, Height: 984, Center: True }
      , Windows: [ "GVIM"
                 , "Visual Studio Code" ] }

    , { HiRes: { Width: 1900, Height: 1200, Center: True }
      , LoRes: { Width: 1500, Height: 1000, Center: True }
      , Windows: [ "BareTail"
                 , "Developer Tools" ; Chrome
                 , "Edge"
                 , "Excel"
                 , "F12 Developer Tools" ; Edge
                 , "Git Gui"
                 , "Google Chrome"
                 , "JetBrains dotPeek"
                 , "Mozilla Firefox",
                 , "paint.net"
                 , "PowerPoint"
                 , "Remote Desktop Connection"
                 , "SourceTree"
                 , "SQL Server Profiler"
                 , "SumatraPDF"
                 , "Visio"
                 , "Internet Explorer"
                 , "Word" ] }

    , { HiRes: { Width: 1500, Height: 1000, Center: True }
      , LoRes: { Width: 1300, Height: 900, Center: True }
      , Windows: [ "Steam" ] }

    , { HiRes: { Width: 1200, Height: 850, Center: True }
      , LoRes: { Width: 1200, Height: 850, Center: True }
      , Windows: [ "Battle.net"
                 , "Event Viewer"
                 , "Fiddler Web Debugger"
                 , "Hyper-V Manager"
                 , "Internet Information Services (IIS) Manager"
                 , "LOOT"
                 , "Mod Organizer"
                 , "NVIDIA Control Panel"
                 , "Origin"
                 , "Pogoda"
                 , "Task Scheduler"
                 , "Total Commander"
                 , "Settings"
                 , "Uplay"
                 , "WinSCP" ] } ]

_settings := Concatenate(_settings, [ Join

    , { HiRes: { Width: 1253, Height: 959, Right: 25, Bottom: 25 }
      , LoRes: { Width: 1013, Height: 779, Right: 25, Bottom: 25 }
      , Windows: [ "~" ] } ; ConEmu

    , { HiRes: { Width: 975, Height: 650, Center: True }
      , LoRes: { Width: 975, Height: 650, Center: True }
      , Windows: [ "WinSnap" ] }

    , { HiRes: { Width: 900, Height: 900, Center: True }
      , LoRes: { Width: 900, Height: 900, Center: True }
      , Windows: [ "Skype"
                 , "Slack" ] }

    , { HiRes: { Width: 900, Height: 600, Center: True }
      , LoRes: { Width: 900, Height: 600, Center: True }
      , Windows: [ "C:\Users\" ; 7-Zip
                 , "Deluge"
                 , "KeePass"
                 , "Lister" ; Total Commander
                 , "Notepad"
                 , "Oracle VM VirtualBox Manager"
                 , "Rapid Environment Editor"
                 , "Registry Editor"
                 , "Resource Hacker"
                 , "VLC media player"
                 , "WinRAR" ] } ] )

_settings := Concatenate(_settings, [ Join

    , { HiRes: { Width: 850, Height: 700, Center: True }
      , LoRes: { Width: 850, Height: 700, Center: True }
      , Windows: [ "OBS" ] }

    , { HiRes: { Width: 700, Height: 800, Center: True }
      , LoRes: { Width: 700, Height: 800, Center: True }
      , Windows: [ "Todoist" ] }

    , { HiRes: { Width: 800, Height: 500, Center: True }
      , LoRes: { Width: 800, Height: 500, Center: True }
      , Windows: [ "SyncBackPro" ] }

    , { HiRes: { Width: 660, Height: 600, Right: 25, Bottom: 25 }
      , LoRes: { Width: 660, Height: 600, Right: 25, Bottom: 25 }
      , Windows: [ "Task Manager" ] }

    , { HiRes: { Width: 233, Height: 450, Right: 25, Bottom: 25 }
      , LoRes: { Width: 233, Height: 450, Right: 25, Bottom: 25 }
      , Windows: [ "Friends" ] } ] ) ; Steam

; Main

SplitPath A_ScriptName,,,, fileName
Menu Tray, Icon, %fileName%.ico
SetTitleMatchMode 2
HotKey ^#w, FixActiveWindow
HotKey ^#c, CenterActiveWindow
return

; Labels

FixActiveWindow:
    _screen := GetScreen()
    WinGetActiveTitle activeWindowTitle
    FixWindow(activeWindowTitle)
    return

CenterActiveWindow:
    _screen := GetScreen()
    WinGetActiveTitle activeWindowTitle
    CenterWindow(activeWindowTitle)
    return

; Functions

Concatenate(arrays*) {
    result := Object()
    for key, array in arrays {
        for key, element in array {
            result.Insert(element)
        }
    }
    return result
}

GetScreen() {
    SysGet monitorNumber, MonitorPrimary
    SysGet monitor, Monitor, %monitorNumber%
    SysGet monitorWorkArea, MonitorWorkArea, %monitorNumber%
    return { Dpi: GetDpi(), LoRes: monitorBottom < 1440, Width: monitorWorkAreaRight - monitorWorkAreaLeft, Height: monitorWorkAreaBottom - monitorWorkAreaTop }
}

GetDpi() {
    ; 96 (for 100%), 120, 144, 168, 192 (for 200%), ...
    RegRead, dpi, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
    if (ErrorLevel = 1) {
        return 96
    } else {
        return dpi
    }
}

FixWindow(title) {
    options := GetOptions(title)
    if (!options) {
        return
    }
    window := GetWindow(title)
    if (!window) {
        return
    }
    WinRestore %title%
    left := options.Left ? options.Left : -options.Right
    top := options.Top ? options.Top : -options.Bottom
    MoveWindow(window, title, left, top, options.Width, options.Height)
    if (options.Center) {
        CenterWindow(title)
    }
    if (options.Maximize) {
        WinMaximize %title%
    }
}

GetOptions(title) {
    global _settings
    global _screen
    for key, group in _settings {
        options := _screen.LoRes ? group.LoRes : group.HiRes
        for key, window in group.Windows {
            find := window.Find ? window.Find : window
            except := window.Except ? window.Except : ""
            if (InStr(title, find) > 0 && (!except || InStr(title, except) == 0)) {
                return options
            }
        }
    }
}

MoveWindow(window, title, left = "", top = "", width = "", height = "") {
    global _screen
    if (!width) {
        width := window.Width
    }
    if (!height) {
        height := window.Height
    }
    if (!left) {
        left := window.Left
    } else if (left < 0) {
        left := _screen.Width - (width + Abs(left))
    }
    if (!top) {
        top := window.Top
    } else if (top < 0) {
        top := _screen.Height - (height + Abs(top))
    }
    WinMove %title%,, %left%, %top%, %width%, %height%
}

CenterWindow(title) {
    global _screen
    window := GetWindow(title)
    if (!window) {
        return
    }
    WinMove %title%,, (_screen.Width / 2) - (window.Width / 2), (_screen.Height / 2) - (window.Height / 2)
}

GetWindow(title) {
    WinGetPos x, y, width, height, %title%
    if (!x) {
        return
    }
    WinGet minMax, MinMax, %title%
    return { Left: x, Top: y, Width: width, Height: height }
}

