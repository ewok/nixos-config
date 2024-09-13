(local {: pack} (require :lib))

(pack :nvimdev/indentmini.nvim
      {:event :BufEnter
       :commit :15ba2c35a89d314a33d50dff06497c6b509ec8e6
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
