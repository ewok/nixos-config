(local path (.. conf.notes-dir :/dict-en.utf-8.add))
(local words [])

(each [word (: (io.open path :r) :lines)]
  (table.insert words word))

{:cmd [:ltex-ls]
 :filetypes [:markdown :text]
 :flags {:debounce_text_changes 300}
 :settings {:ltex {:enabled [:markdown]
                   :language :en-US
                   :dictionary {:en-US words :en-GB words}}}}
