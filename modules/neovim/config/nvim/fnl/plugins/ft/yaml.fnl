(local {: pack : map!} (require :lib))

[(pack :someone-stole-my-name/yaml-companion.nvim
       {:ft :yaml
        :config #(let [lsp-zero (require :lsp-zero)
                       yamlconfig (require :yaml-companion)
                       cfg (yamlconfig.setup {:handlers [lsp-zero.default_setup]
                                              :schemas [{:name "Kubernetes 1.22.4"
                                                         :uri "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json"}]})
                       telescope (require :telescope)
                       lspconfig (require :lspconfig)]
                   (telescope.load_extension :yaml_schema)
                   (lspconfig.yamlls.setup cfg)
                   (map! :n :<leader>cs
                         "<cmd>lua require('yaml-companion').open_ui_select()<CR>"
                         {:noremap true} "[ft] Switch Schema"))})
 (pack :allaman/kustomize.nvim
       {:ft :yaml
        :config #(let [kustomize (require :kustomize)]
                   (kustomize.setup {:enable_key_mappings false}))})]
