local reg_ft = require "lib".reg_ft
local map = require "lib".map

reg_ft("qf", function()
    map('n', ':q', '<cmd>bdelete<CR>', { silent = true, buffer = true }, "Close")
    map('n', 'n', ':cnext|wincmd p<CR>', { silent = true, buffer = true }, "Next C item")
    map('n', 'p', ':cprevious|wincmd p<CR>', { silent = true, buffer = true }, "Previous C item")
    map('n', ']l', ':lnext|wincmd p<CR>', { silent = true, buffer = true }, "Next L item")
    map('n', '[l', ':lprevious|wincmd p<CR>', { silent = true, buffer = true }, "Previous L item")
end)
