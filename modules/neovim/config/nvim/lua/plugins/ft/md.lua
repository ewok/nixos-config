return {
    {
        "mickael-menu/zk-nvim",
        cmd = {
            "ZkNew",
            "ZkIndex",
            "ZkNotes",
            "ZkTags",
            "ZkMatch",
        },
        init = function()
            local map = require("lib").map
            local md = { noremap = true, silent = false }

            map("n", "<leader>wn", "<cmd>ZkNew { title = vim.fn.input('Title: '), dir = 'notes' }<cr>", md, "New note")
            map("n", "<leader>wi", "<cmd>ZkIndex<cr>", md, "Reindex notes")
            map(
                "n",
                "<leader>wo",
                "<cmd>ZkNotes { sort = { 'modified' }, select = { 'absPath', 'path' } }<cr>",
                md,
                "Open note"
            )
            map("n", "<leader>wt", "<cmd>ZkTags<cr>", md, "Open tag")
            map(
                "n",
                "<leader>wf",
                "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') }, select = { 'absPath', 'path' } }<cr>",
                md,
                "Find in notes"
            )
            map("v", "<leader>wf", ":'<,'>ZkMatch<cr>", md, "Find in notes")
        end,
        config = function()
            local zk = require("zk")
            local telescope = require("telescope")
            zk.setup({ picker = "telescope" })
            telescope.load_extension("zk")
        end,
    },

    {
        "gpanders/vim-medieval",
        ft = { "markdown" },
        config = function()
            vim.g.medieval_langs = { "python", "ruby", "sh", "console=bash", "bash", "perl", "fish", "bb" }
        end,
    },
    {

        "jakewvincent/mkdnflow.nvim",
        ft = { "markdown" },
        opts = {
            modules = {
                bib = false,
                buffers = true,
                conceal = false,
                cursor = true,
                folds = false,
                links = true,
                lists = true,
                maps = true,
                paths = true,
                tables = true,
                yaml = false,
            },
            filetypes = {
                md = true,
                rmd = true,
                markdown = true,
            },
            create_dirs = true,
            perspective = {
                priority = "first",
                fallback = "current",
                root_tell = false,
                nvim_wd_heel = true,
            },
            wrap = false,
            silent = false,
            links = {
                style = "markdown",
                name_is_source = false,
                conceal = true,
                context = 1,
                implicit_extension = nil,
                transform_implicit = false,
                transform_explicit = function(text)
                    local str = require("str")
                    local time = require("time")
                    return str.join(str.lower_case(str.replace(text, " ", "-")), str(time.now()) .. "_")
                end,
            },
            to_do = {
                symbols = { " ", "+", "x", "-" },
                update_parents = true,
                not_started = " ",
                in_progress = "+",
                complete = "x",
            },
            tables = {
                trim_whitespace = true,
                format_on_move = true,
                auto_extend_rows = false,
                auto_extend_cols = false,
            },
            mappings = {
                MkdnEnter = { { "n", "v" }, "<M-CR>" },
                MkdnTab = false,
                MkdnSTab = false,
                MkdnNextLink = { { "n" }, "]l" },
                MkdnPrevLink = { { "n" }, "[l" },
                MkdnNextHeading = { { "n" }, "]]" },
                MkdnPrevHeading = { { "n" }, "[[" },
                MkdnGoBack = { { "n" }, "<BS>" },
                MkdnGoForward = { { "n" }, "<Del>" },
                MkdnFollowLink = false,
                MkdnMoveSource = { { "n" }, "<leader>wr" },
                MkdnYankAnchorLink = { { "n" }, "ya" },
                MkdnYankFileAnchorLink = { { "n" }, "yfa" },
                MkdnIncreaseHeading = { { "n" }, "+" },
                MkdnDecreaseHeading = { { "n" }, "-" },
                MkdnToggleToDo = { { "n" }, "<C-Space>", ["v"] = "<C-Space>" },
                MkdnNewListItem = { { "i" }, "<CR>" },
                MkdnNewListItemBelowInsert = { { "n" }, "o" },
                MkdnNewListItemAboveInsert = { { "n" }, "O" },
                MkdnExtendList = false,
                MkdnUpdateNumbering = { { "n" }, "<leader>wN" },
                MkdnTableFormat = { { "n" }, "tf" },
                MkdnTableNewColAfter = { { "n" }, "ta" },
                MkdnTableNewColBefore = { { "n" }, "ti" },
                MkdnTableNewRowAbove = { { "n" }, "tO" },
                MkdnTableNewRowBelow = { { "n" }, "to" },
                MkdnTableNextCell = { { "i" }, "<Tab>" },
                MkdnTableNextRow = { { "i" }, "<C-Down>" },
                MkdnTablePrevCell = { { "i" }, "<S-Tab>" },
                MkdnTablePrevRow = { { "i" }, "<C-Up>" },
                MkdnFoldSection = { { "n" }, "zf" },
                MkdnUnfoldSection = { { "n" }, "zF" },
            },
        },
    },
}
