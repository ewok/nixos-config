return {
    {
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete", "Bwipeout" },
    },
    {
        "chrisgrieser/nvim-early-retirement",
        config = function()
            require("early-retirement").setup({
                minimumBufferNum = 1,
                notificationOnAutoClose = true,
                retirementAgeMins = 20,
                -- deleteBufferWhenFileDeleted = true,
            })

            local id = vim.api.nvim_create_augroup("early-retirement", {
                clear = false,
            })
            vim.api.nvim_create_autocmd({ "BufRead" }, {
                group = id,
                pattern = { "*" },
                callback = function()
                    vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
                        buffer = 0,
                        once = true,
                        callback = function()
                            local bufnr = vim.api.nvim_get_current_buf()
                            vim.api.nvim_buf_set_var(bufnr, "ignore_early_retirement", true)
                        end,
                    })
                end,
            })

            local map = require("lib").map
            map("n", "<leader>bp", function()
                local cur_buf = vim.api.nvim_get_current_buf()
                local isSet, setTrue = pcall(vim.api.nvim_buf_get_var, cur_buf, "ignore_early_retirement")
                vim.api.nvim_buf_set_var(cur_buf, "ignore_early_retirement", not (isSet and setTrue))
            end, { noremap = true }, "Pin Buffer")
        end,
        event = "VeryLazy",
    },
}
