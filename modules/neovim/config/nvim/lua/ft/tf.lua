local lib = require("lib")

lib.reg_lsp({ "terraformls" })

lib.reg_ft_once("terraform", function()
    local null_ls = require("null-ls")
    null_ls.register({ null_ls.builtins.diagnostics.tfsec })
end)
