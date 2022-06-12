local M = {}
local v = require'my.v'

-- Automatically install packer
local install_path = v.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

if v.fn.empty(v.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = v.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
  vim.cmd [[q]]
end

vim.cmd [[packadd packer.nvim]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  print("Packer is not loaded.")
  return
end

-- v.cmd [[packadd packer.nvim]]

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

M.sync_all = function(pkgs)
  packer.startup(function(use)
    use {
      'wbthomason/packer.nvim',
      opt = true,
      branch='master',
    }
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

    for _, value in ipairs(pkgs) do
      use ( value )
    end

    if PACKER_BOOTSTRAP then
      packer.sync()
    end

  end)
end

return M
