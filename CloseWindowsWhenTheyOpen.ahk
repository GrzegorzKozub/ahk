; Main                        

loop {
   CloseWindow( { Text: "" } )
} 
return

; Functions

CloseWindow(criteria) {
    if (criteria.Title && criteria.Text) {
        WinWait % criteria.Title, % criteria.Text, 1
        if (ErrorLevel == 0) {
            WinClose % criteria.Title, % criteria.Text
        }
    } else if (criteria.Title) {
        WinWait % criteria.Title,, 1
        if (ErrorLevel == 0) {
            WinClose % criteria.Title
        }
    } else {
        WinWait,, % criteria.Text, 1
        if (ErrorLevel == 0) {
            WinClose,, % criteria.Text
        }
    }
}
