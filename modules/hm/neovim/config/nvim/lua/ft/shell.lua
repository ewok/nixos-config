local reg_ft_once = require("lib").reg_ft_once

for _, x in ipairs({ "bash", "sh", "zsh" }) do
    reg_ft_once(x, function()
        require("conform").formatters_by_ft[x] = { "shellharden", "shfmt" }
    end)
end
