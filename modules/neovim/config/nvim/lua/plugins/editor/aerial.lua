local function on_attach(bufnr)
    local map = require("lib").map
    map("n", "{", "<cmd>lua require('aerial').prev()<cr>", { silent = true, buffer = bufnr }, "Move item up")
    map("n", "}", "<cmd>lua require('aerial').next()<cr>", { silent = true, buffer = bufnr }, "Move item down")
    map("n", "[[", "<cmd>lua require('aerial').prev_up()<cr>", { silent = true, buffer = bufnr }, "Move up one level")
    map("n", "]]", "<cmd>lua require('aerial').next_up()<cr>", { silent = true, buffer = bufnr }, "Move down one level")
end

return {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle" },
    init = function()
        local map = require("lib").map
        map("n", "<leader>a", "<cmd>AerialToggle! right<cr>", { silent = true }, "Open Outline Explorer")
    end,
    config = function()
        local conf = require("conf")
        local aerial = require("aerial")

        aerial.setup({
            icons = conf.icons,
            layout = { min_width = 40 },
            show_guides = true,
            backends = { "lsp", "treesitter", "markdown" },
            update_events = "TextChanged,InsertLeave",
            on_attach = on_attach,
            lsp = {
                diagnostics_trigger_update = false,
                update_when_errors = true,
                update_delay = 300,
            },
            guides = {
                mid_item = "├─",
                last_item = "└─",
                nested_top = "│ ",
                whitespace = "  ",
            },
            filter_kind = {
                "Module",
                "Struct",
                "Interface",
                "Class",
                "Constructor",
                "Enum",
                "Function",
                "Method",
            },
        })
    end,
}