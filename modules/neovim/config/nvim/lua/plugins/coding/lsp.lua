return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "neovim/nvim-lspconfig" },
        { "folke/neodev.nvim",                opts = {} },
        { "williamboman/mason-lspconfig.nvim" },
    },
    init = function()
        local map = require("lib").map

        map("n", "<leader>li", "<cmd>LspInfo<CR>", { noremap = true }, "Info")
        map("n", "<leader>ls", "<cmd>LspStart<CR>", { noremap = true }, "Start")
        map("n", "<leader>lS", "<cmd>LspStop<CR>", { noremap = true }, "Stop")
        map("n", "<leader>lr", "<cmd>LspRestart<CR>", { noremap = true }, "Restart")
        map("n", "<leader>ll", "<cmd>LspLog<CR>", { noremap = true }, "Log")
    end,
    config = function()
        local map = require("lib").map
        local conf = require "conf"
        local icons = conf.icons.diagnostic
        local lsp_zero = require("lsp-zero")

        lsp_zero.on_attach(function(client, bufnr)
            -- Default does not work, not sure why
            map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { buffer = bufnr }, "[lsp] Hover documentation")
            map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { buffer = bufnr }, "[lsp] Go to definition")
            map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { buffer = bufnr }, "[lsp] Go to declaration")
            map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { buffer = bufnr }, "[lsp] Go to implementation")
            map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { buffer = bufnr },
                "[lsp] Go to type definition")
            map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { buffer = bufnr }, "[lsp] Go to reference")
            map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = bufnr },
                "[lsp] Show function signature")
            map("n", "<leader>cn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr }, "[lsp] Rename symbol")
            map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", { buffer = bufnr },
                "[lsp] Format file")
            map(
                "x",
                "<leader>cf",
                "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
                { buffer = bufnr },
                "[lsp] Format selection"
            )
            map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = bufnr },
                "[lsp] Execute code action")

            if vim.lsp.buf.range_code_action then
                map(
                    "x",
                    "<leader>ca",
                    "<cmd>lua vim.lsp.buf.range_code_action()<cr>",
                    { buffer = bufnr },
                    "[lsp] Execute code action"
                )
            else
                map(
                    "x",
                    "<leader>ca",
                    "<cmd>lua vim.lsp.buf.code_action()<cr>",
                    { buffer = bufnr },
                    "[lsp] Execute code action"
                )
            end

            map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", { buffer = bufnr }, "[lsp] Show diagnostic")
            map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { buffer = bufnr }, "[lsp] Previous diagnostic")
            map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { buffer = bufnr }, "[lsp] Next diagnostic")
        end)

        lsp_zero.set_sign_icons(
            {
                error = icons.Error,
                warn = icons.Warn,
                hint = icons.Hint,
                info = icons.Info
            }
        )
        require('lspconfig').nil_ls.setup({})

        require("mason-lspconfig").setup({
            handlers = {
                lsp_zero.default_setup,
            },
        })
    end,
}
