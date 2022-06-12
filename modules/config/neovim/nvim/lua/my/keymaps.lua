local v = require'my.v'

table.insert(pkgs, "christoomey/vim-tmux-navigator")

local status_ok, wk = pcall(require, "my.wk")
if not status_ok or not wk then
  print("my-wk is not loaded.")
  return false
end

local wkmap = wk.map

vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- vim.g.maplocalleader = '\\'

wkmap({
  -- Go back and forward
  -- Go B and F
  ['<C-O>'] = {
    ['<C-O>'] = {'<C-O>', 'Go Back'},
    ['<C-I>'] = {'<Tab>', 'Go Forward'},
  },
  -- Windows
  ['<C-W>'] = {

    -- Tabs
    t = {'<cmd>tabnew<CR>', 'New Tab'},

    -- Terminal
    S = v.fn.exists('$TMUX') == 1
    and {'<cmd>!tmux split-window -v -p 20<CR><CR>', 'Split window[tmux]'}
    or {'<cmd>split term://bash<CR>i', 'Split window[terminal]'},
    V = v.fn.exists('$TMUX') == 1
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

  ['<leader>'] = {

    -- Menu
    c = {name = '+Code'},
    f = {name = '+Find'},
    g = {name = "+Git"},
    t = {name = "+Text/Toggle"},

    -- Yank
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
      C = {function()
        require'packer'.clean()
        print("Packer: clean - finished")
      end, 'Clean'},
      c = {function()
        require'packer'.compile()
        print("Packer: compile - finished")
      end, 'Compile'},
      i = {function()
        require'packer'.install()
        print("Packer: install: - finished")
      end, 'Install'},
      u = {function()
        require'packer'.sync()
        print("Packer: install: - finished")
      end, 'Update/Sync'},
      s = {function()
        require'packer'.status()
      end, 'Status'},
    },

    o = {
      name = '+Open/+Options',
      p = {
        name = '+Profiling',
        s = {'<cmd>profile start /tmp/profile_vim.log|profile func *|profile file *<CR>', 'Start'},
        t = {'<cmd>profile stop|e /tmp/profile_vim.log|nmap <buffer> q :!rm /tmp/profile_vim.log<CR>', 'Stop'}
      }
    }
  }
},{
  noremap = true,
  silent = false,
})

wkmap({
  -- Folding{{{
  ['<Space><Space>'] = {'zf"}}}"', 'Toggle Fold'},--}}}

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
v.exec([[
nmap <expr>  MR  ':%s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
vmap <expr>  MR  ':s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
]], true)

-- Replace without yanking
v.map('v', 'p', ':<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>', { noremap = true })

-- Tunings
v.map('n', 'Y', 'y$', { noremap = true })

-- Don't cancel visual select when shifting
v.map('x', '<', '<gv', { noremap = true })
v.map('x', '>', '>gv', { noremap = true })

-- Keep the cursor in place while joining lines
v.map('n', 'J', 'mzJ`z', { noremap = true })

-- [S]plit line (sister to [J]oin lines) S is covered by cc.
v.map('n', 'S', 'mzi<CR><ESC>`z', { noremap = true })

-- Don't move cursor when searching via *
v.map('n', '*', ':let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<CR>', { noremap = true, silent = true })

-- Keep search matches in the middle of the window.
v.map('n', 'n', 'nzzzv', { noremap = true })
v.map('n', 'N', 'Nzzzv', { noremap = true })

-- -- Jumplist updates
-- map('n', 'k', [[(v:count > 5 ? "m'" . v:count : "") . 'k']], {noremap = true, expr = true})
-- map('n', 'j', [[(v:count > 5 ? "m'" . v:count : "") . 'j']], {noremap = true, expr = true})

v.map("n", "<esc><esc>", "<cmd>nohlsearch<cr>", { noremap = true })

v.map("n", "Q", "<cmd>Bdelete!<CR>", { noremap = true })

v.map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { noremap = true })

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
v.map('n', 'H', ':lua start_line()<CR>', { noremap = true, silent = true })
v.map('n', 'L', '$', { noremap = true })
v.map('v', 'H', [[:lua start_line('v')<CR>]], { noremap = true, silent = true })
v.map('v', 'L', '$', { noremap = true })

-- Terminal
vim.cmd [[tnoremap <Esc> <C-\><C-n>]]

-- Change '<CR>' to whatever shortcut you like :)
-- vim.api.nvim_set_keymap("n", "<CR>", "<cmd>NeoZoomToggle<CR>", { noremap = true, silent = true, nowait = true })
-- vim.api.nvim_set_keymap(
--   "n",
--   "=",
--   "<cmd>JABSOpen<cr>",
--   { noremap = true, silent = true, nowait = true }
-- )

-- Tmux Navigator
vim.g.tmux_navigator_save_on_switch = 2
vim.g.tmux_navigator_disable_when_zoomed = 1
