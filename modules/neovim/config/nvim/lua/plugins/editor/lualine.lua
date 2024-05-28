return {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    config = function()
        local lualine = require("lualine")
        local conf = require("conf")
        lualine.setup({
            extensions = { "fugitive", "trouble", "aerial" },
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
                lualine_c = {
                    {
                        "filename",
                        fmt = function(str)
                            local isSet, pinned = pcall(function()
                                local cur_buf = vim.api.nvim_get_current_buf()
                                return require("hbac.state").is_pinned(cur_buf)
                            end)
                            local pinned = (isSet and pinned) and "📍" or ""
                            return pinned .. str
                        end,
                    },
                },
                lualine_x = {
                    "encoding",
                    "fileformat",
                    "filetype",
                    {
                        function()
                            local isSet, venv = pcall(require, "venv-selector")
                            if isSet then
                                if venv.venv() then
                                    return "venv"
                                end
                            end
                            return ""
                        end,
                    },
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            tabline = {
                lualine_a = { { "buffers", use_mode_colors = true } },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "tabs" },
                lualine_z = {
                    {
                        function()
                            local cwd = string.gsub(vim.fn.getcwd(), os.getenv("HOME"), "~")
                            -- nicely shorten cwd path
                            if #cwd > 30 then
                                local parts = vim.split(cwd, "/")
                                local shortened = ""
                                for i = #parts, 1, -1 do
                                    shortened = "/" .. parts[i] .. shortened
                                    if #shortened - 1 > 30 then
                                        shortened = "/..." .. shortened
                                        break
                                    end
                                end
                                cwd = shortened
                            end
                            local buff_count = #vim.api.nvim_list_bufs()
                            return cwd .. " #" .. buff_count
                        end,
                    },
                },
            },
        })

        local map = require("lib").map
        local lualine_refresh = function()
            lualine.refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
        end

        local hydra = require("hydra")
        map("n", "<leader>j", function()
            hydra({
                name = "Switch buffers",

                config = {
                    hint = { type = "statusline" },
                    on_enter = function()
                        vim.cmd("silent! bnext")
                        lualine_refresh()
                    end,
                    on_key = function()
                        lualine_refresh()
                    end,
                    timeout = 300,
                },
                heads = {
                    { "k", "<cmd>silent! bprevious<CR>", { desc = "prev" } },
                    { "j", "<cmd>silent! bnext<CR>", { desc = "next" } },
                    { "q", nil, { exit = true } },
                },
            }):activate()
        end, { noremap = true }, "Goto next buffer")

        map("n", "<leader>k", function()
            hydra({
                name = "Switch buffers",

                config = {
                    hint = { type = "statusline" },
                    on_enter = function()
                        vim.cmd("silent! bprevious")
                        lualine_refresh()
                    end,
                    on_key = function()
                        lualine_refresh()
                    end,
                    timeout = 300,
                },
                heads = {
                    { "k", "<Cmd>silent! bprevious<CR>", { desc = "prev" } },
                    { "j", "<Cmd>silent! bnext<CR>", { desc = "next" } },
                    { "q", nil, { exit = true } },
                },
            }):activate()
        end, { noremap = true }, "Goto prev buffer")
    end,
}
