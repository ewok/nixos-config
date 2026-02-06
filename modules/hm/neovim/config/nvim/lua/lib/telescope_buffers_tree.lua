--- Telescope buffer picker with tree view.
-- Displays open buffers in a hierarchical tree structure grouped by directory.
-- Automatically switches to flat list when filtering (insert mode).
-- @module lib.telescope_buffers_tree
local M = {}

-- Telescope imports
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")

-------------------------------------------------------------------------------
-- Helper functions
-------------------------------------------------------------------------------

--- Split a path string into segments by "/".
local function split_path(p)
    local t = {}
    for s in p:gmatch("[^/]+") do
        t[#t + 1] = s
    end
    return t
end

--- Create ordinal string for telescope filtering.
local function make_ordinal(path, name, bufnr)
    return (path or name or "") .. " " .. tostring(bufnr or "")
end

--- Parse a path into segments, handling special prefixes (/, ~).
local function segments_for_path(p)
    if not p or p == "" then
        return {}
    end
    if p == "~" then
        return { "~" }
    end

    local prefix, rest
    if p:sub(1, 1) == "/" then
        prefix, rest = "/", p:sub(2)
    elseif p:sub(1, 2) == "~/" then
        prefix, rest = "~", p:sub(3)
    end

    local seg = split_path(rest or p)
    if prefix then
        table.insert(seg, 1, prefix)
    end
    return seg
end

--- Join path segments back into a path string.
local function join(segs, n)
    n = n or #segs
    if n <= 0 then
        return ""
    end

    local first = segs[1]
    if n == 1 then
        return first
    end

    if first == "/" then
        return "/" .. table.concat(segs, "/", 2, n)
    elseif first == "~" then
        return "~/" .. table.concat(segs, "/", 2, n)
    end
    return table.concat(segs, "/", 1, n)
end

--- Get display path for a buffer (relative to cwd, using ~ for home).
local function path_for_buf(name)
    return (name and name ~= "") and vim.fn.fnamemodify(name, ":~:.") or "[No Name]"
end

-------------------------------------------------------------------------------
-- Buffer collection
-------------------------------------------------------------------------------

--- Collect all listed buffers with path information.
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

    -- Sort by path depth, then alphabetically
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

-------------------------------------------------------------------------------
-- Tree building
-------------------------------------------------------------------------------

--- Sort children nodes (directories first, then files, alphabetically).
-- @param children table List of child nodes
-- @param is_root boolean If true, "/" and "~" directories are sorted last
local function sort_children(children, is_root)
    table.sort(children, function(a, b)
        local function rank(x)
            if x.kind == "dir" then
                if is_root and (x.name == "/" or x.name == "~") then
                    return 2
                end
                return 0
            end
            return 1
        end

        local ra, rb = rank(a), rank(b)
        if ra ~= rb then
            return ra < rb
        end
        return (a.name or "") < (b.name or "")
    end)
end

--- Compress single-child directory chains into combined names.
-- Example: a/b/c with single children becomes "a/b/c" as one node.
local function compress_empty_dirs(node)
    if node.kind ~= "dir" or node.name == "/" or node.name == "~" then
        return node
    end

    while node.children and #node.children == 1 and node.children[1].kind == "dir" do
        local child = node.children[1]
        node.name = node.name .. "/" .. child.name
        node.path = child.path
        node.children = child.children
    end

    return node
end

--- Build tree entries from buffer items for tree-style display.
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

    -- Build tree structure
    for _, it in ipairs(items) do
        local seg = it.seg
        local parent = root

        for i = 1, #seg - 1 do
            local dir_path = join(seg, i)
            parent = ensure_dir(dir_path, seg[i], parent)
        end

        local file_name = seg[#seg] or it.path
        local file_node = {
            kind = "file",
            name = file_name,
            path = it.path,
            bufnr = it.bufnr,
        }
        parent.children[#parent.children + 1] = file_node
    end

    -- Flatten tree with indentation
    local function walk(n, prefix, is_root)
        if not n.children then
            return
        end

        sort_children(n.children, is_root)

        for idx, ch in ipairs(n.children) do
            if ch.kind == "dir" then
                ch = compress_empty_dirs(ch)
            end

            local last = idx == #n.children
            local connector = is_root and "" or (last and "└── " or "├── ")
            local next_prefix = is_root and "" or (prefix .. (last and "    " or "│   "))
            local tree = prefix .. connector

            -- Format label with trailing slash for directories
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
                ordinal = make_ordinal(ch.path, ch.name, ch.bufnr),
                tree = tree,
                text = label,
            }

            if ch.kind == "dir" then
                walk(ch, next_prefix, false)
            end
        end
    end

    walk(root, "", true)
    return nodes
end

--- Build flat entries from buffer items for filtered display.
local function make_flat_entries(items)
    local nodes = {}
    for _, it in ipairs(items) do
        nodes[#nodes + 1] = {
            kind = "file",
            name = it.name,
            path = it.path,
            bufnr = it.bufnr,
            ordinal = make_ordinal(it.path, nil, it.bufnr),
            tree = "",
            text = it.path,
        }
    end
    return nodes
end

-------------------------------------------------------------------------------
-- Entry display
-------------------------------------------------------------------------------

--- Create entry maker function for telescope finder.
local function make_entry_maker(style, displayer)
    return function(e)
        return {
            value = e,
            kind = e.kind,
            ordinal = e.ordinal or make_ordinal(e.path, e.name, e.bufnr),
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
    end
end

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

--- Open the buffer picker with tree view.
-- @param opts table Configuration options:
--   - theme: string or function ("dropdown", "ivy", "cursor", or custom)
--   - theme_opts: table passed to theme function
--   - switch_on_insert: boolean, auto-switch to flat on insert (default: true)
--   - action_close: boolean, close picker after action (default: true)
--   - actions: table {key = function}, custom key-action mappings
--   - mappings: table {mode = {lhs = rhs}}, custom telescope mappings
--   - on_folder_select: function(path), callback when selecting a directory node
function M.open(opts)
    local base_opts = opts or {}
    local user_mappings = base_opts.mappings or {}
    local action_close = vim.F.if_nil(base_opts.action_close, true)
    local switch_on_insert = vim.F.if_nil(base_opts.switch_on_insert, true)
    local on_folder_select = base_opts.on_folder_select

    -- Setup theme
    local theme_name = base_opts.theme or "dropdown"
    local theme_opts = base_opts.theme_opts or {}
    local theme_get
    if type(theme_name) == "function" then
        theme_get = theme_name
    elseif type(theme_name) == "string" then
        theme_get = themes["get_" .. theme_name]
    end
    theme_get = theme_get or themes.get_dropdown

    -- Build actions map
    local actions_map = base_opts.actions or {}

    -- Merge options with theme
    local call_opts = vim.tbl_deep_extend("force", {}, base_opts)
    call_opts.theme = nil
    call_opts.theme_opts = nil
    opts = theme_get(vim.tbl_deep_extend("force", {
        previewer = false,
        initial_mode = "normal",
    }, theme_opts, call_opts))

    -- Collect and process buffers
    local items = collect_buffers()
    local tree_entries = make_tree_entries(items)
    local flat_entries = make_flat_entries(items)

    -- Find current buffer's index for default selection
    local current_bufnr = vim.api.nvim_get_current_buf()
    local default_idx
    for i, e in ipairs(tree_entries) do
        if e.kind == "file" and e.bufnr == current_bufnr then
            default_idx = i
            break
        end
    end

    -- Setup displayer
    local displayer = entry_display.create({
        separator = "",
        items = {
            {},
            { remaining = true },
        },
    })

    -- Finder factory
    local function make_finder(style)
        local results = style == "flat" and flat_entries or tree_entries
        return finders.new_table({
            results = results,
            entry_maker = make_entry_maker(style, displayer),
        })
    end

    -- Create and open picker
    pickers
        .new(opts, {
            prompt_title = "Buffers",
            finder = make_finder("tree"),
            default_selection_index = default_idx or 1,
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local style = "tree"

                -- Switch between tree and flat view
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

                -- Auto-switch on insert mode
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

                -- Apply user-defined mappings
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

                -- Select buffer action
                local function select()
                    local sel = action_state.get_selected_entry()
                    if sel and sel.kind == "file" and sel.bufnr then
                        actions.close(prompt_bufnr)
                        vim.api.nvim_set_current_buf(sel.bufnr)
                    elseif sel and sel.kind == "dir" and type(on_folder_select) == "function" then
                        actions.close(prompt_bufnr)
                        on_folder_select(sel.path)
                    end
                end

                actions.select_default:replace(select)

                -- Delete buffer and clean up empty directories
                local function delete_buffer_and_cleanup()
                    local sel = action_state.get_selected_entry()
                    if not (sel and sel.kind == "file" and sel.bufnr) then
                        return
                    end

                    -- Don't delete the buffer that was open before Telescope
                    if sel.bufnr == current_bufnr then
                        vim.notify("Cannot delete current buffer", vim.log.levels.WARN)
                        return
                    end

                    actions.delete_buffer(prompt_bufnr)

                    local new_sel = action_state.get_selected_entry()
                    local stay_on_bufnr = new_sel and new_sel.kind == "file" and new_sel.bufnr

                    -- Rebuild tree to remove empty directories
                    items = collect_buffers()
                    tree_entries = make_tree_entries(items)
                    flat_entries = make_flat_entries(items)

                    if #items == 0 then
                        actions.close(prompt_bufnr)
                        return
                    end

                    picker:refresh(make_finder(style), { reset_prompt = false })

                    if stay_on_bufnr then
                        vim.schedule(function()
                            local results = style == "flat" and flat_entries or tree_entries
                            for i, e in ipairs(results) do
                                if e.kind == "file" and e.bufnr == stay_on_bufnr then
                                    pcall(picker.set_selection, picker, i)
                                    return
                                end
                            end
                        end)
                    end
                end

                map("n", "dd", delete_buffer_and_cleanup)
                map("i", "<c-d>", delete_buffer_and_cleanup)

                -- Register custom actions
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
