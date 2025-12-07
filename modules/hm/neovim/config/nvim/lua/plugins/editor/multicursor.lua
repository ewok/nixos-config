local map = require("lib").map

return {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
        { "<c-n>", mode = { "n", "x" } },
        { "<c-q>", mode = { "n", "x" } },
        { "<up>", mode = { "n", "x" } },
        { "<down>", mode = { "n", "x" } },
    },
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()
        mc.addKeymapLayer(function(layerSet)
            layerSet({ "n", "x" }, "<c-k>", mc.prevCursor)
            layerSet({ "n", "x" }, "<c-j>", mc.nextCursor)
            layerSet({ "n", "x" }, "<c-p>", function()
                mc.matchAddCursor(-1)
            end)
            layerSet({ "n", "x" }, "<c-s>", function()
                mc.matchSkipCursor(1)
            end)
            layerSet({ "n", "x" }, "*", mc.matchAllAddCursors)
            layerSet({ "n", "x" }, "<c-x>", mc.deleteCursor)
            layerSet({ "n", "x" }, "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)
        map({ "n", "x" }, "<up>", function()
            mc.lineAddCursor(-1)
        end, {}, "None")
        map({ "n", "x" }, "<down>", function()
            mc.lineAddCursor(1)
        end, {}, "None")
        map({ "n", "x" }, "<c-n>", function()
            mc.matchAddCursor(1)
        end, {}, "None")
        map({ "n", "x" }, "<c-q>", function()
            mc.toggleCursor()
        end, {}, "None")
    end,
}
