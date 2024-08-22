(local {: pack} (require :lib))

(pack :otavioschwanck/arrow.nvim {:event :VeryLazy
                                  :opts {:show_icons true
                                         :leader_key ";"
                                         :buffer_leader_key :m
                                         ; :index_keys :123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP
                                         }})
