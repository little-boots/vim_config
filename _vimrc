"""""""""""""""""""""""""""""""""""""""""""""""""
" Author:
" 		Chris Glessner
"
" Version:
" 		2.0 - 28JUN2017
"
" History:
"     1.0 - Inital build
"     2.0 - Update to suit numerous different languages and operating systems
"
" Sections:
"     -> TODOs
"     -> OS-Specific
"		-> Plugins
"		-> General
"		-> Language/GUI-Specific
"		-> Display
"		-> Controls
"		-> Tools
"
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" => TODOs       
"""""""""""""""""""""""""""""""""""""""""""""""""

" Set up do loop snippet as a regex so you can type the whole do line first
" Figure out how to do optional additions to snippets
" Change snippets to default to take you to the bottom first (rather than the optional places).
"   Return to bottom a second time after the optional stuff

"""""""""""""""""""""""""""""""""""""""""""""""""
" => OS-Specific
"""""""""""""""""""""""""""""""""""""""""""""""""

if has ("win32")
   "another option to consider
   "source $VIMRUNTIME/mswin.vim
   set rtp+=C:/users/cglessne/vimfiles/bundle/Vundle.vim
   let vundleloc="C:/users/cglessne/vimfiles/bundle"
   let snippetdir="C:/users/cglessne/vimfiles/bundle/ultisnips/usersnips"
   behave mswin
else
   set rtp+=~/.vim/bundle/Vundle.vim
   let vundleloc="/home/$USER/.vim/bundle/"
   let snippetdir="~/.vim/bundle/ultisnips/usersnips"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

" Initialize Vundle
call vundle#begin(vundleloc)

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'xolox/vim-misc'
Plugin 'flazz/vim-colorschemes'
Plugin 'xolox/vim-colorscheme-switcher'
Plugin 'scrooloose/nerdtree'
" Plugin 'easymotion/vim-easymotion'
Plugin 'tpope/vim-surround'
Plugin 'EricGebhart/SAS-Vim'   
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
Plugin 'ascenator/L9', {'name': 'newL9'}

" Statusbar
" Plugin 'vim-airline/vim-airline'

" UltiSnips
" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Python plugins
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=[snippetdir]

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
   
" Map leader
let mapleader = " "
let g:mapleader = " "

" Remember position
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Mode for tab completion
set wildmode=longest,list,full
set wildmenu

" Ignore case in searches
set ignorecase

" Show search matches as the search is typed
set incsearch

" Maximum line width
set lbr
set textwidth=255

" Replace documents with most recent copies
set autoread

" Turn backup off
set nobackup
set nowb
set noswapfile

" Use spaces instead of tabs
set expandtab

" Auto indent
filetype plugin indent on
set tabstop=3
set shiftwidth=3

" Maintain indent
set autoindent

" Autocorrect
:iabbrev selelct select
:iabbrev seleect select
:iabbrev macxro macro
:iabbrev strop strip
:iabbrev striop strip
:iabbrev riun run
:iabbrev crate create
:iabbrev usujbid usubjid
:iabbrev viist visit
:iabbrev viistnum visitnum
:iabbrev legnth length
:iabbrev adn and
:iabbrev dat data
:iabbrev aedeocd aedecod

"""""""""""""""""""""""""""""""""""""""""""""""""
" => Language/GUI-Specific
"""""""""""""""""""""""""""""""""""""""""""""""""

" SAS

augroup sasgroup
   " Clear the group (so VIM does not get overloaded)
   autocmd!

   " Set syntax to SAS
   au BufNewFile,BufRead *.sas set filetype=sas

   " No syntax for .log and .lst files
   au BufRead,BufNewFile *.log set syntax=off
   au BufRead,BufNewFile *.log set nomodifiable
   au BufRead,BufNewFile *.lst set syntax=off
   au BufRead,BufNewFile *.lst set nomodifiable
   au BufNewFile *.sas :call MakeHeader()
augroup END

if &filetype == 'sas'
   " Set tab
   set tabstop=3
   
   " Search for beginning of fallout in compare
   nnoremap <leader>u gg :execute "normal /Variables with Unequal Values/e\<CR>"

   function! LoadAllSAS()
      :args **.sas
      :argdo tabe
      :source $MYVIMRC 
   endfunction

   nnoremap <silent> <leader>la :call LoadAllSAS()<CR>

   " Jump from log to code
   function! Log2Code()
      let ext = expand('%:e')
      if ext == 'log'
         if filereadable( strpart(expand('%'),0,strridx(expand('%'),".")) . '.sas' )
            let gl=getline('.')
            " Code below jumps to the last line of code directly above the comment you're viewing or stays on current line if you're viewing code
            if gl !~ '[0-9]\+\s\+.*'
               let cl=line('.')
               ?^[0-9]\+\s\+.*$
               if cl<line('.')
                  /^[0-9]\+\s\+.*$
               endif
            endif
            " TODO: At this stage, need to read in full 'paragraph' of code.  A snippet like 'run;' will not help you.
            " Command below gets the text of the line you want
            let jl=substitute(getline('.'),'[0-9]\+\s\++','','')
            execute 'sp ' . strpart(expand('%'),0,strridx(expand('%'),".")) . '.sas'
            let @/=jl
         else
            echo "No .sas file detected!"
         endif
      endif
   endfunction

   nnoremap <silent> <leader>j :call Log2Code()<CR>
   nnoremap <silent> <leader>ch ebistrip(put(<Esc>ea,best.))<Esc>
   nnoremap <silent> <leader>no ebiinput(strip(<Esc>ea),best.)<Esc>
endif

" Python

function! PythonOptions()
      exe "set tabstop=4 "
      exe "set softtabstop=4"
      exe "set shiftwidth=4"
      exe "set textwidth=79"
      exe "set expandtab"
      exe "set autoindent"
      exe "set fileformat=unix"
endfunction

augroup pygroup
   au BufNewFile,BufRead *.py call PythonOptions()
   au BufNewFile,BufRead *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
augroup END

let python_highlight_all = 1

if has ('gui_running')
   " Set a theme
   color gentooish

   " Desired backspace behavior
   set backspace=2
   set backspace=indent,eol,start
endif

"""""""""""""""""""""""""""""""""""""""""""""""""
" => Display
"""""""""""""""""""""""""""""""""""""""""""""""""

"Display line and column number in bottom ruler
set ruler

"Display line numbers
set number

"Change default comment color
highlight comment cterm=none guifg=green

" Set font
set gfn=SAS_Monospace:h9:cANSI

"Highlight current line for visibility
set cursorline

" Activate syntax highlighting
syntax on

" Keep the current line in the center of the screen
set scrolloff=999

"""""""""""""""""""""""""""""""""""""""""""""""""
" => Controls
"""""""""""""""""""""""""""""""""""""""""""""""""

" Use Home/End for CAPS LOCK
" Execute 'lnoremap x X' and 'lnoremap X x' for each letter a-z.
for c in range(char2nr('A'), char2nr('Z'))
  execute 'lnoremap ' . nr2char(c+32) . ' ' . nr2char(c)
  execute 'lnoremap ' . nr2char(c) . ' ' . nr2char(c+32)
endfor

" Kill the capslock when leaving insert mode.
autocmd InsertLeave * set iminsert=0

" Use Home and Ctrl for CAPS LOCK
noremap  <silent> <Home> :let &l:imi = !&l:imi<CR>
inoremap <silent> <Home> <C-O>:let &l:imi = !&l:imi<CR>
cnoremap <silent> <Home> <C-^>

noremap  <silent> <End> :let &l:imi = !&l:imi<CR>
inoremap <silent> <End> <C-O>:let &l:imi = !&l:imi<CR>
cnoremap <silent> <End> <C-^>

" Easily leave visual selection mode
vnoremap <silent> <CR> <Esc>

" Write program name
nnoremap <leader>p "%p
inoremap <F3> <Esc>"%pa

" Insert date
nnoremap <leader>n "=toupper(strftime("%d%b%Y"))<C-M>p
inoremap <F2> <C-R>=toupper(strftime("%d%b%Y"))<C-M>

" Quickly turn off search highlighting
:nnoremap <leader>sh :nohlsearch<CR>

" Quickly open this file for editing
:nnoremap <leader>ev :20sp $MYVIMRC<CR>
:nnoremap <leader>EV :tabe $MYVIMRC<CR>

" Start using a new mapping immediately
:nnoremap <leader>sv :source $MYVIMRC<CR>

" Faster escape from insert
inoremap <silent> jk <Esc>
inoremap <silent> JK <Esc>

" Temporarily make it harder to use Esc
" inoremap <Esc> <nop>

" Shortcut to wrap in desired wrapping
nnoremap <leader>( gewi(<Esc>ea)<Esc>%i
nnoremap <leader>) gewi(<Esc>ea)<Esc>%i
nnoremap <leader>[ gewi[<Esc>ea]<Esc>%i
nnoremap <leader>] gewi[<Esc>ea]<Esc>%i
nnoremap <leader>{ gewi{<Esc>ea}<Esc>%i
nnoremap <leader>} gewi{<Esc>ea}<Esc>%i
nnoremap <leader>< gewi<<Esc>ea><Esc>
nnoremap <leader>> gewi<<Esc>ea><Esc>
nnoremap <leader>' gewi'<Esc>ea'<Esc>
nnoremap <leader>" gewi"<Esc>ea"<Esc>

" Quick save
nnoremap <leader>w :w!<CR>

" Quick close
nnoremap <leader>cl :close<CR>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Treat long lines as break lines
nnoremap j gj
nnoremap k gk

" Easily switch tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" Opens a new tab with the current buffer's path
nnoremap <leader>te :tabedit <C-R>=expand("%:p:h")<CR><CR>

" Switch CWD to the directory of the open buffer
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Kill trailing whitespace
nnoremap <leader>dw :%s/\s\+$//ge<CR>:%s/^\s*$\n[\s\n]*$//e<CR>

" Kill leading whitespace (current line only)
nnoremap <leader>db ^d0

" Allow/disallow modification
nnoremap <leader>m :set modifiable<CR>
nnoremap <leader>M :set nomodifiable<CR>

" Put spaces around = sign within line
nnoremap <leader>= :s/\([^ ]\)=\([^ ]\)/\1 = \2/g<CR>

" Remove spaces around = sign within line
nnoremap <leader>+ :s/\([^ ]\) = \([^ ]\)/\1=\2/g<CR>

" Delete text of line (but leave the line there)
nnoremap <leader>dl :s/.*//<CR>

" Indent line
nnoremap <leader>il I<Tab><Esc>

" Indent paragraph
nnoremap <leader>ip vip>

" Delete full comments
nnoremap <leader>dc :s/\/\*\\|\*\///g<CR>
vnoremap <leader>dc :s/\%V\/\*\\|\*\///g<CR>

" Inside parentheses, wrap words/phrases in single/double quotes
function! ParenWrap(type)
   exe "normal vi(\e"
   if a:type == 'qw'
      :s/\%V\(\w\+\)/'\1'/g
   elseif a:type == 'qqw'
      :s/\%V\(\w\+\)/"\1"/g
   elseif a:type == 'qp'
      :s/\%V\([A-Za-z0-9_ ]\+\)/'\1'/g
   elseif a:type == 'qqp'
      :s/\%V\([A-Za-z0-9_ ]\+\)/"\1"/g
   endif
endfunction

nnoremap <leader>qw :call ParenWrap('qw')<CR>
nnoremap <leader>qqw :call ParenWrap('qqw')<CR>
nnoremap <leader>qp :call ParenWrap('qp')<CR>
nnoremap <leader>qqp :call ParenWrap('qqp')<CR>

" Comment out a line
function! CommentLine()
   if &filetype == 'vim'
      s/\(.*\)/" \1/
   elseif &filetype == 'sas'
      s/\(.*\)/\/\*\1\*\//
   endif
endfunction

nnoremap <leader>lc :call CommentLine()<CR>


" Comment out a paragraph
function! CommentParagraph()
   if &filetype == 'sas'
      exe "normal {o\e"
      :s/.*// 
      exe "normal i/*\e"
      exe "normal }O\e"
      :s/.*//
      exe "normal i*/\e"
   endif
endfunction

nnoremap <leader>pc :call CommentParagraph()<CR>

function! MakeComment()
   if &filetype == 'sas'
      :set virtualedit=all
      :. center 50
      exe "normal 0R|\e"
      exe "normal 49|\e"
      exe "normal R|\e"
      exe "normal O\e"
      exe "normal d$i/***********************************************\\\e"
      exe "normal jo\e"
      exe "normal d$i\\***********************************************/\e"
      s/^\s*//
      :set virtualedit=
   endif
endfunction

nnoremap <silent> <leader>CC :call MakeComment()<CR>

function! MakeSmallComment()
   if &filetype == 'sas'
      :set virtualedit=all
      :. center 30
      exe "normal 0R|\e"
      exe "normal 29|\e"
      exe "normal R|\e"
      exe "normal O\e"
      exe "normal d$i/***************************\\\e"
      exe "normal jo\e"
      exe "normal d$i\\***************************/\e"
      s/^\s*//
      :set virtualedit=
   endif
endfunction

nnoremap <silent> <leader>cc :call MakeSmallComment()<CR>

" TODO: Make this a snippet
function! MakeHeader()
   if &filetype == 'sas'
      :set modifiable
      :0r C:\Program Files (x86)\Vim\vimfiles\header.txt
      exe "normal gg\e"
      /XXXX
      s/XXXX/\= expand(strftime("%Y"))
      /PROGRAM
      s/X/\= expand('%:p')
      /INPUT
      s/X/\= strpart(expand('%:p'),0,strridx(toupper(expand('%:p')),"BIOSTATISTICS")+14)
      /OUTPUT
      s/X/\= strpart(expand('%:p'),0,strridx(toupper(expand('%:p')),"BIOSTATISTICS")+14)
      /XXXXXXXXX
      s/XXXXXXXXX/\= toupper(strftime("%d%b%Y"))
   endif
endfunction

" Add title lines
function! AddTitle()
   if &filetype == 'sas'
      let cl=line('.')
      /^\s*$
      if cl>line('.')
         " Search continued past end.  Must be working with last stanza in code.
         exe "normal G\e"
         exe "normal otitle;\e"
      else
         " Normal stanza.  Place title after end.
         exe "normal Otitle;\e"
      endif
      ?^\s*$
      exe 'normal otitle ""'
      exe 'normal 0d^\e'
      exe "normal A;\e"
      exe "normal h\e"
      :startinsert
   endif
endfunction

nnoremap <silent> <leader>tt :call AddTitle()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""
" => Tools
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <leader>hi :call Hi()<CR>

function! GetTracker()
   if match(expand('%:p'),"biostatistics")>0
      echom expand('%') . "is a biostat program.  Checking for tracker info..."
      let s:biodir = fnameescape(strpart(expand('%:p'),0,match(expand('%:p'),"biostatistics")-1) . '\Biostatistics\Macros\')
      if filereadable(s:biodir . "setup_tlf.sas")
         echom "Found Setup_TLF.sas!"
         let s:searchline = "vimgrep !%let\\s\\+ProjID\\s*=\\s*\\d\\+;! " . s:biodir . "setup_tlf.sas"
         redir => s:tracker
         silent execute s:searchline
         redir END
         if empty(s:tracker)
            echom "No tracker info found"
         else
            let s:reducetrack = matchstr(matchstr(s:tracker, "ProjID\\s*=\\s*\\d\\+"), "\\d\\+")
            echom s:reducetrack
         endif
      elseif filereadable(s:biodir . "setup.sas")
         echom "Found Setup.sas!"
         let s:searchline = "vimgrep !%let\\s\\+ProjID\\s*=\\s*\\d\\+;! " . s:biodir . "setup.sas"
         redir => s:tracker
         silent execute s:searchline
         redir END
         if empty(s:tracker)
            echom "No tracker info found"
         else
            let s:reducetrack = matchstr(matchstr(s:tracker, "ProjID\\s*=\\s*\\d\\+"), "\\d\\+")
            echom s:reducetrack
         endif
      else
         echom "No Setup_TLF or Setup program detected!  Unable to determine tracker details!"
      endif
   else
      echom "Not working in biostats directory.  Not checking for tracker."
   endif
   if exists("s:reducetrack")
      echom "Tracker definition found!  Using tracker ID: " . s:reducetrack
      let b:tracker = s:reducetrack
   else
      echom "Unable to locate tracker definition in Setup_TLF.sas"
   endif
endfunction

" Create copy of buffer to use as base for new file
function! CopyAs(name)
   let s:new = expand('%:p:h') . '\' . a:name
   let s:com1 = "write " . s:new
   let s:com2 = "tabedit " . s:new
   execute s:com1
   execute s:com2
endfunction

" Define tool for F9: Run file in SAS 9.4
function! Run9_4()
	:w
   let s:fp = expand('%:p')
	let s:cmd = '!start "I:\RHO_APPS\SAS Grid\GridBatch\PROD\gridBatch94.bat"' . ' "' . s:fp . '" wait'
   execute s:cmd
endfunction

nnoremap <silent> <F9> :call Run9_4()<CR>
inoremap <silent> <F9> <ESC>:call Run9_4()<CR>

" Define tool for S-F9: Run file in SAS 9.3
function! Run9_3()
	:w
   let s:fp = expand('%:p')
	let s:cmd = '!start "I:\RHO_APPS\SAS Grid\QuickBatch\PROD\SASBatch93.bat"' . ' "' . s:fp . '" wait'
   execute s:cmd
endfunction

nnoremap <silent> <S-F9> :call Run9_3()<CR>
inoremap <silent> <F9> <ESC>:call Run9_3()<CR>

" Define tool for C+F9: Run file in SAS 9.4 using modified script
function! Run9_4_mod()
	:w
   let s:fp = expand('%:p')
	let s:cmd = '!"C:\Users\cglessne\Desktop\gridBatch94.bat"' . ' "' . s:fp . '" wait'
   execute s:cmd
endfunction

nnoremap <silent> <C-F9> :call Run9_4_mod()<CR>
inoremap <silent> <C-F9> <ESC>:call Run9_4_mod()<CR>

" Define tool for F10: Open updated .log
function! Open_log()
	let s:fp_trim = strpart(expand('%'),0,strridx(expand('%'),"."))
	let s:fp_log = s:fp_trim . '.log'
	if filereadable(s:fp_log)
		execute "100sp! " . s:fp_log
   endif
endfunction

nnoremap <silent> <F10> :call Open_log()<CR>
inoremap <silent> <F10> <ESC>:call Open_log()<CR>

" Check SAS log files for errors, warnings and other problems
" Assumes you are editing the file to be checked when invoking this function.
" No assumption about log file name extension is made so you can check any file.
function! CheckSASLog()
  " Go to the first line of the file
  :0

  " Set grepformat for use with the program used by grepprg. NOTE:
  " quickfix needs a file name! Example grepformat when a file name is
  " returned by grepprg program
  set grepformat=%f:%l:%m

  " Example grepformat with no file name returned by the program used
  " by grepprg.
  "set grepformat=%l:%m

  " Save current grepprg setting
  let _grepprg=&grepprg

  " Define the program to use for searching the SAS log
  :set grepprg=internal

  " Run grepprg on the current file
  grep +warning\|error\|uninit\|repeats of\|not found\|not valid\|invalid\|overwritten\|division\ by\ zero\|converted\ to\ character\|trunca\|more\ than\ one\|missing\ values\ were\ generated\|special\ note\|\<w\.d\>/\c+ %:p

  " Set grepprg back to its original setting
  let &grepprg=_grepprg

  " Open the quickfix error window
  :cope
endfunction

nnoremap <silent> <F11> :call CheckSASLog()<CR>
inoremap <silent> <F11> <ESC>:call CheckSASLog()<CR>

" Define tool for F12: Open updated .lst
function! Open_lst()
	let s:fp_trim = strpart(expand('%'),0,strridx(expand('%'),"."))
	let s:fp_lst = s:fp_trim . '.lst'
	if filereadable(s:fp_lst)
		execute "100sp! " . s:fp_lst
   endif
endfunction

nnoremap <silent> <F12> :call Open_lst()<CR>
inoremap <silent> <F12> <ESC>:call Open_lst()<CR>

" https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript#6271254
function! s:get_visual_selection()
   " Why is this not a built-in Vim script function?!
   let [lnum1, col1] = getpos("'<")[1:2]
   let [lnum2, col2] = getpos("'>")[1:2]
   let lines = getline(lnum1, lnum2)
   let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
   let lines[0] = lines[0][col1 - 1:]
   return join(lines, "\n")
endfunction

vnoremap <leader>i :call InteractiveSAS()<CR>

" 2) Open in fullscreen mode
" 6) Jump from a section of the log to the exact section of the code
" 8) Make it so that settings only apply if extension = .sas when option is
" SAS-specific
" Use Python tool to get metadata for whatever dataset is under the cursor - show variables, labels, lengths, and names in split
" Possibly write fucntion to read in and view datasets.
