local lib = require("lib")
local reg_ft, map = lib.reg_ft, lib.map

return {
    {
        "FabijanZulj/blame.nvim",
        cmd = "BlameToggle",
        keys = {
            {
                "<leader>gb",
                function()
                    local pos = vim.fn.getcurpos()
                    vim.cmd("normal! gg")
                    vim.cmd("BlameToggle")
                    vim.fn.timer_start(500, function()
                        vim.fn.setpos(".", pos)
                        vim.cmd("normal! zz")
                    end)
                end,
                mode = { "n" },
                desc = "Blame",
            },
        },
        config = true,
    },
    -- { "akinsho/git-conflict.nvim", event = { "BufReadPre", "BufNewFile" }, version = "*", config = true },
    {
        "spacedentist/resolve.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "CodeDiff" },
        opts = {},
    },
    {
        "esmuellert/codediff.nvim",
        keys = {
            { "<leader>gfl", "<cmd>CodeDiff history %<cr>", mode = { "n" }, desc = "Log" },
            { "<leader>gl", "<cmd>CodeDiff history<cr>", mode = { "n" }, desc = "Log" },
            { "<leader>gd", "<cmd>CodeDiff<cr>", mode = { "n" }, desc = "Open Diff" },
        },
        config = function()
            require("codediff").setup({
                keymaps = {
                    explorer = {
                        toggle_stage = "s", -- Stage/unstage selected file
                    },
                },
            })
        end,
    },
    {
        "NeogitOrg/neogit",
        -- "sotte/neogit",
        -- branch = "support-vscode-diff",
        cmd = { "Neogit" },
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", mode = { "n" }, desc = "Git Status" },
        },
        config = function()
            local ng = require("neogit")
            ng.setup({
                diff_viewer = "codediff",
                use_per_project_settings = true,
                remember_settings = true,
                mappings = {
                    status = {
                        gx = "OpenTree",
                        ["="] = "Toggle",
                    },
                    finder = {
                        ["<c-j>"] = "Next",
                        ["<c-k>"] = "Previous",
                    },
                },
                auto_show_console = true,
                console_timeout = 500,
                disable_insert_on_commit = true,
            })
        end,
    },
    {
        "echasnovski/mini.diff",
        event = { "BufReadPre", "BufNewFile" },
        version = false,
        config = function()
            map(
                "n",
                "<leader>gh",
                "<cmd>lua MiniDiff.toggle_overlay()<cr>",
                { noremap = true },
                "Toggle githunk overlay"
            )
            require("mini.diff").setup({
                view = {
                    style = "number",
                },
                mappings = {
                    apply = "gh",
                    reset = "gH",
                    textobject = "gh",
                    goto_first = "",
                    goto_prev = "[g",
                    goto_next = "]g",
                    gotoGit_last = "",
                },
            })
        end,
    },
}
