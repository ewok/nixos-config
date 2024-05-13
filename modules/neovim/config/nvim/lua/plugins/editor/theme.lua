local conf = require("conf")
return {
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        lazy = false,
        enabled = conf.options.theme == "onedark" and true or false,
        config = function()
            local onedark = require("onedark")
            onedark.setup({
                highlights = {
                    Visual = { bg = "$cyan", fg = "$bg0", fmt = "bold" },
                    FloatBorder = { fg = "$cyan" },
                    MatchParen = { fg = "$red", bg = "$bg0", fmt = "bold" },
                },
                style = "dark",
                toggle_style_key = "<leader>th",
                toggle_style_list = { "darker", "light", "dark" },
                code_style = {
                    comments = "italic",
                    keywords = "bold",
                    functions = "bold",
                    strings = "none",
                    variables = "none",
                },
                diagnostics = {
                    darker = true,
                    undercurl = true,
                },
            })
            onedark.load()
        end,
    },
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        lazy = false,
        enabled = conf.options.theme == "nightfox" and true or false,
        config = function()
            -- autocommand on WinEnter
            vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained", "VimEnter" }, {
                group = vim.api.nvim_create_augroup("nightfox", { clear = true }),
                callback = function()
                    if vim.fn.filereadable("/tmp/theme_light") == 1 then
                        if vim.cmd.colorscheme ~= "dayfox" then
                            vim.cmd.colorscheme("dayfox")
                            require("lualine").setup({ options = { theme = "dayfox" } })
                            require("ibl").update()
                        end
                    else
                        if vim.cmd.colorscheme ~= "nightfox" then
                            vim.cmd.colorscheme("nightfox")
                            require("lualine").setup({ options = { theme = "nightfox" } })
                            require("ibl").update()
                        end
                    end
                end,
                desc = "Toggle theme on WinEnter",
            })
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        -- enabled = conf.options.theme == "catppuccin-mocha" and true or false,
        enabled = conf.options.theme:match("^catppuccin") and true or false,
        config = function()
            vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained", "VimEnter" }, {
                group = vim.api.nvim_create_augroup("catppuccin", { clear = true }),
                callback = function()
                    if vim.fn.filereadable("/tmp/theme_light") == 1 then
                        if vim.cmd.colorscheme ~= conf.options.light_theme then
                            vim.cmd.colorscheme(conf.options.light_theme)
                            require("lualine").setup({ options = { theme = conf.options.light_theme } })
                            require("ibl").update()
                        end
                    else
                        if vim.cmd.colorscheme ~= conf.options.theme then
                            vim.cmd.colorscheme(conf.options.theme)
                            require("lualine").setup({ options = { theme = conf.options.theme } })
                            require("ibl").update()
                        end
                    end
                end,
                desc = "Toggle theme on WinEnter",
            })
        end,
    },
}
