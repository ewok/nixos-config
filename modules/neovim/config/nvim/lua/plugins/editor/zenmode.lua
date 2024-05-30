return {
    {
        "folke/zen-mode.nvim",
        cmd = { "ZenMode" },
        opts = {
            window = {
                backdrop = 0.95,
                width = 0.7,
                height = 0.98,
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                    cursorcolumn = false,
                    foldcolumn = "0",
                    list = false,
                },
            },
            plugins = {
                gitsigns = { enabled = false },
                tmux = { enabled = true },
            },
            on_open = function(win)
                require("barbecue.ui").toggle(false)
                vim.o.winbar = ""
                vim.o.laststatus = 0
                vim.o.cmdheight = 0
                require("ibl").update()
            end,
            on_close = function()
                require("barbecue.ui").toggle(true)
                vim.o.laststatus = 3
                vim.o.cmdheight = 1
                require("ibl").update()
            end,
        },
        init = function()
            local map = require("lib").map
            map("n", "<leader>z", "<cmd>ZenMode<CR>", { silent = true, nowait = true }, "Zoom")
        end,
    },
}
