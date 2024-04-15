local reg_ft = require "lib".reg_ft
local map = require "lib".map

reg_ft("qf", function()
    map('n', 'q', '<cmd>bdelete<CR>', { silent = true, buffer = true }, "Close")
    -- map('n', '<c-n>', ':cnext|wincmd p<CR>', { silent = true, buffer = true }, "Next C item")
    -- map('n', '<c-p>', ':cprevious|wincmd p<CR>', { silent = true, buffer = true }, "Previous C item")
    -- map('n', ']]', ':lnext|wincmd p<CR>', { silent = true, buffer = true }, "Next L item")
    -- map('n', '[[', ':lprevious|wincmd p<CR>', { silent = true, buffer = true }, "Previous L item")
    map('n', 'i', ':cdo s/\\<<c-r>=expand("<cword>")<cr>\\>//gc<LEFT><LEFT><LEFT>', { buffer = true }, "Edit Results")
    map('v', 'i', 'y:cdo s/<c-r>0//gc<LEFT><LEFT><LEFT>', { buffer = true }, "Edit Results")
    map('n', 'a', ':cdo s///gc<LEFT><LEFT><LEFT><LEFT>', { buffer = true }, "Edit Results")
    vim.cmd([[
    nmap <expr>  MR  ':cdo s/' . @/ . '//gc<LEFT><LEFT><LEFT>'
    ]])
end)

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

map("n", "<leader>q", toggle_qf, { silent = true }, "Toggle QF")
