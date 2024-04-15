return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            { "shumphrey/fugitive-gitlab.vim", config = false },
        },
        event = { "BufNewFile", "BufReadPre" },
        keys = { "<leader>gs" },
        config = function()
            local map = require("lib").map
            local md = { noremap = true, silent = true }

            map("n", "<leader>gb", "<cmd>Git blame<CR>", md, "Git Blame")
            map("n", "<leader>ge", "<cmd>Gedit<CR>", md, "Git Edit")
            map("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", md, "Git Diff")
            map("n", "<leader>gx", "<cmd>.GBrowse %<CR>", md, "Git Browse")
            map("n", "<leader>gl", function()
                vim.cmd('exe ":G log -U1 -L " . string(getpos(\'.\')[1]) . ",+1:%"')
            end, md, "Line")
            map("n", "<leader>glt", "<cmd>Flog<cr>", md, "Commits in Tab")
            map("n", "<leader>gll", "<cmd>Flogsplit<cr>", md, "History")
            map("n", "<leader>glf", "<cmd>Flogsplit -path=%<cr>", md, "File History")
            map("n", "<leader>gfm", "<cmd>Git pull<CR>", md, "Git Merge")
            map("n", "<leader>gfr", "<cmd>Git pull --rebase<CR>", md, "Git Rebase")
            map("n", "<leader>gps", "<cmd>Git push<CR>", md, "Git Push")
            map("n", "<leader>gpf", "<cmd>Git push --force-with-lease<CR>", md, "Push(force with lease)")
            map("n", "<leader>gpF", "<cmd>Git push --force<CR>", md, "Push(force)")
            map("n", "<leader>gR", "<cmd>Gread<CR>", md, "Git Reset")
            map("n", "<leader>gs", "<cmd>Git<CR>", md, "Git Status")
            map("n", "<leader>gW", "<cmd>Gwrite<CR>", md, "Git Write")
            map("x", "<leader>gx", ":'<,'>GBrowse %<CR>", md, "Git Browse")
            map("x", "<leader>glv", function()
                -- TODO: Fix it
                -- vim.cmd('exe ":G log -L " . string(getpos("\'<")[1]) . "," . string(getpos("\'>\'")[1]) . ":%"')
                vim.cmd('exe ":G log -L " . string(getpos("\'<\'")[1]) . "," . string(getpos("\'>\'")[1]) . ":%"')
            end, md, "Visual Block")
        end,
    },
    { "rbong/vim-flog",    config = false, cmd = { "Flog", "Flogsplit" } },
    { "tpope/vim-rhubarb", config = false, cmd = { "GBrowse" } },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local gitsigns = require("gitsigns")
            local conf = require("conf")
            gitsigns.setup({
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                on_attach = function(bufnr)
                    local map = require("lib").map
                    map(
                        "n",
                        "<leader>gtl",
                        "<cmd>Gitsigns toggle_current_line_blame<cr>",
                        { silent = true, buffer = bufnr },
                        "Toggle current line blame"
                    )
                    map(
                        "n",
                        "<leader>ghp",
                        "<cmd>lua require'gitsigns'.preview_hunk()<cr>",
                        { silent = true, buffer = bufnr },
                        "Preview current hunk"
                    )
                    map(
                        "n",
                        "<leader>ghP",
                        "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>",
                        { silent = true, buffer = bufnr },
                        "Show current block blame"
                    )
                    map(
                        "n",
                        "<leader>ghd",
                        "<cmd>Gitsigns diffthis<cr>",
                        { silent = true, buffer = bufnr },
                        "Open diff view"
                    )
                    map(
                        "n",
                        "<leader>gtD",
                        "<cmd>Gitsigns toggle_deleted<cr>",
                        { silent = true, buffer = bufnr },
                        "Show deleted lines"
                    )
                    map(
                        "n",
                        "<leader>ghr",
                        "<cmd>Gitsigns reset_hunk<cr>",
                        { silent = true, buffer = bufnr },
                        "Reset current hunk"
                    )
                    map(
                        "v",
                        "<leader>ghr",
                        "<cmd>Gitsigns reset_hunk<cr>",
                        { silent = true, buffer = bufnr },
                        "Reset selected hunk"
                    )
                    map(
                        "n",
                        "<leader>ghR",
                        "<cmd>Gitsigns reset_buffer<cr>",
                        { silent = true, buffer = bufnr },
                        "Reset current buffer"
                    )
                    map(
                        "n",
                        "[g",
                        vim.wo.diff and "[c" or "<cmd>lua vim.schedule(require'gitsigns'.prev_hunk())<cr>",
                        { silent = true, buffer = bufnr },
                        "Jump to the prev hunk"
                    )
                    map(
                        "n",
                        "]g",
                        vim.wo.diff and "]c" or "<cmd>lua vim.schedule(require'gitsigns'.next_hunk())<cr>",
                        { silent = true, buffer = bufnr },
                        "Jump to the next hunk"
                    )
                end,
                signs = {
                    add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
                    change = {
                        hl = "GitSignsChange",
                        text = "~",
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn",
                    },
                    delete = {
                        hl = "GitSignsDelete",
                        text = "-",
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn",
                    },
                    topdelete = {
                        hl = "GitSignsDelete",
                        text = "‾",
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn",
                    },
                    changedelete = {
                        hl = "GitSignsChange",
                        text = "_",
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn",
                    },
                },
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol",
                    delay = 100,
                    ignore_whitespace = false,
                },
                preview_config = {
                    border = conf.options.float_border and "rounded" or "none",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })
        end,
    },
}
