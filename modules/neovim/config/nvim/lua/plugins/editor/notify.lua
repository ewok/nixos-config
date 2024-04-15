return {
    "rcarriga/nvim-notify",
    init = function()
        local map = require("lib").map
        map("n", "<leader>fn", ":Notifications<cr>", { silent = true }, "Find notices history")
    end,
    config = function()
        local conf = require("conf")
        local notify = require("notify")

        local notify_options = {
            background_colour = conf.options.transparent and "#1E1E2E" or "#000000",
            stages = "fade",
            timeout = 1500,
            fps = 120,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { focusable = false })
            end,
            icons = {
                ERROR = conf.icons.diagnostic.Error,
                WARN = conf.icons.diagnostic.Warn,
                INFO = conf.icons.diagnostic.Info,
            },
        }

        notify.setup(notify_options)
        vim.notify = notify
    end,
}
