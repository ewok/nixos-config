return {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "SmiteshP/nvim-navic",
    },

    config = function()
        local conf = require "conf"
        local barbecue = require "barbecue"
        local ui = require "barbecue.ui"
        local is_ft_open = require "lib".is_ft_open
        barbecue.setup({
            create_autocmd = false,
            -- attach_navic = false,
            theme = conf.options.theme,
            symbols = {
                separator = conf.separator.alt_left
            }
        })

        local au_group = vim.api.nvim_create_augroup("barbecue.updater", {})

        vim.api.nvim_create_autocmd(
            { "CursorHold", "BufWinEnter", "InsertLeave", "WinScrolled" },
            {
                group = au_group,
                callback = function() ui.update() end
            })

        vim.api.nvim_create_autocmd("BufEnter", {
            group = au_group,
            callback = function()
                if is_ft_open("fugitiveblame") then
                    ui.toggle(false)
                else
                    ui.toggle(true)
                end
            end
        })
    end
}
