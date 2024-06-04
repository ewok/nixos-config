local lib = require("lib")
return {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    config = function()
        local lualine = require("lualine")
        local conf = require("conf")
        local opts = {
            extensions = { "fugitive", "trouble" },
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
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                    {
                        function()
                            if lib.is_loaded("hbac") then
                                local isSet, is_pinned = pcall(function()
                                    local cur_buf = vim.api.nvim_get_current_buf()
                                    return require("hbac.state").is_pinned(cur_buf)
                                end)
                                return (isSet and is_pinned) and " 📍" or ""
                            end
                        end,
                    },
                },
                lualine_c = {},
                lualine_x = {
                    {
                        "lsp_progress",
                        separators = {
                            component = " ",
                            progress = " | ",
                            percentage = { pre = "", post = "%% " },
                            title = { pre = "", post = ": " },
                            lsp_client_name = { pre = "[", post = "]" },
                            spinner = { pre = "", post = "" },
                            message = { commenced = "In Progress", completed = "Completed" },
                        },
                        display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
                        timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
                        spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
                    },
                    {
                        function()
                            if lib.is_loaded("venv-selector") then
                                local isSet, venv = pcall(require, "venv-selector")
                                if isSet then
                                    if venv.venv() then
                                        return "venv"
                                    end
                                end
                            end
                            return ""
                        end,
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            tabline = {
                lualine_a = {
                    { "buffers", use_mode_colors = true },
                },
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
        }

        lualine.setup(opts)
    end,
}
