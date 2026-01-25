local reg_ft_once = require("lib").reg_ft_once
local conf = require("conf")

for _, x in ipairs({ "bash", "sh", "zsh" }) do
    reg_ft_once(x, function()
        if conf.packages.conform then
            require("conform").formatters_by_ft[x] = { "shellharden", "shfmt" }
        end
        if conf.packages.null then
            local null_ls = require("null-ls")
            null_ls.register({
                null_ls.builtins.formatting.shellharden,
                null_ls.builtins.formatting.shfmt,
            })
        end
    end)
end
