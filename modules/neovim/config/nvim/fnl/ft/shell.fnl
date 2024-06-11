(local {: reg_ft_once : map!} (require :lib))

(each [_ x (ipairs [:bash :sh :zsh])]
  (reg_ft_once x
               #(let [null-ls (require :null-ls)]
                  (null-ls.register [null-ls.builtins.formatting.shellharden
                                     null-ls.builtins.formatting.shfmt]))))
