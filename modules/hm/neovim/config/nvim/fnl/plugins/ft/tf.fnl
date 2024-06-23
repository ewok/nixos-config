(local {: pack} (require :lib))

(pack :hashivim/vim-terraform
      {:ft [:terraform]
       :config #(do
                  (set vim.g.terraform_align 1)
                  (set vim.g.terraform_fmt_on_save 0))})
