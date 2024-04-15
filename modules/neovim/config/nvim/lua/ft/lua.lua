local reg_ft = require "lib".reg_ft

reg_ft("lua", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.foldmethod = 'marker'
    vim.opt_local.foldmarker = '{{{,}}}'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    local wk_ok, wk = pcall(require, 'which-key')
    if wk_ok then
        wk.register({
            ec = { name = "Eval Comment[conjure]" },
            e = { name = "Eval[conjure]" },
            l = { name = "Log[conjure]" },
            r = { name = "Reset[conjure]" }
        }, {
            prefix = "<leader>c",
            mode = "n",
            buffer = 0
        })
    end
end)
