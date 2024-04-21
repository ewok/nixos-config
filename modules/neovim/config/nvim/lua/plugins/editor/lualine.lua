return {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    init = function()
        local map = require("lib").map

        map("n", "<C-W>d", "<cmd>lua require('scope.core').delete_buf()<cr>", { silent = true }, "Close current buffer")
        map(
            "n",
            "<C-W><C-D>",
            "<cmd>lua require('scope.core').delete_buf()<cr>",
            { silent = true },
            "Close current buffer"
        )
    end,
    config = function()
        local lualine = require("lualine")
        local conf = require("conf")
        lualine.setup({
            options = {
                theme = conf.options.theme or "auto",
                icons_enabled = true,
                component_separators = { left = conf.separator.alt_left, right = conf.separator.alt_right },
                section_separators = { left = conf.separator.left, right = conf.separator.right },
                disabled_filetypes = {},
                globalstatus = true,
                refresh = {
                    statusline = 100,
                    winbar = 100,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            tabline = {
                lualine_a = { "buffers" },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "tabs" },
                lualine_z = { 'string.gsub(vim.fn.getcwd(), os.getenv("HOME"), "~")' },
            },
        })

        local map = require("lib").map
        -- map("n", "<Tab>", function()
        --     vim.cmd("silent! bnext")
        --     require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
        -- end, {}, "Goto next buffer")
        -- map("n", "<S-Tab>", function()
        --     vim.cmd("silent! bprevious")
        --     require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
        -- end, {}, "Goto prev buffer")

        local hydra = require("hydra")
        map("n", "<leader>j", function()
            hydra({
                name = "Switch buffers",

                config = {
                    hint = { type = "statusline" },
                    on_enter = function()
                        vim.cmd("silent! bnext")
                        require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                    end,
                    on_key = function()
                        require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                    end,
                    timeout = 300,
                },
                heads = {
                    { "k", "<cmd>silent! bprevious<CR>", { desc = "prev" } },
                    { "j", "<cmd>silent! bnext<CR>", { desc = "next" } },
                    { "q", nil, { exit = true } },
                },
            }):activate()
        end, { noremap = true }, "Goto next buffer")

        map("n", "<leader>k", function()
            hydra({
                name = "Switch buffers",

                config = {
                    hint = { type = "statusline" },
                    on_enter = function()
                        vim.cmd("silent! bprevious")
                        require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                    end,
                    on_key = function()
                        require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                    end,
                    timeout = 300,
                },
                heads = {
                    { "k", "<Cmd>silent! bprevious<CR>", { desc = "prev" } },
                    { "j", "<Cmd>silent! bnext<CR>", { desc = "next" } },
                    { "q", nil, { exit = true } },
                },
            }):activate()
        end, { noremap = true }, "Goto prev buffer")
    end,
}
