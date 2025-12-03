local lib = require("lib")
local is_loaded = lib.is_loaded
local conf = require("conf")

return {
    {
        "okuuva/auto-save.nvim",
        cmd = "ASToggle",
        event = { "InsertLeave", "TextChanged" },
        opts = {
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
        },
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            local bqf = require("bqf")
            bqf.setup({
                func_map = {
                    tab = "<C-t>",
                    vsplit = "<C-v>",
                    split = "<C-s>",
                },
                filter = {
                    fzf = {
                        action_for = {
                            ["ctrl-t"] = "tabedit",
                            ["ctrl-v"] = "vsplit",
                            ["ctrl-s"] = "split",
                        },
                    },
                },
            })
        end,
    },
    {
        "j-hui/fidget.nvim",
        lazy = false,
        config = function()
            require("fidget").setup({
                notification = {
                    override_vim_notify = true,
                    window = {
                        normal_hl = "Keyword",
                        align = "top",
                    },
                    view = {
                        stack_upwards = false,
                    },
                },
            })
        end,
        init = function()
            map("n", "<leader>oN", "<cmd>Fidget history<cr>", { silent = true }, "Open notification history")
        end,
    },
    {
        "RRethy/vim-illuminate",
        event = { "BufNewFile", "BufReadPre" },
        config = function()
            local illuminate = require("illuminate")
            vim.cmd([[highlight illuminatedCurWord cterm=underline gui=underline]])
            illuminate.configure({
                delay = 100,
                under_cursor = false,
                modes_denylist = { "i" },
                providers = { "regex", "treesitter" },
                filetypes_denylist = require("conf").ui_ft,
            })
        end,
    },
    {
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
                        { "filename", path = 4 },
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
                        { "filename", path = 4 },
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
                                local cwd = vim.fn.getcwd():gsub(os.getenv("HOME"), "~")
                                return cwd
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
    },
}
