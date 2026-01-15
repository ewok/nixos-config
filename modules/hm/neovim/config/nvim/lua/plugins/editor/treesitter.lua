local conf = require("conf")

return {
    { "hiphish/rainbow-delimiters.nvim", event = { "BufReadPost", "BufNewFile" } },
    {
        "nvim-treesitter/nvim-treesitter",
        cmd = "TSUpdate",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            init = function()
                -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
                vim.g.no_plugin_maps = true
            end,
            config = function()
                require("nvim-treesitter-textobjects").setup({
                    select = {
                        lookahead = true,
                        selection_modes = {
                            ["@parameter.outer"] = "v", -- charwise
                            ["@function.outer"] = "V", -- linewise
                            -- ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = false,
                    },
                })

                vim.keymap.set({ "x", "o" }, "am", function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
                end, { desc = "[ts] Select around function" })
                vim.keymap.set({ "x", "o" }, "im", function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
                end, { desc = "[ts] Select inner function" })
                vim.keymap.set({ "x", "o" }, "ac", function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
                end, { desc = "[ts] Select around class" })
                vim.keymap.set({ "x", "o" }, "ic", function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
                end, { desc = "[ts] Select inner class" })
                -- You can also use captures from other query groups like `locals.scm`
                vim.keymap.set({ "x", "o" }, "as", function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
                end, { desc = "[ts] Select around local scope" })

                vim.keymap.set("n", "gm>", function()
                    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
                end, { desc = "[ts] Swap next parameter" })
                vim.keymap.set("n", "gm<", function()
                    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
                end, { desc = "[ts] Swap previous parameter" })
            end,
        },
        lazy = false,
        branch = "main",
        config = function()
            require("nvim-treesitter").setup({
                -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
                install_dir = vim.fn.stdpath("data") .. "/site",
            })
            require("nvim-treesitter").install({ "markdown_inline", "markdown", "c", "lua", "vim", "vimdoc", "html" })
        end,
    },
}
