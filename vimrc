"" Basic vim settings

"choose no compatibility with legacy vi
set nocompatible
"display incomplete commands
set showcmd
set encoding=utf-8
set noswapfile
"configure undofiles
set undodir=~/.vim/undofiles
set undofile
"hide buffers when not displayed
set hidden

"" Looks

set t_Co=256        "force 256 colours
colorscheme xoria256
set background=dark
set colorcolumn=+1  "mark the ideal max text width

""Indentation and syntax highlighting

syntax enable
filetype plugin on
filetyp plugin on

"" Handling whitespaces

set expandtab       "use spaces for tabs and set it to 4 spaces
set tabstop=4 shiftwidth=4 "4 spaces is a tab
set nowrap          "dont wrap lines
set backspace=indent,eol,start "backspace through everything in insert mode

"" Searching

set hlsearch        "highlight search by default
set incsearch       "incremental search
set ignorecase      "ignore cases while searching
set smartcase       "consider case for search patterns with uppercase letters

"" Mappings
set pastetoggle=<F6> "toggle paste mode with <F6>
"<C-l> - Clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>    
"don't move lines starting by `#` to first column
inoremap # X<BS>#


"" Auto execution commands
"disable beeping and flashing
autocmd VimEnter * set vb t_vb=""
"spell check for text, mail, commit files
autocmd filetype markdown,mail,svn,*commit* setlocal spell
