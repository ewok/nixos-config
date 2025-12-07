local lib = require("lib")
local is_loaded = lib.is_loaded
local get_buf_ft = lib.get_buf_ft
local conf = require("conf")

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
        local ll = require("lualine")
        local opts = {
            extensions = { "aerial" },
            options = {
                theme = "auto",
                icons_enabled = true,
                component_separators = { left = conf.separator.alt_left, right = conf.separator.alt_right },
                section_separators = { left = conf.separator.left, right = conf.separator.right },
                disabled_filetypes = {},
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = {
                    {
                        function()
                            local isSet, venv = pcall(require, "venv-selector")
                            if isSet then
                                return venv.venv() or ""
                            else
                                return ""
                            end
                        end,
                        cond = function()
                            return is_loaded("venv-selector")
                        end,
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            winbar = {
                lualine_c = {
                    {
                        "filename",
                        path = 4,
                        cond = function()
                            return get_buf_ft(0) ~= "oil"
                        end,
                    },
                    {
                        function()
                            local ok, oil = pcall(require, "oil")
                            if ok then
                                return " oil://" .. vim.fn.fnamemodify(oil.get_current_dir(), ":~")
                            else
                                return ""
                            end
                        end,
                        cond = function()
                            return get_buf_ft(0) == "oil"
                        end,
                    },
                    {
                        "%{%v:lua.require'nvim-navic'.get_location()%}",
                        cond = function()
                            return is_loaded("nvim-navic")
                        end,
                    },
                },
            },
            inactive_winbar = {
                lualine_c = {
                    {
                        "filename",
                        path = 4,
                        cond = function()
                            return get_buf_ft(0) ~= "oil"
                        end,
                    },
                    {
                        function()
                            local ok, oil = pcall(require, "oil")
                            if ok then
                                return " oil://" .. vim.fn.fnamemodify(oil.get_current_dir(), ":~")
                            else
                                return ""
                            end
                        end,
                        cond = function()
                            return get_buf_ft(0) == "oil"
                        end,
                    },
                },
            },
            tabline = {
                lualine_a = { "tabs" },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_z = {
                    {
                        function()
                            return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
                        end,
                    },
                },
                lualine_y = {
                    {
                        function()
                            return "buffers: " .. #vim.api.nvim_list_bufs()
                        end,
                    },
                },
            },
        }
        ll.setup(opts)
    end,
}
