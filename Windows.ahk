; Settings

Setup( { Options: [ { Left: 50, Top: 50, Stretch: True, Max: True, Screens: [ { P: 1800, Dpi: 240 } ] }
                  , { Left: 400, Top: 50, Stretch: True, Screens: [ { P: 2160, Dpi: 192 } ] }
                  , { Left: 50, Top: 50, Stretch: True, Max: True, Screens: [ { P: 1080, Dpi: 96 } ] }
                  , { Left: 50, Top: 50, Stretch: True, Max: True, Screens: [ { P: 1440, Dpi: 192 } ] } ]
       , Windows: [ "BareTail"
                  , { Title: "DevTools", Push: True } ; Chrome
                  , "dotPeek"
                  , "Edge"
                  , "Excel"
                  , "Google Chrome"
                  , "Inkscape"
                  , "Microsoft Azure Storage Explorer"
                  , "Microsoft Visual Studio"
                  , { Title: "OneNote", Push: True }
                  , { Title: "Outlook", Push: True }
                  , "paint.net"
                  , "Pluralsight"
                  , "Postman"
                  , "PowerPoint"
                  , { Title: "Remote Desktop Connection", Push: True }
                  , { Title: "Slack", Push: True }
                  , { Title: "SourceTree", Push: True }
                  , "SQL Server Management Studio"
                  , "SQL Server Profiler"
                  , { Title: "Teams", Push: True }
                  , { Class: "Chrome_WidgetWin_1" } ; Termnius
                  , "Visual Studio Code"
                  , "Word" ] } )

Setup( { Options: [ { Width: 700, Height: 900, Right: 50, Bottom: 50, Screens: [ { P: 1800, Dpi: 240 } ] }
                  , { Left: 550, Top: 150, Stretch: True, Screens: [ { P: 2160, Dpi: 192 } ] } ]
       , Windows: [ "Battle.net"
                  , "Epic Games"
                  , "Galaxy"
                  , "Rockstar Games"
                  , "Steam"
                  , "Uplay" ] } )

Setup( { Options: [ { Left: 450, Top: 50, Stretch: True, Screens: [ { P: 1800, Dpi: 240 } ] }
                  , { Left: 750, Top: 250, Stretch: True, Screens: [ { P: 2160, Dpi: 192 } ] }
                  , { Left: 250, Top: 50, Stretch: True, Screens: [ { P: 1080, Dpi: 96 } ] }
                  , { Left: 250, Top: 50, Stretch: True, Screens: [ { P: 1440, Dpi: 192 } ] } ]
       , Windows: [ { Title: "Event Viewer", Push: True }
                  , "Fiddler"
                  , { Title: "Hyper-V Manager", Push: True }
                  , "Intel® Graphics Command Center"
                  , { Title: "Internet Information Services (IIS) Manager", Push: True }
                  , "Microsoft Store"
                  , "NVIDIA Control Panel"
                  , "Registry Editor"
                  , { Title: "Services", Push: True }
                  , { Title: "SQL Server Configuration Manager", Push: True }
                  , "Settings"
                  , "SumatraPDF"
                  , { Title: "Task Scheduler", Push: True }
                  , "Total Commander"
                  , "Virtual Machine Manager"
                  , "Windows Security" ] } )

Setup( { Options: [ { Left: 650, Top: 150, Stretch: True, Screens: [ { P: 1800, Dpi: 240 } ] }
                  , { Left: 1150, Top: 450, Stretch: True, Screens: [ { P: 2160, Dpi: 192 } ] }
                  , { Left: 450, Top: 150, Stretch: True, Screens: [ { P: 1080, Dpi: 96 } ] }
                  , { Left: 450, Top: 150, Stretch: True, Screens: [ { P: 1440, Dpi: 192 } ] } ]
       , Windows: [ "4K Video Downloader"
                  , { Class: "FM" } ; 7-Zip
                  , "Deluge"
                  , "Find Files" ; Total Commander
                  , "KeePass"
                  , "Lister" ; Total Commander
                  , "Multi-Rename Tool" ; Total Commander
                  , "Notepad"
                  , "OBS"
                  , "Rapid Environment Editor"
                  , { Class: "rctrl_renwnd32" } ; Outlook
                  , "Resource Hacker"
                  , "Synchronize directories" ; Total Commander
                  , "Task Manager" ] } )

Setup( { Options: [ { Width: 3082, Height: 1607, Center: True, Max: True, Screens: [ { P: 1800, Dpi: 240 } ] }
                  , { Width: 2506, Height: 1431, Left: 50, Top: 50, Screens: [ { P: 2160, Dpi: 192 } ] }
                  , { Width: 1266, Height: 761, Left: 25, Top: 25, Screens: [ { P: 1080, Dpi: 96 } ] }
                  , { Width: 2458, Height: 1249, Center: True, Max: True, Screens: [ { P: 1440, Dpi: 192 } ] } ]
       , Windows: [ "GVIM"
                  , "Neovim" ] } )

Setup( { Options: [ { Width: 3071, Height: 1548, Center: True, Max: True, Screens: [ { P: 1800, Dpi: 240 } ] }
                  , { Width: 2550, Height: 1459, Right: 50, Bottom: 50, Screens: [ { P: 2160, Dpi: 192 } ] }
                  , { Width: 1403, Height: 724, Right: 25, Bottom: 25, Screens: [ { P: 1080, Dpi: 96 } ] }
                  , { Width: 2455, Height: 1269, Center: True, Max: True, Screens: [ { P: 1440, Dpi: 192 } ] } ]
       , Windows: [ { Class: "VirtualConsoleClass" } ] } ) ; ConEmu

; Main

#NoTrayIcon
#SingleInstance force

SetTitleMatchMode 2
HotKey ^#o, FixOpenWindows
HotKey ^#w, FixActiveWindow
HotKey ^#c, CenterActiveWindow
HotKey ^#p, PushActiveWindow
;InitShellHooks()
return

; Shell hooks

InitShellHooks() {
    ; Enables support for FixOnOpen
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
        screen := GetCurrentScreen()
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
        screen := GetCurrentScreen()
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
        screen := GetCurrentScreen()
        window := GetActiveWindow()
        Fix(_settings, screen, window)
    } catch e {
        MsgBox 48,, %e%
    }
    return

CenterActiveWindow:
    try {
        screen := GetCurrentScreen()
        window := GetActiveWindow()
        Center(screen, window)
    } catch e {
        MsgBox 48,, %e%
    }
    return

PushActiveWindow:
    try {
        screen := GetCurrentScreen()
        window := GetActiveWindow()
        Push(screen, window)
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

GetCurrentScreen() {
    SysGet monitor, Monitor, %current%
    SysGet monitorWorkArea, MonitorWorkArea, %current%
    screen := { Dpi: GetCurrentScreenDpi()
        , Width: monitorWorkAreaRight - monitorWorkAreaLeft
        , Height: monitorWorkAreaBottom - monitorWorkAreaTop
        , P: monitorBottom }
    if (Debug()) {
        MsgBox % "Dpi: " . screen.Dpi . ", Width: " . screen.Width . ", Height: " . screen.Height . ", P: " . screen.P 
    }
    return screen
}

GetCurrentScreenDpi() {
    output := Execute("screen.exe")
    RegExMatch(output, """dpi"": (\d+)", match)
    return %match1%
}

Execute(command) {
    tempFile := A_Temp . "\" . A_ScriptName . ".txt"
    ComObjCreate("WScript.Shell").Run(ComSpec . " /c " . command . " > " . tempFile, 0, true)
    FileRead, output, %tempFile%
    FileDelete, %tempFile%
    return output
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
    if (options.Push) {
        Push(screen, window)
    }
}

Center(screen, window) {
    window := MeasureWindow(window)
    RestoreWindow(window)
    window := MeasureWindow(window)
    CenterWindow(screen, window)
}

Push(screen, window) {
    ; Pushes the window to the screen on the right
    ; Assumes all screen resolutions and DPI are the same
    SysGet monitorCount, MonitorCount
    if (monitorCount < 2) {
        return
    }
    max := IsWindowMaximized(window)
    if (max) {
        RestoreWindow(window)
    }
    window := MeasureWindow(window)
    left := window.Left < screen.Width ? screen.Width + window.Left : window.Left
    PushWindow(window, left, window.Top)
    if (max) {
        MaximizeWindow(window)
    }
}

FindMatch(settings, screen, window) {
    for key, group in settings {
        for key, windowInConfig in group.Windows {
            if (WindowMatchesConfig(window, windowInConfig)) {
                for key, options in group.Options {
                    for key, screenInConfig in options.Screens {
                        if (ScreenMatchesConfig(screen, screenInConfig)) {
                            options.Push := windowInConfig.Push
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

IsWindowMaximized(window) {
    title := window.Title
    class := window.Class
    WinGet minMax, MinMax, %title% ahk_class %class%
    return minMax == 1 ? True : False
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

PushWindow(window, left, top) {
    title := window.Title
    class := window.Class
    WinMove %title% ahk_class %class%,, left, top
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

Debug() {
    if (A_Args[1] == "debug") {
        return true
    } else {
        return false
    }
}
