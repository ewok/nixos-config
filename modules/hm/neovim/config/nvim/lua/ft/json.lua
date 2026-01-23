local lib = require("lib")

lib.reg_ft("json", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2

    pcall(vim.treesitter.start)
end)

lib.reg_lsp("jsonls", {})

lib.reg_ft_once("json", function()
    require("conform").formatters_by_ft.json = { "prettier" }
    require("nvim-treesitter").install({ "json" })
end)
