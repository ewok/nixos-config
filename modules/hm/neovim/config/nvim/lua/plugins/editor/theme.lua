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

map("n", "<leader>th", function()
    vim.o.background = vim.o.background == "light" and "dark" or "light"
    -- update_bg()
    -- os.execute("toggle-theme " .. (vim.o.background == "light" and "dark" or "light"))
    -- update_bg(true)
end, { noremap = true }, "Toggle theme Dark")

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
        local catppuccin = require("catppuccin")
        catppuccin.setup({
            no_italic = true,
            flavour = "auto",
            background = {
                light = "latte",
                dark = "macchiato",
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
}
