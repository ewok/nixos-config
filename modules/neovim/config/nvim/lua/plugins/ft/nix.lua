return {
    "mrcjkb/telescope-manix",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        local telescope = require("telescope")
        telescope.load_extension("manix")
    end,
}
