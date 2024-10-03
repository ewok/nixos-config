(local {: pack : map} (require :lib))

[(pack :MagicDuck/grug-far.nvim
       {:config #(let [grug (require :grug-far)]
                   (grug.setup {:keymaps {:replace {:n :X}
                                          :qflist {:n :<c-q>}
                                          :syncLocations {:n :<c-r>}
                                          :syncLine {:n :r}
                                          :close {:n :q}
                                          :historyOpen {:n :<localleader>t}
                                          :historyAdd {:n :<localleader>a}
                                          :refresh {:n :R}
                                          :gotoLocation {:n :<enter>}
                                          :pickHistoryEntry {:n :<enter>}
                                          :abort {:n :<c-c> :i :<c-c>}}}))
        :cmd [:GrugFar]
        :keys [{1 :<leader>fr
                2 :<cmd>GrugFar<cr>
                :mode :n
                :desc "Find and Replace [global]"}]})
 ;(pack :chrisgrieser/nvim-rip-substitute
 ;      {:cmd [:RipSubstitute]
 ;       ; :init #(do
 ;       ;          (map :n :MR (fn []
 ;       ;                        vim.cmd
 ;       ;                        (.. ":RipSubstitute ("
 ;       ;                            (string.gsub (vim.fn.getreg "/") "[\\<>]" "")
 ;       ;                            ")<cr>"))
 ;       ;               {:noremap true :expr true})
 ;       ;          (map :v :MR (fn []
 ;       ;                        vim.cmd
 ;       ;                        (.. ":RipSubstitute ("
 ;       ;                            (string.gsub (vim.fn.getreg "/") "[\\<>]" "")
 ;       ;                            ")<cr>"))
 ;       ;               {:noremap true :expr true}))
 ;       :config #(let [rs (require :rip-substitute)]
 ;                  (rs.setup {:keymaps {:confirm :<c-l>
 ;                                       :abort :<esc>
 ;                                       :prevSubst :<c-k>
 ;                                       :nextSubst :<c-j>
 ;                                       :insertModeConfirm :<c-l>}
 ;                             :editingBehavior {:autoCaptureGroups true}
 ;                             :prefill {:startInReplaceLineIfPrefill true}}))
 ;       :keys [{1 :<leader>fr
 ;               2 #(vim.cmd (.. "RipSubstitute (" (vim.fn.expand :<cword>) ")"))
 ;               :mode [:n]
 ;               :desc "Find and Replace [buffer]"}
 ;              {1 :<leader>fr
 ;               2 #(vim.cmd :RipSubstitute)
 ;               :mode [:x]
 ;               :desc "Find and Replace [buffer]"}]})
 ]
