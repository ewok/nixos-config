local lib = require("lib")
local reg_ft, reg_ft_once, map = lib.reg_ft, lib.reg_ft_once, lib.map

reg_ft("yaml", function(ev)
    local wk_ok, wk = pcall(require, "which-key")

    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2

    map("n", "<leader>ckb", ":KustomizeBuild<cr>", { noremap = true, buffer = ev.buf }, "Kustomize Build")
    map("n", "<leader>ckk", ":KustomizeListKinds<cr>", { noremap = true, buffer = ev.buf }, "List kinds")
    map("n", "<leader>ckl", ":KustomizeListResources<cr>", { noremap = true, buffer = ev.buf }, "List resources")
    map(
        "n",
        "<leader>ckp",
        ":KustomizePrintResources<cr>",
        { noremap = true, buffer = ev.buf },
        "Print resources in folder"
    )
    map("n", "<leader>ckv", ":KustomizeValidate<cr>", { noremap = true, buffer = ev.buf }, "Validate manifests")
    map("n", "<leader>ckd", ":KustomizeDeprecations<cr>", { noremap = true, buffer = ev.buf }, "Check for deprecations")

    if wk_ok then
        wk.add({
            { "<leader>ck", group = "[ft] Kustomize", buffer = ev.buf },
        })
    end

    vim.treesitter.start()
end)

reg_ft_once("yaml", function()
    require("conform").formatters_by_ft.yaml = { "prettier" }
    require("nvim-treesitter").install({ "yaml" })
end)
