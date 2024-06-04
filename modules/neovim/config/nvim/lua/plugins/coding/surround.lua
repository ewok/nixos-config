return {
    -- "tpope/vim-surround",
    -- config = false,
    -- event = { "BufReadPre", "BufNewFile" },
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("nvim-surround").setup({})
    end,
}
