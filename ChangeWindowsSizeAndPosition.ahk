; Settings

Setup( { Options: [ { Left: 50, Top: 50, Stretch: True, Max: True, Screens: [ { P: 1200, Dpi: 144 }
                                                                            , { P: 1440, Dpi: 192 }
                                                                            , { P: 1800, Dpi: 240 } ] } ]
       , Windows: [ "BareTail"
                  , "Developer Tools" ; Chrome, Edge
                  , "dotPeek"
                  , "Edge"
                  , "Excel"
                  , "Google Chrome"
                  , "Inkscape"
                  , "Microsoft Visual Studio"
                  , "OneNote"
                  , "Outlook"
                  , "paint.net"
                  , "Pluralsight"
                  , "PowerPoint"
                  , "Remote Desktop Connection"
                  , "Slack"
                  , "SourceTree"
                  , "SQL Server Management Studio"
                  , "SQL Server Profiler"
                  , "Steam"
                  , "Visual Studio Code"
                  , "Word" ] } )

Setup( { Options: [ { Left: 250, Top: 50, Stretch: True, Screens: [ { P: 1200, Dpi: 144 } ] }
                  , { Left: 450, Top: 50, Stretch: True, Screens: [ { P: 1440, Dpi: 192 }
                                                                  , { P: 1800, Dpi: 240 } ] } ]
       , Windows: [ "Defender"
                  , "Event Viewer"
                  , "Fiddler"
                  , "Hyper-V Manager"
                  , "Internet Information Services (IIS) Manager"
                  , "NVIDIA Control Panel"
                  , "Registry Editor"
                  , "Services"
                  , "SQL Server Configuration Manager"
                  , "SumatraPDF"
                  , "Task Scheduler"
                  , "Total Commander"
                  , "Settings" ] } )

Setup( { Options: [ { Left: 400, Top: 100, Stretch: True, Screens: [ { P: 1200, Dpi: 144 } ] }
                  , { Left: 650, Top: 150, Stretch: True, Screens: [ { P: 1440, Dpi: 192 }
                                                                   , { P: 1800, Dpi: 240 } ] } ]
       , Windows: [ { Class: "FM" } ; 7-Zip
                  , "Deluge"
                  , "Find Files" ; Total Commander
                  , "KeePass"
                  , "Lister" ; Total Commander
                  , "Multi-Rename Tool" ; Total Commander
                  , "Notepad"
                  , "OBS"
                  , "Rapid Environment Editor"
                  , "Resource Hacker"
                  , "Synchronize directories" ] } ) ; Total Commander

Setup( { Options: [ { Width: 1862, Height: 1079, Center: True, Max: True, Screens: [ { P: 1200, Dpi: 144 } ] }
                  , { Width: 2462, Height: 1289, Center: True, Max: True, Screens: [ { P: 1440, Dpi: 192 } ] }
                  , { Width: 3074, Height: 1567, Center: True, Max: True, Screens: [ { P: 1800, Dpi: 240 } ] } ]
       , Windows: [ "GVIM" ] } )

Setup( { Options: [ { Width: 1568, Height: 876, Right: 50, Bottom: 50, Screens: [ { P: 1200, Dpi: 144 } ] }
                  , { Width: 2080, Height: 1141, Right: 50, Bottom: 50, Screens: [ { P: 1440, Dpi: 192 } ] }
                  , { Width: 2595, Height: 1408, Right: 50, Bottom: 50, Screens: [ { P: 1800, Dpi: 240 } ] } ]
       , Windows: [ { Class: "VirtualConsoleClass", FixOnOpen: False } ] } ) ; ConEmu

Setup( { Options: [ { Width: 2600, Height: 1450, Right: 50, Bottom: 50, Screens: [ { P: 1800, Dpi: 240 } ] } ]
       , Windows: [ "Hyper" ] } )

Setup( { Options: [ { Width: 1000, Height: 900, Right: 50, Bottom: 50, Screens: [ { P: 1200, Dpi: 144 } ] }
                  , { Width: 1350, Height: 1150, Right: 50, Bottom: 50, Screens: [ { P: 1440, Dpi: 192 } ] }
                  , { Width: 1700, Height: 1400, Right: 50, Bottom: 50, Screens: [ { P: 1800, Dpi: 240 } ] } ]
       , Windows: [ "Task Manager" ] } )

Setup( { Options: [ { Left: 50, Top: 50, Stretch: True, Max: True, Screens: [ { P: 1440, Dpi: 192 } ] } ]
       , Windows: [ "Blizzard App"
                  , "Galaxy"
                  , "Origin"
                  , "Uplay" ] } )

Setup( { Options: [ { Width: 660, Height: 1000, Right: 50, Bottom: 50, Screens: [ { P: 1440, Dpi: 192 } ] } ]
       , Windows: [ "Friends" ] } ) ; Blizzard App, GOG Galaxy, Steam

; Main

#SingleInstance force

SplitPath A_ScriptName,,,, fileName
Menu Tray, Icon, %fileName%.ico
SetTitleMatchMode 2
HotKey ^#o, FixOpenWindows
HotKey ^#w, FixActiveWindow
HotKey ^#c, CenterActiveWindow
InitShellHooks()
return

; Shell hooks

InitShellHooks() {
    Gui +LastFound +HwndWindowHwnd
    DllCall("RegisterShellHookWindow", UInt, WindowHwnd)
    msgNumber := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
    OnMessage(msgNumber, "HandleMessage")
}

HandleMessage(wParam, lParam) {
    if (wParam != 1) { ; HSHELL_WINDOWCREATED
        return
    }
    try {
        global _settings
        screen := GetPrimaryScreen()
        Sleep 1000
        window := GetActiveWindow()
        window.FixOnOpen := True
        Fix(_settings, screen, window)
    } catch e {
        MsgBox 48,, %e%
    }
}

; Labels

FixOpenWindows:
    try {
        global _settings
        screen := GetPrimaryScreen()
        windows := GetOpenWindows()
        for key, window in windows {
            Fix(_settings, screen, window)
        }
    } catch e {
        MsgBox 48,, %e%
    }
    return

FixActiveWindow:
    try {
        global _settings
        screen := GetPrimaryScreen()
        window := GetActiveWindow()
        Fix(_settings, screen, window)
    } catch e {
        MsgBox 48,, %e%
    }
    return

CenterActiveWindow:
    try {
        screen := GetPrimaryScreen()
        window := GetActiveWindow()
        Center(screen, window)
    } catch e {
        MsgBox 48,, %e%
    }
    return

; Functions

Setup(settingsChunk) {
    global _settings
    if (!_settings) {
        _settings := Object()
    }
    _settings.Insert(settingsChunk)
}

GetPrimaryScreen() {
    SysGet monitor, Monitor, %current%
    SysGet monitorWorkArea, MonitorWorkArea, %current%
    return { P: monitorBottom
        , Dpi: GetPrimaryScreenDpi()
        , Width: monitorWorkAreaRight - monitorWorkAreaLeft
        , Height: monitorWorkAreaBottom - monitorWorkAreaTop }
}

GetPrimaryScreenDpi() {
    ; Returns 96 (for 100%), 120, 144, 168, 192 (for 200%), 216, 240 (for 250%)...
    RegRead dpi, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
    return (ErrorLevel = 1) ? 96 : dpi
}

GetOpenWindows() {
    supported:= Object()
    WinGet all, List
    loop %all% {
        id := all%A_Index%
        WinGetTitle title, ahk_id %id%
        if (title != "" && title != "Microsoft Store" && title != "Program Manager" && title != "Settings") {
            WinGetClass class, ahk_id %id%
            supported.Insert(InitWindow(class, title))
        }
    }
    return supported
}

GetActiveWindow() {
    WinGetClass class, A
    WinGetTitle title, A
    return InitWindow(class, title)
}

InitWindow(class, title) {
    return { Class: class, Title: title }
}

Fix(settings, screen, window) {
    options := FindMatch(settings, screen, window)
    if (!options) {
        return
    }
    window := MeasureWindow(window)
    RestoreWindow(window)
    MoveWindow(screen, options, window)
    if (options.Center) {
        window := MeasureWindow(window)
        CenterWindow(screen, window)
    }
    if (options.Max) {
        MaximizeWindow(window)
    }
}

Center(screen, window) {
    window := MeasureWindow(window)
    RestoreWindow(window)
    window := MeasureWindow(window)
    CenterWindow(screen, window)
}

FindMatch(settings, screen, window) {
    for key, group in settings {
        for key, windowInConfig in group.Windows {
            if (WindowMatchesConfig(window, windowInConfig)) {
                for key, options in group.Options {
                    for key, screenInConfig in options.Screens {
                        if (ScreenMatchesConfig(screen, screenInConfig)) {
                            return options
                        }
                    }
                }
            }
        }
    }
}

WindowMatchesConfig(windowOnScreen, windowInConfig) {
    if (windowOnScreen.FixOnOpen && !windowInConfig.FixOnOpen) {
        return False
    }
    if (windowInConfig.Class && windowInConfig.Title) {
        return windowOnScreen.Class == windowInConfig.Class && InStr(windowOnScreen.Title, windowInConfig.Title) > 0
    } else if (windowInConfig.Class) {
        return windowOnScreen.Class == windowInConfig.Class
    } else {
        return InStr(windowOnScreen.Title, windowInConfig.Title ? windowInConfig.Title : windowInConfig) > 0
    }
}

ScreenMatchesConfig(actualScreen, screen) {
    return actualScreen.P == screen.P && actualScreen.Dpi == screen.Dpi
}

MeasureWindow(window) {
    title := window.Title
    class := window.Class
    WinGetPos x, y, width, height, %title% ahk_class %class%
    window.Left := x
    window.Top := y
    window.Width := width
    window.Height := height
    return window
}

RestoreWindow(window) {
    title := window.Title
    class := window.Class
    WinRestore %title% ahk_class %class%
}

MaximizeWindow(window) {
    title := window.Title
    class := window.Class
    WinMaximize %title% ahk_class %class%
}

CenterWindow(screen, window) {
    title := window.Title
    class := window.Class
    WinMove %title% ahk_class %class%,, (screen.Width / 2) - (window.Width / 2), (screen.Height / 2) - (window.Height / 2)
}

MoveWindow(screen, options, window) {
    if (!options.Left) {
        options.Left := -options.Right
    }
    if (!options.Top) {
        options.Top := -options.Bottom
    }
    options.Width := GetSize(options.Width, window.Width, screen.Width, options.Left, options.Right, options.Stretch)
    options.Height := GetSize(options.Height, window.Height, screen.Height, options.Top, options.Bottom, options.Stretch)
    options.Left := GetMargin(options.Left, window.Left, options.Width, screen.Width)
    options.Top := GetMargin(options.Top, window.Top, options.Height, screen.Height)
    title := window.Title
    class := window.Class
    WinMove %title% ahk_class %class%,, options.Left, options.Top, options.Width, options.Height
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

Contains(list, item) {
    for key, value in list {
        if (value == item) {
            return True
        }
    }
    return False
}
