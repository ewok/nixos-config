local lib = require("lib")

lib.reg_ft("lua", function(ev)
    local wk_ok, wk = pcall(require, "which-key")
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.foldmethod = "marker"
    vim.opt_local.foldmarker = "{{{,}}}"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    if wk_ok then
        wk.add({
            { "<leader>ce", buffer = ev.buf, group = "Eval[conjure]" },
            { "<leader>cec", buffer = ev.buf, group = "Eval Comment[conjure]" },
            { "<leader>cl", buffer = ev.buf, group = "Log[conjure]" },
            { "<leader>cr", buffer = ev.buf, group = "Reset[conjure]" },
        })
    end

    pcall(vim.treesitter.start)
end)

lib.reg_lsp("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    "vim",
                    "require",
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

lib.reg_ft_once("lua", function()
    require("conform").formatters_by_ft.lua = { "stylua" }
    require("nvim-treesitter").install({ "lua" })
end)
