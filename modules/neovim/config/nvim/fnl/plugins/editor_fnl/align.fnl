(local {: pack} (require :lib))

(pack :junegunn/vim-easy-align
      {:keys [{1 :ga
               2 "<Plug>(LiveEasyAlign)"
               :mode [:n :x]
               :desc "Align Block"}]})
