local wkmap = require'my.wk'.map

table.insert(pkgs, "chrisbra/Colorizer")

wkmap({['<leader>tc'] = {'<cmd>ColorToggle<CR>', 'Toggle Colors showing'}})
