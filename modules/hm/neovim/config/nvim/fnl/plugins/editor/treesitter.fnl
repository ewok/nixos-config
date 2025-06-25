;; Treesitter related
(local {: pack} (require :lib))
(local conf (require :conf))

;; Remove codeblock concealation

[(pack :hiphish/rainbow-delimiters.nvim {:event [:BufReadPost :BufNewFile]})
 (pack :nvim-treesitter/nvim-treesitter-textobjects
       {:config #(let [configs (require :nvim-treesitter.configs)]
                   (configs.setup {:textobjects {:select {:enable true
                                                          :lookahead true
                                                          :keymaps {:a= {:query "@assignment.outer"
                                                                         :desc "[TS] Select outer part of an assignment"}
                                                                    :i= {:query "@assignment.inner"
                                                                         :desc "[TS] Select inner part of an assignment"}
                                                                    :=h {:query "@assignment.lhs"
                                                                         :desc "[TS] Select left hand side of an assignment"}
                                                                    :=l {:query "@assignment.rhs"
                                                                         :desc "[TS] Select right hand side of an assignment"}
                                                                    "a:" {:query "@property.outer"
                                                                          :desc "[TS] Select outer part of an object property"}
                                                                    "i:" {:query "@property.inner"
                                                                          :desc "[TS] Select inner part of an object property"}
                                                                    "h:" {:query "@property.lhs"
                                                                          :desc "[TS] Select left part of an object property"}
                                                                    "l:" {:query "@property.rhs"
                                                                          :desc "[TS] <Select> right part of an object property"}
                                                                    :aa {:query "@parameter.outer"
                                                                         :desc "[TS] <Select> outer part of a parameter/argument"}
                                                                    :ia {:query "@parameter.inner"
                                                                         :desc "[TS] <Select> inner part of a parameter/argument"}
                                                                    :ai {:query "@conditional.outer"
                                                                         :desc "[TS] <Select> outer part of a conditional"}
                                                                    :ii {:query "@conditional.inner"
                                                                         :desc "[TS] <Select> inner part of a conditional"}
                                                                    :al {:query "@loop.outer"
                                                                         :desc "[TS] <Select> outer part of a loop"}
                                                                    :il {:query "@loop.inner"
                                                                         :desc "[TS] <Select> inner part of a loop"}
                                                                    :af {:query "@call.outer"
                                                                         :desc "[TS] <Select> outer part of a function call"}
                                                                    :if {:query "@call.inner"
                                                                         :desc "[TS] <Select> inner part of a function call"}
                                                                    :am {:query "@function.outer"
                                                                         :desc "[TS] Select outer part of a method/function definition"}
                                                                    :im {:query "@function.inner"
                                                                         :desc "[TS] Select inner part of a method/function definition"}
                                                                    :ac {:query "@class.outer"
                                                                         :desc "[TS] Select outer part of a class"}
                                                                    :ic {:query "@class.inner"
                                                                         :desc "[TS] Select inner part of a class"}}}
                                                 :swap {:enable true
                                                        :swap_next {:gm> "@parameter.inner"}
                                                        :swap_previous {:gm< "@parameter.inner"}}
                                                 :move {:enable true
                                                        :set_jumps true
                                                        :goto_next_start {"]f" {:query "@call.outer"
                                                                                :desc "[TS] <Next> function call start"}
                                                                          "]m" {:query "@function.outer"
                                                                                :desc "[TS] <Next> method/function def start"}
                                                                          "]c" {:query "@class.outer"
                                                                                :desc "[TS] <Next> class start"}
                                                                          "]i" {:query "@conditional.outer"
                                                                                :desc "[TS] <Next> conditional start"}
                                                                          "]l" {:query "@loop.outer"
                                                                                :desc "[TS] <Next> loop start"}
                                                                          "]s" {:query "@scope"
                                                                                :query_group :locals
                                                                                :desc "[TS] <Next> scope"}
                                                                          "]z" {:query "@fold"
                                                                                :query_group :folds
                                                                                :desc "[TS] <Next> fold"}}
                                                        :goto_previous_start {"[f" {:query "@call.outer"
                                                                                    :desc "[TS] <Prev> function call start"}
                                                                              "[m" {:query "@function.outer"
                                                                                    :desc "[TS] <Prev> method/function def start"}
                                                                              "[c" {:query "@class.outer"
                                                                                    :desc "[TS] <Prev> class start"}
                                                                              "[i" {:query "@conditional.outer"
                                                                                    :desc "[TS] <Prev> conditional start"}
                                                                              "[l" {:query "@loop.outer"
                                                                                    :desc "[TS] <Prev> loop start"}}}}}))})
 (pack :nvim-treesitter/nvim-treesitter
       {:build ":TSUpdate"
        :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]
        :event [:BufReadPost :BufNewFile]
        :config #(let [configs (require :nvim-treesitter.configs)
                       install (require :nvim-treesitter.install)]
                   (tset install :prefer_git true)
                   (configs.setup {:ensure_installed [:markdown_inline
                                                      :markdown
                                                      :c
                                                      :lua
                                                      :vim
                                                      :vimdoc]
                                   :ignore_install []
                                   :sync_install false
                                   :auto_install true
                                   :matchup {:enable false}
                                   :highlight {:enable true
                                               :disable [:clojure]
                                               :additional_vim_regex_highlighting conf.treesitter_nvim_highlighting}
                                   :indent {:enable true
                                            :disable [:yaml :python :html :vue]}
                                   :incremental_selection {:enable false
                                                           :keymaps {:init_selection :<cr>
                                                                     :node_incremental :<cr>
                                                                     :node_decremental :<bs>
                                                                     :scope_incremental :<tab>}}
                                   :autotag {:enable true}
                                   :context_commentstring {:enable true
                                                           :enable_autocmd false}}))})]
