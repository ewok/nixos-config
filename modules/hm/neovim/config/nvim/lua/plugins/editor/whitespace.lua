local map = require("lib").map
local conf = require("conf")

return {
    "ntpeters/vim-better-whitespace",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.g.better_whitespace_filetypes_blacklist = conf.ui_ft
        vim.g.better_whitespace_operator = "<localleader>S"
        map("n", "<leader>cw", ":StripWhitespace<CR>", {}, "Strip Whitespaces")
    end,
}
