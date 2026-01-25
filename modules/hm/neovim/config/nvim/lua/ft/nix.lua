local lib = require("lib")
local conf = require("conf")

lib.reg_ft("nix", function(ev)
    -- lib.map("n", "<leader>fm", "<Cmd>lua require('telescope').extensions.manix.manix()<CR>", { silent = true, buffer = ev.buf }, "Nix manual[manix]")
    pcall(vim.treesitter.start)
end)

lib.reg_lsp("nil_ls", {})

lib.reg_ft_once("nix", function()
    require("nvim-treesitter").install({ "nix" })
    if conf.packages.conform then
        require("conform").formatters_by_ft.nix = { "nixpkgs_fmt" }
    end
    if conf.packages.null then
        local null_ls = require("null-ls")
        null_ls.register({ null_ls.builtins.formatting.nixpkgs_fmt })
    end
end)
