local lib = require("lib")

lib.reg_ft("clojure", function(ev)
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2

    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
        wk.register({
            c = { name = "Connect[conjure]" },
            ec = { name = "Eval Comment[conjure]" },
            e = { name = "Eval[conjure]" },
            l = { name = "Log[conjure]" },
            r = { name = "Refresh[conjure]" },
            s = { name = "Session[conjure]" },
            t = { name = "Test[conjure]" },
            v = { name = "View[conjure]" },
        }, {
            prefix = "<leader>c",
            mode = "n",
            buffer = ev.buf,
        })
    end
end)

lib.reg_lsp({ "clojure_lsp" })

lib.reg_ft_once("clojure", function()
    local null_ls = require("null-ls")
    null_ls.register({ null_ls.builtins.formatting.zprint })
end)
