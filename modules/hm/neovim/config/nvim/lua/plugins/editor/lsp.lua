local lib = require("lib")
local map = lib.map
local lsps = lib.lsps
local umap = lib.umap
local conf = require("conf")

return {
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
        "kosayoda/nvim-lightbulb",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local bulb = require("nvim-lightbulb")
            bulb.setup({
                ignore = {},
                sign = { enabled = true, priority = 15 },
                float = { enabled = false, text = "💡", win_opts = {} },
                virtual_text = { enabled = false, text = "💡", hl_mode = "replace" },
                status_text = { enabled = false, text = "💡", text_unavailable = "" },
            })
            -- vim.fn.sign_define(
            --     "LightBulbSign",
            --     { text = "💡", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
            -- )
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                pattern = "*",
                callback = function()
                    bulb.update_lightbulb()
                end,
            })
        end,
    },
    {
        "SmiteshP/nvim-navic",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local navic = require("nvim-navic")
            navic.setup({ highlight = true })
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP navic",
                callback = function(event)
                    local client_id = vim.tbl_get(event, "data", "client_id")
                    local client = client_id and vim.lsp.get_client_by_id(client_id)
                    if client and client.server_capabilities.documentSymbolProvider then
                        navic.attach(client, event.buf)
                    end
                end,
            })
        end,
    },
    {
        -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
        "nvimtools/none-ls.nvim",
        config = function()
            local nl = require("null-ls")
            nl.setup()
        end,
        keys = {
            {
                "<leader>cf",
                function()
                    local gen = require("null-ls.generators")
                    local meth = require("null-ls.methods")
                    local bufnr = vim.api.nvim_get_current_buf()

                    local function formatting_enabled(buf)
                        local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
                        local generators = gen.get_available(ft, meth.internal.FORMATTING)
                        return #generators > 0
                    end

                    vim.lsp.buf.format({
                        filter = function(client)
                            local null_supported = formatting_enabled(bufnr)

                            if client.name == "null-ls" then
                                if null_supported then
                                    vim.notify("Formatting with: " .. client.name, nil, { title = "FMT" })
                                    return true
                                else
                                    return false
                                end
                            else
                                if null_supported then
                                    return false
                                elseif client.supports_method("textDocument/formatting") then
                                    vim.notify("Formatting with: " .. client.name, nil, { title = "FMT" })
                                    return true
                                else
                                    return false
                                end
                            end
                        end,
                        bufnr = bufnr,
                    })
                end,
                mode = { "n", "v" },
                desc = "[null] Format file or range",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        init = function()
            map("n", "<leader>li", "<cmd>LspInfo<CR>", { noremap = true }, "Info")
            map("n", "<leader>ls", "<cmd>LspStart<CR>", { noremap = true }, "Start")
            map("n", "<leader>lS", "<cmd>LspStop<CR>", { noremap = true }, "Stop")
            map("n", "<leader>lr", "<cmd>LspRestart<CR>", { noremap = true }, "Restart")
            map("n", "<leader>ll", "<cmd>LspLog<CR>", { noremap = true }, "Log")
            for _, x in ipairs({ "gra", "grn", "gri", "grr", "grt" }) do
                pcall(umap, "n", x, {})
            end
        end,
        cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart", "LspLog" },
        config = function()
            local blink = require("blink.cmp")

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = conf.icons.diagnostic.Error,
                        [vim.diagnostic.severity.WARN] = conf.icons.diagnostic.Warn,
                        [vim.diagnostic.severity.INFO] = conf.icons.diagnostic.Info,
                        [vim.diagnostic.severity.HINT] = conf.icons.diagnostic.Hint,
                    },
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP config",
                callback = function(event)
                    local client_id = vim.tbl_get(event, "data", "client_id")
                    local client = client_id and vim.lsp.get_client_by_id(client_id)
                    local bufnr = event.buf

                    if client then
                        -- Signature help keymap
                        if client.server_capabilities.signatureHelpProvider then
                            map("i", "<C-S>", function()
                                vim.lsp.buf.signature_help({ border = conf.options.float_border })
                            end, { buffer = bufnr, noremap = true }, "[lsp] Show signature")
                        end

                        -- General LSP keymaps
                        map(
                            "n",
                            "<leader>cdw",
                            -- "<cmd>lua vim.diagnostic.setqflist()<cr>",
                            "<cmd>lua require('telescope.builtin').diagnostics()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Code workspace diagnostics"
                        )
                        map(
                            "n",
                            "<leader>cdd",
                            "<cmd>lua vim.diagnostic.setloclist()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Code document diagnostics"
                        )
                        map("n", "K", function()
                            vim.lsp.buf.hover({ border = conf.options.float_border })
                        end, { buffer = bufnr, noremap = true }, "[lsp] Hover documentation")
                        map(
                            "n",
                            "gd",
                            "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Go to definition"
                        )
                        map(
                            "n",
                            "gD",
                            "<cmd>vsplit | lua vim.lsp.buf.declaration()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Go to declaration"
                        )
                        map(
                            "n",
                            "gi",
                            "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Go to implementation"
                        )
                        map(
                            "n",
                            "go",
                            "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Go to type definition"
                        )
                        map(
                            "n",
                            "gr",
                            "<cmd>lua require('telescope.builtin').lsp_references()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Go to reference"
                        )
                        map(
                            "n",
                            "<leader>cn",
                            "<cmd>lua vim.lsp.buf.rename()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Rename symbol"
                        )
                        map(
                            "n",
                            "<leader>cc",
                            "<cmd>lua vim.lsp.buf.code_action()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Execute code action"
                        )
                        map(
                            "n",
                            "gl",
                            "<cmd>lua vim.diagnostic.open_float()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Show diagnostic"
                        )
                        map(
                            "n",
                            "[d",
                            "<cmd>lua vim.diagnostic.goto_prev()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Prev diagnostic"
                        )
                        map(
                            "n",
                            "]d",
                            "<cmd>lua vim.diagnostic.goto_next()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Next diagnostic"
                        )
                        map(
                            "n",
                            "gO",
                            "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
                            { buffer = bufnr, noremap = true },
                            "[lsp] Document symbols"
                        )
                        if vim.lsp.buf.range_code_action then
                            map(
                                "x",
                                "<leader>cc",
                                "<cmd>lua vim.lsp.buf.range_code_action()<cr>",
                                { buffer = bufnr, noremap = true },
                                "[lsp] Execute code action"
                            )
                        else
                            map(
                                "x",
                                "<leader>cc",
                                "<cmd>lua vim.lsp.buf.code_action()<cr>",
                                { buffer = bufnr, noremap = true },
                                "[lsp] Execute code action"
                            )
                        end
                        -- vim.diagnostic.config({ virtual_lines = { current_line = true } })
                    end
                end,
            })

            for lsp_name, settings in pairs(lsps) do
                settings.capabilities = blink.get_lsp_capabilities(settings.capabilities)
                vim.lsp.enable(lsp_name)
                vim.lsp.config(lsp_name, settings)
            end
        end,
    },
}
