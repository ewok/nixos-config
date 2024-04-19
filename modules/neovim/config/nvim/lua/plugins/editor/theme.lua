return {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        local onedark = require("onedark")
        onedark.setup({
            highlights = {
                Visual = { bg = "$cyan", fg = "$bg0", fmt = "bold" },
                FloatBorder = { fg = "$cyan" },
                MatchParen = { fg = "$red", bg = "$bg0", fmt = "bold" },
            },
            style = "dark",
            toggle_style_key = "<leader>8",
            toggle_style_list = { "darker", "light", "dark" },
            code_style = {
                comments = "italic",
                keywords = "bold",
                functions = "bold",
                strings = "none",
                variables = "none",
            },
            diagnostics = {
                darker = true,
                undercurl = true,
            },
        })
        onedark.load()
    end,
}

