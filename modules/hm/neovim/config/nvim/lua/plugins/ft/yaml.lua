local map = require("lib").map

return {
    {
        "someone-stole-my-name/yaml-companion.nvim",
        ft = "yaml",
        config = function()
            local yamlconfig = require("yaml-companion")
            local cfg = yamlconfig.setup({
                schemas = {
                    {
                        name = "Kubernetes 1.22.4",
                        uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
                    },
                },
            })
            local telescope = require("telescope")
            telescope.load_extension("yaml_schema")
            vim.lsp.config("yamlls", cfg)
            map(
                "n",
                "<leader>cs",
                "<cmd>lua require('yaml-companion').open_ui_select()<CR>",
                { noremap = true },
                "[ft] Switch Schema"
            )
        end,
    },
    {
        "allaman/kustomize.nvim",
        ft = "yaml",
        config = function()
            local kustomize = require("kustomize")
            kustomize.setup({
                enable_key_mappings = false,
            })
        end,
    },
}
