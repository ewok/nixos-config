local conf = require("conf")
return {
    "folke/todo-comments.nvim",
    keys = {
        {
            "<leader>fd",
            function()
                require("telescope").extensions["todo-comments"].todo()
            end,
            desc = "Find todo tag in the current workspace",
            mode = "n",
        },
        {
            "<leader>tD",
            "<cmd>Trouble todo<CR>",
            mode = "n",
            desc = "Find todo tag in the current workspace",
        },
    },
    opts = {
        keywords = {
            NOTE = { icon = conf.icons.Note, color = "#96CDFB" },
            TODO = { icon = conf.icons.Todo, color = "#B5E8E0" },
            PERF = { icon = conf.icons.Pref, color = "#F8BD96" },
            WARN = { icon = conf.icons.Warn, color = "#FAE3B0" },
            HACK = { icon = conf.icons.Hack, color = "#DDB6F2" },
            FIX = {
                icon = conf.icons.Fixme,
                color = "#DDB6F2",
                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
        },
    },
}
