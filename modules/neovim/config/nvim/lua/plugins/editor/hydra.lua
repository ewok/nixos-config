return {
    "nvimtools/hydra.nvim",
    config = function()
        local conf = require("conf")
        local map = require("lib").map
        local hydra = require("hydra")

        hydra({
            name = "Spell",
            hint = [[
Spell Langs
  ^
  ^^^^^_1_ %{spell} spell
  ^^^^^_2_ %{en_us} en
  ^^^^^_3_ %{ru_ru} ru
  ^^^^^_q_ quit
]],
            config = {
                invoke_on_body = true,
                hint = {
                    float_opts = {
                        style = "minimal",
                    },
                    position = "middle",
                    funcs = {
                        spell = function()
                            return vim.wo.spell and "[x]" or "[ ]"
                        end,
                        en_us = function()
                            return vim.bo.spelllang == "en_us" and "[x]" or "[ ]"
                        end,
                        ru_ru = function()
                            return vim.bo.spelllang == "ru_ru" and "[x]" or "[ ]"
                        end,
                    },
                },
            },
            mode = "n",
            body = "<leader>S",
            heads = {
                {
                    "1",
                    function()
                        vim.wo.spell = not vim.wo.spell
                    end,
                    { desc = "toggle" },
                },
                {
                    "2",
                    function()
                        vim.wo.spell = true
                        vim.bo.spelllang = "en_us"
                        vim.bo.spellfile = conf.notes_dir .. "/dict-en.utf-8.add"
                    end,
                    {},
                },
                {
                    "3",
                    function()
                        vim.wo.spell = true
                        vim.bo.spelllang = "ru_ru"
                        vim.bo.spellfile = conf.notes_dir .. "/dict-ru.utf-8.add"
                    end,
                    {},
                },
                { "q", nil, { exit = true } },
            },
        })

        local opts = { noremap = true, silent = true }
        local buff_hint = [[
^^         Buffers
^^---------------
_j_, _k_: next/previous
_d_: delete
_a_: new
_p_: pin buffer
_o_: remain only current
any : quit
]]
        map("n", "<leader>b", function()
            hydra({
                name = "Buffers/Tabs",
                hint = buff_hint,
                config = {
                    hint = {
                        float_opts = {
                            style = "minimal",
                        },
                    },
                    on_enter = function()
                        --     if conf.nvim_tree then
                        --         require("nvim-tree.api").tree.find_file({ open = true, focus = false })
                        --     end
                        require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                    end,
                    on_key = function()
                        -- if conf.nvim_tree then
                        --     require("nvim-tree.api").tree.find_file({ open = true, focus = false })
                        -- end
                        require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                    end,
                    -- on_exit = function()
                    --     -- if conf.nvim_tree then
                    --     --     require("lib").close_sidebar("NvimTree")
                    --     -- end
                    --     require("lualine").refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                    -- end,
                },
                mode = "n",
                body = "<leader>b",
                heads = {
                    {
                        "j",
                        function()
                            vim.cmd("silent! bnext")
                            -- mapping.by_step("focus", 1)
                        end,
                        { desc = "Next Buffer" },
                    },
                    {
                        "k",
                        function()
                            vim.cmd("silent! bprevious")
                            -- mapping.by_step("focus", -1)
                        end,
                        { desc = "Prev Buffer" },
                    },
                    {
                        "d",
                        function()
                            vim.cmd("Bdelete")
                        end,
                        { desc = "Delete Buffer" },
                    },
                    {
                        "a",
                        function()
                            vim.cmd("enew")
                        end,
                        { desc = "New Buffer", exit = true },
                    },
                    {
                        "p",
                        function()
                            local cur_buf = vim.api.nvim_get_current_buf()
                            local isSet, setTrue = pcall(vim.api.nvim_buf_get_var, cur_buf, "ignore_early_retirement")
                            vim.api.nvim_buf_set_var(cur_buf, "ignore_early_retirement", not (isSet and setTrue))
                        end,
                        { desc = "Pin buffer" },
                    },
                    {
                        "o",
                        function()
                            vim.cmd("BufOnly")
                        end,
                        { desc = "Only one Buffer", exit = true },
                    },
                },
            }):activate()
        end, opts, "Buffer/Tabs")
        map("n", "<leader>ba", function()
            vim.cmd("enew")
        end, { noremap = true }, "New Buffer")
        map("n", "<leader>bd", function()
            vim.cmd("Bdelete")
        end, { noremap = true }, "Delete Buffer")
        map("n", "<leader>bo", function()
            vim.cmd("BufOnly")
        end, { noremap = true }, "Only one Buffer")
    end,
    event = { "BufReadPre", "BufNewFile" },
}
