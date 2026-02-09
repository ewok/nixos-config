local lib = require("lib")
local conf = require("conf")

lib.reg_ft("kdl", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4

    pcall(vim.treesitter.start)
end)

lib.reg_ft_once("kdl", function()
    require("nvim-treesitter").install({ "kdl" })
    if conf.packages.conform then
        require("conform").formatters_by_ft.kdl = { "kdlfmt" }
    end
end)
