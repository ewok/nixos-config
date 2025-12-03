local lib = require("lib")

-- lib.reg_ft("nix", function(ev)
--   lib.map("n", "<leader>fm", "<Cmd>lua require('telescope').extensions.manix.manix()<CR>", { silent = true, buffer = ev.buf }, "Nix manual[manix]")
-- end)

lib.reg_lsp("nil_ls", {})

lib.reg_ft_once("nix", function()
    local null_ls = require("null-ls")
    null_ls.register({ null_ls.builtins.formatting.nixpkgs_fmt })
end)
