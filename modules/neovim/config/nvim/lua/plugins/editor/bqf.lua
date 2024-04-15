return {
    "kevinhwang91/nvim-bqf",
    event = { "VeryLazy" },
    init = function()
        local map = require("lib").map
        local function toggle_qf()
            local qf_exists = false
            for _, win in pairs(vim.fn.getwininfo()) do
                if win.quickfix == 1 then
                    qf_exists = true
                    break
                end
            end

            if qf_exists then
                vim.cmd("cclose")
            elseif not vim.tbl_isempty(vim.fn.getqflist()) then
                vim.cmd("copen")
            end
        end

        map("n", "<leader>tq", toggle_qf, { silent = true }, "Toggle BQF")
    end,
    config = function()
        local bqf = require("bqf")
        bqf.setup({
            func_map = {
                tab = "<C-t>",
                vsplit = "<C-v>",
                split = "<C-s>",
            },
            filter = {
                fzf = {
                    action_for = {
                        ["ctrl-t"] = "tabedit",
                        ["ctrl-v"] = "vsplit",
                        ["ctrl-s"] = "split",
                    },
                },
            },
        })
    end,
}
