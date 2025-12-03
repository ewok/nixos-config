local reg_ft_once = require("lib").reg_ft_once

for _, x in ipairs({ "bash", "sh", "zsh" }) do
    reg_ft_once(x, function()
        local null_ls = require("null-ls")
        null_ls.register({
            null_ls.builtins.formatting.shellharden,
            null_ls.builtins.formatting.shfmt,
        })
    end)
end
