local lib = require("lib")
local map = lib.map
local get_file_cwd = lib.get_file_cwd
local conf = require("conf")

map("n", "<C-W>S", function()
    if conf.in_tmux then
        vim.cmd("silent !tmux split-window -v -l 20\\% -c %:p:h")
    else
        vim.cmd("split term://bash")
    end
end, { noremap = true, silent = true }, "Split window")

map("n", "<C-W>V", function()
    if conf.in_tmux then
        vim.cmd("silent !tmux split-window -h -l 20\\% -c %:p:h")
    else
        vim.cmd("vsplit term://bash")
    end
end, { noremap = true, silent = true }, "VSplit window")

map("n", "<leader>ott", function()
    vim.g.tth = false
    vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. get_file_cwd() .. "' t")
end, { silent = true }, "Open bottom terminal")

map("n", "<leader>otf", function()
    vim.g.tth = true
    vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. get_file_cwd() .. "' f")
end, { silent = true }, "Open floating terminal")

map("n", "<c-space>", function()
    if vim.g.tth then
        vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. get_file_cwd() .. "' f")
    else
        vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. get_file_cwd() .. "' t")
    end
end, { silent = true }, "Toggle bottom or float terminal")

map("n", "<leader>gg", function()
    vim.cmd("silent !tmux popup -d " .. vim.uv.cwd() .. " -xC -yC -w90% -h90% -E lazygit")
end, { silent = true }, "Open lazygit in bottom terminal")

return {
    "christoomey/vim-tmux-navigator",
    event = { "VeryLazy" },
    init = function()
        vim.g.tmux_navigator_save_on_switch = 2
        vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
}
