local lib = require("lib")
local reg_ft, map = lib.reg_ft, lib.map

for _, x in ipairs({ "help", "NeogitDiffViewCommit" }) do
    reg_ft(x, function()
        map("n", "q", "<cmd>bdelete<cr>", { silent = true, buffer = true }, "Close")
    end)
end
