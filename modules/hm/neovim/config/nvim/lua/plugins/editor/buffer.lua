local map = require("lib").map

map("n", "<C-w>O", function()
    vim.cmd("BufOnly")
    vim.cmd("LspRestart")
end, { noremap = true }, "Wipe all buffers but one")

return {
    -- { "serhez/bento.nvim", opts = {}, lazy = false, config = true },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            local bqf = require("bqf")
            bqf.setup({
                func_map = {
                    tab = "<C-t>",
                    vsplit = "<C-v>",
                    split = "<C-s>",
                },
                filter = {
                    fzf = {
                        action_for = {
                            ["ctrl-t"] = "tabedit",
                            ["ctrl-v"] = "vsplit",
                            ["ctrl-s"] = "split",
                        },
                    },
                },
            })
        end,
    },
    {
        "stevearc/quicker.nvim",
        ft = "qf",
        init = function()
            map("n", "<leader>q", "<cmd>lua require('quicker').toggle()<cr>", { noremap = true }, "Toggle quickfix")
            map(
                "n",
                "<leader>tl",
                    "<cmd>lua require('quicker').toggle({loclist = true})<cr>",
                { noremap = true },
                "Toggle loclist"
            )
        end,
        config = true,
    },
    {
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete", "Bwipeout" },
        init = function()
            map("n", "<C-W>d", "<CMD>Bdelete<CR>", { silent = true }, "Close current buffer")
            map("n", "<C-W><C-D>", "<CMD>Bdelete<CR>", { silent = true }, "Close current buffer")
        end,
    },
}
