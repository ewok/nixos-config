-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

local installer_resources = {
    -- lsp = {
    "ansible-language-server",
    "bash-language-server",
    "clojure-lsp",
    "fennel-language-server",
    "gopls",
    "jq",
    "json-lsp",
    "ltex-ls",
    "lua-language-server",
    "pyright",
    "terraform-ls",
    "zk",
    "yaml-language-server",
    "nil",
    -- },
    -- linter = {
    "ansible-lint",
    "clj-kondo",
    "codespell",
    "hadolint",
    "markdownlint",
    "pylint",
    "revive",
    "staticcheck",
    "tflint",
    "tfsec",
    "yamllint",
    -- },
    -- formatter = {
    "autopep8",
    "black",
    "gofumpt",
    "goimports-reviser",
    "joker",
    "jq",
    "markdownlint",
    "prettier",
    "shfmt",
    "sql-formatter",
    "stylua",
    -- },
}
-- Customize Mason plugins

---@type LazySpec
return {
    {
        "williamboman/mason.nvim",
        cmd = {
            "Mason",
            "MasonInstall",
            "MasonInstallAll",
            "MasonUpdate",
            "MasonLog",
            "MasonUninstall",
            "MasonUninstallAll",
        },
        opts = {
            ensure_installed = installer_resources, -- not an option from mason.nvim

            PATH = "skip",

            ui = {
                icons = {
                    package_pending = " ",
                    package_installed = "󰄳 ",
                    package_uninstalled = " 󰚌",
                },

                keymaps = {
                    toggle_server_expand = "<CR>",
                    install_server = "i",
                    update_server = "u",
                    check_server_version = "c",
                    update_all_servers = "U",
                    check_outdated_servers = "C",
                    uninstall_server = "X",
                    cancel_installation = "<C-c>",
                },
            },

            max_concurrent_installers = 10,
        },
        init = function ()
            local map = require "lib".map
            map("n", "<leader>pm", "<cmd>Mason<CR>", { noremap = true }, "Mason")
        end,
        config = function(_, opts)
            require("mason").setup(opts)

            vim.api.nvim_create_user_command("MasonInstallAll", function()
                if opts.ensure_installed and #opts.ensure_installed > 0 then
                    vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
                end
            end, {})

            vim.g.mason_binaries_list = opts.ensure_installed
        end,
    },
}
