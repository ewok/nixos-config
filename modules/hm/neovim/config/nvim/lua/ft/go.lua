local lib = require("lib")

lib.reg_ft("go", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
end)

lib.reg_lsp("gopls", {})

lib.reg_ft_once("go", function()
    local null_ls = require("null-ls")
    null_ls.register({ null_ls.builtins.diagnostics.golangci_lint })
end)
