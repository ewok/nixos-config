local lib = require("lib")
local map = lib.map
local conf = require("conf")

return {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    enabled = conf.packages.zen,
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
        on_open = function()
            vim.o.winbar = ""
            vim.o.laststatus = 0
            vim.o.cmdheight = 0
        end,
        on_close = function()
            vim.o.laststatus = 3
            vim.o.cmdheight = 1
        end,
    },
    init = function()
        map("n", "<leader>z", "<cmd>ZenMode<cr>", { silent = true, nowait = true }, "Toggle Zoom")
    end,
}
