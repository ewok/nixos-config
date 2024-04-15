return {
    "folke/flash.nvim",
    event = { "VeryLazy" },
    config = function()
        local map = require("lib").map

        local flash = require("flash")

        map({ "n", "o", "x" }, "s", flash.jump, { silent = true }, "Flash")
        map("o", "r", flash.remote, { silent = true }, "FlashRemote")
        map({ "o", "x" }, "R", flash.treesitter_search, { silent = true }, "FlashTreesitterSearch")
        map("c", "<c-s>", flash.toggle, { silent = true }, "FlashToggle")

        flash.setup({
            modes = {
                search = {
                    enabled = false,
                },
            },
        })
    end,
}
