(local {: pack} (require :lib))
(local conf (require :conf))

(pack :folke/which-key.nvim
      {:event [:VeryLazy]
       :config #(let [wk (require :which-key)]
                  (wk.setup {:preset :modern
                             :plugins {:presets {:operators false
                                                 :text_objects true
                                                 :motions true
                                                 :g true
                                                 :z true
                                                 :nav true
                                                 :windows true}
                                       :spelling {:enabled true
                                                  :suggestions 20}}
                             :icons {:breadcrumb conf.icons.wk.breadcrumb
                                     :separator conf.icons.wk.separator
                                     :group conf.icons.wk.group}
                             :win {:border :single}})
                  (wk.add [{1 :<leader>b :group :Buffer}
                           {1 :<leader>c :group :Code}
                           {1 :<leader>cd :group :Diff/Diagnostics}
                           {1 :<leader>f :group :Find}
                           {1 :<leader>fs :group :Settings}
                           {1 :<leader>j :desc "Goto Next buffer"}
                           {1 :<leader>k :desc "Goto Prev buffer"}
                           {1 :<leader>l :group :Lsp}
                           {1 :<leader>o :group :Open}
                           {1 :<leader>g :group :Git...}
                           {1 :<leader>gf :group :File...}
                           {1 :<leader>p :group "Packages | Profiling"}
                           {1 :<leader>s :group :Session}
                           {1 :<leader>t :group :Toggle}
                           {1 :<leader>th :desc "Dark/Light theme"}
                           {1 :<leader>w :group :Wiki}
                           {1 :<leader>y :group :Yank}
                           {1 :<leader>yf :group :File}
                           {1 :<leader>6 :name :Base64 :mode [:v]}
                           {1 :<leader>c :name :Code :mode [:v]}
                           {1 :<leader>y :name :Yank :mode [:v]}
                           {1 :<leader>w :name :Wiki :mode [:v]}]))})
