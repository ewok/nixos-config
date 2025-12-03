local lib = require("lib")
local map = lib.map
local conf = require("conf")

map("n", "<C-w>O", function()
    vim.cmd("BufOnly")
    vim.cmd("LspRestart")
end, { noremap = true }, "Wipe all buffers but one")

return {
    "junegunn/vim-easy-align",
    keys = {
        {
            "ga",
            "<Plug>(LiveEasyAlign)",
            mode = { "n", "x" },
            desc = "Align Block",
        },
    },
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({
                disable_filetype = { "TelescopePrompt", "clojure", "fennel", "markdown" },
                disable_in_macro = true,
                disable_in_visualblock = true,
                disable_in_replace_mode = true,
                enable_moveright = true,
                enable_check_bracket_line = false,
                check_ts = true,
                map_bs = true,
                map_c_h = true,
                map_c_w = true,
            })
            npairs.get_rule("'")[1].not_filetypes = conf.lisp_langs
        end,
    },
    {
        "ntpeters/vim-better-whitespace",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.g.better_whitespace_filetypes_blacklist = conf.ui_ft
            vim.g.better_whitespace_operator = "<localleader>S"
            map("n", "<leader>cw", ":StripWhitespace<CR>", {}, "Strip Whitespaces")
        end,
    },
    {
        "brenoprata10/nvim-highlight-colors",
        cmd = { "HighlightColors" },
        init = function()
            map("n", "<leader>tc", "<cmd>HighlightColors On<CR>", { silent = true }, "Code Colorizer")
        end,
        config = function()
            require("nvim-highlight-colors").setup({
                render = "background",
                virtual_symbol = "■",
                enable_named_colors = true,
            })
        end,
    },
    {
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local guess_indent = require("guess-indent")
            guess_indent.setup({
                auto_cmd = true,
                override_editorconfig = false,
                filetype_exclude = require("conf").ui_ft,
                buftype_exclude = { "help", "nofile", "terminal", "prompt" },
            })
        end,
    },
    {
        "nvimdev/indentmini.nvim",
        event = "BufEnter",
        config = function()
            local indentmini = require("indentmini")
            indentmini.setup({
                char = "│",
                exclude = { "clojure", "fennel" },
            })
            vim.cmd([[highlight default link IndentLine Comment]])
        end,
    },
    { "kylechui/nvim-surround", version = "*", event = { "BufReadPre", "BufNewFile" }, config = true },
    { "chaoren/vim-wordmotion", config = false, event = { "BufReadPre", "BufNewFile" } },
    {
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete", "Bwipeout" },
        init = function()
            map("n", "<C-W>d", "<CMD>Bdelete<CR>", { silent = true }, "Close current buffer")
            map("n", "<C-W><C-D>", "<CMD>Bdelete<CR>", { silent = true }, "Close current buffer")
        end,
    },
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        keys = {
            { "<c-n>", mode = { "n", "x" } },
            { "<c-q>", mode = { "n", "x" } },
            { "<up>", mode = { "n", "x" } },
            { "<down>", mode = { "n", "x" } },
        },
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()
            mc.addKeymapLayer(function(layerSet)
                layerSet({ "n", "x" }, "<c-k>", mc.prevCursor)
                layerSet({ "n", "x" }, "<c-j>", mc.nextCursor)
                layerSet({ "n", "x" }, "<c-p>", function()
                    mc.matchAddCursor(-1)
                end)
                layerSet({ "n", "x" }, "<c-s>", function()
                    mc.matchSkipCursor(1)
                end)
                layerSet({ "n", "x" }, "*", mc.matchAllAddCursors)
                layerSet({ "n", "x" }, "<c-x>", mc.deleteCursor)
                layerSet({ "n", "x" }, "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)
            map({ "n", "x" }, "<up>", function()
                mc.lineAddCursor(-1)
            end, {}, "None")
            map({ "n", "x" }, "<down>", function()
                mc.lineAddCursor(1)
            end, {}, "None")
            map({ "n", "x" }, "<c-n>", function()
                mc.matchAddCursor(1)
            end, {}, "None")
            map({ "n", "x" }, "<c-q>", function()
                mc.toggleCursor()
            end, {}, "None")
        end,
    },
}
