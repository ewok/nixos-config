return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    -- keys = { "<leader>m", "<leader>fm", "<leader>j", "<leader>k" },
    event = { "VeryLazy" },
    config = function()
        local map = require "lib".map
        local harpoon = require("harpoon")

        harpoon:setup()

        map("n", "<leader>m", function() harpoon:list():add() end, { noremap = true }, "Mark File")
        map("n", "<leader>fm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { noremap = true },
            "Find Marks")
        map("n", "<leader>1", function() harpoon:list():select(1) end, { noremap = true }, "Goto file 1")
        map("n", "<leader>2", function() harpoon:list():select(2) end, { noremap = true }, "Goto file 2")
        map("n", "<leader>3", function() harpoon:list():select(3) end, { noremap = true }, "Goto file 3")
        map("n", "<leader>4", function() harpoon:list():select(4) end, { noremap = true }, "Goto file 4")
        map("n", "<leader>5", function() harpoon:list():select(5) end, { noremap = true }, "Goto file 5")
        map("n", "<leader>6", function() harpoon:list():select(6) end, { noremap = true }, "Goto file 6")
        map("n", "<leader>7", function() harpoon:list():select(7) end, { noremap = true }, "Goto file 7")
        -- Toggle previous & next buffers stored within Harpoon list
        -- map("n", "<leader>k", function() harpoon:list():prev() end, {}, "Goto prev file")
        -- map("n", "<leader>j", function() harpoon:list():next() end, {}, "Goto next file")
    end
}
