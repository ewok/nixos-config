return {
    {
        "okuuva/auto-save.nvim",
        cmd = "ASToggle",
        event = { "InsertLeave", "TextChanged" },
        opts = {
            enabled = true,
            execution_message = {
                enabled = false,
                message = function()
                    return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
                end,
                dim = 0.18,
                cleaning_interval = 250,
            },
            trigger_events = {
                immediate_save = { "BufLeave", "FocusLost" },
                defer_save = { "InsertLeave", "TextChanged" },
                cancel_defered_save = { "InsertEnter" },
            },
            -- {
            --   condition = function(buf)
            --     local fn = vim.fn
            --     local utils = require("auto-save.utils.data")
            --
            --     -- don't save for `sql` file types
            --     if utils.not_in(fn.getbufvar(buf, "&filetype"), {'sql'}) then
            --       return true
            --     end
            --     return false
            --   end
            -- }
            condition = nil,
            write_all_buffers = false,
            noautocmd = false,
            lockmarks = false,
            debounce_delay = 1000,
            debug = false,
        },
    },
}
