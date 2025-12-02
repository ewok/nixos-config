(local {: pack : map : reg_ft} (require :lib))
; (local conf (require :conf))

(local commit-prompt "You are an expert at following the Conventional Commit specification.
commit message must:
- follow Conventional Commits
- have a goal at the end
- do not set goal if type = chore
- message structure must be:
<type>[scope]: <description>

[body with details, one per line, started with a minus sign]

[goal]


example:
fix(authentication): add password regex pattern

- `extends` key in config file is now used for extending other config files
- passwords now are following security protocol

goal: enhance security level


Given the git diff listed below, please generate a commit message for me:
```diff
%s
```")

[(pack :ravitemer/mcphub.nvim
       {:cmd [:MCPHub]
        :init #(map :n :<leader>cm :<cmd>MCPHub<cr> {:noremap true} :MCPHub)
        :config #(let [hub (require :mcphub)]
                   ;; https://ravitemer.github.io/mcphub.nvim/configuration.html
                   (hub.setup {:port 37373 :use_bundled_binary true}))
        :build :bundled_build.lua})
 (pack :olimorris/codecompanion.nvim
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
                           (map :n :cc ":CodeCompanion /commit<cr>"
                                {:noremap true
                                 :silent true
                                 :nowait true
                                 :buffer ev.buf}
                                "[gpt] Add commit"))))
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
                                                                                      :content #(string.format commit-prompt
                                                                                                               (vim.fn.system "git diff --no-ext-diff --staged"))
                                                                                      :opts {:contains_code true}}]}}
                             :strategies {:chat {:adapter {:name :openai
                                                           :model :gpt-4o}}
                                          :inline {:adapter {:name :openai
                                                             :model :gpt-4o-mini}}}
                             :extensions {:mcphub {:callback :mcphub.extensions.codecompanion
                                                   :opts {:make_vars true
                                                          :make_slash_commands true
                                                          :show_result_in_chat true}}}}))})
 (pack :github/copilot.vim
       {:event :InsertEnter
        :cmd :Copilot
        :keys [{1 :<leader>co
                2 #(do
                     (vim.cmd "Copilot enable")
                     (vim.schedule #(vim.cmd "Copilot status"))
                     (vim.notify "Copilot Enabled" :INFO {:title :Copilot}))
                :mode :n
                :desc "Start Copilot"}
               {1 :<leader>cO
                2 #(do
                     (vim.cmd "Copilot disable")
                     (vim.notify "Copilot Disabled" :INFO {:title :Copilot}))
                :mode :n
                :desc "Stop Copilot"}]
        :config #(set vim.g.copilot_loaded true)
        :init #(set vim.g.copilot_no_maps true)})]
