local lib = require("lib")
local conf = require("conf")
local map = lib.map

return {
    {
        "folke/flash.nvim",
        event = { "BufReadPost", "BufNewFile", "BufNew" },
        config = function()
            local flash = require("flash")
            map({ "n", "o", "x" }, "s", flash.jump, { silent = true }, "Flash")
            map("o", "r", flash.remote, { silent = true }, "FlashRemote")
            map({ "o", "x" }, "R", flash.treesitter_search, { silent = true }, "FlashTreesitterSearch")
            map("c", "<c-s>", flash.toggle, { silent = true }, "FlashToggle")
            flash.setup({
                modes = {
                    search = { enabled = false },
                },
            })
        end,
    },
    {
        "MagicDuck/grug-far.nvim",
        config = function()
            local grug = require("grug-far")
            grug.setup({
                keymaps = {
                    replace = { n = "X" },
                    qflist = { n = "<c-q>" },
                    syncLocations = { n = "<c-r>" },
                    syncLine = { n = "r" },
                    close = { n = "q" },
                    historyOpen = { n = "<localleader>t" },
                    historyAdd = { n = "<localleader>a" },
                    refresh = { n = "R" },
                    gotoLocation = { n = "<enter>" },
                    pickHistoryEntry = { n = "<enter>" },
                    abort = { n = "<c-c>", i = "<c-c>" },
                },
            })
        end,
        cmd = { "GrugFar" },
        keys = {
            {
                "<leader>fr",
                "<cmd>GrugFar<cr>",
                mode = "n",
                desc = "Find and Replace [global]",
            },
        },
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
        "stevearc/aerial.nvim",
        cmd = { "AerialToggle" },
        enabled = conf.packages.aerial,
        init = function()
            map("n", "<C-P>", "<cmd>AerialToggle float<cr>", { silent = true }, "Open Outline Explorer")
        end,
        config = function()
            require("aerial").setup({
                icons = conf.icons,
                keymaps = { q = "actions.close", ["<esc>"] = "actions.close" },
                layout = { min_width = 120 },
                show_guides = true,
                backends = { "lsp", "treesitter", "markdown", "man" },
                update_events = "TextChanged,InsertLeave",
                -- on_attach = on_attach,
                lsp = { diagnostics_trigger_update = false, update_when_errors = true, update_delay = 300 },
                guides = {
                    mid_item = "├─",
                    last_item = "└─",
                    nested_top = "│ ",
                    whitespace = "  ",
                },
                filter_kind = {
                    "Module",
                    "Struct",
                    "Interface",
                    "Class",
                    "Constructor",
                    "Enum",
                    "Function",
                    "Method",
                },
            })
        end,
    },
    {
        "jiaoshijie/undotree",
        init = function()
            map("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { silent = true }, "Toggle Undo Tree")
        end,
    },
    {
        "folke/zen-mode.nvim",
        cmd = { "ZenMode" },
        opts = {
            window = {
                backdrop = 0.95,
                width = 0.7,
                height = 0.98,
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                    cursorcolumn = false,
                    foldcolumn = "0",
                    list = false,
                },
            },
            plugins = {
                gitsigns = { enabled = false },
                tmux = { enabled = true },
            },
            on_open = function()
                vim.o.winbar = ""
                vim.o.laststatus = 0
                vim.o.cmdheight = 0
            end,
            on_close = function()
                vim.o.laststatus = 3
                vim.o.cmdheight = 1
            end,
        },
        init = function()
            map("n", "<leader>z", "<cmd>ZenMode<cr>", { silent = true, nowait = true }, "Toggle Zoom")
        end,
    },
    {
        "ravibrock/spellwarn.nvim",
        config = function()
            local sw = require("spellwarn")
            sw.setup({})
        end,
        keys = {
            {
                "<leader>ts",
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
