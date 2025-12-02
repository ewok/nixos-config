(local {: pack : map : lsps : umap : open-file} (require :lib))
(local conf (require :conf))

[(pack :kosayoda/nvim-lightbulb
       {:event [:BufReadPost :BufNewFile]
        :config #(let [bulb (require :nvim-lightbulb)]
                   (bulb.setup {:ignore []
                                :sign {:enabled true :priority 15}
                                :float {:enabled false
                                        :text "💡"
                                        :win_opts {}}
                                :virtual_text {:enabled false
                                               :text "💡"
                                               :hl_mode :replace}
                                :status_text {:enabled false
                                              :text "💡"
                                              :text_unavailable ""}})
                   (vim.fn.sign_define :LightBulbSign
                                       {:text "💡"
                                        :texthl :DiagnosticSignWarn
                                        :linehl ""
                                        :numhl ""})
                   (vim.api.nvim_create_autocmd [:CursorHold :CursorHoldI]
                                                {:pattern "*"
                                                 :callback #(bulb.update_lightbulb)}))})
 (pack :SmiteshP/nvim-navic
       {:event [:BufReadPre :BufNewFile]
        :config #(let [navic (require :nvim-navic)]
                   (navic.setup {:highlight true})
                   (vim.api.nvim_create_autocmd :LspAttach
                                                {:desc "LSP navic"
                                                 :callback (fn [event]
                                                             (let [client (let [id (vim.tbl_get event
                                                                                                :data
                                                                                                :client_id)]
                                                                            (and id
                                                                                 (vim.lsp.get_client_by_id id)))]
                                                               (when client
                                                                 (when client.server_capabilities.documentSymbolProvider
                                                                   (navic.attach client
                                                                                 event.buf)))))}))})
 (pack :nvimtools/none-ls.nvim
       {:config #(let [nl (require :null-ls)]
                   (nl.setup))
        :keys [{1 :<leader>cf
                2 #(let [gen (require :null-ls.generators)
                         meth (require :null-ls.methods)
                         bufnr (vim.api.nvim_get_current_buf)
                         formatting-enabled? (fn [bufnr]
                                               (let [ft (vim.api.nvim_buf_get_option bufnr
                                                                                     :filetype)
                                                     generators (gen.get_available ft
                                                                                   meth.internal.FORMATTING)]
                                                 (> (length generators) 0)))]
                     (vim.lsp.buf.format {:filter (fn [client]
                                                    (let [null_supported (formatting-enabled? bufnr)]
                                                      (if (and (= client.name
                                                                  :null-ls)
                                                               null_supported)
                                                          (do
                                                            (vim.notify (.. "Formatting with: "
                                                                            client.name)
                                                                        nil
                                                                        {:title :FMT})
                                                            true)
                                                          (if null_supported
                                                              false
                                                              (if (client.supports_method :textDocument/formatting)
                                                                  (do
                                                                    (vim.notify (.. "Formatting with: "
                                                                                    client.name)
                                                                                nil
                                                                                {:title :FMT})
                                                                    true)
                                                                  false)))))
                                          : bufnr}))
                :mode [:n :v]
                :desc "[null] Format file or range"}]})
 (pack :neovim/nvim-lspconfig
       {:event [:BufReadPre :BufNewFile]
        :init #(do
                 (map :n :<leader>li :<cmd>LspInfo<CR> {:noremap true} :Info)
                 (map :n :<leader>ls :<cmd>LspStart<CR> {:noremap true} :Start)
                 (map :n :<leader>lS :<cmd>LspStop<CR> {:noremap true} :Stop)
                 (map :n :<leader>lr :<cmd>LspRestart<CR> {:noremap true}
                      :Restart)
                 (map :n :<leader>ll :<cmd>LspLog<CR> {:noremap true} :Log)
                 (each [_ x (ipairs [:gra :grn :gri :grr :grt])]
                   (pcall umap :n x {})))
        :cmd [:LspInfo :LspStart :LspStop :LspRestart :LspLog]
        :config #(let [blink (require :blink.cmp)]
                   (tset vim.lsp.handlers :textDocument/hover
                         (vim.lsp.with vim.lsp.handlers.hover
                           {:border :rounded}))
                   (tset vim.lsp.handlers :textDocument/signatureHelp
                         (vim.lsp.with vim.lsp.handlers.signature_help
                           {:border :rounded}))
                   (each [typ icon (pairs (. conf.icons :diagnostic))]
                     (let [hl (.. :DiagnosticSign typ)]
                       ;; numhl hl - to highlight numbers as well
                       (vim.fn.sign_define hl {:text icon :texthl hl})))
                   (vim.api.nvim_create_autocmd :LspAttach
                                                {:desc "LSP navic"
                                                 :callback (fn [event]
                                                             (let [client (let [id (vim.tbl_get event
                                                                                                :data
                                                                                                :client_id)]
                                                                            (and id
                                                                                 (vim.lsp.get_client_by_id id)))
                                                                   bufnr event.buf]
                                                               (when client
                                                                 (do
                                                                   (map :n
                                                                        :<leader>cdw
                                                                        "<cmd>lua vim.diagnostic.setqflist()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Code workspace diagnostics")
                                                                   (map :n
                                                                        :<leader>cdd
                                                                        ; "<cmd>lua vim.diagnostic.setloclist()<cr>"
                                                                        "<cmd>lua require('telescope.builtin').diagnostics()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Code document diagnostics")
                                                                   (map :n :K
                                                                        "<cmd>lua vim.lsp.buf.hover()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Hover documentation")
                                                                   (map :n :gd
                                                                        ; "<cmd>lua require('goto-preview').goto_preview_definition()<cr>"
                                                                        "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>"
                                                                        ; "<CMD>Glance definitions<CR>"
                                                                        ; "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Go to definition")
                                                                   (map :n :gD
                                                                        ; "<cmd>lua require('goto-preview').goto_preview_declaration()<cr>"
                                                                        ; "<cmd>lua require('telescope.builtin').lsp_declarations()<cr>"
                                                                        "<cmd>vsplit | lua vim.lsp.buf.declaration()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Go to declaration")
                                                                   (map :n :gi
                                                                        ; "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>"
                                                                        "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>"
                                                                        ; "<CMD>Glance implementations<CR>"
                                                                        ; "<cmd>vsplit | lua vim.lsp.buf.implementation()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Go to implementation")
                                                                   (map :n :go
                                                                        ; "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>"
                                                                        "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>"
                                                                        ; "<CMD>Glance type_definitions<CR>"
                                                                        ; "<cmd>lua vim.lsp.buf.type_definition()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Go to type definition")
                                                                   (map :n :gr
                                                                        ; "<cmd>lua require('goto-preview').goto_preview_references()<cr>"
                                                                        "<cmd>lua require('telescope.builtin').lsp_references()<cr>"
                                                                        ; "<CMD>Glance references<CR>"
                                                                        ; "<cmd>lua vim.lsp.buf.references()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Go to reference")
                                                                   ; (map :n :gP
                                                                   ;      "<cmd>lua require('goto-preview').close_all_win()<cr>"
                                                                   ;      {:buffer bufnr
                                                                   ;       :noremap true}
                                                                   ;      "[lsp] Close all float preview")
                                                                   (map :n
                                                                        :<leader>cn
                                                                        "<cmd>lua vim.lsp.buf.rename()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Rename symbol")
                                                                   (map :n
                                                                        :<leader>ca
                                                                        "<cmd>lua vim.lsp.buf.code_action()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Execute code action")
                                                                   (map :n :gl
                                                                        "<cmd>lua vim.diagnostic.open_float()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Show diagnostic")
                                                                   (map :n "[d"
                                                                        "<cmd>lua vim.diagnostic.goto_prev()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Prev diagnostic")
                                                                   (map :n "]d"
                                                                        "<cmd>lua vim.diagnostic.goto_next()<cr>"
                                                                        {:buffer bufnr
                                                                         :noremap true}
                                                                        "[lsp] Next diagnostic")
                                                                   (when client.server_capabilities.signatureHelpProvider
                                                                     (map :i
                                                                          :<C-S>
                                                                          #(vim.lsp.buf.signature_help)
                                                                          {:buffer bufnr
                                                                           :noremap true}
                                                                          "[lsp] Show signature"))
                                                                   (if vim.lsp.buf.range_code_action
                                                                       (map :x
                                                                            :<leader>ca
                                                                            "<cmd>lua vim.lsp.buf.range_code_action()<cr>"
                                                                            {:buffer bufnr
                                                                             :noremap true}
                                                                            "[lsp] Execute code action")
                                                                       (map :x
                                                                            :<leader>ca
                                                                            "<cmd>lua vim.lsp.buf.code_action()<cr>"
                                                                            {:buffer bufnr
                                                                             :noremap true}
                                                                            "[lsp] Execute code action"))
                                                                   (vim.diagnostic.config {:virtual_lines {:current_line true}})))))})
                   (each [lsp-name settings (pairs lsps)]
                     (set settings.capabilities
                          (blink.get_lsp_capabilities settings.capabilities))
                     (vim.lsp.enable lsp-name)
                     (vim.lsp.config lsp-name settings)))})]
