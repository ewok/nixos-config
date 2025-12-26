local lib = require("lib")

lib.reg_lsp("terraformls", {
    root_markers = { ".terraform", ".terraform.lock.hcl", "tfstate.tf", "versions.tf", "provider.tf" },
})

lib.reg_lsp("tflint", {
    root_markers = { ".terraform", ".terraform.lock.hcl", "tfstate.tf", "versions.tf", "provider.tf" },
})

lib.reg_ft_once("terraform", function()
    require("lint").linters_by_ft = {
        terraform = { "tfsec", "tflint" },
    }
    require("conform").formatters_by_ft.terraform = { "terraform_fmt" }
    -- local null_ls = require("null-ls")
    -- null_ls.register({
    --     -- null_ls.builtins.formatting.terraform_fmt,
    --     null_ls.builtins.diagnostics.tfsec,
    --     null_ls.builtins.diagnostics.terraform_validate,
    -- })
end)
