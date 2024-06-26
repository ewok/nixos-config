(local {: pack} (require :lib))
(local conf (require :conf))

(pack :ravibrock/spellwarn.nvim
      {:config #(let [sw (require :spellwarn)]
                  (sw.setup {}))
       :keys [{1 :<leader>ts
               2 #(let [sw (require :spellwarn)]
                    (if vim.wo.spell
                        (do
                          (sw.disable)
                          (set vim.wo.spell false)
                          (vim.notify "Spellchecking is off" :INFO
                                      {:title :Spell}))
                        (do
                          (set vim.bo.spellfile
                               (.. conf.notes_dir "/dict-en.utf-8.add,"
                                   conf.notes_dir :/dict-ru.utf-8.add))
                          (set vim.bo.spelllang "en_us,ru_ru")
                          (set vim.o.spell true)
                          (sw.enable)
                          (vim.notify "Spellchecking is on" :INFO
                                      {:title :Spell}))))
               :mode :n
               :desc "Toggle spelling"}]})
