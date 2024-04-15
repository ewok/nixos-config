return {
    "junegunn/vim-easy-align",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local map = require("lib").map
        map("n", "ga", "<Plug>(LiveEasyAlign)", { noremap = true }, "Align Block")
        map("x", "ga", "<Plug>(LiveEasyAlign)", { noremap = true }, "Align Block")
    end,
}
