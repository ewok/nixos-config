local lib = require("lib")
local map = lib.map

return {
    "jiaoshijie/undotree",
    init = function()
        map("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { silent = true }, "Toggle Undo Tree")
    end,
}
