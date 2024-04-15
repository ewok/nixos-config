(local {: pack} (require :lib))

[;; Ansible
 (pack :mfussenegger/nvim-ansible {:config false
                                   :ft :ansible
                                   ;; :event [:BufReadPre :BufNewFile]
                                   })]
