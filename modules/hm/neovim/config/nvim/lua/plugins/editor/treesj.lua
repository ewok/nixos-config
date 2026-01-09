return {
    "Wansmer/treesj",
    keys = {
        {
            "gs",
            function()
                require("treesj").split()
            end,
            mode = "n",
            desc = "[treesj] Split",
        },
        {
            "gj",
            function()
                require("treesj").join()
            end,
            mode = "n",
            desc = "[treesj] Join",
        },
    },
    config = function()
        require("treesj").setup({
            use_default_keymaps = false,
        })
    end,
}
