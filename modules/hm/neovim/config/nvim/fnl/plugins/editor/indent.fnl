(local {: pack} (require :lib))

(pack :nvimdev/indentmini.nvim
      {:event :BufEnter
       :config #(do
                  ((-> (require :indentmini) (. :setup)) {; char = "┊",
                                                          ; char = "╎",
                                                          ; char = "┊",
                                                          ; char = "│",
                                                          ; :char "▏"
                                                          :char "│"
                                                          :exclude [:clojure
                                                                    :fennel]})
                  (vim.cmd.highlight "default link IndentLine Comment"))})
