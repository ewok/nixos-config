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
                             {:mode [:i :n :v] :prefix :<C-g>})
                (map! [:n :i] :<C-g>c :<cmd>GpChatNew<cr> md "New Chat")
                (map! [:n :i] :<C-g>t :<cmd>GpChatToggle<cr> md "Toggle Chat")
                (map! [:n :i] :<C-g>f :<cmd>GpChatFinder<cr> md "Chat Finder")
                (map! :v :<C-g>c ":<C-u>'<,'>GpChatNew<cr>" md
                      "Visual Chat New")
                (map! :v :<C-g>p ":<C-u>'<,'>GpChatPaste<cr>" md
                      "Visual Chat Paste")
                (map! :v :<C-g>t ":<C-u>'<,'>GpChatToggle<cr>" md
                      "Visual Toggle Chat")
                (map! [:n :i] :<C-g><C-x> "<cmd>GpChatNew split<cr>" md
                      "New Chat split")
                (map! [:n :i] :<C-g><C-v> "<cmd>GpChatNew vsplit<cr>" md
                      "New Chat vsplit")
                (map! [:n :i] :<C-g><C-t> "<cmd>GpChatNew tabnew<cr>" md
                      "New Chat tabnew")
                (map! :v :<C-g><C-x> ":<C-u>'<,'>GpChatNew split<cr>" md
                      "Visual Chat New split")
                (map! :v :<C-g><C-v> ":<C-u>'<,'>GpChatNew vsplit<cr>" md
                      "Visual Chat New vsplit")
                (map! :v :<C-g><C-t> ":<C-u>'<,'>GpChatNew tabnew<cr>" md
                      "Visual Chat New tabnew")
                (map! [:n :i] :<C-g>r :<cmd>GpRewrite<cr> md "Inline Rewrite")
                (map! [:n :i] :<C-g>a :<cmd>GpAppend<cr> md "Append (after)")
                (map! [:n :i] :<C-g>b :<cmd>GpPrepend<cr> md "Prepend (before)")
                (map! :v :<C-g>r ":<C-u>'<,'>GpRewrite<cr>" md "Visual Rewrite")
                (map! :v :<C-g>a ":<C-u>'<,'>GpAppend<cr>" md
                      "Visual Append (after)")
                (map! :v :<C-g>b ":<C-u>'<,'>GpPrepend<cr>" md
                      "Visual Prepend (before)")
                (map! :v :<C-g>i ":<C-u>'<,'>GpImplement<cr>" md
                      "Implement selection")
                (map! [:n :i] :<C-g>gp :<cmd>GpPopup<cr> md :Popup)
                (map! [:n :i] :<C-g>ge :<cmd>GpEnew<cr> md :GpEnew)
                (map! [:n :i] :<C-g>gn :<cmd>GpNew<cr> md :GpNew)
                (map! [:n :i] :<C-g>gv :<cmd>GpVnew<cr> md :GpVnew)
                (map! [:n :i] :<C-g>gt :<cmd>GpTabnew<cr> md :GpTabnew)
                (map! :v :<C-g>gp ":<C-u>'<,'>GpPopup<cr>" md "Visual Popup")
                (map! :v :<C-g>ge ":<C-u>'<,'>GpEnew<cr>" md "Visual GpEnew")
                (map! :v :<C-g>gn ":<C-u>'<,'>GpNew<cr>" md "Visual GpNew")
                (map! :v :<C-g>gv ":<C-u>'<,'>GpVnew<cr>" md "Visual GpVnew")
                (map! :v :<C-g>gt ":<C-u>'<,'>GpTabnew<cr>" md
                      "Visual GpTabnew")
                (map! [:n :i] :<C-g>x :<cmd>GpContext<cr> md "Toggle Context")
                (map! :v :<C-g>x ":<C-u>'<,'>GpContext<cr>" md
                      "Visual Toggle Context")
                (map! [:n :i :v :x] :<C-g>s :<cmd>GpStop<cr> md :Stop)
                (map! [:n :i :v :x] :<C-g>n :<cmd>GpNextAgent<cr> md
                      "Next Agent")
                (map! [:n :i] :<C-g>ww :<cmd>GpWhisper<cr> md :Whisper)
                (map! :v :<C-g>ww ":<C-u>'<,'>GpWhisper<cr>" md
                      "Visual Whisper")
                (map! [:n :i] :<C-g>wr :<cmd>GpWhisperRewrite<cr> md
                      "Whisper Inline Rewrite")
                (map! [:n :i] :<C-g>wa :<cmd>GpWhisperAppend<cr> md
                      "Whisper Append (after)")
                (map! [:n :i] :<C-g>wb :<cmd>GpWhisperPrepend<cr> md
                      "Whisper Prepend (before) ")
                (map! :v :<C-g>wr ":<C-u>'<,'>GpWhisperRewrite<cr>" md
                      "Visual Whisper Rewrite")
                (map! :v :<C-g>wa ":<C-u>'<,'>GpWhisperAppend<cr>" md
                      "Visual Whisper Append (after)")
                (map! :v :<C-g>wb ":<C-u>'<,'>GpWhisperPrepend<cr>" md
                      "Visual Whisper Prepend (before)")
                (map! [:n :i] :<C-g>wp :<cmd>GpWhisperPopup<cr> md
                      "Whisper Popup")
                (map! [:n :i] :<C-g>we :<cmd>GpWhisperEnew<cr> md
                      "Whisper Enew")
                (map! [:n :i] :<C-g>wn :<cmd>GpWhisperNew<cr> md "Whisper New")
                (map! [:n :i] :<C-g>wv :<cmd>GpWhisperVnew<cr> md
                      "Whisper Vnew")
                (map! [:n :i] :<C-g>wt :<cmd>GpWhisperTabnew<cr> md
                      "Whisper Tabnew")
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
