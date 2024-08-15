(local {: pack} (require :lib))

(pack :otavioschwanck/arrow.nvim
      {:event :VeryLazy
       :opts {:show_icons true
              :leader_key ";"
              :buffer_leader_key :m
              :index_keys :trwgfyuiophjklbcxznm1234567890}})
