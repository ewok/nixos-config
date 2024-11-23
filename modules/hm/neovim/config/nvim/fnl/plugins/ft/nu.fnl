(local {: pack} (require :lib))

(pack :LhKipp/nvim-nu
      {
       :ft [:nu]
       :config #(let [nu (require :nu)]
                  (nu.setup))})
