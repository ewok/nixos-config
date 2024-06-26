(local {: pack} (require :lib))

(pack :ramilito/kubectl.nvim
      {:keys [{1 :<leader>ok
               2 #(let [kc (require :kubectl)]
                    (kc.open))
               :desc :Kubectl}]
       :config #(let [kc (require :kubectl)]
                  (kc.setup {}))})
