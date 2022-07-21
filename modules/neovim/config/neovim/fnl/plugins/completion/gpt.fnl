(local {: pack : map!} (require :lib))

(local md {:noremap true :silent true :nowait true})

(pack :robitx/gp.nvim
      {;;:event [:VeryLazy]
       :cmd [:GpChatNew
             :GpChatToggle
             :GpChatFinder
             :GpRewrite
             :GpAppend
             :GpPrepend
             :GpPopup
             :GpEnew
             :GpNew
             :GpVnew
             :GpTabnew]
       :init #(let [wk (require :which-key)]
                (wk.register {:g {:name "generate into new .."}
                              :w {:name :Whisper}}
                             {:mode [:i :n :v] :prefix :<C-g>}) ; -- Chat commands ; vim.keymap.set({"n", "i"}, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
                ; vim.keymap.set({"n", "i"}, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
                ; vim.keymap.set({"n", "i"}, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))
                (map! [:n :i] :<C-g>c :<cmd>GpChatNew<cr> md "New Chat")
                (map! [:n :i] :<C-g>t :<cmd>GpChatToggle<cr> md "Toggle Chat")
                (map! [:n :i] :<C-g>f :<cmd>GpChatFinder<cr> md "Chat Finder") ; ; vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
                ; vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
                ; vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))
                (map! :v :<C-g>c ":<C-u>'<,'>GpChatNew<cr>" md
                      "Visual Chat New")
                (map! :v :<C-g>p ":<C-u>'<,'>GpChatPaste<cr>" md
                      "Visual Chat Paste")
                (map! :v :<C-g>t ":<C-u>'<,'>GpChatToggle<cr>" md
                      "Visual Toggle Chat") ; ; vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat split"))
                ; vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat vsplit"))
                ; vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))
                (map! [:n :i] :<C-g><C-x> "<cmd>GpChatNew split<cr>" md
                      "New Chat split")
                (map! [:n :i] :<C-g><C-v> "<cmd>GpChatNew vsplit<cr>" md
                      "New Chat vsplit")
                (map! [:n :i] :<C-g><C-t> "<cmd>GpChatNew tabnew<cr>" md
                      "New Chat tabnew") ; ; vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New split"))
                ; vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual Chat New vsplit"))
                ; vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions("Visual Chat New tabnew"))
                (map! :v :<C-g><C-x> ":<C-u>'<,'>GpChatNew split<cr>" md
                      "Visual Chat New split")
                (map! :v :<C-g><C-v> ":<C-u>'<,'>GpChatNew vsplit<cr>" md
                      "Visual Chat New vsplit")
                (map! :v :<C-g><C-t> ":<C-u>'<,'>GpChatNew tabnew<cr>" md
                      "Visual Chat New tabnew") ; ; -- Prompt commands ; vim.keymap.set({"n", "i"}, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
                ; vim.keymap.set({"n", "i"}, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
                ; vim.keymap.set({"n", "i"}, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))
                (map! [:n :i] :<C-g>r :<cmd>GpRewrite<cr> md "Inline Rewrite")
                (map! [:n :i] :<C-g>a :<cmd>GpAppend<cr> md "Append (after)")
                (map! [:n :i] :<C-g>b :<cmd>GpPrepend<cr> md "Prepend (before)")
                ; ; vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
                ; vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
                ; vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
                ; vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))
                (map! :v :<C-g>r ":<C-u>'<,'>GpRewrite<cr>" md "Visual Rewrite")
                (map! :v :<C-g>a ":<C-u>'<,'>GpAppend<cr>" md
                      "Visual Append (after)")
                (map! :v :<C-g>b ":<C-u>'<,'>GpPrepend<cr>" md
                      "Visual Prepend (before)")
                (map! :v :<C-g>i ":<C-u>'<,'>GpImplement<cr>" md
                      "Implement selection") ; ; vim.keymap.set({"n", "i"}, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
                ; vim.keymap.set({"n", "i"}, "<C-g>ge", "<cmd>GpEnew<cr>", keymapOptions("GpEnew"))
                ; vim.keymap.set({"n", "i"}, "<C-g>gn", "<cmd>GpNew<cr>", keymapOptions("GpNew"))
                ; vim.keymap.set({"n", "i"}, "<C-g>gv", "<cmd>GpVnew<cr>", keymapOptions("GpVnew"))
                ; vim.keymap.set({"n", "i"}, "<C-g>gt", "<cmd>GpTabnew<cr>", keymapOptions("GpTabnew"))
                (map! [:n :i] :<C-g>gp :<cmd>GpPopup<cr> md :Popup)
                (map! [:n :i] :<C-g>ge :<cmd>GpEnew<cr> md :GpEnew)
                (map! [:n :i] :<C-g>gn :<cmd>GpNew<cr> md :GpNew)
                (map! [:n :i] :<C-g>gv :<cmd>GpVnew<cr> md :GpVnew)
                (map! [:n :i] :<C-g>gt :<cmd>GpTabnew<cr> md :GpTabnew) ; ; vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", keymapOptions("Visual Popup"))
                ; vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", keymapOptions("Visual GpEnew"))
                ; vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", keymapOptions("Visual GpNew"))
                ; vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", keymapOptions("Visual GpVnew"))
                ; vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", keymapOptions("Visual GpTabnew"))
                (map! :v :<C-g>gp ":<C-u>'<,'>GpPopup<cr>" md "Visual Popup")
                (map! :v :<C-g>ge ":<C-u>'<,'>GpEnew<cr>" md "Visual GpEnew")
                (map! :v :<C-g>gn ":<C-u>'<,'>GpNew<cr>" md "Visual GpNew")
                (map! :v :<C-g>gv ":<C-u>'<,'>GpVnew<cr>" md "Visual GpVnew")
                (map! :v :<C-g>gt ":<C-u>'<,'>GpTabnew<cr>" md
                      "Visual GpTabnew") ; ; vim.keymap.set({"n", "i"}, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
                ; vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))
                (map! [:n :i] :<C-g>x :<cmd>GpContext<cr> md "Toggle Context")
                (map! :v :<C-g>x ":<C-u>'<,'>GpContext<cr>" md
                      "Visual Toggle Context") ; ; vim.keymap.set({"n", "i", "v", "x"}, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
                ; vim.keymap.set({"n", "i", "v", "x"}, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))
                (map! [:n :i :v :x] :<C-g>s :<cmd>GpStop<cr> md :Stop)
                (map! [:n :i :v :x] :<C-g>n :<cmd>GpNextAgent<cr> md
                      "Next Agent") ; ; -- optional Whisper commands with prefix <C-g>w ; vim.keymap.set({"n", "i"}, "<C-g>ww", "<cmd>GpWhisper<cr>", keymapOptions("Whisper"))
                ; vim.keymap.set("v", "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", keymapOptions("Visual Whisper"))
                (map! [:n :i] :<C-g>ww :<cmd>GpWhisper<cr> md :Whisper)
                (map! :v :<C-g>ww ":<C-u>'<,'>GpWhisper<cr>" md
                      "Visual Whisper") ; ; vim.keymap.set({"n", "i"}, "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", keymapOptions("Whisper Inline Rewrite"))
                ; vim.keymap.set({"n", "i"}, "<C-g>wa", "<cmd>GpWhisperAppend<cr>", keymapOptions("Whisper Append (after)"))
                ; vim.keymap.set({"n", "i"}, "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", keymapOptions("Whisper Prepend (before) "))
                (map! [:n :i] :<C-g>wr :<cmd>GpWhisperRewrite<cr> md
                      "Whisper Inline Rewrite")
                (map! [:n :i] :<C-g>wa :<cmd>GpWhisperAppend<cr> md
                      "Whisper Append (after)")
                (map! [:n :i] :<C-g>wb :<cmd>GpWhisperPrepend<cr> md
                      "Whisper Prepend (before) ") ; ; vim.keymap.set("v", "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", keymapOptions("Visual Whisper Rewrite"))
                ; vim.keymap.set("v", "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", keymapOptions("Visual Whisper Append (after)"))
                ; vim.keymap.set("v", "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", keymapOptions("Visual Whisper Prepend (before)"))
                (map! :v :<C-g>wr ":<C-u>'<,'>GpWhisperRewrite<cr>" md
                      "Visual Whisper Rewrite")
                (map! :v :<C-g>wa ":<C-u>'<,'>GpWhisperAppend<cr>" md
                      "Visual Whisper Append (after)")
                (map! :v :<C-g>wb ":<C-u>'<,'>GpWhisperPrepend<cr>" md
                      "Visual Whisper Prepend (before)") ; ; vim.keymap.set({"n", "i"}, "<C-g>wp", "<cmd>GpWhisperPopup<cr>", keymapOptions("Whisper Popup"))
                ; vim.keymap.set({"n", "i"}, "<C-g>we", "<cmd>GpWhisperEnew<cr>", keymapOptions("Whisper Enew"))
                ; vim.keymap.set({"n", "i"}, "<C-g>wn", "<cmd>GpWhisperNew<cr>", keymapOptions("Whisper New"))
                ; vim.keymap.set({"n", "i"}, "<C-g>wv", "<cmd>GpWhisperVnew<cr>", keymapOptions("Whisper Vnew"))
                ; vim.keymap.set({"n", "i"}, "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", keymapOptions("Whisper Tabnew"))
                (map! [:n :i] :<C-g>wp :<cmd>GpWhisperPopup<cr> md
                      "Whisper Popup")
                (map! [:n :i] :<C-g>we :<cmd>GpWhisperEnew<cr> md
                      "Whisper Enew")
                (map! [:n :i] :<C-g>wn :<cmd>GpWhisperNew<cr> md "Whisper New")
                (map! [:n :i] :<C-g>wv :<cmd>GpWhisperVnew<cr> md
                      "Whisper Vnew")
                (map! [:n :i] :<C-g>wt :<cmd>GpWhisperTabnew<cr> md
                      "Whisper Tabnew") ; ; vim.keymap.set("v", "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", keymapOptions("Visual Whisper Popup"))
                ; vim.keymap.set("v", "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", keymapOptions("Visual Whisper Enew"))
                ; vim.keymap.set("v", "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", keymapOptions("Visual Whisper New"))
                ; vim.keymap.set("v", "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", keymapOptions("Visual Whisper Vnew"))
                ; vim.keymap.set("v", "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", keymapOptions("Visual Whisper Tabnew"))
                (map! :v :<C-g>wp ":<C-u>'<,'>GpWhisperPopup<cr>" md
                      "Visual Whisper Popup")
                (map! :v :<C-g>we ":<C-u>'<,'>GpWhisperEnew<cr>" md
                      "Visual Whisper Enew")
                (map! :v :<C-g>wn ":<C-u>'<,'>GpWhisperNew<cr>" md
                      "Visual Whisper New")
                (map! :v :<C-g>wv ":<C-u>'<,'>GpWhisperVnew<cr>" md
                      "Visual Whisper Vnew")
                (map! :v :<C-g>wt ":<C-u>'<,'>GpWhisperTabnew<cr>" md
                      "Visual Whisper Tabnew"))
       :config #(let [gp (require :gp)]
                  (gp.setup {:openai_api_key conf.openai_token}))})
