return {
    "norcalli/nvim-colorizer.lua",
    cmd = { "ColorizerToggle" },
    init = function()
        require("lib").map("n", "<leader>tC", "<cmd>ColorizerToggle<CR>", { silent = true }, "Code Colorizer")
    end,
}
