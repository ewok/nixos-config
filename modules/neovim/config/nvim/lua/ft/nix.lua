local lib = require("lib")

lib.reg_lsp({ "nil_ls" })

lib.reg_ft_once("nix", function()
    local null_ls = require("null-ls")
    null_ls.register({ null_ls.builtins.formatting.nixpkgs_fmt })
end)
