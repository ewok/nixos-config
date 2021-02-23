" vim: ts=2 sts=2 sw=2
"
" Basic options {{{
set shell=bash
let g:mapleader = "\<Space>"
let g:maplocalleader = "\\"

" -> A big mess, should be reviewed {{{
set backspace=2
set clipboard=unnamedplus
set cmdheight=1
set confirm
set copyindent
set cursorline
set encoding=utf-8
set expandtab
set exrc
set fenc=utf-8 enc=utf-8
set hidden
set history=1000
set ignorecase
set laststatus=2
set linebreak
set linespace=0
set mouse=
set nobackup
set nobomb
set nocompatible
set noerrorbells
set nofoldenable
set nolist
set nostartofline
set noswapfile
set nowrap
set nowritebackup
set number
set numberwidth=4
set ruler
set scrolloff=5
set secure
set shiftwidth=4
set shortmess=aOtT
set showmode
set showtabline=1
set smartcase
set smarttab
set softtabstop=4
set splitbelow
set splitright
set switchbuf=useopen
set synmaxcol=1000
set tabstop=4
set timeoutlen=500
set title
set titlestring=%F
set ttimeoutlen=-1
set ttyfast

if !isdirectory($HOME . "/.vim_undo")
  call mkdir($HOME . "/.vim_undo", "p", 0700)
endif
set undolevels=100
set undodir=~/.vim_undo
set undofile

set visualbell
scriptencoding utf-8

filetype plugin indent on

syntax on
set hlsearch
set incsearch
syntax enable

if (has("termguicolors"))
  set termguicolors
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors

endif

set guicursor=n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175

" Dynamic timeoutlen
au InsertEnter * set timeoutlen=1000
au InsertLeave * set timeoutlen=500

" }}}
" -> Wildmenu completion {{{
set wildmenu
set wildmode=longest,list

" ignores
set wildignore+=*.o,*.obj,*.pyc
set wildignore+=*.png,*.jpg,*.gif,*.ico
set wildignore+=*.swf,*.fla
set wildignore+=*.mp3,*.mp4,*.avi,*.mkv
set wildignore+=*.git*,*.hg*,*.svn*
set wildignore+=*sass-cache*
set wildignore+=*.DS_Store
set wildignore+=log/**
set wildignore+=tmp/**
" }}}
" -> Cursorline {{{
"
" cursorline switched while focus is switched to another split window
augroup cline
  au!
  au WinLeave,InsertEnter * set nocursorline
  au WinEnter,InsertLeave * set cursorline
augroup END
" }}}
" -> Restore cursor {{{
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END
" }}}
" -> NeoVim settings  {{{
"
if has('nvim')
  set shada='50,<1000,s100,"10,:10,n~/.viminfo
  set inccommand=nosplit

  " let g:python_host_prog = $HOME . "/share/venv/neovim2/bin/python2"
  " let g:python3_host_prog = $HOME . "/share/venv/neovim3/bin/python3"

  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

  nmap <BS> <C-h>
  tnoremap <Esc> <C-\><C-n>
endif

" }}}
" -> Dealing with largefiles  {{{
"
" Protect large files from sourcing and other overhead.
" Files become read only

let g:largefile=0

if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowrite (file is read-only)
  " undolevels=-1 (no undo possible)
  "
  let g:LargeFile = 1024 * 1024 * 20
  augroup LargeFile
    au BufReadPre *
          \ let f=expand("<afile>")
          \ | if getfsize(f) > g:LargeFile
            \ | if input("Large file detected, turn off features? (y/n) ", "y") == "y"
              \ | setlocal inccommand=
              \ | setlocal eventignore+=FileType
              \ | setlocal noswapfile bufhidden=unload undolevels=-1
              \ | let b:syntastic_mode="passive"
              \ | let b:ycm_auto_trigger=0
              \ | let g:largefile=1
              \ | endif
            \ | else
              \ | setlocal eventignore-=FileType
              \ | let g:largefile=0
              \ | endif
  augroup END
endif
" }}}
" -> Number Toggle  {{{
function! NumberOn()
  if(&showcmd == 1)
    set rnu
  endif
endfunction

function! NumberOff()
  if(&showcmd == 1)
    set nornu
  endif
endfunction

set rnu
augroup rnu
  au!
  au InsertEnter * :call NumberOff()
  au InsertLeave * :call NumberOn()
augroup END
" }}}
" -> RunCmd {{{
"
function! RunCmd(cmd)
  exe "!" . a:cmd
endfunction
" }}}
" }}}

" Leader Initializations {{{
" Define prefix dictionary
let g:lmap =  {}
let g:lmap.b = { 'name': '+Buffer'}
let g:lmap.b.q = 'Quit All'
let g:lmap.c = { 'name': '+Code'}
let g:lmap.c.a = 'Code action(file)'
let g:lmap.c.c = 'Code action(line)'
let g:lmap.c.d = 'Diagnostics'
let g:lmap.c.r = { 'name': '+Refactor'}
let g:lmap.c.r.n = 'Rename'
let g:lmap.c.r.r = 'Menu'
let g:lmap.c.f = 'Format'
let g:lmap.c.F = 'Fix code(coc)'
let g:lmap.f = { 'name': '+Find' }
let g:lmap.f.f = 'in-File'
let g:lmap.f.p = 'Path'
let g:lmap.f.r = 'Replace'
let g:lmap.f.t = 'Tag'
let g:lmap.g = { 'name': '+Git'}
let g:lmap.g.b = { 'name': '+Blame' }
let g:lmap.g.b.b = 'Messanger'
let g:lmap.g.b.l = 'bLame'
let g:lmap.g.C = 'Commit'
let g:lmap.g.d = 'Diff'
let g:lmap.g.g = 'Browse'
let g:lmap.g.h = { 'name': '+History' }
let g:lmap.g.h.f = '+File'
let g:lmap.g.h.h = '+All'
let g:lmap.g.h.p = 'Hunk-Preview'
let g:lmap.g.h.r = 'Hunk-Revert'
let g:lmap.g.h.s = 'Hunk-Stage'
let g:lmap.g.h.v = 'Visual'
let g:lmap.g.p = { 'name': '+Push-pull' }
let g:lmap.g.p.l = { 'name': '+Pull' }
let g:lmap.g.p.l.m = 'Merge'
let g:lmap.g.p.l.r = 'Rebase'
let g:lmap.g.p.s = 'Push'
let g:lmap.g.R = 'Read'
let g:lmap.g.s = 'Status'
let g:lmap.g.W = 'Write'
let g:lmap.i = { 'name': '+Insert' }
let g:lmap.i.t = 'To-do'
let g:lmap.i.d = {'name': '+DateTime'}
let g:lmap.i.d.m = 'date Time(Minutes)'
let g:lmap.i.d.d = 'date Time(Day)'
let g:lmap.i.d.s = 'date Time(seconds)'
let g:lmap.l = { 'name': '+Location' }
let g:lmap.l.c = 'Close'
let g:lmap.l.l = 'Toggle'
let g:lmap.l.n = 'Next'
let g:lmap.l.o = 'Open'
let g:lmap.l.p = 'Previous'
let g:lmap.m = { 'name': '+Marks' }
let g:lmap.o = { 'name': '+Open/+Option'}
let g:lmap.o.e = 'Explorer'
let g:lmap.o.s = { 'name': '+Option-Set'}
let g:lmap.o.s.f = { 'name': '+File'}
let g:lmap.o.s.f.f = { 'name': '+Format='}
let g:lmap.o.u = { 'name': '+Option-Unset'}
let g:lmap.o.t = 'To-Do'
let g:lmap.p = { 'name': '+Plugins' }
let g:lmap.p.c = {'name': '+Coc'}
let g:lmap.p.c.m = 'Marketplace'
let g:lmap.p.c.u = 'Update'
let g:lmap.p.c.l = 'List'
let g:lmap.q = { 'name': '+QFix' }
let g:lmap.q.c = 'Close'
let g:lmap.q.n = 'Next'
let g:lmap.q.o = 'Open'
let g:lmap.q.p = 'Previous'
let g:lmap.q.q = 'Toggle'
let g:lmap.r = { 'name': '+Run' }
let g:lmap.r.b = 'Breakpoint'
let g:lmap.r.R = { 'name': '+Runner' }
let g:lmap.r.R.q = 'Close Runner'
let g:lmap.r.R.x = 'Interrupt'
let g:lmap.s = { 'name': '+Session' }
let g:lmap.s.c = 'Close'
let g:lmap.s.d = 'Delete'
let g:lmap.s.o = 'Open'
let g:lmap.s.q = 'Quit'
let g:lmap.s.s = 'Save'
let g:lmap.s.u = 'open-cUrrent'
let g:lmap.t = { 'name': '+Tags/Text' }
let g:lmap.t.f = {'name': '+Fix'}
let g:lmap.t.s = 'Syntax'
let g:lmap.t.T = 'Text-only(Goyo)'
let g:lmap.u = 'Undo'
let g:lmap.w = { 'name': '+Wiki' }
let g:lmap.w.w = 'Index'
let g:lmap.w.m = { 'name' :'+Maintanence'}
let g:lmap.w.m.c = 'Check Links'
let g:lmap.w.m.t = 'Rebuild Tags'
let g:lmap.w.c = 'Colorize'
let g:lmap.w.t = 'Today'
let g:lmap.w.T = 'Tag Rebuild+Insert'
let g:lmap.w.i = 'Diary'
let g:lmap.w.r = 'Rename link'
let g:lmap.w.d = 'Delete link'
let g:lmap.w.n = 'goto'
let g:lmap.w.j = 'Next Day'
let g:lmap.w.k = 'Prev Day'
let g:lmap.y = { 'name': '+Yank' }
let g:lmap.y.f = { 'name': '+File' }
let g:lmap.y.f.n = 'Name'
let g:lmap.y.f.p = 'Path'
let g:lmap.y.f.l = 'File:Line'
let g:lmap.z = { 'name': '+Zettel' }
let g:lmap.z.b = 'Update Backlinks'
let g:lmap.z.z = 'Open'
let g:lmap.z.y = 'Yank Page'
let g:lmap.z.n = 'New'
let g:lmap.z.i = 'Insert Note'
let g:lmap.z.C = 'Capture As Note'
let g:lmap.Z = 'Zoom'

let g:which_key_use_floating_win = 1
let g:which_key_flatten = 0
" }}}

" Helpers {{{
" minpac
if has('nvim')
  let g:config_path = '.config/nvim'
else
  let g:config_path = '.vim'
endif

if ! isdirectory($HOME . '/' . g:config_path . '/pack/minpac/opt/minpac/')
  execute "!git clone https://github.com/k-takata/minpac.git " . $HOME . "/" . g:config_path . "/pack/minpac/opt/minpac"
endif

packadd minpac

call minpac#init()
command! PackUpdate call minpac#update()
command! PackClean  call minpac#clean()
command! PackStatus call minpac#status()

nmap <leader>pu :PackUpdate<CR>

" Idempotent packs loading
function PackAddId(packname, ...)

  if a:0 > 0
      let reload = a:1
    else
      let reload = 0
  endif

  let l:packnamenorm = substitute(a:packname, "[-.]", "_", "")

  if ! exists('g:loaded' . l:packnamenorm)

    exe 'packadd ' . a:packname
    exe 'let g:loaded' . l:packnamenorm . '= 1'

    if exists('g:debug')
      echom a:packname . ' loaded'
    endif

    if reload != 0
      exe 'e %'
    endif

  endif
endfunction

command! -nargs=* PackAdd call PackAddId(<f-args>)

function SmartCR()
  let line = getline('.')
  if line =~# ';$'
    execute "normal o\<Space>\<BS>\<Esc>"
    startinsert!
  else
    call setline('.', line . ';')
    normal l
    startinsert
  endif
endfunction
" }}}

" Keymaps {{{
"   Tabs {{{
" map gr gT
nnoremap <C-W>t :tabnew<CR>
noremap <Tab> :tabnext<CR>
noremap <S-Tab> :tabprev<CR>

" }}}
"   Windows {{{

" Tmux?
if exists('$TMUX')
  nnoremap <Plug>(window_split-tmux) :!tmux split-window -v -p 20<CR><CR>
  nmap <silent><C-W>S <Plug>(window_split-tmux)

  nnoremap <Plug>(window_vsplit-tmux) :!tmux split-window -h -p 20<CR><CR>
  nmap <silent><C-W>V <Plug>(window_vsplit-tmux)

else
  if has('nvim')
    nmap <silent><C-W>S :split +terminal<CR>i
    nmap <silent><C-W>V :vsplit +terminal<CR>i
  else
    nmap <silent><C-W>S :terminal<CR>i
    nmap <silent><C-W>V :terminal<CR>i
  endif
endif

" split window resize
if bufwinnr(1)
  map <C-W><C-J> :resize +5<CR>
  map <C-W><C-K> :resize -5<CR>
  map <C-W><C-L> :vertical resize +6<CR>
  map <C-W><C-H> :vertical resize -6<CR>
  map <C-W><BS> :vertical resize -6<CR>
endif

" don't close last window
nmap <silent><C-W>q :close<CR>

" }}}
"   Folding {{{
" Space to toggle folds.
nnoremap <silent> <leader><leader> za"{{{
nnoremap <silent> z. mzzMzvzz15<c-e>`z
vnoremap <silent> <leader><leader> zf"}}}

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" Close recursively
nnoremap zC zcV:foldc!<CR>

nmap zj zjmzzMzvzz15<c-e>`z
nmap zk zkmzzMzvzz15<c-e>`z

" " }}}
"   Yank {{{
nmap <expr>  MR  ':%s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
vmap <expr>  MR  ':s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'

nmap <expr>  MY  ':%Yankitute/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
vmap <expr>  MY  ':Yankitute/\(' . @/ . '\)/\1/g<LEFT><LEFT>'

" Replace without yanking
vnoremap p :<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>

" Permanent buffer
command! YankYank :.w! ~/.vbuf
nmap <leader>yy :YankYank<CR>

command! YankVYank :w! ~/.vbuf
vmap <leader>yy :YankVYank<CR>

command! YankPaste :r ~/.vbuf
nmap <leader>yp :YankPaste<CR>

nnoremap <leader>yfl :let @+=expand("%") . ':' . line(".")<CR>
nnoremap <leader>yfn :let @+=expand("%")<CR>
nnoremap <leader>yfp :let @+=expand("%:p")<CR>

" }}}
"   Some vim tunings {{{
nnoremap Y y$

" Don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc
"
" Don't cancel visual select when shifting
xnoremap <  <gv
xnoremap >  >gv

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" [S]plit line (sister to [J]oin lines) S is covered by cc.
nnoremap S mzi<CR><ESC>`z

" Don't move cursor when searching via *
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap H ^
nnoremap L $

vnoremap H ^
vnoremap L $
" }}}
"   Settings {{{
nmap <leader>osw :set wrap<CR>
nmap <leader>ouw :set nowrap<CR>

nmap <leader>osffu :set ff=unix<CR>
nmap <leader>osffd :set ff=dos<CR>

nmap <leader>osts2 :set tabstop=2\|set softtabstop=2<CR>
nmap <leader>osts4 :set tabstop=4\|set softtabstop=4<CR>
"   }}}
"   Insert data {{{
nnoremap <leader>it O<C-R>=split(&commentstring, '%s')[0] . 'TODO: '<CR><CR><C-R>=expand("%:h") . '/' . expand("%:t") . ':' . line(".")<CR><C-G><C-K><C-O>A
nnoremap <leader>ids a<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR><ESC>
nnoremap <leader>idm a<C-R>=strftime("%Y-%m-%d %H:%M")<CR><ESC>
nnoremap <leader>idd a<C-R>=strftime("%Y-%m-%d")<CR><ESC>
"   }}}
" }}}

" Filetypes {{{
" Ansible/Yaml {{{
call minpac#add('pearofducks/ansible-vim', {'type': 'opt', 'name': 'ansible'})
augroup ft_ansible
  au!
  au BufNewFile,BufRead */\(playbooks\|roles\|tasks\|handlers\|defaults\|vars\)/*.\(yaml\|yml\) set filetype=yaml.ansible

  au FileType yaml.ansible call LoadAnsibleFT()
  function! LoadAnsibleFT()

    if exists('b:ansible_ft')
      return
    endif

    setlocal commentstring=#\ %s

    PackAdd ale

    let b:ale_ansible_ansible_lint_executable = 'ansible_custom'
    let b:ale_ansible_ansible_lint_command = '%e %t'
    let b:ale_ansible_yamllint_executable = 'yamllint_custom'
    let b:ale_linters = ['yamllint', 'ansible_custom']

    call ale#linter#Define('ansible', {
          \   'name': 'ansible_custom',
          \   'executable': function('ale_linters#ansible#ansible_lint#GetExecutable'),
          \   'command': '%e %s',
          \   'callback': 'ale_linters#ansible#ansible_lint#Handle',
          \})

    PackAdd ansible 1
    PackAdd rooter

    let g:ansible_template_syntaxes = { '*.rb.j2': 'ruby', '*.py.j2': 'python' }
    let g:ansible_unindent_after_newline = 1
    let g:ansible_attribute_highlight = "ob"
    let g:ansible_extra_keywords_highlight = 1
    let g:ansible_normal_keywords_highlight = 'Constant'
    let g:ansible_with_keywords_highlight = 'Constant'

    let b:ansible_ft = 1

  endfunction

augroup END
" }}}
" CSV {{{
call minpac#add('chrisbra/csv.vim', {'type': 'opt', 'name': 'csv'})
augroup ft_csv
  au!
  au BufNewFile,BufRead *.csv set filetype=csv

  au FileType csv call LoadCSVFT()
  function! LoadCSVFT()

    if exists('b:csv_ft')
      return
    endif

    PackAdd csv 1

    let b:csv_ft = 1

  endfunction

augroup END
" }}}
" Yaml {{{
augroup ft_yaml
  au!

  au FileType yaml call LoadYamlFT()
  function! LoadYamlFT()

    if exists('b:yaml_ft')
      return
    endif

    PackAdd ale
    let b:ale_yaml_yamllint_executable = 'yamllint_custom'
    let b:ale_linters = ['yamllint']

    PackAdd speeddating
    PackAdd rooter
    " PackAdd splitjoin

    let b:yaml_ft = 1

  endfunction

augroup END
" }}}
" Config {{{
augroup ft_config
  au!
  au BufNewFile,BufRead *.conf,*.cfg,*.ini set filetype=config
  au FileType config setlocal commentstring=#\ %s
augroup END
" }}}
" GitIgnore {{{
augroup ft_git
  au!
  au BufNewFile,BufRead *.gitignore set filetype=gitignore
augroup END
" }}}
" Go {{{
call minpac#add('fatih/vim-go', {'type': 'opt', 'name': 'vim-go'})
augroup ft_go
  au!

  au FileType go call LoadGoFT()
  function! LoadGoFT()

    if exists('b:go_ft')
      return
    endif

    PackAdd vim-go 1

    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_interfaces = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1

    " let g:go_auto_type_info = 1
    let g:go_auto_sameids = 1
    " let g:go_fmt_autosave = 0
    " let g:go_fmt_command = "goimports"

    nmap <buffer> <silent> <leader>rr :silent GoRun<CR>
    nmap <buffer> <silent> <leader>rt :GoTest<CR>
    nmap <buffer> <silent> <leader>rb :GoBuild<CR>
    nmap <buffer> <silent> <leader>rc :GoCoverageToggle<CR>

    " FIXME: Adjust to coc accordingly
    " let g:lmap.r.d = { 'name': '+Definition' }
    " let g:lmap.r.d.s = 'Split'
    " nmap <buffer> <Leader>rds <Plug>(go-def-split)

    " let g:lmap.r.d.v = 'Vertical'
    " nmap <buffer> <Leader>rdv <Plug>(go-def-vertical)

    " let g:lmap.r.d.t = 'Tab'
    " nmap <buffer> <Leader>rdt <Plug>(go-def-tab)
    " " au FileType go nmap <buffer> K <Plug>(go-doc)

    " let g:lmap.r.d.i = 'Info'
    " nmap <buffer> <Leader>rdi <Plug>(go-info)

    PackAdd rooter

    " PackAdd splitjoin

    let b:go_ft = 1

  endfunction

augroup END
" }}}
" jrnl {{{
augroup ft_jrnl
  au!
  au BufRead,BufNewFile /tmp/jrnl* setlocal filetype=jrnl
  au FileType config setlocal commentstring=#\ %s

  au FileType jrnl call LoadJrnlFT()
  function! LoadJrnlFT()

    if exists('b:jrnl_ft')
      return
    endif

    PackAdd jrnl 1

    let b:jrnl_ft = 1

  endfunction
augroup END
" }}}
" JSON {{{
augroup ft_json
  au!
  au BufNewFile,BufRead *.json set filetype=javascript
augroup END
" }}}
" Haskell {{{
augroup ft_haskell
  au!
  au BufNewFile,BufRead *.hs,*.lhs set filetype=haskell
augroup END
" }}}
" Logstash {{{
call minpac#add('robbles/logstash.vim', {'type': 'opt', 'name': 'logstash'})
augroup ft_logstash
  au!

  au FileType logstash call LoadLogstashFT()
  function! LoadLogstashFT()

    if exists('b:logstash_ft')
      return
    endif

    PackAdd logstash 1

    setlocal foldmethod=marker
    setlocal foldmarker={,}
    setlocal wrap

    let b:logstash_ft = 1

  endfunction

augroup END
" }}}
" Markdown {{{
call minpac#add('shime/vim-livedown', {'type': 'opt', 'name': 'livedown'})
call minpac#add('gpanders/vim-medieval', {'type': 'opt', 'name': 'medieval'})
augroup ft_markdown
  au!

  au FileType markdown call LoadMarkdownFT()
  function! LoadMarkdownFT()

    if exists('b:markdown_ft')
      return
    endif

    setlocal foldlevel=2
    setlocal conceallevel=2

    PackAdd livedown
    let g:livedown_browser = 'firefox'
    let g:livedown_port = 14545

    nmap <buffer> <silent> <leader>rr :LivedownPreview<CR>
    nmap <buffer> <silent> <leader>rt :LivedownToggle<CR>
    nmap <buffer> <silent> <leader>rk :LivedownKill<CR>

    nmap <buffer> <silent> <leader>oT :silent ! typora "%" &<CR>

    iab \c ```

    PackAdd medieval
    let g:medieval_langs = ['python=python3', 'ruby', 'sh', 'console=bash', 'bash', 'perl']

    command! -bang -nargs=? EvalBlock call medieval#eval(<bang>0, <f-args>)
    nmap <buffer> <leader>rb "":EvalBlock<CR>

    " PackAdd ale
    " let b:ale_linters = ['vale', 'markdownlint']

    PackAdd speeddating
    PackAdd rooter

    inoremap <buffer><expr> ]] fzf#vim#complete({
          \ 'source':  'rg --no-heading --smart-case  .',
          \ 'reducer': function('<sid>make_note_link'),
          \ 'options': '--multi --reverse --margin 15%,0',
          \ 'window': { 'width': 0.9, 'height': 0.6 }})

    " Zettel
    imap <buffer><silent> [[ qq<esc><Plug>ZettelSearchMap
    xmap <buffer><silent> <CR> <Plug>ZettelNewSelectedMap

    nnoremap <buffer><silent> <leader>wb :VimwikiBacklinks<cr>

    " Links mapping
    nnoremap <buffer><silent> <CR> :VimwikiFollowLink<CR>

    nnoremap <buffer><silent> <Backspace> :VimwikiGoBackLink<CR>
    nnoremap <buffer><silent> <leader>wd :VimwikiDeleteFile<CR>
    nnoremap <buffer><silent> <leader>wr :VimwikiRenameFile<CR>

    nnoremap <buffer><silent> ]w :VimwikiNextLink<CR>
    nnoremap <buffer><silent> [w :VimwikiPrevLink<CR>

    command! ZettelUpdateBackLinks :call UpdateBacklinks()
    nnoremap <buffer><silent> <leader>zb :ZettelUpdateBackLinks<CR>

    nnoremap <buffer><silent> <leader>zz :ZettelOpen<CR>

    nnoremap <buffer><silent> <leader>zy :ZettelYankName<CR>

    nnoremap <buffer><silent> <leader>zn :ZettelNew<space>

    nnoremap <buffer><silent> <leader>zi :ZettelInsertNote<CR>

    nnoremap <buffer><silent> <leader>zC :ZettelCapture<CR>

    nnoremap <buffer><silent> <leader>wT :VimwikiRebuildTags!<cr>:VimwikiGenerateTagLinks<cr><c-l>

    let b:markdown_ft = 1

  endfunction

augroup END
" }}}
" Mustache {{{
call minpac#add('mustache/vim-mustache-handlebars', {'type': 'opt', 'name': 'mustache'})
augroup ft_mustache
  au!

  au FileType mustache call LoadMustacheFT()
  function! LoadMustacheFT()

    if exists('b:mustache_ft')
      return
    endif

    PackAdd mustache 1
    let g:mustache_abbreviations = 1

    PackAdd rooter
    " PackAdd splitjoin

    let b:mustache_ft = 1

  endfunction

augroup END
" }}}
" Nix {{{
call minpac#add('LnL7/vim-nix', {'type': 'opt', 'name': 'nix'})
augroup ft_nix
  au!
  au BufRead,BufNewFile *.nix set filetype=nix

  let g:tagbar_type_nix = {
      \ 'ctagstype': 'nix',
      \ 'kinds' : [
          \'f:function'
      \]
  \}

  au FileType nix call LoadNixFT()
  function! LoadNixFT()

    if exists('b:nix_ft')
      return
    endif

    set expandtab

    imap <buffer> <C-Enter> <ESC>:call SmartCR()<CR>

    PackAdd ale
    PackAdd rooter

    PackAdd nix 1

    let b:nix_ft = 1

  endfunction

augroup END
" }}}
" Python {{{
call minpac#add('jmcantrell/vim-virtualenv', {'type': 'opt', 'name': 'vim-virtualenv'})
call minpac#add('Vimjas/vim-python-pep8-indent', {'type': 'opt', 'name': 'pep8-ind'})
" call minpac#add('davidhalter/jedi-vim', {'type': 'opt', 'name': 'jedi'})
" call minpac#add('deoplete-plugins/deoplete-jedi', {'type': 'opt'})
augroup ft_python
  au!

  au FileType python call LoadPythonFT()
  function! LoadPythonFT()

    if exists('b:python_ft')
      return
    endif

    " let g:jedi#completions_command = ""
    " let g:jedi#completions_enabled = 0
    " let g:jedi#documentation_command = "K"
    " let g:jedi#goto_assignments_command = "gA"
    " let g:jedi#goto_command = "gd"
    " let g:jedi#goto_definitions_command = "gD"
    " let g:jedi#goto_stubs_command = "gS"
    " let g:jedi#rename_command = "<leader>rR"
    " let g:jedi#usages_command = "gr"
    " let g:jedi#use_splits_not_buffers = "right"
    " PackAdd jedi 1

    let g:virtualenv_directory = $PWD
    PackAdd vim-virtualenv

    PackAdd pep8-ind

    setlocal foldmethod=indent
    setlocal foldlevel=0
    setlocal foldnestmax=2
    setlocal commentstring=#\ %s

    nmap <buffer> <leader>rr :w\|call RunCmd("python " . bufname("%"))<CR>
    nmap <buffer> <leader>rt :w\|call RunCmd("python -m unittest " . bufname("%"))<CR>
    nmap <buffer> <leader>rT :w\|call RunCmd("python -m unittest")<CR>
    nmap <buffer> <leader>rL :!pip install flake8 mypy pylint bandit pydocstyle pudb jedi<CR>:ALEInfo<CR>

    nmap <Plug>(python_breakpoint) oimport pudb; pudb.set_trace()<esc>
    nmap <silent> <buffer> <leader>rb <Plug>(python_breakpoint)

    PackAdd ale
    let b:ale_linters = ['flake8', 'mypy', 'pylint', 'bandit', 'pydocstyle']
    let b:ale_fixers = {'python': ['remove_trailing_lines', 'trim_whitespace', 'autopep8']}
    let b:ale_python_flake8_executable = 'flake8'
    let b:ale_python_flake8_options = '--ignore E501'
    let b:ale_python_flake8_use_global = 0
    let b:ale_python_mypy_executable = 'mypy'
    let b:ale_python_mypy_options = ''
    let b:ale_python_mypy_use_global = 0
    let b:ale_python_pylint_executable = 'pylint'
    let b:ale_python_pylint_options = '--disable C0301,C0111,C0103'
    let b:ale_python_pylint_use_global = 0
    let b:ale_python_bandit_executable = 'bandit'
    let b:ale_python_isort_executable = 'isort'
    let b:ale_python_pydocstyle_executable = 'pydocstyle'
    let b:ale_python_vulture_executable = 'vulture'

    PackAdd textobj-python
    PackAdd rooter
    " PackAdd splitjoin

    let b:python_ft = 1

  endfunction

augroup END
" }}}
" Puppet {{{
call minpac#add('rodjek/vim-puppet', {'type': 'opt', 'name': 'puppet'})
augroup ft_puppet
  au!

  au BufNewFile,BufRead *.pp set filetype=puppet
  au FileType puppet call LoadPuppetFT()
  function! LoadPuppetFT()

    if exists('b:puppet_ft')
      return
    endif

    setlocal commentstring=#\ %s

    nmap <buffer> <leader>rr :w\|call RunCmd("puppet " . bufname("%"))<CR>
    nmap <buffer> <leader>rt :w\|call RunCmd("puppet parser validate")<CR>
    nmap <buffer> <leader>rL :!gem install puppet puppet-lint r10k yaml-lint<CR>:ALEInfo<CR>

    PackAdd puppet 1
    let g:puppet_align_hashes = 0

    " let b:ale_linters = ['puppet', 'puppetlint']

    PackAdd rooter

    let b:puppet_ft = 1

  endfunction

augroup END
" }}}
" Rust {{{
call minpac#add('rust-lang/rust.vim', {'type': 'opt', 'name': 'rust'})
" call minpac#add('racer-rust/vim-racer', {'type': 'opt', 'name': 'rust-racer'})
augroup ft_rust
  au!

  au FileType rust call LoadRustFT()
  function! LoadRustFT()

    if exists('b:rust_ft')
      return
    endif

    imap <buffer> <C-Enter> <ESC>:call SmartCR()<CR>

    PackAdd rust 1
    " PackAdd rust-racer
    " let g:racer_experimental_completer = 1

    " nmap <buffer> gd <Plug>(rust-def)
    " nmap <buffer> gs <Plug>(rust-def-split)
    " nmap <buffer> gx <Plug>(rust-def-vertical)
    " nmap <buffer> K <Plug>(rust-doc)
    nmap <buffer> <silent> <leader>rr :RustRun<CR>
    nmap <buffer> <silent> <leader>rt :RustTest<CR>
    nmap <buffer> <silent> <leader>cf :RustFmt<CR>

    PackAdd rooter
    " PackAdd splitjoin

    " PackAdd ale

    let b:rust_ft = 1

  endfunction

augroup END
" }}}
" SQL {{{
augroup ft_sql
  au!
  au FileType sql call LoadSQLFT()
  function! LoadSQLFT()
    if exists('b:sql_ft')
      return
    endif

    setlocal commentstring=/*\ %s\ */

    let b:sql_ft = 1

  endfunction
augroup END
" }}}
" TODO {{{
augroup ft_todo
  au!

  au BufRead,BufNewFile *.todo setf todo

  au FileType todo call LoadTODOFT()
  function! LoadTODOFT()

    hi TODO guifg=Yellow ctermfg=Yellow term=Bold
    hi FIXME guifg=Red ctermfg=Red term=Bold
    syn match TODO "TODO\|@todo\|@today"
    syn match FIXME "FIXME\|@fixme\|@error"

    hi TASK guifg=Yellow ctermfg=Yellow term=Bold
    syn match TASK "\s\w\{1,10}-\d\{1,6}[ :]"

    " hi P1 guifg=Red ctermfg=Red term=Bold
    " hi P2 guifg=LightRed ctermfg=LightRed term=Bold
    " hi P3 guifg=LightYellow ctermfg=LightYellow term=Bold
    " syn match P1 " !!! "
    " syn match P2 " !! "
    " syn match P3 " ! "

    hi DT guifg=DarkMagenta ctermfg=DarkMagenta term=Bold
    syn match DT "\d\{4}-\d\{2}-\d\{2}"

    " hi H1 guifg=LightGreen ctermfg=Grey term=Bold
    " hi H2 guifg=DarkGreen ctermfg=DarkGreen term=Bold
    " hi H3 guifg=Magenta ctermfg=Magenta term=Bold
    " syn match H1 "^[#] .*$"
    " syn match H2 "^[#]\{2} .*$"
    " syn match H3 "^[#]\{3} .*$"

    hi P1 guifg=Red ctermfg=Red term=Bold
    hi P2 guifg=LightRed ctermfg=LightRed term=Bold
    hi P3 guifg=LightYellow ctermfg=LightYellow term=Bold
    hi P4 guifg=LightGrey ctermfg=Grey term=Italic

    syn match P1 ".*\[[^X]\]\s\+[pP]1.*$" contains=TODO,FIXME,TASK,DT
    syn match P2 ".*\[[^X]\]\s\+[pP]2.*$" contains=TODO,FIXME,TASK,DT
    syn match P3 ".*\[[^X]\]\s\+[pP]3.*$" contains=TODO,FIXME,TASK,DT
    syn match P4 ".*\[[^X]\]\s\+[pP]4.*$" contains=TODO,FIXME,TASK,DT

    hi DONE guifg=DarkGreen ctermfg=Grey term=Italic
    syn match DONE ".*\[[X]\]\s.*$" contains=NONE

    " hi TEXT guifg=LightGrey ctermfg=LightGrey
    " syn match TEXT "^\s*[-*] .*$" contains=TASK,P1,P2,P3,DONE,DT

    " hi Block guifg=Black ctermbg=Black
    " syn region Block start="```" end="```" contains=TEXT,DONE,H1,H2,H3
    " syn region Block start="<" end=">" contains=TEXT,DONE,H1,H2,H3

    PackAdd speeddating

  endfunction

augroup END
" }}}
" Vim {{{
augroup ft_vim
  au!

  au FileType help setlocal textwidth=78
  au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif

  au FileType vim call LoadVimFT()
  function! LoadVimFT()

    if exists('b:vim_ft')
      return
    endif

    setlocal foldmethod=marker keywordprg=:help
    setlocal commentstring=\"\ %s

    inoremap <c-n> <c-x><c-n>

    nmap <Plug>(vim_source_file) :source %<CR>:echon "script reloaded!"<CR>
    nmap <buffer> <leader>rr <Plug>(vim_source_file)

    vnoremap <buffer> <leader>rS y:@"<CR>

    nnoremap <Plug>(vim_source_line) ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>
    nnoremap <buffer> <leader>rS <Plug>(vim_source_line)

    " PackAdd splitjoin

    let b:vim_ft = 1

  endfunction

augroup END
" }}}
" ZSH {{{
augroup ft_zsh
  au!
  au BufNewFile,BufRead *.zsh-theme set filetype=zsh
augroup END
" }}}
" Shell {{{
augroup ft_sh
  au!

  au FileType sh call LoadShFT()
  function! LoadShFT()

    if exists('b:shell_ft')
      return
    endif

    nmap <buffer> <leader>rr :w\|call RunCmd("bash " . bufname("%"))<CR>

    " PackAdd ale
    " let b:ale_linters = ['shellcheck', 'language_server']

    PackAdd speeddating
    " PackAdd splitjoin

    let b:shell_ft = 1

  endfunction

augroup END
" }}}
" Vimwiki {{{
augroup ft_vimwiki
  au!

  au FileType vimwiki call LoadVimWikiFT()
  function! LoadVimWikiFT()

    if exists('b:vimwiki_ft')
      return
    endif

    call LoadMarkdownFT()

    let b:vimwiki_ft = 1

  endfunction

augroup END
" }}}
" Dockerfile {{{
augroup ft_dockerfile
  au!

  au FileType dockerfile call LoadDockerfileFT()
  function! LoadDockerfileFT()

    if exists('b:docker_ft')
      return
    endif

    PackAdd ale
    let b:ale_linters = ['hadolint']

    let b:docker_ft = 1

  endfunction

augroup END
" }}}
" Mail {{{
augroup ft_mail
  au!
  au FileType mail call LoadMailFT()

  function! LoadMailFT()

    if exists('b:mail_ft')
      return
    endif

    nmap <buffer> <leader>ry :%!pandoc -f markdown_mmd -t html<CR>

    PackAdd livedown

    let g:livedown_browser = 'firefox'
    let g:livedown_port = 14545

    nmap <buffer> <silent> <leader>rr :LivedownPreview<CR>
    nmap <buffer> <silent> <leader>rt :LivedownToggle<CR>
    nmap <buffer> <silent> <leader>rk :LivedownKill<CR>

    PackAdd speeddating

    let b:mail_ft = 1

  endfunction

augroup END
" }}}
" Helm {{{
call minpac#add('towolf/vim-helm', {'type': 'opt', 'name': 'helm'})
augroup ft_helm
  au!
  au BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl,Chart.yaml,values.yaml set ft=helm

  function! RenderHelm()
    write
    exe '!helm template ./ --output-dir .out'
  endfunction

  au FileType helm call LoadHelmFT()
  function! LoadHelmFT()

    if exists('b:helm_ft')
      return
    endif

    PackAdd helm 1

    command! RenderHelm :call RenderHelm()
    nmap <buffer> <silent> <leader>rr :RenderHelm<CR>

    PackAdd rooter

    let b:helm_ft = 1

  endfunction

augroup END
"  }}}
" Log {{{
call minpac#add('mtdl9/vim-log-highlighting', {'type': 'opt', 'name': 'log'})
augroup ft_log
  au!
  au BufNewFile,BufRead *.log set filetype=log

  au FileType log call LoadLogFT()
  function! LoadLogFT()

    if exists('b:log_ft')
      return
    endif

    PackAdd log 1

    let b:log_ft = 1

  endfunction

augroup END
"  }}}
" Terraform {{{
call minpac#add('hashivim/vim-terraform', {'type': 'opt', 'name': 'terraform'})
augroup ft_terraform
  au!

  au FileType terraform call LoadTerraformFT()
  function! LoadTerraformFT()

    if exists('b:terraform_ft')
      return
    endif

    PackAdd terraform 1
    let g:terraform_align=1
    let g:terraform_fmt_on_save=1

    PackAdd ale
    call ale#linter#Define('terraform', {
          \   'name': 'terraform-lsp',
          \   'lsp': 'stdio',
          \   'executable': 'terraform-lsp',
          \   'command': '%e',
          \   'project_root': getcwd(),
          \})

    PackAdd rooter

    let b:terraform_ft = 1

  endfunction

augroup END
"  }}}
" LUA {{{
augroup ft_lua
  au!

  au FileType lua call LoadLUAFT()
  function! LoadLUAFT()

    if exists('b:lua_ft')
      return
    endif

    PackAdd ale
    call ale#linter#Define('lua', {
          \   'name': 'lua-language-server',
          \   'lsp': 'stdio',
          \   'executable': 'lua-language-server',
          \   'command': '%e',
          \   'project_root': getcwd(),
          \})

    " PackAdd splitjoin

    let b:lua_ft = 1

  endfunction

augroup END
" }}}
" XML {{{
call minpac#add('sukima/xmledit', {'type': 'opt', 'name': 'make'})
augroup ft_xml
  au!

  au FileType xml call LoadXMLFT()
  function! LoadXMLFT()

    if exists('b:xml_ft')
      return
    endif

    PackAdd xml 1

    let b:xml_ft = 1

  endfunction

augroup END
" }}}
" }}}

" UI {{{
" Autoread {{{
call minpac#add('djoshea/vim-autoread', {'type': 'start', 'name': 'autoread'})
let autoreadargs={'autoread':1}
" }}}
" Colorscheme {{{
call minpac#add('KeitaNakamura/neodark.vim', {'type': 'opt', 'name': 'neodark'})
PackAdd neodark
let g:neodark#background = '#282c34'
colorscheme neodark

" Mark 80-th character
hi OverLength ctermbg=168 guibg=#ebabb8 ctermfg=250 guifg=#3c3e42
call matchadd('OverLength', '\%81v', 100)

" Change cursor color to make it more visible
hi Cursor ctermbg=140 guibg=#B888E2
" }}}
" Fuzzy {{{
call minpac#add('junegunn/fzf', {'type': 'opt', 'name': 'fzf'})
call minpac#add('junegunn/fzf.vim', {'type': 'opt', 'name': 'fzf.vim'})

PackAdd fzf
PackAdd fzf.vim

tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
" command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4.. --preview',
"       \ 'source': 'ag --hidden --ignore .git -U -p ~/.gitexcludes --nogroup --column --color "^(?=.)"'}, <bang>0)
"
command! -bang -nargs=* Rg
      \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
      \ 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=.idea --exclude=log'

nnoremap <silent> <leader>of :Files<CR>
nnoremap <silent> <leader>om :Maps<CR>
nnoremap <silent> <leader>oh :History<CR>
nnoremap <silent> <leader>osft :Filetypes<CR>
nnoremap <silent> <leader>osc :Colors<CR>

nmap <silent> <leader>ghf :BCommits<CR>
nmap <silent> <leader>ff :Rg<CR>

nnoremap <leader>bb :Buffers<CR>

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind=ctrl-a:toggle-all,ctrl-space:toggle+down,ctrl-alt-a:deselect-all'
let $FZF_DEFAULT_COMMAND = 'rg --iglob !.git --files --hidden --ignore-vcs --ignore-file ~/.config/git/gitexcludes'
" }}}
" Indent-guides {{{
call minpac#add('nathanaelkane/vim-indent-guides', {'type': 'opt', 'name': 'indent-guides'})

let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=237
hi IndentGuidesEven ctermbg=236

let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_default_mapping = 0

PackAdd indent-guides
" }}}
" Lightline {{{
call minpac#add('itchyny/lightline.vim', {'type': 'start', 'name': 'lightline'})
if !has('gui_running')
  set t_Co=256
endif

let g:lightline = {
      \ 'enable': { 'tabline': 1 },
      \ 'colorscheme': 'neodark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ,
      \             [ 'venv', 'readonly'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'venv': 'virtualenv#statusline'
      \ },
      \ }

let g:lightline.enable.tabline = 0

" }}}
" Marks {{{
call minpac#add('kshenoy/vim-signature', {'type': 'start', 'name': 'marks'})

let g:SignatureMap = {
  \ 'Leader'             :  "m",
  \ 'PlaceNextMark'      :  "",
  \ 'ToggleMarkAtLine'   :  "mm",
  \ 'PurgeMarksAtLine'   :  "m-",
  \ 'DeleteMark'         :  "",
  \ 'PurgeMarks'         :  "",
  \ 'PurgeMarkers'       :  "m<BS>",
  \ 'GotoNextLineAlpha'  :  "",
  \ 'GotoPrevLineAlpha'  :  "",
  \ 'GotoNextSpotAlpha'  :  "]'",
  \ 'GotoPrevSpotAlpha'  :  "['",
  \ 'GotoNextLineByPos'  :  "",
  \ 'GotoPrevLineByPos'  :  "",
  \ 'GotoNextSpotByPos'  :  "",
  \ 'GotoPrevSpotByPos'  :  "",
  \ 'GotoNextMarker'     :  "",
  \ 'GotoPrevMarker'     :  "",
  \ 'GotoNextMarkerAny'  :  "",
  \ 'GotoPrevMarkerAny'  :  "",
  \ 'ListBufferMarks'    :  "m/",
  \ 'ListBufferMarkers'  :  ""
  \ }

nnoremap m/ :Marks<CR>
nnoremap <leader>mm :Marks<CR>
" }}}
" NERTree {{{
call minpac#add('preservim/nerdtree', {'type': 'start', 'name': 'nerdtree'})
call minpac#add('Xuyuanp/nerdtree-git-plugin', {'type': 'start', 'name': 'nerdtree-git'})
call minpac#add('ryanoasis/vim-devicons', {'type': 'start', 'name': 'devicons'})

nnoremap <leader>oe :call NERDTreeToggleCWD()<CR>
nnoremap <Plug>(find_Path) :call FindPathOrShowNERDTree()<CR>

function! NERDTreeToggleCWD()
  NERDTreeToggle
  let currentfile = expand('%')
  if (currentfile == "") || !(currentfile !~? 'NERD')
    NERDTreeCWD
  endif
endfunction

function! FindPathOrShowNERDTree()
  let currentfile = expand('%')
  if (currentfile == "") || !(currentfile !~? 'NERD')
    NERDTreeToggle
  else
    NERDTreeFind
    NERDTreeCWD
  endif
endfunction

nmap <leader>fp <Plug>(find_Path)

let NERDTreeShowBookmarks=0
let NERDTreeChDirMode=2
let NERDTreeMouseMode=2
let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_open_on_gui_startup=0

" make nerdtree look nice
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let g:NERDTreeWinSize=30
let NERDTreeIgnore=['\.pyc$']

" ReMaps
let NERDTreeMapOpenVSplit='v'
let NERDTreeMapOpenSplit='s'
let NERDTreeMapJumpNextSibling=''
let NERDTreeMapJumpPrevSibling=''
let g:NERDTreeMapMenu='<leader>'
let NERDTreeQuitOnOpen=1
let NERDTreeCustomOpenArgs={'file': {'reuse':'all', 'where':'p', 'keepopen':0, 'stay':1}}

" Close vim if the only NERDTree window left
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" Rooter {{{
call minpac#add('airblade/vim-rooter', {'type': 'opt', 'name': 'rooter'})
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1
" }}}
" Tagbar {{{
call minpac#add('preservim/tagbar', {'type': 'start', 'name': 'tagbar'})
noremap <leader>tt :TagbarToggle<CR>

nmap <leader>ft :TagbarOpenAutoClose<CR>
" }}}
" Texting {{{
call minpac#add('junegunn/goyo.vim', {'type': 'opt', 'name': 'goyo'})
call minpac#add('junegunn/limelight.vim', {'type': 'opt', 'name': 'limelight'})

" Spell Check
let g:myLangList=["nospell","en_us", "ru_ru"]

function! ToggleSpell()
  if !exists( "b:myLang" )
    if &spell
      let b:myLang=index(g:myLangList, &spelllang)
    else
      let b:myLang=0
    endif
  endif
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
    " exe "GrammarousReset"
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
    " execute "GrammarousCheck"
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
endfunction

nnoremap <silent> <F7> :call ToggleSpell()<CR>

nnoremap <silent> <leader>ts :call ToggleSpell()<CR>
imap <silent> <F7> <ESC>:call ToggleSpell()<CR>a

" Focus on the process
"
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  set wrap
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  set nowrap
  Limelight!
  " ...
endfunction

au! User GoyoEnter nested call <SID>goyo_enter()
au! User GoyoLeave nested call <SID>goyo_leave()

function! StartGoyo()

  if !exists("g:goyo_loaded")
    let g:goyo_loaded = 1
    let g:goyo_width = 120
    let g:goyo_height = "90%"
    PackAdd goyo
    PackAdd limelight
  endif

  Goyo

endfunction

nnoremap <silent> <leader>tT :call StartGoyo()<CR>
" }}}
" Tmux {{{
call minpac#add('christoomey/vim-tmux-navigator', {'type': 'start', 'name': 'tmux-navigator'})
call minpac#add('benmills/vimux', {'type': 'opt', 'name': 'vimux'})
if exists('$TMUX')
  if has('nvim')
    nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
  endif

  let g:tmux_navigator_save_on_switch = 2
  let g:tmux_navigator_disable_when_zoomed = 1

  PackAdd vimux

  " Override RunCmd command
  function! RunCmd(cmd)
    mark z
    exe VimuxRunCommand(a:cmd)
    exe "normal! g`z"
    delmark z
  endfunction

  function! CloseRunner()
    if exists('g:VimuxRunnerIndex')
      let choice = confirm("Close runner?", "\n&yes\n&no\nor &detach", 2)

      if choice == 2
        VimuxCloseRunner
      elseif choice == 4
        unlet g:VimuxRunnerIndex
      endif
    else
      echo "Runner is not registered"
    endif
  endfunction

  nmap <leader>rRq :call CloseRunner()<CR>
  nmap <leader>rRx :VimuxInterruptRunner<CR>
  let g:VimuxHeight = "20"
  let g:VimuxUseNearest = 0
endif
" }}}
" Undo {{{
call minpac#add('mbbill/undotree', {'type': 'start', 'name': 'undo'})
nnoremap <silent> <leader>u :UndotreeToggle<CR>
" }}}
" Which-Key {{{
call minpac#add('liuchengxu/vim-which-key', {'type': 'opt', 'name': 'which-key'})
PackAdd which-key

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

nnoremap <silent> <localleader> :<c-u>WhichKey  '\'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '\'<CR>
" }}}
" Xkb {{{
call minpac#add('lyokha/vim-xkbswitch', {'type': 'start', 'name': 'xkbswitch'})

if executable('nix-store')
  let cmd = 'nix-store -r $(which xkb-switch) 2>/dev/null'
  let result = substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
  let g:XkbSwitchLib = result . '/lib/libxkbswitch.so'
endif

let g:XkbSwitchEnabled = 1
let g:XkbSwitchSkipFt = [ 'nerdtree', 'coc-explorer' ]
" }}}
" Zoom {{{
call minpac#add('dhruvasagar/vim-zoom', {'type': 'start', 'name': 'vim-zoom'})

nmap <leader>Z :call ZoomToggle()<CR>

function! ZoomToggle()
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ':NERDTreeClose'
    let zoom_nerd = 1
  endif

  if (exists("t:tagbar_buf_name") && bufwinnr(t:tagbar_buf_name) != -1)
    exe ':TagbarClose'
    let zoom_tag = 1
  endif

  if (exists("t:coc_explorer_tab_id") && bufwinnr('coc-explorer') != -1)
    execute bufwinnr('coc-explorer') 'wincmd q'
    let zoom_explorer = 1
  endif

  call zoom#toggle()

  if (exists("zoom_nerd") && (zoom_nerd == 1))
    exe ':NERDTreeCWD'
    exe ':wincmd p'
    unlet zoom_nerd
  endif

  if (exists("zoom_tag") && (zoom_tag == 1))
    exe ':TagbarOpen'
    unlet zoom_tag
  endif

  if (exists("zoom_explorer") && (zoom_explorer == 1))
    exe ':CocCommand explorer --no-toggle --no-focus'
    unlet zoom_explorer
  endif

endfunction
" }}}
" Buffers {{{
call minpac#add('schickling/vim-bufonly', {'type': 'start', 'name': 'bufonly'})

nmap <silent><leader>bq :Bonly<CR>

" }}}
" }}}

" Code {{{
" Ale {{{
call minpac#add('w0rp/ale', {'type': 'opt', 'name': 'ale'})
" let g:ale_sign_column_always = 1
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '..'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_insert_leave = 0
let g:ale_completion_enabled = 0
" }}}
" AutoIndent {{{
call minpac#add('tpope/vim-sleuth', {'type': 'start', 'name': 'auto-indent'})
" }}}
" Commentary {{{
call minpac#add('tpope/vim-commentary', {'type': 'start', 'name': 'commentary'})
set commentstring=#\ %s
" }}}
" Completor {{{
call minpac#add('neoclide/coc.nvim', {'type': 'opt', 'name': 'coc', 'rev': 'release'})
PackAdd coc
let g:coc_user_config = {}
set shortmess+=c
"  Plugin list {{{
let g:coc_global_extensions = [
      \ 'coc-marketplace',
      \ 'coc-pyright',
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-vimlsp',
      \ 'coc-markdownlint',
      \ 'coc-yaml',
      \ 'coc-json',
      \ 'coc-snippets',
      \ 'coc-spell-checker',
      \ 'coc-sql'
      \]
" }}}
"  Mappings {{{
"    General {{{
nmap <leader>pcm :CocList marketplace<CR>
nmap <leader>pcu :CocUpdate<CR>
nmap <leader>pcl :CocList extensions<CR>
"    }}}
"    Code completion {{{
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1, 2) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0, 2) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 2)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 2)\<cr>" : "\<Left>"
" }}}
"    GoTo code navigation {{{
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" }}}
"    Documentation {{{
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
"    }}}
"    Refactoring and formatting {{{
nmap <leader>crn <Plug>(coc-rename)
nmap <leader>crr <Plug>(coc-refactor)
" " Formatting selected code.
xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)

nmap <leader>cc  <Plug>(coc-codeaction-line)
vmap <leader>cc  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>cF  <Plug>(coc-fix-current)

nmap ]d :CocNext<CR>
nmap [d :CocPrev<CR>
nmap <leader>cd  :CocList diagnostics<CR>
"    }}}
"    Map function and class text objects {{{
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" }}}
" }}}
" " coc-explorer {{{
" " let g:coc_user_config['coc.preferences.jumpCommand'] = 'vsp'
" let g:coc_user_config['explorer.keyMappings.global.<tab>'] = v:false
" let g:coc_user_config['explorer.keyMappings.global.<space>'] = 'actionMenu'
" " let g:coc_user_config['explorer.keyMappings.global.s'] = 'open:split'
" let g:coc_user_config['explorer.keyMappings.global.v'] = 'open:vsplit'
" let g:coc_user_config['explorer.keyMappings.global.<cr>'] = ["wait", "expandable?", "cd", "open:sourceWindow"]
" let g:coc_user_config['explorer.keyMappings.global.m'] = 'rename'
" let g:coc_user_config['explorer.keyMappings.global.il'] = 'previewOnHover:toggle:labeling'
" let g:coc_user_config['explorer.keyMappings.global.ic'] = 'previewOnHover:toggle:content'
" let g:coc_user_config['explorer.keyMappings.global.ii'] = 'previewOnHover:disable'
" let g:coc_user_config['explorer.keyMappings.global.I'] = 'toggleHidden'
" let g:coc_user_config['explorer.keyMappings.global.Ic'] = v:false
" let g:coc_user_config['explorer.keyMappings.global.Il'] = v:false
" let g:coc_user_config['explorer.keyMappings.global.II'] = v:false
" let g:coc_user_config['explorer.keyMappings.global.dd'] = 'delete'
" let g:coc_user_config['explorer.keyMappings.global.u'] = ["wait", "gotoParent"]

" let g:coc_user_config['explorer.diagnostic.displayMax'] = 0

" let g:coc_user_config['explorer.icon.enableNerdfont'] = v:true
" let g:coc_user_config['explorer.file.showHiddenFiles'] = v:true

" let g:coc_user_config['explorer.file.showHiddenFiles'] = v:true

" let g:coc_user_config['explorer.trash.command'] = 'trash-put %l --trash-dir ~/.local/share/Trash'

" let g:coc_explorer_global_presets = {
" \   'buffer': {
" \     'sources': [{'name': 'buffer', 'expand': v:true}],
" \     'quit-on-open': v:true,
" \   },
" \ }

" function ExplorerFP()
"   exe ':CocCommand explorer --no-toggle --quit-on-open'
"   call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal'], [['relative', 0, 'file']])
" endfunction

" let g:lmap.f.p = 'Path(coc)'
" nnoremap <leader>fp :call ExplorerFP()<CR>

" let g:lmap.o.e = 'Explorer(coc)'
" nnoremap <leader>oe :CocCommand explorer --toggle --no-focus --sources=file+<CR>

" function ExplorerFB()
"   exe ':CocCommand explorer --no-toggle --preset buffer --quit-on-open'
"   call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal'], [['relative', 0, 'buffer']])
" endfunction

" let g:lmap.f.b = 'Buffer(coc)'
" nnoremap <leader>fb :call ExplorerFB()<CR>
" }}}
" }}}
" Easyalign {{{
call minpac#add('junegunn/vim-easy-align', {'type': 'start', 'name': 'easy-align'})
nmap ga <Plug>(LiveEasyAlign)
xmap ga <Plug>(LiveEasyAlign)
" }}}
" Find and Replace {{{
call minpac#add('brooth/far.vim', {'type': 'start', 'name': 'far'})

let g:far#source = 'agnvim'
let g:far#file_mask_favorites = ['%', '.*', '\.py$', '\.go$']

nnoremap <leader>fr :Far<space>
vnoremap <leader>fr :Far<space>

" }}}
" Git {{{
call minpac#add('tpope/vim-fugitive', {'type': 'opt', 'name': 'fugitive'})
call minpac#add('tpope/vim-rhubarb', {'type': 'opt', 'name': 'rhubarb'})
call minpac#add('shumphrey/fugitive-gitlab.vim', {'type': 'opt', 'name': 'gitlab'})

PackAdd fugitive
PackAdd rhubarb
PackAdd gitlab

" let g:fugitive_gitlab_domains = ['https://my.gitlab.com']

" Helper
function! GitShowBlockHistory()
  exe ":G log -L " . string(getpos("'<'")[1]) . "," . string(getpos("'>'")[1]) . ":%"
endfunction

" Fugitive options
au BufEnter */.git/index nnoremap <buffer> <silent> c :WhichKey 'c'<CR>
au BufEnter */.git/index nnoremap <buffer> <silent> d :WhichKey 'd'<CR>
au BufEnter */.git/index nnoremap <buffer> <silent> r :WhichKey 'r'<CR>
"
" shortcuts mapping
nmap <silent> <leader>gs :Gstatus<CR>
nmap <silent> <leader>gd :Gdiff<CR>
nmap <silent> <leader>gC :Gcommit<CR>
nmap <silent> <leader>gW :Gwrite<CR>
nmap <silent> <leader>gR :Gread<CR>

nmap <silent> <leader>gbl :Gblame<CR>

nmap <silent> <leader>gps :G push<CR>
nmap <silent> <leader>gplr :G pull --rebase<CR>
nmap <silent> <leader>gplm :G pull<CR>
nmap <silent> <leader>gg :.Gbrowse %<CR>
vmap <silent> <leader>gg :'<,'>Gbrowse %<CR>
vmap <silent> <leader>ghv :<C-U>call GitShowBlockHistory()<CR>

" Gitgutter options
call minpac#add('airblade/vim-gitgutter', {'type': 'opt', 'name': 'gitgutter'})
PackAdd gitgutter
let g:gitgutter_map_keys = 0

nmap [g <Plug>(GitGutterPrevHunk)
nmap ]g <Plug>(GitGutterNextHunk)

let g:gitgutter_override_sign_column_highlight = 0

nmap <leader>ghs :GitGutterStageHunk<CR>
nmap <leader>ghr :GitGutterUndoHunk<CR>
nmap <leader>ghp :GitGutterPreviewHunk<CR>

" Gitv options
call minpac#add('junegunn/gv.vim', {'type': 'opt', 'name': 'gv'})
PackAdd gv

let g:Gitv_DoNotMapCtrlKey = 1
nmap <silent> <leader>ghh :GV<CR>

" Git messages in popup
call minpac#add('rhysd/git-messenger.vim', {'type': 'opt', 'name': 'git-messenger'})
PackAdd git-messenger
let g:git_messenger_no_default_mappings = v:true
nunmap <leader>gm
let g:git_messenger_always_into_popup = v:false
nmap <Leader>gbb <Plug>(git-messenger)
" }}}
" Snippets {{{
call minpac#add('honza/vim-snippets', {'type': 'start', 'name': 'snippets'})
" }}}
" SpeedDating {{{
call minpac#add('tpope/vim-speeddating', {'type': 'opt', 'name': 'speeddating'})
" }}}
" Surround {{{
call minpac#add('tpope/vim-surround', {'type': 'start', 'name': 'surround'})
let g:surround_113="#{\r}"       " v
let g:surround_35="#{\r}"        " #
let g:surround_45="{%- \r -%}"   " -
let g:surround_61="{%= \r =%}"   " =

" div
let g:surround_{char2nr("d")} = "<div\1id: \r..*\r id=\"&\"\1>\r</div>"
" xml
let g:surround_{char2nr("x")} = "<\1id: \r..*\r&\1>\r</\1\1>"

let g:surround_{char2nr("%")} = "{% \r %}"

" }}}
" Split/Join {{{
call minpac#add('andrewradev/splitjoin.vim', {'type': 'start', 'name': 'splitjoin'})
" let g:splitjoin_split_mapping = 'gs'
" let g:splitjoin_join_mapping  = 'gj'
nmap gs :SplitjoinSplit<cr>
nmap gj :SplitjoinJoin<cr>

" }}}
" Zeavim {{{
call minpac#add('KabbAmine/zeavim.vim', {'type': 'start', 'name': 'zeavim'})
let g:zv_disable_mapping = 1
let g:zv_file_types = {
                \    '\v^(G|g)runt\.'           : 'gulp,javascript,nodejs',
                \    '\v^(G|g)ulpfile\.'        : 'grunt',
                \    '\v^(md|mdown|mkd|mkdn)$'  : 'markdown',
                \    'yaml.ansible'             : 'ansible',
                \ }
nmap <F1> <Plug>Zeavim
nmap gzz <Plug>Zeavim
vmap gzz <Plug>ZVVisSelection
nmap gZ <Plug>ZVKeyDocset<CR>
nmap gz <Plug>ZVOperator
" }}}
" }}}

" Motion {{{
" Text objects {{{
call minpac#add('kana/vim-textobj-user', {'type': 'start', 'name': 'textobj'})

" adds: f - function
call minpac#add('bps/vim-textobj-python', {'type': 'opt', 'name': 'textobj-python'})

let g:textobj_python_no_default_key_mappings = 1
xmap af <Plug>(textobj-python-function-a)
omap af <Plug>(textobj-python-function-a)
xmap if <Plug>(textobj-python-function-i)
omap if <Plug>(textobj-python-function-i)

" Adds: i - indent, I - the same indent
call minpac#add('kana/vim-textobj-indent', {'type': 'start', 'name': 'textobj-indent'})

" Adds: c - comment, C - whole comment
call minpac#add('glts/vim-textobj-comment', {'type': 'start', 'name': 'textobj-comment'})
" }}}
" Quick Scope {{{
call minpac#add('unblevable/quick-scope', {'type': 'start', 'name': 'quickscope'})
let g:qs_buftype_blacklist = ['terminal', 'nofile', 'nerdtree']
" let g:qs_lazy_highlight = 1
" }}}
" }}}

" Additional {{{
" DraIt {{{
" TODO: Update keys
call minpac#add('ewok/DrawIt', {'type': 'start', 'name': 'drawit'})
" }}}
" VimWiki {{{
call minpac#add('vimwiki/vimwiki', {'type': 'opt', 'name': 'vimwiki', 'branch': 'dev'})
call minpac#add('michal-h21/vim-zettel', {'type': 'opt', 'name': 'zettel'})
call minpac#add('ewok/vimwiki-sync', {'type': 'opt', 'name': 'vimwiki-sync'})

function! LoadVimwiki()

  " Global mapping
  nnoremap <Leader>ww :call VimwikiIndexCd()<CR>
  nnoremap <Leader>wi :VimwikiDiaryIndex<CR>
  nnoremap <Leader>wj :VimwikiDiaryNextDay<CR>
  nnoremap <Leader>wk :VimwikiDiaryPrevDay<CR>
  nnoremap <Leader>wk :VimwikiDiaryPrevDay<CR>
  nnoremap <Leader>wmc :VimwikiCheckLinks<CR>
  nnoremap <leader>wmt :VimwikiRebuildTags<CR>
  nnoremap <leader>wt :call VimwikiMakeDiaryNoteNew()<CR>


  " Links mapping
  " see in vimwiki file type

endfunction

function! VimwikiIndexCd()
  VimwikiIndex
  cd %:h
endfunction

function! VimwikiMakeDiaryNoteNew()
  VimwikiMakeDiaryNote
  cd %:h:h
endfunction

let g:vimwiki_list = [{'path': '~/Notes/',
      \ 'syntax': 'markdown', 'ext': '.md',
      \ 'auto_toc': 1,
      \ 'auto_diary_index': 1,
      \ 'list_margin': 0,
      \ 'custom_wiki2html': 'vimwiki-godown',
      \ 'links_space_char': '_',
      \ 'auto_tags': 1}]

let g:vimwiki_ext2syntax = {'.md': 'markdown',
      \ '.mkd': 'markdown',
      \ '.wiki': 'media'}

let g:vimwiki_folding = 'expr'
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_commentstring = '<!--%s-->'
let g:vimwiki_auto_header = 1
let g:vimwiki_create_link = 0
let g:vimwiki_key_mappings =
  \ {
  \ 'global': 0,
  \ 'links': 0
  \ }

" make_note_link: List -> Str
" returned string: [Title](YYYYMMDDHH.md)
function! s:make_note_link(l)
  " fzf#vim#complete returns a list with all info in index 0
  let line = split(a:l[0], ':')
  let ztk_id = l:line[0]

  try
    let ztk_title = substitute(l:line[2], '\#\+\s\+', '', 'g')
  catch
    let ztk_title = substitute(l:line[1], '\#\+\s\+', '', 'g')
  endtry

  let mdlink = "[" . ztk_title ."](". ztk_id .")"

  return mdlink
endfunction

PackAdd vimwiki
PackAdd vimwiki-sync

let g:zettel_format = "%y%m%d-%H%M-%title"
let g:zettel_default_mappings = 0

function! UpdateBacklinks()
  let s:backlinksline = search("# Backlinks", 'wnb')
  if s:backlinksline != 0
    execute s:backlinksline . ",$delete"
    d
  endif
  ZettelBackLinks
endfunction

PackAdd zettel
" }}}
" Sessions {{{
let g:sessiondir = $HOME . "/.vim_sessions"

function! MakeSession(file)

  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ':tabdo NERDTreeClose'
  endif

  if (exists("t:tagbar_buf_name") && bufwinnr(t:tagbar_buf_name) != -1)
    exe ':tabdo TagbarClose'
  endif

  if (exists("t:coc_explorer_tab_id") && bufwinnr('coc-explorer') != -1)
    exe ':tabdo exe bufwinnr("coc-explorer") "wincmd q"'
  endif


  exe ':lclose|cclose'

  let file = a:file

  if (file == "")
    if (exists('g:sessionfile'))
      let b:sessiondir = g:sessiondir
      let file = g:sessionfile
    else
      let b:sessiondir = g:sessiondir . getcwd()
      let file = "session"
    endif
  else
    let b:sessiondir = g:sessiondir
    let g:sessionfile = file
  endif

  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/' . file . '.vim'

  exe "silent mksession! " . b:filename
endfunction

function! LoadSession(file)

  let file = a:file

  if (file == "")
    if (exists('g:sessionfile'))
      let b:sessiondir = g:sessiondir
      let file = g:sessionfile
    else
      let b:sessiondir = g:sessiondir . getcwd()
      let file = "session"
    endif
  else
    let b:sessiondir = g:sessiondir
    let g:sessionfile = file
  endif

  let b:sessionfile = b:sessiondir . '/' . file . '.vim'
  if (filereadable(b:sessionfile))
    exe 'silent source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

function! DeleteSession(file)

  let file = a:file

  if (file == "")
    if (exists('g:sessionfile'))
      let b:sessiondir = g:sessiondir
      let file = g:sessionfile
    else
      let b:sessiondir = g:sessiondir . getcwd()
      let file = "session"
    endif
  else
    let b:sessiondir = g:sessiondir
  endif

  let b:sessionfile = b:sessiondir . '/' . file . '.vim'
  if (filereadable(b:sessionfile))
    exe 'silent !rm -f ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

function! CloseSession()
  if (exists('g:sessionfile'))
    call MakeSession(g:sessionfile)
    unlet g:sessionfile
  else
    call MakeSession("")
  endif
  exe 'silent wa | %bd!'
endfunction

function! CloseSessionAndExit()
  call CloseSession()
  exe 'silent qa'
endfunction

fun! ListSessions(A,L,P)
  return system("ls " . g:sessiondir . ' | grep .vim | sed s/\.vim$//')
endfun

command! -nargs=1 -range -complete=custom,ListSessions MakeSession :call MakeSession("<args>")
command! -nargs=1 -range -complete=custom,ListSessions LoadSession :call LoadSession("<args>")
command! -nargs=1 -range -complete=custom,ListSessions DeleteSession :call DeleteSession("<args>")
command! MakeSessionCurrent :call MakeSession("")
command! LoadSessionCurrent :call LoadSession("")
command! DeleteSessionCurrent :call DeleteSession("")
command! CloseSession :call CloseSession()
command! CloseSessionAndExitCurrent :call CloseSessionAndExit()

nnoremap <Plug>(session_Load) :LoadSession<SPACE>
nnoremap <Plug>(session_Load-Current) :LoadSessionCurrent<CR>
nnoremap <Plug>(session_Make) :MakeSessionCurrent<CR>
nnoremap <Plug>(session_Exit) :CloseSessionAndExit<CR>
nnoremap <Plug>(session_Close) :CloseSession<CR>
nnoremap <Plug>(session_Delete) :DeleteSessionCurrent<CR>

nmap <leader>so <Plug>(session_Load)
nmap <leader>su <Plug>(session_Load-Current)
nmap <leader>ss <Plug>(session_Make)
nmap <leader>sq <Plug>(session_Exit)
nmap <leader>sc <Plug>(session_Close)
nmap <leader>sd <Plug>(session_Delete)
" }}}
" Folding {{{
" Thx Steve Losh
set foldlevelstart=0

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
"
" This mapping wipes out the z mark, which I never use.
"
function! MyFoldText() " {{{
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
  return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" AutoSave feature {{{

" Trigger autoread when changing buffers or coming back to vim.
" au FocusGained,BufEnter,WinEnter * :silent! !

au! FileType vim,python,golang,go,yaml.ansible,puppet,json,sh,vimwiki,rust,yaml,nix call DefaultOn()

function! DefaultOn()
  if !exists("b:auto_save")
    let b:auto_save = 1
  endif
endfunction

set updatetime=4000

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:auto_save_silent")
  let g:auto_save_silent = 0
endif

if !exists("g:auto_save_events")
  let g:auto_save_events = ["CursorHold","CursorHoldI","BufLeave","FocusLost","WinLeave"]
endif

" Check all used events exist
for event in g:auto_save_events
  if !exists("##" . event)
    let eventIndex = index(g:auto_save_events, event)
    if (eventIndex >= 0)
      call remove(g:auto_save_events, eventIndex)
      echo "(AutoSave) Save on " . event . " event is not supported for your Vim version!"
      echo "(AutoSave) " . event . " was removed from g:auto_save_events variable."
      echo "(AutoSave) Please, upgrade your Vim to a newer version or use other events in g:auto_save_events!"
    endif
  endif
endfor

augroup auto_save
  au!
  for event in g:auto_save_events
    execute "au " . event . " * nested call AutoSave()"
  endfor
augroup END

function! AutoSave()
  if &modified > 0
    if !exists("b:auto_save")
      let b:auto_save = 0
    endif

    if b:auto_save == 0
      return
    end

    let was_modified = &modified

    " Preserve marks that are used to remember start and
    " end position of the last changed or yanked text (`:h '[`).
    let first_char_pos = getpos("'[")
    let last_char_pos = getpos("']")

    call DoSave()

    call setpos("'[", first_char_pos)
    call setpos("']", last_char_pos)

    if was_modified && !&modified
      if g:auto_save_silent == 0
        echo "(AutoSave) saved at " . strftime("%H:%M:%S")
      endif
    endif
  endif
endfunction

function! DoSave()
  silent! w
endfunction

function! ToggleAutoSave()
  if !exists("b:auto_save")
    let b:auto_save = 0
  endif

  if b:auto_save == 0
    let b:auto_save = 1
  else
    let b:auto_save = 0
  end
endfunction

command! ToggleAutoSave :call ToggleAutoSave()

let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" Quickfix {{{
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo "Location List is Empty."
    return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

function! QFixSwitch(direction)
  exec('copen')
  if a:direction == 'next'
    try
      cnext
    catch E42
    catch E553
      echom "No more items"
    endtry
  elseif a:direction == 'prev'
    try
      cprevious
    catch E42
    catch E553
      echom "No more items"
    endtry
  else
    echom "Unknown direction"
  endif
endfunction

nnoremap <Plug>(qfix_Toggle) :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <Plug>(qfix_Open) :copen<CR>
nnoremap <Plug>(qfix_Close) :cclose<CR>
nnoremap <Plug>(qfix_QNext) :call QFixSwitch('next')<CR>
nnoremap <Plug>(qfix_QPrev) :call QFixSwitch('prev')<CR>
nmap <leader>qq  <Plug>(qfix_Toggle)
nmap <leader>qo <Plug>(qfix_Open)
nmap <leader>qc <Plug>(qfix_Close)
nmap <leader>qn <Plug>(qfix_QNext)
nmap ]q <Plug>(qfix_QNext)
nmap <leader>qp <Plug>(qfix_QPrev)
nmap [q <Plug>(qfix_QPrev)

nnoremap <Plug>(qfix_LToggle) :call ToggleList("Location List", 'l')<CR>
nnoremap <Plug>(qfix_LOpen) :lopen<CR>
nnoremap <Plug>(qfix_LClose) :lclose<CR>
nnoremap <Plug>(qfix_LNext) :lnext<CR>
nnoremap <Plug>(qfix_LPrev) :lprev<CR>
nmap <leader>ll  <Plug>(qfix_LToggle)
nmap <leader>lo <Plug>(qfix_LOpen)
nmap <leader>lc <Plug>(qfix_LClose)
nmap <leader>ln <Plug>(qfix_LNext)
nmap ]l <Plug>(qfix_LNext)
nmap <leader>lp <Plug>(qfix_LPrev)
nmap [l <Plug>(qfix_LPrev)
" }}}
" TODOs {{{
nnoremap <leader>ot :call OpenToDo()<CR>
function! OpenToDo()
  vsplit TODO.md
  nnoremap <buffer> q :x<CR>

  call LoadTODOFT()
endfunction
" }}}
" Small plugins {{{
call minpac#add('ntpeters/vim-better-whitespace', {'type': 'start', 'name': 'better-whitespace'})
let g:better_whitespace_filetypes_blacklist=['gitcommit', 'unite', 'qf', 'help', 'dotooagenda', 'dotoo']
nmap <leader>tfw :StripWhitespace<CR>

call minpac#add('jiangmiao/auto-pairs', {'type': 'start', 'name': 'auto-pairs'})

call minpac#add('junegunn/vim-peekaboo', {'type': 'start', 'name': 'peekaboo'})
let g:peekaboo_delay = 1000

call minpac#add('chaoren/vim-wordmotion', {'type': 'start', 'name': 'wordmotion'})

call minpac#add('tpope/vim-repeat', {'type': 'start', 'name': 'repeat'})

call minpac#add('powerline/fonts', {'type': 'opt', 'name': 'fonts'})

call minpac#add('PeterRincker/vim-yankitute', {'type': 'start', 'name': 'yankitute'})
" }}}
" }}}

" Leader end
call which_key#register('<Space>', "g:lmap")

" Start {{{
au! VimEnter * call AfterVimEnter()
function! AfterVimEnter()
  if g:largefile != 1
    exe ":IndentGuidesEnable"
  endif

  call LoadVimwiki()
endfunction
" }}}

" Load local vars {{{
"
try
  source ~/.vimrc.local
catch
  " Ignoring
endtry
" }}}
