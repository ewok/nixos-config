return {
    "Exafunction/codeium.vim",
    cmd = {
        "Codeium",
        "CodeiumEnable",
        "CodeiumDisable",
        "CodeiumToggle",
        "CodeiumManual",
        "CodeiumAuto",
    },
    keys = {
        {
            "<leader>tc",
            function()
                local notify = require("notify")
                vim.cmd("CodeiumToggle")
                if vim.g.codeium_enabled then
                    notify("Codeium Enabled", "INFO", { title = "Codeium" })
                else
                    notify("Codeium Disabled", "INFO", { title = "Codeium" })
                end
            end,
            mode = "n",
            desc = "Toggle Codeium for Buffer",
        },
    },
    init = function()
        vim.g.codeium_disable_bindings = 1
        vim.g.codeium_enabled = false
    end,
    config = function()
        local map = require("lib").map

        map("i", "<C-l>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true, noremap = true }, "Codeium Complete")
        map("i", "<c-j>", function()
            vim.call("codeium#CycleCompletions", 1)
        end, { silent = true, noremap = true }, "Codeium next")
        map("i", "<c-k>", function()
            vim.call("codeium#CycleCompletions", 1)
        end, { silent = true, noremap = true }, "Codeium prev")
        map("i", "<c-g>", function()
            return vim.fn["codeium#Clear"]()
        end, { expr = true, silent = true, noremap = true }, "Codeium abort")
    end,
}
