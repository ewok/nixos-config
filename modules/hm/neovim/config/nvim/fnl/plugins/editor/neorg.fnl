(local {: pack} (require :lib))

(pack :nvim-orgmode/orgmode
      {:event :VeryLazy
       :ft [:org]
       :config #(let [orgmode (require :orgmode)]
                  (orgmode.setup {:org_agenda_files "~/Notes/org/**/*"
                                  :org_default_notes_file "~/Notes/org/refile.org"}))})
