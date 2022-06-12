local augroups = require'my.v'.augroups
local oget = require'my.v'.oget

-- cursorline
local au_cline = {
  {'InsertEnter * set nocursorline'};
  {'InsertLeave * set cursorline'};
}
augroups({au_cline=au_cline})

-- Restore Cursor
local au_line_return = {
  {[[BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |]]..
  [[execute 'normal! g`"zvzz' | endif]]};
}
augroups({au_line_return=au_line_return})

-- Number Toggle
_G.rnu_on = function()
  if oget('showcmd') then
    vim.wo.rnu = true
  end
end
_G.rnu_off = function()
  if oget('showcmd') then
    vim.wo.rnu = false
  end
end
vim.wo.rnu = true
local au_rnu = {
  {'InsertEnter * lua rnu_off()'};
  {'InsertLeave * lua rnu_on()'};
}
augroups({au_rnu=au_rnu})
