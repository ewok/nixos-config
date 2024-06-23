(local {: reg_ft : map} (require :lib))

(reg_ft :qf
        (fn [ev]
          (map [:n] :q :<cmd>bdelete<cr> {:silent true :buffer true} :Close)
          (map :n :ri
               ":cdo s/\\<<c-r>=expand(\"<cword>\")<cr>\\>//gc<LEFT><LEFT><LEFT>"
               {:buffer ev.buf} "cdo <cword>")
          (map :n :rI
               ":cdo %s/\\<<c-r>=expand(\"<cword>\")<cr>\\>//gc<LEFT><LEFT><LEFT>"
               {:buffer ev.buf} "cdo %<cword>")
          (map :v :ri "y:cdo s/<c-r>0//gc<LEFT><LEFT><LEFT>" {:buffer ev.buf}
               "cdo <visual>")
          (map :n :ra ":cdo s///gc<LEFT><LEFT><LEFT><LEFT>" {:buffer ev.buf}
               "cdo <>")
          (map :n :rA ":cdo %s///gc<LEFT><LEFT><LEFT><LEFT>" {:buffer ev.buf}
               "cdo %<>")
          (vim.cmd "nmap <expr><buffer>  MR  ':cdo s/' . @/ . '//gc<LEFT><LEFT><LEFT>'")
          (map :n :r "<cmd>WhichKey r<cr>" {:buffer ev.buf} :Close)))

(fn toggle_qf []
  (do
    (var qf-exists? false)
    (each [_ win (pairs (vim.fn.getwininfo)) &until (= qf-exists? true)]
      (when (= win.quickfix 1)
        (set qf-exists? true)))
    (if qf-exists?
        (vim.cmd :cclose)
        (when (not (vim.tbl_isempty (vim.fn.getqflist)))
          (vim.cmd :copen)))))

(map :n :<leader>q toggle_qf {:silent true} "Toggle QF")
