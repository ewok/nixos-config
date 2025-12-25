return {
    "emmanueltouzery/apidocs.nvim",
    cmd = { "ApidocsSearch", "ApidocsInstall", "ApidocsOpen", "ApidocsSelect", "ApidocsUninstall" },
    config = function()
        require("apidocs").setup()
        -- Picker will be auto-detected. To select a picker of your choice explicitly you can set picker by the configuration option 'picker':
        -- require('apidocs').setup({picker = "snacks"})
        -- Possible options are 'ui_select', 'telescope', and 'snacks'
    end,
    keys = {
        { "<leader>fh", "<cmd>ApidocsOpen<cr>", desc = "Search Api Doc" },
    },
}
