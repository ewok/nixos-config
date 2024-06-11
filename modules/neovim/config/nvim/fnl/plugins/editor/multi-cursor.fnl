(local {: pack} (require :lib))

(pack :mg979/vim-visual-multi
      {:keys [{1 :<c-n> :mode :n}]
       :config #(do
                  (set vim.g.VM_Extend_hl :DiffAdd)
                  (set vim.g.VM_Cursor_hl :Visual)
                  (set vim.g.VM_Mono_hl :DiffText)
                  (set vim.g.VM_Insert_hl :DiffChange)
                  (set vim.g.VM_default_mappings 0)
                  (set vim.g.VM_maps
                       {"Find Under" :<c-n>
                        "Find Prev" :<c-p>
                        "Skip Region" :<c-s>
                        "Remove Region" :<c-d>}))})
