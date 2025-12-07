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
    {
        "NeogitOrg/neogit",
        cmd = { "Neogit", "DiffviewOpenFileHistory" },
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", mode = { "n" }, desc = "Git Status" },
            { "<leader>gfd", "<cmd>DiffviewFileHistory %<cr>", mode = { "n" }, desc = "Diff history" },
            { "<leader>gd", ":DiffviewOpen ", mode = { "n" }, desc = "Open Diff" },
            { "<leader>gfl", "<cmd>NeogitLog<cr>", mode = { "n" }, desc = "Line history" },
            { "<leader>gfl", ":NeogitLog<cr>", mode = { "v" }, desc = "Line history" },
        },
        dependencies = { "sindrets/diffview.nvim" },
        config = function()
            local ng = require("neogit")
            ng.setup({
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
            reg_ft("DiffviewFiles", function(ev)
                map("n", "q", "<cmd>tabclose<cr>", { buffer = ev.buf }, "Close")
            end)
            reg_ft("DiffviewFileHistory", function(ev)
                map("n", "q", "<cmd>tabclose<cr>", { buffer = ev.buf }, "Close")
            end)
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
