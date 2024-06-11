(local {: pack} (require :lib))

(pack :linux-cultist/venv-selector.nvim
      {:branch :regexp
       :cmd [:VenvSelectCached :VenvSelect]
       :config #(let [venv (require :venv-selector)]
                  (venv.setup))})
