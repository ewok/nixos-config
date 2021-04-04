-- vim: ts=2 sw=2 sts=2
--
-- Helpers {{{
  _G.augroups = function(definitions)
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

  _G.augroups_buff = function(definitions)
    for group_name, definition in pairs(definitions) do
      vim.api.nvim_command('augroup '..group_name)
      vim.api.nvim_command('autocmd! * <buffer>')
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
  _G.map = api.nvim_set_keymap
  function _G.bmap(mode, key, comm, flags)
    api.nvim_buf_set_keymap(api.nvim_get_current_buf(), mode, key, comm, flags)
  end

  _G.t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
-- }}}

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
    use {'wbthomason/packer.nvim', opt = true, branch='master'}
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
      termguicolors = true;
      timeoutlen = 500;
      titlestring = '%F';
      title = true;
      ttimeoutlen = -1;
      ttyfast = true;
      undodir = os.getenv('HOME')..'/.vim_undo';
      undolevels = 100;
      updatetime = 300;
      visualbell = true;
      writebackup = false;
      guicursor = 'n-v-c:block,i-ci-ve:block,r-cr:hor20,'..
      'o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,'..
      'sm:block-blinkwait175-blinkoff150-blinkon175';
      shada = [['50,<1000,s100,"10,:10,n~/.viminfo]];
      inccommand = 'nosplit';

      -- Buf opts
      bomb = false;
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

    for opt, val in pairs(set_options) do
      local info = api.nvim_get_option_info(opt)
      local scope = info.scope

      vim.o[opt] = val
      if scope == 'win' then
        vim.wo[opt] = val
      elseif scope == 'buf' then
        vim.bo[opt] = val
      elseif scope == 'global' then
      else
        print(opt..' has '..scope.. ' scope?')
      end
    end

    -- let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    -- let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

    exec([[
    filetype plugin indent on

    syntax on
    syntax enable

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
    local au_cline = {
      {'WinLeave,InsertEnter * set nocursorline'};
      {'WinEnter,InsertLeave * set cursorline'};
    }
    augroups({au_cline=au_cline})
  -- }}}
  -- Restore Cursor {{{
    local au_line_return = {
      {[[BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |]]..
      [[execute 'normal! g`"zvzz' | endif]]};
    }
    augroups({au_line_return=au_line_return})
  -- }}}
  -- Dealing with largefiles  {{{
    -- Protect large files from sourcing and other overhead.
    vim.g.large_file_size = 1024*1024*20
    _G.adj_if_largefile = function()
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
    _G.rnu_on = function()
      if oget('showcmd') then
        vim.wo.rnu = true
      end
    end
    _G.rnu_off = function()
      if oget('showcmd') then
        vim.wo.rnu = false
      end
    end
    vim.wo.rnu = true
    local au_rnu = {
      {'InsertEnter * lua rnu_off()'};
      {'InsertLeave * lua rnu_on()'};
    }
    augroups({au_rnu=au_rnu})
  -- }}}
  -- RunCmd {{{
    _G.run_cmd = function(command)
      execute('!'..command)
    end
  -- }}}
-- }}}

-- Keymaps {{{
  -- Tabs {{{
    map('n', '<C-W>t', ':tabnew<CR>', { noremap = true, silent = true })
    map('n', '<Tab>', ':tabnext<CR>', { noremap = true, silent = true })
    map('n', '<S-Tab>', ':tabprev<CR>', { noremap = true, silent = true })
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

    _G.start_line = function(mode)
      mode = mode or 'n'
      if mode == 'v' then
        vim.api.nvim_exec('normal! gv', false)
      elseif mode == 'n' then
      else
        print('Unknown mode, using normal.')
      end
      local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
      vim.api.nvim_exec('normal ^', false)
      local check_cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
      if cursor[2] == check_cursor[2] then
        vim.api.nvim_exec('normal 0', false)
      end
    end
    map('n', 'H', ':lua start_line()<CR>', { noremap = true, silent = true })
    map('n', 'L', '$', { noremap = true })
    map('v', 'H', [[:lua start_line('v')<CR>]], { noremap = true, silent = true })
    map('v', 'L', '$', { noremap = true })
    -- Sudo
    map('c', 'w!!', 'w !sudo tee %', {})
    --- Quick escape insert mode
    -- map('i', 'jj', '<ESC>jj', {noremap = true, silent = true})
    -- map('i', 'kk', '<ESC>kk', {noremap = true, silent = true})
  -- }}}
  -- Settings options {{{
    map('n', '<leader>osw', ':set wrap<CR>', {})
    map('n', '<leader>ouw', ':set nowrap<CR>', {})

    map('n', '<leader>ost2', ':set tabstop=2 |set softtabstop=2| set shiftwidth=2<CR>', {})
    map('n', '<leader>ost4', ':set tabstop=4 |set softtabstop=4| set shiftwidth=4<CR>', {})
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
    map('n', '<leader>pC', ':PackerClean<CR>', {})
    map('n', '<leader>pc', ':PackerCompile<CR>', {})
    map('n', '<leader>pi', ':PackerInstall<CR>', {})
    map('n', '<leader>ps', ':PackerSync<CR>', {})
  -- }}}
  -- Terminal {{{
  vim.cmd [[tnoremap <Esc> <C-\><C-n>]]
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
      {[[ FileType yaml.ansible lua load_ansible_ft() ]]}
    }
    augroups({ft_ansible=ft_ansible})
    _G.load_ansible_ft = function()
      vim.bo.commentstring = [[# %s]]
      reg_highlight_cword()
      reg_auto_save()
      -- vim.b.ale_ansible_ansible_lint_executable = 'ansible_custom'
      -- vim.b.ale_ansible_ansible_lint_command = '%e %t'
      -- vim.b.ale_ansible_yamllint_executable = 'yamllint_custom'
      -- vim.b.ale_linters = { 'yamllint', 'ansible_custom' }
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
      {[[ FileType dockerfile lua load_dockerfile_ft() ]]};
    }
    augroups({ft_dockerfile=ft_dockerfile})
    _G.load_dockerfile_ft = function()
      require('lspconfig').dockerls.autostart()
      reg_highlight_cword()
      reg_auto_save()
    end
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
      {[[ FileType go lua load_go_ft() ]]}
    }
    augroups({ft_go=ft_go})
    _G.load_go_ft = function()
      bmap('n', '<leader>rr', ':silent GoRun<CR>', { silent = true })
      bmap('n', '<leader>rt', ':silent GoTest<CR>', { silent = true })
      bmap('n', '<leader>rb', ':silent GoBuild<CR>', { silent = true })
      bmap('n', '<leader>rc', ':silent GoCoverageToggle<CR>', { silent = true })
      reg_highlight_cword()
      reg_auto_save()
    end
  -- }}}
  -- Java {{{
    packer.use{
      'mfussenegger/nvim-jdtls',
      -- config = function()
      --   require('jdtls').start_or_attach({
      --     on_attach = require'lsp'.common_on_attach,
      --     cmd = {JAVA_LS_EXECUTABLE},
      --     root_dir = require('jdtls.setup').find_root({'gradle.build', 'pom.xml'})
      --   })
      -- end,
    }
  -- }}}
  -- Json {{{
    local ft_json = {
      {[[ FileType json lua load_json_ft() ]]};
    }
    augroups({ft_json=ft_json})
    _G.load_json_ft = function()
      require('lspconfig').jsonls.autostart()
      reg_highlight_cword()
      reg_auto_save()
    end
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
      {[[ FileType helm lua load_helm_ft() ]]}
    }
    augroups({ft_helm=ft_helm})

    _G.render_helm = function()
      cmd [[write]]
      execute '!helm template ./ --output-dir .out'
    end

    _G.load_helm_ft = function()
      bmap('n', '<leader>rr', ':lua render_helm()<CR>', { silent = true })
      reg_highlight_cword()
      reg_auto_save()
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
      {[[ FileType lua lua load_lua_ft() ]]}
    }
    augroups({ft_lua=ft_lua})
    _G.load_lua_ft = function()
      vim.wo.foldmethod = 'marker'
      require'lspconfig'.sumneko_lua.autostart()
      reg_auto_save()
    end
  -- }}}
  -- Mail {{{
    local ft_mail = {
      {[[ FileType mail lua load_mail_ft() ]]}
    }
    augroups({ft_mail=ft_mail})
    _G.load_mail_ft = function()
      bmap('n', '<leader>ry', ':%!pandoc -f markdown_mmd -t html<CR>', {})
      bmap('n', '<leader>rr', ':LivedownPreview<CR>', { silent = true })
      bmap('n', '<leader>rt', ':LivedownToggle<CR>', { silent = true })
      bmap('n', '<leader>rk', ':LivedownKill<CR>', { silent = true })

      vim.g.livedown_browser = 'qutebrowser'
      vim.g.livedown_port = 14545
    end
  -- }}}
  -- Markdown/VimWiki {{{
    packer.use {
      'shime/vim-livedown',
      as = 'livedown',
      ft = { 'markdown', 'vimwiki', 'mail' },
      config = function ()
        vim.g.livedown_browser = 'qutebrowser'
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
      {[[ FileType mail lua load_md_ft() ]]};
      {[[ FileType vimwiki lua load_md_ft() ]]};
      {[[ FileType markdown lua load_md_ft() ]]};
    }
    augroups({ft_md=ft_md})
    _G. load_md_ft = function()
      if vim.b.ft_loaded then return end

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

      reg_highlight_cword()
      reg_auto_save()
      vim.b.ft_loaded = true
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
      {[[ FileType nix lua load_nix_ft() ]]};
    }
    augroups({ft_nix=ft_nix})
    _G.load_nix_ft = function()
      require('lspconfig').rnix.autostart()
      reg_smart_cr()
      reg_highlight_cword()
      reg_auto_save()
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
      {[[ FileType python lua load_python_ft() ]]};
    }
    augroups({ft_python=ft_python})
    _G.load_python_ft = function()
      vim.g.virtualenv_directory = os.getenv('PWD')
      vim.wo.foldmethod = 'indent'
      vim.wo.foldlevel = 0
      vim.wo.foldnestmax = 2
      vim.bo.commentstring = '# %s'
      vim.bo.tabstop = 4
      vim.bo.softtabstop = 4
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 4

      bmap('n', '<leader>rr', ':w|lua run_cmd("python " .. vim.fn.bufname("%"))<CR>', {})
      bmap('n', '<leader>rt', ':w|lua run_cmd("python -m unittest " .. vim.fn.bufname("%"))<CR>', {})
      bmap('n', '<leader>rT', ':w|lua run_cmd("python -m unittest")<CR>', {})
      bmap('n', '<leader>rL', ':!pip install flake8 mypy pylint bandit pydocstyle pudb jedi<CR>:ALEInfo<CR>', {})

      _G.format_python = function()
        vim.api.nvim_command('silent! write')
        vim.api.nvim_command('silent ! black -l 119 %')
        vim.api.nvim_command('silent e')
      end

      bmap('n', '<leader>cf', ':lua format_python()<CR>', { silent = true })

      bmap('n', '<leader>rb', 'ofrom pudb import set_trace; set_trace()<esc>', {})

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

      require'lspconfig'.pyright.autostart()
      vim.fn.matchadd('OverLength', '\\%81v', 100)

      reg_auto_save()
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
      {[[ FileType puppet lua load_puppet_ft() ]]};
    }
    augroups({ft_puppet=ft_puppet})
    _G.load_puppet_ft = function()
      vim.bo.commentstring = '# %s'
      bmap('n', '<leader>rr', ':w |lua run_cmd("puppet " .. vim.fn.bufname("%"))<CR>', {})
      bmap('n', '<leader>rt', ':w |lua run_cmd("puppet parser validate")<CR>', {})
      bmap('n', '<leader>rL', ':!gem install puppet puppet-lint r10k yaml-lint<CR>:ALEInfo<CR>', {})

      reg_highlight_cword()
      reg_auto_save()
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
      {[[ FileType rust lua load_rust_ft() ]]};
    }
    augroups({ft_rust=ft_rust})
    _G.load_rust_ft = function()
      bmap('n', '<leader>rr', ':RustRun<CR>', {})
      bmap('n', '<leader>rt', ':RustTest<CR>', {})
      bmap('n', '<leader>rL', ':RustFmr<CR>', {})

      reg_smart_cr()
      reg_auto_save()
      vim.b.ale_enabled = 0
    end
  -- }}}
  -- Shell {{{
    local ft_shell = {
      {[[ FileType sh lua load_shell_ft() ]]};
    }
    augroups({ft_shell=ft_shell})
    _G.load_shell_ft = function()
      bmap('n', '<leader>rr', ':w |lua run_cmd("bash " .. vim.fn.bufname("%"))<CR>', {})
      require('lspconfig').bashls.autostart()
      reg_highlight_cword()
      reg_auto_save()
    end
  -- }}}
  -- SQL {{{
    local ft_sql = {
      {[[ FileType sql lua load_sql_ft() ]]};
    }
    augroups({ft_sql=ft_sql})
    _G.load_sql_ft = function()
      vim.bo.commentstring = '/* %s */'
      reg_highlight_cword()
      reg_auto_save()
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
      {[[ FileType terraform lua load_terraform_ft() ]]};
    }
    augroups({ft_terraform=ft_terraform})
    _G.load_terraform_ft = function()
    -- call ale#linter#Define('terraform', {
    --       \   'name': 'terraform-lsp',
    --       \   'lsp': 'stdio',
    --       \   'executable': 'terraform-lsp',
    --       \   'command': '%e',
    --       \   'project_root': getcwd(),
    --       \})
      reg_highlight_cword()
      reg_auto_save()
    end
  -- }}}
  -- TODO {{{
    local ft_todo = {
      {[[ BufRead,BufNewFile *.todo,TODO.md setf todo ]]};
      {[[ FileType todo lua load_todo_ft() ]]};
    }
    augroups({ft_todo=ft_todo})
    _G.load_todo_ft = function()
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
      reg_highlight_cword()
      reg_auto_save()
    end
  -- }}}
  -- Vim {{{
    local ft_vim = {
      {[[ FileType vim lua load_vim_ft() ]]};
    }
    augroups({ft_vim=ft_vim})
    _G.load_vim_ft = function()
      vim.wo.foldmethod = 'marker'
      vim.bo.keywordprg = ':help'
      reg_highlight_cword()
      reg_auto_save()
    end
  -- }}}
  -- XML {{{
    packer.use {
      'sukima/xmledit',
      ft = { 'xml' },
    }
  -- }}}
  -- QF {{{
    local ft_qf = {
      {[[ FileType qf lua load_qf_ft() ]]};
    }
    augroups({ft_qf=ft_qf})
    _G.load_qf_ft = function()
      bmap('n', 'q', ':cclose<CR>', {})
    end
  -- }}}
  -- Yaml {{{
    local ft_yaml = {
      {[[ FileType yaml lua load_yaml_ft() ]]};
    }
    augroups({ft_yaml=ft_yaml})
    _G.load_yaml_ft = function()
      vim.b.ale_yaml_yamllint_executable = 'yamllint_custom'
      vim.b.ale_linters = { 'yamllint' }
      reg_highlight_cword()
      reg_auto_save()
    end
  -- }}}
  -- Other {{{
    local ft_other = {
      {[[ FileType gitignore lua load_other_ft() ]]};
      {[[ FileType config lua load_other_ft() ]]};
    }
    augroups({ft_other=ft_other})
    _G.load_other_ft = function()
      reg_highlight_cword()
      reg_auto_save()
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
  -- Better QuickFix {{{
    packer.use{
      'kevinhwang91/nvim-bqf',
      config = function()
        require('bqf').setup({
          func_map = {
            tab = 't',
            vsplit = 'v',
            split = 's'
          },
          filter = {
            fzf = {
              action_for = {
                ['ctrl-t'] = 'tabedit',
                ['ctrl-v'] = 'vsplit',
                ['ctrl-s'] = 'split',
              }
            }
          }
        })
      end,
    }
  -- }}}
  -- Cheatsheet {{{
    packer.use {
      'RishabhRD/nvim-cheat.sh',
      requires = {{
        'RishabhRD/popfix'
      }},
      config = function()
        vim.g.cheat_default_window_layout = 'vertical_split'
        map('n', '<leader>fc', ':Cheat<CR>', { noremap = true, silent = true })
      end,
    }
  -- }}}
  -- Colorscheme {{{
    -- packer.use "chxuan/change-colorscheme"
    packer.use {
      'chriskempson/base16-vim',
      as = 'base16',
      opt = true,
      setup = function ()
        -- vim.g['neodark#background'] = '#282c34'
        -- vim.cmd [[colorscheme neodark]]
        vim.api.nvim_exec([[
          " Mark 80-th character
          hi! OverLength ctermbg=168 guibg=#ebabb8 ctermfg=250 guifg=#3c3e42
          call matchadd('OverLength', '\%81v', 100)

          " Change cursor color to make it more visible
          hi! Cursor ctermbg=140 guibg=#B888E2
          hi! Search ctermfg=236 ctermbg=74 guifg=#282c34 guibg=#639EE4
          hi! AutoHiWord cterm=bold ctermbg=red guibg=#464646
        ]], true)
      end,
    }
    vim.cmd [[ colorscheme base16-onedark ]]
  -- }}}
  -- Telescope {{{
    packer.use {
      'nvim-telescope/telescope.nvim',
      requires = {
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'},
        {
          'nvim-telescope/telescope-fzf-writer.nvim',
          requires = {{
            'junegunn/fzf',
            config = function()
              map('n', '<leader>ghf', ':BCommits<CR>', { noremap = true, silent = true })
            end,
          }},
          config = function()
            require('telescope').setup {
              extensions = {
                fzf_writer = {
                  minimum_grep_characters = 3,
                  minimum_files_characters = 2,
                  -- If slow -> turn off
                  use_highlighter = true,
                }
              }
            }
            map('n', '<leader>ff', ':Telescope fzf_writer grep<CR>', { noremap = true, silent = true })
            map('n', '<leader>fo', ':Telescope fzf_writer files<CR>', { noremap = true, silent = true })
            map('n', '<leader>of', ':Telescope fzf_writer files<CR>', { noremap = true, silent = true })
          end,
        }
      },
      config = function()

        -- map('n', '<leader>ff', ':Telescope live_grep<CR>', { noremap = true, silent = true })
        -- map('n', '<leader>fo', ':Telescope find_files<CR>', { noremap = true, silent = true })

        map('n', '<leader>oh', ':Telescope help_tags<CR>', { noremap = true, silent = true })

        map('n', '<leader>osf', ':Telescope filetypes<CR>', { noremap = true, silent = true })

        map('n', '<leader>oo', ':Telescope vim_options<CR>', { noremap = true, silent = true })
        map('n', '<leader>ona', ':Telescope autocommands<CR>', { noremap = true, silent = true })
        map('n', '<leader>onc', ':Telescope commands<CR>', { noremap = true, silent = true })
        map('n', '<leader>ons', ':Telescope colorscheme<CR>', { noremap = true, silent = true })
        map('n', '<leader>oni', ':Telescope highlights<CR>', { noremap = true, silent = true })
        map('n', '<leader>onk', ':Telescope keymaps<CR>', { noremap = true, silent = true })

        map('n', '<leader>mm', ':Telescope marks<CR>', { noremap = true, silent = true })
        map('n', 'm/', ':Telescope marks<CR>', { noremap = true, silent = true })

        map('n', '<leader>bb', ':Telescope buffers<CR>', { noremap = true, silent = true })

        local actions = require('telescope.actions')
        require('telescope').setup{
          defaults = {
            file_ignore_patterns = {},
            width = 0.75,
            prompt_position = "top",
            prompt_prefix = " ",
            sorting_strategy = "ascending",
            set_env = { ['COLORTERM'] = 'truecolor' },
            -- file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
            -- grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
            -- qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
            mappings = {
              i = {
                -- So, to not map "<C-n>", just put
                ["<c-n>"] = false,
                ["<c-p>"] = false,
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous,

                ["<C-s>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                -- ["<C-q>"] = actions.send_selected_to_qflist,

                ["<C-Space>"] = actions.toggle_selection + actions.move_selection_next,

                -- ["<CR>"] = actions.select_default + actions.center,
                ["<esc>"] = actions.close,
              },
              n = {
                ["<esc>"] = actions.close,
              },
            },
          }
        }
      end,
    }
    -- packer.use {
    --   'junegunn/fzf.vim',
    --   requires = { 'junegunn/fzf', as = 'fzf' },
    --   as = 'fzf.vim',
    --   config = function()
    --     -- map('n', '<leader>fb', ':Buffers<CR>', { noremap = true, silent = true })
    --     -- map('n', '<leader>of', ':Files<CR>', { noremap = true, silent = true })
    --     -- map('n', '<leader>om', ':Maps<CR>', { noremap = true, silent = true })
    --     -- map('n', '<leader>oh', ':History<CR>', { noremap = true, silent = true })
    --     -- map('n', '<leader>osft', ':Filetypes<CR>', { noremap = true, silent = true })
    --     -- map('n', '<leader>osc', ':Colors<CR>', { noremap = true, silent = true })
    --     -- map('n', '<leader>ghf', ':BCommits<CR>', { noremap = true, silent = true })
    --     -- map('n', '<leader>ff', ':Rg<CR>', { noremap = true, silent = true })
    --     -- map('n', '<leader>vv', ':Buffers<CR>', { noremap = true, silent = true })

    --     vim.g.fzf_tags_command = 'ctags -R --exclude=.git --exclude=.idea --exclude=log'
    --     local fzf_action = {}
    --     -- vim.g.fzf_action['ctrl-q'] = 'tab split'
    --     fzf_action['ctrl-t'] = 'tab split'
    --     fzf_action['ctrl-s'] = 'split'
    --     fzf_action['ctrl-v'] = 'vsplit'
    --     vim.g.fzf_action = fzf_action

    --     vim.env.FZF_DEFAULT_OPTS = '--bind=ctrl-a:toggle-all,ctrl-space:toggle+down,ctrl-alt-a:deselect-all'
    --     vim.env.FZF_DEFAULT_COMMAND = 'rg --iglob !.git --files --hidden --ignore-vcs --ignore-file ~/.config/git/gitexcludes'

    --     vim.cmd [[tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"]]
    --     vim.cmd([[ command! -bang -nargs=* Rg ]]..
    --     [[ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),]]..
    --     [[ 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)]])
    --   end,
    -- }
  -- }}}
  -- Indent-guides {{{
    packer.use {
      'glepnir/indent-guides.nvim',
      as = 'indent-guides',
      config = function()
        require('indent_guides').setup({
          indent_levels = 30;
          indent_guide_size = 1;
          indent_start_level = 2;
          indent_space_guides = true;
          indent_tab_guides = false;
          indent_soft_pattern = '\\s';
          exclude_filetypes = {'help','dashboard','dashpreview','nerdtree','vista','sagahover','which_key'};
          even_colors = { fg ='#AAAAAA',bg='#35383F' };
          odd_colors = {fg='#AAAAAA',bg='#35383F'};
        })
      end,
    }
  -- }}}
  -- Galaxyline {{{
    packer.use {
      'glepnir/galaxyline.nvim',
      branch = 'main',
      config = function()
        local gl = require('galaxyline')
        local gls = gl.section
        local condition = require('galaxyline.condition')
        local buffer = require('galaxyline.provider_buffer')
        local fileinfo = require('galaxyline.provider_fileinfo')
        local lspclient = require('galaxyline.provider_lsp')
        local icons = require('galaxyline.provider_fileinfo').define_file_icon()

         local colors = {
          black     = '#35383F',
          bblack    = '#49505E',
          red       = '#cc241d',
          bred      = '#fb4934',
          green     = '#84B97C',
          bgreen    = '#b8bb26',
          yellow    = '#d79921',
          byellow   = '#fabd2f',
          blue      = '#458588',
          bblue     = '#83a598',
          mangenta  = '#b16286',
          bmangenta = '#d3869b',
          cyan      = '#689d6a',
          bcyan     = '#8ec07c',
          white     = '#aaaaaa',
          bwhite    = '#bbbbbb',
        }

        icons['man'] = {colors.green, ''}

        function condition.checkwidth()
          local squeeze_width  = vim.fn.winwidth(0) / 2
          if squeeze_width > 50 then
            return true
          end
          return false
        end

        gls.left = {
          {
            Mode = {
              provider = function()
                local alias = {n = 'NORMAL', i = 'INSERT', c = 'COMMAND', V= 'VISUAL', [''] = 'VISUAL'}
                if not condition.checkwidth() then
                  alias = {n = 'N', i = 'I', c = 'C', V= 'V', [''] = 'V'}
                end
                return string.format('   %s ', alias[vim.fn.mode()])
              end,
              highlight = {colors.black, colors.green, 'bold'},
            }
          },
          {
            GitIcon = {
              provider = function() return '   ' end,
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.white, colors.bblack}
            }
          },
          {
            GitBranch = {
              provider = 'GitBranch',
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.bwhite, colors.bblack}
            }
          },
          {
            DiffAdd = {
              provider = 'DiffAdd',
              icon = '+',
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.green, colors.bblack}
            }
          },
          {
            DiffModified = {
              provider = 'DiffModified',
              icon = '~',
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.yellow, colors.bblack}
            }
          },
          {
            DiffRemove = {
              provider = 'DiffRemove',
              icon = '-',
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.red, colors.bblack}
            }
          },
          {
            BlankSpace = {
              provider = function() return ' ' end,
              highlight = {colors.black, colors.black}
            }
          },
          {
            FileIcon = {
              provider = fileinfo.get_file_icon,
              condition = condition.buffer_not_empty,
              highlight = {
                fileinfo.get_file_icon_color,
                colors.black
              },
            },
          },
          {
            FileName = {
              provider = function()
                return string.format('%s| %s ', fileinfo.get_file_size(), fileinfo.get_current_file_name())
              end,
              condition = condition.buffer_not_empty,
              highlight = {colors.blue, colors.black}
            }
          },
          {
            Blank = {
              provider = function() return '' end,
              highlight = {colors.black, colors.black}
            }
          }
        }

        gls.right = {
          {
            DiagnosticError = {
              provider = 'DiagnosticError',
              icon = '  ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.red, colors.black}
            },
          },
          {
            DiagnosticWarn = {
              provider = 'DiagnosticWarn',
              icon = '  ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.yellow, colors.black}
            },
          },
          {
            DiagnosticHint = {
              provider = 'DiagnosticHint',
              icon = '  ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.cyan, colors.black}
            }
          },
          {
            DiagnosticInfo = {
              provider = 'DiagnosticInfo',
              icon = '  ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.cyan, colors.black}
            }
          },
          {
            LspStatus = {
              provider = function() return string.format(' %s ', lspclient.get_lsp_client()) end,
              icon = '   ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.white, colors.black}
            }
          },
          {
            FileType = {
              provider = function() return string.format(' %s ', buffer.get_buffer_filetype()) end,
              condition = function() return buffer.get_buffer_filetype() ~= '' end,
              highlight = {colors.white, colors.black}
            }
          },
          {
            FileFormat = {
              provider = function() return string.format('   %s ', fileinfo.get_file_format()) end,
              condition = condition.checkwidth,
              highlight = {colors.white, colors.bblack}
            }
          },
          {
            FileEncode = {
              provider = function() return string.format('   %s ', fileinfo.get_file_encode()) end,
              condition = condition.checkwidth,
              highlight = {colors.white, colors.bblack}
            }
          },
          {
            LineInfo = {
              provider = function() return string.format(' %s %s ', fileinfo.current_line_percent(),fileinfo.line_column()) end,
              highlight = {colors.black, colors.white}
            }
          },
        }

        gl.short_line_list = {'nerdtree','vista'}
        gls.short_line_right = {
          {
            FileTypeShort = {
              provider = function() return string.format(' %s ', buffer.get_buffer_filetype()) end,
              condition = function()
                if vim.fn.index(gl.short_line_list, vim.bo.filetype) ~= -1 then
                  return false
                end
                return buffer.get_buffer_filetype() ~= ''
              end,
              highlight = {colors.white, colors.black}
            }
          },
        }

        gls.short_line_left = {
          {
            BufferIcon = {
              provider = function()
                local icon = buffer.get_buffer_type_icon()
                if icon ~= nil then
                  return string.format(' %s ', icon)
                end
              end,
              highlight = {colors.white, colors.black}
            }
          },
          {
            BufferName = {
              provider = function()
                if vim.fn.index(gl.short_line_list, vim.bo.filetype) ~= -1 then
                  local filetype = vim.bo.filetype
                  if filetype == 'nerdtree' then
                    return ' Explorer '
                  elseif filetype == 'vista' then
                    return ' Tags '
                  end
                else
                  if fileinfo.get_current_file_name() ~= '' then
                    return string.format(' %s %s| %s ', fileinfo.get_file_icon(), fileinfo.get_file_size() , fileinfo.get_current_file_name())
                  end
                end
                return ' <...> '
              end,
              separator = '',
              highlight = {colors.white, colors.black}
            }
          },
          {
            BlankShort = {
              provider = function() return '' end,
              highlight = {colors.black, colors.black},
            }
          }
        }
      end,
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    -- packer.use {
    --   'itchyny/lightline.vim',
    --   as = 'lightline',
    --   opt = true,
    --   setup = function ()
    --     vim.cmd [[ packadd neodark ]]
    --   end,
    -- }
    -- local lightline = {
    --   enable = { tabline = 0 },
    --   colorscheme = 'neodark',
    --   active = {
    --     left = {
    --       { 'mode', 'paste' },
    --       { 'gitbranch', 'readonly', 'filename', 'modified' },
    --       { 'venv', 'readonly' }
    --     },
    --     component_function = {
    --       gitbranch = 'fugitive#head',
    --       venv = 'virtualenv#statusline'
    --     }
    --   }
    -- }
    -- vim.g.lightline = lightline
    -- cmd [[ packadd lightline ]]
  -- }}}
  -- Marks {{{
    packer.use {
      'kshenoy/vim-signature',
      config = function ()
        vim.g.SignatureForceRemoveGlobal = 0
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
        map('n', '<leader>mc', [[:call signature#mark#Purge('all')|wshada!<CR>]], { noremap = true, silent = true })
      end,
    }
  -- }}}
  -- NvimTree {{{
    -- Buggy yet. Added for tracking.
    packer.use {
      'kyazdani42/nvim-tree.lua',
      requires = {{'kyazdani42/nvim-web-devicons'}},
      config = function ()
        vim.g.nvim_tree_width = 40
        vim.g.nvim_tree_auto_close = 1
        -- vim.g.nvim_tree_quit_on_open = 1
        vim.g.nvim_tree_follow = 1
        -- Forgets state
        -- vim.g.nvim_tree_tab_open = 1
        vim.g.nvim_tree_group_empty = 1
        vim.g.nvim_tree_disable_netrw = 0
        map('n', '<leader>oE', ':NvimTreeToggle<CR>', { noremap = true })
        map('n', '<leader>fP', ':NvimTreeFindFile<CR>', { noremap = true })

        local tree_cb = require'nvim-tree.config'.nvim_tree_callback
        vim.g.nvim_tree_bindings = {
          -- ["<CR>"] = ":YourVimFunction()<cr>",
          -- ["u"] = ":lua require'some_module'.some_function()<cr>",

          -- default mappings
          ["<CR>"]           = tree_cb("edit"),
          ["o"]              = tree_cb("edit"),
          ["<C-]>"]          = tree_cb("cd"),
          ["C"]              = tree_cb("cd"),
          ["v"]              = tree_cb("vsplit"),
          ["s"]              = tree_cb("split"),
          ["t"]              = tree_cb("tabnew"),
          ["<BS>"]           = tree_cb("close_node"),
          ["<S-CR>"]         = tree_cb("close_node"),
          ["<Tab>"]          = tree_cb("preview"),
          ["I"]              = tree_cb("toggle_ignored"),
          ["H"]              = tree_cb("toggle_dotfiles"),
          ["R"]              = tree_cb("refresh"),
          ["a"]              = tree_cb("create"),
          ["d"]              = tree_cb("remove"),
          ["r"]              = tree_cb("rename"),
          ["<C-r>"]          = tree_cb("full_rename"),
          ["x"]              = tree_cb("cut"),
          ["c"]              = tree_cb("copy"),
          ["p"]              = tree_cb("paste"),
          ["[c"]             = tree_cb("prev_git_item"),
          ["]c"]             = tree_cb("next_git_item"),
          ["u"]              = tree_cb("dir_up"),
          ["q"]              = tree_cb("close"),
        }
      end,
    }
  --   -- }}}
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
        vim.g.NERDTreeWinSize=45
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

        -- local au_nerd = {
        --   {[[ FileType nerdtree lua load_nerdtree_ft() ]]}
        -- }
        -- augroups({au_nerd=au_nerd})

        -- _G.load_nerdtree_ft = function ()
        --   bmap('n', 'r', ':Rooter<CR>', {})
        -- end

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
        -- vim.g.rooter_silent_chdir = 1
        vim.g.rooter_resolve_links = 1
        vim.g.rooter_manual_only = 1
        vim.g.rooter_cd_cmd = 'lcd'
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
  -- Texting {{{
    packer.use {
      'junegunn/goyo.vim',
      requires = {
        {
          'junegunn/limelight.vim',
          opt = true,
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

    vim.cmd[[packadd limelight.vim]]

    _G.goyo_enter = function()
      if fn.executable('tmux') == 1 and fn.exists('$TMUX') == 1 then
        execute '!tmux set status off'
        execute([[!tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z]])
      end
      require('galaxyline').disable_galaxyline()
      vim.defer_fn(function()
        vim.wo.statusline = ''
        vim.o.showmode = false
        vim.o.showcmd = false
        vim.o.scrolloff = 999
        vim.wo.wrap = true
        vim.cmd('IndentGuidesDisable')
        vim.cmd('Limelight')
      end, 1000)
    end

    _G.goyo_leave = function()
      if fn.executable('tmux') == 1 and fn.exists('$TMUX') == 1 then
        execute '!tmux set status on'
        execute [[!tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z]]
      end
      require('galaxyline').load_galaxyline()
      require('galaxyline').galaxyline_augroup()
      vim.defer_fn(function()
        vim.o.showmode = true
        vim.o.showcmd = true
        vim.o.scrolloff = 5
        vim.wo.wrap = false
        vim.cmd('IndentGuidesEnable')
        vim.cmd('Limelight!')
      end, 1000)
    end

    local au_goyo = {
      { 'User GoyoEnter nested silent lua goyo_enter()' };
      { 'User GoyoLeave nested silent lua goyo_leave()' };
    }
    augroups({au_goyo=au_goyo})

    map('n', '<leader>tt', ':Goyo<CR>', { noremap = true })
    -- Spelling
    vim.g.myLangList = { 'nospell', 'en_us', 'ru_ru' }
    local index={}
    for k,v in pairs(vim.g.myLangList) do
      index[v]=k
    end
    _G.toggle_spell = function()
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
      config = function ()
        vim.g.VimuxHeight = "20"
        vim.g.VimuxUseNearest = 0
      end,
    }

    if fn.exists('$TMUX') == 1 then
      _G.run_cmd = function(command)
        execute('VimuxRunCommand("'..command..'")')
      end

      exec([[
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
    _G.zoom_toggle = function()

      local zoom_nerd = false
      local zoom_tag = false

      if vim.t.NERDTreeBufName and fn.bufwinnr(vim.t.NERDTreeBufName) ~= -1 then
        cmd 'NERDTreeClose'
        zoom_nerd = true
      end

      if fn.bufwinnr('vista') ~= -1 then
        cmd 'Vista!'
        zoom_tag = true
      end

      cmd [[call zoom#toggle()]]

      if zoom_nerd then
        cmd 'NERDTreeCWD'
        execute ':wincmd p'
      end

      if zoom_tag then
        cmd 'Vista'
        execute ':wincmd p'
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
        { 'ewok/vimwiki-sync' },
        -- { '/home/ataranchiev/projects/vim/vimwiki-sync/' },
        { 'junegunn/fzf.vim' },
        { 'junegunn/fzf' },
      },
      setup = function()
        vim.g.vimwiki_list = {
          {
            path = os.getenv('HOME')..'/Notes/',
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
        -- Zettel part
        vim.g.zettel_format = "%y%m%d-%H%M-%title"
        vim.g.zettel_default_mappings = 0
        _G.update_back_links = function()
          local bline = vim.fn.search('# Backlinks', 'wnb')
          if bline ~= 0 then
            vim.cmd (bline..[[,$delete]])
            vim.cmd [[d]]
          end
          vim.cmd [[ZettelBackLinks]]
        end
      end,
      config = function()
        map('n', '<leader>ww', ':silent call VimwikiIndexCd()<CR>', { noremap = true })
        map('n', '<leader>wi', ':VimwikiDiaryIndex<CR>', { noremap = true })
        map('n', '<leader>wj', ':VimwikiDiaryNextDay<CR>', { noremap = true })
        map('n', '<leader>wk', ':VimwikiDiaryPrevDay<CR>', { noremap = true })
        map('n', '<leader>wmc', ':VimwikiCheckLinks<CR>', { noremap = true })
        map('n', '<leader>wmt', ':VimwikiRebuildTags<CR>', { noremap = true })
        map('n', '<leader>wt', ':call VimwikiMakeDiaryNoteNew()<CR>', { noremap = true })

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
  -- Vista {{{
    packer.use {
      'liuchengxu/vista.vim',
      requires = {{'junegunn/fzf'}},
      config = function ()
        map('n', '<leader>ov', ':Vista<CR>', { noremap = true })
        map('n', '<leader>ft', ':Vista finder<CR>', { noremap = true })
        vim.cmd [[tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"]]
        vim.g.vista_close_on_jump = 1
        local vista_executive_for = {
          vimwiki = 'markdown',
          pandoc = 'markdown',
          markdown = 'toc',
          python = 'nvim_lsp',
          rust = 'nvim_lsp',
          yaml = 'nvim_lsp',
          ['ansible.yaml'] = 'nvim_lsp',
          json = 'nvim_lsp',
          lua = 'nvim_lsp',
          sh = 'nvim_lsp'
        }
        vim.g.vista_executive_for = vista_executive_for
        vim.g.vista_echo_cursor_strategy = "both"
      end,
    }
  -- }}}
-- Code
  -- ALE {{{
    packer.use {
      'w0rp/ale',
      ft = {'sh', 'zsh', 'bash', 'c',
      'cpp', 'cmake', 'html', 'markdown',
      'racket', 'vim', 'text', 'ansible', 'yaml',
      'yaml.ansible', 'dockerfile', 'python' },
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
        { 'honza/vim-snippets', },
        { 'hrsh7th/vim-vsnip', },
        { 'cstrap/python-snippets', },
        { 'rust-lang/vscode-rust', },
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
          max_abbr_width = 100;
          max_kind_width = 100;
          max_menu_width = 100;
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
            nvim_treesitter = true;
            emoji = true;
          };
        }

        local t = function(str)
          return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        local check_back_space = function()
          local col = vim.fn.col('.') - 1
          if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return true
          else
            return false
          end
        end

        _G.tab_complete = function(key)
          local key = key or "<Tab>"
          if vim.fn.pumvisible() == 1 then
            return t "<C-n>"
          elseif vim.fn.call("vsnip#available", {1}) == 1 then
            return t "<Plug>(vsnip-expand-or-jump)"
          elseif check_back_space() then
            return t(key)
          else
            return vim.fn['compe#complete']()
          end
        end
        _G.s_tab_complete = function(key)
          local key = key or "<S-Tab>"
          if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
          elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
            return t "<Plug>(vsnip-jump-prev)"
          else
            return t(key)
          end
        end

        map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
        map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
        map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
        map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

        map("i", "<C-j>", "v:lua.tab_complete('<C-j>')", {expr = true})
        map("s", "<C-j>", "v:lua.tab_complete('<C-j>')", {expr = true})
        map("i", "<C-k>", "v:lua.s_tab_complete('<C-k>')", {expr = true})
        map("s", "<C-k>", "v:lua.s_tab_complete('<C-k>')", {expr = true})

        map("i", "<C-Space>", "compe#complete()", {expr = true})
        map("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
        map("i", "<C-e>", "compe#close('<C-e>')", {expr = true})
        map("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {expr = true})
        map("i", "<C-b>", "compe#scroll({ 'delta': -4 })", {expr = true})
      end,
    }
  -- }}}
  -- LSP {{{
    packer.use {
      'neovim/nvim-lspconfig',
      requires = {
        {
          'onsails/lspkind-nvim',
          config = function()
            require('lspkind').init({
              with_text = false,
              symbol_map = {
                Text = '  ',
                Method = '  ',
                Function = '  ',
                Constructor = '  ',
                Variable = '[]',
                Class = '  ',
                Interface = ' 蘒',
                Module = '  ',
                Property = '  ',
                Unit = ' 塞 ',
                Value = '  ',
                Enum = ' 練',
                Keyword = '  ',
                Snippet = '  ',
                Color = '',
                File = '',
                Folder = ' ﱮ ',
                EnumMember = '  ',
                Constant = '  ',
                Struct = '  '
              },
            })
          end,
        },
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
        local function common_on_attach(client, _)
          if client.resolved_capabilities.document_highlight then
            vim.api.nvim_exec([[
              hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
              hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
              hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
            ]], false)
            local lsp_document_highlight = {
              {'CursorHold <buffer> lua vim.lsp.buf.document_highlight()'};
              {'CursorMoved <buffer> lua vim.lsp.buf.clear_references()'};
            }
            augroups_buff({lsp_document_highlight=lsp_document_highlight})
          end
        end
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
        require'lspconfig'.rust_analyzer.setup{
          on_attach = common_on_attach,
          autostart = false,
        }
        require'lspconfig'.pyright.setup{
          on_attach = common_on_attach,
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
          on_attach = common_on_attach,
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
        require'lspconfig'.rnix.setup{
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
          ensure_installed = { 'comment', 'python', 'regex', 'yaml', 'rust', 'bash', 'json', 'lua', 'nix', 'go' },
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
    'wincent/ferret',
    config = function()
      vim.g.FerretMap = 0
      map('n', '<leader>fr<space>', '<Plug>(FerretAck)', {})
      map('n', '<leader>fr<cr>', '<Plug>(FerretAcks)', {})
    end,
    }
    -- packer.use {
    --   'brooth/far.vim',
    --   config = function ()
    --     vim.g['far#source'] = 'agnvim'
    --     vim.g['far#file_mask_favorites'] = { '%', '.*', '\\.py$', '\\.go$' }
    --     map('n', '<leader>fr', ':Far<space>', { noremap = true })
    --     map('v', '<leader>fr', ':Far<space>', { noremap = true })
    --   end,
    -- }
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
        _G.git_show_block_history = function()
          vim.cmd[[exe ":G log -L " . string(getpos("'<'")[1]) . "," . string(getpos("'>'")[1]) . ":%"]]
        end

        _G.git_show_line_history = function()
          vim.cmd[[exe ":G log -U1 -L " . string(getpos('.')[1]) . ",+1:%"]]
        end

        local au_git = {
          {[[FileType git nnoremap <buffer> <silent> c :WhichKey 'c'<CR>]]};
          {[[FileType git nnoremap <buffer> <silent> d :WhichKey 'd'<CR>]]};
          {[[FileType git nnoremap <buffer> <silent> r :WhichKey 'r'<CR>]]};
          {[[FileType fugitive nnoremap <buffer> <silent> c :WhichKey 'c'<CR>]]};
          {[[FileType fugitive nnoremap <buffer> <silent> d :WhichKey 'd'<CR>]]};
          {[[FileType fugitive nnoremap <buffer> <silent> r :WhichKey 'r'<CR>]]};
          -- {[[BufEnter */.git/index nnoremap <buffer> <silent> c :WhichKey 'c'<CR>]]};
          -- {[[BufEnter */.git/index nnoremap <buffer> <silent> d :WhichKey 'd'<CR>]]};
          -- {[[BufEnter */.git/index nnoremap <buffer> <silent> r :WhichKey 'r'<CR>]]};
        }
        augroups({au_git=au_git})

        map('n', '<leader>gs', ':Gstatus<CR>', { silent = true })
        map('n', '<leader>gd', ':Gdiff<CR>', { silent = true })
        map('n', '<leader>gC', ':Gcommit<CR>', { silent = true })
        map('n', '<leader>gW', ':Gwrite<CR>', { silent = true })
        map('n', '<leader>gR', ':Gread<CR>', { silent = true })
        map('n', '<leader>gR', ':Gread<CR>', { silent = true })

        map('n', '<leader>gb', ':Gblame<CR>', { silent = true })

        map('n', '<leader>gps', ':G push<CR>', { silent = true })
        map('n', '<leader>gplr', ':G pull --rebase<CR>', { silent = true })
        map('n', '<leader>gplm', ':G pull<CR>', { silent = true })
        map('n', '<leader>gg', ':.Gbrowse %<CR>', { silent = true })
        map('v', '<leader>gg', [[:'<,'>Gbrowse %<CR>]], { silent = true })
        map('v', '<leader>ghv', ':<C-U>lua git_show_block_history()<CR>', { silent = true })
        map('n', '<leader>ghl', ':lua git_show_line_history()<CR>', { silent = true })
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
        map('n', '<F1>', '<Plug>Zeavim', {})
        map('n', 'gzz', '<Plug>Zeavim', {})
        map('v', 'gzz', '<Plug>ZVVisSelection', {})
        map('n', 'gZ', '<Plug>ZVKeyDocset<CR>', {})
        map('n', 'gz', '<Plug>ZVOperator', {})
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
  -- Codi {{{
    packer.use{
      'metakirby5/codi.vim',
      cmd = {'Codi'},
    }
    map('n', '<leader>cP', ':Codi!! python<CR>', {})
    map('n', '<leader>cL', ':Codi!! lua<CR>', {})
  -- }}}
  -- Debug {{{
    packer.use{
      'mfussenegger/nvim-dap',
      requires = {
        {
          "mfussenegger/nvim-dap-python",
          config = function()
            require('dap-python').setup('python')
          end,
        },{
          "theHamsta/nvim-dap-virtual-text",
          config = function()
            vim.g.dap_virtual_text = true
          end,
        },{
          "nvim-telescope/telescope-dap.nvim",
          config = function()
            map('n', '<leader>dB', ':Telescope dap list_breakpoints<CR>', {})
            map('n', '<leader>dv', ':Telescope dap variables<CR>', {})
          end,
        }
      },
      config = function()
        map('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<CR>', {})
        map('n', '<leader>dc', ':lua require"dap".continue()<CR>', {})
        map('n', '<leader>dn', ':lua require"dap".step_over()<CR>', {})
        map('n', '<leader>di', ':lua require"dap".step_into()<CR>', {})
        map('n', '<leader>do', ':lua require"dap".step_out()<CR>', {})
        map('n', '<leader>dS', ':lua require"dap".stop()<CR>', {})
        map('n', '<leader>dr', ':lua require"dap".repl.open()<CR>', {})
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
      nnoremap <silent> <leader>ot :call OpenToDo()<CR>
      function! OpenToDo()
        silent! vsplit TODO.md
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
      let g:current_session_dir = getcwd()

      function! MakeSession(file)

        " if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exe ':tabdo NERDTreeClose'
        " endif

        " if bufwinnr('vista') != -1)
        exe ':tabdo Vista!'
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
            let b:sessiondir = g:sessiondir . g:current_session_dir
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
            let b:sessiondir = g:sessiondir . g:current_session_dir
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
            let b:sessiondir = g:sessiondir . g:current_session_dir
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
    local auto_save_locked = false
    local auto_save_checkpoint = 0
    vim.g.timer_count = 0

    local timer = vim.loop.new_timer()
    local co = coroutine.create(function ()
      while true do
        timer:start(4000, 4000, vim.schedule_wrap(function()
          if (os.time() - auto_save_checkpoint) > 4 then
            auto_save()
            auto_save_locked = false
            timer:stop()
            -- timer:close()
          end
        end))
        coroutine.yield()
      end
    end)

    _G.auto_save_reset_checkpoint = function ()
      auto_save_checkpoint = os.time()
    end

    _G.auto_save_trigger = function ()
      if auto_save_locked then return else auto_save_locked = true end
      coroutine.resume(co)
    end

    _G.auto_save = function ()
      if vim.bo.modified then
        vim.api.nvim_command('silent! write')
        if not vim.bo.modified then
          print("(AutoSave) saved at ".. vim.fn.strftime("%H:%M:%S"))
          auto_save_checkpoint = os.time()
        end
      end
    end

    _G.reg_auto_save = function()
      local reg_auto_save = {
        {('CursorHold <buffer> lua auto_save_trigger()')};
        {('CursorHoldI <buffer> lua auto_save_trigger()')};
        {('BufLeave <buffer> lua auto_save()')};
        {('FocusLost <buffer> lua auto_save()')};
        {('WinLeave <buffer> lua auto_save()')};
        {('CursorMoved <buffer> lua auto_save_reset_checkpoint()')};
      }
      augroups_buff({reg_auto_save=reg_auto_save})
    end
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
      " if winnr() != winnr
      "   wincmd p
      " endif
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
  -- AutoHighlight Current Word {{{

    _G.highlight_cword = function()
      clear_cword_highlight()

      local cword = vim.fn.expand('<cword>')

      if cword then
        if vim.fn.match(cword, [[\w\+]]) >= 0 then
          local ecword = vim.fn.substitute(cword, [[\(*\)]], [[\\\1]], 'g')
          local m_id = vim.fn.matchadd('AutoHiWord', [[\<]]..ecword..[[\>]], 0)
          local hi_ids = vim.w.hi_ids
          table.insert(hi_ids, m_id)
          vim.w.hi_ids = hi_ids
        end
      end
    end
    _G.clear_cword_highlight = function()
      if not vim.w.hi_ids then
        vim.w.hi_ids = {}
      end

      if #vim.w.hi_ids > 0 then
        vim.fn.matchdelete(vim.w.hi_ids[#vim.w.hi_ids])
        local hi_ids = vim.w.hi_ids
        table.remove(hi_ids)
        vim.w.hi_ids = hi_ids
      end
    end
    -- vim.cmd[[hi! AutoHiWord ctermbg=245 ctermfg=NONE guibg=#6b7589 guifg=NONE gui=underline]]
    _G.reg_highlight_cword = function()
      local reg_highlight_cword = {
        {'CursorHold <buffer> silent! lua highlight_cword()'};
        {'CursorMoved <buffer> silent! lua clear_cword_highlight()'};
      }
      augroups_buff({reg_highlight_cword=reg_highlight_cword})
    end
  -- }}}
  -- SmartCR {{{
    _G.smart_cr = function()
      local line = vim.fn.getline('.')
      if string.find(line, ';$') then
        vim.api.nvim_command("normal ".. t[[o<Space><BS><Esc>]])
        vim.cmd'startinsert!'
      else
        vim.fn.setline('.', line..';')
        vim.api.nvim_command("normal l")
        vim.cmd'startinsert'
      end
    end
    _G.reg_smart_cr = function()
      bmap('i', '<C-Enter>', '<ESC>:lua smart_cr()<CR>', {})
    end
  -- }}}
-- }}}

-- Testing {{{
  -- -- DrawIt {{{
  --   packer.use {
  --     'ewok/DrawIt'
  --   }
  -- -- }}}
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
  lmap.d = {name = '+Debug'}
  lmap.d.B = 'Breakpoints'
  lmap.d.b = 'set Breakpoint'
  lmap.d.c = 'Run/Continue'
  lmap.d.i = 'Step Into'
  lmap.d.n = 'Step Over'
  lmap.d.o = 'Step Out'
  lmap.d.r = 'Repl'
  lmap.d.S = 'Stop'
  lmap.d.v = 'Variables'
  lmap.f = {name = '+Find' }
  lmap.f.b = 'Buffer'
  lmap.f.b = 'Cheat'
  lmap.f.f = 'in-File'
  lmap.f.p = 'file in Path'
  lmap.f.r = { name = '+Replace',
    [' '] = 'Search',
    ['<CR>'] = 'Replace'
  }
  lmap.f.o = 'and-Open file'
  lmap.f.t = 'Tag'
  lmap.g = {name = '+Git'}
  lmap.g.b = 'Blame'
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
  lmap.m.m = 'Find'
  lmap.m.c = 'Clean'
  lmap.o = { name = '+Open/+Option'}
  lmap.o.n = { name = '+Options+Neovim'}
  lmap.o.n.a = 'Autocommands'
  lmap.o.n.c = 'Commands'
  lmap.o.n.s = 'Colorscheme'
  lmap.o.n.i = 'hIghlights'
  lmap.o.n.k = 'Keymaps'
  lmap.o.o = 'All Options'
  lmap.o.e = 'Explorer'
  lmap.o.f = 'File'
  lmap.o.h = 'Help'
  lmap.o.r = 'Root(project)'
  lmap.o.s = { name = '+Set'}
  lmap.o.s.f = 'Filetype'
  lmap.o.t = 'To-Do'
  lmap.o.u = { name = '+Unset'}
  lmap.o.v = 'Vista'
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
  lmap.t = { name = '+Text' }
  lmap.t.f = {name = '+Fix'}
  lmap.t.s = 'Syntax'
  lmap.t.t = 'Text-only(Goyo)'
  lmap.u = 'Undo'
  lmap.w = { name = '+Wiki' }
  lmap.w.w = 'Index'
  lmap.w.m = { name = '+Maintanence'}
  lmap.w.m.c = 'Check Links'
  lmap.w.m.t = 'Rebuild Tags'
  lmap.w.t = 'Today'
  lmap.w.T = 'Tag Rebuild+Insert'
  lmap.w.i = 'Diary'
  lmap.w.r = 'Rename link'
  lmap.w.d = 'Delete link'
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
  vim.g.which_key_align_by_seperator = 1
  vim.g.which_key_run_map_on_popup = 1
  vim.g.which_key_fallback_to_native_key = 1
  vim.g.which_key_flatten = 0
  -- Register which key
  vim.fn['which_key#register']('<Space>', vim.g.lmap)
-- }}}

-- Load local config {{{
  vim.api.nvim_exec([[
  try
  source ~/.vimrc.local
  catch
  " Ignoring
  endtry
  ]], true)
-- }}}
