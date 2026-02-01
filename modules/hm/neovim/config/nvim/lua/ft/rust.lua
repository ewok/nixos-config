local lib = require("lib")
local conf = require("conf")

lib.reg_ft("rust", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4

    pcall(vim.treesitter.start)
end)

lib.reg_lsp("rust_analyzer", {})

lib.reg_ft_once("rust", function()
    require("nvim-treesitter").install({ "rust" })
    if conf.packages.conform then
        require("conform").formatters_by_ft.rust = { "rustfmt" }
    end
    if conf.packages.null then
        local null_ls = require("null-ls")
        null_ls.register({ null_ls.builtins.formatting.rustfmt })
    end
end)
