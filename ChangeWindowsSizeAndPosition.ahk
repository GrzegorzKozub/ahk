; Settings

_settings := [ Join

    , { Options: { Width: 1650, Height: 1000, LoResAutofit: True, Max: True, LoResMax: True, Center: True }
      , Windows: [ "Microsoft SQL Server Management Studio"
                 , "Microsoft WebMatrix"
                 , "Microsoft Visual Studio" ] }

    , { Options: { Width: 1636, Height: 984, LoResAutofit: True, Center: True }
      , Windows: [ "GVIM" ] }

    , { Options: { Width: 1500, Height: 1000, LoResAutofit: True, LoResMax: True, Center: True }
      , Windows: [ "BareTail"
                 , "Console"
                 , "Developer Tools" ; Chrome
                 , "Edge"
                 , "Excel"
                 , "F12" ; Internet Explorer
                 , "Git Gui"
                 , { Title: "Google Chrome", Except: "Task Manager - Google Chrome" }
                 , "JetBrains dotPeek"
                 , { Title: "Mozilla Firefox", Except: "Source of"}
                 , "paint.net"
                 , "PowerPoint"
                 , "Remote Desktop Connection"
                 , "SourceTree"
                 , "SQL Server Profiler"
                 , "SumatraPDF"
                 , "Visio"
                 , "Internet Explorer"
                 , "Word" ] }

    , { Options: { Width: 1300, Height: 900, LoResAutofit: True, LoResMax: True, Center: True }
      , Windows: [ "Spotify"
                 , "Steam" ] }

    , { Options: { Width: 1200, Height: 850, LoResAutofit: True, LoResMax: True, Center: True }
      , Windows: [ "Event Viewer"
                 , "Fiddler Web Debugger"
                 , "Hyper-V Manager"
                 , "Internet Information Services (IIS) Manager"
                 , "LOOT"
                 , "Mod Organizer"
                 , "NVIDIA Control Panel"
                 , "Source of" ; Firefox
                 , "Task Scheduler"
                 , "Total Commander"
                 , "Settings"
                 , "WinSCP" ] } ]

_settings := Concatenate(_settings, [ Join

    , { Options: { Width: 1013, Height: 779, Right: 25, Bottom: 25 }
      , Windows: [ "~" ] } ; ConEmu

    , { Options: { Width: 975, Height: 650, Center: True }
      , Windows: [ "WinSnap"
                 , "West Wind WebSurge" ] }

    , { Options: { Width: 900, Height: 830, Right: 25, Bottom: 25 }
      , Windows: [ "foobar2000" ] }

    , { Options: { Width: 900, Height: 900, Center: True }
      , Windows: [ "Skype"
                 , "Slack" ] }

    , { Options: { Width: 900, Height: 600, Center: True }
      , Windows: [ { Title: "C:\Users\", Except: "Notepad" } ; 7-Zip
                 , "Deluge"
                 , "Error Console" ; Firefox
                 , "KeePass"
                 , "Library" ; Firefox
                 , "Lister" ; Total Commander
                 , "Microsoft Service Trace Viewer"
                 , "Notepad"
                 , "Oracle VM VirtualBox Manager"
                 , "Rapid Environment Editor"
                 , "Registry Editor"
                 , "Resource Hacker"
                 , "Scratchpad" ; Firefox
                 , "Style Editor" ; Firefox
                 , "VLC media player"
                 , "WinRAR" ] }

    , { Options: { Width: 700, Height: 800, Center: True }
      , Windows: [ "Todoist" ] }

    , { Options: { Width: 800, Height: 500, Center: True }
      , Windows: [ "SyncBackPro" ] }

    , { Options: { Width: 750, Height: 500, Center: True }
      , Windows: [ "Manage Stickies"
                 , "Task Manager - Google Chrome" ] }

    , { Options: { Width: 660, Height: 600, Right: 25, Bottom: 25 }
      , Windows: [ { Title: "Task Manager", Except: "Task Manager - Google Chrome" } ] }

    , { Options: { Width: 650, Height: 600, Center: True }
      , Windows: [ "Open Broadcaster Software" ] }

    , { Options: { Width: 600, Height: 600, Left: 200, Top: 200 }
      , Windows: [ "Service Bus MQ Manager" ] }

    , { Options: { Width: 420, Height: 460, Right: 25, Bottom: 25 }
      , Windows: [ "Windows Task Manager" ] }

    , { Options: { Width: 233, Height: 450, Right: 25, Bottom: 25 }
      , Windows: [ "Friends" ] } ; Steam

    , { Options: { Center: True }
      , Windows: [ "C:\Windows\System32\cmd.exe"
                 , "Calculator"
                 , "Command Prompt"
                 , "IrfanView"
                 , "Microsoft Security Essentials"
                 , "Stickies"
                 , "Web Platform Installer" ] } ] )

; Main

SplitPath A_ScriptName,,,, fileName
Menu Tray, Icon, %fileName%.ico
SetTitleMatchMode 2
HotKey ^#i, FixDesktopIcons
HotKey ^#w, FixWindows
HotKey ^#a, FixActiveWindow
HotKey ^#c, CenterActiveWindow
;OnMessage(0x219, "OnWmDeviceChange")
_screen := GetScreen()
return

; Labels

FixDesktopIcons:
    Run desktopcmd restore /y,, Hide
    return

FixWindows:
    _screen := GetScreen()
    Act(_settings)
    return

FixActiveWindow:
    _screen := GetScreen()
    WinGetActiveTitle activeWindowTitle
    Act(_settings, activeWindowTitle)
    return

CenterActiveWindow:
    _screen := GetScreen()
    WinGetActiveTitle title
    UpdateWindow(title, "", { Center: True })
    return

; Functions

OnWmDeviceChange(wParam, lParam, msg, hwnd) {
    Sleep 3000
    GoSub FixWindows
    GoSub FixDesktopIcons
}

Act(settings, filter = "") {
    global _screen
    for key, group in settings {
        autofit := (_screen.LoRes && group.Options.LoResAutofit) || group.Options.Autofit
        for key, window in group.Windows {
            title := window.Title ? window.Title : window
            except := window.Except ? window.Except : ""
            if (!filter || (InStr(filter, title) > 0 && (!except || InStr(filter, except) == 0))) {
                if (autofit) {
                    AutofitWindow(title, except, group.Options)
                } else {
                    UpdateWindow(title, except, group.Options)
                }
                if (filter) {
                    match := True
                    break
                }
            }
        }
        if (match) {
            match := False
            break
        }
    }
}

AutofitWindow(title, except, options) {
    global _screen
    if (!options.MarginWidth) {
        options.MarginWidth := 10
    }
    if (!options.MarginHeight) {
        options.MarginHeight := 2
    }
    if (!options.LoResMarginWidth) {
        options.LoResMarginWidth := 5
    }
    if (!options.LoResMarginHeight) {
        options.LoResMarginHeight := 1
    }
    marginWidth := _screen.LoRes ? options.LoResMarginWidth : options.MarginWidth
    marginHeight := _screen.LoRes ? options.LoResMarginHeight : options.MarginHeight
    horizontalMargin := Round(_screen.Width * (marginWidth / 100))
    verticalMargin := Round(_screen.Height * (marginHeight / 100))
    options.Left := horizontalMargin
    options.Top := verticalMargin
    options.Width := _screen.Width - 2 * horizontalMargin
    options.Height := _screen.Height - 2 * verticalMargin
    UpdateWindow(title, except, options)
}

UpdateWindow(title, except, options) {
    global _screen
    window := GetWindowPositionAndSize(title, except)
    if (!window) {
        return
    }
    loResLeft := options.LoResLeft ? options.LoResLeft : - options.LoResRight
    left := options.Left ? options.Left : - options.Right
    left := (_screen.LoRes && loResLeft) ? loResLeft : left
    loResTop := options.LoResTop ? options.LoResTop : - options.LoResBottom
    top := options.Top ? options.Top : - options.Bottom
    top := (_screen.LoRes && loResTop) ? loResTop : top
    width := (_screen.LoRes && options.LoResWidth) ? options.LoResWidth : options.Width
    height := (_screen.LoRes && options.LoResHeight) ? options.LoResHeight : options.Height
    center := (_screen.LoRes && options.LoResCenter) ? options.LoResCenter : options.Center
    max := (_screen.LoRes && options.LoResMax) ? options.LoResMax : options.Max
    SetWindowPositionAndSize(title, except, left, top, width, height, center, max)
    if (window.Minimized) {
        WinMinimize % title
    }
}

SetWindowPositionAndSize(title, except = "", left = "", top = "", width = "", height = "", center = False, max = False) {
    global _screen
    WinRestore %title%,, %except%
    window := GetWindowPositionAndSize(title, except)
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
    WinMove %title%,, %left%, %top%, %width%, %height%, %except%
    if (center) {
        WinMove %title%,, (_screen.Width / 2) - (width / 2), (_screen.Height / 2) - (height / 2),,, %except%
    }
    if (max) {
        WinMaximize %title%,, %except%
    }
}

GetWindowPositionAndSize(title = "", except = "") {
    if (!title) {
        WinGetActiveTitle title
    }
    WinGetPos x, y, width, height, %title%,, %except%
    if (!x) {
        return
    }
    WinGet minMax, MinMax, %title%,, %except%
    return { Left: x, Top: y, Width: width, Height: height, Maximized: minMax == 1, Minimized: minMax == -1 }
}

GetScreen(monitor = "") {
    if (!monitor) {
        SysGet monitor, MonitorPrimary
    }
    SysGet workArea, MonitorWorkArea, %monitor%
    return { Width: workAreaRight - workAreaLeft, Height: workAreaBottom - workAreaTop, LoRes: (workAreaRight - workAreaLeft) <= 1600 }
}

Concatenate(arrays*) {
    result := Object()
    for key, array in arrays {
        for key, element in array {
            result.Insert(element)
        }
    }
    return result
}

