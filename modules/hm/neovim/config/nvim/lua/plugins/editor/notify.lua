local lib = require("lib")
local map = lib.map

return {
    "j-hui/fidget.nvim",
    lazy = false,
    config = function()
        require("fidget").setup({
            notification = {
                override_vim_notify = true,
                window = {
                    normal_hl = "Keyword",
                    align = "top",
                },
                view = {
                    stack_upwards = false,
                },
            },
        })
    end,
    init = function()
        map("n", "<leader>N", "<cmd>Fidget history<cr>", { silent = true }, "Open notification history")
    end,
}
