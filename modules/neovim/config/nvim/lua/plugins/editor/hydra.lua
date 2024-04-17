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
                        style = "rounded"
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
        local mapping = require("cokeline.mappings")
        if conf.nvim_tree then
            local buff_hint = [[
^^         Buffers           ^^     Tabs
^^---------------            ^^---------------
_j_, _k_: next/previous      ^^ _L_, _H_: next/previous
_d_: delete                  ^^ _D_: delete
_a_: new                     ^^ _A_: new
_o_: remain only             ^^ _O_: remain only
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
                            if conf.nvim_tree then
                                require("nvim-tree.api").tree.find_file({ open = true, focus = false })
                            end
                        end,
                        on_key = function()
                            if conf.nvim_tree then
                                require("nvim-tree.api").tree.find_file({ open = true, focus = false })
                            end
                        end,
                        on_exit = function()
                            if conf.nvim_tree then
                                require("lib").close_sidebar("NvimTree")
                            end
                        end,
                    },
                    mode = "n",
                    body = "<leader>b",
                    heads = {
                        {
                            "j",
                            function()
                                mapping.by_step("focus", 1)
                            end,
                        },
                        {
                            "k",
                            function()
                                mapping.by_step("focus", -1)
                            end,
                        },
                        {
                            "d",
                            function()
                                require("scope.core").delete_buf()
                            end,
                            { desc = "delete" },
                        },
                        {
                            "a",
                            function()
                                vim.cmd("enew")
                            end,
                            { desc = "new", exit = true },
                        },
                        {
                            "o",
                            function()
                                vim.cmd("BufOnly")
                            end,
                            { desc = "only", exit = true },
                        },
                        {
                            "L",
                            function()
                                vim.cmd("tabnext")
                            end,
                        },
                        {
                            "H",
                            function()
                                vim.cmd("tabprevious")
                            end,
                        },
                        {
                            "D",
                            function()
                                vim.cmd("tabclose")
                            end,
                            { desc = "delete" },
                        },
                        {
                            "A",
                            function()
                                vim.cmd("$tabnew")
                            end,
                            { desc = "new", exit = true },
                        },
                        {
                            "O",
                            function()
                                vim.cmd("tabonly")
                            end,
                            { desc = "only", exit = true },
                        },
                    },
                }):activate()
            end, opts, "Buffer/Tabs")
        else
            map("n", "<leader>ba", function()
                vim.cmd("enew")
            end, { noremap = true }, "New Buffer")
            map("n", "<leader>bd", function()
                require("scope.core").delete_buf()
            end, { noremap = true }, "Delete Buffer")
            map("n", "<leader>bo", function()
                vim.cmd("BufOnly")
            end, { noremap = true }, "Only one Buffer")
            map("n", "<leader>bA", function()
                vim.cmd("$tabnew")
            end, { noremap = true }, "New tab")
            map("n", "<leader>bD", function()
                vim.cmd("tabclose")
            end, { noremap = true }, "Delete tab")
            map("n", "<leader>bO", function()
                vim.cmd("tabonly")
            end, { noremap = true }, "Only one tab")
        end
    end,
    event = { "BufReadPre", "BufNewFile" },
}
