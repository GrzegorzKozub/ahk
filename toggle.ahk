#MaxThreadsPerHotkey 1
#SingleInstance force

windowTitle = %1%
if (windowTitle == "") {
  ExitApp
}

SetTitleMatchMode 2

#If WinActive(windowTitle)

  *RButton Up::
    if (toggle := !toggle) {
      Send { Click Down Right }
    } else {
      Send { RButton Up }
    }
    return

#If

