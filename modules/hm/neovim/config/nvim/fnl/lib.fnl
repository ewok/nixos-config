(fn map [mode lhs rhs options desc]
  "Map keybinding"
  (do
    (doto options (tset :desc desc))
    (vim.keymap.set mode lhs rhs options)))

(fn umap [mode lhs options]
  "Unmap keybinding"
  (pcall vim.keymap.del mode lhs options))

(lambda reg_ft [ft fun ?postfix]
  "Register function for filetype"
  (let [ft_name (.. :ft_ ft (if ?postfix ?postfix ""))]
    (vim.api.nvim_create_augroup ft_name {:clear true})
    (vim.api.nvim_create_autocmd [:FileType]
                                 {:pattern [ft] :callback fun :group ft_name})))

(lambda path_join [...]
  "Join path"
  (table.concat (vim.tbl_flatten [...]) "/"))

(lambda set! [scope key val act]
  "Set option:
    :scope - global, local, ''
    :key - option name
    :val - option value
    :act - append, prepend, get"
  (let [key (tostring key)
        opt (. vim (.. :opt scope) key)]
    (: opt act val)))

(lambda cmd! [...]
  "Execute command"
  (vim.cmd (table.concat (vim.tbl_flatten [...]) "\n")))

(lambda exists? [name]
  "Check if variable exists"
  (not (= 0 (vim.fn.exists name))))

(lambda pack [identifier ?options]
  "A workaround around the lack of mixed tables in Fennel.
  Has special `options` keys for enhanced utility.
  See `:help themis.pack.lazy.pack` for information about how to use it.
  from: https://github.com/datwaft/themis.nvim/blob/main/fnl/themis/pack/lazy.fnl
  "
  (let [options (or ?options {})
        options (collect [k v (pairs options)]
                  (match k
                    :require* (values :config #(require `,v))
                    _ (values k v)))]
    (doto options (tset 1 identifier))))

(fn get_all_win_buf_ft []
  (let [win_tbl (vim.api.nvim_list_wins)
        result []]
    (each [_ win_id (ipairs win_tbl)]
      (if (vim.api.nvim_win_is_valid win_id)
          (let [buf_id (vim.api.nvim_win_get_buf win_id)]
            (table.insert result
                          {: win_id
                           : buf_id
                           :buf_ft (vim.api.nvim_buf_get_option buf_id
                                                                :filetype)}))))
    result))

(fn get_buf_ft [buf_id]
  (vim.api.nvim_buf_get_option buf_id :filetype))

(fn toggle_sidebar [target_ft]
  (let [offset_ft [:NvimTree :undotree :dbui :spectre_panel :mind]]
    (each [_ opts (ipairs (get_all_win_buf_ft))]
      (if (and (not (= opts.buf_ft target_ft))
               (vim.tbl_contains offset_ft opts.buf_ft))
          (vim.api.nvim_win_close opts.win_id true)))))

(fn close_sidebar [target_ft]
  (each [_ opts (ipairs (get_all_win_buf_ft))]
    (if (= opts.buf_ft target_ft)
        (vim.api.nvim_win_close opts.win_id true))))

;; True if filetype in Window otherwise False
(fn is_ft_open [target_ft]
  (each [_ opts (ipairs (get_all_win_buf_ft))]
    (if (= opts.buf_ft target_ft)
        (lua "return true"))))

(fn get_file_cwd []
  (let [current_path (vim.fn.expand "%:p")
        cwd (vim.loop.cwd)]
    (if (= 1 (vim.fn.filereadable current_path))
        (let [current_parent (vim.fn.expand "%:p:h")]
          (if (or (= "" current_parent) (= nil current_parent))
              cwd
              current_parent))
        cwd)))

(fn once [name fun]
  (when (not (. _G name))
    (tset _G name true)
    (fun)))

(fn reg_ft_once [filetype fun]
  (vim.api.nvim_create_autocmd :FileType
                               {:pattern filetype :callback fun :once true}))

(local lsps {})

(lambda reg_lsp [lsp settings]
  (tset lsps lsp settings))

(fn has_value [tbl value]
  (var found? false)
  (each [_ v (pairs tbl) &until (not found?)]
    (when (= v value)
      (set found? true)))
  found?)

(fn has_key [tbl key]
  (not= nil (. tbl key)))

(fn is_loaded [module]
  (has_key package.loaded module))

(local t (fn [str]
           (vim.api.nvim_replace_termcodes str true true true)))

(fn open-file [orig-window filename cursor-position command]
  (when (and (not= orig-window 0) orig-window)
    (vim.api.nvim_set_current_win orig-window))
  (pcall vim.cmd (string.format "%s %s" command filename))
  (vim.api.nvim_win_set_cursor 0 cursor-position))

{: open-file
 : close_sidebar
 : cmd!
 : exists?
 : get_buf_ft
 : get_file_cwd
 : has_key
 : has_value
 : is_ft_open
 : is_loaded
 : lsps
 : map
 :map! map
 : once
 : pack
 : path_join
 : reg_ft
 : reg_ft_once
 :reg-ft reg_ft
 : reg_lsp
 : set!
 :set set!
 : t
 : toggle_sidebar
 : umap}
