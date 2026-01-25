local lib = require("lib")
local conf = require("conf")

lib.reg_ft("clojure", function(ev)
    local wk_ok, wk = pcall(require, "which-key")

    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2

    if wk_ok then
        wk.add({
            { "<leader>cC", { buffer = ev.buf, group = "Connect[conjure]" } },
            { "<leader>cec", { buffer = ev.buf, group = "Eval Comment[conjure]" } },
            { "<leader>ce", { buffer = ev.buf, group = "Eval[conjure]" } },
            { "<leader>cl", { buffer = ev.buf, group = "Log[conjure]" } },
            { "<leader>cr", { buffer = ev.buf, group = "Refresh[conjure]" } },
            { "<leader>cs", { buffer = ev.buf, group = "Session[conjure]" } },
            { "<leader>ct", { buffer = ev.buf, group = "Test[conjure]" } },
            { "<leader>cv", { buffer = ev.buf, group = "View[conjure]" } },
        })
    end

    pcall(vim.treesitter.start)
end)

lib.reg_lsp("clojure_lsp", {
    root_markers = {
        "project.clj",
        "deps.edn",
        "build.boot",
        "shadow-cljs.edn",
        "bb.edn",
    },
})

lib.reg_ft_once("clojure", function()
    require("nvim-treesitter").install({ "clojure" })
    if conf.packages.conform then
        require("conform").formatters_by_ft.clojure = { "joker" }
    end
    if conf.packages.null then
        local null_ls = require("null-ls")
        null_ls.register({ null_ls.builtins.formatting.joker })
    end
end)
