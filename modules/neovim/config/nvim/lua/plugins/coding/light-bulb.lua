return {
    "kosayoda/nvim-lightbulb",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local nvim_lightbulb = require("nvim-lightbulb")
        nvim_lightbulb.setup({
            ignore = {},
            sign = { enabled = true, priority = 15 },
            float = { enabled = false, text = "💡", win_opts = {} },
            virtual_text = { enabled = false, text = "💡", hl_mode = "replace" },
            status_text = { enabled = false, text = "💡", text_unavailable = "" },
        })

        vim.fn.sign_define("LightBulbSign", {
            text = "💡",
            texthl = "DiagnosticSignWarn",
            linehl = "",
            numhl = "",
        })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            pattern = "*",
            callback = function()
                nvim_lightbulb.update_lightbulb()
            end,
        })
    end,
}
