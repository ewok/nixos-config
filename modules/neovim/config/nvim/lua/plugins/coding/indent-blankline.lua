return {
    "lukas-reineke/indent-blankline.nvim",
    commit = "3d08501",
    main = "ibl",
    event = { "BufNewFile", "BufReadPre" },
    config = function()
        local conf = require("conf")
        vim.g.indent_blankline_buftype_exclude = conf.ui_ft
        require("ibl").setup({
            indent = {
                -- char = "╎",
                -- char = "┊",
                char = "│",
                -- char = "▏",
            },
            scope = { enabled = true },
        })
    end,
}
