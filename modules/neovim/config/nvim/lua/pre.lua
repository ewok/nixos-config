-- (local {: path-join} (require :lib))
local path_join = require("lib").path_join
local conf = require("conf")

vim.fn.setenv("PATH", path_join(conf.data_dir, "mason", "bin") .. ":" .. vim.env.PATH)

-- Dealing with large files.
local LargeFileGroup = vim.api.nvim_create_augroup("LargeFile", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "*",
    group = LargeFileGroup,
    callback = function()
        local fname = vim.fn.expand("<afile>")
        if vim.fn.getfsize(fname) > conf.options.large_file_size then
            if vim.fn.input("Large file detected, turn off features? (y/N): ", "n") == "y" then
                vim.opt_local.inccommand = ""
                vim.opt_local.wrap = true
                vim.cmd("syntax off")
                vim.cmd("IndentBlanklineDisable")
                vim.opt_local.foldmethod = "manual"
                vim.opt_local.spell = false
                vim.bo.swapfile = false
                vim.bo.bufhidden = "unload"
                vim.bo.buftype = "nowrite"
                vim.bo.undolevels = -1
                vim.cmd("setlocal eventignore+=FileType")
                vim.g.largefile = true -- setting a global variable, might be used elsewhere in configuration
            end
        end
    end,
})
