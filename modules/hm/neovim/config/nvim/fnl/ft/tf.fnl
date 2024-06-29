(local lib (require :lib))

(lib.reg_lsp :terraformls {})

(lib.reg_ft_once :terraform
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.diagnostics.tfsec
                                       null-ls.builtins.formatting.terraform_fmt])))
