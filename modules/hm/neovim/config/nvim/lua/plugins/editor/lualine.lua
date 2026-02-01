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
                disabled_filetypes = {
                    statusline = {
                        "dap-repl",
                        "dapui_breakpoints",
                        "dapui_console",
                        "dapui_scopes",
                        "dapui_watches",
                        "dapui_stacks",
                    },
                    winbar = {
                        "dap-repl",
                        "dapui_breakpoints",
                        "dapui_console",
                        "dapui_scopes",
                        "dapui_watches",
                        "dapui_stacks",
                        "toggleterm",
                        "terminal",
                        "sidekick_terminal",
                    },
                },
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                    {
                        function()
                            local linters = require("lint").get_running()
                            if #linters == 0 then
                                return "󰦕"
                            end
                            return "󱉶 " .. table.concat(linters, ", ")
                        end,
                        cond = function()
                            return is_loaded("lint")
                        end,
                    },
                },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = {
                    {
                        function()
                            local status = require("sidekick.status").cli()
                            return " " .. (#status > 1 and #status or "")
                        end,
                        cond = function()
                            if is_loaded("sidekick") then
                                return #require("sidekick.status").cli() > 0
                            end
                            return false
                        end,
                        color = function()
                            return "Special"
                        end,
                    },
                    {
                        function()
                            return require("opencode").statusline()
                        end,
                        cond = function()
                            return is_loaded("opencode")
                        end,
                    },
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
                            if not conf.packages.oil then
                                return
                            end
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
                            if not conf.packages.oil then
                                return
                            end
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
