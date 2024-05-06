return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "TroubleToggle", "TodoTrouble" },
    keys = {
        { "<leader>tt", "<cmd>TroubleToggle<CR>",                       desc = "Open/close trouble list" },
        { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Open trouble workspace diagnostics" },
        { "<leader>td", "<cmd>TroubleToggle document_diagnostics<CR>",  desc = "Open trouble document diagnostics" },
        { "<leader>tq", "<cmd>TroubleToggle quickfix<CR>",              desc = "Open trouble quickfix list" },
        { "<leader>tl", "<cmd>TroubleToggle loclist<CR>",               desc = "Open trouble location list" },
    },
}