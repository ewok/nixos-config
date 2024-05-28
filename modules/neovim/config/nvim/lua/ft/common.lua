local reg_ft = require("lib").reg_ft
local map = require("lib").map

for _, x in ipairs({ "help" }) do
    reg_ft(x, function()
        map("n", "q", "<cmd>bdelete<cr>", { silent = true, buffer = true }, "Close")
    end)
end
