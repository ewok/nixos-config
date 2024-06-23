(local {: pack} (require :lib))

(pack :NMAC427/guess-indent.nvim
      {:event [:BufReadPre :BufNewFile]
       :config #(let [conf (require :conf)]
                  ((-> (require :guess-indent) (. :setup)) {:auto_cmd true
                                                            :override_editorconfig false
                                                            :filetype_exclude conf.ui_ft
                                                            :buftype_exclude [:help
                                                                              :nofile
                                                                              :terminal
                                                                              :prompt]}))})
