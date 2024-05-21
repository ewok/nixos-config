local reg_ft = require("lib").reg_ft

reg_ft("python", function(ev)
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
        wk.register({
            c = { name = "Connect[conjure]" },
            ec = { name = "Eval Comment[conjure]" },
            e = { name = "Eval[conjure]" },
            l = { name = "Log[conjure]" },
            r = { name = "Reset[conjure]" },
        }, {
            prefix = "<leader>c",
            mode = "n",
            buffer = ev.buf,
        })
    end
    local map = require("lib").map
    map("n", "<leader>cv", "<cmd>VenvSelect<cr>", { noremap = true, buffer = true }, "Select VirtualEnv")
end)
