local conf = require("conf")

return {
    {
        "ravibrock/spellwarn.nvim",
        config = function()
            local sw = require("spellwarn")
            sw.setup({})
        end,
        keys = {
            {
                "<leader>S",
                function()
                    local sw = require("spellwarn")
                    if vim.wo.spell then
                        sw.disable()
                        vim.wo.spell = false
                        vim.notify("Spellchecking is off", vim.log.levels.INFO, { title = "Spell" })
                    else
                        vim.bo.spellfile = conf.notes_dir
                            .. "/dict-en.utf-8.add,"
                            .. conf.notes_dir
                            .. "/dict-ru.utf-8.add"
                        vim.bo.spelllang = "en_us,ru_ru"
                        vim.o.spell = true
                        sw.enable()
                        vim.notify("Spellchecking is on", vim.log.levels.INFO, { title = "Spell" })
                    end
                end,
                mode = "n",
                desc = "Toggle spelling",
            },
        },
    },
}
