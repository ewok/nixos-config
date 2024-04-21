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
        { "<C-l>", mode = "i" },
        { "<C-.>", mode = "i" },
        { "<C-,>", mode = "i" },
        { "<C-;>", mode = "i" },
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
        -- vim.g.codeium_bin =  "~/.nix-profile/bin/codeium-lsp"
        vim.g.codeium_disable_bindings = 1
        vim.g.codeium_enabled = false
    end,
    config = function()
        -- require("codeium").setup({})
        -- require"codeium".setup({
        --   tools ={
        --     language_server = "~/.nix-profile/bin/codeium-lsp",
        --   }
        -- })
        vim.keymap.set("i", "<C-l>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true })
        vim.keymap.set("i", "<c-n>", function()
            return vim.fn["codeium#CycleCompletions"](1)
        end, { expr = true, silent = true })
        vim.keymap.set("i", "<c-p>", function()
            return vim.fn["codeium#CycleCompletions"](-1)
        end, { expr = true, silent = true })
        vim.keymap.set("i", "<c-g>", function()
            return vim.fn["codeium#Clear"]()
        end, { expr = true, silent = true })
    end,
}
