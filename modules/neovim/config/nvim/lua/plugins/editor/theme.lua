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
                        vim.cmd.colorscheme("dayfox")
                        require("lualine").setup({ options = { theme = "dayfox" } })
                    else
                        vim.cmd.colorscheme("nightfox")
                        require("lualine").setup({ options = { theme = "nightfox" } })
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
        enabled = conf.options.theme == "catppuccin" and true or false,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
