require("settings")
require("pre")
require("mappings")

local ft_path = vim.fn.stdpath("config") .. "/lua/ft"
if vim.loop.fs_stat(ft_path) then
  for file in vim.fs.dir(ft_path) do
    file = file:match("^(.*)%.lua$")
    if file then
      require("ft." .. file)
    end
  end
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
end

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        config = false,
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
        config = false,
    },

    { import = "plugins/ft" },
    { import = "plugins/coding" },
    { import = "plugins/editor" },
}, lazy_config)

require("post")
-- -- load theme
-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")
--
-- require "nvchad.autocmds"

-- vim.schedule(function()
--   require "mappings"
-- end)
