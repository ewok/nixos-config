return {

    '0x00-ketsu/autosave.nvim',
    event = { "InsertLeave", "TextChanged" },
    config = function()
        local conf = require "conf"

        require('autosave').setup {
            enable = conf.options.auto_save,
            events = { 'InsertLeave', 'TextChanged' },
            conditions = {
                exists = true,
                modifiable = true,
                filename_is_not = {},
                filetype_is_not = {}
                -- filetype_is_not = { "oil" }
            },
            write_all_buffers = false,
            debounce_delay = 2000
        }
    end
}
