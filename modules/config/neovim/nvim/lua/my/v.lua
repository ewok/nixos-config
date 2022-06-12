local M = {}

M.api = vim.api
M.cmd = vim.cmd
M.execute = M.api.nvim_command
M.exec = M.api.nvim_exec
M.fn = vim.fn
M.oget = M.api.nvim_get_option
M.oset = M.api.nvim_set_option

M.Utils = {}

M.augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

M.augroups_buff = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd! * <buffer>')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

M.map = M.api.nvim_set_keymap

M.bmap = function(mode, key, comm, flags)
  M.api.nvim_buf_set_keymap(M.api.nvim_get_current_buf(), mode, key, comm, flags)
end

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.interp = function(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end
getmetatable("").__mod = M.interp

return M
