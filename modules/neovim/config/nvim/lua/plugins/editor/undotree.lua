return {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    init = function()
        local map = require("lib").map
        local toggle_sidebar = require("lib").toggle_sidebar
        map("n", "<leader>u", function()
            toggle_sidebar("undotree")
            vim.cmd("UndotreeToggle")
        end, { silent = true }, "Open Undo Explorer")
    end,
    config = function()
        local conf = require("conf")
        local undotree_dir = require("lib").path_join(conf.cache_dir, "undotree")
        local target_path = vim.fn.expand(undotree_dir)

        vim.g.undotree_CustomUndotreeCmd = "topleft vertical 30 new"
        vim.g.undotree_CustomDiffpanelCmd = "belowright 10 new"
        vim.g.undotree_SetFocusWhenToggle = 1

        if vim.fn.has("persistent_undo") == 1 then
            if not vim.fn.isdirectory(target_path) then
                vim.fn.mkdir(target_path, "p", 700)
                vim.o.undofile = true
                vim.o.undodir = target_path
            end
        end
    end,
}
