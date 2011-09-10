﻿; Main                        

loop {
   CloseWindow( { Title: "Information" } )
   CloseWindow( { Text: "Na pytanie o instalacje odpowiedz TAK." } )
   CloseWindow( { Text: "Błąd wczytania danych z" } )
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
