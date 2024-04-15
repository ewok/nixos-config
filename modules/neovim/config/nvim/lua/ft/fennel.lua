local reg_ft = require "lib".reg_ft

reg_ft("fennel", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2

    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
        wk.register({
            ec = { name = "Eval Comment[conjure]" },
            e = { name = "Eval[conjure]" },
            l = { name = "Log[conjure]" },
            r = { name = "Refresh[conjure]" },
            t = { name = "Test[conjure]" },
        }, {
            prefix = "<leader>c",
            mode = "n",
            buffer = 0
        })
    end
end)
