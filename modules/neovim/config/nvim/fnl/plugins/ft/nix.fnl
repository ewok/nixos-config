(local {: pack} (require :lib))

(pack :mrcjkb/telescope-manix
      {:dependencies [:nvim-telescope/telescope.nvim]
       :config #(let [telescope (require :telescope)]
                  (telescope.load_extension :manix))})
