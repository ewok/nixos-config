return {
    "junegunn/vim-easy-align",
    keys = { { "ga", mode = { "n", "x" } } },
    init = function()
        local map = require("lib").map
        map("n", "ga", "<Plug>(LiveEasyAlign)", { noremap = true }, "Align Block")
        map("x", "ga", "<Plug>(LiveEasyAlign)", { noremap = true }, "Align Block")
    end,
}
