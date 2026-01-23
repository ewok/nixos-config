local lib = require("lib")

lib.reg_ft("python", function(ev)
    local wk_ok, wk = pcall(require, "which-key")
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    if wk_ok then
        wk.add({
            { "<leader>cC", buffer = ev.buf, group = "Connect[conjure]" },
            { "<leader>ce", buffer = ev.buf, group = "Eval[conjure]" },
            { "<leader>cec", buffer = ev.buf, group = "Eval Comment[conjure]" },
            { "<leader>cl", buffer = ev.buf, group = "Log[conjure]" },
            { "<leader>cr", buffer = ev.buf, group = "Reset[conjure]" },
        })
    end
    lib.map("n", "<leader>cv", "<cmd>VenvSelect<cr>", { noremap = true, buffer = true }, "Select VirtualEnv")

    pcall(vim.treesitter.start)
end)

lib.reg_lsp("pyright", {})

lib.reg_ft_once("python", function()
    require("conform").formatters_by_ft.python = { "isort", "black" }
    require("nvim-treesitter").install({ "python" })
end)
