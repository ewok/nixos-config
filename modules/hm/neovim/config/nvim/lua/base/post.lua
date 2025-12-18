local set = require("lib").set
local conf = require("conf")

-- auto restore cursor position
if conf.options.auto_restore_cursor_position then
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
        pattern = { "*" },
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
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*" },
        callback = function()
            set("", "formatoptions", { "c", "r", "o" }, "remove")
        end,
    })
end

-- auto toggle rnu
if conf.options.auto_toggle_rnu then
    vim.wo.rnu = true
    vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter", "CmdlineLeave" }, {
        pattern = { "*" },
        callback = function()
            if vim.o.number then
                vim.wo.rnu = true
            end
        end,
    })
    vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter" }, {
        pattern = { "*" },
        callback = function()
            if vim.o.number then
                vim.wo.rnu = false
            end
        end,
    })
end

-- auto hide cursorline
if conf.options.auto_hide_cursorline then
    vim.api.nvim_create_autocmd({ "InsertLeave" }, { pattern = { "*" }, command = "set cursorline" })
    vim.api.nvim_create_autocmd({ "InsertEnter" }, { pattern = { "*" }, command = "set nocursorline" })
end

local function buffer_delete_only()
    local del_non_modifiable = false -- Set true to delete non-modifiable buffers
    local cur = vim.api.nvim_get_current_buf()
    for _, n in ipairs(vim.api.nvim_list_bufs()) do
        if
            n ~= cur
            and (vim.api.nvim_get_option_value("modifiable", { buf = n }) or del_non_modifiable)
            and vim.api.nvim_get_option_value("filetype", { buf = n }) ~= "aerial"
        then
            vim.api.nvim_buf_delete(n, {})
        end
    end
    vim.cmd("redrawt")
end

vim.api.nvim_create_user_command("BufOnly", buffer_delete_only, { desc = "Delete all other buffers" })

local function buffer_wipe_all()
    local del_non_modifiable = false -- Set true to delete non-modifiable buffers
    for _, n in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_get_option_value("modifiable", { buf = n }) or del_non_modifiable then
            vim.api.nvim_buf_delete(n, {})
        end
    end
    vim.cmd("redrawt")
end

vim.api.nvim_create_user_command("BufWipeAll", buffer_wipe_all, { desc = "Wipe all buffers" })

-- Autoread
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if getcmdwintype() == '' | checktime | endif",
    pattern = { "*" },
})

-- Autosize windows
vim.api.nvim_create_autocmd({ "VimResized" }, { command = "wincmd =", pattern = { "*" } })

-- load local vimrc
-- vim.api.nvim_exec([[\n  try\n    source ~/.vimrc.local\n  catch\n  endtry]], false)

-- Show virtual lines
if conf.options.show_virtual_lines then
    vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        callback = function()
            vim.diagnostic.config({ virtual_lines = { current_line = true } })
        end,
        desc = "Enable virtual_lines with current_line",
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
        pattern = "*",
        callback = function()
            vim.diagnostic.config({ virtual_lines = false })
        end,
        desc = "Disable virtual_lines",
    })
end

-- Highlight search results only when the search pattern is not empty
if conf.options.auto_hide_hlsearch then
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
        callback = function()
            if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
                vim.schedule(function()
                    vim.cmd.nohlsearch()
                end)
            end
        end,
    })
end
