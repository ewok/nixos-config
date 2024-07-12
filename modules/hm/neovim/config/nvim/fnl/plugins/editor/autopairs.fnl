(local {: pack} (require :lib))

; (pack :windwp/nvim-autopairs
;       {:event [:InsertEnter]
;        :config #(let [npairs (require :nvim-autopairs)
;                       conf (require :conf)]
;                   (npairs.setup {:disable_filetype [:TelescopePrompt]
;                                  :disable_in_macro true
;                                  :disable_in_visualblock true
;                                  :disable_in_replace_mode true
;                                  :enable_moveright true
;                                  :enable_check_bracket_line false
;                                  :check_ts true
;                                  :map_bs true
;                                  :map_c_h true
;                                  :map_c_w true})
;                   (tset (. (npairs.get_rule "'") 1) :not_filetypes
;                         conf.lisp_langs))})

(pack :altermo/ultimate-autopair.nvim
      {:event [:InsertEnter :CmdlineEnter]
       :branch :v0.6
       :opts {:cmap false
              :pair_cmap false
              :config_internal_pairs [{1 "'"
                                       2 "'"
                                       :surround true
                                       :cond #(or (not ($1.in_lisp))
                                                  ($1.in_string))
                                       :alpha true
                                       :multiline false
                                       :nft [:fennel
                                             :clojure
                                             :commonlisp
                                             :tex
                                             :rip-substitute]}
                                      {1 "["
                                       2 "]"
                                       :fly true
                                       :dosurround true
                                       :newline true
                                       :space true
                                       :nft [:rip-substitute]}
                                      {1 "("
                                       2 ")"
                                       :fly true
                                       :dosurround true
                                       :newline true
                                       :space true
                                       :nft [:rip-substitute]}
                                      {1 "{"
                                       2 "}"
                                       :fly true
                                       :dosurround true
                                       :newline true
                                       :space true
                                       :nft [:rip-substitute]}
                                      {1 "`"
                                       2 "`"
                                       :cond #(or (not ($1.in_lisp))
                                                  ($1.in_string))
                                       :nft [:tex :rip-substitute]
                                       :multiline false}
                                      {1 "``" 2 "''" :ft [:tex]}
                                      {1 "```"
                                       2 "```"
                                       :newline true
                                       :ft [:markdown]}
                                      {1 "<!--"
                                       2 "-->"
                                       :ft [:markdown :html]
                                       :space true}
                                      {1 "\"\"\""
                                       2 "\"\"\""
                                       :newline true
                                       :ft [:python]}
                                      {1 "'''"
                                       2 "'''"
                                       :newline true
                                       :ft [:python]}
                                      {1 "\""
                                       2 "\""
                                       :surround true
                                       :multiline false
                                       :nft [:rip-substitute]}]}})
