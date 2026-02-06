local path_join = require("lib").path_join
local conf = require("conf")
local haunt_root = path_join(conf.notes_dir, "projects/haunt")

return {
    "TheNoeTrevino/haunt.nvim",
    enabled = conf.packages.haunt,
    lazy = false,
    config = function()
        require("haunt").setup({
            sign = "󱙝",
            sign_hl = "DiagnosticInfo",
            virt_text_hl = "HauntAnnotation",
            annotation_prefix = " 󰆉 ",
            line_hl = nil,
            virt_text_pos = "eol",
            data_dir = haunt_root,
            per_branch_bookmarks = true,
            picker = "telescope",
            picker_keys = {
                delete = { key = "<c-d>", mode = { "i" } },
                edit_annotation = { key = "<c-a>", mode = { "i" } },
            },
        })
    end,
    keys = {
        {
            "mm",
            function()
                require("haunt.api").annotate()
            end,
            desc = "Annotate",
        },
        {
            "mt",
            function()
                require("haunt.api").toggle_annotation()
            end,
            desc = "Toggle annotation",
        },
        {
            "mT",
            function()
                require("haunt.api").toggle_all_lines()
            end,
            desc = "Toggle all annotations",
        },
        {
            "md",
            function()
                require("haunt.api").delete()
            end,
            desc = "Delete bookmark",
        },
        {
            "mD",
            function()
                require("haunt.api").clear_all()
            end,
            desc = "Delete all bookmarks",
        },
        {
            "mp",
            function()
                require("haunt.api").prev()
            end,
            desc = "Previous bookmark",
        },
        {
            "mn",
            function()
                require("haunt.api").next()
            end,
            desc = "Next bookmark",
        },
        {
            "ml",
            function()
                require("haunt.picker").show(require('telescope.themes').get_ivy({}))
            end,
            desc = "Show Picker",
        },
        {
            "mq",
            function()
                require("haunt.api").to_quickfix()
            end,
            desc = "Send Hauntings to QF Lix (buffer)",
        },
        {
            "mQ",
            function()
                require("haunt.api").to_quickfix({ current_buffer = true })
            end,
            desc = "Send Hauntings to QF Lix (all)",
        },
        {
            "my",
            function()
                require("haunt.api").yank_locations({ current_buffer = true })
            end,
            desc = "Send Hauntings to Clipboard (buffer)",
        },
        {
            "mY",
            function()
                require("haunt.api").yank_locations()
            end,
            desc = "Send Hauntings to Clipboard (all)",
        },
    },
}
