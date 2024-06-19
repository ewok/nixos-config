(local {: pack : reg-ft : map!} (require :lib))

[(pack :Olical/conjure
       {:ft [:python :clojure :fennel :lua]
        :config #(do
                   (tset vim.g "conjure#mapping#prefix" :<leader>c)
                   (tset vim.g "conjure#mapping#def_word" :g)
                   (tset vim.g "conjure#mapping#doc_word" :h))})
 (pack :guns/vim-sexp {:ft [:python :clojure :fennel :lua]
                       :init #(let [conf (require :conf)]
                                (set vim.g.sexp_filetypes
                                     (table.concat conf.lisp_langs ","))
                                (set vim.g.sexp_mappings
                                     {:sexp_outer_list :af
                                      :sexp_inner_list :if
                                      :sexp_outer_top_list :aF
                                      :sexp_inner_top_list :iF
                                      :sexp_outer_string :as
                                      :sexp_inner_string :is
                                      :sexp_outer_element :ae
                                      :sexp_inner_element :ie
                                      :sexp_move_to_prev_bracket "[["
                                      :sexp_move_to_next_bracket "]]"
                                      :sexp_move_to_prev_element_head :B
                                      :sexp_move_to_next_element_head :W
                                      :sexp_move_to_prev_element_tail :gE
                                      :sexp_move_to_next_element_tail :E
                                      :sexp_round_head_wrap_list "g("
                                      :sexp_round_tail_wrap_list "g)"
                                      :sexp_square_head_wrap_list "g["
                                      :sexp_square_tail_wrap_list "g]"
                                      :sexp_curly_head_wrap_list "g{"
                                      :sexp_curly_tail_wrap_list "g}"
                                      :sexp_round_head_wrap_element "gw("
                                      :sexp_round_tail_wrap_element "gw)"
                                      :sexp_square_head_wrap_element "gw["
                                      :sexp_square_tail_wrap_element "gw]"
                                      :sexp_curly_head_wrap_element "gw{"
                                      :sexp_curly_tail_wrap_element "gw}"
                                      :sexp_insert_at_list_head :g<
                                      :sexp_insert_at_list_tail :g>
                                      :sexp_splice_list :dsf
                                      :sexp_convolute :g?
                                      :sexp_raise_list ""
                                      :sexp_raise_element ""
                                      :sexp_swap_list_backward ""
                                      :sexp_swap_list_forward ""
                                      :sexp_swap_element_backward ""
                                      :sexp_swap_element_forward ""
                                      :sexp_emit_head_element ""
                                      :sexp_emit_tail_element ""
                                      :sexp_capture_prev_element ""
                                      :sexp_capture_next_element ""}))
                       :config #(let [hydra (require :hydra)
                                      conf (require :conf)]
                                  (let [form (hydra {:name "Move Form"
                                                     :config {:hint {:type :statusline}}
                                                     :heads [[:h
                                                              "<Plug>(sexp_swap_list_backward)"
                                                              {:desc :left}]
                                                             [:l
                                                              "<Plug>(sexp_swap_list_forward)"
                                                              {:desc :right}]
                                                             [:r
                                                              "<Plug>(sexp_raise_list)"
                                                              {:desc :raise}]
                                                             [:q
                                                              nil
                                                              {:exit true}]]})
                                        element (hydra {:name "Move Element"
                                                        :config {:hint {:type :statusline}}
                                                        :heads [[:h
                                                                 "<Plug>(sexp_swap_element_backward)"
                                                                 {:desc :left}]
                                                                [:l
                                                                 "<Plug>(sexp_swap_element_forward)"
                                                                 {:desc :right}]
                                                                [:r
                                                                 "<Plug>(sexp_raise_element)"
                                                                 {:desc :raise}]
                                                                [:q
                                                                 nil
                                                                 {:exit true}]]})
                                        head (hydra {:name "Move ("
                                                     :config {:hint {:type :statusline}}
                                                     :heads [[:h
                                                              "<Plug>(sexp_capture_prev_element)"
                                                              {:desc :left}]
                                                             [:l
                                                              "<Plug>(sexp_emit_head_element)"
                                                              {:desc :right}]
                                                             [:q
                                                              nil
                                                              {:exit true}]]})
                                        tail (hydra {:name "Move )"
                                                     :config {:hint {:type :statusline}}
                                                     :heads [[:h
                                                              "<Plug>(sexp_emit_tail_element)"
                                                              {:desc :left}]
                                                             [:l
                                                              "<Plug>(sexp_capture_next_element)"
                                                              {:desc :right}]
                                                             [:q
                                                              nil
                                                              {:exit true}]]})]
                                    (each [_ x (ipairs conf.lisp_langs)]
                                      (reg-ft x
                                              #(do
                                                 (map! :n :m
                                                       "<cmd>WhichKey m<cr>"
                                                       {:buffer true} :Menu)
                                                 (map! :n :mh #(head:activate)
                                                       {:buffer true}
                                                       "Move Head")
                                                 (map! :n :ml #(tail:activate)
                                                       {:buffer true}
                                                       "Move Tail")
                                                 (map! :n :me
                                                       #(element:activate)
                                                       {:buffer true}
                                                       "Move Element")
                                                 (map! :n :mf #(form:activate)
                                                       {:buffer true}
                                                       "Move Form"))
                                              :lisp))))})]
