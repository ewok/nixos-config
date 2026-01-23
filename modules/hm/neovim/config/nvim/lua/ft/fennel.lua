local lib = require("lib")
local reg_ft, reg_lsp, reg_ft_once = lib.reg_ft, lib.reg_lsp, lib.reg_ft_once

reg_ft("fennel", function(ev)
    local wk_ok, wk = pcall(require, "which-key")

    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2

    if wk_ok then
        wk.add({
            { "<leader>ce", { buffer = ev.buf, group = "Eval[conjure]" } },
            { "<leader>cec", { buffer = ev.buf, group = "Eval Comment[conjure]" } },
            { "<leader>cl", { buffer = ev.buf, group = "Log[conjure]" } },
            { "<leader>cp", "<cmd>FnlPeek<cr>", { buffer = ev.buf, desc = "[fnl] Convert buffer" } },
            { "<leader>cr", { buffer = ev.buf, group = "Reset[conjure]" } },
            { "<leader>ct", { buffer = ev.buf, group = "Test[conjure]" } },
        })
    end

    pcall(vim.treesitter.start)
end)

reg_lsp("fennel_ls", { settings = { ["fennel-ls"] = { extra_globals = { "vim" } } } })

reg_ft_once("fennel", function()
    require("conform").formatters_by_ft.fennel = { "fnlfmt" }
    require("nvim-treesitter").install({ "fennel" })
end)
