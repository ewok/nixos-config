local conf = require("conf")
local set = require("lib").set

-- auto save buffer
-- if conf.options.auto_save then
--     vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--         pattern = "*",
--         command =fun
--             "silent! wall",
--         callback = function(opts)
--             if vim.api.nvim_buf_get_var(opts.buf, "autosave") == false
--             vim.cmd("silent! wall")
--
--         end,
--         nested = true,
--     })
-- end

-- auto restore cursor position
if conf.options.auto_restore_cursor_position then
    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
            if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
                vim.fn.setpos(".", vim.fn.getpos("'\""))
                vim.cmd("silent! foldopen")
            end
        end,
    })
end

-- remove auto-comments
if conf.options.auto_remove_new_lines_comment then
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            set("", "formatoptions", { "c", "r", "o" }, "remove")
        end,
    })
end

-- auto toggle rnu
if conf.options.auto_toggle_rnu then
    vim.wo.rnu = true
    vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = "*",
        callback = function()
            if vim.api.nvim_get_option("showcmd") then
                vim.wo.rnu = true
            end
        end,
    })
    vim.api.nvim_create_autocmd("InsertEnter", {
        pattern = "*",
        callback = function()
            if vim.api.nvim_get_option("showcmd") then
                vim.wo.rnu = false
            end
        end,
    })
end

-- auto hide cursorline
if conf.options.auto_hide_cursorline then
    vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = "*",
        command = "set cursorline",
    })
    vim.api.nvim_create_autocmd("InsertEnter", {
        pattern = "*",
        command = "set nocursorline",
    })
end

local function buffer_delete_only()
    local del_non_modifiable = false -- true if you want to delete non-modifiable buffers
    local cur = vim.api.nvim_get_current_buf()
    for _, n in ipairs(vim.api.nvim_list_bufs()) do
        if n ~= cur and (vim.api.nvim_buf_get_option(n, "modifiable") or del_non_modifiable) then
            vim.api.nvim_buf_delete(n, {})
        end
    end
    vim.cmd("redraw!")
end

vim.api.nvim_create_user_command("BufOnly", buffer_delete_only, { desc = "Delete all other buffers" })
--

-- Autoread
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
})

-- Autosize windows
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

-- ;; load local vimrc
local local_vimrc = vim.fn.expand("~/.vimrc.local")
if vim.fn.filereadable(local_vimrc) == 1 then
    vim.api.nvim_command("source " .. local_vimrc)
end
