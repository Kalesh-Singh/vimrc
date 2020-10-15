" BASIC SETUP:
" disable vi compatibility (emulation of old bugs)
set nocompatible

" Show filname
set title

" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces

" Detect and use existing file indentation IOW am i working on Linux kernel
function TabsOrSpaces()
    " Determines whether to use spaces or tabs on the current buffer.
    if getfsize(bufname("%")) > 256000
        " File is very large, just use the default.
        return
    endif

    let numTabs=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\t[^\\s]"'))
    let num4Spaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\s{4}[^\\s]"'))
    let num2Spaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\s{2}[^\\s]"'))

    if numTabs > num4Spaces && numTabs > num2Spaces
        setlocal shiftwidth=8
        setlocal tabstop=8
        setlocal noexpandtab
    elseif num2Spaces > num4Spaces
        setlocal shiftwidth=2
        setlocal tabstop=2
        setlocal expandtab
    else
        setlocal shiftwidth=4
        setlocal tabstop=4
        setlocal expandtab
    endif
endfunction

" Call the function after opening a buffer
autocmd BufReadPost * call TabsOrSpaces()

" wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
set textwidth=120

" enable syntax and plugins
syntax on

" turn absolute line numbers on
set number
set nu
" turn relative line numbers on
:set relativenumber
:set rnu

" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" enable filetype detection:
filetype on
filetype plugin on
filetype indent on " file type based indentation

" use indentation of previous line
set autoindent
" use intelligent indentation for C
set smartindent

" FINDING FILES:
" search down into subfolders
" provides tab-completion for all file-related tasks
set path+=**
" display all matching files when we tab complete
set wildmenu
" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy
" THINGS TO CONDSIDER:
" - :ls shows all open buffers
" - :b lets you switch to any open buffer

" FILE BROWSING:
" I use the built-in plugin netrw.
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" NOW WE CAN:
" - :edit <path> to open a file browser
" - <CR>/v/t to open in h-split/v-split/tab

" TABS AND SPLITS:
" Use :vs <path-to-file> to split veritcally
" Use :sp <path-to-file> to split horizontally
" Use :tabnew <path-to-file> to open in a new tab
" Use gt or :tabn to go to next tab
" Use gT or :tabp or :tabN) to go to previous tab
" Use #gt or :tabn # to go to #th tab
" Use :tabr to go to first tab
" Use :tabl to go to last tab
" Use :tabm to move the current tab to the last position
" Use :tabm # to move the current tab to the #th position

" COPY PASTE SYSTEM CLIP BOARD:
" We can use the special + register which connects to
" the system clip board.
" This doesn't work in versions of vim aren't compiled 
" with  this option.
" I use vim-gtk3 on ubuntu.
" NOW WE CAN:
" - Use "+y to copy to the system clipboard
" - Use "+p to paste from the system clipboard

" AVOIDING ESCAPE:
" I don't particularly like doing system-wide remaps
" of the ESC key -- the most popular being:
" ESC --> CAPS LOCK
" I'd rather avoid the use of escape all together.
" NOW WE CAN:
" 1. <Alt> + <key> - Most terminals will send <Esc> + <key>
" 2. <Ctrl> + c - Most terminals will send <Esc>
" 3. <Ctrl> + [ - Most terminals will send <Esc>

" AUTOCOMPLETE:
" This is a built-in feature
" NOW WE CAN:
" - Use <Ctrl> + n and <Ctrl> + p to go back and forth in the suggestion list.
" EXTRAS:
" - Use <Ctrl> + x + <Ctrl> + n for JUST this file.
" - Use <Ctrl> + x + <Ctrl> + f for JUST filenames.
" - Use <Ctrl> + x + <Ctrl> + ] for tags only.

" CHANGING AND DELETING TEXT QUICKLY:
" I use ci and di a lot.
" NOW WE CAN USE:
" ciw
" ci)
" ci}
" ci'
" ci"
" ct<char> - change until <char>
" cf<char> - change until and including <char>
" And similarly for the d operator and y operators.

" ASSEMBLY AND MAKEFILES:
" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" ensure normal tabs in assembly files
" and set to NASM syntax highlighting
autocmd FileType asm set noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm

" DELETE SPACES FROM EMPTY LINES
nnoremap lint :%s/\s\+$//g

" COMPILING c in vim
" Use :make | copen
" copen shows the quick fix window
" this can be closed using :cclose 

" PLUGINS:
" For this we are using vimplug manager.
" Setup:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Upon editing the below list of commands:
" run the command
" :PlugInstall

call plug#begin()
Plug 'tpope/vim-sensible'


" On-demand loading
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'tpope/vim-commentary'
" NOW WE CAN:
" - Use gcc to comment out a line
" - Use gc to comment out the target of a motion (e.g. gcap)

Plug 'vim-syntastic/syntastic'
" NOW WE CAN:
" - Have syntax errors displayed when the file is saved.

Plug 'tpope/vim-surround'
" NOW WE CAN:
" Use cs'" to change ' to "
" Use cst" to surround replace tags with "
" Use ds" to delete in "
" Use ys<motion><s-char> to surround motion with <s-char>
" e.g ysiw<em> or ysiw"

call plug#end()

" PLUGIN CONFIGURATIONS:
" NERDTree
nnoremap nt :NERDTree<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" STATUS BAR
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" set statusline=
" set statusline+=%#PmenuSel#
"set statusline+=%{StatuslineGit()}
" set statusline+=%#LineNr#
" set statusline+=\ %f
" set statusline+=%m\
" set statusline+=%=
" set statusline+=%#CursorColumn#
" set statusline+=\ %y
" set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
" set statusline+=\[%{&fileformat}\]
" set statusline+=\ %p%%
" set statusline+=\ %l:%c
" set statusline+=\

" status bar colors
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan

" Status line
" default: set statusline=%P% %f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %n\                                 " Buffer number
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %Y\                                 " FileType
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
set statusline+=\ (%{&ff})                               " FileFormat (dos/unix..)
set statusline+=%=                                       " Right Side
set statusline+=%2*\ col:\ %02v\                         " Colomn number
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ ln:\ %02l/%L\ (%3p%%)\              " Line number / total lines, percentage of document
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e

" TODO: Make this into a function
" Retab from 2 to 4 spaces
" :set local ts=2 sts=2 noet | retab! | set ts=4 sts=4 et | retab!

function IndentSp4()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal noexpandtab
    retab!
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal expandtab
    retab!
endfunction
