local conf = require("conf")

-- Setup improved input UI
require("base.input").setup()

-- Dealing with large files
-- Protect large files from sourcing and other overhead.
vim.api.nvim_create_augroup("LargeFile", {})

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    pattern = "*",
    group = "LargeFile",
    callback = function()
        local fname = vim.fn.expand("<afile>")
        if vim.fn.getfsize(fname) > conf.options.large_file_size then
            if vim.fn.input("Large file detected, turn off features?(y): ", "y") == "y" then
                vim.cmd("setlocal inccommand=")
                vim.cmd("setlocal wrap")
                vim.cmd("syntax off")
                -- vim.cmd("IndentBlanklineDisable")
                vim.opt_local.foldmethod = "manual"
                vim.opt_local.spell = false
                vim.bo.swapfile = false
                vim.bo.bufhidden = "unload"
                vim.bo.buftype = "nowrite"
                vim.bo.undolevels = -1
                vim.cmd("setlocal eventignore+=FileType")
                vim.g.largefile = true
            end
        end
    end,
})
