local lib = require("lib")

lib.reg_ft("lua", function(ev)
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.foldmethod = "marker"
    vim.opt_local.foldmarker = "{{{,}}}"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
        wk.register({
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
end)

lib.reg_lsp({ "lua_ls" })

lib.reg_ft_once("lua", function()
    local null_ls = require("null-ls")
    null_ls.register({ null_ls.builtins.formatting.stylua })
end)

