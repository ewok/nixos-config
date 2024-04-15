return {
    "mg979/vim-visual-multi",
    keys = { "<c-n>" },
    config = function()
        vim.g.VM_Extend_hl = "DiffAdd"
        vim.g.VM_Cursor_hl = "Visual"
        vim.g.VM_Mono_hl = "DiffText"
        vim.g.VM_Insert_hl = "DiffChange"
        vim.g.VM_default_mappings = 0
        vim.g.VM_maps = {
            ["Find Under"] = "<c-n>",
            ["Find Prev"] = "<c-p>",
            ["Skip Region"] = "<c-s>",
            ["Remove Region"] = "<c-d>",
        }
    end,
}
