local lib = require("lib")
local conf = require("conf")

lib.reg_lsp("terraformls", {
    root_markers = { ".terraform", ".terraform.lock.hcl", "tfstate.tf", "versions.tf", "provider.tf" },
})

lib.reg_lsp("tflint", {
    root_markers = { ".terraform", ".terraform.lock.hcl", "tfstate.tf", "versions.tf", "provider.tf" },
})

lib.reg_ft_once("terraform", function()
    require("nvim-treesitter").install({ "terraform" })
    if conf.packages.conform then
        require("conform").formatters_by_ft.terraform = { "terraform_fmt" }
    end
    if conf.packages.nvim_lint then
        require("lint").linters_by_ft = {
            terraform = { "tfsec", "tflint" },
        }
    end
    if conf.packages.null then
        local null_ls = require("null-ls")
        null_ls.register({
            null_ls.builtins.formatting.terraform_fmt,
            null_ls.builtins.diagnostics.tfsec,
            null_ls.builtins.diagnostics.terraform_validate,
        })
    end
end)

lib.reg_ft("terraform", function()
    pcall(vim.treesitter.start)
end)
