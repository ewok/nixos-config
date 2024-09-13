(local {: reg-ft : map!} (require :lib))

(each [_ x (ipairs [:help :NeogitDiffViewCommit])]
  (reg-ft x
          #(map! [:n] :q :<cmd>bdelete<cr> {:silent true :buffer true} :Close)))
