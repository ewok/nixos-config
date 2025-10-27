(local lib (require :lib))

(lib.reg_lsp :terraformls
             {:root_markers [:.terraform
                             :.terraform.lock.hcl
                             :tfstate.tf
                             :versions.tf
                             :provider.tf]})

(lib.reg_lsp :tflint {:root_markers [:.terraform
                                     :.terraform.lock.hcl
                                     :tfstate.tf
                                     :versions.tf
                                     :provider.tf]})

(lib.reg_ft_once :terraform
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.terraform_fmt
                                       null-ls.builtins.diagnostics.tfsec
                                       null-ls.builtins.diagnostics.terraform_validate])))
