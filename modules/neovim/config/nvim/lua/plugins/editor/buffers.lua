local map = require("lib").map

-- map("n", "<leader>ba", function()
--     vim.cmd("enew")
-- end, { noremap = true }, "New Buffer")
map("n", "<leader>bo", function()
    vim.cmd("BufOnly")
end, { noremap = true }, "Only one Buffer")
-- map("n", "<Tab>", function()
--     vim.cmd("silent! bnext")
-- end, {}, "Goto next buffer")
-- map("n", "<S-Tab>", function()
--     vim.cmd("silent! bprevious")
-- end, {}, "Goto prev buffer")

return {
    {
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete", "Bwipeout" },
        init = function()
            map("n", "<leader>bd", function()
                vim.cmd("Bdelete")
            end, { noremap = true }, "Delete Buffer")
            map("n", "<C-W>d", "<CMD>Bdelete<CR>", { silent = true }, "Close current buffer")
            map("n", "<C-W><C-D>", "<CMD>Bdelete<CR>", { silent = true }, "Close current buffer")
        end,
    },
    {
        "ewok/hbac.nvim",
        event = "VeryLazy",
        config = function()
            require("hbac").setup({
                autoclose = true,
                threshold = 10,
                close_command = function(bufnr)
                    -- vim.api.nvim_buf_delete(bufnr, {})
                    require('bufdelete').bufdelete(bufnr)
                end,
                close_buffers_with_windows = false,
            })
            map("n", "<leader>bb", "<cmd>Hbac toggle_pin<cr>", { noremap = true }, "Pin Buffer")
            map("n", "<leader>bc", "<cmd>Hbac close_unpinned<cr>", { noremap = true }, "Close UnPinned buffers")
            map("n", "<leader>ba", "<cmd>Hbac pin_all<cr>", { noremap = true }, "Pin all buffers")
            map("n", "<leader>bA", "<cmd>Hbac unpin_all<cr>", { noremap = true }, "UnPin all buffers")
        end,
    },
    -- {
    --     "chrisgrieser/nvim-early-retirement",
    --     config = function()
    --         require("early-retirement").setup({
    --             minimumBufferNum = 3,
    --             notificationOnAutoClose = true,
    --             retirementAgeMins = 20,
    --             -- deleteBufferWhenFileDeleted = true,
    --         })
    --
    --         local id = vim.api.nvim_create_augroup("early-retirement", {
    --             clear = false,
    --         })
    --         vim.api.nvim_create_autocmd({ "BufRead" }, {
    --             group = id,
    --             pattern = { "*" },
    --             callback = function()
    --                 vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
    --                     buffer = 0,
    --                     once = true,
    --                     callback = function()
    --                         local bufnr = vim.api.nvim_get_current_buf()
    --                         vim.api.nvim_buf_set_var(bufnr, "ignore_early_retirement", true)
    --                     end,
    --                 })
    --             end,
    --         })
    --
    --         map("n", "<leader>bp", function()
    --             local cur_buf = vim.api.nvim_get_current_buf()
    --             local isSet, setTrue = pcall(vim.api.nvim_buf_get_var, cur_buf, "ignore_early_retirement")
    --             vim.api.nvim_buf_set_var(cur_buf, "ignore_early_retirement", not (isSet and setTrue))
    --         end, { noremap = true }, "Pin Buffer")
    --     end,
    --     event = "VeryLazy",
    -- },
}
