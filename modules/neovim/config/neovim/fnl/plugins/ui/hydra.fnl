;; Hydra
(local {: pack} (require :lib))
(local hint "^Spell Langs       ^
       ^
       ^^^^^_1_ %{spell?} spell
       ^^^^^_2_ %{en_us?} en
       ^^^^^_3_ %{ru_ru?} ru
       ^^^^^_q_ quit
       ")

(fn config []
  (let [hydra (require :hydra)]
    (hydra {:name :Spell
            : hint
            :config {:invoke_on_body true
                     :hint {:border :rounded
                            :position :middle
                            :funcs {:spell? #(if vim.wo.spell "[x]" "[ ]")
                                    :en_us? #(if (= vim.bo.spelllang :en_us)
                                                 "[x]"
                                                 "[ ]")
                                    :ru_ru? #(if (= vim.bo.spelllang :ru_ru)
                                                 "[x]"
                                                 "[ ]")}}}
            :mode :n
            :body :<leader>7
            :heads [[:1 #(set vim.wo.spell (not vim.wo.spell)) {:desc :toggle}]
                    [:2
                     #(do
                        (set vim.wo.spell true)
                        (set vim.bo.spelllang :en_us)
                        (set vim.bo.spellfile
                             (.. conf.notes-dir :/dict-en.utf-8.add)))
                     {}]
                    [:3
                     #(do
                        (set vim.wo.spell true)
                        (set vim.bo.spelllang :ru_ru)
                        (set vim.bo.spellfile
                             (.. conf.notes-dir :/dict-ru.utf-8.add)))
                     {}]
                    [:q nil {:exit true}]]})))

(pack :anuvyklack/hydra.nvim {: config :event [:BufReadPre :BufNewFile]})
