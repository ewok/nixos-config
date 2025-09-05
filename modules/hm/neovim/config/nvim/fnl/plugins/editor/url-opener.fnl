(local {: pack} (require :lib))

[(pack :ruifm/gitlinker.nvim {:opts {:opts {:print_url false} :mappings nil}})
 (pack :chrishrb/gx.nvim
       {:keys [{1 :gx 2 :<cmd>Browse<cr> :mode [:n :x]}]
        :cmd [:Browse]
        :init #(set vim.g.netrw_nogx 1)
        :opts {:handler_options {:select_for_search true}
               :handlers {:plugin true
                          :github true
                          :brewfile false
                          :package_json false
                          :search true
                          :go true
                          :gitlinker {:name :gitlinker
                                      :handle (fn [mode _ _]
                                                (let [linker (require :gitlinker)
                                                      mode (if (= mode :n) :n
                                                               :v)]
                                                  (linker.get_buf_range_url mode
                                                                            {}
                                                                            {:silent true})))}
                          :tf {:name :tf
                               :filetype [:terraform]
                               :handle (fn [mode line _]
                                         (let [helper (require :gx.helper)
                                               atype (helper.find line mode
                                                                  "(%w+) ")]
                                           (when (or (= atype :resource)
                                                     (= atype :data))
                                             (let [provider (helper.find line
                                                                         mode
                                                                         "%w+ \"(%w+)_.+\" ")
                                                   resource (helper.find line
                                                                         mode
                                                                         "resource \"%w+_([a-zA-Z_]+)\" ")
                                                   data (helper.find line mode
                                                                     "data \"%w+_([a-zA-Z_]+)\" ")
                                                   url (match provider
                                                         :aws "https://registry.terraform.io/providers/hashicorp/aws/"
                                                         :terraform "https://registry.terraform.io/providers/hashicorp/terraform/"
                                                         :gitlab "https://registry.terraform.io/providers/gitlabhq/gitlab/"
                                                         :databricks "https://registry.terraform.io/providers/databricks/databricks/")]
                                               (when url
                                                 (if resource
                                                     (.. url
                                                         :latest/docs/resources/
                                                         resource)
                                                     (when data
                                                       (.. url
                                                           :latest/docs/data-sources/
                                                           data))))))))}}}})]
