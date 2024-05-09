return {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    config = function()
        local wk = require("which-key")
        local conf = require("conf")

        wk.setup({
            plugins = {
                presets = {
                    operators = false,
                    motions = true,
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
            operators = { gc = "Comments" },
            window = {
                border = "single",
            },
        })

        wk.register({
            th = "Dark/Light theme",
            c = { name = "Code" },
            f = { name = "Find" },
            fs = { name = "Settings" },
            g = { name = "Git" },
            gc = { name = "Git Conflict" },
            gf = { name = "Git Fetch" },
            gh = { name = "Git Hunk" },
            gl = { name = "Git Log" },
            gt = { name = "Git Toggle" },
            gp = { name = "Git Push" },
            l = { name = "Lsp" },
            o = { name = "Open" },
            p = { name = "Packages | Profiling | Mason" },
            s = { name = "Session" },
            y = { name = "Yank" },
            yf = { name = "File" },
            t = { name = "Toggle" },
            w = { name = "Wiki" },
        }, {
            prefix = "<leader>",
            mode = "n",
        })

        wk.register({
            ["6"] = { name = "Base64" },
            c = { name = "Code" },
            g = { name = "Git" },
            gl = { name = "Git Log" },
            gh = { name = "Hunk" },
            y = { name = "Yank" },
            w = { name = "Wiki" },
        }, {
            prefix = "<leader>",
            mode = "x",
        })

        wk.register({
            c = {
                name = "Comment",
                c = "Toggle line comment",
                b = "Toggle block comment",
                a = "Insert line comment to line end",
                j = "Insert line comment to next line",
                k = "Insert line comment to previous line",
            },
        }, {
            prefix = "g",
            mode = "n",
        })
    end,
}
