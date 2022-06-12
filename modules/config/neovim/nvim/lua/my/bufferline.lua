local wkmap = require'my.wk'.map

table.insert(pkgs, {"akinsho/bufferline.nvim", requires={{"moll/vim-bbye"}}})
local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  print("Bufferline is not loaded.")
  return
end

bufferline.setup {
  options = {
    numbers = "none",
    close_command = "Bdelete! %d",
    right_mouse_command = "Bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    separator_style = "slant",
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    sort_by = "directory",
    persist_buffer_sort = true,
    always_show_bufferline = true,
    offsets = {
      {filetype = "NvimTree", text = "File Explorer", highlight = "Directory"},
      {filetype = "nerdtree", text = "File Explorer", highlight = "Directory"}
    },
  },
}

wkmap({
  ['<C-W>'] = {
    d = {'<cmd>Bdelete<CR>', 'Delete Buffer'},
    ['<C-D>'] = {'<cmd>Bdelete<CR>', 'Delete Buffer'}
  },
  ['<Tab>'] = {'<cmd>BufferLineCycleNext<CR>', 'Cycle Buffer'},
  ['<S-Tab>'] = {'<cmd>BufferLineCyclePrev<CR>', 'Cycle Back Buffer'},
  ['<leader>ob'] = {
    name = '+Buffers',
    s = {'<cmd>BufferLineSortByDirectory<CR>', 'Sort Buffer in Line'},
  },
},{
  noremap = true,
  silent = true
})
