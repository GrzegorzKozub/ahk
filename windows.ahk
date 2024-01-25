; https://www.autohotkey.com/docs/v2/

#NoTrayIcon
#SingleInstance Force

HotKey "^#o", fixAll
HotKey "^#w", fixActive
HotKey "^#c", centerActive
HotKey "^#f", tileFullActive

init

init() {
  global config := []
  addConfig(big, [
    { title: "Brave" },
    { title: "DevTools" }, ; Brave
    { title: "Edge" },
    { title: "Microsoft Visual Studio" },
    { title: "NTLite" },
    { title: "Remote Desktop Connection" },
    { title: "SQL Server Management Studio" },
    { title: "SQL Server Profiler" },
    { title: "Visual Studio Code" },
  ])
  addConfig(bigMedium, [
    { title: "Steam" },
  ])
  addConfig(medium, [
    { title: "AMD Software" },
    { title: "Event Viewer" },
    { title: "Firewall" },
    { title: "HxD" },
    { title: "Intel® Graphics Command Center" },
    { title: "Microsoft Store" },
    { title: "NVIDIA Control Panel" },
    { title: "Obsidian" },
    { title: "Paint" },
    { title: "paint.net" },
    { title: "Photos" },
    { title: "Registry Editor" },
    { title: "Services" },
    { title: "SQL Server Configuration Manager" },
    { title: "Settings" },
    { title: "SumatraPDF" },
    { title: "Task Scheduler" },
    { title: "Total Commander" },
    { title: "Windows Security" },
  ])
  addConfig(mediumSmall, [
    { title: "Cemu" },
    { title: "yuzu" },
  ])
  addConfig(small, [
    { title: "curve editor" }, ; Afterburner
    { title: "Find Files" }, ; Total Commander
    { class: "FM" }, ; 7-Zip
    { title: "hardware monitor" }, ; Afterburner
    { title: "HWiNFO64" },
    { title: "KeePassXC" },
    { title: "Lister" }, ; Total Commander
    { title: "LockHunter" },
    { title: "Multi-Rename Tool" }, ; Total Commander
    { title: "Notepad" },
    { title: "OBS" },
    { title: "Partition Expert" },
    { title: "qBittorrent" },
    { title: "Resource Hacker" },
    { title: "Synchronize directories" }, ; Total Commander
    { title: "Task Manager" },
  ])
}

addConfig(fix, size) {
  for cfg in size {
    cfg.fix := fix.Bind()
    config.Push cfg
  }
}

fixAll(*) {
  for hwnd in WinGetList(,, "Program Manager")
    fix hwnd
}

fixActive(*) => fix(WinGetID("A"))

centerActive(*) {
  WinWait WinGetID("A")
  desktop := getDesktop()
  WinRestore
  WinGetPos(,, &width, &height)
  WinMove desktop.width / 2 - width / 2, desktop.height / 2 - height / 2, width, height
}

tileFullActive(*) {
  WinWait WinGetID("A")
  tileFull
}

fix(hwnd) {
  cfg := findConfig(hwnd)
  if cfg {
    WinWait hwnd ; https://www.autohotkey.com/docs/v2/misc/WinTitle.htm#LastFoundWindow
    cfg.fix.Call()
  }
}

findConfig(hwnd) {
  class := WinGetClass(hwnd), title := WinGetTitle(hwnd)
  for cfg in config
    if HasProp(cfg, "class") && RegExMatch(class, cfg.class) || HasProp(cfg, "title") && RegExMatch(title, cfg.title)
      return cfg
}

big() => onUhd() ? center(12, 14) : center(14, 14.5)
bigMedium() => onUhd() ? center(10.5, 13) : center(13, 13.5)
medium() => onUhd() ? center(9, 12) : center(12, 12.5)
mediumSmall() => onUhd() ? center(7.5, 11) : center(11, 11.5)
small() => onUhd() ? center(6, 10) : center(10, 10.5)

onUhd() {
  MonitorGet getMonitor(), &left, &top, &right, &bottom
  return right - left = 3840 && bottom - top = 2160
}

center(width, height) => move(getCenterTile(width, height))

getCenterTile(width, height) {
  static step := 16
  desktop := getDesktop()
  return tile(
    ((desktop.width / step) * ((step - width) / 2)) + desktop.x, 
    ((desktop.height / step) * ((step - height) / 2)) + desktop.y,
    (desktop.width / step) * width,
    (desktop.height / step) * height,
  )
}

tileFull() => move(getTiles().full)

getTiles() {
  static gap := 25, step := 2, master := 1
  desktop := getDesktop()
  xLeft := desktop.x + gap
  xRight := desktop.x + (desktop.width / step * master) + (gap * 0.5)
  yDown := desktop.y + (desktop.height / 2) + (gap * 0.5)
  yUp := desktop.y + gap
  widthFull := desktop.width - (gap * 2)
  widthLeft := (desktop.width / step * master) - (gap * 1.5)
  widthRight := (desktop.width / step * (step - master)) - (gap * 1.5)
  heightFull := (desktop.height) - (gap * 2)
  heightHalf := (desktop.height / 2) - (gap * 1.5)
  return {
    full: tile(xLeft, yUp, widthFull, heightFull),
    left: tile(xLeft, yUp, widthLeft, heightFull),
    right: tile(xRight, yUp, widthRight, heightFull),
    down: tile(xLeft, yDown, widthFull, heightHalf),
    up: tile(xLeft, yUp, widthFull, heightHalf),
    leftDown: tile(xLeft, yDown, widthLeft, heightHalf),
    leftUp: tile(xLeft, yUp, widthLeft, heightHalf),
    rightDown: tile(xRight, yDown, widthRight, heightHalf),
    rightUp: tile(xRight, yUp, widthRight, heightHalf),
  }
}

move(tile) {
  WinRestore
  WinMove tile.x, tile.y, tile.width, tile.height
}

getDesktop() {
  MonitorGetWorkArea getMonitor(), &left, &top, &right, &bottom
  return { x: left, y: top, width: right - left, height: bottom - top }
}

getMonitor() {
  try {
    static MONITOR_DEFAULTTONEAREST := 2
    monitorHandle := DllCall("MonitorFromWindow", "Ptr", WinGetID(), "UInt", MONITOR_DEFAULTTONEAREST, "Ptr")
    NumPut("UInt", 104, monitorInfo := Buffer(104))
    if (DllCall("GetMonitorInfo", "Ptr", monitorHandle, "Ptr", monitorInfo)) {
      return RegExReplace(StrGet(monitorInfo.Ptr + 40, 32), ".*(\d+)$", "$1")
    } else {
      return MonitorGetPrimary()
    }
  } catch {
    return MonitorGetPrimary()
  }
}

tile(x, y, width, height) => { x: x, y: y, width: width, height: height }

