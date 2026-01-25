local path_join = require("lib").path_join
local conf = require("conf")
local haunt_root = path_join(conf.notes_dir, "projects/haunt")

return {
    "ewok/haunt.nvim",
    -- "TheNoeTrevino/haunt.nvim",
    -- dir = "~/projects/vim/haunt.nvim",
    -- event = { "BufReadPre" },
    enabled = false,
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
            picker_keys = {
                delete = { key = "d", mode = { "n" } },
                edit_annotation = { key = "a", mode = { "n" } },
            },
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = { "NeogitBranchCheckout" },
            callback = function()
                require("haunt.api").sync_branch()
            end,
        })
        vim.api.nvim_create_autocmd({ "DirChanged", "FocusGained" }, {
            callback = function()
                require("haunt.api").sync_branch()
            end,
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
                require("haunt.picker").show()
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
