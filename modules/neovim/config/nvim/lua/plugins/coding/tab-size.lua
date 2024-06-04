return {
    -- "tpope/vim-sleuth", config = false, event = { "BufReadPre", "BufNewFile" }
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conf = require("conf")
        require("guess-indent").setup({
            auto_cmd = true,
            override_editorconfig = false,
            filetype_exclude = conf.ui_ft,
            buftype_exclude = {
                "help",
                "nofile",
                "terminal",
                "prompt",
            },
        })
    end,
}
