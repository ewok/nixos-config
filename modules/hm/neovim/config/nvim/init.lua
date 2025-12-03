require("base.settings")
require("base.pre")
require("base.mappings")
local lazy_config = require("conf").lazy_config

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
    vim.api.nvim_echo({
        { string.format("Unable to load lazy from: %s\n", lazypath), "ErrorMsg" },
        { "Press any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
else
    -- load plugins
    local lazy = require("lazy")
    lazy.setup({
        { import = "plugins/base" },
        { import = "plugins/ft" },
        { import = "plugins/editor" },
    }, lazy_config)
end

local ft_path = vim.fn.stdpath("config") .. "/lua/ft"
if vim.loop.fs_stat(ft_path) then
    for _, file in ipairs(vim.fn.readdir(ft_path)) do
        local match = file:match("^(.*)%.lua$")
        if match then
            require("ft." .. match)
        end
    end
end

require("base.post")
