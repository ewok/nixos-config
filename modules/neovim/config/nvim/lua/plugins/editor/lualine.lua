return {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    config = function()
        local lualine = require("lualine")
        local conf = require("conf")
        lualine.setup({
            options = {
                theme = conf.options.theme or "auto",
                icons_enabled = true,
                component_separators = { left = conf.separator.alt_left, right = conf.separator.alt_right },
                section_separators = { left = conf.separator.left, right = conf.separator.right },
                disabled_filetypes = {},
                globalstatus = true,
                refresh = {
                    statusline = 100,
                    winbar = 100,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end,
}
