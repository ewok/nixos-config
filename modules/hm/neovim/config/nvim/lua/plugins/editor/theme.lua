local lib = require("lib")
local map = lib.map
local conf = require("conf")

local function update_bg(forced)
    if vim.fn.filereadable(conf.home_dir .. "/Documents/theme_light") == 1 then
        if forced or vim.o.background ~= "light" then
            vim.cmd.colorscheme(conf.options.light_theme)
            -- vim.cmd.colorscheme("github_light")
            vim.o.background = "light"
        end
    end
    if vim.fn.filereadable(conf.home_dir .. "/Documents/theme_dark") == 1 then
        if forced or vim.o.background ~= "dark" then
            vim.cmd.colorscheme(conf.options.theme)
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
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    lazy = false,
    config = function()
        local tokyonight = require("tokyonight")
        tokyonight.setup({
            style = "storm",
            light_style = "day",
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
            -- integrations = {
            --     aerial = true,
            --     blink_cmp = {
            --         style = "bordered",
            --     },
            --     diffview = true,
            --     fidget = true,
            --     flash = true,
            --     grug_far = true,
            --     mini = {
            --         enabled = true,
            --         indentscope_color = "text",
            --     },
            --     neotree = true,
            --     neogit = true,
            --     copilot_vim = true,
            --     dap = true,
            --     dap_ui = true,
            --     nvim_surround = true,
            --     which_key = true,
            --     navic = { enabled = false },
            -- },
            -- on_highlights = function(hl, c)
            --     local prompt = "#2d3149"
            --     hl.TelescopeNormal = {
            --         bg = c.bg_dark,
            --         fg = c.fg_dark,
            --     }
            --     hl.TelescopeBorder = {
            --         bg = c.bg_dark,
            --         fg = c.bg_dark,
            --     }
            --     hl.TelescopePromptNormal = {
            --         bg = prompt,
            --     }
            --     hl.TelescopePromptBorder = {
            --         bg = prompt,
            --         fg = prompt,
            --     }
            --     hl.TelescopePromptTitle = {
            --         bg = prompt,
            --         fg = prompt,
            --     }
            --     hl.TelescopePreviewTitle = {
            --         bg = c.bg_dark,
            --         fg = c.bg_dark,
            --     }
            --     hl.TelescopeResultsTitle = {
            --         bg = c.bg_dark,
            --         fg = c.bg_dark,
            --     }
            -- end,
        })
        vim.cmd.colorscheme("tokyonight")
        update_bg(true)
        vim.api.nvim_create_augroup("toggle-theme", { clear = true })
        vim.api.nvim_create_autocmd("FocusGained", {
            group = "toggle-theme",
            callback = update_bg,
        })
    end,
}
