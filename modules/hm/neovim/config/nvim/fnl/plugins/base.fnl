(local {: pack} (require :lib))

[(pack :nvim-tree/nvim-web-devicons {:lazy false :config false})
 (pack :nvim-lua/plenary.nvim {:lazy false :config false})
 (pack :stevearc/dressing.nvim {:event :VeryLazy :config false})]
