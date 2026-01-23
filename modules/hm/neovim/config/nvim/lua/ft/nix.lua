local lib = require("lib")

lib.reg_ft("nix", function(ev)
  -- lib.map("n", "<leader>fm", "<Cmd>lua require('telescope').extensions.manix.manix()<CR>", { silent = true, buffer = ev.buf }, "Nix manual[manix]")
    pcall(vim.treesitter.start)
end)

lib.reg_lsp("nil_ls", {})

lib.reg_ft_once("nix", function()
    require("conform").formatters_by_ft.nix = { "nixpkgs_fmt" }
    require("nvim-treesitter").install({ "nix" })
end)
