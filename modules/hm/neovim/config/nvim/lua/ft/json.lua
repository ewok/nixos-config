local lib = require("lib")
local conf = require("conf")

lib.reg_ft("json", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2

    pcall(vim.treesitter.start)
end)

lib.reg_lsp("jsonls", {})

lib.reg_ft_once("json", function()
    require("nvim-treesitter").install({ "json" })
    if conf.packages.conform then
        require("conform").formatters_by_ft.json = { "prettier" }
    end
    if conf.packages.null then
        local null_ls = require("null-ls")
        null_ls.register({ null_ls.builtins.formatting.prettier })
    end
end)
