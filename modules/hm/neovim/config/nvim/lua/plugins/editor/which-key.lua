local conf = require("conf")

return {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    config = function()
        local wk = require("which-key")
        wk.setup({
            preset = "modern",
            plugins = {
                presets = {
                    operators = false,
                    text_objects = true,
                    motions = true,
                    g = true,
                    z = true,
                    nav = true,
                    windows = true,
                },
                spelling = {
                    enabled = true,
                    suggestions = 20,
                },
            },
            icons = {
                breadcrumb = conf.icons.wk.breadcrumb,
                separator = conf.icons.wk.separator,
                group = conf.icons.wk.group,
            },
            win = {
                border = conf.options.float_border,
            },
        })
        wk.add({
            { "<leader>c", group = "Code" },
            { "<leader>ca", group = "Ai" },
            { "<leader>cd", group = "Diff/Diagnostics" },
            { "<leader>f", group = "Find" },
            { "<leader>fs", group = "Settings" },
            { "<leader>l", group = "Lsp" },
            { "<leader>o", group = "Open" },
            { "<leader>g", group = "Git..." },
            { "<leader>ot", group = "Terminal..." },
            { "<leader>gf", group = "File..." },
            { "<leader>p", group = "Packages" },
            { "<leader>P", group = "Profiling" },
            { "<leader>s", group = "Session" },
            { "<leader>t", group = "Toggle" },
            { "<leader>th", desc = "Dark/Light theme" },
            { "<leader>w", group = "Wiki" },
            { "<leader>y", group = "Yank" },
            { "<leader>yf", group = "File" },
            { "<leader>6", name = "Base64", mode = { "v" } },
            { "<leader>c", name = "Code", mode = { "v" } },
            { "<leader>y", name = "Yank", mode = { "v" } },
            { "<leader>w", name = "Wiki", mode = { "v" } },
        })
    end,
}
