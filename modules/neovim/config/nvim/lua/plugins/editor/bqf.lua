return {
    "kevinhwang91/nvim-bqf",
    ft = {"qf"},
    config = function()
        local bqf = require("bqf")
        bqf.setup({
            func_map = {
                tab = "<C-t>",
                vsplit = "<C-v>",
                split = "<C-s>",
            },
            filter = {
                fzf = {
                    action_for = {
                        ["ctrl-t"] = "tabedit",
                        ["ctrl-v"] = "vsplit",
                        ["ctrl-s"] = "split",
                    },
                },
            },
        })
    end,
}
