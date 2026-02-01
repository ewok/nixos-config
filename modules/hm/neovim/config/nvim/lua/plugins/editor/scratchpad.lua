local conf = require("conf")
return {
    "PremBharwani/scratchpad",
    event = "VeryLazy",
    config = function()
        require("scratchpad").setup({
            border = conf.options.float_border,
            title = true,
            mappings = {
                toggle_buffer = "<leader><leader>,",
                toggle_visibility = "<leader>,",
                cycle_next = "<nop>",
                cycle_prev = "<nop>",
            },
            local_mappings = {
                close = "q",
                cycle_next = "<Tab>",
                cycle_prev = "<S-Tab>",
            },
        })
    end,
}
