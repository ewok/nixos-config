local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")

local function split_path(p)
    local t = {}
    for s in p:gmatch("[^/]+") do
        t[#t + 1] = s
    end
    return t
end

local function segments_for_path(p)
    if not p or p == "" then
        return {}
    end
    if p:sub(1, 1) == "/" then
        local seg = split_path(p:sub(2))
        table.insert(seg, 1, "/")
        return seg
    end
    if p:sub(1, 2) == "~/" then
        local seg = split_path(p:sub(3))
        table.insert(seg, 1, "~")
        return seg
    end
    if p == "~" then
        return { "~" }
    end
    return split_path(p)
end

local function path_for_buf(name)
    if not name or name == "" then
        return "[No Name]"
    end
    -- relative to cwd if possible; use ~ for home
    return vim.fn.fnamemodify(name, ":~:.")
end

local function collect_buffers()
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    local items = {}

    for _, b in ipairs(bufs) do
        local name = vim.api.nvim_buf_get_name(b.bufnr)
        local p = path_for_buf(name)
        items[#items + 1] = {
            kind = "file",
            name = vim.fs.basename(p),
            path = p,
            bufnr = b.bufnr,
            seg = segments_for_path(p),
        }
    end

    table.sort(items, function(a, b)
        if a.path == "[No Name]" and b.path ~= "[No Name]" then
            return false
        end
        if b.path == "[No Name]" and a.path ~= "[No Name]" then
            return true
        end

        local da = select(2, a.path:gsub("/", ""))
        local db = select(2, b.path:gsub("/", ""))
        if da ~= db then
            return da < db
        end
        return a.path < b.path
    end)

    return items
end

local function join(segs, n)
    n = n or #segs
    if n <= 0 then
        return ""
    end
    if n == 1 then
        return segs[1]
    end
    if segs[1] == "/" then
        return "/" .. table.concat(segs, "/", 2, n)
    end
    if segs[1] == "~" then
        return "~/" .. table.concat(segs, "/", 2, n)
    end
    return table.concat(segs, "/", 1, n)
end

local function sort_children(children)
    table.sort(children, function(a, b)
        local function kind_rank(x)
            if x.kind == "dir" then
                -- Default: dirs first, then files.
                return 0
            end

            return 1
        end

        local ra = kind_rank(a)
        local rb = kind_rank(b)
        if ra ~= rb then
            return ra < rb
        end

        return (a.name or "") < (b.name or "")
    end)
end

local function sort_root_children(children)
    table.sort(children, function(a, b)
        local function rank(x)
            if x.kind == "dir" and (x.name == "/" or x.name == "~") then
                return 2
            end
            if x.kind == "dir" then
                return 0
            end
            return 1
        end

        local ra = rank(a)
        local rb = rank(b)
        if ra ~= rb then
            return ra < rb
        end

        return (a.name or "") < (b.name or "")
    end)
end

local function compress_empty_dirs(n)
    if not n or n.kind ~= "dir" then
        return n
    end

    if n.name == "/" or n.name == "~" then
        return n
    end

    while true do
        if not n.children or #n.children ~= 1 then
            break
        end
        local only = n.children[1]
        if only.kind ~= "dir" then
            break
        end
        n.name = n.name .. "/" .. only.name
        n.path = only.path
        n.children = only.children
    end

    return n
end

local function make_tree_entries(items)
    local root = { kind = "root", name = "", children = {} }
    local dir_by_path = { [""] = root }
    local nodes = {}

    local function ensure_dir(dir_path, name, parent)
        if dir_by_path[dir_path] then
            return dir_by_path[dir_path]
        end
        local n = { kind = "dir", name = name, path = dir_path, children = {} }
        dir_by_path[dir_path] = n
        parent.children[#parent.children + 1] = n
        return n
    end

    for _, it in ipairs(items) do
        local p = it.path
        local seg = it.seg

        local parent = root
        for i = 1, #seg - 1 do
            local dir_path = join(seg, i)
            parent = ensure_dir(dir_path, seg[i], parent)
        end

        local file_name = seg[#seg] or p
        local node = {
            kind = "file",
            name = file_name,
            path = p,
            bufnr = it.bufnr,
        }
        parent.children[#parent.children + 1] = node
    end

    local function walk(n, prefix, is_root)
        if n.children then
            if is_root then
                sort_root_children(n.children)
            else
                sort_children(n.children)
            end
            for idx, ch in ipairs(n.children) do
                if ch.kind == "dir" then
                    ch = compress_empty_dirs(ch)
                end
                local last = idx == #n.children
                local connector = is_root and "" or (last and "└── " or "├── ")
                local next_prefix = is_root and "" or (prefix .. (last and "    " or "│   "))

                local tree = prefix .. connector

                local label = ch.name
                if ch.kind == "dir" then
                    if label == "/" then
                        label = "/"
                    elseif label == "~" then
                        label = "~/"
                    else
                        label = label .. "/"
                    end
                end

                nodes[#nodes + 1] = {
                    kind = ch.kind,
                    bufnr = ch.bufnr,
                    path = ch.path,
                    ordinal = (ch.path or ch.name or "") .. " " .. tostring(ch.bufnr or ""),
                    tree = tree,
                    text = label,
                }

                if ch.kind == "dir" then
                    walk(ch, next_prefix, false)
                end
            end
        end
    end

    walk(root, "", true)

    return nodes
end

local function make_flat_entries(items)
    local nodes = {}
    for _, it in ipairs(items) do
        nodes[#nodes + 1] = {
            kind = "file",
            name = it.name,
            path = it.path,
            bufnr = it.bufnr,
            ordinal = it.path .. " " .. tostring(it.bufnr),
            tree = "",
            text = it.path,
        }
    end
    return nodes
end

function M.open(opts)
    local base_opts = opts or {}
    local user_mappings = base_opts.mappings or {}
    local action_key = base_opts.action_key or base_opts.file_manager_key
    local action = base_opts.action or base_opts.file_manager
    local action_close = vim.F.if_nil(base_opts.action_close, true)
    local switch_on_insert = vim.F.if_nil(base_opts.switch_on_insert, true)

    local theme_name = base_opts.theme or "dropdown"
    local theme_opts = base_opts.theme_opts or {}
    local theme_get = nil
    if type(theme_name) == "function" then
        theme_get = theme_name
    elseif type(theme_name) == "string" then
        theme_get = themes["get_" .. theme_name]
    end
    theme_get = theme_get or themes.get_dropdown

    -- Backwards compatible / additional actions.
    local actions_map = {}
    if type(base_opts.actions) == "table" then
        for k, v in pairs(base_opts.actions) do
            actions_map[k] = v
        end
    end
    if type(action_key) == "string" and action_key ~= "" and type(action) == "function" then
        actions_map[action_key] = action
    end

    local call_opts = vim.tbl_deep_extend("force", {}, base_opts)
    call_opts.theme = nil
    call_opts.theme_opts = nil
    opts = theme_get(vim.tbl_deep_extend("force", {
        previewer = false,
        initial_mode = "normal",
    }, theme_opts, call_opts))

    local items = collect_buffers()
    local tree_entries = make_tree_entries(items)
    local flat_entries = make_flat_entries(items)

    local current_bufnr = vim.api.nvim_get_current_buf()
    local default_idx = nil
    for i, e in ipairs(tree_entries) do
        if e.kind == "file" and e.bufnr == current_bufnr then
            default_idx = i
            break
        end
    end

    local displayer = entry_display.create({
        separator = "",
        items = {
            {},
            { remaining = true },
        },
    })

    local function make_finder(style)
        local results = style == "flat" and flat_entries or tree_entries
        return finders.new_table({
            results = results,
            entry_maker = function(e)
                return {
                    value = e,
                    kind = e.kind,
                    ordinal = e.ordinal or ((e.path or e.name or "") .. " " .. tostring(e.bufnr or "")),
                    tree = e.tree,
                    text = e.text,
                    path = e.path,
                    bufnr = e.bufnr,
                    display = function(entry)
                        if style == "flat" then
                            return entry.path or entry.text or ""
                        end
                        local hl = entry.kind == "dir" and "Directory" or nil
                        return displayer({
                            { entry.tree or "", "TelescopeResultsComment" },
                            { entry.text or "", hl },
                        })
                    end,
                }
            end,
        })
    end

    pickers
        .new(opts, {
            prompt_title = "Buffers",
            finder = make_finder("tree"),
            default_selection_index = default_idx or 1,
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local style = "tree"

                local function switch_to(new_style)
                    if new_style == style then
                        return
                    end

                    local selected = action_state.get_selected_entry()
                    local keep_bufnr = (selected and selected.kind == "file" and selected.bufnr)
                        or vim.api.nvim_get_current_buf()

                    style = new_style
                    picker:refresh(make_finder(style), { reset_prompt = false })

                    vim.schedule(function()
                        local results = style == "flat" and flat_entries or tree_entries
                        for i, e in ipairs(results) do
                            if e.kind == "file" and e.bufnr == keep_bufnr then
                                pcall(picker.set_selection, picker, i)
                                break
                            end
                        end
                    end)
                end

                if switch_on_insert then
                    vim.api.nvim_create_autocmd("InsertEnter", {
                        buffer = prompt_bufnr,
                        callback = function()
                            switch_to("flat")
                        end,
                    })
                    vim.api.nvim_create_autocmd("InsertLeave", {
                        buffer = prompt_bufnr,
                        callback = function()
                            switch_to("tree")
                        end,
                    })
                end

                local function apply_user_mappings(mode)
                    local m = user_mappings[mode] or {}
                    for lhs, rhs in pairs(m) do
                        if type(rhs) == "function" then
                            map(mode, lhs, function()
                                rhs(prompt_bufnr)
                            end)
                        end
                    end
                end

                local function select()
                    local sel = action_state.get_selected_entry()
                    if sel and sel.kind == "file" and sel.bufnr then
                        actions.close(prompt_bufnr)
                        vim.api.nvim_set_current_buf(sel.bufnr)
                    end
                end

                actions.select_default:replace(select)

                map("n", "dd", function()
                    local sel = action_state.get_selected_entry()
                    if sel and sel.kind == "file" and sel.bufnr then
                        actions.delete_buffer(prompt_bufnr)
                    end
                end)
                map("i", "<c-d>", function()
                    local sel = action_state.get_selected_entry()
                    if sel and sel.kind == "file" and sel.bufnr then
                        actions.delete_buffer(prompt_bufnr)
                    end
                end)

                for lhs, rhs in pairs(actions_map) do
                    if type(lhs) == "string" and lhs ~= "" and type(rhs) == "function" then
                        map("n", lhs, function()
                            if action_close then
                                actions.close(prompt_bufnr)
                            end
                            rhs(prompt_bufnr, action_state.get_selected_entry())
                        end)
                    end
                end

                apply_user_mappings("n")
                apply_user_mappings("i")

                return true
            end,
        })
        :find()
end

return M
