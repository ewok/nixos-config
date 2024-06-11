(local lib (require :lib))

(lib.reg_ft :nix
            (fn [ev]
              (lib.map :n :<leader>fm
                       "<Cmd>lua require('telescope').extensions.manix.manix()<CR>"
                       {:silent true :buffer ev.buf} "Nix manual[manix] ")))

(lib.reg_lsp :nil_ls {})
;
(lib.reg_ft_once :nix
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.nixpkgs_fmt])))
