local lib = require("lib")

local reg_ft, map = lib.reg_ft, lib.map

reg_ft("qf", function()
    map("n", "q", "<cmd>close<cr>", { silent = true, buffer = true }, "Close")
    map("n", "r", function()
        vim.diagnostic.setqflist()
        vim.notify("Refreshed")
    end, { buffer = true }, "Refresh")
    -- map("n", "rr", ":cdo s/\\<<c-r>=expand(\"<cword>\")<cr>\\>//gc<LEFT><LEFT><LEFT>", { buffer = ev.buf }, "cdo <cword>")
    -- map("n", "rR", ":cdo %s/\\<<c-r>=expand(\"<cword>\")<cr>\\>//gc<LEFT><LEFT><LEFT>", { buffer = ev.buf }, "cdo %<cword>")
    -- map("v", "rr", "y:cdo s/<c-r>0//gc<LEFT><LEFT><LEFT>", { buffer = ev.buf }, "cdo <visual>")
    -- map("n", "ri", ":cdo s///gc<LEFT><LEFT><LEFT><LEFT>", { buffer = ev.buf }, "cdo <>")
    -- map("n", "rI", ":cdo %s///gc<LEFT><LEFT><LEFT><LEFT>", { buffer = ev.buf }, "cdo %<>")
    -- vim.cmd([[
    -- nmap <expr><buffer>  MR  ':cdo s/' . @/ . '//gc<LEFT><LEFT><LEFT>' ]])
    -- map("n", "r", "<cmd>WhichKey r<cr>", { buffer = ev.buf }, "Close")
end)

-- function toggle_qf()
--   local qf_exists = false
--   for _, win in pairs(vim.fn.getwininfo()) do
--     if win.quickfix == 1 then
--       qf_exists = true
--     end
--   end
--   if qf_exists then
--     vim.cmd("cclose")
--   else
--     if not vim.tbl_isempty(vim.fn.getqflist()) then
--       vim.cmd("copen")
--     end
--   end
-- end

-- map("n", "<leader>q", toggle_qf, { silent = true }, "Toggle QF")
