local v = require'my.v'

table.insert(pkgs, {
  'NTBBloodbath/doom-one.nvim',
  as = 'doom-one',
  config = function ()
    vim.cmd [[ colorscheme doom-one]]
  end,
  setup = function ()
    vim.g.doom_one_terminal_colors = true
    vim.g.doom_one_italic_comments = true
    -- if enabled.overlength then
    --   vim.api.nvim_exec([[
    --   " Mark 80-th character
    --   hi! OverLength ctermbg=168 guibg=${color_14} ctermfg=250 guifg=${color_0}
    --   call matchadd('OverLength', '\%81v', 100)
    --   ]] % colors, true)
    -- end
  end
})

v.exec([[

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
  endif

  ]], true)
