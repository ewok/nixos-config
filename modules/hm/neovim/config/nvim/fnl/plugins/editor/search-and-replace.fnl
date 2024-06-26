(local {: pack} (require :lib))

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
        :keys [{1 :<leader>fR
                2 :<cmd>GrugFar<cr>
                :mode :n
                :desc "Find and Replace [global]"}]})
 (pack :chrisgrieser/nvim-rip-substitute
       {:config #(let [rs (require :rip-substitute)]
                   (rs.setup {:keymaps {:confirm :<c-l>
                                        :abort :<esc>
                                        :prevSubst :<c-k>
                                        :nextSubst :<c-j>
                                        :insertModeConfirm :<c-l>}
                              :editingBehavior {:autoCaptureGroups true}
                              :prefill {:startInReplaceLineIfPrefill false}}))
        :keys [{1 :<leader>fr
                2 #(let [rs (require :rip-substitute)]
                     (rs.sub))
                :mode [:n :x]
                :desc "Find and Replace [buffer]"}]})]
