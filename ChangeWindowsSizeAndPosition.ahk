; Settings

_settings := [ Join

    , { Options: [ { Left: 150, Top: 50, Stretch: True } ; 2560 x 1440 at 96 dpi
                 , { Left: 100, Top: 25, Stretch: True, Screens: [ { Resolution: 1080, Dpi: 96 }
                                                                 , { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "Microsoft SQL Server Management Studio"
                 , "Microsoft Visual Studio"
                 , "Visual Studio Code" ] }

    , { Options: [ { Left: 300, Top: 100, Stretch: True }
                 , { Left: 200, Top: 50, Stretch: True, Screens: [ { Resolution: 1080, Dpi: 96 }
                                                                 , { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "BareTail"
                 , "Developer Tools" ; Chrome
                 , "Edge"
                 , "F12 Developer Tools" ; Edge
                 , "Google Chrome"
                 , "JetBrains dotPeek"
                 , "Mozilla Firefox"
                 , "paint.net"
                 , "Remote Desktop Connection"
                 , "SourceTree"
                 , "WinSnap" ] }

    , { Options: [ { Left: 450, Top: 150, Stretch: True }
                 , { Left: 300, Top: 75, Stretch: True, Screens: [ { Resolution: 1080, Dpi: 96 } ] } ]
      , Windows: [ "Steam" ] }

    , { Options: [ { Left: 600, Top: 200, Stretch: True }
                 , { Left: 400, Top: 100, Stretch: True, Screens: [ { Resolution: 1080, Dpi: 96 }
                                                                  , { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "Battle.net"
                 , "Event Viewer"
                 , "Fiddler Web Debugger"
                 , "GOG Galaxy"
                 , "Hyper-V Manager"
                 , "Internet Information Services (IIS) Manager"
                 , "LOOT"
                 , "Mod Organizer"
                 , "NVIDIA Control Panel"
                 , "Origin"
                 , "Pogoda"
                 , "Task Scheduler"
                 , "Settings"
                 , "Uplay" ] }

    , { Options: [ { Left: 750, Top: 250, Stretch: True }
                 , { Left: 500, Top: 125, Stretch: True, Screens: [ { Resolution: 1080, Dpi: 96 }
                                                                  , { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "C:\Users\" ; 7-Zip
                 , "Deluge"
                 , "KeePass"
                 , "Lister" ; Total Commander
                 , "Notepad"
                 , "OBS"
                 , "Oracle VM VirtualBox Manager"
                 , "Rapid Environment Editor"
                 , "Registry Editor"
                 , "Resource Hacker"
                 , "WinRAR" ] } ]

_settings := Concatenate(_settings, [ Join

    , { Options: [ { Width: 1296, Height: 832, Center: True } ]
      , Windows: [ "VLC media player" ] }

    , { Options: [ { Width: 1250, Height: 850, Center: True }
                 , { Width: 1150, Height: 750, Center: True, Screens: [ { Resolution: 1080, Dpi: 96 } ] }
                 , { Width: 1600, Height: 1000, Center: True, Screens: [ { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "Total Commander" ] }

    , { Options: [ { Width: 800, Height: 600, Center: True }
                 , { Width: 1200, Height: 800, Center: True, Screens: [ { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "SyncBackPro" ] } ] )

_settings := Concatenate(_settings, [ Join

    , { Options: [ { Width: 1200, Left: 75, Top: 75, Bottom: 75 }
                 , { Width: 900, Left: 75, Top: 75, Bottom: 75, Screens: [ { Resolution: 1080, Dpi: 96 } ] } ]
      , Windows: [ "SumatraPDF" ] }

    , { Options: [ { Width: 1456, Height: 984, Center: True }
                 , { Width: 1321, Height: 879, Center: True, Screens: [ { Resolution: 1080, Dpi: 96 } ] }
                 , { Width: 1842, Height: 1176, Center: True, Screens: [ { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "GVIM" ] }

    , { Options: [ { Width: 1205, Height: 1019, Right: 25, Bottom: 25 }
                 , { Width: 1061, Height: 699, Right: 25, Bottom: 25, Screens: [ { Resolution: 1080, Dpi: 96 } ] }
                 , { Width: 1412, Height: 1036, Right: 25, Bottom: 25, Screens: [ { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "~" ] } ; ConEmu

    , { Options: [ { Width: 700, Height: 600, Right: 25, Bottom: 25 }
                 , { Width: 1000, Height: 850, Right: 25, Bottom: 25, Screens: [ { Resolution: 1440, Dpi: 144 } ] } ]
      , Windows: [ "Task Manager" ] }

    , { Options: [ { Width: 250, Height: 450, Right: 25, Bottom: 25 } ]
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
    return { Resolution: monitorBottom
        , Dpi: GetDpi()
        , Width: monitorWorkAreaRight - monitorWorkAreaLeft
        , Height: monitorWorkAreaBottom - monitorWorkAreaTop }
}

GetDpi() {
    ; Returns 96 (for 100%), 120, 144, 168, 192 (for 200%), ...
    RegRead, dpi, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
    return (ErrorLevel = 1) ? 96 : dpi
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
    MoveWindow(window, title, options)
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
        for key, window in group.Windows {
            find := window.Find ? window.Find : window
            except := window.Except ? window.Except : ""
            if (InStr(title, find) > 0 && (!except || InStr(title, except) == 0)) {
                for key, options in group.Options {
                    for key, screen in options.Screens {
                        if (screen.Resolution == _screen.Resolution && screen.Dpi == _screen.Dpi) {
                            return options
                        }
                    }
                }
                return group.Options[1]
            }
        }
    }
}

MoveWindow(window, title, options) {
    global _screen
    if (!options.Left) {
        options.Left := -options.Right
    }
    if (!options.Top) {
        options.Top := -options.Bottom
    }
    options.Width := GetSize(options.Width, window.Width, _screen.Width, options.Left, options.Right, options.stretch)
    options.Height := GetSize(options.Height, window.Height, _screen.Height, options.Top, options.Bottom, options.stretch)
    options.Left := GetMargin(options.Left, window.Left, options.Width, _screen.Width)
    options.Top := GetMargin(options.Top, window.Top, options.Height, _screen.Height)
    WinMove % title,, options.Left, options.Top, options.Width, options.Height
}

GetSize(size, windowSize, screenSize, startMargin, endMargin, stretch) {
    if (size) {
        return size
    }
    if (stretch) {
        return screenSize - (2 * startMargin)
    } else if (endMargin) {
        return screenSize - startMargin - endMargin
    } else {
        return windowSize
    }
}

GetMargin(margin, windowMargin, size, screenSize) {
    if (!margin) {
        return windowMargin
    } else if (margin < 0) {
        return screenSize - (size + Abs(margin))
    } else {
        return margin
    }
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

