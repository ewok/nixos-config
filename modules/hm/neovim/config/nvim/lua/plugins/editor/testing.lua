local lib = require("lib")
local is_loaded = lib.is_loaded
local reg_ft, map = lib.reg_ft, lib.map

for _, x in ipairs({ "neotest-summary", "neotest-output-panel" }) do
    reg_ft(x, function()
        map("n", "q", "<cmd>close<cr>", { silent = true, buffer = true }, "Close")
    end)
end

return {
    "nvim-neotest/neotest",
    keys = {
        {
            "<leader>tt",
            function()
                require("neotest").run.run()
                if is_loaded("coverage") then
                    require("coverage").load(true)
                end
            end,
            desc = "Run Nearest Test",
        },
        {
            "<leader>tf",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
                if is_loaded("coverage") then
                    require("coverage").load(true)
                end
            end,
            desc = "Run Current Test File",
        },
        {
            "<leader>td",
            function()
                require("neotest").run.run({ strategy = "dap" })
            end,
            desc = "Debug Nearest Test",
        },
        {
            "<leader>tS",
            function()
                require("neotest").run.stop()
            end,
            desc = "Stop Nearest Test",
        },
        {
            "<leader>ta",
            function()
                require("neotest").run.attach()
            end,
            desc = "Attach to Nearest Test",
        },
        {
            "<leader>to",
            function()
                require("neotest").output.open({ enter = true })
            end,
            desc = "Open Test Output",
        },
        {
            "<leader>tp",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "Toggle Test Output Panel",
        },
        {
            "<leader>ts",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Toggle Test Summary",
        },
    },
    dependencies = {
        "nvim-neotest/nvim-nio",
        "antoinemadec/FixCursorHold.nvim",
        {
            "fredrikaverpil/neotest-golang",
            version = "*", -- Optional, but recommended; track releases
            -- build = function()
            --     vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
            -- end,
            dependencies = {
                "andythigpen/nvim-coverage", -- Added dependency
                version = "*",
                config = function()
                    require("coverage").setup({
                        auto_reload = true,
                    })
                end,
            },
        },
    },
    config = function()
        local config = {
            -- runner = "gotestsum", -- Optional, but recommended
            runner = "go",
            go_test_args = {
                "-v",
                "-race",
                "-count=1",
                "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            },
        }
        ---@diagnostic disable
        require("neotest").setup({
            adapters = {
                require("neotest-golang")(config),
            },
            diagnostic = {
                enabled = true,
                severity = 1,
            },
            summary = {
                animated = true,
                count = true,
                enabled = true,
                expand_errors = true,
                follow = true,
                mappings = {
                    attach = "a",
                    clear_marked = "M",
                    clear_target = "T",
                    debug = "d",
                    debug_marked = "D",
                    expand = "l",
                    expand_all = "L",
                    help = "?",
                    jumpto = "<CR>",
                    mark = "m",
                    next_failed = "J",
                    next_sibling = ">",
                    output = "o",
                    parent = "u",
                    prev_failed = "K",
                    prev_sibling = "<",
                    run = "r",
                    run_marked = "R",
                    short = "O",
                    stop = "s",
                    target = "t",
                    watch = "w",
                },
                open = "botright vsplit | vertical resize 50",
            },
        })
    end,
}
