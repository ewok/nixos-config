local wkmap = require'my.wk'.map

table.insert(pkgs, "lewis6991/gitsigns.nvim")

local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  print("Gitsigns is not loaded.")
  return
end

gitsigns.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
}

wkmap({
  [']g'] = {'<cmd>lua require"gitsigns.actions".next_hunk()<CR>', 'Next Git Hunk'},
  ['[g'] = {'<cmd>lua require"gitsigns.actions".prev_hunk()<CR>', 'Previous Git Hunk'},
  ['<leader>gh'] = {
    name = '+Hunk',
    b = {'<cmd>lua require"gitsigns".blame_line(true)<CR>', 'Hunk Blame'},
    p = {'<cmd>lua require"gitsigns".preview_hunk()<CR>', 'Hunk Preview'},
    r = {'<cmd>lua require"gitsigns".reset_hunk()<CR>', 'Hunk Revert'},
    s = {'<cmd>lua require"gitsigns".stage_hunk()<CR>', 'Hunk Stage'},
    u = {'<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', 'Hunk Undo'},
  }
})

wkmap({
  ['<leader>gh'] = {
    r = {'<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', 'Hunk Revert'},
    s = {'<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', 'Hunk Stage'},
  }
},{
  mode = 'v',
})
