return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
        { "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
        -- { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Diagnostics workspace (Trouble)" },
        { "<leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
        {
            "<leader>ts",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>tl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        { "<leader>tQ", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" },
        { "<leader>tL", "<cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
    },
    opts = {},
}
