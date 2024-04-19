return {
    "stevearc/resession.nvim",
    event = { "VeryLazy" },
    dependencies = {
        {
            "ewok/scope.nvim",
            config = true,
        },
    },
    config = function()
        local map = require("lib").map
        local path_join = require("lib").path_join
        local resession = require("resession")
        local notify = require("notify")

        resession.setup({
            -- override default filter
            buf_filter = function(bufnr)
                local buftype = vim.bo[bufnr].buftype
                if buftype == "help" then
                    return true
                end
                if buftype ~= "" and buftype ~= "acwrite" then
                    return false
                end
                if vim.api.nvim_buf_get_name(bufnr) == "" then
                    return false
                end

                -- this is required, since the default filter skips nobuflisted buffers
                return true
            end,
            extensions = { scope = {} },
        })

        local autgroup = vim.api.nvim_create_augroup("PersistedHooks", {})

        if vim.g.auto_load_session then
            vim.fn.timer_start(1000, function()
                resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
                pcall(function()
                    vim.cmd("silent e")
                end)
            end)
        end

        vim.api.nvim_create_autocmd("VimLeavePre", {
            group = autgroup,
            callback = function()
                resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
            end,
        })

        -- mappings

        map("n", "<leader>sl", function()
            resession.load()
            pcall(function()
                vim.cmd("silent e")
            end)
            notify("Session loaded", "INFO", { title = "Session" })
        end, { silent = true }, "Session Load")

        map("n", "<leader>su", function()
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            pcall(function()
                vim.cmd("silent e")
            end)
            notify("Session loaded", "INFO", { title = "Session" })
        end, { silent = true }, "Session Load")

        map("n", "<leader>ss", function()
            resession.save()
            notify("Session saved success", "INFO", { title = "Session" })
        end, { silent = true }, "Session Save")

        map("n", "<leader>sq", function()
            resession.save()
            vim.cmd("qall")
        end, { silent = true }, "Session Quit")

        map("n", "<leader>sd", function()
            local ok, _ = pcall(resession.delete)
            if ok then
                notify("Session deleted success", "INFO", { title = "Session" })
                -- vim.cmd('qall') -- It is commented out in the original snippet, so it's not clear if it should be executed or not.
            else
                notify("Session deleted failure", "ERROR", { title = "Session" })
            end
        end, { silent = true }, "Session Delete")
    end,
}
