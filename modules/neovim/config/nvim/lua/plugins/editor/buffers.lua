local map = require("lib").map

map("n", "<leader>bw", function()
    vim.cmd("BufOnly")
end, { noremap = true }, "Wipe all except one Buffer")

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
        "axkirillov/hbac.nvim",
        event = "BufReadPost",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            local telescope = require("telescope")
            local actions = require("hbac.telescope.actions")
            require("hbac").setup({
                autoclose = true,
                threshold = 10,
                close_command = function(bufnr)
                    -- vim.api.nvim_buf_delete(bufnr, {})
                    require("bufdelete").bufdelete(bufnr)
                end,
                close_buffers_with_windows = false,
                telescope = {
                    show_all_buffers = true,
                    sort_mru = true,
                    select_current = true,
                    theme = "dropdown",
                    previewer = false,
                    use_default_mappings = false,
                    layout_strategy = "dropdown",
                    mappings = {
                        i = {
                            ["<C-a>"] = actions.pin_all,
                            ["<c-d>"] = actions.delete_buffer,
                            ["<C-o>"] = actions.close_unpinned,
                            ["<C-Space>"] = actions.toggle_pin,
                            ["<C-u>"] = actions.unpin_all,
                        },
                    },
                },
            })

            map("n", "<leader>ba", "<cmd>Hbac pin_all<cr>", { noremap = true }, "Pin all buffers")
            map("n", "<leader>bb", "<cmd>Hbac toggle_pin<cr>", { noremap = true }, "Pin Buffer")
            map("n", "<leader>bo", "<cmd>Hbac close_unpinned<cr>", { noremap = true }, "Close UnPinned buffers")
            map("n", "<leader>bu", "<cmd>Hbac unpin_all<cr>", { noremap = true }, "UnPin all buffers")

            telescope.load_extension("hbac")
            local CallTelescope = function(input)
                local theme = require("telescope.themes").get_dropdown({})
                input(theme)
            end

            map("n", "<leader>fb", function()
                CallTelescope(telescope.extensions.hbac.buffers)
            end, { silent = true }, "Find all buffers")
        end,
    },
}
