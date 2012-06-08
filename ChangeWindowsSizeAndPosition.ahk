; Settings

_settings := [ Join

    , { Options: { Width: 1750, Height: 1000, LoResAutofit: True, Max: True, LoResMax: True, Center: True }
      , Windows: [ "Blend"
                 , "Microsoft SQL Server Management Studio"
                 , "Microsoft Visual Studio" ] }

    , { Options: { Width: 1500, Height: 1000, LoResAutofit: True, LoResMax: True, Center: True }
      , Windows: [ "Adobe Reader"
                 , "BareTail"
                 , "Beyond Compare"
                 , "Git Gui"
                 , "Google Chrome"
                 , "JetBrains dotPeek"
                 , "Kindle for PC"
                 , "LINQPad"
                 , "Microsoft Excel"
                 , "Microsoft FxCop"
                 , "Microsoft OneNote"
                 , "Microsoft Outlook"
                 , "Microsoft PowerPoint"
                 , "Microsoft Visio"
                 , "Microsoft Word"
                 , "Mozilla Firefox"
                 , "NUnit"
                 , "Paint.NET"
                 , "Picasa"
                 , "SQL Server Profiler"
                 , "SumatraPDF"
                 , "Windows Internet Explorer"
                 , "WinMerge"
                 , "XPS Viewer" ] }

    , { Options: { Width: 1317, Height: 934, LoResHeight: 801, Center: True }
      , Windows: [ "GVIM"
                 , "Notepad++" ] }

    , { Options: { Width: 1200, Height: 850, Center: True }
      , Windows: [ "iTunes"
                 , "Origin"
                 , "Steam" ] }

    , { Options: { Width: 1075, Height: 775, Left: 25, Top: 25 }
      , Windows: [ "Total Commander" ] }

    , { Options: { Width: 1003, Height: 793, Right: 25, Bottom: 25 }
      , Windows: [ "Console" ] }

    , { Options: { Width: 925, Height: 800, Center: True }
      , Windows: [ " - Appointment"
                 , " - Contact"
                 , " - Meeting"
                 , " - Message"
                 , " - Task" ] }

    , { Options: { Width: 900, Height: 830, Right: 25, Bottom: 25 }
      , Windows: [ "foobar2000" ] }

    , { Options: { Width: 900, Height: 600, Center: True }
      , Windows: [ { Title: "C:\Users\", Except: "Notepad" } ; 7-Zip
                 , "InfraRecorder"
                 , "Internet Information Services (IIS) Manager"
                 , "KeePass Password Safe"
                 , { Title: "Notepad", Except: "Notepad++" } ; also handles Notepad2
                 , "Rapid Environment Editor"
                 , "Registry Editor"
                 , "Resource Hacker"
                 , "Sql Server Configuration Manager"
                 , "VLC media player"
                 , "WinRAR"
                 , "µTorrent" ] }

    , { Options: { Width: 750, Height: 500, Center: True }
      , Windows: [ "Manage Stickies"
                 , "SyncBackPro"
                 , "WinSnap" ] } ; does not work

    , { Options: { Width: 450, Height: 500, Center: True }
      , Windows: [ ", " ; Lync
                 , "Group Conversation" ] } ; Lync

    , { Options: { Width: 420, Height: 460, Right: 25, Bottom: 25 }
      , Windows: [ "Windows Task Manager" ] }

    , { Options: { Width: 300, Height: 600, Right: 25, Bottom: 25 }
      , Windows: [ "Friends" ; Steam
                 , "Microsoft Lync"
                 , "Miranda IM" ] }

    , { Options: { Center: True }
      , Windows: [ "Apple QuickTime"
                 , "BRISS - BRight Snippet Sire"
                 , "C:\Windows\System32\cmd.exe"
                 , "Calculator"
                 , "Catalyst Control Center"
                 , "Command Prompt"
                 , "IrfanView"
                 , "Microsoft Security Essentials"
                 , "Piriform Defraggler"
                 , "Shotty"
                 , "Stickies"
                 , "Web Platform Installer" ] } ]

; Main

SetTitleMatchMode 2
HotKey #i, FixDesktopIcons
HotKey #w, FixWindows
HotKey #a, FixActiveWindow
HotKey #c, CenterActiveWindow
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
    For key, group In settings {
        autofit := (_screen.LoRes && group.Options.LoResAutofit) || group.Options.Autofit
        For key, window In group.Windows {
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
        SysGet, monitor, MonitorPrimary
    }
    SysGet workArea, MonitorWorkArea, %monitor%
    return { Width: workAreaRight - workAreaLeft, Height: workAreaBottom - workAreaTop, LoRes: (workAreaRight - workAreaLeft) <= 1600 }
}
