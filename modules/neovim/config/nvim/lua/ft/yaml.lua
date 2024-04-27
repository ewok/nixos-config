local reg_ft = require("lib").reg_ft

reg_ft("yaml", function(ev)
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    local map = require("lib").map
    map("n", "<leader>ckb", "<cmd>lua require('kustomize').build()<cr>", { noremap = true, buffer = true }, "Kustomize Build")
    map("n", "<leader>ckk", "<cmd>lua require('kustomize').kinds()<cr>", { noremap = true, buffer = true }, "List kinds")
    map(
        "n",
        "<leader>ckl",
        "<cmd>lua require('kustomize').list_resources()<cr>",
        { noremap = true, buffer = true },
        "List resources"
    )
    map(
        "n",
        "<leader>ckp",
        "<cmd>lua require('kustomize').print_resources()<cr>",
        { noremap = true, buffer = true },
        "Print resources in folder"
    )
    map(
        "n",
        "<leader>ckv",
        "<cmd>lua require('kustomize').validate()<cr>",
        { noremap = true, buffer = true },
        "Validate manifests"
    )
    map(
        "n",
        "<leader>ckd",
        "<cmd>lua require('kustomize').deprecations()<cr>",
        { noremap = true, buffer = true },
        "Check for deprecations"
    )
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
        wk.register({
            k = { name = "[ft] Kustomize" },
        }, {
            prefix = "<leader>c",
            mode = "n",
            buffer = ev.buf,
        })
    end
end)
