return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufNewFile", "BufReadPre" },
    config = function()
        local conf = require("conf")
        vim.g.indent_blankline_buftype_exclude = conf.ui_ft
        require("ibl").setup({ scope = { enabled = true } })
    end,
}
