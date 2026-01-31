local map = require("lib").map
local conf = require("conf")

return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
    },
    {
        "gpanders/vim-medieval",
        ft = { "markdown" },
        config = function()
            vim.g.medieval_langs = {
                "python",
                "ruby",
                "sh",
                "console=bash",
                "bash",
                "perl",
                "fish",
                "nu",
                "bb",
                "go",
            }
        end,
    },
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        dependencies = {
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    preset = "obsidian",
                    latex = { enabled = false },
                    code = {
                        enabled = true,
                        conceal_delimiters = false,
                        border = "thin",
                        render_modes = true,
                    },
                    completions = {
                        lsp = { enabled = true },
                        blink = { enabled = true },
                    },
                    checkbox = {
                        unchecked = { icon = "" },
                        checked = { icon = "󰄳" },
                        custom = {
                            ["/"] = {
                                raw = "[/]",
                                rendered = "󱎖",
                                highlight = "RenderMarkdownHint",
                                scope_highlight = nil,
                            },
                            ["-"] = {
                                raw = "[-]",
                                rendered = " ",
                                highlight = "RenderMarkdownSuccess",
                                scope_highlight = nil,
                            },
                            [">"] = {
                                raw = "[>]",
                                rendered = "",
                                highlight = "RenderMarkdownInfo",
                                scope_highlight = nil,
                            },
                            ["<"] = {
                                raw = "[<]",
                                rendered = "",
                                highlight = "RenderMarkdownInfo",
                                scope_highlight = nil,
                            },
                            ["?"] = {
                                raw = "[?]",
                                rendered = "",
                                highlight = "RenderMarkdownWarn",
                                scope_highlight = nil,
                            },
                            ["!"] = {
                                raw = "[!]",
                                rendered = "",
                                highlight = "RenderMarkdownWarn",
                                scope_highlight = nil,
                            },
                            ["*"] = {
                                raw = "[*]",
                                rendered = "",
                                highlight = "RenderMarkdownSuccess",
                                scope_highlight = nil,
                            },
                            l = {
                                raw = "[l]",
                                rendered = "",
                                highlight = "RenderMarkdownInfo",
                                scope_highlight = nil,
                            },
                            b = {
                                raw = "[b]",
                                rendered = "",
                                highlight = "RenderMarkdownInfo",
                                scope_highlight = nil,
                            },
                            i = {
                                raw = "[i]",
                                rendered = "󱩎",
                                highlight = "RenderMarkdownHint",
                                scope_highlight = nil,
                            },
                            S = {
                                raw = "[S]",
                                rendered = "",
                                highlight = "RenderMarkdownInfo",
                                scope_highlight = nil,
                            },
                            p = {
                                raw = "[p]",
                                rendered = "󰔓",
                                highlight = "RenderMarkdownSuccess",
                                scope_highlight = nil,
                            },
                            c = {
                                raw = "[c]",
                                rendered = "󰔑",
                                highlight = "RenderMarkdownError",
                                scope_highlight = nil,
                            },
                            f = {
                                raw = "[f]",
                                rendered = "",
                                highlight = "RenderMarkdownError",
                                scope_highlight = nil,
                            },
                            k = {
                                raw = "[k]",
                                rendered = "",
                                highlight = "RenderMarkdownInfo",
                                scope_highlight = nil,
                            },
                            w = {
                                raw = "[w]",
                                rendered = "",
                                highlight = "RenderMarkdownInfo",
                                scope_highlight = nil,
                            },
                            u = {
                                raw = "[u]",
                                rendered = "󰔵",
                                highlight = "RenderMarkdownSuccess",
                                scope_highlight = nil,
                            },
                            d = {
                                raw = "[d]",
                                rendered = "󰔳",
                                highlight = "RenderMarkdownError",
                                scope_highlight = nil,
                            },
                            q = {
                                raw = "[q]",
                                rendered = "",
                                highlight = "RenderMarkdownQuote",
                                scope_highlight = nil,
                            },
                        },
                    },
                },
            },
        },
        init = function()
            local md = { noremap = true, silent = false }
            map("n", "<leader>wo", "<cmd>Obsidian quick_switch<cr>", md, "Open note")
            map("n", "<leader>wt", "<cmd>Obsidian tags<cr>", md, "Open tag")
            map("n", "<leader>wf", "<cmd>Obsidian search<cr>", md, "Find in notes")
        end,
        cmd = { "Obsidian" },
        ft = "markdown",
        event = {
            "BufReadPre " .. conf.notes_dir .. "/**.md",
            "BufNewFile " .. conf.notes_dir .. "/**.md",
        },
        opts = {
            frontmatter = {
                enabled = false,
            },
            ui = {
                enable = false,
            },
            legacy_commands = false,
            workspaces = {
                {
                    name = "notes",
                    path = "~/Notes",
                },
            },
            daily_notes = {
                folder = "daily",
                date_format = "%Y-%m-%d",
                alias_format = "%B %-d, %Y",
                template = "hidden/templates/__daily",
            },
            wiki_link_func = "use_alias_only",
            note_id_func = function(text)
                return text
            end,
            completion = {
                nvim_cmp = true,
                blink = true,
                min_chars = 1,
            },
            templates = { folder = "hidden/templates" },
            checkbox = {
                order = {
                    " ",
                    "x",
                    "/",
                    "-",
                    ">",
                    "<",
                    "?",
                    "!",
                    "*",
                    "q",
                    "l",
                    "b",
                    "i",
                    "S",
                    "i",
                    "p",
                    "c",
                    "f",
                    "k",
                    "w",
                    "u",
                    "d",
                },
            },
        },
    },
}
