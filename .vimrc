
"call plug#begin()
""
"" Status bar
"Plug 'bling/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

"" Commenting
"Plug 'scrooloose/nerdcommenter'
"Plug 'tpope/vim-commentary'

"" Copy paste
"Plug 'roxma/vim-tmux-clipboard'

"" Git
"Plug 'tpope/vim-fugitive'

"" Files
"Plug '/usr/local/opt/fzf'
"Plug 'junegunn/fzf.vim'
"Plug 'jremmen/vim-ripgrep'

"" Colors
"Plug 'flazz/vim-colorschemes'

"" Tmux complete Vim plugin for insert mode completion of words in adjacent tmux panes
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'wellle/tmux-complete.vim'

"" Moving across file
"Plug 'easymotion/vim-easymotion'
"Plug 'justinmk/vim-sneak'

"" Syntax
"Plug 'Raimondi/delimitMate'
"Plug 'tpope/vim-surround'
"Plug 'dense-analysis/ale'
"Plug 'vim-syntastic/syntastic'
"Plug 'tmux-plugins/vim-tmux'

"" Tips
""Plug 'openuado/vimtips-fortune'

call plug#end()

" Leader shortcut
:let mapleader=","		" leader is coma

" Copy paste vim to macOS clipboard
set clipboard=unnamed


" -- Keybinds --
"  key ',' + 'f' to navigate between buffers"
nnoremap <Leader>f :set nomore<Bar>:ls<Bar>:set more<CR>:b<Space>
"  CTRL + h for previous buffer
:nnoremap <C-h> :bp<CR>
"  CTRL + l for next buffer
:nnoremap <C-l> :bn<CR>
"  CTRL + x for delete current buffer
:nnoremap <C-x> :bd<CR>
" undo highlight of research
:nnoremap <Leader><space> :noh<CR>
"remap ctrl j and k to move half page up and down"
:nnoremap <C-j> <C-d>
:nnoremap <C-k> <C-u>
"relaoad vimrc"
:nnoremap <leader>s :source $MYVIMRC<CR>
"save all buffers"
:nmap <Leader>w :wa<CR>
"quit buf"
:nmap <Leader>q :q<CR>
"save all buffers and quit
:nmap <Leader>x :xa<CR>
"disable arrows
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
" Make j and k move to the next row, not file line (ex : lines > 80)
nnoremap j gj
nnoremap k gk
" Keep search results at the center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" use ctrl + l to del next char
imap <C-L> <DEL>


" Watch file changes on filesystem
set autoread
"set an undo dir and enable undofile to have history of undo after closing buf
set undodir=~/.config/nvim/undo_dir
set undofile
" Spaces and tabs
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set switchbuf=usetab
:set smartindent
:set incsearch "hiligh researches while typing"
:set title
:set hlsearch
:set smartcase
:set hlsearch	" Enable search highlighting.
:set ignorecase	" Ignore case when searching.
:set incsearch	" Incremental search that shows partial matches.
:set smartcase	" Automatically switch search to case-sensitive
:set lazyredraw	" Don’t update screen during macro and script execution.
:set cc=80
"":set columns=90
:set textwidth=80
:set list
"":set expandtab
:set display+=lastline " Always try to show a paragraph’s last line.
:set encoding=utf-8 " Use an encoding that supports unicode.
:set linebreak " Avoid wrapping a line in the middle of a word.
:set scrolloff=1 " The number of screen lines to keep above and below the cursor.
:syntax enable " Enable syntax highlighting.
:set wrap " Enable line wrapping.
:set laststatus=2 " Always display the status bar.
:set ruler " Always show cursor position.
:set wildmenu " Display command line’s tab complete options as a menu.
:set cursorline " Highlight the line and col currently under cursor.
:set history=1000 " Increase the undo limit.
:set nomodeline " Ignore file’s mode lines; use vimrc configurations instead.
:set noswapfile " Disable swap files.
:set wildignore+=.o,.swp " Ignore files matching these patterns
:set backup " Fait une copie de sauvegarde lors de l'écrasement d'un fichier
:set backupdir=~/.config/nvim/backup " chmod 700"
":filetype plugin on
":filetype indent on
:set showmatch "highlight brackets
:set showcmd
:set wildmode=list:longest,list:full "auto completon in cmd line"
:set noequalalways " don't resize when new window is open"
:set splitright "add new window on the rigth"
" ## Vérification orthographique
" en français, 10 suggestions
":let loaded_vimspell = 1
":set spelllang=fr
":set spelllang=us
":set spellsuggest=10
":let spell_executable = "aspell"
":let spell_auto_type = ''
":let spell_insert_mode = 0

" ## ctags
" génération automatique pour les extensions connues
":let generate_tags=1
" affichage dans la statusline
":let g:ctags_statusline=1

" ## Complétion par dictionnaire
" (Ctrl-x Ctrl-k)
:set dictionary+=/usr/share/dict/american-english
:set dictionary+=/usr/share/dict/french
":setlocal spell
":set spell " Enable spellchecking.
:set complete+=kspell
:set complete-=kspell
:set complete-=k
:set complete+=k
    
" UI Config
:set relativenumber
":set mouse=a
:set number

" Live replace
:set inccommand=split

" Set nasm syntax on
" set ft=nasm

let g:netrw_banner = 0

let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_usetab = 1
let g:netrw_winsize = 80
