-- vim: ts=2 sw=2 sts=2

-- Helpers {{{
  _G.augroups = function(definitions)
    for group_name, definition in pairs(definitions) do
      vim.api.nvim_command('augroup '..group_name)
      vim.api.nvim_command('autocmd!')
      for _, def in ipairs(definition) do
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

  _G.interp = function(s, tab)
    return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
  end
  getmetatable("").__mod = interp
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

-- WhichKey {{{
  packer.use {
    "folke/which-key.nvim",
    opt = true,
    as = 'which-key',
    config = function()
      require("which-key").setup {
        operators = { gc = "Comments", gz = "Zeal in" },
      }
    end
  }
  cmd [[packadd which-key]]
  local wk = require("which-key")
  _G.wkmap = wk.register

  -- Some common menu items
  wkmap({
    ['<leader>'] = {
      b = '+Buffers',
      c = '+Code',
      f = '+Find',
      m = '+Marks',
      o = '+Open/+Options',
    }
  })
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
      showtabline = 2;
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

    set sessionoptions+=globals

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
  -- Colors {{{
    _G.colors = {
      color_0 = "#282c34",
      color_1 = "#e06c75",
      color_2 = "#98c379",
      color_3 = "#e5c07b",
      color_4 = "#61afef",
      color_5 = "#c678dd",
      color_6 = "#56b6c2",
      color_7 = "#abb2bf",
      color_8 = "#545862",
      color_9 = "#d19a66",
      color_10 = "#353b45",
      color_11 = "#3e4451",
      color_12 = "#565c64",
      color_13 = "#b6bdca",
      color_14 = "#be5046",
      color_15 = "#c8ccd4",
    }
  -- }}}
-- }}}

-- Keymaps {{{
  wkmap({
    -- Go back and forward
    ['<C-O>'] = {
      ['<C-O>'] = {'<C-O>', 'Go Back'},
      ['<C-I>'] = {'<Tab>', 'Go Forward'},
    },
    ['<C-W>'] = {

      -- Tabs
      t = {'<cmd>tabnew<CR>', 'New Tab'},

      -- Terminal
      S = fn.exists('$TMUX') == 1
      and {'<cmd>!tmux split-window -v -p 20<CR><CR>', 'Split window[tmux]'}
      or {'<cmd>split term://bash<CR>i', 'Split window[terminal]'},
      V = fn.exists('$TMUX') == 1
      and {'<cmd>!tmux split-window -h -p 20<CR><CR>', 'VSplit window[tmux]'}
      or {'<cmd>vsplit term://bash<CR>i', 'VSplit window[terminal]'},

      -- Resize
      ['<C-J>'] = {':resize +5<CR>', 'Increase height +5'},
      ['<C-K>'] = {':resize -5<CR>', 'Decrease height -5'},
      ['<C-L>'] = {':vertical resize +5<CR>', 'Increase width +5'},
      ['<C-H>'] = {':vertical resize -5<CR>', 'Decrease width -5'},

      -- Don't close last window
      q = {'<cmd>close<CR>', 'Quit a window'}
    },

    -- Folding
    [']z'] = {'zjmzzMzvzz15<c-e>`z', 'Next Fold'},
    ['[z'] = {'zkmzzMzvzz15<c-e>`z', 'Previous Fold'},
    z = {
      O = {'zczO', 'Open all folds under cursor'},
      C = {'zcV:foldc!<CR>', 'Close all folds under cursor'},
      ['<Space>'] = {'mzzMzvzz15<c-e>`z', 'Show only current Fold'}
    },
    ['<Space><Space>'] = {'za"{{{"', 'Toggle Fold'},

    -- Yank
    ['<leader>'] = {
      y = {
        name = "+Yank",
        y = {'<cmd>.w! ~/.vbuf<CR>', 'Yank to ~/.vbuf'},
        p = {'<cmd>r ~/.vbuf<CR>', 'Paste from ~/.vbuf'},

        -- Yank some data
        f = {
          name = "+File",
          l = {[[:let @+=expand("%") . ':' . line(".")<CR>]], 'Yank file name and line'},
          n = {[[:let @+=expand("%")<CR>]], 'Yank file name'},
          p = {[[:let @+=expand("%:p")<CR>]], 'Yank file path'}
        }
      },

      -- Packer
      p = {
        name = '+Packer',
        u = {'<cmd>PackerUpdate<CR>', 'Update'},
        C = {'<cmd>PackerClean<CR>', 'Clean'},
        c = {'<cmd>PackerCompile<CR>', 'Compile'},
        i = {'<cmd>PackerInstall<CR>', 'Install'},
        s = {'<cmd>PackerSync<CR>', 'Sync'},
      },
    }
  },{
    noremap = true,
  })

  wkmap({
    -- Folding
    ['<Space><Space>'] = {'zf"}}}"', 'Toggle Fold'},

    -- Permanent buffer
    ['<leader>'] = {
      y = {
        name = "+Yank",
        y = {[[:'<,'>w! ~/.vbuf<CR>]], 'Yank to ~/.vbuf'},
      },
    },
  },{
    mode = 'x',
    noremap = true
  })

  -- Replace search
  exec([[
  nmap <expr>  MR  ':%s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
  vmap <expr>  MR  ':s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
  ]], true)

  -- Replace without yanking
  map('v', 'p', ':<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>', { noremap = true })

  -- Tunings
  map('n', 'Y', 'y$', { noremap = true })

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

  -- Smart start line
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

  -- Terminal
  vim.cmd [[tnoremap <Esc> <C-\><C-n>]]
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
      {[[ BufNewFile,BufRead *.conf,*.cfg,*.ini set filetype=cfg ]]};
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
    local ft_go = {
      {[[ FileType go lua load_go_ft() ]]}
    }
    augroups({ft_go=ft_go})
    _G.load_go_ft = function()

      wkmap({
        name = '+Run[go]',
        r = {'<cmd>GoRun<CR>', 'Run'},
        t = {'<cmd>GoTest<CR>', 'Test'},
        b = {'<cmd>GoBuild<CR>', 'Build'},
        c = {'<cmd>GoCoverageToggle<CR>', 'Coverage Toggle'},
      },{
        prefix = '<leader>r',
        silent = false,
        noremap = true,
        buffer = api.nvim_get_current_buf()
      })

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

      wkmap({
        name = '+Run[helm]',
        r = {function() render_helm() end, 'Render'},
      },{
        prefix = '<leader>r',
        silent = true,
        noremap = true,
        buffer = api.nvim_get_current_buf()
      })

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

      wkmap({
        name = '+Run[mail]',
        y = {':%!pandoc -f markdown_mmd -t html<CR>', 'From MD to HTML'},
        r = {':LivedownPreview<CR>', 'Live preview'},
        t = {':LivedownToggle<CR>', 'Live preview ON/OFF'},
        k = {':LivedownKill<CR>', 'Kill live preview'}
      },{
        prefix = '<leader>r',
        silent = false,
        noremap = true,
        buffer = api.nvim_get_current_buf()
      })

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

      cmd [[ command! -bang -nargs=? EvalBlock call medieval#eval(<bang>0, <f-args>) ]]

    -- inoremap <buffer><expr> ]] fzf#vim#complete({
    --       \ 'source':  'rg --no-heading --smart-case  .',
    --       \ 'reducer': function('<sid>make_note_link'),
    --       \ 'options': '--multi --reverse --margin 15%,0',
    --       \ 'window': { 'width': 0.9, 'height': 0.6 }})

      -- bmap('i', ']]', )

      -- Zettel
      bmap('i', '[[', 'qq<esc><Plug>ZettelSearchMap', { silent = true })
      bmap('x', '<CR>', '<Plug>ZettelNewSelectedMap', { silent = true })

      wkmap({
        ['<CR>'] = {'<cmd>VimwikiFollowLink<CR>', 'Follow Link'},
        ['<Backspace>'] = {'<cmd>VimwikiGoBackLink<CR>', 'Go Back'},
        [']w'] = {'<cmd>VimwikiNextLink<CR>', 'Next Wiki Link'},
        ['[w'] = {'<cmd>VimwikiPrevLink<CR>', 'Prev Wiki Link'},
        ['<leader>oT'] = {'<cmd>silent ! typora "%" &<CR>', 'Open in Typora'},
        ['<leader>r'] = {
          name = '+Run[md]',
          b = {'<cmd>EvalBlock<CR>', 'Run Block'},
          r = {'<cmd>LivedownPreview<CR>', 'Live preview'},
          t = {'<cmd>LivedownToggle<CR>', 'Live preview ON/OFF'},
          k = {'<cmd>LivedownKill<CR>', 'Kill live preview'}
        },
        ['<leader>w'] = {
          name = '+Wiki',
          b = {'<cmd>VimwikiBacklinks<cr>', 'Update wiki backlinks'},
          d = {'<cmd>VimwikiDeleteFile<CR>', 'Delete page'},
          r = {'<cmd>VimwikiRenameFile<CR>', 'Rename page'},
          T = {'<cmd>VimwikiRebuildTags!<cr>:VimwikiGenerateTagLinks<cr><c-l>', 'Rebuild tags'},
          j = {'<cmd>VimwikiDiaryNextDay<CR>', 'Show Next Day'},
          k = {'<cmd>VimwikiDiaryPrevDay<CR>', 'Show Previous Day'},
          m = {
            name = '+Maint',
            c = {'<cmd>VimwikiCheckLinks<CR>', 'Check Links'},
            t = {'<cmd>VimwikiRebuildTags<CR>', 'Rebuild Tags'},
          }
        },
        ['<leader>z'] = {
          name = '+Zettel',
          b = {function() update_back_links() end, 'Update Backlinks'},
          z = {'<cmd>ZettelOpen<CR>', 'Open'},
          y = {'<cmd>ZettelYankName<CR>', 'Yank Page'},
          n = {':ZettelNew<space>', 'New'},
          i = {'<cmd>ZettelInsertNote<CR>', 'Insert Note'},
          C = {'<cmd>ZettelCapture<CR>', 'Capture as Note'},
        },
      },{
        silent = false,
        noremap = true,
        buffer = api.nvim_get_current_buf()
      })

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

      wkmap({
        ['<leader>c'] = {
          f = {function() format_python() end, 'Formatting[black]'},
        },
        ['<leader>r'] = {
          name = '+Run[python]',
          b = {'ofrom pudb import set_trace; set_trace()<esc>', 'Breakpoint'},
          r = {'<cmd>w|lua run_cmd("python " .. vim.fn.bufname("%"))<CR>', 'Run'},
          t = {'<cmd>w|lua run_cmd("python -m unittest " .. vim.fn.bufname("%"))<CR>', 'Test'},
          T = {'<cmd>w|lua run_cmd("python -m unittest")<CR>', 'Test All'},
          L = {'<cmd>:!pip install flake8 mypy pylint bandit pydocstyle pudb jedi<CR>:ALEInfo<CR>', 'Install Libs'},
          R = {
            name = '+Runner',
            Q = 'Closer Runner',
            X = 'Interrupt'
          }
        },
      },{
        silent = true,
        buffer = api.nvim_get_current_buf()
      })

      _G.format_python = function()
        vim.api.nvim_command('silent! write')
        vim.api.nvim_command('silent ! black -l 119 %')
        vim.api.nvim_command('silent e')
      end

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
      reg_dap_keys()
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

      wkmap({
        name = '+Run[puppet]',
        r = {'<cmd>w |lua run_cmd("puppet " .. vim.fn.bufname("%"))<CR>', 'Run'},
        t = {'<cmd>w |lua run_cmd("puppet parser validate")<CR>', 'Test'},
        L = {'<cmd>!gem install puppet puppet-lint r10k yaml-lint<CR>:ALEInfo<CR>', 'Install Libs'},
        R = {
          name = '+Runner',
          Q = 'Closer Runner',
          X = 'Interrupt'
        }
      },{
        prefix = '<leader>r',
        silent = true,
        buffer = api.nvim_get_current_buf()
      })

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

      wkmap({
        name = '+Run[rust]',
        r = {'<cmd>RustRun<CR>', 'Run'},
        t = {'<cmd>RustTest<CR>', 'Test'},
        L = {'<cmd>RustFmr<CR>', 'Install Libs'},
        R = {
          name = '+Runner',
          Q = 'Closer Runner',
          X = 'Interrupt'
        }
      },{
        prefix = '<leader>r',
        silent = false,
        buffer = api.nvim_get_current_buf()
      })

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

      wkmap({
        name = '+Run[shell]',
        r = {'<cmd>w |lua run_cmd("bash " .. vim.fn.bufname("%"))<CR>', 'Run'},
        R = {
          name = '+Runner',
          Q = 'Closer Runner',
          X = 'Interrupt'
        }
      },{
        prefix = '<leader>r',
        buffer = api.nvim_get_current_buf()
      })

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
      require'lspconfig'.terraformls.autostart()
      -- reg_highlight_cword()
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
  -- BufferLine {{{
    packer.use {
      'akinsho/nvim-bufferline.lua',
      as = 'bufferline',
      requires = {
        'kyazdani42/nvim-web-devicons',
        {
          'moll/vim-bbye',
          config = function()
            wkmap({
              ['<C-W>'] = {
                d = {'<cmd>Bdelete<CR>', 'Delete Buffer'},
                ['<C-D>'] = {'<cmd>Bdelete<CR>', 'Delete Buffer'}
              }
            })
          end,
        }
      },
      run = function(plugin)

        local bufferline_patch = [[
diff --git a/lua/bufferline.lua b/lua/bufferline.lua
index 52d1e26..15c6e8e 100644
--- a/lua/bufferline.lua
+++ b/lua/bufferline.lua
@@ -583,7 +583,7 @@ local function render(bufs, tbs, prefs)
   local right_element_size = strwidth(join(padding, padding, right_trunc_icon, padding))

   local offset_size, left_offset, right_offset = require("bufferline.offset").get(prefs)
-  local available_width = vim.o.columns - offset_size - tabs_length - close_length
+  local available_width = vim.o.columns - offset_size - tabs_length - close_length - vim.fn.len(vim.fn.fnamemodify(vim.fn.getcwd(), ':~'))
   local before, current, after = get_sections(bufs)
   local line, marker = truncate(before, current, after, available_width, {
     left_count = 0,
     ]]
        local fh, err, oserr = io.open(plugin.install_path .. '/patch.txt', 'wb')
        if not fh then return fh, err, oserr end
        fh:write(bufferline_patch)
        fh:close()
        os.execute('cd ' .. plugin.install_path .. ' && patch -i patch.txt -p1 && rm -f patch.txt || true')
      end,
      config = function()
        require'bufferline'.setup{
          options = {
            mappings = false,
            max_name_length = 18,
            max_prefix_length = 15,
            tab_size = 18,
            diagnostics = "nvim_lsp",
            separator_style = "slant",
            diagnostics_indicator = function(_, _, diagnostics_dict)
              local s = " "
              for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " "
                or (e == "warning" and " " or " " )
                s = s .. n .. sym
              end
              return s
            end,
            -- -- NOTE: this will be called a lot so don't do any heavy processing here
            -- custom_filter = function(buf_number)
            --   -- filter out filetypes you don't want to see
            --   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
            --     return true
            --   end
            --   -- filter out by buffer name
            --   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
            --     return true
            --   end
            --   -- filter out based on arbitrary rules
            --   -- e.g. filter out vim wiki buffer from tabline in your work repo
            --   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
            --     return true
            --   end
            -- end,
            show_buffer_close_icons = false,
            show_close_icon = false,
            show_tab_indicators = true,
            persist_buffer_sort = true,
            always_show_bufferline = true,
            offsets = {{filetype = "NvimTree", text = "File Explorer", highlight = "Directory"}}
          }
        }

        wkmap({
          ['<Tab>'] = {'<cmd>BufferLineCycleNext<CR>', 'Cycle Buffer'},
          ['<S-Tab>'] = {'<cmd>BufferLineCyclePrev<CR>', 'Cycle Back Buffer'},
          ['g.'] = {'<cmd>BufferLineMoveNext<CR>', 'Move Buffer Next in Line'},
          ['g,'] = {'<cmd>BufferLineMovePrev<CR>', 'Move Buffer Back in Line'},
          gb = {'<cmd>BufferLinePick<CR>', 'Buffer Pick'},
          ['<leader>bs'] = {'<cmd>BufferLineSortByDirectory<CR>', 'Sort Buffer in Line'},
        },{
          noremap = true,
          silent = true
        })

        -- Add CWD to buffferline
        vim.o.tabline = "%!v:lua.nvim_bufferline() . ' ' . fnamemodify(getcwd(),':~')"
      end,
    }
  -- }}}
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
        wkmap({['<leader>fc'] = {'<cmd>Cheat<CR>', 'Find Cheat in cheat.sh'}})
      end,
    }
  -- }}}
  -- Colorscheme {{{
    packer.use {
      "chrisbra/Colorizer",
      config = function ()
        wkmap({['<leader>oc'] = {'<cmd>ColorToggle<CR>', 'Toggle Colors showing'}})
      end,
    }
    packer.use {
      'joshdick/onedark.vim',
      as = 'onedark',
      opt = true,
      setup = function ()
        vim.api.nvim_exec([[
          " Mark 80-th character
          hi! OverLength ctermbg=168 guibg=${color_14} ctermfg=250 guifg=${color_0}
          call matchadd('OverLength', '\%81v', 100)

          " Change cursor color to make it more visible
          hi! Cursor ctermbg=140 guibg=${color_5}
          hi! Search ctermfg=236 ctermbg=74 guifg=${color_0} guibg=${color_4}
          hi! AutoHiWord cterm=bold ctermbg=red guibg=${color_0}
        ]] % colors, true)
      end,
    }
    vim.cmd [[ packadd onedark ]]
    vim.cmd [[ colorscheme onedark ]]
  -- }}}
  -- Telescope {{{
    packer.use {
      'nvim-telescope/telescope.nvim',
      requires = {
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'},
        {'nvim-telescope/telescope-fzy-native.nvim'},
      },
      config = function()

        _G.telescope_buffers = function()
          local actions = require('telescope.actions')
          local action_set = require('telescope.actions.set')
          local action_state = require('telescope.actions.state')
          require('telescope.builtin').buffers({
            attach_mappings = function()
              action_set.select:replace(function(prompt_bufnr, _)
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("bdelete " .. tostring(entry['bufnr']))
              end)
              return true
            end,
          })
        end

        wkmap({
          ['<leader>'] = {
            f = {
              f = {'<cmd>Telescope live_grep<CR>', 'Find in Files'},
              o = {'<cmd>Telescope find_files<CR>', 'Find File'}
            },
            o = {
              o = {'<cmd>Telescope vim_options<CR>', 'Open options'},
              h = {'<cmd>Telescope help_tags<CR>', 'Open Help'},
              s = {
                name = '+Set',
                a = {'<cmd>Telescope autocommands<CR>', 'Autocommands'},
                c = {'<cmd>Telescope commands<CR>', 'Commands'},
                f = {'<cmd>Telescope filetypes<CR>', 'Filetypes'},
                i = {'<cmd>Telescope highlights<CR>', 'Highlights'},
                k = {'<cmd>Telescope keymaps<CR>', 'Keymaps'},
                s = {'<cmd>Telescope colorscheme<CR>', 'Colorschemes'},
              }
            },
            mm = {'<cmd>Telescope marks<CR>', 'Show Marks'},
            bb = {'<cmd>Telescope buffers<CR>', 'Show buffers'},
            bd = {function() telescope_buffers() end, 'Delete Buffer'}
          }
        },{
          noremap = true,
          silent = true
        })

        local actions = require('telescope.actions')
        require('telescope').setup{
          defaults = {
            file_ignore_patterns = {},
            width = 0.75,
            prompt_position = "top",
            sorting_strategy = "ascending",
            set_env = { ['COLORTERM'] = 'truecolor' },
            -- file_sorter =  require'telescope.sorters'.get_fzy_sorter,
            -- generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
            mappings = {
              i = {
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous,

                ["<C-s>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,

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
        require('telescope').load_extension('fzy_native')

      end,
    }
    packer.use {
      'junegunn/fzf.vim',
      requires = { 'junegunn/fzf', as = 'fzf' },
      as = 'fzf.vim',
      config = function()

        wkmap({['<leader>ghf'] = {'<cmd>BCommits<CR>', 'File History'}},{noremap=true})

    --     vim.g.fzf_tags_command = 'ctags -R --exclude=.git --exclude=.idea --exclude=log'
        local fzf_action = {}
    --     -- vim.g.fzf_action['ctrl-q'] = 'tab split'
        fzf_action['ctrl-t'] = 'tab split'
        fzf_action['ctrl-s'] = 'split'
        fzf_action['ctrl-v'] = 'vsplit'
        vim.g.fzf_action = fzf_action

        vim.env.FZF_DEFAULT_OPTS = '--bind=ctrl-a:toggle-all,ctrl-space:toggle+down,ctrl-alt-a:deselect-all'
        vim.env.FZF_DEFAULT_COMMAND = 'rg --iglob !.git --files --hidden --ignore-vcs --ignore-file ~/.config/git/gitexcludes'

    --     vim.cmd [[tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"]]
    --     vim.cmd([[ command! -bang -nargs=* Rg ]]..
    --     [[ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),]]..
    --     [[ 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)]])
      end,
    }
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
          exclude_filetypes = {'help','dashboard','dashpreview','nerdtree','vista','sagahover','which_key', 'nvimtree'};
          even_colors = { fg ='#AAAAAA',bg=colors.color_10 };
          odd_colors = {fg='#AAAAAA',bg=colors.color_10};
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
          base00 = colors.color_0,
          base08 = colors.color_1,
          base0B = colors.color_2,
          base0A = colors.color_3,
          base0D = colors.color_4,
          base0E = colors.color_5,
          base0C = colors.color_6,
          base05 = colors.color_7,
          base03 = colors.color_8,
          base09 = colors.color_9,
          base01 = colors.color_10,
          base02 = colors.color_11,
          base04 = colors.color_12,
          base06 = colors.color_13,
          base0F = colors.color_14,
          base07 = colors.color_15,
        }

        icons['man'] = {colors.base0C, ''}

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
              highlight = {colors.base00, colors.base0C, 'bold'},
            }
          },
          {
            BlankSpace0 = {
              provider = function() return '' end,
              highlight = {colors.base0C, colors.base09}
            }
          },
          {
            GitIcon = {
              provider = function() return '   ' end,
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.base00, colors.base09}
            }
          },
          {
            GitBranch = {
              provider = 'GitBranch',
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.base00, colors.base09}
            }
          },
          {
            BlankSpace1 = {
              provider = function() return ' ' end,
              highlight = {colors.base09, colors.base01}
            }
          },
          {
            BlankSpace2 = {
              provider = function() return ' ' end,
              highlight = {colors.base01, colors.base01}
            }
          },
          {
            DiffAdd = {
              provider = 'DiffAdd',
              icon = '+',
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.base0B, colors.base01}
            }
          },
          {
            DiffModified = {
              provider = 'DiffModified',
              icon = '~',
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.base0A, colors.base01}
            }
          },
          {
            DiffRemove = {
              provider = 'DiffRemove',
              icon = '-',
              condition = function() return condition.check_git_workspace() and condition.checkwidth() end,
              highlight = {colors.base08, colors.base01}
            }
          },
          {
            BlankSpace3 = {
              provider = function() return ' ' end,
              highlight = {colors.base01, colors.base01}
            }
          },
          {
            FileIcon = {
              provider = fileinfo.get_file_icon,
              condition = condition.buffer_not_empty,
              highlight = {
                fileinfo.get_file_icon_color,
                colors.base01
              },
            },
          },
          {
            FileName = {
              provider = function()
                return string.format('%s| %s ',
                fileinfo.get_file_size(),
                fileinfo.get_current_file_name()
                )
              end,
              condition = condition.buffer_not_empty,
              highlight = {colors.base0C, colors.base01}
            }
          },
          {
            Blank = {
              provider = function() return '' end,
              highlight = {colors.base01, colors.base01}
            }
          }
        }

        gls.right = {
          {
            DiagnosticError = {
              provider = 'DiagnosticError',
              icon = '  ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.base08, colors.base01}
            },
          },
          {
            DiagnosticWarn = {
              provider = 'DiagnosticWarn',
              icon = '  ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.base0A, colors.base01}
            },
          },
          {
            DiagnosticHint = {
              provider = 'DiagnosticHint',
              icon = '  ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.base0B, colors.base01}
            }
          },
          {
            DiagnosticInfo = {
              provider = 'DiagnosticInfo',
              icon = '  ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.base0B, colors.base01}
            }
          },
          {
            LspStatus = {
              provider = function() return string.format(' %s ', lspclient.get_lsp_client()) end,
              icon = '   ',
              condition = function() return condition.check_active_lsp() and condition.checkwidth() end,
              highlight = {colors.base05, colors.base01}
            }
          },
          {
            FileType = {
              provider = function() return string.format(' %s ', buffer.get_buffer_filetype()) end,
              condition = function() return buffer.get_buffer_filetype() ~= '' end,
              highlight = {colors.base05, colors.base01}
            }
          },
          {
            BlankSpace4 = {
              provider = function() return '' end,
              highlight = {colors.base0B, colors.base01}
            }
          },
          {
            FileFormat = {
              provider = function() return string.format('   %s ', fileinfo.get_file_format()) end,
              condition = condition.checkwidth,
              highlight = {colors.base00, colors.base0B}
            }
          },
          {
            BlankSpace5 = {
              provider = function() return '' end,
              highlight = {colors.base09, colors.base0B}
            }
          },
          {
            FileEncode = {
              provider = function() return string.format('   %s ', fileinfo.get_file_encode()) end,
              condition = condition.checkwidth,
              highlight = {colors.base00, colors.base09}
            }
          },
          {
            BlankSpace6 = {
              provider = function() return '' end,
              highlight = {colors.base0C, colors.base09}
            }
          },
          {
            LineInfo = {
              provider = function() return string.format(' %s %s ', fileinfo.current_line_percent(),fileinfo.line_column()) end,
              highlight = {colors.base00, colors.base0C}
            }
          },
        }

        gl.short_line_list = {'nerdtree','vista','nvimtree'}
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
              highlight = {colors.base05, colors.base01}
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
              highlight = {colors.base05, colors.base01}
            }
          },
          {
            BufferName = {
              provider = function()
                if vim.fn.index(gl.short_line_list, vim.bo.filetype) ~= -1 then
                  local filetype = vim.bo.filetype
                  if filetype == 'nvimtree' then
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
              highlight = {colors.base05, colors.base01}
            }
          },
          {
            BlankShort = {
              provider = function() return '' end,
              highlight = {colors.base01, colors.base01},
            }
          }
        }
      end,
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
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

        wkmap({['<leader>mc'] = {[[:call signature#mark#Purge('all')|wshada!<CR>]], 'Clear All'}})

      end,
    }
  -- }}}
  -- NvimTree {{{
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
        vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
        vim.g.nvim_tree_quit_on_open = 1
        vim.g.nvim_tree_lsp_diagnostics = 1
        vim.g.nvim_tree_highlight_opened_files = 1

        wkmap({
          ['<leader>'] = {
            oe = {'<cmd>NvimTreeToggle<CR>', 'Open Explorer'},
            fp = {'<cmd>NvimTreeFindFile<CR>', 'Find file in Path'}
          }
        },{
          noremap = true,
          silent = true
        })

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
          ["r"]              = tree_cb("refresh"),
          ["R"]              = tree_cb("refresh"),
          ["a"]              = tree_cb("create"),
          ["d"]              = tree_cb("remove"),
          ["m"]              = tree_cb("rename"),
          ["M"]          = tree_cb("full_rename"),
          ["x"]              = tree_cb("cut"),
          ["c"]              = tree_cb("copy"),
          ["p"]              = tree_cb("paste"),
          ["[g"]             = tree_cb("prev_git_item"),
          ["]g"]             = tree_cb("next_git_item"),
          ["u"]              = tree_cb("dir_up"),
          ["q"]              = tree_cb("close"),
        }

        vim.g.nvim_tree_icons = {
          default = '',
          symlink = '',
        }

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

        wkmap({
          ['<leader>or'] = {'<cmd>call RooterWithCWD()<CR>', 'Open RootDir'}
        },{
          noremap = true,
          silent = true
        })

        vim.api.nvim_exec([[
          function! RooterWithCWD()
            Rooter
            "NERDTreeCWD
            NvimTreeClose
            NvimTreeOpen
          endfunction
        ]], true)
      end,
    }
  -- }}}
  -- StartScreen and Sessions {{{
    packer.use {
      'mhinz/vim-startify',
      config = function()
        vim.g.startify_session_before_save = {
          'silent! tabdo NERDTreeClose',
          'silent! tabdo NvimTreeClose',
          'silent! tabdo Vista!',
          'silent! lclose',
          'silent! cclose',
        }

        vim.g.startify_session_autoload = 1
        vim.g.startify_session_persistence = 1
        vim.g.startify_change_to_dir = 1

        local startify_lists = {
          -- { type = 'files',     header = {'   MRU'}            },
          { type = 'sessions',  header = {'   Sessions'}       },
          { type = 'dir',       header = {'   MRU '.. vim.fn.getcwd()} },
          { type = 'bookmarks', header = {'   Bookmarks'}      },
          { type = 'commands',  header = {'   Commands'}       },
        }
        vim.g.startify_lists = startify_lists

        -- vim.g.startify_custom_header = {
        --   [[                    | |  ( )                (_)]],
        --   [[   _____      _____ | | _|/ ___   _ ____   ___ _ __ ___]],
        --   [[  / _ \ \ /\ / / _ \| |/ / / __| | '_ \ \ / / | '_ ` _ \]],
        --   [[ |  __/\ V  V / (_) |   <  \__ \ | | | \ V /| | | | | | |]],
        --   [[  \___| \_/\_/ \___/|_|\_\ |___/ |_| |_|\_/ |_|_| |_| |_|]],
        -- }

        wkmap({
          ['<leader>s'] = {
            name = '+Session',
            o = {'<cmd>SLoad<CR>', 'Load'},
            u = {'<cmd>SLoad ' .. vim.g.current_session_name .. '<CR>', 'Load Current'},
            s = {':SSave ' .. vim.g.current_session_name, 'Save'},
            c = {'<cmd>SClose<CR>', 'Close'},
            q = {'<cmd>SClose<CR>:q<CR>', 'Save and Quit'},
            d = {'<cmd>SDelete<CR>', 'Delete'}
          }
        },{
          silent = false
        })

      end,
    }

    vim.api.nvim_exec([[
      let g:current_session_name = fnamemodify(getcwd(), ':~:s?\~/??:gs?/?_?')
      command! LoadSessionCurrent :call startify#session_load(0, g:current_session_name)
    ]], false)
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

    map('i', '<F7>', '<ESC>:lua toggle_spell()<CR>a', { silent = true })
    -- Keys
    wkmap({
      ['<F7>'] = {function() toggle_spell() end, 'Toggle Spelling'},
      ['<leader>'] = {
        t = {
          name = '+Text',
          t = {'<cmd>Goyo<CR>', 'Goyo'},
          s = {function() toggle_spell() end, 'Toggle Spelling'},
          f = {
            name = '+Fix'
          }
        }
      }
    },{
      noremap = true,
      silent = true
    })
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
        bmap('n', '<leader>rRQ', ':call CloseRunner()<CR>', {})
        bmap('n', '<leader>rRX', ':VimuxInterruptRunner<CR>', {})
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

    end
  -- }}}
  -- Undo {{{
    packer.use {
      'mbbill/undotree',
    }

    wkmap({['<leader>u'] = {'<cmd>UndotreeToggle<CR>', 'Undo Tree'}})

  -- }}}
  -- Xkb {{{
    packer.use {
      'lyokha/vim-xkbswitch',
      config = function ()
        vim.g.XkbSwitchEnabled = 1
        vim.g.XkbSwitchSkipFt = { 'nerdtree', 'coc-explorer', 'nvimtree' }
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

    wkmap({['<leader>Z'] = {function() zoom_toggle() end, 'Toggle Zoom'}})

    _G.zoom_toggle = function()

      local zoom_nerd = false
      local zoom_ntree = false
      local zoom_tag = false

      if vim.t.NERDTreeBufName and fn.bufwinnr(vim.t.NERDTreeBufName) ~= -1 then
        cmd 'NERDTreeClose'
        zoom_nerd = true
      end

      if fn.bufwinnr('NvimTree') ~= -1 then
        cmd 'NvimTreeClose'
        zoom_ntree = true
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

      if zoom_ntree then
        cmd 'NvimTreeOpen'
        execute ':wincmd p'
      end

      if zoom_tag then
        cmd 'Vista'
        execute ':wincmd p'
      end

    end
  -- }}}
  -- VimWiki {{{
    packer.use {
      'vimwiki/vimwiki',
      branch = 'dev',
      requires = {
        { 'michal-h21/vim-zettel' },
        { 'ewok/vimwiki-sync' },
        { 'fzf.vim' },
        { 'fzf' },
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
        vim.g.vimwiki_emoji_enable = 1

        vim.g.vimwiki_key_mappings =
        {
          global = 0,
          links = 0
        }
      end,
      config = function()
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

        wkmap({
          ['<leader>w'] = {
            name = '+Wiki',
            w = {'<cmd>silent call VimwikiIndexCd()<CR>', 'Index'},
            i = {'<cmd>VimwikiDiaryIndex<CR>', 'Diary'},
            t = {'<cmd>call VimwikiMakeDiaryNoteNew()<CR>', 'Today'}
          }
        },{
          noremap = true
        })

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
      requires = {{'fzf'}},
      config = function ()

        wkmap({
          ['<leader>'] = {
            ov = {'<cmd>Vista<CR>', 'Open Vista'},
            ft = {'<cmd>Vista finder<CR>', 'Find Tag in Vista'}
          }
        })

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
      'yaml.ansible', 'dockerfile', 'python', 'terraform',
      'hcl'},
      as = 'ale',
      cmd = 'ALEEnable',
      opt = true,
      setup = function ()
        vim.g.ale_sign_error = '!!'
        vim.g.ale_sign_warning = '..'
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
        { 'rafamadriz/friendly-snippets', },
        { 'hrsh7th/vim-vsnip', },
        { 'norcalli/snippets.nvim',
        config=function()
          local U = require'snippets.utils'
          _G.sep = function () return string.gsub(vim.bo.commentstring, "%%s", "") end
          require'snippets'.snippets = {
            _global = {
              ["date_ymd"]   = "${=os.date('%Y-%m-%d')}",
              ["date_ymdHM"]   = "${=os.date('%Y-%m-%d %H-%M')}",
              ["date_ymdHMS"]   = "${=os.date('%Y-%m-%d %H-%M-%S')}",

              ["todo"] = U.match_indentation (
              "${=sep()} TODO(${=io.popen('id -un'):read'*l'}): $0\n"..
              "${=sep()} ${=vim.fn.expand('%:h')}/${=vim.fn.expand('%:t')}:${=tostring(vim.fn.line('.'))}"),

            };
            vimwiki = {
              code  = "```\n$0\n```",
              code_shell = "```sh\n$0\n```",
              code_python = "```python\n$0\n```",
            };
          }
        end,},
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

        _G.tab_complete = function(a_key)
          local key = a_key or "<Tab>"
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
        _G.s_tab_complete = function(a_key)
          local key = a_key or "<S-Tab>"
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

        map("i", "<C-n>", "v:lua.tab_complete('<C-n>')", {expr = true})
        map("s", "<C-n>", "v:lua.tab_complete('<C-n>')", {expr = true})
        map("i", "<C-p>", "v:lua.s_tab_complete('<C-p>')", {expr = true})
        map("s", "<C-p>", "v:lua.s_tab_complete('<C-p>')", {expr = true})

        map("i", "<C-y>", [[pumvisible() ? "\<C-y>\<C-y>"  : "\<C-y>"]], {expr = true, noremap = true})
        map("s", "<C-y>", [[pumvisible() ? "\<C-y>\<C-y>"  : "\<C-y>"]], {expr = true, noremap = true})

        map("i", "<C-e>", [[pumvisible() ? "\<C-y>\<C-e>"  : "\<Esc>a\<C-e>"]], {expr = true, noremap = true})
        map("s", "<C-e>", [[pumvisible() ? "\<C-y>\<C-e>"  : "\<Esc>a\<C-e>"]], {expr = true, noremap = true})

        map("i", "<C-Space>", "compe#complete()", {expr = true})
        map("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
        map("i", "<C-j>", "compe#confirm('<C-j>')", {expr = true})

        -- map("i", "<C-e>", "compe#close('<C-e>')", {expr = true})
        -- map("i", "<C-e>", "compe#close('<C-e>')", {expr = true})

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
          wkmap({
            gk = {function() require('lspsaga.signaturehelp').signature_help() end, 'Signature Help[lspsaga]'}
          })
        end, }
      },
      as = 'lspconfig',
      config = function()
        -- Turn on snippets
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        local function common_on_attach(client, bufnr)

          if client.resolved_capabilities.document_highlight then
            vim.api.nvim_exec([[
              hi LspReferenceRead cterm=bold ctermbg=red guibg=${color_12}
              hi LspReferenceText cterm=bold ctermbg=red guibg=${color_12}
              hi LspReferenceWrite cterm=bold ctermbg=red guibg=${color_12}
            ]] % colors, false)
            local lsp_document_highlight = {
              {'CursorHold <buffer> lua vim.lsp.buf.document_highlight()'};
              {'CursorMoved <buffer> lua vim.lsp.buf.clear_references()'};
            }
            augroups_buff({lsp_document_highlight=lsp_document_highlight})
          end

          wkmap({
            ['[d'] = {function() vim.lsp.diagnostic.goto_prev() end, 'Previous Diagnostic Record'},
            [']d'] = {function() vim.lsp.diagnostic.goto_next() end, 'Next Diagnostic Record'},
            g = {
              d = {function() vim.lsp.buf.definition() end, 'Goto Definition'},
              D = {function() vim.lsp.buf.declaration() end, 'Goto Declaration'},
              r = {function() vim.lsp.buf.references() end, 'Goto References'},
              i = {function() vim.lsp.buf.implementation() end, 'Goto Implementation'},
              T = {function() vim.lsp.buf.type_definition() end, 'Goto Type Definition'}
            },
            ['<leader>W'] = {
              name = '+Workspace',
              a = {function() vim.lsp.buf.add_workspace_folder() end, 'Add Workspace'},
              r = {function() vim.lsp.buf.remove_workspace_folder() end, 'Remove Workspace'},
              l = {function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'List Workspaces'},
            },
            ['<leader>c'] = {
              c = {function() vim.lsp.buf.code_action() end, 'Code Action'},
              d = {function() vim.lsp.diagnostic.show_line_diagnostics() end, 'Show Diagnostics'},
              D = {function() vim.lsp.diagnostic.set_loclist() end, 'Show Diagnostics in LocList'},
              r = {function() vim.lsp.buf.rename() end, 'Rename'},
            }
          },{
            silent = true,
            noremap = true,
            buffer = bufnr
          })

          if client.resolved_capabilities.document_formatting then
            wkmap({['<leader>cf'] = {function() vim.lsp.buf.formatting() end, 'Formatting'}})
          end

        end

        require'lspconfig'.dockerls.setup{
          capabilities = capabilities,
          on_attach = common_on_attach,
          root_dir = function(fname)
            return require'lspconfig'.util.find_git_ancestor(fname) or require'lspconfig'.util.path.dirname(fname)
          end;
        }
        require'lspconfig'.bashls.setup{
          capabilities = capabilities,
          on_attach = common_on_attach,
          autostart = false,
          root_dir = function(fname)
            return require'lspconfig'.util.find_git_ancestor(fname) or require'lspconfig'.util.path.dirname(fname)
          end;
        }
        require'lspconfig'.rust_analyzer.setup{
          capabilities = capabilities,
          on_attach = common_on_attach,
          autostart = false,
        }
        require'lspconfig'.pyright.setup{
          capabilities = capabilities,
          on_attach = common_on_attach,
          autostart = false,
        }
        require'lspconfig'.jsonls.setup{
          capabilities = capabilities,
          on_attach = common_on_attach,
          autostart = false,
          root_dir = function(fname)
            return require'lspconfig'.util.find_git_ancestor(fname) or require'lspconfig'.util.path.dirname(fname)
          end;
        }
        require'lspconfig'.yamlls.setup{
          capabilities = capabilities,
          on_attach = common_on_attach,
          filetypes = { "yaml", "yaml.ansible", "helm"},
          autostart = false,
          root_dir = function(fname)
            return require'lspconfig'.util.find_git_ancestor(fname) or require'lspconfig'.util.path.dirname(fname)
          end;
        }
        require'lspconfig'.sumneko_lua.setup{
          capabilities = capabilities,
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
          capabilities = capabilities,
          on_attach = common_on_attach,
          autostart = false,
        }
        require'lspconfig'.gopls.setup{
          capabilities = capabilities,
          on_attach = common_on_attach,
          autostart = false,
          cmd = {"gopls", "serve"},
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            }
          }
        }
        require'lspconfig'.terraformls.setup{
          capabilities = capabilities,
          on_attach = common_on_attach,
          autostart = false,
        }
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
        wkmap({
          ga = {'<Plug>(LiveEasyAlign)', 'Align Block'}
        })
        wkmap({
          ga = {'<Plug>(LiveEasyAlign)', 'Align Block'}
        },{mode='x'})
      end,
    }
  -- }}}
  -- FAR {{{
    packer.use {
    'wincent/ferret',
    config = function()
      vim.g.FerretMap = 0
      wkmap({
        ['<leader>fr'] = {
          name = '+Replace',
          ['<space>'] = {'<Plug>(FerretAck)', 'Search'},
          ['<CR>'] = {'<Plug>(FerretAcks)', 'Replace'}
        }
      })
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
        _G.git_show_block_history = function()
          vim.cmd[[exe ":G log -L " . string(getpos("'<'")[1]) . "," . string(getpos("'>'")[1]) . ":%"]]
        end

        _G.git_show_line_history = function()
          vim.cmd[[exe ":G log -U1 -L " . string(getpos('.')[1]) . ",+1:%"]]
        end

        local au_git = {
          {[[FileType fugitive nnoremap <buffer> <silent> q :close<CR>]]};
          {[[FileType fugitiveblame nnoremap <buffer> <silent> q :close<CR>]]};
          {[[FileType git nnoremap <buffer> <silent> q :close<CR>]]};
        }
        augroups({au_git=au_git})

        wkmap({
          ['<leader>g'] = {
            name = '+Git',
            b = {'<cmd>Git blame<CR>', 'Blame'},
            d = {'<cmd>Gdiffsplit<CR>', 'Diff'},
            g =  {'<cmd>.GBrowse %<CR>', 'Browse'},
            h = {
              name = '+History/Hunk',
              l = {function() git_show_line_history() end, 'History Line'},
            },
            p = {
              name = '+Push/Pull',
              lm = {'<cmd>Git pull<CR>', 'Merge'},
              lr = {'<cmd>Git pull --rebase<CR>', 'Rebase'},
              s = {'<cmd>Git push<CR>', 'Push'},
            },
            R = {'<cmd>Gread<CR>', 'Read'},
            s = {'<cmd>Git<CR>', 'Status'},
            W = {'<cmd>Gwrite<CR>', 'Write'},
          }
        })

        wkmap({
          ['<leader>g'] = {
            name = '+Git',
            g =  {[[:'<,'>GBrowse %<CR>]], 'Browse'},
            h = {
              name = '+History/Hunk',
              v = {function() git_show_block_history() end, 'History Visual Block'},
            },
          }
        },{
          mode = 'x'
        })

      end,
    }
    -- Gitgutter
    packer.use {
      'airblade/vim-gitgutter',
      config = function()
        vim.g.gitgutter_map_keys = 0
        vim.g.gitgutter_override_sign_column_highlight = 0

        wkmap({
          [']g'] = {'<Plug>(GitGutterNextHunk)', 'Next Git Hunk'},
          ['[g'] = {'<Plug>(GitGutterPrevHunk)', 'Previous Git Hunk'},
          ['<leader>gh'] = {
            s = {'<cmd>GitGutterStageHunk<CR>', 'Hunk Stage'},
            r = {'<cmd>GitGutterUndoHunk<CR>', 'Hunk Revert'},
            p = {'<cmd>GitGutterPreviewHunk<CR>', 'Hunk Preview'},
          }
        })

      end,
    }
    -- Gitv
    packer.use {
      'junegunn/gv.vim',
      config = function()
        vim.g.Gitv_DoNotMapCtrlKey = 1
        wkmap({
          ['<leader>ghh'] = {'<cmd>GV<CR>', 'History All'}
        })
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
      setup = function ()
        vim.g.splitjoin_split_mapping = ''
        vim.g.splitjoin_join_mapping = ''
      end,
      config = function()
        wkmap({
          gs = {'<cmd>SplitjoinSplit<CR>', 'Magic Split'},
          gj = {'<cmd>SplitjoinJoin<CR>', 'Magic Join'}
        })
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

        wkmap({
          gzz = {'<Plug>Zeavim', 'Find in Zeal'},
          gZ = {'<Plug>ZVKeyDocset<CR>', 'Find Docset'},
          gz = {'<Plug>ZVOperator', 'Zeal in...'}
        })

        wkmap({
          gz = {'<Plug>ZVVisSelection', 'Find in Zeal'},
        },{
          mode = 'x'
        })

      end,
    }
  -- }}}
  -- Better Whitespace {{{
    packer.use {
      'ntpeters/vim-better-whitespace',
      config = function()
        vim.g.better_whitespace_filetypes_blacklist = { 'gitcommit', 'unite', 'qf', 'help', 'dotooagenda', 'dotoo' }
        wkmap({['<leader>tfw'] = {'<cmd>StripWhitespace<CR>', 'Strip Whitespaces'}})
      end,
    }
  -- }}}
  -- Codi {{{
    packer.use{
      'metakirby5/codi.vim',
      cmd = {'Codi'},
    }

    wkmap({
      ['<leader>c'] = {
        P = {'<cmd>Codi!! python<CR>', 'Codi Python'},
        L = {'<cmd>Codi!! lua<CR>', 'Codi LUA'},
      }
    })
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
        }
      },
    }
    _G.reg_dap_keys = function()
      wkmap({
        name = '+Debug',
        b = {function() require"dap".toggle_breakpoint() end, 'Toggle Breakpoint'},
        c = {function() require"dap".continue() end, 'Run/Continue'},
        n = {function() require"dap".step_over() end, 'Step Over'},
        i = {function() require"dap".step_into() end, 'Step Into'},
        o = {function() require"dap".step_out() end, 'Step Out'},
        S = {function() require"dap".stop() end, 'Stop'},
        r = {function() require"dap".repl.open() end, 'REPL'},
        B = {'<cmd>Telescope dap list_breakpoints<CR>', 'Breakpoints List'},
        v = {'<cmd>Telescope dap variables<CR>', 'Variables'},
      },{
        prefix = '<leader>d',
        silent = false,
        noremap = true,
        buffer = api.nvim_get_current_buf()
      })
    end
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
        vim.g.qs_buftype_blacklist = { 'terminal', 'nofile', 'nerdtree', 'nvimtree' }
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
      function! OpenToDo()
        silent! vsplit TODO.md
        nnoremap <buffer> q :x<CR>
        setf todo
      endfunction
    ]], true)

    wkmap({['<leader>ot'] = {'<cmd>call OpenToDo()<CR>', 'Open ToDO'}})
  -- }}}
  -- FoldText {{{
    vim.api.nvim_exec([[
      function! MyFoldText()
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
      endfunction
      set foldtext=MyFoldText()
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
            if vim.fn.mode() ~= 'i' then
              auto_save()
              auto_save_locked = false
              timer:stop()
              -- timer:close()
            end
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

    nnoremap <Plug>(qfix_LToggle) :call ToggleList("Location List", 'l')<CR>
    nnoremap <Plug>(qfix_LOpen) :lopen<CR>
    nnoremap <Plug>(qfix_LClose) :lclose<CR>
    nnoremap <Plug>(qfix_LNext) :lnext<CR>
    nnoremap <Plug>(qfix_LPrev) :lprev<CR>
  ]], true)

  wkmap({
    [']'] = {
      q = {'<Plug>(qfix_QNext)', 'Next QFix Item'},
      l = {'<Plug>(qfix_LNext)', 'Next Location Item'},
    },
    ['['] = {
      q = {'<Plug>(qfix_QPrev)', 'Previous QFix Item'},
      l = {'<Plug>(qfix_LPrev)', 'Previous Location Item'},
    },
    ['<leader>'] = {
      q = {
        name = '+QFix',
        q = {'<Plug>(qfix_Toggle)', 'Toggle'},
        o = {'<Plug>(qfix_Open)', 'Open'},
        c = {'<Plug>(qfix_Close)', 'Close'},
        n = {'<Plug>(qfix_QNext)', 'Next'},
        p = {'<Plug>(qfix_QPrev)', 'Previous'},
      },
      l = {
        name = '+Location',
        q = {'<Plug>(qfix_LToggle)', 'Toggle'},
        o = {'<Plug>(qfix_LOpen)', 'Open'},
        c = {'<Plug>(qfix_LClose)', 'Close'},
        n = {'<Plug>(qfix_LQNext)', 'Next'},
        p = {'<Plug>(qfix_LQPrev)', 'Previous'},
      }
    }
  })
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
      bmap('i', '<C-CR>', '<ESC>:lua smart_cr()<CR>', {noremap=true})
      bmap('i', ';;', '<ESC>:lua smart_cr()<CR>', {noremap=true})
      bmap('i', ';<CR>', '<ESC>A;<CR>', {noremap=true})
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

-- Load local config {{{
  vim.api.nvim_exec([[
  try
  source ~/.vimrc.local
  catch
  " Ignoring
  endtry
  ]], true)
-- }}}
