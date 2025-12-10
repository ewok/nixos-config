return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.toggle({})
                end,
                desc = "Toggle REPL",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_out()
                end,
                desc = "Step Out",
            },
        },
    },
    {
        "leoluz/nvim-dap-go",
        dependencies = { "mfussenegger/nvim-dap" },
        ft = { "go", "gomod" },
        config = function()
            require("dap-go").setup()
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle({})
                end,
                desc = "Toggle Dap UI",
            },
        },
        config = function()
            require("dapui").setup()
        end,
    },
}
