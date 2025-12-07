return {
    "MagicDuck/grug-far.nvim",
    config = function()
        local grug = require("grug-far")
        grug.setup({
            keymaps = {
                replace = { n = "X" },
                qflist = { n = "<c-q>" },
                syncLocations = { n = "<c-r>" },
                syncLine = { n = "r" },
                close = { n = "q" },
                historyOpen = { n = "<localleader>t" },
                historyAdd = { n = "<localleader>a" },
                refresh = { n = "R" },
                gotoLocation = { n = "<enter>" },
                pickHistoryEntry = { n = "<enter>" },
                abort = { n = "<c-c>", i = "<c-c>" },
            },
        })
    end,
    cmd = { "GrugFar" },
    keys = {
        {
            "<leader>fr",
            "<cmd>GrugFar<cr>",
            mode = "n",
            desc = "Find and Replace [global]",
        },
    },
}
