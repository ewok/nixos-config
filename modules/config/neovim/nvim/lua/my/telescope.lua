local wkmap = require'my.wk'.map

table.insert(pkgs, "nvim-telescope/telescope.nvim")

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  print("Telescope is not loaded.")
  return
end

local actions = require "telescope.actions"
local icons = require("my.icons")

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--ignore',
      '--iglob',
      '!.git',
      '--ignore-vcs',
      '--ignore-file',
      '~/.config/git/gitexcludes',
    },
    file_ignore_patterns = {},
    layout_config = {
      width = 0.95,
      height = 0.95,
    },
    sorting_strategy = "descending",
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = icons.ui.Telescope .. " ",
    selection_caret = " ",
    -- path_display = { "smart" },

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,
        ["<CR>"] = actions.select_default,

        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ['<c-d>'] = require('telescope.actions').delete_buffer,

        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-Space>"] = actions.toggle_selection + actions.move_selection_next,
        ["<C-l>"] = actions.complete_tag,
        ["<esc>"] = actions.close,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["?"] = actions.which_key,
      },
    },
  },
}

wkmap({
  ['<leader>'] = {
    f = {
      c = {'<cmd>Telescope commands<CR>', 'Commands'},
      f = {'<cmd>Telescope live_grep<CR>', 'Find in Files'},
      ['/'] = {'<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Find in buffer'},
      ['.'] = {'<cmd>Telescope resume<CR>', 'Resume finding'},
      o = {
        function ()
          local find_command={
            'rg',
            '--ignore',
            '--hidden',
            '--files',
            '--iglob',
            '!.git',
            '--ignore-vcs',
            '--ignore-file',
            '~/.config/git/gitexcludes',
          }
          require('telescope.builtin').find_files({find_command=find_command})
        end,
        'Find File'},
        -- o = {'<cmd>Telescope find_files<CR>', 'Find File'},
        b = {'<cmd>Telescope buffers<CR>', 'Find Buffers'},
        m = {'<cmd>Telescope marks<CR>', 'Find Marks'},
      },
      g = {
        l = {
          f = {'<cmd>BCommits<CR>', 'File History'},
          l = {'<cmd>Commits<CR>', 'History'}
        }
      },
      o = {
        o = {'<cmd>Telescope vim_options<CR>', 'Open options'},
        h = {'<cmd>Telescope help_tags<CR>', 'Open Help'},
        s = {
          name = '+Set',
          a = {'<cmd>Telescope autocommands<CR>', 'Autocommands'},
          f = {'<cmd>Telescope filetypes<CR>', 'Filetypes'},
          i = {'<cmd>Telescope highlights<CR>', 'Highlights'},
          k = {'<cmd>Telescope keymaps<CR>', 'Keymaps'},
          s = {'<cmd>Telescope colorscheme<CR>', 'Colorschemes'},
        }
      },
    }
  },{
    noremap = true,
    silent = true
  })
