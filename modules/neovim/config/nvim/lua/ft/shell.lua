local lib = require("lib")

for _, x in ipairs({ "bash", "sh", "zsh" }) do
    lib.reg_ft_once(x, function()
        local null_ls = require("null-ls")
        null_ls.register({ null_ls.builtins.formatting.nixpkgs_fmt })
    end)
end
