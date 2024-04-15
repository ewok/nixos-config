-- {% raw %}
local reg_ft = require("lib").reg_ft
local map = require("lib").map
reg_ft("markdown", function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.wo.foldlevel = 2
    vim.wo.conceallevel = 2
    local md_opts = { noremap = true, silent = true, buffer = true }
    map('n', '<leader>ce', '<cmd>EvalBlock<CR>', md_opts, 'Run Block')
    map('n', '<CR>', '<Cmd>lua vim.lsp.buf.definition()<CR>', md_opts, 'Open Link')
    map('v', '<CR>', ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", md_opts, 'Create Link')
    map('n', '<leader>wb', '<Cmd>ZkBacklinks<CR>', md_opts, 'Backlinks')
    map('n', '<leader>wl', '<Cmd>ZkLinks<CR>', md_opts, 'Links')
    map('n', 'tn', '<cmd>MkdnTable 1 1<cr>', md_opts, 'New Table')
end)
-- {% endraw %}
