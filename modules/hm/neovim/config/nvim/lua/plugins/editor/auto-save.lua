local lib = require("lib")
local get_buf_ft = lib.get_buf_ft
local has_value = lib.has_value
local conf = require("conf")

return {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    config = function()
        local utils = require("auto-save.utils.data")
        require("auto-save").setup({
            enabled = true,
            trigger_events = {
                immediate_save = { "BufLeave", "FocusLost" },
                defer_save = { "InsertLeave", "TextChanged" },
                cancel_deferred_save = { "InsertEnter" },
            },
            write_all_buffers = false,
            noautocmd = false,
            lockmarks = false,
            debounce_delay = 1000,
            debug = false,
            condition = function(buf)
                return not has_value(conf.exclude_autosave_filetypes, get_buf_ft(buf))
            end,
        })
    end,
}
