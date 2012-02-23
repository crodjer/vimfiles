"" Basic behaviour

set nocompatible        "choose no compatibility with legacy vi

"activate pathogen
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

set encoding=utf-8
set noswapfile          "disable swapfiles
set hidden              "hide buffers when not displayed
set textwidth=80        "maximum width of text that can be inserted
set nofoldenable        "dont fold by default

"undofiles configuration
set undodir=~/.vim/undofiles
set undofile

"commandline configuration
set showcmd                 "display incomplete commands
set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable C-n and C-p to scroll through matches
"stuff to ignore when tab completing
set wildignore=*.o,*~,*.pyc,*.hi

"" Looks

set t_Co=256            "force 256 colours
colorscheme xoria256    "nice dark colorscheme
set background=dark
set colorcolumn=+1      "mark the ideal max text width
set rnu                 "show line numbers
set showmode            "show current mode down the bottom

"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

"" Indentation and syntax highlighting

syntax enable
filetype plugin on
filetyp plugin on
set autoindent
set smartindent

"open parameter indentation settings
let g:pyindent_open_paren = '&sw'
let g:pyindent_continue = '&sw'
set cinoptions+=+1

"" Handling whitespaces

set expandtab                   "use spaces for tabs and set it to 4 spaces
"4 spaces is a tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set nowrap                      "dont wrap lines
set backspace=indent,eol,start  "backspace through everything in insert mode

"" Searching

set hlsearch        "highlight search by default
set incsearch       "incremental search
set ignorecase      "ignore cases while searching
set smartcase       "consider case for search patterns with uppercase letters

"" Mappings

"explorer mappings
nnoremap <F1> :BufExplorer<CR>
nnoremap <F3> :TlistToggle<CR>
set pastetoggle=<F6>            "toggle paste mode with <F6>
"<C-l> - Clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
"`#` should follow neighbouring indentation
inoremap # X<BS>#


"" Auto execution commands

autocmd VimEnter * set vb t_vb=""   "disable beeping and flashing

"spell check for text, mail, commit files
autocmd filetype markdown,mail,svn,*commit* setlocal spell

"" Status Line

set statusline=%f       "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag

set statusline+=%{fugitive#statusline()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%{StatuslineLongLineWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"disable beeping and flashing
autocmd VimEnter * set vb t_vb=""

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

"" Plugin configurations

"vim-pad
let g:pad_dir = "~/workspace/notes/"

"syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2
let g:syntastic_python_checker='pylint'

"taglist settings
let Tlist_Enable_Fold_Column = 0
let Tlist_Exit_OnlyWindow = 0
let Tlist_WinWidth = 35
let Tlist_Use_Right_Window=1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Display_Tag_Scope = 1
let Tlist_Process_File_Always = 1
let Tlist_Show_One_File = 1
