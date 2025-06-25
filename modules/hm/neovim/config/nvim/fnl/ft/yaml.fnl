(local lib (require :lib))

(lib.reg_ft :yaml (fn [ev]
                    (let [map lib.map
                          (wk_ok? wk) (pcall require :which-key)]
                      (set vim.opt_local.expandtab true)
                      (set vim.opt_local.shiftwidth 2)
                      (set vim.opt_local.tabstop 2)
                      (set vim.opt_local.softtabstop 2)
                      (map :n :<leader>ckb ":KustomizeBuild<cr>"
                           {:noremap true :buffer ev.buf} "Kustomize Build")
                      (map :n :<leader>ckk ":KustomizeListKinds<cr>"
                           {:noremap true :buffer ev.buf} "List kinds")
                      (map :n :<leader>ckl ":KustomizeListResources<cr>"
                           {:noremap true :buffer ev.buf} "List resources")
                      (map :n :<leader>ckp ":KustomizePrintResources<cr>"
                           {:noremap true :buffer ev.buf}
                           "Print resources in folder")
                      (map :n :<leader>ckv ":KustomizeValidate<cr>"
                           {:noremap true :buffer ev.buf} "Validate manifests")
                      (map :n :<leader>ckd ":KustomizeDeprecations<cr>"
                           {:noremap true :buffer ev.buf}
                           "Check for deprecations")
                      (when wk_ok?
                        (wk.add {1 :<leader>ck
                                 :name "[ft] Kustomize"
                                 :buffer ev.buf})))))

(lib.reg_ft_once :yaml
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.prettier])))
