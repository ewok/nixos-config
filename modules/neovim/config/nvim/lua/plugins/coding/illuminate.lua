return {
    "RRethy/vim-illuminate",
    event = { "BufNewFile", "BufReadPre" },
    config = function()
        local illuminate = require("illuminate")
        illuminate.configure({
            delay = 100,
            under_cursor = true,
            modes_denylist = { "i" },
            providers = { "regex", "treesitter" },
            filetypes_denylist = require("conf").ui_ft,
        })
    end,
}
