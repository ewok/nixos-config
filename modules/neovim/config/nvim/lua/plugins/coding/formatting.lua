return {
    "stevearc/conform.nvim",
    keys = {
        {
            "<leader>cf",
            function()
                local conform = require("conform")
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end,
            mode = { "n", "v" },
            desc = "Format file or range (in visual mode)",
        },
    },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
                shell = { "shfmt" },
                bash = { "shfmt" },
                sh = { "shfmt" },
                nix = { "nixpkgs_fmt" },
                clojure = { "zprint" },
            },
        })
    end,
}
