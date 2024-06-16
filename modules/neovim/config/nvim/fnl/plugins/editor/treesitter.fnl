;; Treesitter related
(local {: pack} (require :lib))
(local conf (require :conf))

;; Remove codeblock concealation
(local md-rule "
(atx_heading (inline) @text.title)
(setext_heading (paragraph) @text.title)

[
  (atx_h1_marker)
  (atx_h2_marker)
  (atx_h3_marker)
  (atx_h4_marker)
  (atx_h5_marker)
  (atx_h6_marker)
  (setext_h1_underline)
  (setext_h2_underline)
] @punctuation.special

[
  (link_title)
  (indented_code_block)
  (fenced_code_block)
] @text.literal

(pipe_table_header (pipe_table_cell) @text.title)

(pipe_table_header \"|\" @punctuation.special)
(pipe_table_row \"|\" @punctuation.special)
(pipe_table_delimiter_row \"|\" @punctuation.special)
(pipe_table_delimiter_cell) @punctuation.special

[
  (fenced_code_block_delimiter)
] @punctuation.delimiter

(code_fence_content) @none

[
  (link_destination)
] @text.uri

[
  (link_label)
] @text.reference

[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
  (thematic_break)
] @punctuation.special


(task_list_marker_unchecked) @text.todo.unchecked
(task_list_marker_checked) @text.todo.checked

(block_quote) @text.quote

[
  (block_continuation)
  (block_quote_marker)
] @punctuation.special

[
  (backslash_escape)
] @string.escape

(inline) @spell
   ")

[(pack :hiphish/rainbow-delimiters.nvim {:event [:BufReadPost :BufNewFile]})
 (pack :nvim-treesitter/nvim-treesitter-textobjects
       {:config #(let [configs (require :nvim-treesitter.configs)
                       ts_repeat_move (require :nvim-treesitter.textobjects.repeatable_move)]
                   (vim.keymap.set [:n :x :o] ";"
                                   ts_repeat_move.repeat_last_move)
                   (vim.keymap.set [:n :x :o] ","
                                   ts_repeat_move.repeat_last_move_opposite)
                   (configs.setup {:textobjects {:select {:enable true
                                                          :lookahead true
                                                          :keymaps {:a= {:query "@assignment.outer"
                                                                         :desc "Select outer part of an assignment"}
                                                                    :i= {:query "@assignment.inner"
                                                                         :desc "Select inner part of an assignment"}
                                                                    "[=" {:query "@assignment.lhs"
                                                                          :desc "Select left hand side of an assignment"}
                                                                    "]=" {:query "@assignment.rhs"
                                                                          :desc "Select right hand side of an assignment"}
                                                                    "a:" {:query "@property.outer"
                                                                          :desc "Select outer part of an object property"}
                                                                    "i:" {:query "@property.inner"
                                                                          :desc "Select inner part of an object property"}
                                                                    "[:" {:query "@property.lhs"
                                                                          :desc "Select left part of an object property"}
                                                                    "]:" {:query "@property.rhs"
                                                                          :desc "Select right part of an object property"}
                                                                    :aa {:query "@parameter.outer"
                                                                         :desc "Select outer part of a parameter/argument"}
                                                                    :ia {:query "@parameter.inner"
                                                                         :desc "Select inner part of a parameter/argument"}
                                                                    :ai {:query "@conditional.outer"
                                                                         :desc "Select outer part of a conditional"}
                                                                    :ii {:query "@conditional.inner"
                                                                         :desc "Select inner part of a conditional"}
                                                                    :al {:query "@loop.outer"
                                                                         :desc "Select outer part of a loop"}
                                                                    :il {:query "@loop.inner"
                                                                         :desc "Select inner part of a loop"}
                                                                    :af {:query "@call.outer"
                                                                         :desc "Select outer part of a function call"}
                                                                    :if {:query "@call.inner"
                                                                         :desc "Select inner part of a function call"}
                                                                    :am {:query "@function.outer"
                                                                         :desc "Select outer part of a method/function definition"}
                                                                    :im {:query "@function.inner"
                                                                         :desc "Select inner part of a method/function definition"}
                                                                    :ac {:query "@class.outer"
                                                                         :desc "Select outer part of a class"}
                                                                    :ic {:query "@class.inner"
                                                                         :desc "Select inner part of a class"}}}
                                                 :swap {:enable true
                                                        :swap_next {:m> "@parameter.inner"}
                                                        :swap_previous {:m< "@parameter.inner"}}
                                                 :move {:enable true
                                                        :set_jumps true
                                                        :goto_next_start {"]f" {:query "@call.outer"
                                                                                :desc "Next function call start"}
                                                                          "]m" {:query "@function.outer"
                                                                                :desc "Next method/function def start"}
                                                                          "]c" {:query "@class.outer"
                                                                                :desc "Next class start"}
                                                                          "]i" {:query "@conditional.outer"
                                                                                :desc "Next conditional start"}
                                                                          "]l" {:query "@loop.outer"
                                                                                :desc "Next loop start"}
                                                                          "]s" {:query "@scope"
                                                                                :query_group :locals
                                                                                :desc "Next scope"}
                                                                          "]z" {:query "@fold"
                                                                                :query_group :folds
                                                                                :desc "Next fold"}}
                                                        :goto_next_end {"]F" {:query "@call.outer"
                                                                              :desc "Next function call end"}
                                                                        "]M" {:query "@function.outer"
                                                                              :desc "Next method/function def end"}
                                                                        "]C" {:query "@class.outer"
                                                                              :desc "Next class end"}
                                                                        "]I" {:query "@conditional.outer"
                                                                              :desc "Next conditional end"}
                                                                        "]L" {:query "@loop.outer"
                                                                              :desc "Next loop end"}}
                                                        :goto_previous_start {"[f" {:query "@call.outer"
                                                                                    :desc "Prev function call start"}
                                                                              "[m" {:query "@function.outer"
                                                                                    :desc "Prev method/function def start"}
                                                                              "[c" {:query "@class.outer"
                                                                                    :desc "Prev class start"}
                                                                              "[i" {:query "@conditional.outer"
                                                                                    :desc "Prev conditional start"}
                                                                              "[l" {:query "@loop.outer"
                                                                                    :desc "Prev loop start"}}
                                                        :goto_previous_end {"[F" {:query "@call.outer"
                                                                                  :desc "Prev function call end"}
                                                                            "[M" {:query "@function.outer"
                                                                                  :desc "Prev method/function def end"}
                                                                            "[C" {:query "@class.outer"
                                                                                  :desc "Prev class end"}
                                                                            "[I" {:query "@conditional.outer"
                                                                                  :desc "Prev conditional end"}
                                                                            "[L" {:query "@loop.outer"
                                                                                  :desc "Prev loop end"}}}}}))})
 (pack :nvim-treesitter/nvim-treesitter
       {:build ":TSUpdate"
        :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]
        :event [:BufReadPost :BufNewFile]
        :config #(let [configs (require :nvim-treesitter.configs)
                       query (require :vim.treesitter.query)]
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
                                                           :enable_autocmd false}})
                   (query.set :markdown :highlights md-rule))})]
