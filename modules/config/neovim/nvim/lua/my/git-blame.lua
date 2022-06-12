--
local wkmap = require'my.wk'.map
table.insert(pkgs, "f-person/git-blame.nvim")

vim.g.gitblame_enabled = 0
vim.g.gitblame_message_template = "<summary> • <date> • <author>"
vim.g.gitblame_highlight_group = "LineNr"

wkmap({
  ['<leader>gb'] = { "<cmd>GitBlameToggle<cr>", "Blame" }
},{
  mode = 'n',
})
