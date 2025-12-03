local lib = require("lib")
local map = lib.map

return {
    "stevearc/resession.nvim",
    event = { "VeryLazy" },
    config = function()
        local resession = require("resession")
        local e = function()
            pcall(function()
                vim.cmd("silent e")
            end)
        end
        resession.setup({
            buf_filter = function(buf)
                local buftype = vim.bo[buf].buftype
                if buftype == "help" then
                    return true
                elseif buftype ~= "" and buftype ~= "acwrite" then
                    return false
                elseif vim.api.nvim_buf_get_name(buf) == "" then
                    return false
                else
                    return true
                end
            end,
        })

        if vim.g.auto_load_session then
            if vim.fn.argc(-1) == 0 then
                vim.fn.timer_start(200, function()
                    resession.load(vim.fn.getcwd(), { silence_errors = true })
                    e()
                end)
            end
        end

        map("n", "<leader>sl", function()
            resession.load()
            e()
            vim.notify("Session loaded", vim.log.levels.INFO, { title = "Session" })
        end, { silent = true }, "Session Load")
        map("n", "<leader>su", function()
            resession.load(vim.fn.getcwd(), { silence_errors = true })
            e()
            vim.notify("Session loaded", vim.log.levels.INFO, { title = "Session" })
        end, { silent = true }, "Session Load")
        map("n", "<leader>ss", function()
            resession.save()
            vim.notify("Session saved success", vim.log.levels.INFO, { title = "Session" })
        end, { silent = true }, "Session Save")
        map("n", "<leader>sq", function()
            if resession.get_current() ~= nil then
                resession.save()
                vim.cmd("qall")
            else
                resession.save(vim.fn.getcwd(), { notify = false })
                vim.cmd("qall")
            end
        end, { silent = true }, "Session Quit")
        map("n", "<leader>sd", function()
            local ok, _ = pcall(resession.delete)
            if ok then
                vim.notify("Session deleted success", vim.log.levels.INFO, { title = "Session" })
            else
                vim.notify("Session deleted failure", vim.log.levels.ERROR, { title = "Session" })
            end
        end, { silent = true }, "Session Delete")
    end,
}
