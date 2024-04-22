local function under_compare(entry1, entry2)
    local entry1_under = string.find(entry1.completion_item.label, "^_+")
    local entry2_under = string.find(entry2.completion_item.label, "^_+")
    return (entry1_under or 0) < (entry2_under or 0)
end

local complete_window_settings = { fixed = true, min_width = 20, max_width = 40 }

local duplicate_keywords = {
    snippy = 1,
    nvim_lsp = 1,
    buffer = 0,
    path = 0,
    cmdline = 0,
    conjure = 0,
}

return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
        local conf = require("conf")
        local cmp = require("cmp")
        local types = require("cmp.types")

        local t = function(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
        end
        local config_opts = {
            preselect = types.cmp.PreselectMode.None,
            confirmation = {
                default_behavior = cmp.ConfirmBehavior.Insert,
            },
            snippet = {
                expand = function(args)
                    local snippy = require("snippy")
                    snippy.expand_snippet(args.body)
                end,
            },
            sources = {
                { name = "codeium" },
                { name = "calc" },
                { name = "snippy" },
                { name = "nvim_lsp" },
                { name = "conjure" },
                { name = "path" },
                { name = "buffer" },
            },
            mapping = {
                ["<c-space>"] = cmp.mapping(function(fallback)
                    if not cmp.visible() then
                        cmp.complete()
                    else
                        cmp.abort()
                    end
                end),
                ["<cr>"] = cmp.mapping(cmp.mapping.confirm(), { "i", "s", "c" }),
                ["<C-n>"] = cmp.mapping({
                    c = function()
                        -- if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        -- else
                        --     vim.api.nvim_feedkeys(t("<Down>"), "n", true)
                        -- end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<C-p>"] = cmp.mapping({
                    c = function()
                        -- if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        -- else
                        --     vim.api.nvim_feedkeys(t("<Up>"), "n", true)
                        -- end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s", "c" }),
                ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s", "c" }),
                ["<c-u>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        for i = 1, 5 do
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        end
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
                ["<c-d>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        for i = 1, 5 do
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        end
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
                ["<c-k>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.abort()
                    else
                        cmp.complete()
                    end
                end, { "i", "s", "c" }),
            },
            sorting = {
                priority_weight = 2,
                comparators = {
                    -- require 'copilot_cmp.comparators'.prioritize,
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    under_compare,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
            window = conf.options.float_border
                    and {
                        completion = cmp.config.window.bordered({
                            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                        }),
                        documentation = cmp.config.window.bordered({
                            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                        }),
                    }
                or {},
            formatting = {
                format = function(entry, vim_item)
                    local kind = vim_item.kind
                    local source = entry.source.name
                    vim_item.kind = string.format("%s %s", conf.icons.lsp_kind[kind], kind)
                    vim_item.menu = string.format("<%s>", string.upper(source))
                    vim_item.dup = duplicate_keywords[source] or 0
                    if complete_window_settings.fixed and vim.fn.mode() == "i" then
                        local label = vim_item.abbr
                        local min_width = complete_window_settings.min_width
                        local max_width = complete_window_settings.max_width
                        local truncated_label = vim.fn.strcharpart(label, 0, max_width)
                        if truncated_label ~= label then
                            vim_item.abbr = string.format("%s %s", truncated_label, "…")
                        elseif string.len(label) < min_width then
                            local padding = string.rep(" ", min_width - string.len(label))
                            vim_item.abbr = string.format("%s %s", label, padding)
                        end
                    end
                    return vim_item
                end,
            },
        }
        cmp.setup(config_opts)
        cmp.setup.cmdline("/", {
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline("?", {
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            sources = cmp.config.sources({
                { name = "path" },
                { name = "cmdline" },
            }),
        })
    end,
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp", config = false, event = "InsertEnter" },
        { "hrsh7th/cmp-buffer", config = false, event = "InsertEnter" },
        { "hrsh7th/cmp-path", config = false, event = "InsertEnter" },
        { "hrsh7th/cmp-cmdline", config = false, event = { "InsertEnter", "CmdlineEnter" } },
        { "hrsh7th/cmp-calc", config = false, event = "InsertEnter" },
        -- { "PaterJason/cmp-conjure", config = false, event = "InsertEnter" },
        "dcampos/cmp-snippy",
    },
}
