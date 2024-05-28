local lib = require("lib")

lib.reg_ft("json", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
end)

lib.reg_lsp({ "jsonls" })

lib.reg_ft_once("json", function()
    local null_ls = require("null-ls")
    null_ls.register({ null_ls.builtins.formatting.prettier })
end)
