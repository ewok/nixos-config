local lib = require("lib")
local map = lib.map
local conf = require("conf")

local function update_bg(forced)
    if vim.fn.filereadable(conf.home_dir .. "/Documents/theme_light") == 1 then
        if forced or vim.o.background ~= "light" then
            vim.cmd.colorscheme(conf.options.theme .. "-" .. conf.options.light_flavor)
            -- vim.cmd.colorscheme("github_light")
            vim.o.background = "light"
        end
    end
    if vim.fn.filereadable(conf.home_dir .. "/Documents/theme_dark") == 1 then
        if forced or vim.o.background ~= "dark" then
            vim.cmd.colorscheme(conf.options.theme .. "-" .. conf.options.flavor)
            -- vim.cmd.colorscheme("github_dark")
            vim.o.background = "dark"
        end
    end
    vim.cmd("doautocmd ColorScheme")
    return false
end

map("n", "<leader><leader>d", function()
    vim.o.background = vim.o.background == "light" and "dark" or "light"
    -- update_bg()
    -- os.execute("toggle-theme " .. (vim.o.background == "light" and "dark" or "light"))
    -- update_bg(true)
end, { noremap = true }, "Toggle theme Dark")

return {
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        priority = 1000,
        lazy = false,
        enabled = conf.options.theme == "tokyonight",
        config = function()
            local tokyonight = require("tokyonight")
            tokyonight.setup({
                style = conf.options.flavor,
                light_style = conf.options.light_flavor,
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    sidebars = "dark",
                    floats = "dark",
                },
                day_brightness = 0.3,
                dim_inactive = false,
                lualine_bold = false,
                on_colors = function(colors)
                    colors.border = conf.colors.base0B
                end,
            })
            vim.cmd.colorscheme("tokyonight")
            update_bg(true)
            vim.api.nvim_create_augroup("toggle-theme", { clear = true })
            vim.api.nvim_create_autocmd("FocusGained", {
                group = "toggle-theme",
                callback = update_bg,
            })
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        enabled = conf.options.theme == "catppuccin",
        config = function()
            local catppuccin = require("catppuccin")
            catppuccin.setup({
                no_italic = true,
                flavour = "auto",
                background = {
                    light = conf.options.light_flavor,
                    dark = conf.options.flavor,
                },
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = { "italic" },
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                    -- miscs = {}, -- Uncomment to turn off hard-coded styles
                },
                integrations = {
                    aerial = true,
                    blink_cmp = {
                        style = "bordered",
                    },
                    diffview = true,
                    fidget = true,
                    flash = true,
                    grug_far = true,
                    mini = {
                        enabled = true,
                        indentscope_color = "text",
                    },
                    neotree = true,
                    neogit = true,
                    copilot_vim = true,
                    dap = true,
                    dap_ui = true,
                    nvim_surround = true,
                    which_key = true,
                    navic = { enabled = true },
                },
            })
            vim.cmd.colorscheme("catppuccin")
            update_bg(true)
            vim.api.nvim_create_augroup("toggle-theme", { clear = true })
            vim.api.nvim_create_autocmd("FocusGained", {
                group = "toggle-theme",
                callback = update_bg,
            })
        end,
    },
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        lazy = false,
        enabled = conf.options.theme == "onedark",
        config = function()
            local onedark = require("onedarkpro")
            onedark.setup({
                styles = { -- For example, to apply bold and italic, use "bold,italic"
                    types = "NONE", -- Style that is applied to types
                    methods = "NONE", -- Style that is applied to methods
                    numbers = "NONE", -- Style that is applied to numbers
                    strings = "NONE", -- Style that is applied to strings
                    comments = "italic",
                    keywords = "italic",
                    constants = "NONE", -- Style that is applied to constants
                    functions = "NONE", -- Style that is applied to functions
                    operators = "NONE", -- Style that is applied to operators
                    variables = "NONE", -- Style that is applied to variables
                    parameters = "NONE", -- Style that is applied to parameters
                    conditionals = "NONE", -- Style that is applied to conditionals
                    virtual_text = "NONE", -- Style that is applied to virtual text
                },
            })
            vim.cmd.colorscheme("onedark")
            update_bg(true)
            vim.api.nvim_create_augroup("toggle-theme", { clear = true })
            vim.api.nvim_create_autocmd("FocusGained", {
                group = "toggle-theme",
                callback = update_bg,
            })
        end,
    },
}
