-- {% raw %}
local reg_ft = require("lib").reg_ft
reg_ft("ledger", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.foldmethod = "marker"
    vim.opt_local.foldmarker = "{{{,}}}"
    vim.opt_local.commentstring = "; %s"
end)
-- {% endraw %}
