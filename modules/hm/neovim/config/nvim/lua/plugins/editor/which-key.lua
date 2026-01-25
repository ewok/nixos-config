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
            triggers = {
                { "<auto>", mode = "nixsotc" },
                { "m", mode = { "n" } },
            },
        })
        wk.add({
            { "<leader>c", group = "Code..." },
            { "<leader>a", group = "Ai...", mode = { "n", "v" } },
            { "<leader>cd", group = "Diff/Diagnostics" },
            { "<leader>d", group = "Debug..." },
            { "<leader>f", group = "Find..." },
            { "<leader>fs", group = "Settings" },
            { "<leader>g", group = "Git...", mode = { "n", "v" } },
            { "<leader>gf", group = "File..." },
            { "<leader>s", group = "Session..." },
            { "<leader>t", group = "Testing..." },
            { "<leader>w", group = "Wiki..." },
            { "<leader>y", group = "Yank..." },
            { "<leader>yf", group = "File..." },
            { "<leader>6", name = "Base64", mode = { "v" } },
            { "<leader>c", name = "Code...", mode = { "v" } },
            { "<leader>y", name = "Yank...", mode = { "v" } },
            { "<leader>w", name = "Wiki...", mode = { "v" } },
            { "<leader><leader>", group = "next..." },
            { "<leader><leader>l", group = "Lsp..." },
            { "<leader><leader>P", group = "Profiling..." },
            { "<leader><leader>t", group = "Terminal..." },
        })
    end,
}
