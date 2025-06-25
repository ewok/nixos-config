(local {: pack : map} (require :lib))

(pack :jake-stewart/multicursor.nvim
      {:branch :1.0
       :keys [{1 :<c-n> :mode [:n :x]}
              {1 :<c-q> :mode [:n :x]}
              {1 :<up> :mode [:n :x]}
              {1 :<down> :mode [:n :x]}]
       :config #(let [mc (require :multicursor-nvim)]
                  (mc.setup)
                  (mc.addKeymapLayer (fn [layerSet]
                                       (layerSet [:n :x] :<c-k> mc.prevCursor)
                                       (layerSet [:n :x] :<c-j> mc.nextCursor)
                                       (layerSet [:n :x] :<c-p>
                                                 #(mc.matchAddCursor -1))
                                       (layerSet [:n :x] :<c-s>
                                                 #(mc.matchSkipCursor 1))
                                       (layerSet [:n :x] "*"
                                                 mc.matchAllAddCursors)
                                       (layerSet [:n :x] :<c-x> mc.deleteCursor)
                                       (layerSet [:n :x] :<esc>
                                                 (fn []
                                                   (if (not (mc.cursorsEnabled))
                                                       (mc.enableCursors)
                                                       (mc.clearCursors))))))
                  (map [:n :x] :<up> #(mc.lineAddCursor -1) {} :None)
                  (map [:n :x] :<down> #(mc.lineAddCursor 1) {} :None)
                  (map [:n :x] :<c-n> #(mc.matchAddCursor 1) {} :None)
                  (map [:n :x] :<c-q> #(mc.toggleCursor) {} :None))})
