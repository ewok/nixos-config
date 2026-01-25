local lib = require("lib")
local map = lib.map

return {
    {
        "RRethy/vim-illuminate",
        event = { "BufNewFile", "BufReadPre" },
        config = function()
            local illuminate = require("illuminate")
            vim.cmd([[highlight illuminatedCurWord cterm=underline gui=underline]])
            illuminate.configure({
                delay = 100,
                under_cursor = false,
                modes_denylist = { "i" },
                providers = { "regex", "treesitter" },
                filetypes_denylist = require("conf").ui_ft,
            })
        end,
    },
    {
        "brenoprata10/nvim-highlight-colors",
        cmd = { "HighlightColors" },
        keys = {
            { "<leader>C", "<cmd>HighlightColors On<CR>", silent = true, desc = "Code Colorizer" },
        },
        config = function()
            require("nvim-highlight-colors").setup({
                render = "background",
                virtual_symbol = "■",
                enable_named_colors = true,
            })
        end,
    },
    -- {
    --     "lewis6991/satellite.nvim",
    --     config = true,
    --     event = { "BufReadPre", "BufNewFile" },
    -- },
}
