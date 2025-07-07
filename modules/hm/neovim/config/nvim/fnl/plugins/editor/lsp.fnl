(local {: pack : map : lsps : umap : open-file} (require :lib))
(local conf (require :conf))

(map :n :<leader>li :<cmd>LspInfo<CR> {:noremap true} :Info)
(map :n :<leader>ls :<cmd>LspStart<CR> {:noremap true} :Start)
(map :n :<leader>lS :<cmd>LspStop<CR> {:noremap true} :Stop)
(map :n :<leader>lr :<cmd>LspRestart<CR> {:noremap true} :Restart)

(map :n :<leader>ll :<cmd>LspLog<CR> {:noremap true} :Log)
; (each [_ x (ipairs [:gra :grn :gri :grr])]
;   (umap :n x {}))

(tset vim.lsp.handlers :textDocument/hover
      (vim.lsp.with vim.lsp.handlers.hover
        {:border :rounded}))

(tset vim.lsp.handlers :textDocument/signatureHelp
      (vim.lsp.with vim.lsp.handlers.signature_help
        {:border :rounded}))

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
                                                (map :n :<leader>cdw
                                                     "<cmd>lua vim.diagnostic.setqflist()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Code workspace diagnostics")
                                                (map :n :<leader>cdd
                                                     "<cmd>lua vim.diagnostic.setloclist()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Code document diagnostics")
                                                (map :n :K
                                                     "<cmd>lua vim.lsp.buf.hover()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Hover documentation")
                                                (map :n :gd
                                                     "<cmd>lua require('goto-preview').goto_preview_definition()<cr>"
                                                     ; "<CMD>Glance definitions<CR>"
                                                     ; "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Go to definition")
                                                (map :n :gD
                                                     "<cmd>lua require('goto-preview').goto_preview_declaration()<cr>"
                                                     ; "<cmd>vsplit | lua vim.lsp.buf.declaration()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Go to declaration")
                                                (map :n :gi
                                                     "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>"
                                                     ; "<CMD>Glance implementations<CR>"
                                                     ; "<cmd>vsplit | lua vim.lsp.buf.implementation()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Go to implementation")
                                                (map :n :go
                                                     "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>"
                                                     ; "<CMD>Glance type_definitions<CR>"
                                                     ; "<cmd>lua vim.lsp.buf.type_definition()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Go to type definition")
                                                (map :n :gr
                                                     "<cmd>lua require('goto-preview').goto_preview_references()<cr>"
                                                     ; "<CMD>Glance references<CR>"
                                                     ; "<cmd>lua vim.lsp.buf.references()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Go to reference")
                                                (map :n :gP
                                                     "<cmd>lua require('goto-preview').close_all_win()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Close all float preview")
                                                (map :n :<leader>cn
                                                     "<cmd>lua vim.lsp.buf.rename()<cr>"
                                                     {:buffer bufnr
                                                      :noremap true}
                                                     "[lsp] Rename symbol")
                                                (map :n :<leader>ca
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
                                                  (map :i :<C-S>
                                                       #(vim.lsp.buf.signature_help)
                                                       {:buffer bufnr
                                                        :noremap true}
                                                       "[lsp] Show signature"))
                                                (if vim.lsp.buf.range_code_action
                                                    (map :x :<leader>ca
                                                         "<cmd>lua vim.lsp.buf.range_code_action()<cr>"
                                                         {:buffer bufnr
                                                          :noremap true}
                                                         "[lsp] Execute code action")
                                                    (map :x :<leader>ca
                                                         "<cmd>lua vim.lsp.buf.code_action()<cr>"
                                                         {:buffer bufnr
                                                          :noremap true}
                                                         "[lsp] Execute code action"))
                                                (vim.diagnostic.config {:virtual_text true})))))})

; https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
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
 (pack :rmagatti/goto-preview
       {:config #(let [gp (require :goto-preview)
                       select-to-edit-map {:default :edit
                                           :horizontal :new
                                           :vertical :vnew
                                           :tab :tabedit}]
                   (fn open-preview [preview-win type]
                     (fn []
                       (let [command (. select-to-edit-map type)
                             orig-window (. (vim.api.nvim_win_get_config preview-win)
                                            :win)
                             cursor-position (vim.api.nvim_win_get_cursor preview-win)
                             filename (vim.api.nvim_buf_get_name 0)]
                         (vim.api.nvim_win_close preview-win
                                                 gp.conf.force_close)
                         (open-file orig-window filename cursor-position
                                    command))))

                   (fn post-open-hook [buf win]
                     (map :n :<C-v> (open-preview win :vertical) {:buffer buf})
                     (map :n :<CR> (open-preview win :default) {:buffer buf})
                     (map :n :<C-s> (open-preview win :horizontal)
                          {:buffer buf})
                     (map :n :<C-t> (open-preview win :tab) {:buffer buf})
                     (map :n :q :<cmd>q<cr> {:buffer buf}))

                   (gp.setup {:stack_floating_preview_windows false
                              :post_open_hook post-open-hook
                              :post_close_hook #(each [_ x (ipairs [:<C-v>
                                                                    :<CR>
                                                                    :<C-s>
                                                                    :<C-t>
                                                                    :q])]
                                                  (umap [:n] x {:buffer $1}))}))})
 ; (pack :neovim/nvim-lspconfig
 ;       {:event [:BufReadPre :BufNewFile]
 ;        :config #(let [lsp (require :lspconfig)]
 ;                   (each [lsp-name settings (pairs lsps)]
 ;                     (let [server (. lsp lsp-name)]
 ;                       (print lsp-name)
 ;                       (vim.lsp.config lsp-name settings)
 ;                       (vim.lsp.enable lsp-name))))})
 (pack :VonHeikemen/lsp-zero.nvim
       {:branch :v4.x
        :event [:BufReadPre :BufNewFile]
        :dependencies [; :ray-x/lsp_signature.nvim
                       ; {1 :SmiteshP/nvim-navic
                       ;  :config #((-> (require :nvim-navic)
                       ;                (. :setup)) {:highlight true})}
                       ]
        :config #(let [icons conf.icons.diagnostic
                       lsp_zero (require :lsp-zero)
                       lsp (require :lspconfig) ; sig (require :lsp_signature)
                       blink (require :blink.cmp)]
                   (lsp_zero.set_sign_icons {:error icons.Error
                                             :warn icons.Warn
                                             :hint icons.Hint
                                             :info icons.Info})
                   (each [lsp-name settings (pairs lsps)]
                     (let [server (. lsp lsp-name)]
                       (set settings.handlers [lsp_zero.default_setup])
                       (set settings.capabilities
                            (blink.get_lsp_capabilities settings.capabilities))
                       (server.setup settings))))})
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
                :desc "[null] Format file or range"}]})]
