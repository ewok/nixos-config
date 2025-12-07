return {
    {
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local guess_indent = require("guess-indent")
            guess_indent.setup({
                auto_cmd = true,
                override_editorconfig = false,
                filetype_exclude = require("conf").ui_ft,
                buftype_exclude = { "help", "nofile", "terminal", "prompt" },
            })
        end,
    },
    {
        "nvimdev/indentmini.nvim",
        event = "BufEnter",
        config = function()
            local indentmini = require("indentmini")
            indentmini.setup({
                char = "│",
                exclude = { "clojure", "fennel", "oil" },
            })
            vim.cmd([[highlight default link IndentLine Comment]])
        end,
    },
}
