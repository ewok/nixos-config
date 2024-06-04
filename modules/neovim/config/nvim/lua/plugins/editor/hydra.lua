return {
    "nvimtools/hydra.nvim",
    keys = {
        {
            "<leader>j",
            function()
                local lualine = require("lualine")
                local hydra = require("hydra")
                hydra({
                    name = "Switch buffers",

                    config = {
                        hint = false,
                        on_enter = function()
                            vim.cmd("silent! bnext")
                            lualine.refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                        end,
                        on_key = function()
                            lualine.refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                        end,
                        timeout = 300,
                    },
                    heads = {
                        { "k", "<cmd>silent! bprevious<CR>", { desc = "prev" } },
                        { "j", "<cmd>silent! bnext<CR>", { desc = "next" } },
                        { "q", nil, { exit = true } },
                    },
                }):activate()
            end,
            mode = { "n" },
            desc = "Goto next buffer",
        },

        {
            "<leader>k",
            function()
                local lualine = require("lualine")
                local hydra = require("hydra")
                hydra({
                    name = "Switch buffers",

                    config = {
                        hint = false,
                        on_enter = function()
                            vim.cmd("silent! bprevious")
                            lualine.refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                        end,
                        on_key = function()
                            lualine.refresh({ scope = "tabpage", place = { "tabline", "statusline", "winbar" } })
                        end,
                        timeout = 300,
                    },
                    heads = {
                        { "k", "<Cmd>silent! bprevious<CR>", { desc = "prev" } },
                        { "j", "<Cmd>silent! bnext<CR>", { desc = "next" } },
                        { "q", nil, { exit = true } },
                    },
                }):activate()
            end,
            { noremap = true },
            "Goto prev buffer",
        },
        {
            "<leader>tS",
            function()
                local conf = require("conf")
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
                    body = "<leader>tS",
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
                }):activate()
            end,
            { noremap = true },
            "Toggle spell check",
        },
    },
}
