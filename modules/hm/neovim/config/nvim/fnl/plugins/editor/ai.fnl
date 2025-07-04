(local {: pack : map : reg_ft} (require :lib))
(local conf (require :conf))

[(pack :olimorris/codecompanion.nvim
       {:event :InsertEnter
        :cmd [:CodeCompanion
              :CodeCompanionChat
              :CodeCompanionActions
              :CodeCompanionCmd]
        :init #(do
                 (map [:n :v] :<Leader>cc "<cmd>CodeCompanionChat Toggle<cr>"
                      {:noremap true :silent true})
                 (map [:n :v] :<Leader>cA :<cmd>CodeCompanionActions<cr>
                      {:noremap true :silent true})
                 (map [:v] :gA "<cmd>CodeCompanionChat Add<cr>"
                      {:noremap true :silent true})
                 (map [:n] :<c-g>a ":CodeCompanion /add<cr>"
                      {:noremap true :silent false})
                 (map [:v] :<c-g>a ":'<,'>CodeCompanion /add<cr>"
                      {:noremap true :silent false})
                 (vim.cmd "cab cc CodeCompanion")
                 (reg_ft :gitcommit
                         (fn [ev]
                           (do
                             (map :n :cc ":CodeCompanion /commit<cr>"
                                  {:noremap true
                                   :silent true
                                   :nowait true
                                   :buffer ev.buf}
                                  "[gpt] Add commit")))))
        :config #(let [c (require :codecompanion)]
                   (c.setup {:prompt_library {"Add Prompt" {:strategy :inline
                                                            :description "Prompt the LLM from Neovim"
                                                            :opts {:index 50
                                                                   :is_default true
                                                                   :is_slash_cmd true
                                                                   :short_name :add
                                                                   :user_prompt true
                                                                   :placement :add
                                                                   :start_in_insert_mode true}
                                                            :prompts [{:role :system
                                                                       :content (fn [context]
                                                                                  (string.format "I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]]"
                                                                                                 context.filetype))}]}
                                              "Generate a Commit Message" {:strategy :inline
                                                                           :description "Generate a commit message"
                                                                           :opts {:index 10
                                                                                  :is_default true
                                                                                  :is_slash_cmd true
                                                                                  :short_name :commit
                                                                                  :auto_submit true
                                                                                  :user_prompt false
                                                                                  :placement :before}
                                                                           :prompts [{:role :user
                                                                                      :content #(string.format (.. "You are an expert at following the Conventional Commit specification.\n"
                                                                                                                  "commit messages should:\n"
                                                                                                                  "- follow Conventional Commits\n"
                                                                                                                  "- have goal at the end\n"
                                                                                                                  "- do not set goal if type = chore\n"
                                                                                                                  "- message structure must be:\n"
                                                                                                                  "--START OF TEMPLATE--\n"
                                                                                                                  "<type>[scope]: <description>\n\n"
                                                                                                                  "[body with details, one per line, started with a minus sign]\n\n"
                                                                                                                  "[goal]\n"
                                                                                                                  "--END OF TEMPLATE--\n\n"
                                                                                                                  "example:\n"
                                                                                                                  "fix(authentication): add password regex pattern\n\n"
                                                                                                                  "- `extends` key in config file is now used for extending other config files\n"
                                                                                                                  "- passwords now are following security protocol\n\n"
                                                                                                                  "goal: enhance security level\n\n"
                                                                                                                  "Given the git diff listed below, please generate a commit message for me:\n"
                                                                                                                  "```diff\n"
                                                                                                                  "%s\n"
                                                                                                                  "```"
                                                                                                                  )
                                                                                                              (vim.fn.system "git diff --no-ext-diff --staged"))
                                                                                      :opts {:contains_code true}}]}}
                             :strategies {:chat {:adapter {:name :openai
                                                           :model :gpt-4.1}}
                                          :inline {:adapter {:name :openai
                                                             :model :gpt-4.1}}}}))})
 (pack :github/copilot.vim
       {:event :InsertEnter
        :cmd :Copilot
        :keys [{1 :<leader>co
                2 #(do
                     (set vim.g.copilot_enabled (not vim.g.copilot_enabled))
                     (if vim.g.copilot_enabled
                         (do
                           (vim.cmd "Copilot enable")
                           (vim.schedule #(vim.cmd "Copilot status")))
                         (vim.cmd "Copilot disable"))
                     (vim.notify (string.format "Copilot Enabled %s"
                                                vim.g.copilot_enabled)
                                 :INFO {:title :Copilot}))
                :mode :n
                :desc "Toggle Copilot"}]
        :config #(do
                   (set vim.g.copilot_loaded true)
                   (set vim.g.copilot_enabled false))
        :init #(do
                 (set vim.g.copilot_no_maps true))})
 ; (pack :robitx/gp.nvim
 ;       {:cmd [:GpChatNew
 ;              :GpChatToggle
 ;              :GpChatFinder
 ;              :GpRewrite
 ;              :GpAppend
 ;              :GpPrepend
 ;              :GpPopup
 ;              :GpEnew
 ;              :GpNew
 ;              :GpVnew
 ;              :GpTabnew
 ;              :GpImage
 ;              :GpNextAgent
 ;              :GpCodeReview
 ;              :GpUnitTests
 ;              :GpExplain
 ;              :GpCommitMessage]
 ;        :init #(let [wk (require :which-key)
 ;                     md {:noremap true :silent true :nowait true}]
 ;                 (wk.add [{1 :<C-g>g
 ;                           :name "generate into new .."
 ;                           :mode [:i :n :v]}
 ;                          {1 :<C-g>w :name :Whisper :mode [:i :n :v]}])
 ;                 (do
 ;                   (map [:n :i] :<C-g>c :<cmd>GpChatNew<cr> md "New Chat")
 ;                   (map [:n :i] :<C-g>t :<cmd>GpChatToggle<cr> md "Toggle Chat")
 ;                   (map [:n :i] :<C-g>f :<cmd>GpChatFinder<cr> md "Chat Finder")
 ;                   (map [:n :i] :<C-g>i :<cmd>GpImage<cr> md :Image)
 ;                   (map :v :<C-g>c ":<C-u>'<,'>GpChatNew<cr>" md
 ;                        "Visual Chat New")
 ;                   (map :v :<C-g>p ":<C-u>'<,'>GpChatPaste<cr>" md
 ;                        "Visual Chat Paste")
 ;                   (map :v :<C-g>t ":<C-u>'<,'>GpChatToggle<cr>" md
 ;                        "Visual Toggle Chat")
 ;                   (map [:n :i] :<C-g><C-x> "<cmd>GpChatNew split<cr>" md
 ;                        "New Chat split")
 ;                   (map [:n :i] :<C-g><C-v> "<cmd>GpChatNew vsplit<cr>" md
 ;                        "New Chat vsplit")
 ;                   (map [:n :i] :<C-g><C-t> "<cmd>GpChatNew tabnew<cr>" md
 ;                        "New Chat tabnew")
 ;                   (map :v :<C-g><C-x> ":<C-u>'<,'>GpChatNew split<cr>" md
 ;                        "Visual Chat New split")
 ;                   (map :v :<C-g><C-v> ":<C-u>'<,'>GpChatNew vsplit<cr>" md
 ;                        "Visual Chat New vsplit")
 ;                   (map :v :<C-g><C-t> ":<C-u>'<,'>GpChatNew tabnew<cr>" md
 ;                        "Visual Chat New tabnew")
 ;                   (map [:n :i] :<C-g>r :<cmd>GpRewrite<cr> md "Inline Rewrite")
 ;                   (map [:n :i] :<C-g>a :<cmd>GpAppend<cr> md "Append (after)")
 ;                   (map [:n :i] :<C-g>b :<cmd>GpPrepend<cr> md
 ;                        "Prepend (before)")
 ;                   (map :v :<C-g>r ":<C-u>'<,'>GpRewrite<cr>" md
 ;                        "Visual Rewrite")
 ;                   (map :v :<C-g>a ":<C-u>'<,'>GpAppend<cr>" md
 ;                        "Visual Append (after)")
 ;                   (map :v :<C-g>b ":<C-u>'<,'>GpPrepend<cr>" md
 ;                        "Visual Prepend (before)")
 ;                   (map :v :<C-g>i ":<C-u>'<,'>GpImplement<cr>" md
 ;                        "Implement selection")
 ;                   (map [:n :i] :<C-g>gp :<cmd>GpPopup<cr> md :Popup)
 ;                   (map [:n :i] :<C-g>ge :<cmd>GpEnew<cr> md :GpEnew)
 ;                   (map [:n :i] :<C-g>gn :<cmd>GpNew<cr> md :GpNew)
 ;                   (map [:n :i] :<C-g>gv :<cmd>GpVnew<cr> md :GpVnew)
 ;                   (map [:n :i] :<C-g>gt :<cmd>GpTabnew<cr> md :GpTabnew)
 ;                   (map :v :<C-g>gp ":<C-u>'<,'>GpPopup<cr>" md "Visual Popup")
 ;                   (map :v :<C-g>ge ":<C-u>'<,'>GpEnew<cr>" md "Visual GpEnew")
 ;                   (map :v :<C-g>gn ":<C-u>'<,'>GpNew<cr>" md "Visual GpNew")
 ;                   (map :v :<C-g>gv ":<C-u>'<,'>GpVnew<cr>" md "Visual GpVnew")
 ;                   (map :v :<C-g>gt ":<C-u>'<,'>GpTabnew<cr>" md
 ;                        "Visual GpTabnew")
 ;                   (map [:n :i] :<C-g>x :<cmd>GpContext<cr> md "Toggle Context")
 ;                   (map :v :<C-g>x ":<C-u>'<,'>GpContext<cr>" md
 ;                        "Visual Toggle Context")
 ;                   (map [:n :i :v :x] :<C-g>s :<cmd>GpStop<cr> md :Stop)
 ;                   (map [:n :i :v :x] :<C-g>n :<cmd>GpNextAgent<cr> md
 ;                        "Next Agent")
 ;                   (map [:n :i] :<C-g>ww :<cmd>GpWhisper<cr> md :Whisper)
 ;                   (map :v :<C-g>ww ":<C-u>'<,'>GpWhisper<cr>" md
 ;                        "Visual Whisper")
 ;                   (map [:n :i] :<C-g>wr :<cmd>GpWhisperRewrite<cr> md
 ;                        "Whisper Inline Rewrite")
 ;                   (map [:n :i] :<C-g>wa :<cmd>GpWhisperAppend<cr> md
 ;                        "Whisper Append (after)")
 ;                   (map [:n :i] :<C-g>wb :<cmd>GpWhisperPrepend<cr> md
 ;                        "Whisper Prepend (before) ")
 ;                   (map :v :<C-g>wr ":<C-u>'<,'>GpWhisperRewrite<cr>" md
 ;                        "Visual Whisper Rewrite")
 ;                   (map :v :<C-g>wa ":<C-u>'<,'>GpWhisperAppend<cr>" md
 ;                        "Visual Whisper Append (after)")
 ;                   (map :v :<C-g>wb ":<C-u>'<,'>GpWhisperPrepend<cr>" md
 ;                        "Visual Whisper Prepend (before)")
 ;                   (map :v :<leader>c1 ":<C-u>'<,'>GpCodeReview<cr>" md
 ;                        "[gpt] Code review")
 ;                   (map :v :<leader>c2 ":<C-u>'<,'>GpUnitTests<cr>" md
 ;                        "[gpt] Code Unit tests")
 ;                   (map :v :<leader>c3 ":<C-u>'<,'>GpExplain<cr>" md
 ;                        "[gpt] Code Explain") ; (reg_ft :NeogitDiffView ;         (fn [ev] ;           (do ;             (map :n :cc ":%GpCommitMessage<cr>" ;                  {:noremap true ;                   :silent true ;                   :nowait true ;                   :buffer ev.buf} ;                  "[gpt] Code Unit tests"))))
 ;                   ))
 ;        :config #(let [gp (require :gp)
 ;                       defaults (require :gp.defaults)]
 ;                   (gp.setup {:openai_api_key conf.openai_token
 ;                              :chat_finder_pattern "topic: "
 ;                              :chat_free_cursor true
 ;                              :image {:store_dir ""}
 ;                              :agents [{:name :ChatGPT4 :disable true}
 ;                                       {:name :CodeGPT4 :disable true}
 ;                                       {:name :ChatGPT4o :disable true}
 ;                                       {:name :CodeGPT4o :disable true}
 ;                                       {:name :ChatGPT3-5 :disable true}
 ;                                       {:name :CodeGPT3-5 :disable true}
 ;                                       {:name :CodeGPT-o3-mini :disable true}
 ;                                       {:name :ChatGPT-o3-mini :disable true}
 ;                                       {:name :CodeGPT4o-mini :disable true}
 ;                                       {:name :ChatGPT4o-mini :disable true}
 ;                                       {:provider :openai
 ;                                        :name :ChatGPT41
 ;                                        :chat true
 ;                                        :command false
 ;                                        :model {:model :gpt-4.1
 ;                                                :temperature 1.1
 ;                                                :top_p 1}
 ;                                        :system_prompt defaults.chat_system_prompt}
 ;                                       {:provider :openai
 ;                                        :name :CodeGPT41mini
 ;                                        :chat false
 ;                                        :command true
 ;                                        :model {:model :gpt-4.1-mini
 ;                                                :temperature 0.7
 ;                                                :top_p 1}
 ;                                        :system_prompt "Please return ONLY code snippets.\\nSTART AND END YOUR ANSWER WITH:\\n\\n```"}]
 ;                              :hooks {:CodeReview (fn [gp params]
 ;                                                    (let [template (.. "I have the following code from {{filename}}:\\n\\n"
 ;                                                                       "```{{filetype}}\\n{{selection}}\\n```\\n\\n"
 ;                                                                       "Please analyze for code smells and suggest improvements.")
 ;                                                          agent (gp.get_chat_agent)]
 ;                                                      (gp.Prompt params
 ;                                                                 (gp.Target.enew :markdown)
 ;                                                                 agent template)))
 ;                                      :UnitTests (fn [gp params]
 ;                                                   (let [template (.. "I have the following code from {{filename}}:\\n\\n"
 ;                                                                      "```{{filetype}}\\n{{selection}}\\n```\\n\\n"
 ;                                                                      "Please respond by writing table driven unit tests for the code above.")
 ;                                                         agent (gp.get_command_agent)]
 ;                                                     (gp.Prompt params
 ;                                                                gp.Target.enew
 ;                                                                agent template)))
 ;                                      :Explain (fn [gp params]
 ;                                                 (let [template (.. "I have the following code from {{filename}}:\\n\\n"
 ;                                                                    "```{{filetype}}\\n{{selection}}\\n```\\n\\n"
 ;                                                                    "Please respond by explaining the code above.")
 ;                                                       agent (gp.get_command_agent)]
 ;                                                   (gp.Prompt params
 ;                                                              gp.Target.popup
 ;                                                              agent template)))
 ;                                      :CommitMessage (fn [gp params]
 ;                                                       (let [template (.. "suggest commit message based on the following diff:\\n"
 ;                                                                          "{{selection}}\\n"
 ;                                                                          "commit messages should:\\n"
 ;                                                                          "- follow conventional commits\\n"
 ;                                                                          "- have goal at the end\\n"
 ;                                                                          "- not set goal if type = chore\\n"
 ;                                                                          "- message structure must be:\\n"
 ;                                                                          "--START OF TEMPLATE--\\n"
 ;                                                                          "<type>[scope]: <description>\\n\\n"
 ;                                                                          "[body with details, one per line, started with a minus sign]\\n\\n"
 ;                                                                          "[goal]\\n"
 ;                                                                          "--END OF TEMPLATE--\\n\\n"
 ;                                                                          "example:\\n"
 ;                                                                          "fix(authentication): add password regex pattern\\n\\n"
 ;                                                                          "- `extends` key in config file is now used for extending other config files\\n"
 ;                                                                          "- passwords now are following security protocol\\n\\n"
 ;                                                                          "goal: enhance security level")
 ;                                                             agent (gp.get_command_agent)]
 ;                                                         (gp.Prompt params
 ;                                                                    (gp.Target.vnew :NeogitDiffViewCommit)
 ;                                                                    agent
 ;                                                                    template)))}}))})
 ]
