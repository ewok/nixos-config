return {
    {
        "someone-stole-my-name/yaml-companion.nvim",
        ft = { "yaml" },
        config = function()
            local map = require("lib").map
            local lsp_zero = require("lsp-zero")

            local yamlconfig = require("yaml-companion")
            local cfg = yamlconfig.setup({
                handlers = {
                    lsp_zero.default_setup,
                },
                schemas = {
                    {
                        name = "Kubernetes 1.22.4",
                        uri =
                        "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
                    },
                },
            })
            local telescope = require("telescope")
            telescope.load_extension("yaml_schema")

            local lspconfig = require("lspconfig")
            lspconfig.yamlls.setup(cfg)
            map(
                "n",
                "<leader>cs",
                '<cmd>lua require("yaml-companion").open_ui_select()<CR>',
                { noremap = true, silent = true },
                "[ft] Switch Schema"
            )
        end,
    },
    {
        "allaman/kustomize.nvim",
        ft = "yaml",
        config = function()
            require("kustomize").setup({ enable_key_mappings = false })
        end,
    },
}
