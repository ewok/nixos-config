local lib = require("lib")

lib.reg_ft("go", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4

    pcall(vim.treesitter.start)
end)

lib.reg_lsp("gopls", {})

lib.reg_ft_once("go", function()
    require("conform").formatters_by_ft.go = { "gofumpt", "goimports" }
    require("lint").linters_by_ft = {
        go = { "golangcilint" },
    }
    require("nvim-treesitter").install({ "go" })
end)
