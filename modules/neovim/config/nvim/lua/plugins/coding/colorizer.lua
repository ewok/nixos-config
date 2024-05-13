return {
    "brenoprata10/nvim-highlight-colors",
    cmd = { "HighlightColors" },
    init = function()
        require("lib").map("n", "<leader>tC", "<cmd>HighlightColors Toggle<CR>", { silent = true }, "Code Colorizer")
    end,
    config = function()
        require("nvim-highlight-colors").setup({
            render = "background",
            virtual_symbol = "■",
            enable_named_colors = true,
        })
    end,
}
