-- Init

-- Use it to install packages
_G.pkgs = {}

-- Basics
require "my.packer"
require "my.options"
require "my.keymaps"

-- UI
require "my.colorscheme"
require "my.lualine"
require "my.cursor"
require "my.nvim-tree"
require "my.bufferline"
require "my.impatient"
require "my.indentline"

-- Tools
require "my.colorizer"
require "my.gitsigns"
require "my.alpha"
require "my.telescope"

-- Coding
require "my.cmp"
require "my.lsp"
require "my.treesitter"
require "my.comment"
require "my.git-blame"
require "my.gitlinker"

-- Text
require "my.autopairs"
require "my.quickscope"

-- TODO: require "my.git"

-- require "user.toggleterm"
-- require "user.project"
-- require "user.hop"
-- require "user.matchup"
-- require "user.numb"
-- require "user.dial"
-- require "user.spectre"
-- require "user.zen-mode"
-- require "user.neoscroll"
-- require "user.todo-comments"
-- require "user.bookmark"
-- require "user.renamer"
-- require "user.symbol-outline"
-- require "user.git-blame"
-- require "user.gist"
-- require "user.gitlinker"
-- -- require "user.session-manager"
-- require "user.surround"
-- require "user.notify"
-- require "user.ts-context"
-- require "user.registers"
-- require "user.telescope-file-browser"
-- require "user.sniprun"
-- require "user.functions"
-- require "user.copilot"
-- require "user.gps"
-- require "user.illuminate"
-- require "user.dap"
-- require "user.lir"
-- require "user.jabs"

require'my.packer'.sync_all(pkgs)
