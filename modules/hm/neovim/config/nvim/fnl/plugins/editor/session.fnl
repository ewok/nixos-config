(local {: pack : map} (require :lib))

(pack :stevearc/resession.nvim
      {:event [:VeryLazy]
       ;;:dependencies [(pack :tiagovla/scope.nvim {:config true})]
       :config #(let [resession (require :resession)
                      e #(pcall #(vim.cmd "silent e"))]
                  (resession.setup {:buf_filter #(let [buftype (-> (. vim.bo $1)
                                                                   (. :buftype))]
                                                   (case buftype
                                                     :help true
                                                     (where buftype
                                                            (and (not= ""
                                                                       buftype)
                                                                 (not= :acwrite
                                                                       buftype)))
                                                     false
                                                     (where _
                                                            (= ""
                                                               (vim.api.nvim_buf_get_name $1)))
                                                     false
                                                     _ true))
                                    ;;:extensions {:scope {}}
                                    })
                  (when vim.g.auto_load_session
                    (when (= (vim.fn.argc -1) 0)
                      ;(resession.load (vim.fn.getcwd) {:silence_errors true})
                      (vim.fn.timer_start 200
                                          #(do
                                             (resession.load (vim.fn.getcwd)
                                                             {:silence_errors true})
                                             (e)))))
                  (map :n :<leader>sl
                       #(do
                          (resession.load)
                          (e)
                          (vim.notify " Session loaded" :INFO {:title :Session}))
                       {:silent true} "Session Load")
                  (map :n :<leader>su
                       #(do
                          (resession.load (vim.fn.getcwd)
                                          {:silence_errors true})
                          (e)
                          (vim.notify "Session loaded" :INFO {:title :Session}))
                       {:silent true} "Session Load")
                  (map :n :<leader>ss
                       #(do
                          (resession.save)
                          (vim.notify "Session saved success" :INFO
                                      {:title :Session}))
                       {:silent true} "Session Save")
                  (map :n :<leader>sq
                       #(if (not= (resession.get_current) nil)
                            (do
                              (resession.save)
                              (vim.cmd :qall))
                            (do
                              (resession.save (vim.fn.getcwd) {:notify false})
                              (vim.cmd :qall))
                            ;;(do
                            ;;  (vim.ui.input {:prompt "Session Name(enter to use path): "}
                            ;;                #(case $1
                            ;;                   "" (do
                            ;;                        (resession.save (vim.fn.getcwd)
                            ;;                                        {:notify false})
                            ;;                        (vim.cmd :qall))
                            ;;                   nil (vim.notify :Canceled :INFO
                            ;;                                   {:title :Session})
                            ;;                   _ (do
                            ;;                       (resession.save $1
                            ;;                                       {:notify false})
                            ;;                       (vim.cmd :qall)))))
                            ) {:silent true}
                       "Session Quit")
                  (map :n :<leader>sd
                       #(let [(ok _) (pcall resession.delete)]
                          (if ok
                              (vim.notify "Session deleted success" :INFO
                                          {:title :Session})
                              (vim.notify "Session deleted failure" :ERROR
                                          {:title :Session})))
                       {:silent true} "Session Delete"))})
