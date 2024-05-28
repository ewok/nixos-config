local M = {}

--   "Join path"
function M.path_join(...)
    return table.concat(vim.tbl_flatten({ ... }), "/")
end

--   "Set option:
--     :scope - global, local, ''
--     :key - option name
--     :val - option value
--     :act - append, prepend, get"
function M.set(scope, key, val, act)
    key = tostring(key)
    local opt = vim["opt" .. scope][key]
    opt[act](opt, val)
end

function M.map(mode, lhs, rhs, options, desc)
    options.desc = desc
    vim.keymap.set(mode, lhs, rhs, options)
end

function M.reg_ft(ft, fun)
    -- local ft_name = "ft_" .. ft .. (postfix or "")
    -- vim.api.nvim_create_augroup(ft_name, { clear = true })
    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = ft,
        callback = fun,
        -- group = ft_name
    })
end

local function get_all_win_buf_ft()
    local win_tbl = vim.api.nvim_list_wins()
    local result = {}
    for _, win_id in ipairs(win_tbl) do
        if vim.api.nvim_win_is_valid(win_id) then
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            table.insert(result, {
                win_id = win_id,
                buf_id = buf_id,
                buf_ft = vim.api.nvim_buf_get_option(buf_id, "filetype"),
            })
        end
    end
    return result
end

function M.toggle_sidebar(target_ft)
    local offset_ft = { "NvimTree", "undotree", "dbui", "spectre_panel", "mind" }
    for _, opts in ipairs(get_all_win_buf_ft()) do
        if opts.buf_ft ~= target_ft and vim.tbl_contains(offset_ft, opts.buf_ft) then
            vim.api.nvim_win_close(opts.win_id, true)
        end
    end
end

function M.close_sidebar(target_ft)
    for _, opts in ipairs(get_all_win_buf_ft()) do
        if opts.buf_ft == target_ft then
            vim.api.nvim_win_close(opts.win_id, true)
        end
    end
end

function M.umap(mode, lhs, options)
    vim.keymap.del(mode, lhs, options)
end

function M.is_ft_open(target_ft)
    local result = false
    for _, opts in ipairs(get_all_win_buf_ft()) do
        if opts.buf_ft == target_ft then
            return true
        end
    end
    return false
end

function M.get_file_cwd()
    local current_path = vim.fn.expand("%:p")
    local cwd = vim.loop.cwd()
    if vim.fn.filereadable(current_path) == 1 then
    else
        return cwd
    end
    local current_parent = vim.fn.expand("%:p:h")
    if current_parent == "" or current_parent == nil then
        return cwd
    else
        return current_parent
    end
end

-- -- Function singleton
function M.once(name, func)
    if not _G[name] then
        _G[name] = true
        func()
    end
end

-- Function to run once on FileType
function M.reg_ft_once(filetype, func)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetype,
        callback = func,
        once = true,
    })
end

M.lsps = {}
function M.reg_lsp(lsp_list)
    for _, lsp_name in ipairs(lsp_list) do
        table.insert(M.lsps, lsp_name)
    end
end

return M
