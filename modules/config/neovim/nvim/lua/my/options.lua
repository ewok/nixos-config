local v = require'my.v'

local set_options = {
  shell = 'bash';
  backspace = '2';
  backup = false;
  clipboard = 'unnamed,unnamedplus';
  cmdheight = 2;
  compatible = false;
  completeopt = { "menuone", "noselect" };
  confirm = true;
  encoding = 'utf-8';
  enc = 'utf-8';
  errorbells = false;
  exrc = true;
  hidden = true;
  history = 1000;
  hlsearch = true;
  ignorecase = true;
  incsearch = true;
  laststatus = 3;
  linespace = 0;
  mouse = '';
  pumheight = 10;
  ruler = true;
  scrolloff = 5;
  secure = true;
  shortmess = 'aOtT';
  showmode = false;
  showtabline = 2;
  smartcase = true;
  smarttab = true;
  splitbelow = true;
  splitright = true;
  startofline = false;
  switchbuf = 'useopen';
  signcolumn = "yes";
  termguicolors = true;
  timeoutlen = 500;
  titlestring = '%F';
  title = true;
  ttimeoutlen = -1;
  ttyfast = true;
  undodir = os.getenv('HOME')..'/.vim_undo';
  undolevels = 100;
  updatetime = 300;
  visualbell = true;
  writebackup = false;
  guicursor = 'n-v-c:block,i-ci-ve:block,r-cr:hor20,'..
  'o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,'..
  'sm:block-blinkwait175-blinkoff150-blinkon175';
  shada = [['50,<1000,s100,"10,:10,f0,n]]..v.fn.stdpath('data')..[[shada/main.shada]];
  inccommand = 'nosplit';

  -- Buf opts
  bomb = false;
  copyindent = true;
  expandtab = true;
  fenc = 'utf-8';
  shiftwidth = 4;
  softtabstop = 4;
  swapfile = false;
  synmaxcol = 1000;
  tabstop = 4;
  undofile = true;

  -- Window opts
  cursorline = true;
  number = true;
  foldenable = false;
  wrap = false;
  list = false;
  linebreak = true;
  numberwidth = 4;
}

for opt, val in pairs(set_options) do
  local info = v.api.nvim_get_option_info(opt)
  local scope = info.scope

  vim.opt[opt] = val
  if scope == 'win' then
    vim.wo[opt] = val
  elseif scope == 'buf' then
    vim.bo[opt] = val
  elseif scope == 'global' then
  else
    print(opt..' has '..scope.. ' scope?')
  end
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.shortmess:append "c"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

v.exec([[
filetype plugin indent on

syntax on
syntax enable

set sessionoptions+=globals
]], true)
