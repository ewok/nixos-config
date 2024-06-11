(local {: set!} (require :lib))
(local conf (require :conf))

; ;; auto save buffer
; (if _G.conf.options.auto_save
;     (vim.api.nvim_create_autocmd [:InsertLeave :TextChanged]
;                                  {:pattern ["*"]
;                                   :command "silent! wall"
;                                   :nested true}))

;; auto restore cursor position
(if conf.options.auto_restore_cursor_position
    (vim.api.nvim_create_autocmd [:BufReadPost]
                                 {:pattern ["*"]
                                  :callback (fn []
                                              (if (and (> (vim.fn.line "'\"") 0)
                                                       (<= (vim.fn.line "'\"")
                                                           (vim.fn.line "$")))
                                                  (do
                                                    (vim.fn.setpos "."
                                                                   (vim.fn.getpos "'\""))
                                                    (vim.cmd "silent! foldopen"))))}))

;; remove auto-comments
(if conf.options.auto_remove_new_lines_comment
    (vim.api.nvim_create_autocmd [:BufEnter]
                                 {:pattern ["*"]
                                  :callback (fn []
                                              (set! "" :formatoptions
                                                    [:c :r :o] :remove))}))

;; auto toggle rnu
(if conf.options.auto_toggle_rnu
    (do
      (tset vim.wo :rnu true)
      (vim.api.nvim_create_autocmd [:InsertLeave]
                                   {:pattern ["*"]
                                    :callback (fn []
                                                (if (vim.api.nvim_get_option :showcmd)
                                                    (tset vim.wo :rnu true)))})
      (vim.api.nvim_create_autocmd [:InsertEnter]
                                   {:pattern ["*"]
                                    :callback (fn []
                                                (if (vim.api.nvim_get_option :showcmd)
                                                    (tset vim.wo :rnu false)))})))

;; auto hide cursorline
(if conf.options.auto_hide_cursorline
    (do
      (vim.api.nvim_create_autocmd [:InsertLeave]
                                   {:pattern ["*"] :command "set cursorline"})
      (vim.api.nvim_create_autocmd [:InsertEnter]
                                   {:pattern ["*"] :command "set nocursorline"})))

(fn buffer-delete-only []
  (let [del-non-modifiable false
        ; true if you want to delete non-modifiable buffers
        cur (vim.api.nvim_get_current_buf)]
    (each [_ n (ipairs (vim.api.nvim_list_bufs))]
      (if (and (not= n cur) (or (vim.api.nvim_buf_get_option n :modifiable)
                                del-non-modifiable)
               (not= (vim.api.nvim_buf_get_option n :filetype) :aerial))
          (vim.api.nvim_buf_delete n {})))
    (vim.cmd :redrawt)))

(vim.api.nvim_create_user_command :BufOnly buffer-delete-only
                                  {:desc "Delete all other buffers"})

;; Autoread
(tset vim.opt :autoread true)
; (vim.api.nvim_create_autocmd [:BufEnter :CursorHold :CursorHoldI :FocusGained]
;                              {:callback #(let [{: mode} (vim.api.nvim_get_mode)]
;                                            (when (not= :c mode)
;                                              (pcall vim.cmd :checktime)))
;                               :pattern ["*"]})

;; Autosize windows
(vim.api.nvim_create_autocmd [:VimResized] {:command "wincmd =" :pattern ["*"]})

;; load local vimrc
(vim.api.nvim_exec "\n try\n source ~/.vimrc.local\n catch\n endtry" nil)
