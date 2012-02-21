"" Basic behaviour

set nocompatible        "choose no compatibility with legacy vi
set encoding=utf-8
set noswapfile          "disable swapfiles
set hidden              "hide buffers when not displayed

"undofiles configuration
set undodir=~/.vim/undofiles
set undofile

"commandline configuration
set showcmd                 "display incomplete commands
set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable C-n and C-p to scroll through matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

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

"" Handling whitespaces

set expandtab       "use spaces for tabs and set it to 4 spaces
set tabstop=4 shiftwidth=4      "4 spaces is a tab
set nowrap          "dont wrap lines
set backspace=indent,eol,start  "backspace through everything in insert mode

"" Searching

set hlsearch        "highlight search by default
set incsearch       "incremental search
set ignorecase      "ignore cases while searching
set smartcase       "consider case for search patterns with uppercase letters

"" Mappings

set pastetoggle=<F6> "toggle paste mode with <F6>
"<C-l> - Clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
"`#` should follow neighbouring indentation
inoremap # X<BS>#


"" Auto execution commands

autocmd VimEnter * set vb t_vb=""   "disable beeping and flashing

"spell check for text, mail, commit files
autocmd filetype markdown,mail,svn,*commit* setlocal spell
