(local {: pack} (require :lib))

(pack :okuuva/auto-save.nvim
      {:cmd :ASToggle
       :event [:InsertLeave :TextChanged]
       :opts {:enabled true
              :execution_message {:enabled false
                                  :message #(.. "AutoSave: saved at "
                                                (vim.fn.strftime "%H:%M:%S"))
                                  :dim 0.18
                                  :cleaning_interval 250}
              :trigger_events {:immediate_save [:BufLeave :FocusLost]
                               :defer_save [:InsertLeave :TextChanged]
                               :cancel_defered_save [:InsertEnter]}
              :condition nil
              :write_all_buffers false
              :noautocmd false
              :lockmarks false
              :debounce_delay 1000
              :debug false}})
