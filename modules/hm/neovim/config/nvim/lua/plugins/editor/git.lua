local lib = require("lib")
local map = lib.map

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
    { "akinsho/git-conflict.nvim", event = { "BufReadPre", "BufNewFile" }, version = "*", config = true },
    {
        "esmuellert/codediff.nvim",
        cmd = { "CodeDiff" },
        keys = {
            { "<leader>gfl", "<cmd>CodeDiff history %<cr>", mode = { "n" }, desc = "Log" },
            { "<leader>gl", "<cmd>CodeDiff history<cr>", mode = { "n" }, desc = "Log" },
            { "<leader>gd", "<cmd>CodeDiff<cr>", mode = { "n" }, desc = "Open Diff" },
        },
        config = function()
            require("codediff").setup({
                keymaps = {
                    view = {
                        quit = "q",
                        -- toggle_explorer = ";",
                        next_hunk = "<c-f>",
                        prev_hunk = "<c-b>",
                        next_file = "<c-n>",
                        prev_file = "<c-p>",
                        diff_get = "do",
                        diff_put = "dp",
                        open_in_prev_tab = "gf",
                        toggle_stage = "s",
                    },
                    explorer = {
                        select = "<CR>",
                        hover = "K",
                        refresh = "R",
                        toggle_view_mode = "i",
                        stage_all = "S",
                        unstage_all = "U",
                        restore = "X",
                    },
                    history = {
                        select = "<CR>",
                        toggle_view_mode = "i",
                    },
                    conflict = {
                        accept_incoming = "ct",
                        accept_current = "co",
                        accept_both = "cb",
                        discard = "cx",
                        next_conflict = "]x",
                        prev_conflict = "[x",
                        diffget_incoming = "2do",
                        diffget_current = "3do",
                    },
                },
            })
        end,
    },
    {
        "NeogitOrg/neogit",
        -- "sotte/neogit",
        -- branch = "support-vscode-diff",
        cmd = { "Neogit", "NeogitCommit" },
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
