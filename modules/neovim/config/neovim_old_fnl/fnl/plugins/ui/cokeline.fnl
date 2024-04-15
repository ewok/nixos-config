(local {: map! : pack : close_sidebar} (require :lib))

(fn init []
  (map! :n :<C-W>d "<cmd>lua require('scope.core').delete_buf()<cr>"
        {:silent true} "Close current buffer")
  (map! :n :<C-W><C-D> "<cmd>lua require('scope.core').delete_buf()<cr>"
        {:silent true} "Close current buffer"))

(local buff_hint "^^         Buffers           ^^     Tabs
 ^^---------------            ^^---------------
 _j_, _k_: next/previous      ^^ _L_, _H_: next/previous
 _d_: delete                  ^^ _D_: delete
 _a_: new                     ^^ _A_: new
 _o_: remain only             ^^ _O_: remain only
 any : quit
 ")

(fn find-file [nvim-tree-api]
  (let [win (vim.api.nvim_get_current_win)]
    (nvim-tree-api.tree.find_file {:open true :focus false})))

(fn config []
  (let [cokeline (require :cokeline)
        mapping (require :cokeline.mappings)
        get-hex (. (require :cokeline.hlgroups) :get_hl_attr)
        get-mode (. (require :lualine.utils.mode) :get_mode)
        normal-fg #(get-hex :lualine_a_normal :fg)
        normal-bg #(get-hex :lualine_a_normal :bg)
        insert-fg #(get-hex :lualine_a_insert :fg)
        insert-bg #(get-hex :lualine_a_insert :bg)
        command-fg #(get-hex :lualine_a_command :fg)
        command-bg #(get-hex :lualine_a_command :bg)
        visual-fg #(get-hex :lualine_a_visual :fg)
        visual-bg #(get-hex :lualine_a_visual :bg)
        inactive-fg #(get-hex :lualine_a_inactive :fg)
        inactive-bg #(get-hex :lualine_a_inactive :bg)
        active-fg #(match (get-mode)
                     :VISUAL (visual-fg)
                     :V-BLOCK (visual-fg)
                     :V-LINE (visual-fg)
                     :V-REPLACE (visual-fg)
                     :COMMAND (command-fg)
                     :INSERT (insert-fg)
                     _ (normal-fg))
        active-bg #(match (get-mode)
                     :VISUAL (visual-bg)
                     :V-BLOCK (visual-bg)
                     :V-LINE (visual-bg)
                     :V-REPLACE (visual-bg)
                     :COMMAND (command-bg)
                     :INSERT (insert-bg)
                     _ (normal-bg))
        win-fg (fn [buffer]
                 (if buffer.is_focused
                     (active-fg)
                     (inactive-fg)))
        win-bg (fn [buffer]
                 (if buffer.is_focused
                     (active-bg)
                     (inactive-bg)))
        tab-fg (fn [tab]
                 (if tab.is_active
                     (active-fg)
                     (inactive-fg)))
        tab-bg (fn [tab]
                 (if tab.is_active
                     (active-bg)
                     (inactive-bg)))]
    (cokeline.setup {:buffers {:filter_visible (fn [buffer]
                                                 (and (not= buffer.type
                                                            :terminal)
                                                      (not= buffer.type :help)
                                                      (not= buffer.type :nofile)))
                               :new_buffers_position :directory}
                     ;; Only one supported for now
                     :sidebar {:filetype [:NvimTree :undotree :mind :aerial]
                               :components [{:text (fn [buffer] buffer.filetype)
                                             :style :bold}]}
                     :default_hl {:bg inactive-bg}
                     :components [{:text (fn [buffer]
                                           (if buffer.is_focused
                                               conf.separator.right
                                               conf.separator.alt_right))
                                   :fg win-bg}
                                  {:text " " :fg win-fg :bg win-bg}
                                  {:text (fn [buffer]
                                           (.. (if buffer.is_readonly "🔒 "
                                                   "")
                                               (if buffer.is_modified "● "
                                                   "")
                                               buffer.devicon.icon
                                               buffer.unique_prefix
                                               buffer.filename))
                                   :style (fn [buffer]
                                            (if buffer.is_focused :bold nil))
                                   :fg win-fg
                                   :bg win-bg}
                                  {:text (fn [buffer]
                                           (if (not= buffer.diagnostics.errors
                                                     0)
                                               (.. " "
                                                   conf.icons.diagnostic.Error
                                                   " " buffer.diagnostics.errors)
                                               (if (not= buffer.diagnostics.warnings
                                                         0)
                                                   (.. " "
                                                       conf.icons.diagnostic.Warn
                                                       " "
                                                       buffer.diagnostics.warnings)
                                                   "")))
                                   :fg (fn [buffer]
                                         (if (not= buffer.diagnostics.errors 0)
                                             (get-hex :ErrorMsg :fg)
                                             (if (not= buffer.diagnostics.warnings
                                                       0)
                                                 (get-hex :IncSearch :bg)
                                                 nil)))
                                   :style (fn [buffer]
                                            (if buffer.is_focused :bold nil))
                                   :bg win-bg}
                                  {:text " " :fg win-fg :bg win-bg}
                                  {:text (fn [buffer]
                                           (if buffer.is_focused
                                               conf.separator.left
                                               conf.separator.alt_left))
                                   :fg (fn [buffer]
                                         (if buffer.is_focused
                                             (active-bg)
                                             (inactive-fg)))}]
                     :tabs {:placement :right
                            :components [{:text (fn [tab]
                                                  (if (and (= tab.number 1)
                                                           tab.is_last)
                                                      ""
                                                      (if tab.is_active
                                                          conf.separator.right
                                                          conf.separator.alt_right)))
                                          :fg (fn [tab]
                                                (if tab.is_active
                                                    (active-bg)
                                                    (inactive-fg)))}
                                         {:text (fn [tab]
                                                  (if (and (= tab.number 1)
                                                           tab.is_last)
                                                      ""
                                                      (.. " " tab.number " ")))
                                          :fg tab-fg
                                          :bg tab-bg}
                                         {:text (fn [tab]
                                                  (if (and (= tab.number 1)
                                                           tab.is_last)
                                                      ""
                                                      (if tab.is_active
                                                          conf.separator.left
                                                          conf.separator.alt_left)))
                                          :fg tab-bg}]}
                     :rhs [{:text " "}
                           {:text (fn []
                                    (string.gsub (vim.fn.getcwd)
                                                 (os.getenv :HOME) "~"))}
                           {:text " "}]})
    (map! :n :<S-Tab> #(do
                         (mapping.by_step :focus -1)) {}
          :Buffers/Tabs)
    (map! :n :<Tab> #(do
                       (mapping.by_step :focus 1)) {}
          :Buffers/Tabs)
    (map! :n :<leader>b #(let [hydra (require :hydra)
                               buff_tabs (hydra {:name :Buffers/Tabs
                                                 :hint buff_hint
                                                 :config {:hint {:border :rounded}
                                                          :on_exit #(close_sidebar :NvimTree)
                                                          :on_enter #(let [nvim-tree-api (require :nvim-tree.api)]
                                                                       ; (vim.cmd :NvimTreeOpen)
                                                                       (find-file nvim-tree-api))
                                                          :on_key #(let [nvim-tree-api (require :nvim-tree.api)]
                                                                     (find-file nvim-tree-api))}
                                                 :heads [[:j
                                                          #(mapping.by_step :focus
                                                                            1)]
                                                         [:k
                                                          #(mapping.by_step :focus
                                                                            -1)]
                                                         [:d
                                                          #(let [scope (require :scope.core)]
                                                             (scope.delete_buf))
                                                          {:desc :delete}]
                                                         [:a
                                                          #(vim.cmd :enew)
                                                          {:desc :new
                                                           :exit true}]
                                                         [:o
                                                          #(vim.cmd :BufOnly)
                                                          {:desc :only
                                                           :exit true}]
                                                         [:L
                                                          #(vim.cmd :tabnext)]
                                                         [:H
                                                          #(vim.cmd :tabprevious)]
                                                         [:D
                                                          #(vim.cmd :tabclose)
                                                          {:desc :delete}]
                                                         [:A
                                                          #(vim.cmd :$tabnew)
                                                          {:desc :new
                                                           :exit true}]
                                                         [:O
                                                          #(vim.cmd :tabonly)
                                                          {:desc :only
                                                           :exit true}]]})]
                           (: buff_tabs :activate)) {}
          :Buffers/Tabs)))

(pack :willothy/nvim-cokeline {: config : init})
