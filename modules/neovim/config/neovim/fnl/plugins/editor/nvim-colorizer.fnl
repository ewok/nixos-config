;; Colorizer
(local {: pack : map!} (require :lib))

(pack :norcalli/nvim-colorizer.lua
      {;;:event [:InsertEnter :BufReadPre]
       :cmd [:ColorizerToggle]
       :init #(map! [:n] :<leader>tC :<cmd>ColorizerToggle<cr> {:silent true}
                    "Code Colorizer")})
