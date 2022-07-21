(local {: pack : map! : get_buf_ft} (require :lib))

(local fmt-white-list {:bash true
                       :clojure true
                       :fennel true
                       :lua true
                       :markdown true
                       :nix true
                       :python true
                       :sh true
                       :yaml true
                       :zsh true})

(local hover-white-list {:nix true :fish true :dockerfile true :terraform true})

(local code-action-white-list {:nix true})

(fn config []
  (let [null-ls (require :null-ls)]
    (null-ls.setup {:on_attach (fn [_ bufnr]
                                 (do
                                   (when (. fmt-white-list (get_buf_ft bufnr))
                                     (map! [:n] :<leader>cf
                                           #(vim.lsp.buf.format {:filter (fn [client]
                                                                           (= client.name
                                                                              :null-ls))
                                                                 : bufnr})
                                           {:buffer bufnr}
                                           "Format buffer[NULL-LS]"))
                                   (when (. code-action-white-list
                                            (get_buf_ft bufnr))
                                     (map! [:n] :<leader>ca
                                           #(vim.lsp.buf.code_action {:filter (fn [client]
                                                                                (= client.name
                                                                                   :null-ls))
                                                                      : bufnr})
                                           {:buffer bufnr}
                                           "Show code action[NULL-LS]"))
                                   (when (. hover-white-list (get_buf_ft bufnr))
                                     (map! [:n] :K #(vim.lsp.buf.hover)
                                           {:buffer bufnr}
                                           "Show help information[NULL-LS]")
                                     (map! [:n] :gh #(vim.lsp.buf.hover)
                                           {:buffer bufnr}
                                           "Show help information[NULL-LS]"))))
                    :sources [;; Text
                              (null-ls.builtins.diagnostics.markdownlint.with {:extra_args [:--disable
                                                                                            :MD013
                                                                                            :MD024]})
                              (null-ls.builtins.formatting.markdownlint.with {:extra_args [:--disable
                                                                                           :MD013
                                                                                           :MD024]})
                              ;; Clojure
                              null-ls.builtins.diagnostics.clj_kondo
                              null-ls.builtins.formatting.joker
                              ;; Fennel
                              null-ls.builtins.formatting.fnlfmt
                              ;; Nix
                              null-ls.builtins.formatting.nixpkgs_fmt
                              null-ls.builtins.code_actions.statix
                              null-ls.builtins.diagnostics.statix
                              ;; Shell
                              null-ls.builtins.diagnostics.fish
                              null-ls.builtins.formatting.shfmt
                              ;; Docker
                              null-ls.builtins.diagnostics.hadolint
                              ;; Terraform
                              ; null-ls.builtins.formatting.terraform_fmt
                              null-ls.builtins.diagnostics.terraform_validate
                              null-ls.builtins.diagnostics.tfsec
                              ;; Python
                              null-ls.builtins.formatting.autopep8
                              null-ls.builtins.formatting.black
                              ;; Go
                              ; null-ls.builtins.formatting.gofmt
                              ;; SQL
                              ; null-ls.builtins.formatting.sql_formatter
                              ;; Json
                              ; null-ls.builtins.formatting.jq
                              ; ; ;; YAML
                              null-ls.builtins.formatting.yq
                              ; null-ls.builtins.diagnostics.yamllint
                              ;; Lua
                              (null-ls.builtins.formatting.stylua.with {:extra_args [:--indent-type=Spaces
                                                                                     :--indent-width=4]})]})))

(pack :nvimtools/none-ls.nvim {: config :event [:BufReadPre :BufNewFile]})
