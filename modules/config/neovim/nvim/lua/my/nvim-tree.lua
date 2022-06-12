local vars = require'my.vars'
local colors = require'my.colors'
local wkmap = require'my.wk'.map

table.insert(pkgs, {'kyazdani42/nvim-tree.lua', requires = {{'kyazdani42/nvim-web-devicons'}}})

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  print("Nvim-tree is not loaded.")
  return
end

-- local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
-- if not config_status_ok then
--   print("Nvim-tree.config is not loaded.")
--   return
-- end

nvim_tree.setup {
  disable_netrw      = false,
  hijack_netrw       = false,
  open_on_setup      = false,
  ignore_ft_on_setup = vars.blacklist_filetypes,

  open_on_tab        = false,
  hijack_cursor      = false,

  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },

  update_focused_file = {
    enable = true,
    ignore_list =vars.blacklist_bufftypes,
  },
  system_open = {
    cmd  = nil,
    args = {}
  },

  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },

  view = {
    width = 40,
    height = 30,
    hide_root_folder = false,
    side = "left",

    mappings = {
      custom_only = true,
      list = {
        { key = { "<CR>" },   action = "edit" },
        { key = { "o" },      action = "edit" },
        { key = { "l" },      action = "edit" },
        { key = { "<C-]>" },  action = "cd" },
        { key = { "C" },      action = "cd" },
        { key = { "v" },      action = "vsplit" },
        { key = { "s" },      action = "split" },
        { key = { "t" },      action = "tabnew" },
        { key = { "h" },      action = "close_node" },
        { key = { "<Tab>" },  action = "preview" },
        { key = { "I" },      action = "toggle_ignored" },
        { key = { "H" },      action = "toggle_dotfiles" },
        { key = { "r" },      action = "refresh" },
        { key = { "R" },      action = "refresh" },
        { key = { "a" },      action = "create" },
        { key = { "d" },      action = "remove" },
        { key = { "m" },      action = "rename" },
        { key = { "M" },      action = "full_rename" },
        { key = { "x" },      action = "cut" },
        { key = { "c" },      action = "copy" },
        { key = { "p" },      action = "paste" },
        { key = { "[g" },     action = "prev_git_item" },
        { key = { "]g" },     action = "next_git_item" },
        { key = { "u" },      action = "dir_up" },
        { key = { "q" },      action = "close" },
      },
    },
    number = false,
    relativenumber = false,
  },
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false
      }
    },
    change_dir = {
      enable = true,
      global = true
    }
  },
  renderer = {
    group_empty = true,
    highlight_opened_files = "all",
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      }
    }
  },
}

vim.api.nvim_exec([[
hi NvimTreeCursorLine cterm=bold ctermbg=white guifg=${color_2}
]] % colors, false)

wkmap({
  ['<leader>oe'] = {function() require'nvim-tree'.toggle() end, 'Open Explorer'},
  ['<leader>fp'] = {function()
    require'nvim-tree'.find_file(true)
    if not require'nvim-tree.view'.is_visible() then
      require'nvim-tree'.open()
    end
  end, 'Find file in Path'}
},{
    noremap = true,
    silent = true
  })
