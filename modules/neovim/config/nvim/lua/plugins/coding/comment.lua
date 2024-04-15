---@type LazySpec
return {
    {
        "numToStr/Comment.nvim",
        event = { "BufNewFile", "BufReadPre" },
        config = function()
            require("Comment").setup({
                opleader = {
                    line = "gc",
                    block = "gb",
                },
                toggler = {
                    line = "gcc",
                    block = "gcb",
                },
                extra = {
                    above = "gck",
                    below = "gcj",
                    eol = "gcA",
                },
            })
        end,
    },
}
