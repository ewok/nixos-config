local lib = require("lib")
local conf = require("conf")

lib.reg_ft("go", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4

    pcall(vim.treesitter.start)
end)

lib.reg_lsp("gopls", {})

lib.reg_ft_once("go", function()
    require("nvim-treesitter").install({ "go" })
    if conf.packages.conform then
        require("conform").formatters_by_ft.go = { "gofumpt", "goimports" }
    end
    if conf.packages.nvim_lint then
        require("lint").linters_by_ft = {
            go = { "golangcilint" },
        }
    end
    if conf.packages.null then
        local null_ls = require("null-ls")
        null_ls.register({
            null_ls.builtins.diagnostics.golangci_lint,
            null_ls.builtins.formatting.gofumpt,
            null_ls.builtins.formatting.goimports,
        })
    end
end)
