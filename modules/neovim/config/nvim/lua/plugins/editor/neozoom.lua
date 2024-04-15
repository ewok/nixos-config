return {
    "nyngwang/NeoZoom.lua",
    cmd = { "NeoZoomToggle" },
    config = function()
        local neozoom = require("neo-zoom")
        neozoom.setup({
            winopts = {
                offset = {
                    width = 0.9,
                    height = 0.85,
                },
                border = "single",
            },
            exclude_filetypes = { "lspinfo", "mason", "lazy", "fzf", "toggleterm" },
        })
    end,
    init = function()
        local map = require("lib").map
        map("n", "<leader>z", "<cmd>NeoZoomToggle<CR>", { silent = true, nowait = true }, "Zoom")
    end,
}
