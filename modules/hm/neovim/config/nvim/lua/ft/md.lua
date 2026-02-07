local lib = require("lib")
local reg_ft, reg_ft_once, map = lib.reg_ft, lib.reg_ft_once, lib.map
local md = { noremap = true, silent = true, buffer = true }
local conf = require("conf")

if not _G.markdown_heading_foldexpr then
    _G.markdown_heading_foldexpr = function(lnum)
        local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
        local hashes = line:match("^#+")
        if hashes then
            return ">" .. #hashes
        end
        return "="
    end
end

if not _G.markdown_foldtext then
    _G.markdown_foldtext = function()
        local fs = vim.v.foldstart
        local fe = vim.v.foldend

        -- First line of the fold (your heading)
        local line = vim.api.nvim_buf_get_lines(0, fs - 1, fs, false)[1] or ""
        local hashes, title = line:match("^(#+)%s*(.*)")
        local level = #hashes
        local text = title ~= "" and title or line
        local lines = fe - fs + 1

        -- Choose icon by heading level (Nerd Font)
        local icon = "" -- top-level
        if hashes then
            if level == 1 then
                icon = "󰲡 "
            elseif level == 2 then
                icon = " 󰲣 "
            elseif level == 3 then
                icon = "  󰲥 "
            elseif level == 4 then
                icon = "   󰲧 "
            elseif level == 5 then
                icon = "    󰲩 "
            else
                icon = "     󰲫 "
            end
        end

        return {
            {
                string.format("%s%s  (%d lines)", icon, text, lines),
                "RenderMarkdownH" .. level,
            },
        }
    end
end
reg_ft("markdown", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.wo.foldlevel = 2
    vim.wo.conceallevel = 2
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.markdown_heading_foldexpr(v:lnum)"
    vim.opt_local.foldtext = "v:lua.markdown_foldtext()"

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
