local M = {}

local function clone_paq()
    local path = vim.fn.stdpath 'data' .. '/site/pack/paqs/start/paq-nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system {
            'git',
            'clone',
            '--depth=1',
            'https://github.com/savq/paq-nvim.git',
            path,
        }
    end
end

-- M.bootstrap = function(PKGS)
    clone_paq()

    -- Load Paq
    vim.cmd 'packadd paq-nvim'
    -- local paq = require 'paq'

    -- Exit nvim after installing plugins
    vim.cmd 'autocmd User PaqDoneInstall quit'

    -- Read and install packages
    -- paq(PKGS):install()
-- end

M.sync_all = function(PKGS)
    -- package.loaded.paq = nil
    (require 'paq')(PKGS):sync()
end

return M
