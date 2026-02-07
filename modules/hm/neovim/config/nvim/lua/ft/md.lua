local lib = require("lib")
local reg_ft, reg_ft_once, map = lib.reg_ft, lib.reg_ft_once, lib.map
local md = { noremap = true, silent = true, buffer = true }
local conf = require("conf")

reg_ft("markdown", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.wo.foldlevel = 2
    vim.wo.conceallevel = 2
    vim.opt_local.foldmethod = "marker"
    vim.opt_local.foldmarker = "{{{,}}}"

    map("n", "<leader>ce", "<cmd>EvalBlock<CR>", md, "Run Block")
    map("v", "<CR>", "'<,'>Obsidian link_new<CR>", md, "Create Link")
    map("n", "<leader>wb", "<Cmd>Obsidian backlinks<CR>", md, "Backlinks")
    map("n", "<leader>wl", "<Cmd>Obsidian links<CR>", md, "Links")
    map("n", "<leader>wt", "<Cmd>Obsidian open<CR>", md, "Links")
    map("n", "<leader>wr", "<Cmd>Obsidian rename<CR>", md, "Links")
    map("n", "<leader>wt", "<Cmd>Obsidian template<CR>", md, "Template")
    map("n", "g<space>", "<Cmd>Obsidian toggle_checkbox<CR>", md, "Links")
    map("n", "<CR>", "<Cmd>Obsidian follow_link<CR>", md, "Open Link")

    map("n", "<leader>cp", "<Cmd>MarkdownPreviewToggle<CR>", md, "Toggle Preview")
    map("n", "<leader>cS", "<Cmd>MarkdownPreviewStop<CR>", md, "Stop Preview")

    pcall(vim.treesitter.start)
end)

lib.reg_ft_once("markdown", function()
    require("nvim-treesitter").install({ "markdown" })
    if conf.packages.conform then
        require("conform").formatters_by_ft.markdown = { "prettier" }
    end
    if conf.packages.null then
        local null_ls = require("null-ls")
        null_ls.register({ null_ls.builtins.formatting.prettier })
    end
end)
