return {
    "nvimtools/hydra.nvim",
    config = function()
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
            body = "<leader>7",
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
    end,
    event = { "BufReadPre", "BufNewFile" },
}
