table.insert(pkgs,
{ 'hrsh7th/nvim-cmp',
requires= {
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-calc"},
  {"hrsh7th/cmp-cmdline"},
  {"hrsh7th/cmp-emoji"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-nvim-lua"},
  {"hrsh7th/cmp-omni"},
  {"hrsh7th/cmp-path"},
  -- {"hrsh7th/cmp-vsnip"},
  -- {"hrsh7th/vim-vsnip"},
  {"cstrap/python-snippets"},
  {"f3fora/cmp-spell"},
  {"rust-lang/vscode-rust"},
  {"saadparwaiz1/cmp_luasnip"},
  {"L3MON4D3/LuaSnip"},
  {"rafamadriz/friendly-snippets"},
}})

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  print("nvim-cmp is not loaded.")
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  print("luasnip is not loaded.")
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local icons = require "my.icons"

local kind_icons = icons.kind

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ['<C-j>'] = cmp.mapping.confirm({ select = true }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
      },
            -- ['<CR>'] = cmp.mapping.confirm(),
            -- ['<S-Tab>'] = function(fallback)
            --   if vim.fn.call("vsnip#jumpable", {-1}) == 1 then
            --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '')
            --   else
            --     fallback()
            --   end
            -- end,
            -- ['<Tab>'] = function(fallback)
            --   if vim.fn.call("vsnip#jumpable", {1}) == 1 then
            --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-next)', true, true, true), '')
            --   else
            --     fallback()
            --   end
            -- end
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
    "i",
    "s",
  }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, {
  "i",
  "s",
}),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

      if entry.source.name == "cmp_tabnine" then
        -- if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
        -- menu = entry.completion_item.data.detail .. " " .. menu
        -- end
        vim_item.kind = icons.misc.Robot
      end
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- NOTE: order matters
      vim_item.menu = ({
        calc = "[Calc]",
        snippets_nvim = "[Norc]",
        spell = "[Spell]",
        vsnip = "[Vsnip]",

        nvim_lsp = "",
        nvim_lua = "",
        luasnip = "",
        buffer = "",
        path = "",
        emoji = "",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'calc' },
    { name = 'path' },
    { name = 'snippets_nvim' },
    { name = 'vsnip' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = "luasnip" },
    { name = 'omni' },
    { name = 'spell' },
    { name = 'buffer' },
    { name = "cmp_tabnine" },
    { name = 'emoji' },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  experimental = {
    ghost_text = true,
  },
}
