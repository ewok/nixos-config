(local {: pack} (require :lib))

[(pack :nvim-tree/nvim-web-devicons {:lazy false :config false})
 (pack :nvim-lua/plenary.nvim {:lazy false :config false})
 ;; TODO: Deprecated, to be substituted with something else
 (pack :stevearc/dressing.nvim {:event :VeryLazy :config false})
 (pack :nvimtools/hydra.nvim {:config true})
 (pack :MunifTanjim/nui.nvim)
 (pack :neovim/nvim-lspconfig {:lazy false})]
