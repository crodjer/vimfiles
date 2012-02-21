"" GUI components

"a - make visually highlighted text available for pasting in X
"c - use console dialogs instead of irritating popup dialogs
"i - use vim icon
set guioptions=aci

"" Behaviour

set anti            "turn on antialiasing
"always show tabs
set showtabline=2 

"function to save  session on unfocus
function! SaveSessionOnUnfocus()
    SaveSession
endfunction
au FocusLost * call SaveSessionOnUnfocus()
