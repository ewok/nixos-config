(local {: path_join :set set! : cmd!} (require :lib))
(local conf (require :conf))

(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\\")

(if conf.options.pbclip
    (set vim.g.clipboard {:name :orb
                          :copy {:+ [:pbcopy] :* [:pbcopy]}
                          :paste {:+ [:pbpaste] :* [:pbpaste]}
                          :cache_enabled 1}))

(local settings
       {:shell :bash
        :backspace :2
        :backup false
        :clipboard "unnamed,unnamedplus"
        :cmdheight 1
        :compatible false
        :confirm true
        :encoding :utf-8
        :enc :utf-8
        :errorbells false
        :exrc true
        :hidden true
        :history 1000
        :hlsearch true
        :ignorecase true
        :incsearch true
        :laststatus 2
        :linespace 0
        :mouse :a
        :ruler true
        :scrolloff 3
        :secure true
        :shortmess :aOtTsI
        :showmode true
        :showtabline 2
        :smartcase true
        :smarttab true
        :splitbelow true
        :splitright true
        :startofline false
        :switchbuf :useopen
        :termguicolors true
        :timeoutlen 500
        :titlestring "%F"
        :title true
        :ttimeoutlen -1
        :ttyfast true
        :undodir (path_join conf.cache_dir :.vim_undo)
        :undolevels 100
        :updatetime 300
        :visualbell true
        :writebackup false
        :shada (.. "'50,<1000,s100,\"10,:10,f0,n" conf.data_dir
                   :/shada/main.shada)
        :inccommand :nosplit
        :bomb false
        :copyindent true
        :expandtab true
        :fenc :utf-8
        :shiftwidth 4
        :softtabstop 4
        :swapfile false
        :synmaxcol 1000
        :tabstop 4
        :undofile true
        :cursorline true
        :number true
        :foldenable false
        :wrap false
        :list true
        :linebreak true
        :numberwidth 2
        :signcolumn "yes:1"
        :pumheight 10
        :filetype :plugin
        :smartindent true
        :iskeyword "@,48-57,_,192-255"
        :fillchars "eob: "
        :sessionoptions "buffers,curdir,folds,tabpages,winsize,globals,winpos"})

(each [key value (pairs settings)]
  (let [key (tostring key)]
    (tset vim.opt key value)))

(set! "" :whichwrap "<>[]hl" :append)

(vim.cmd "
filetype plugin indent on

syntax on
syntax enable

if exists('+termguicolors')
  let &t_8f = \"\\<Esc>[38;2;%lu;%lu;%lum\"
  let &t_8b = \"\\<Esc>[48;2;%lu;%lu;%lum\"
  set termguicolors
endif
")

; " Dynamic timeoutlen
(vim.api.nvim_create_autocmd [:InsertEnter]
                             {:command "set timeoutlen=1000" :pattern ["*"]})

(vim.api.nvim_create_autocmd [:InsertLeave]
                             {:command "set timeoutlen=500" :pattern ["*"]})

(vim.fn.setenv :ZK_NOTEBOOK_DIR conf.notes_dir)

;; Wildmenu
(tset vim.opt :wildmode "longest,list")
(set! "" :wildignore (.. "*.o,*.obj,*.pyc," "*.png,*.jpg,*.gif,*.ico,"
                         "*.swf,*.fla," "*.mp3,*.mp4,*.avi,*.mkv,"
                         "*.git*,*.hg*,*.svn*," "*sass-cache*," "*.DS_Store,"
                         "log/**," :tmp/**) :append)

;; Turn off lsp logs
(vim.lsp.set_log_level :off)
