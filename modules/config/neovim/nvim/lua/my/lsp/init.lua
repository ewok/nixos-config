-- LSP
local wkmap = require'my.wk'.map

table.insert(pkgs, "neovim/nvim-lspconfig")
table.insert(pkgs, "tamago324/nlsp-settings.nvim")
table.insert(pkgs, "filipdutescu/renamer.nvim")
table.insert(pkgs, "simrat39/symbols-outline.nvim")

table.insert(pkgs, {
  "folke/trouble.nvim",
  cmd = "TroubleToggle",
})
-- use "github/copilot.vim"
table.insert(pkgs, "RRethy/vim-illuminate")

-- Java
--  use "mfussenegger/nvim-jdtls"
local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "my.lsp.lsp-signature"
require "my.lsp.lsp-installer"
require("my.lsp.handlers").setup()
require "my.lsp.null-ls"

-- Keys
wkmap({
  ['<leader>'] = {
    l = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = { "<cmd>TroubleToggle<cr>", "Diagnostics" },
      w = {
        "<cmd>Telescope lsp_workspace_diagnostics<cr>",
        "Workspace Diagnostics",
      },
      f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
      F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
      j = {
        "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>",
        "Next Diagnostic",
      },
      k = {
        "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>",
        "Prev Diagnostic",
      },
      l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
      o = { "<cmd>SymbolsOutline<cr>", "Outline" },
      q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
      S = {
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        "Workspace Symbols",
      },
    },
  }
},{
    noremap = true,
    silent = true
  })
