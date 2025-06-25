(local lib (require :lib))
(local util (require :lspconfig.util))

(lib.reg_lsp :terraformls
             {:root_dir (util.root_pattern [:.terraform
                                            :.terraform.lock.hcl
                                            :tfstate.tf
                                            :versions.tf
                                            :provider.tf]
                                           :.git)})

(lib.reg_lsp :tflint {})

(lib.reg_ft_once :terraform
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.terraform_fmt
                                       null-ls.builtins.diagnostics.tfsec
                                       null-ls.builtins.diagnostics.terraform_validate])))
