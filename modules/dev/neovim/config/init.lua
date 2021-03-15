-- vim: ts=2 sw=2 sts=2

-- Helpers {{{
  function augroups(definitions)
    for group_name, definition in pairs(definitions) do
      vim.api.nvim_command('augroup '..group_name)
      vim.api.nvim_command('autocmd!')
      for _, def in ipairs(definition) do
        -- if type(def) == 'table' and type(def[#def]) == 'function' then
        -- 	def[#def] = lua_callback(def[#def])
        -- end
        local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
        vim.api.nvim_command(command)
      end
      vim.api.nvim_command('augroup END')
    end
  end

  local api = vim.api
  local cmd = vim.cmd
  local execute = api.nvim_command
  local exec = api.nvim_exec
  local fn = vim.fn
  local oget = api.nvim_get_option
  -- set
  local oset = api.nvim_set_option
  map = api.nvim_set_keymap
  local function bmap(mode, key, comm, flags)
    api.nvim_buf_set_keymap(api.nvim_get_current_buf(), mode, key, comm, flags)
  end
-- }}}
--

-- Init Packer Plugin {{{
  local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
  end

  cmd [[packadd packer.nvim]]

  local packer = require('packer')
  packer.startup(function(use)
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}
  end)
-- }}}

-- Basic options {{{
  vim.g.mapleader = ' '
  vim.g.maplocalleader = '\\'

  -- Common {{{
    -- NVIM specific
    local set_options = {
      shell = 'bash';
      backspace = '2';
      backup = false;
      clipboard = 'unnamedplus';
      cmdheight = 1;
      compatible = false;
      confirm = true;
      encoding = 'utf-8';
      enc = 'utf-8';
      errorbells = false;
      exrc = true;
      hidden = true;
      history = 1000;
      hlsearch = true;
      ignorecase = true;
      incsearch = true;
      laststatus = 2;
      linespace = 0;
      mouse = '';
      ruler = true;
      scrolloff = 5;
      secure = true;
      shortmess = 'aOtT';
      showmode = true;
      showtabline = 1;
      smartcase = true;
      smarttab = true;
      splitbelow = true;
      splitright = true;
      startofline = false;
      switchbuf = 'useopen';
      timeoutlen = 500;
      titlestring = '%F';
      title = true;
      ttimeoutlen = -1;
      ttyfast = true;
      undodir = '~/.vim_undo';
      undolevels = 100;
      visualbell = true;
      writebackup = false;
      guicursor = 'n-v-c:block,i-ci-ve:block,r-cr:hor20,'..
      'o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,'..
      'sm:block-blinkwait175-blinkoff150-blinkon175';
      shada = [['50,<1000,s100,"10,:10,n~/.viminfo]];
      inccommand = 'nosplit';

      -- Buf opts
      bomb = true;
      copyindent = true;
      expandtab = true;
      fenc = 'utf-8';
      shiftwidth = 4;
      softtabstop = 4;
      swapfile = false;
      synmaxcol = 1000;
      tabstop = 4;
      undofile = true;

      -- Window opts
      cursorline = true;
      number = true;
      foldenable = false;
      wrap = false;
      list = false;
      linebreak = true;
      numberwidth = 4;
    }

    local start_window = api.nvim_get_current_win()
    local start_buf = api.nvim_get_current_buf()
    for opt, val in pairs(set_options) do
      local info = api.nvim_get_option_info(opt)
      local scope = info.scope
      local global_local = info.global_local

      -- print(opt..'('..scope..'): '.. tostring(global_local))

      if scope == 'global' or global_local then
        oset(opt, val)
        local test_val = oget(opt)
        if val ~= test_val then
          print(opt..' is not set')
        end
      elseif scope == 'win' then
        api.nvim_win_set_option(start_window, opt, val)
        local test_val = api.nvim_win_get_option(start_window, opt)
        if val ~= test_val then
          print(opt..' is not set')
        end
      elseif scope == 'buf' then
        api.nvim_buf_set_option(start_buf, opt, val)
        local test_val = api.nvim_buf_get_option(start_buf, opt)
        if val ~= test_val then
          print(opt..' is not set')
        end
      else
        print(opt..' has '..scope.. ' scope.')
      end
    end

    -- let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    -- let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

    exec([[
    if !isdirectory($HOME . "/.vim_undo")
      call mkdir($HOME . "/.vim_undo", "p", 0700)
    endif

    filetype plugin indent on

    syntax on
    syntax enable

    if (has("termguicolors"))
      set termguicolors
    endif

    if exists('+termguicolors')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif

    " Dynamic timeoutlen
    au InsertEnter * set timeoutlen=1000
    au InsertLeave * set timeoutlen=500
    ]], true)
  -- }}}
  -- Wildmenu completion {{{
    oset('wildmenu', true)
    oset('wildmode', 'longest,list')

    oset('wildignore', oget('wildignore')..
    '*.o,*.obj,*.pyc,'..
    '*.png,*.jpg,*.gif,*.ico,'..
    '*.swf,*.fla,'..
    '*.mp3,*.mp4,*.avi,*.mkv,'..
    '*.git*,*.hg*,*.svn*,'..
    '*sass-cache*,'..
    '*.DS_Store,'..
    'log/**,'..
    'tmp/**')
  -- }}}
  -- cursorline {{{
    local cline = {
      {'WinLeave,InsertEnter * set nocursorline'};
      {'WinEnter,InsertLeave * set cursorline'};
    }
    augroups({cline=cline})
  -- }}}
  -- Restore Cursor {{{
    local line_return = {
      {[[BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |]]..
      [[execute 'normal! g`"zvzz' | endif]]};
    }
    augroups({line_return=line_return})
  -- }}}
  -- Dealing with largefiles  {{{
    -- Protect large files from sourcing and other overhead.
    vim.g.large_file_size = 1024*1024*2
    function adj_if_largefile()
      local fname = vim.fn.expand('<afile>')
      if vim.fn.getfsize(fname) > vim.g.large_file_size then
        if vim.fn.input('Large file detected, t-off features?(y/n )', 'y') == 'y' then
          vim.cmd [[ setlocal inccommand= ]]
          vim.bo.swapfile = false
          vim.bo.bufhidden = 'unload'
          vim.bo.undolevels = -1
          vim.cmd [[ setlocal eventignore+=FileType ]]
          vim.g.largefile = true
        else
          vim.g.largefile = false
        end
      end
    end
    local au_largefile = {
      {[[ BufReadPre * lua adj_if_largefile() ]]}
    }
    augroups({au_largefile=au_largefile})
  -- }}}
  -- Number Toggle {{{
    function rnu_on()
      if oget('showcmd') then
        vim.wo.rnu = true
      end
    end
    function rnu_off()
      if oget('showcmd') then
        vim.wo.rnu = false
      end
    end
    vim.wo.rnu = true
    local rnu = {
      {'InsertEnter * lua rnu_off()'};
      {'InsertLeave * lua rnu_on()'};
    }
    augroups({rnu=rnu})
  -- }}}
  -- RunCmd {{{
    exec([[
    function! RunCmd(cmd)
      exe "!" . a:cmd
    endfunction
    ]], true)
  -- }}}
-- }}}

-- Helpers {{{
  exec([[
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
  ]], true)
-- }}}

-- Keymaps {{{
  -- Tabs {{{
    map('n', '<C-W>t', ':tabnew<CR>', { noremap = true })
    map('n', '<Tab>', ':tabnext<CR>', { noremap = true })
    map('n', '<S-Tab>', ':tabprev<CR>', { noremap = true })
  -- }}}
  -- Windows {{{
    if fn.exists('$TMUX') == 1 then
      map('n', '<Plug>(window_split-tmux)', ':!tmux split-window -v -p 20<CR><CR>', { noremap = true })
      map('n', '<C-W>S', '<Plug>(window_split-tmux)', { silent = true })

      map('n', '<Plug>(window_vsplit-tmux)', ':!tmux split-window -h -p 20<CR><CR>', { noremap = true })
      map('n', '<C-W>V', '<Plug>(window_vsplit-tmux)', { silent = true })
    else
      map('n', '<C-W>S', ':split terminal<CR>i', {})
      map('n', '<C-W>V', ':vsplit terminal<CR>i', {})
    end
    -- Resize Windows
    map('n', '<C-W><C-J>', ':resize +5<CR>', {})
    map('n', '<C-W><C-K>', ':resize -5<CR>', {})
    map('n', '<C-W><C-L>', ':vertical resize +5<CR>', {})
    map('n', '<C-W><C-H>', ':vertical resize -5<CR>', {})
  -- Don't close last window
    map('n', '<C-W>q', ':close<CR>', {})
  -- }}}
  -- Folding {{{
    map('n', '<space><space>', 'za"{{{"', { noremap = true, silent = true })
    map('n', 'z.', 'mzzMzvzz15<c-e>`z', { noremap = true, silent = true })
    map('v', '<space><space>', 'zf"}}}"', { noremap = true, silent = true })
    -- Make zO recursively open whatever fold we're in, even if it's partially open.
    map('n', 'zO', 'zczO', { noremap = true })
    -- Close recursively
    map('n', 'zC', 'zcV:foldc!<CR>', { noremap = true })
    -- Navigation
    map('n', 'zj', 'zjmzzMzvzz15<c-e>`z', {})
    map('n', 'zk', 'zkmzzMzvzz15<c-e>`z', {})
  -- }}}
  -- Yank {{{
    -- Don't know how to do that natively yet
    -- map('n', 'MR', ':%s/\\(' .. fn.getreg('/') .. '\\)/\1/g<LEFT><LEFT>', { expr = true })
    exec([[
      nmap <expr>  MR  ':%s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
      vmap <expr>  MR  ':s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
    ]], true)
    -- Replace without yanking
    map('v', 'p', ':<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>', { noremap = true })
    -- Permanent buffer
    map('n', '<leader>yy', ':.w! ~/.vbuf<CR>', {})
    map('v', '<leader>yy', [[:'<,'>w! ~/.vbuf<CR>]], {})
    map('n', '<leader>yp', ':r ~/.vbuf<CR>', {})
    -- Yank some file data
    map('n', '<leader>yfl', [[:let @+=expand("%") . ':' . line(".")<CR>]], { noremap = true })
    map('n', '<leader>yfn', [[:let @+=expand("%")<CR>]], { noremap = true })
    map('n', '<leader>yfp', [[:let @+=expand("%:p")<CR>]], { noremap = true })
  -- }}}
  -- Tunings {{{
    map('n', 'Y', 'y$', { noremap = true })
    -- Don't yank to default register when changing something
    map('n', 'c', '"xc', { noremap = true })
    map('x', 'c', '"xc', { noremap = true })
    -- Don't cancel visual select when shifting
    map('x', '<', '<gv', { noremap = true })
    map('x', '>', '>gv', { noremap = true })
    -- Keep the cursor in place while joining lines
    map('n', 'J', 'mzJ`z', { noremap = true })
    -- [S]plit line (sister to [J]oin lines) S is covered by cc.
    map('n', 'S', 'mzi<CR><ESC>`z', { noremap = true })
    -- Don't move cursor when searching via *
    map('n', '*', ':let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<CR>', { noremap = true, silent = true })
    -- Keep search matches in the middle of the window.
    map('n', 'n', 'nzzzv', { noremap = true })
    map('n', 'N', 'Nzzzv', { noremap = true })

    map('n', 'H', '0', { noremap = true })
    map('n', 'L', '$', { noremap = true })
    map('v', 'H', '0', { noremap = true })
    map('v', 'L', '$', { noremap = true })
    -- Sudo
    map('c', 'w!!', 'w !sudo tee %', {})
  -- }}}
  -- Settings options {{{
    map('n', '<leader>osw', ':set wrap<CR>', {})
    map('n', '<leader>ouw', ':set nowrap<CR>', {})

    map('n', '<leader>osffu', ':set ff=unix<CR>', {})
    map('n', '<leader>osffd', ':set ff=dos<CR>', {})

    map('n', '<leader>osts2', ':set tabstop=2 |set softtabstop=2<CR>', {})
    map('n', '<leader>osts4', ':set tabstop=4 |set softtabstop=4<CR>', {})
  -- }}}
  -- Insert data {{{
    exec([[
      nnoremap <leader>it O<C-R>=split(&commentstring, '%s')[0] . 'TODO: '<CR><CR><C-R>=expand("%:h") . '/' . expand("%:t") . ':' . line(".")<CR><C-G><C-K><C-O>A
      nnoremap <leader>ids a<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR><ESC>
      nnoremap <leader>idm a<C-R>=strftime("%Y-%m-%d %H:%M")<CR><ESC>
      nnoremap <leader>idd a<C-R>=strftime("%Y-%m-%d")<CR><ESC>
    ]], true)
  -- }}}
  -- Packer {{{
    map('n', '<leader>pu', ':PackerUpdate<CR>', {})
    map('n', '<leader>pc', ':PackerClean<CR>', {})
    map('n', '<leader>pC', ':PackerCompile<CR>', {})
    map('n', '<leader>pi', ':PackerInstall<CR>', {})
    map('n', '<leader>ps', ':PackerSync<CR>', {})
  -- }}}
-- }}}

-- Filetypes {{{
  -- Ansible {{{
    packer.use {
      'pearofducks/ansible-vim',
      ft = { 'ansible', 'yaml.ansible' },
      after = 'ale',
      config = function()
        local ansible_template_syntaxes = {}
        ansible_template_syntaxes['*.rb.j2'] = 'ruby'
        ansible_template_syntaxes['*.py.j2'] = 'python'
        vim.g.ansible_template_syntaxes = ansible_template_syntaxes
        vim.g.ansible_unindent_after_newline = 1
        vim.g.ansible_attribute_highlight = 'ob'
        vim.g.ansible_extra_keywords_highlight = 1
        vim.g.ansible_normal_keywords_highlight = 'Constant'
        vim.g.ansible_with_keywords_highlight = 'Constant'

        -- TODO: Fix error popping up
        -- vim.fn['ale#linter#Define']('ansible', {
        --            name = 'ansible_custom',
        --            executable = vim.fn['ale_linters#ansible#ansible_lint#GetExecutable'],
        --            command = '%e %s',
        --            callback=  'ale_linters#ansible#ansible_lint#Handle',
        -- })
        -- exec([[
        --   call ale#linter#Define('ansible', {
        --            'name': 'ansible_custom',
        --            'executable': function('ale_linters#ansible#ansible_lint#GetExecutable'),
        --            'command': '%e %s',
        --            'callback': 'ale_linters#ansible#ansible_lint#Handle',
        --         })
        -- ]], true)

        require'lspconfig'.yamlls.autostart()
      end,
    }
    local ft_ansible = {
      {[[ BufNewFile,BufRead */\(playbooks\|roles\|tasks\|handlers\|defaults\|vars\)/*.\(yaml\|yml\) set filetype=yaml.ansible ]]};
      {[[ FileType yaml.ansible lua ansible_ft() ]]}
    }
    augroups({ft_ansible=ft_ansible})
    function ansible_ft()
      vim.bo.commentstring = [[# %s]]
      vim.b.ale_ansible_ansible_lint_executable = 'ansible_custom'
      vim.b.ale_ansible_ansible_lint_command = '%e %t'
      vim.b.ale_ansible_yamllint_executable = 'yamllint_custom'
      vim.b.ale_linters = { 'yamllint', 'ansible_custom' }
    end
  -- }}}
  -- CSV {{{
    packer.use {
      'chrisbra/csv.vim',
      ft = { 'csv' }
    }
    local ft_csv = {
      {[[ BufNewFile,BufRead *.csv set filetype=csv ]]}
    }
    augroups({ft_csv=ft_csv})
  -- }}}
  -- Config {{{
    local ft_config = {
      {[[ BufNewFile,BufRead *.conf,*.cfg,*.ini set filetype=config ]]};
      {[[ FileType config setlocal commentstring=#\ %s ]]};
    }
    augroups({ft_config=ft_config})
  -- }}}
  -- Dockerfile {{{
    local ft_dockerfile = {
      {[[ FileType dockerfile lua require('lspconfig').dockerls.autostart() ]]};
    }
    augroups({ft_dockerfile=ft_dockerfile})
  -- }}}
  -- Gitignore {{{
    local ft_gitignore = {
      {[[ BufNewFile,BufRead *.gitignore set filetype=gitignore ]]};
    }
    augroups({ft_gitignore=ft_gitignore})
  -- }}}
  -- Go {{{
    packer.use {
      'fatih/vim-go',
      ft = { 'go' },
      config = function()
        vim.g.go_highlight_functions = 1
        vim.g.go_highlight_methods = 1
        vim.g.go_highlight_structs = 1
        vim.g.go_highlight_interfaces = 1
        vim.g.go_highlight_operators = 1
        vim.g.go_highlight_build_constraints = 1
        vim.g.go_auto_sameids = 1
      end,
    }

    local ft_go = {
      {[[ FileType go lua go_ft() ]]}
    }
    augroups({ft_go=ft_go})
    function go_ft()
      bmap('n', '<leader>rr', ':silent GoRun<CR>', { silent = true })
      bmap('n', '<leader>rt', ':silent GoTest<CR>', { silent = true })
      bmap('n', '<leader>rb', ':silent GoBuild<CR>', { silent = true })
      bmap('n', '<leader>rc', ':silent GoCoverageToggle<CR>', { silent = true })
    end
  -- }}}
  -- Json {{{
    local ft_json = {
      {[[ FileType json lua require('lspconfig').jsonls.autostart() ]]};
    }
    augroups({ft_json=ft_json})
  -- }}}
  -- Haskell {{{
    -- None yet
  -- }}}
  -- Helm {{{
    packer.use {
      'towolf/vim-helm',
      ft = { 'helm' },
    }
    local ft_helm = {
      {[[ BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl,Chart.yaml,values.yaml set ft=helm ]]};
      {[[ FileType helm lua helm_ft() ]]}
    }
    augroups({ft_helm=ft_helm})

    function render_helm()
      cmd [[write]]
      execute '!helm template ./ --output-dir .out'
    end

    function helm_ft()
      bmap('n', '<leader>rr', ':lua render_helm()<CR>', { silent = true })
    end
  -- }}}
  -- Log {{{
    packer.use {
      'mtdl9/vim-log-highlighting',
      ft = { 'log' },
    }
    local ft_log = {
      {[[ BufNewFile,BufRead *.log set filetype=log ]]};
    }
    augroups({ft_log=ft_log})
  -- }}}
  -- Lua {{{
    local ft_lua = {
      {[[ FileType lua lua require'lspconfig'.sumneko_lua.autostart() ]]}
    }
    augroups({ft_lua=ft_lua})
  -- }}}
  -- Mail {{{
    local ft_mail = {
      {[[ FileType mail lua mail_ft() ]]}
    }
    augroups({ft_mail=ft_mail})
    function mail_ft()
      bmap('n', '<leader>ry', ':%!pandoc -f markdown_mmd -t html<CR>', {})
      bmap('n', '<leader>rr', ':LivedownPreview<CR>', { silent = true })
      bmap('n', '<leader>rt', ':LivedownToggle<CR>', { silent = true })
      bmap('n', '<leader>rk', ':LivedownKill<CR>', { silent = true })

      vim.g.livedown_browser = 'firefox'
      vim.g.livedown_port = 14545
    end
  -- }}}
  -- Markdown/VimWiki {{{
    packer.use {
      'shime/vim-livedown',
      as = 'livedown',
      ft = { 'markdown', 'vimwiki', 'mail' },
      config = function ()
        vim.g.livedown_browser = 'firefox'
        vim.g.livedown_port = 14545
      end,
    }
    packer.use {
      'gpanders/vim-medieval',
      as = 'medieval',
      ft = { 'markdown', 'vimwiki' },
      config = function ()
        vim.g.medieval_langs = { 'python=python3', 'ruby', 'sh', 'console=bash', 'bash', 'perl' }
      end,
    }
    local ft_md = {
      {[[ FileType mail lua md_ft() ]]};
      {[[ FileType vimwiki lua md_ft() ]]};
    }
    augroups({ft_md=ft_md})
    function  md_ft()
      vim.wo.foldlevel = 2
      vim.wo.conceallevel = 2

      bmap('n', '<leader>rr', ':LivedownPreview<CR>', { silent = true })
      bmap('n', '<leader>rt', ':LivedownToggle<CR>', { silent = true })
      bmap('n', '<leader>rk', ':LivedownKill<CR>', { silent = true })
      bmap('n', '<leader>oT', ':silent ! typora "%" &<CR>', { silent = true })

      cmd [[ command! -bang -nargs=? EvalBlock call medieval#eval(<bang>0, <f-args>) ]]
      bmap('n', '<leader>rb', '"":EvalBlock<CR>', { silent = true })

      cmd [[iab \c ```]]

    -- inoremap <buffer><expr> ]] fzf#vim#complete({
    --       \ 'source':  'rg --no-heading --smart-case  .',
    --       \ 'reducer': function('<sid>make_note_link'),
    --       \ 'options': '--multi --reverse --margin 15%,0',
    --       \ 'window': { 'width': 0.9, 'height': 0.6 }})

      -- bmap('i', ']]', )

      -- Zettel
      bmap('i', '[[', 'qq<esc><Plug>ZettelSearchMap', { silent = true })
      bmap('x', '<CR>', '<Plug>ZettelNewSelectedMap', { silent = true })

      bmap('n', '<leader>wb', ':VimwikiBacklinks<cr>', { noremap = true })

      bmap('n', '<CR>', ':VimwikiFollowLink<CR>', { noremap = true })

      bmap('n', '<Backspace>', ':VimwikiGoBackLink<CR>', { noremap = true })
      bmap('n', '<leader>wd', ':VimwikiDeleteFile<CR>', { noremap = true })
      bmap('n', '<leader>wr', ':VimwikiRenameFile<CR>', { noremap = true })

      bmap('n', ']w',':VimwikiNextLink<CR>', { noremap = true })
      bmap('n', '[w',':VimwikiPrevLink<CR>', { noremap = true })

      bmap('n', '<leader>zb',':lua update_back_links()<CR>', { noremap = true, silent = true })
      bmap('n', '<leader>zz',':ZettelOpen<CR>', { noremap = true })
      bmap('n', '<leader>zy',':ZettelYankName<CR>', { noremap = true })
      bmap('n', '<leader>zn',':ZettelNew<space>', { noremap = true })
      bmap('n', '<leader>zi',':ZettelInsertNote<CR>', { noremap = true })
      bmap('n', '<leader>zC',':ZettelCapture<CR>', { noremap = true })
      bmap('n', '<leader>wT', ':VimwikiRebuildTags!<cr>:VimwikiGenerateTagLinks<cr><c-l>', { noremap = true })
    end
  -- }}}
  -- Nix {{{
    packer.use {
      'LnL7/vim-nix',
      ft = { 'nix' },
      config = function ()
        vim.g.tagbar_type_nix = {
          ctagstype = 'nix',
          kinds = { 'f:function' }
        }
      end,
    }
    local ft_nix = {
      {[[ BufRead,BufNewFile *.nix set filetype=nix ]]};
      {[[ FileType nix lua nix_ft() ]]};
    }
    augroups({ft_nix=ft_nix})
    function nix_ft()
      bmap('i', '<C-Enter>', '<ESC>:call SmartCR()<CR>', {})
    end
  -- }}}
  -- Python {{{
    packer.use {
      'jmcantrell/vim-virtualenv',
      ft = { 'python' },
    }
    packer.use {
      'Vimjas/vim-python-pep8-indent',
      ft = { 'python' },
    }
    packer.use {
      'bps/vim-textobj-python',
      ft = { 'python' },
      config = function ()
        vim.g.textobj_python_no_default_key_mappings = 1
      end,
    }
    local ft_python = {
      {[[ FileType python lua python_ft() ]]};
    }
    augroups({ft_python=ft_python})
    function python_ft()
      vim.g.virtualenv_directory = os.getenv('PWD')
      vim.wo.foldmethod = 'indent'
      vim.wo.foldlevel = 0
      vim.wo.foldnestmax = 2
      vim.bo.commentstring = '# %s'

      bmap('n', '<leader>rr', ':w|call RunCmd("python " . bufname("%"))<CR>', {})
      bmap('n', '<leader>rt', ':w|call RunCmd("python -m unittest " . bufname("%"))<CR>', {})
      bmap('n', '<leader>rT', ':w|call RunCmd("python -m unittest")<CR>', {})
      bmap('n', '<leader>rL', ':!pip install flake8 mypy pylint bandit pydocstyle pudb jedi<CR>:ALEInfo<CR>', {})

      bmap('n', '<leader>rb', 'oimport pudb; pudb.set_trace()<esc>', {})

      bmap('x', 'af', '<Plug>(textobj-python-function-a)', {})
      bmap('o', 'af', '<Plug>(textobj-python-function-a)', {})
      bmap('x', 'if', '<Plug>(textobj-python-function-i)', {})
      bmap('o', 'if', '<Plug>(textobj-python-function-i)', {})

      vim.b.ale_linters = { 'flake8', 'mypy', 'pylint', 'bandit', 'pydocstyle' }
      vim.b.ale_fixers = {python = { 'remove_trailing_lines', 'trim_whitespace', 'autopep8'}}
      vim.b.ale_python_flake8_executable = 'flake8'
      vim.b.ale_python_flake8_options = '--ignore E501'
      vim.b.ale_python_flake8_use_global = 0
      vim.b.ale_python_mypy_executable = 'mypy'
      vim.b.ale_python_mypy_options = ''
      vim.b.ale_python_mypy_use_global = 0
      vim.b.ale_python_pylint_executable = 'pylint'
      vim.b.ale_python_pylint_options = '--disable C0301,C0111,C0103'
      vim.b.ale_python_pylint_use_global = 0
      vim.b.ale_python_bandit_executable = 'bandit'
      vim.b.ale_python_isort_executable = 'isort'
      vim.b.ale_python_pydocstyle_executable = 'pydocstyle'
      vim.b.ale_python_vulture_executable = 'vulture'
    end
  -- }}}
  -- Puppet {{{
    packer.use {
      'rodjek/vim-puppet',
      ft = { 'puppet' },
      config = function ()
        vim.g.puppet_align_hashes = 0
      end,
    }
    local ft_puppet = {
      {[[ BufNewFile,BufRead *.pp set filetype=puppet ]]};
      {[[ FileType puppet lua puppet_ft() ]]};
    }
    augroups({ft_puppet=ft_puppet})
    function puppet_ft()
      vim.bo.commentstring = '# %s'
      bmap('n', '<leader>rr', ':w |call RunCmd("puppet " . bufname("%"))<CR>', {})
      bmap('n', '<leader>rt', ':w |call RunCmd("puppet parser validate")<CR>', {})
      bmap('n', '<leader>rL', ':!gem install puppet puppet-lint r10k yaml-lint<CR>:ALEInfo<CR>', {})
    end
  -- }}}
  -- Rust {{{
    packer.use {
      'rust-lang/rust.vim',
      ft = { 'rust' },
      config = function ()
        require('lspconfig').rust_analyzer.autostart()
      end,
    }
    local ft_rust = {
      {[[ FileType rust lua rust_ft() ]]};
    }
    augroups({ft_rust=ft_rust})
    function rust_ft()
      bmap('i', '<C-Enter>', '<ESC>:call SmartCR()<CR>', {})
      bmap('n', '<leader>rr', ':RustRun<CR>', {})
      bmap('n', '<leader>rt', ':RustTest<CR>', {})
      bmap('n', '<leader>rL', ':RustFmr<CR>', {})
      vim.b.ale_enabled = 0
    end
  -- }}}
  -- Shell {{{
    local ft_shell = {
      {[[ FileType sh lua shell_ft() ]]};
    }
    augroups({ft_shell=ft_shell})
    function shell_ft()
      bmap('n', '<leader>rr', ':w |call RunCmd("bash " . bufname("%"))<CR>', {})
      require('lspconfig').bashls.autostart()
    end
  -- }}}
  -- SQL {{{
    local ft_sql = {
      {[[ FileType sql lua sql_ft() ]]};
    }
    augroups({ft_sql=ft_sql})
    function sql_ft()
      vim.bo.commentstring = '/* %s */'
    end
  -- }}}
  -- Terraform {{{
    packer.use {
      'hashivim/vim-terraform',
      ft = { 'terraform' },
      config = function ()
        vim.g.terraform_align = 1
        vim.g.terraform_fmt_on_save = 1
      end,
    }
    local ft_terraform = {
      {[[ FileType terraform lua terraform_ft() ]]};
    }
    augroups({ft_terraform=ft_terraform})
    function terraform_ft()
    -- call ale#linter#Define('terraform', {
    --       \   'name': 'terraform-lsp',
    --       \   'lsp': 'stdio',
    --       \   'executable': 'terraform-lsp',
    --       \   'command': '%e',
    --       \   'project_root': getcwd(),
    --       \})
    end
  -- }}}
  -- TODO {{{
    local ft_todo = {
      {[[ BufRead,BufNewFile *.todo,TODO.md setf todo ]]};
      {[[ FileType todo lua todo_ft() ]]};
    }
    augroups({ft_todo=ft_todo})
    function todo_ft()
      exec([[
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
      ]], true)
    end
  -- }}}
  -- Vim {{{
    local ft_vim = {
      {[[ FileType vim lua vim_ft() ]]};
    }
    augroups({ft_vim=ft_vim})
    function vim_ft()
      vim.wo.foldmethod = 'marker'
      vim.bo.keywordprg = ':help'
    end
  -- }}}
  -- XML {{{
    packer.use {
      'sukima/xmledit',
      ft = { 'xml' },
    }
  -- }}}
  -- Yaml {{{
    local ft_yaml = {
      {[[ FileType yaml lua yaml_ft() ]]};
    }
    augroups({ft_yaml=ft_yaml})
    function yaml_ft()
      vim.b.ale_yaml_yamllint_executable = 'yamllint_custom'
      vim.b.ale_linters = { 'yamllint' }
    end
  -- }}}
-- }}}

-- Plugins {{{
-- Workflow
  -- Autoread {{{
    packer.use {
      'djoshea/vim-autoread',
    }
  -- }}}
  -- Yank/Paste {{{
    packer.use {
      'PeterRincker/vim-yankitute',
      config = function()
        vim.api.nvim_exec([[
        nmap <expr>  MY  ':%Yankitute/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
        vmap <expr>  MY  ':Yankitute/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
        ]], true)
      end,
    }
  -- }}}
-- UI
  -- Colorscheme {{{
    packer.use {
      'KeitaNakamura/neodark.vim',
      as = 'neodark',
      opt = true,
      setup = function ()
        vim.g['neodark#background'] = '#282c34'
        vim.cmd [[colorscheme neodark]]
        vim.api.nvim_exec([[
          " Mark 80-th character
          hi OverLength ctermbg=168 guibg=#ebabb8 ctermfg=250 guifg=#3c3e42
          call matchadd('OverLength', '\%81v', 100)

          " Change cursor color to make it more visible
          hi Cursor ctermbg=140 guibg=#B888E2
        ]], true)
      end,
    }
    cmd [[ packadd neodark ]]
  -- }}}
  -- Fuzzy {{{
    packer.use {
      'junegunn/fzf.vim',
      requires = { 'junegunn/fzf', as = 'fzf' },
      as = 'fzf.vim',
      config = function()
        map('n', '<leader>of', ':Files<CR>', { noremap = true, silent = true })
        map('n', '<leader>om', ':Maps<CR>', { noremap = true, silent = true })
        map('n', '<leader>oh', ':History<CR>', { noremap = true, silent = true })
        map('n', '<leader>osft', ':Filetypes<CR>', { noremap = true, silent = true })
        map('n', '<leader>osc', ':Colors<CR>', { noremap = true, silent = true })
        map('n', '<leader>ghf', ':BCommits<CR>', { noremap = true, silent = true })
        map('n', '<leader>ff', ':Rg<CR>', { noremap = true, silent = true })
        map('n', '<leader>vv', ':Buffers<CR>', { noremap = true, silent = true })

        vim.g.fzf_tags_command = 'ctags -R --exclude=.git --exclude=.idea --exclude=log'

        vim.env.FZF_DEFAULT_OPTS = '--bind=ctrl-a:toggle-all,ctrl-space:toggle+down,ctrl-alt-a:deselect-all'
        vim.env.FZF_DEFAULT_COMMAND = 'rg --iglob !.git --files --hidden --ignore-vcs --ignore-file ~/.config/git/gitexcludes'

        vim.cmd [[tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"]]
        vim.cmd([[ command! -bang -nargs=* Rg ]]..
        [[ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),]]..
        [[ 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)]])
      end,
    }
  -- }}}
  -- Indent-guides {{{
    packer.use {
      'nathanaelkane/vim-indent-guides',
      opt = true,
      as = 'vim-indent',
      setup = function ()
        vim.g.indent_guides_auto_colors = 0
        vim.g.indent_guides_start_level = 2
        vim.g.indent_guides_guide_size = 1
        vim.g.indent_guides_default_mapping = 0
      end,
      config = function ()
        vim.cmd[[
          hi IndentGuidesOdd  ctermbg=237
          hi IndentGuidesEven ctermbg=236
        ]]
      end,
    }
    vim.cmd [[packadd vim-indent]]
    vim.cmd [[ :IndentGuidesEnable ]]
  -- }}}
  -- Lightline {{{
    packer.use {
      'itchyny/lightline.vim',
      as = 'lightline',
      after = 'neodark',
      setup = function ()
        local lightline = {
          enable = { tabline = 0 },
          colorscheme = 'neodark',
          active = {
            left = {
              { 'mode', 'paste' },
              { 'gitbranch', 'readonly', 'filename', 'modified' },
              { 'venv', 'readonly' }
            },
            component_function = {
              gitbranch = 'fugitive#head',
              venv = 'virtualenv#statusline'
            }
          }
        }
        vim.g.lightline = lightline
      end,
    }
    cmd [[ packadd lightline ]]
  -- }}}
  -- Marks {{{
    packer.use {
      'kshenoy/vim-signature',
      config = function ()
        vim.g.SignatureMap = {
          Leader             =  "m",
          PlaceNextMark      =  "",
          ToggleMarkAtLine   =  "mm",
          PurgeMarksAtLine   =  "m-",
          DeleteMark         =  "",
          PurgeMarks         =  "",
          PurgeMarkers       =  "m<BS>",
          GotoNextLineAlpha  =  "",
          GotoPrevLineAlpha  =  "",
          GotoNextSpotAlpha  =  "]'",
          GotoPrevSpotAlpha  =  "['",
          GotoNextLineByPos  =  "",
          GotoPrevLineByPos  =  "",
          GotoNextSpotByPos  =  "",
          GotoPrevSpotByPos  =  "",
          GotoNextMarker     =  "",
          GotoPrevMarker     =  "",
          GotoNextMarkerAny  =  "",
          GotoPrevMarkerAny  =  "",
          ListBufferMarks    =  "m/",
          ListBufferMarkers  =  ""
        }
        map('n', 'm/', ':Marks<CR>', { noremap = true })
        map('n', '<leader>mm', ':Marks<CR>', { noremap = true })
      end,
    }
  -- }}}
  -- NERDTree {{{
    packer.use {
      'preservim/nerdtree',
      requires = {
        {'Xuyuanp/nerdtree-git-plugin'},
        {'ryanoasis/vim-devicons'}
      },
      config = function ()
        vim.g.NERDTreeShowBookmarks=0
        vim.g.NERDTreeChDirMode=2
        vim.g.NERDTreeMouseMode=2
        vim.g.nerdtree_tabs_focus_on_files=1
        vim.g.nerdtree_tabs_open_on_gui_startup=0

        vim.g.NERDTreeMinimalUI=1
        vim.g.NERDTreeDirArrows=1
        vim.g.NERDTreeWinSize=30
        vim.g.NERDTreeIgnore={ '.pyc$' }

        vim.g.NERDTreeMapOpenVSplit='v'
        vim.g.NERDTreeMapOpenSplit='s'
        vim.g.NERDTreeMapJumpNextSibling=''
        vim.g.NERDTreeMapJumpPrevSibling=''
        vim.g.NERDTreeMapMenu='<leader>'
        vim.g.NERDTreeQuitOnOpen=1
        vim.g.NERDTreeCustomOpenArgs={ file = {reuse = '', where = 'p', keepopen = 0, stay = 0 }}

        map('n', '<leader>oe', ':call NERDTreeToggleCWD()<CR>', { noremap = true })
        map('n', '<leader>fp', ':call FindPathOrShowNERDTree()<CR>', {})

        vim.api.nvim_exec ([[
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
        ]], true)
      end,
    }
  -- }}}
  -- Rooter {{{
    packer.use {
      'airblade/vim-rooter',
      config = function ()
        vim.g.rooter_silent_chdir = 1
        vim.g.rooter_resolve_links = 1
        vim.g.rooter_manual_only = 1
        map('n', '<leader>or', ':call RooterWithCWD()<CR>', {})
        vim.api.nvim_exec([[
          function! RooterWithCWD()
            Rooter
            NERDTreeCWD
          endfunction
        ]], true)
      end,
    }
  -- }}}
  -- Tagbar {{{
    packer.use {
      'preservim/tagbar',
      config = function ()
        map('n', '<leader>tt', ':TagbarToggle<CR>', { noremap = true })
        map('n', '<leader>ft', ':TagbarOpenAutoClose<CR>', { noremap = true })
      end,
    }
  -- }}}
  -- Texting {{{
    packer.use {
      'junegunn/goyo.vim',
      requires = {
        {
          'junegunn/limelight.vim',
          cmd = { 'Limelight' },
        }
      },
      cmd = { 'Goyo' },
      setup = function ()
        vim.g.goyo_loaded = 1
        vim.g.goyo_width = 120
        vim.g.goyo_height = "90%"
      end,
    }

    function goyo_enter()
      if fn.executable('tmux') == 1 and fn.exists('$TMUX') == 1 then
        execute '!tmux set status off'
        execute([[!tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z]])
      end
      vim.o.showmode = false
      vim.o.showcmd = false
      vim.o.scrolloff = 999
      vim.wo.wrap = true
      execute('Limelight')
    end

    function goyo_leave()
      if fn.executable('tmux') == 1 and fn.exists('$TMUX') == 1 then
        execute '!tmux set status on'
        execute [[!tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z]]
      end
      vim.o.showmode = true
      vim.o.showcmd = true
      vim.o.scrolloff = 5
      vim.wo.wrap = false
      execute('Limelight!')
    end

    local au_goyo = {
      { 'User GoyoEnter nested silent lua goyo_enter()' };
      { 'User GoyoLeave nested silent lua goyo_leave()' };
    }
    augroups({au_goyo=au_goyo})

    map('n', '<leader>tT', ':Goyo<CR>', { noremap = true })
    -- Spelling
    vim.g.myLangList = { 'nospell', 'en_us', 'ru_ru' }
    local index={}
    for k,v in pairs(vim.g.myLangList) do
      index[v]=k
    end
    function toggle_spell()
      if not vim.b.myLang then
        if vim.wo.spell then
          vim.b.myLang = index[vim.bo.spelllang]
        else
          vim.b.myLang = 1
        end
      end
      vim.b.myLang = vim.b.myLang + 1
      if vim.b.myLang >= vim.tbl_count(vim.g.myLangList)+1 then
        vim.b.myLang = 1
      end

      if vim.b.myLang == 1 then
        vim.wo.spell = false
      else
        vim.bo.spelllang = vim.g.myLangList[vim.b.myLang]
        vim.wo.spell = true
      end
      print('spell checking lang: '..vim.g.myLangList[vim.b.myLang])
    end

    map('n', '<F7>', ':lua toggle_spell()<CR>', { noremap = true, silent = true })
    map('n', '<leader>ts', ':lua toggle_spell()<CR>', { noremap = true, silent = true })
    map('i', '<F7>', '<ESC>:lua toggle_spell()<CR>a', { silent = true })
  -- }}}
  -- Tmux {{{
    packer.use {
      'christoomey/vim-tmux-navigator',
      config = function ()
        vim.g.tmux_navigator_save_on_switch = 2
        vim.g.tmux_navigator_disable_when_zoomed = 1
      end,
    }

    packer.use {
      'benmills/vimux',
      -- cmd = { 'RunCmd' },
      -- opt = true,
      config = function ()
        vim.g.VimuxHeight = "20"
        vim.g.VimuxUseNearest = 0
      end,
    }

    if fn.exists('$TMUX') == 1 then
      exec([[
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
      ]], true)

      map('n', '<leader>rRQ', ':call CloseRunner()<CR>', {})
      map('n', '<leader>rRX', ':VimuxInterruptRunner<CR>', {})
    end
  -- }}}
  -- Undo {{{
    packer.use {
      'mbbill/undotree',
    }
    map('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, silent = true })
  -- }}}
  -- WhichKey {{{
    packer.use {
      'liuchengxu/vim-which-key',
      opt = true,
    }
    cmd [[packadd vim-which-key]]
    map('n', '<leader>', [[:WhichKey '<Space>'<CR>]], { noremap = true, silent = true })
    map('v', '<leader>', [[:<c-u>WhichKey '<Space>'<CR>]], { noremap = true, silent = true })

    map('n', '<localleader>', [[:WhichKey '\'<CR>]], { noremap = true, silent = true })
    map('v', '<localleader>', [[:<c-u>WhichKey '\'<CR>]], { noremap = true, silent = true })
  -- }}}
  -- Xkb {{{
    packer.use {
      'lyokha/vim-xkbswitch',
      config = function ()
        vim.g.XkbSwitchEnabled = 1
        vim.g.XkbSwitchSkipFt = { 'nerdtree', 'coc-explorer' }
      end,
    }
    if fn.executable('nix-store') == 1 then
      local xkb_cmd = 'nix-store -r $(which xkb-switch) 2>/dev/null'
      local result = fn.substitute(fn.system(xkb_cmd), '[\\]\\|[[:cntrl:]]', '', 'g')
      vim.g.XkbSwitchLib = result .. '/lib/libxkbswitch.so'
    end
  -- }}}
  -- Zoom {{{
    packer.use {
      'dhruvasagar/vim-zoom'
    }
    map('n', '<leader>Z', ':lua zoom_toggle()<CR>', {})
    function zoom_toggle()

      local zoom_nerd = false
      local zoom_tag = false

      if vim.t.NERDTreeBufName and fn.bufwinnr(vim.t.NERDTreeBufName) ~= -1 then
        cmd 'NERDTreeClose'
        zoom_nerd = true
      end

      if vim.t.tagbar_buf_name and fn.bufwinnr(vim.t.tagbar_buf_name) ~= -1 then
        cmd 'TagbarClose'
        zoom_tag = true
      end

      cmd [[call zoom#toggle()]]

      if zoom_nerd then
        cmd 'NERDTreeCWD'
        execute ':wincmd p'
      end

      if zoom_tag then
        cmd 'TagbarOpen'
      end

    end
  -- }}}
  -- Buffers {{{
    packer.use {
      'schickling/vim-bufonly',
    }
    map('n', '<leader>bq', ':Bonly<CR>', { silent = true })
  -- }}}
  -- Registers {{{
    packer.use {
      'junegunn/vim-peekaboo',
      config = function()
        vim.g.peekaboo_delay = 1000
      end,
    }
  -- }}}
  -- LightBulb {{{
    packer.use {
      'kosayoda/nvim-lightbulb',
      config = function ()
        vim.cmd [[ autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb() ]]
      end,
    }
  -- }}}
  -- Fonts {{{
    packer.use 'powerline/fonts'
  -- }}}
  -- VimWiki {{{
    packer.use {
      'vimwiki/vimwiki',
      branch = 'dev',
      requires = {
        { 'michal-h21/vim-zettel' },
        { 'ewok/vimwiki-sync' }
      },
      config = function()
        map('n', '<leader>ww', ':silent call VimwikiIndexCd()<CR>', { noremap = true })
        map('n', '<leader>wi', ':VimwikiDiaryIndex<CR>', { noremap = true })
        map('n', '<leader>wj', ':VimwikiDiaryNextDay<CR>', { noremap = true })
        map('n', '<leader>wk', ':VimwikiDiaryPrevDay<CR>', { noremap = true })
        map('n', '<leader>wmc', ':VimwikiCheckLinks<CR>', { noremap = true })
        map('n', '<leader>wmt', ':VimwikiRebuildTags<CR>', { noremap = true })
        map('n', '<leader>wt', ':call VimwikiMakeDiaryNoteNew()<CR>', { noremap = true })

        vim.g.vimwiki_list = {
          {
            path = '~/Notes/',
            syntax = 'markdown',
            ext = '.md',
            auto_toc = 1,
            auto_diary_index = 1,
            list_margin = 0,
            custom_wiki2html = 'vimwiki-godown',
            links_space_char = '_',
            auto_tags = 1
          }
        }

        local vimwiki_ext2syntax = {}
        vimwiki_ext2syntax['.md'] = "markdown"
        vimwiki_ext2syntax['.mkd'] = "markdown"
        vimwiki_ext2syntax['.wiki'] = "media"
        vim.g.vimwiki_ext2syntax = vimwiki_ext2syntax

        vim.g.vimwiki_folding = 'expr'
        vim.g.vimwiki_hl_headers = 1
        vim.g.vimwiki_hl_cb_checked = 2
        vim.g.vimwiki_markdown_link_ext = 1
        vim.g.vimwiki_commentstring = '<!--%s-->'
        vim.g.vimwiki_auto_header = 1
        vim.g.vimwiki_create_link = 0

        vim.g.vimwiki_key_mappings =
        {
          global = 0,
          links = 0
        }
        -- " make_note_link: List -> Str
        -- " returned string: [Title](YYYYMMDDHH.md)
        -- function! s:make_note_link(l)
        --   " fzf#vim#complete returns a list with all info in index 0
        --   let line = split(a:l[0], ':')
        --   let ztk_id = l:line[0]
        --   try
        --     let ztk_title = substitute(l:line[2], '\#\+\s\+', '', 'g')
        --   catch
        --     let ztk_title = substitute(l:line[1], '\#\+\s\+', '', 'g')
        --   endtry
        --   let mdlink = "[" . ztk_title ."](". ztk_id .")"
        --   return mdlink
        -- endfunction

        -- Zettel part
        vim.g.zettel_format = "%y%m%d-%H%M-%title"
        vim.g.zettel_default_mappings = 0
        function update_back_links()
          local bline = vim.fn.search('# Backlinks', 'wnb')
          if bline ~= 0 then
            vim.cmd (bline..[[,$delete]])
            vim.cmd [[d]]
          end
          vim.cmd [[ZettelBackLinks]]
        end

        vim.api.nvim_exec ([[
          function! VimwikiIndexCd()
            VimwikiIndex
            cd %:h
          endfunction

          function! VimwikiMakeDiaryNoteNew()
            VimwikiMakeDiaryNote
            cd %:h:h
          endfunction
        ]], true)
      end,
    }
  -- }}}
-- Code
  -- ALE {{{
    packer.use {
      'w0rp/ale',
      ft = {'sh', 'zsh', 'bash', 'c',
      'cpp', 'cmake', 'html', 'markdown',
      'racket', 'vim', 'tex', 'ansible',
      'yaml.ansible', 'dockerfile' },
      as = 'ale',
      cmd = 'ALEEnable',
      opt = true,
      setup = function ()
        -- vim.g.ale_sign_column_always = 1
        vim.g.ale_sign_error = '!!'
        vim.g.ale_sign_warning = '..'
        -- vim.g.ale_lint_on_text_changed = 'never'
        -- vim.g.ale_lint_on_insert_leave = 0
        vim.g.ale_completion_enabled = 0
        vim.g.ale_disable_lsp = 1
      end,
      config = function ()
        vim.cmd[[ALEEnable]]
      end,
    }
  -- }}}
  -- AutoIndent {{{
    packer.use {
      'tpope/vim-sleuth',
    }
  -- }}}
  -- Commentary {{{
    packer.use {
      'tpope/vim-commentary',
    }
  -- }}}
  -- Completor {{{
    packer.use {
      'hrsh7th/nvim-compe',
      requires = {
        { 'honza/vim-snippets' },
      },
      config = function ()
        vim.cmd [[set shortmess+=c]]
        vim.o.completeopt = "menuone,noselect"
        require'compe'.setup {
          enabled = true;
          autocomplete = true;
          debug = false;
          min_length = 1;
          preselect = 'enable';
          throttle_time = 80;
          source_timeout = 200;
          incomplete_delay = 400;
          allow_prefix_unmatch = false;
          max_abbr_width = 1000;
          max_kind_width = 1000;
          max_menu_width = 1000000;
          documentation = true;

          source = {
            path = true;
            buffer = true;
            calc = true;
            vsnip = true;
            nvim_lsp = true;
            nvim_lua = true;
            spell = true;
            tags = true;
            snippets_nvim = true;
            treesitter = true;
          };
        }

        local t = function(str)
          return vim.api.nvim_replace_termcodes(str, true, true, true)
        end
        _G.s_tab_complete = function()
          if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
          elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
            return t "<Plug>(vsnip-jump-prev)"
          else
            return t "<S-Tab>"
          end
        end

        vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
        vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
        vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
      end,
    }
  -- }}}
  -- LSP {{{
    packer.use {
      'neovim/nvim-lspconfig',
      requires = {
        { 'onsails/lspkind-nvim', },
        { 'glepnir/lspsaga.nvim',
        config = function ()
          map('n', 'K', [[<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]], { noremap = true, silent = true })
          map('n', '<C-f>', [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]], { noremap = true, silent = true })
          map('n', '<C-b>', [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]], { noremap = true, silent = true })
          map('n', 'gk', [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]], { noremap = true, silent = true })
        end, }
      },
      as = 'lspconfig',
      config = function()
        require'lspconfig'.dockerls.setup{
          root_dir = function(fname)
            return require'lspconfig'.util.find_git_ancestor(fname) or require'lspconfig'.util.path.dirname(fname)
          end;
        }
        require'lspconfig'.bashls.setup{
          autostart = false,
          root_dir = function(fname)
            return require'lspconfig'.util.find_git_ancestor(fname) or require'lspconfig'.util.path.dirname(fname)
          end;
        }
        require'lspconfig'.rust_analyzer.setup{autostart = false}
        require'lspconfig'.pyright.setup{
          autostart = false,
        }
        require'lspconfig'.jsonls.setup{
          autostart = false,
          root_dir = function(fname)
            return require'lspconfig'.util.find_git_ancestor(fname) or require'lspconfig'.util.path.dirname(fname)
          end;
        }
        require'lspconfig'.yamlls.setup{
          filetypes = { "yaml", "yaml.ansible", "helm"},
          autostart = false,
          root_dir = function(fname)
            return require'lspconfig'.util.find_git_ancestor(fname) or require'lspconfig'.util.path.dirname(fname)
          end;
        }
        require'lspconfig'.sumneko_lua.setup{
          autostart = false,
          cmd = {os.getenv("HOME") .. "/.nix-profile/bin/lua-language-server"};
          settings = {
            Lua = {
              diagnostics = {
                enable = true,
                globals = {"vim"},
                disable = {"uppercase-global"},
              }
            }
          }
        }
        map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
        map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
        map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
        map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })

        -- map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
        -- map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })

        map('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
        map('n', '<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true })

        map('n', '<leader>cc', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
        map('n', '<leader>cd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap = true, silent = true })
        map('n', '<leader>crn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
        map('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
      end,
    }
  -- }}}
  -- Treesitter {{{
    packer.use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function ()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = "maintained",
          highlight = {
            enable = true,
          },
        }
      end,
    }
  -- }}}
  -- Easyaligh {{{
    packer.use {
      'junegunn/vim-easy-align',
      config = function ()
        map('n', 'ga', '<Plug>(LiveEasyAlign)', {})
        map('x', 'ga', '<Plug>(LiveEasyAlign)', {})
      end,
    }
  -- }}}
  -- FAR {{{
    packer.use {
      'brooth/far.vim',
      config = function ()
        vim.g['far#source'] = 'agnvim'
        vim.g['far#file_mask_favorites'] = { '%', '.*', '\\.py$', '\\.go$' }
        map('n', '<leader>fr', ':Far<space>', { noremap = true })
        map('v', '<leader>fr', ':Far<space>', { noremap = true })
      end,
    }
  -- }}}
  -- GIT {{{
    -- vim.g.fugitive_gitlab_domains = ['https://my.gitlab.com']
    -- Fugitive
    packer.use {
      'tpope/vim-fugitive',
      requires = {
        {'tpope/vim-rhubarb'},
        {'shumphrey/fugitive-gitlab.vim'},
      },
      config = function()
        function git_show_block_history()
          vim.cmd[[exe ":G log -L " . string(getpos("'<'")[1]) . "," . string(getpos("'>'")[1]) . ":%"]]
        end

        function git_show_line_history()
          vim.cmd[[exe ":G log -U1 -L " . string(getpos('.')[1]) . ",+1:%"]]
        end

        local au_git = {
          {[[BufEnter */.git/index nnoremap <buffer> <silent> c :WhichKey 'c'<CR>]]};
          {[[BufEnter */.git/index nnoremap <buffer> <silent> d :WhichKey 'd'<CR>]]};
          {[[BufEnter */.git/index nnoremap <buffer> <silent> r :WhichKey 'r'<CR>]]};
        }
        augroups({au_git=au_git})

        map('n', '<leader>gs', ':Gstatus<CR>', { silent = true })
        map('n', '<leader>gd', ':Gdiff<CR>', { silent = true })
        map('n', '<leader>gC', ':Gcommit<CR>', { silent = true })
        map('n', '<leader>gW', ':Gwrite<CR>', { silent = true })
        map('n', '<leader>gR', ':Gread<CR>', { silent = true })
        map('n', '<leader>gR', ':Gread<CR>', { silent = true })

        map('n', '<leader>gbl', ':Gblame<CR>', { silent = true })

        map('n', '<leader>gps', ':G push<CR>', { silent = true })
        map('n', '<leader>gplr', ':G pull --rebase<CR>', { silent = true })
        map('n', '<leader>gplm', ':G pull<CR>', { silent = true })
        map('n', '<leader>gg', ':.Gbrowse %<CR>', { silent = true })
        map('v', '<leader>gg', [[:'<,'>Gbrowse %<CR>]], { silent = true })
        map('v', '<leader>ghv', ':<C-U>call GitShowBlockHistory()<CR>', { silent = true })
        map('n', '<leader>ghl', ':call GitShowLineHistory()<CR>', { silent = true })
      end,
    }
    -- Gitgutter
    packer.use {
      'airblade/vim-gitgutter',
      config = function()
        vim.g.gitgutter_map_keys = 0
        vim.g.gitgutter_override_sign_column_highlight = 0
        map('n', '[g', '<Plug>(GitGutterPrevHunk)', {})
        map('n', ']g', '<Plug>(GitGutterNextHunk)', {})
        map('n', '<leader>ghs', ':GitGutterStageHunk<CR>', {})
        map('n', '<leader>ghr', ':GitGutterUndoHunk<CR>', {})
        map('n', '<leader>ghp', ':GitGutterPreviewHunk<CR>', {})
      end,
    }
    -- Gitv
    packer.use {
      'junegunn/gv.vim',
      config = function()
        vim.g.Gitv_DoNotMapCtrlKey = 1
        map('n', '<leader>ghh', ':GV<CR>', { silent = true })
      end,
    }
  -- }}}
  -- Speeddating {{{
    packer.use {
      'tpope/vim-speeddating',
      ft = { 'mail', 'markdown', 'sh', 'todo', 'yaml' },
    }
  -- }}}
  -- Surround {{{
    packer.use {
      'tpope/vim-surround',
      config = function()
        vim.g.surround_113="#{\r}"
        vim.g.surround_35="#{\r}"
        vim.g.surround_45="{%- \r -%}"
        vim.g.surround_61="{%= \r =%}"
        vim.g['surround_'..vim.fn.char2nr("d")] = [[<div\1id: \r..*\r id=\"&\"\1>\r</div>]]
        vim.g['surround_'..vim.fn.char2nr("x")] = [[<\1id: \r..*\r&\1>\r</\1\1>]]
        vim.g['surround_'..vim.fn.char2nr("%")] = [[{% \r %}]]
      end,
    }
  -- }}}
  -- Split/Join {{{
    packer.use {
      'andrewradev/splitjoin.vim',
      config = function()
        map('n', 'gs', ':SplitjoinSplit<CR>', {})
        map('n', 'gj', ':SplitjoinJoin<CR>', {})
      end,
    }
  -- }}}
  -- Zeavim {{{
    packer.use {
      'KabbAmine/zeavim.vim',
      config = function()
        vim.g.zv_disable_mapping = 1
        local zv_file_types = {}
          zv_file_types['\\v^(G|g)runt\\.'] = 'gulp,javascript,nodejs'
          zv_file_types['\\v^(G|g)ulpfile\\.']        = 'grunt'
          zv_file_types['\\v^(md|mdown|mkd|mkdn)$']  = 'markdown'
          zv_file_types['yaml.ansible']             = 'ansible'
        vim.g.zv_file_types = zv_file_types
      end,
    }
  -- }}}
  -- Better Whitespace {{{
    packer.use {
      'ntpeters/vim-better-whitespace',
      config = function()
        vim.g.better_whitespace_filetypes_blacklist = { 'gitcommit', 'unite', 'qf', 'help', 'dotooagenda', 'dotoo' }
        map('n', '<leader>tfw', ':StripWhitespace<CR>', {})
      end,
    }
  -- }}}
-- Motion
  -- AutoPairs {{{
    packer.use 'jiangmiao/auto-pairs'
  -- }}}
  -- Text objects {{{
    packer.use {
      'kana/vim-textobj-user',
      requires = {
        { 'kana/vim-textobj-indent' },
        { 'glts/vim-textobj-comment' }
      }
    }
  -- }}}
  -- Quick Scope {{{
    packer.use {
      'unblevable/quick-scope',
      config = function()
        vim.g.qs_buftype_blacklist = { 'terminal', 'nofile', 'nerdtree' }
      end,
    }
  -- }}}
  -- Word motion {{{
    packer.use 'chaoren/vim-wordmotion'
  -- }}}
  -- Repeat {{{
    packer.use 'tpope/vim-repeat'
  -- }}}
-- }}}

-- Scripts {{{
  -- TODOs {{{
    vim.api.nvim_exec([[
      nnoremap <leader>ot :call OpenToDo()<CR>
      function! OpenToDo()
        vsplit TODO.md
        nnoremap <buffer> q :x<CR>
        setf todo
      endfunction
    ]], true)
  -- }}}
  -- FoldText {{{
    vim.api.nvim_exec([[
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
    ]], true)
  -- }}}
  -- Sessions {{{
    vim.api.nvim_exec([[
      let g:sessiondir = $HOME . "/.vim_sessions"

      function! MakeSession(file)

        " if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exe ':tabdo NERDTreeClose'
        " endif

        " if (exists("t:tagbar_buf_name") && bufwinnr(t:tagbar_buf_name) != -1)
        exe ':tabdo TagbarClose'
        " endif

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
    ]], true)
  -- }}}
  -- AutoSave {{{
    vim.api.nvim_exec([[
      " Trigger autoread when changing buffers or coming back to vim.
      " au FocusGained,BufEnter,WinEnter * :silent! !
      au! FileType vim,python,golang,go,yaml.ansible,puppet,json,sh,vimwiki,rust,yaml,nix call DefaultOn()

      function! DefaultOn()
        if !exists("b:auto_save")
          let b:auto_save = 1
        endif
      endfunction

      set updatetime=4000

      let save_cpo = &cpo
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

      let &cpo = save_cpo
      unlet save_cpo
    ]], true)
  -- }}}
  -- QuickFix {{{
  vim.api.nvim_exec([[
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
  ]], true)
  -- }}}
-- }}}

-- Testing {{{
  -- DrawIt {{{
    packer.use {
      'ewok/DrawIt'
    }
  -- }}}
-- }}}

-- Leader init {{{
  -- vim.g.lmap =  {b = {name = '+Buffer'}}
  local lmap =  {}
  lmap.b = {name = '+Buffer'}
  lmap.b.q = 'Quit All'
  lmap.c = {name = '+Code'}
  lmap.c.c = 'Code action(line)'
  lmap.c.d = 'Diagnostics'
  lmap.c.r = {name = '+Refactor'}
  lmap.c.r.n = 'Rename'
  lmap.c.f = 'Formatting'
  lmap.f = {name = '+Find' }
  lmap.f.f = 'in-File'
  lmap.f.p = 'Path'
  lmap.f.r = 'Replace'
  lmap.f.t = 'Tag'
  lmap.g = {name = '+Git'}
  lmap.g.b = { name = '+Blame' }
  lmap.g.b.b = 'Messanger'
  lmap.g.b.l = 'bLame'
  lmap.g.C = 'Commit'
  lmap.g.d = 'Diff'
  lmap.g.g = 'Browse'
  lmap.g.h = { name = '+History' }
  lmap.g.h.f = '+File'
  lmap.g.h.h = '+All'
  lmap.g.h.p = 'Hunk-Preview'
  lmap.g.h.r = 'Hunk-Revert'
  lmap.g.h.s = 'Hunk-Stage'
  lmap.g.h.v = 'Visual'
  lmap.g.p = { name = '+Push-pull' }
  lmap.g.p.l = { name = '+Pull' }
  lmap.g.p.l.m = 'Merge'
  lmap.g.p.l.r = 'Rebase'
  lmap.g.p.s = 'Push'
  lmap.g.R = 'Read'
  lmap.g.s = 'Status'
  lmap.g.W = 'Write'
  lmap.i = { name = '+Insert' }
  lmap.i.t = 'To-do'
  lmap.i.d = {name = '+DateTime'}
  lmap.i.d.m = 'date Time(Minutes)'
  lmap.i.d.d = 'date Time(Day)'
  lmap.i.d.s = 'date Time(seconds)'
  lmap.l = { name = '+Location' }
  lmap.l.c = 'Close'
  lmap.l.l = 'Toggle'
  lmap.l.n = 'Next'
  lmap.l.o = 'Open'
  lmap.l.p = 'Previous'
  lmap.m = { name = '+Marks' }
  lmap.o = { name = '+Open/+Option'}
  lmap.o.e = 'Explorer'
  lmap.o.r = 'Root(project)'
  lmap.o.s = { name = '+Option-Set'}
  lmap.o.s.f = { name = '+File'}
  lmap.o.s.f.f = { name = '+Format='}
  lmap.o.u = { name = '+Option-Unset'}
  lmap.o.t = 'To-Do'
  lmap.p = { name = '+Plugins' }
  lmap.q = { name = '+QFix' }
  lmap.q.c = 'Close'
  lmap.q.n = 'Next'
  lmap.q.o = 'Open'
  lmap.q.p = 'Previous'
  lmap.q.q = 'Toggle'
  lmap.r = { name = '+Run' }
  lmap.r.b = 'Breakpoint'
  lmap.r.R = { name = '+Runner' }
  lmap.r.R.q = 'Close Runner'
  lmap.r.R.x = 'Interrupt'
  lmap.s = { name = '+Session' }
  lmap.s.c = 'Close'
  lmap.s.d = 'Delete'
  lmap.s.o = 'Open'
  lmap.s.q = 'Quit'
  lmap.s.s = 'Save'
  lmap.s.u = 'open-cUrrent'
  lmap.t = { name = '+Tags/Text' }
  lmap.t.f = {name = '+Fix'}
  lmap.t.s = 'Syntax'
  lmap.t.T = 'Text-only(Goyo)'
  lmap.u = 'Undo'
  lmap.w = { name = '+Wiki' }
  lmap.w.w = 'Index'
  lmap.w.m = { name = '+Maintanence'}
  lmap.w.m.c = 'Check Links'
  lmap.w.m.t = 'Rebuild Tags'
  lmap.w.c = 'Colorize'
  lmap.w.t = 'Today'
  lmap.w.T = 'Tag Rebuild+Insert'
  lmap.w.i = 'Diary'
  lmap.w.r = 'Rename link'
  lmap.w.d = 'Delete link'
  lmap.w.n = 'goto'
  lmap.w.j = 'Next Day'
  lmap.w.k = 'Prev Day'
  lmap.y = { name = '+Yank' }
  lmap.y.f = { name = '+File' }
  lmap.y.y = 'Yank-Ext'
  lmap.y.p = 'Paste-Ext'
  lmap.y.f.n = 'Name'
  lmap.y.f.p = 'Path'
  lmap.y.f.l = 'File:Line'
  lmap.z = { name = '+Zettel' }
  lmap.z.b = 'Update Backlinks'
  lmap.z.z = 'Open'
  lmap.z.y = 'Yank Page'
  lmap.z.n = 'New'
  lmap.z.i = 'Insert Note'
  lmap.z.C = 'Capture As Note'
  lmap.Z = 'Zoom'
  vim.g.lmap = lmap
  vim.g.which_key_use_floating_win = 1
  vim.g.which_key_flatten = 0
  -- Register which key
  vim.fn['which_key#register']('<Space>', vim.g.lmap)
-- }}}


-- Load local config
vim.api.nvim_exec([[
  try
    source ~/.vimrc.local
  catch
    " Ignoring
  endtry
]], true)