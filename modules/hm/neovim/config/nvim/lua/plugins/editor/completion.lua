local lib = require("lib")

local function unique_by_label(items)
    local seen = {}
    local result = {}
    for _, item in ipairs(items) do
        if type(item) == "table" and item.label and not seen[item.label] then
            seen[item.label] = true
            table.insert(result, item)
        end
    end
    return result
end

local function dedupe_toplevel(tbl)
    for k, v in pairs(tbl) do
        if type(v) == "table" and type(v[1]) == "table" and v[1].label then
            tbl[k] = unique_by_label(v)
        end
    end
    return tbl
end

return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "PaterJason/cmp-conjure",
        "hrsh7th/cmp-calc",
        { "saghen/blink.compat", version = "2.*", opts = {} },
    },
    opts = {
        keymap = {
            preset = "none",
            ["<C-space>"] = {
                "show",
                "hide",
                function()
                    if vim.g.copilot_loaded then
                        vim.fn["copilot#Suggest"]()
                    end
                end,
            },
            ["<C-h>"] = {
                "cancel",
                function()
                    if vim.g.copilot_loaded then
                        vim.fn["copilot#Dismiss"]()
                    end
                end,
            },
            ["<CR>"] = { "accept", "fallback" },
            ["<C-l>"] = {
                "select_and_accept",
                function()
                    if vim.g.copilot_loaded then
                        vim.api.nvim_feedkeys(
                            vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<C-l>", true, true, true)),
                            "n",
                            true
                        )
                    end
                end,
            },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-k>"] = {
                "select_prev",
                function()
                    if vim.g.copilot_loaded then
                        vim.fn["copilot#Previous"]()
                    end
                end,
            },
            ["<C-j>"] = {
                "select_next",
                function()
                    if vim.g.copilot_loaded then
                        vim.fn["copilot#Next"]()
                    end
                end,
            },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<Tab>"] = { "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
        },
        appearance = { nerd_font_variant = "mono" },
        completion = {
            menu = { border = "single", auto_show = true },
            list = {
                selection = { preselect = false, auto_insert = true },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100,
                window = { border = "single" },
            },
            ghost_text = { enabled = false },
        },
        sources = {
            default = {
                "calc",
                "lazydev",
                "conjure",
                "lsp",
                "path",
                "snippets",
                "buffer",
                "codecompanion",
                "obsidian",
                "obsidian_new",
                "obsidian_tags",
            },
            providers = {
                conjure = { name = "conjure", module = "blink.compat.source", score_offset = -3, opts = {} },
                calc = { name = "calc", module = "blink.compat.source", score_offset = -3, opts = {} },
                path = {
                    opts = {
                        get_cwd = function(_)
                            return vim.fn.getcwd()
                        end,
                    },
                },
                obsidian = { name = "obsidian", module = "blink.compat.source" },
                obsidian_new = { name = "obsidian_new", module = "blink.compat.source" },
                obsidian_tags = { name = "obsidian_tags", module = "blink.compat.source" },
                lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
            },
        },
        signature = { window = { border = "single" }, enabled = true },
        fuzzy = { sorts = { "exact", "score", "sort_text" } },
        cmdline = {
            keymap = {
                preset = "none",
                ["<Tab>"] = { "show_and_insert", "select_next" },
                ["<S-Tab>"] = { "show_and_insert", "select_prev" },
                ["<C-space>"] = { "show", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<Right>"] = { "select_next", "fallback" },
                ["<Left>"] = { "select_prev", "fallback" },
                ["<C-y>"] = { "select_and_accept" },
                ["<C-l>"] = { "select_and_accept" },
                ["<CR>"] = { "accept_and_enter", "fallback" },
                ["<C-e>"] = { "cancel" },
                ["<C-h>"] = { "cancel", "fallback" },
            },
            completion = {
                list = {
                    selection = { preselect = false, auto_insert = true },
                },
                menu = { auto_show = true },
            },
        },
    },
    version = "1.*",
    opts_extend = { "sources.default" },
    config = function(_, opts)
        local b = require("blink.cmp")
        b.setup(opts)
        local bl = require("blink.cmp.completion.list")
        local original = bl.show
        bl.show = function(ctx, items_by_source)
            original(ctx, dedupe_toplevel(items_by_source))
        end
    end,
}
