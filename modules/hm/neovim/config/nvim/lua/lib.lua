local M = {}

M.map = function(mode, lhs, rhs, options, desc)
    -- Map keybinding
    options.desc = desc
    vim.keymap.set(mode, lhs, rhs, options)
end

M.umap = function(mode, lhs, options)
    -- Unmap keybinding
    pcall(vim.keymap.del, mode, lhs, options)
end

M.reg_ft = function(ft, fun, postfix)
    -- Register function for filetype
    local ft_name = "ft_" .. ft .. (postfix or "")
    vim.api.nvim_create_augroup(ft_name, { clear = true })
    vim.api.nvim_create_autocmd({ "FileType" }, { pattern = { ft }, callback = fun, group = ft_name })
end

M.path_join = function(...)
    -- Join path
    return table.concat(vim.iter({ ... }):flatten():totable(), "/")
end

M.set = function(scope, key, val, act)
    -- Set option
    -- scope - global, local, ''
    -- key - option name
    -- val - option value
    -- act - append, prepend, get
    local opt = vim[("opt" .. scope)][tostring(key)]
    return opt[act](opt, val)
end

M.cmd = function(...)
    -- Execute command
    vim.cmd(table.concat(vim.iter(...):flatten():totable(), "\n"))
end

M.exists = function(name)
    -- Check if variable exists
    return vim.fn.exists(name) ~= 0
end

M.get_all_win_buf_ft = function()
    local win_tbl = vim.api.nvim_list_wins()
    local result = {}
    for _, win_id in ipairs(win_tbl) do
        if vim.api.nvim_win_is_valid(win_id) then
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            table.insert(result, {
                win_id = win_id,
                buf_id = buf_id,
                buf_ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id }),
            })
        end
    end
    return result
end

M.get_buf_ft = function(buf_id)
    return vim.api.nvim_get_option_value("filetype", { buf = buf_id })
end

M.get_file_cwd = function()
    local current_path = vim.fn.expand("%:p")
    local cwd = vim.loop.cwd()
    if vim.fn.filereadable(current_path) == 1 then
        local current_parent = vim.fn.expand("%:p:h")
        return current_parent == "" or current_parent == nil and cwd or current_parent
    else
        return cwd
    end
end

M.once = function(name, fun)
    if not _G[name] then
        _G[name] = true
        fun()
    end
end

M.reg_ft_once = function(filetype, fun)
    vim.api.nvim_create_autocmd("FileType", { pattern = filetype, callback = fun, once = true })
end

M.lsps = {}

M.reg_lsp = function(lsp, settings)
    M.lsps[lsp] = settings
end

M.has_value = function(tbl, value)
    local found = false
    for _, v in pairs(tbl) do
        if v == value then
            found = true
            break
        end
    end
    return found
end

M.has_key = function(tbl, key)
    return tbl[key] ~= nil
end

M.is_loaded = function(module)
    return M.has_key(package.loaded, module)
end

M.t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.open_file = function(orig_window, filename, cursor_position, command)
    if orig_window ~= 0 and orig_window then
        vim.api.nvim_set_current_win(orig_window)
    end
    pcall(vim.cmd, string.format("%s %s", command, filename))
    vim.api.nvim_win_set_cursor(0, cursor_position)
end

M.get_existing_up_dir = function(name)
    local stat = vim.loop.fs_stat(name)
    if stat then
        return name
    else
        local parent = vim.fs.dirname(name)
        return parent == name and nil or M.get_existing_up_dir(parent)
    end
end

return M
