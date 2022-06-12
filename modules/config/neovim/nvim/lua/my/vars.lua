local M = {}

local v = require'my.v'

M.blacklist_bufftypes = {
  'dashboard',
  'dashpreview',
  'help',
  'nerdtree',
  'nofile',
  'nvimtree',
  'NvimTree',
  'sagahover',
  'startify',
  'terminal',
  'vista',
  'which_key',
  'coc-explorer',
  'packer',
  'neo-tree',
}

M.blacklist_filetypes = {
  'coc-explorer',
  'dashboard',
  'dashpreview',
  "help",
  'help',
  "neogitstatus",
  'neo-tree',
  'nerdtree',
  'nofile',
  'nvimtree',
  'NvimTree',
  'packer',
  'sagahover',
  'startify',
  'terminal',
  "Trouble",
  'vista',
  'which_key',
}

if v.fn.executable('rg') == 1 then
  M.searcher = 'Rg'
elseif v.fn.executable('ag') == 1 then
  M.searcher = 'Ag'
else
  M.searcher = 'OldGrep'
end

return M
