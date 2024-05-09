return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
        { "<leader>tt", "<cmd>TroubleToggle<CR>", desc = "Trouble" },
        { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Diagnostics workspace (Trouble)" },
        { "<leader>td", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Diagnostics (Trouble)" },
        { "<leader>tq", "<cmd>TroubleToggle quickfix toggle<CR>", desc = "Quickfix List (Trouble)" },
        { "<leader>tl", "<cmd>TroubleToggle loclist toggle<CR>", desc = "Location List (Trouble)" },
    },
    opts = {},
}
