local map = require("lib").map
local conf = require("conf")

local md = { noremap = true, silent = true }

-- ;; Converters
map("v", "<leader>6d", "c<c-r>=system('base64 --decode', @\")<cr><esc>", md, "Decode Base64")
map("v", "<leader>6e", "c<c-r>=system('base64', @\")<cr><esc>", md, "Encode Base64")

-- Open current cwd note page
-- TODO: Check this one
local function open_mind()
    local git_url = io.popen("git remote get-url origin 2>/dev/null | sed 's/^.*://;s/.git$//'"):read("*a")
    local project_name
    if git_url == "" then
        project_name = string.match(vim.fn.getcwd(), "([^/]+)$")
    else
        git_url = string.match(git_url, "^%s*(.-)%s*$")
        project_name = git_url:gsub("/", "_")
    end
    vim.cmd("e " .. conf.notes_dir .. "/mind/" .. project_name .. ".md")
end

map("n", "<leader>on", open_mind, md, "Open CWD note")
--
-- ;; Navigation
map("n", "<C-O><C-O>", "<C-O>", md, "Go Back")
map("n", "<C-O><C-I>", "<Tab>", md, "Go Forward")
--
-- ;; Windows manipulation
-- Navigation
map("n", "<C-O><C-O>", "<C-O>", md, "Go Back")
map("n", "<C-O><C-I>", "<Tab>", md, "Go Forward")

-- Windows manipulation
map("n", "<C-W>t", "<cmd>tabnew<CR>", md, "New Tab")

-- Terminal
map("n", "<C-W>S", function()
    if conf.in_tmux then
        vim.cmd("silent !tmux split-window -v -l 20\\%")
    else
        vim.cmd("split term://bash")
    end
end, md, "Split window")
map("n", "<C-W>V", function()
    if conf.in_tmux then
        vim.cmd("silent !tmux split-window -h -l 20\\%")
    else
        vim.cmd("vsplit term://bash")
    end
end, md, "VSplit window")

map("n", "<leader>ot", function()
    vim.g.tth = false
    vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. require("lib").get_file_cwd() .. "' false")
end, { silent = true }, "Open bottom terminal")
map("n", "<leader>of", function()
    vim.g.tth = true
    vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. require("lib").get_file_cwd() .. "' true")
end, { silent = true }, "Open floating terminal")

map({ "n" }, "<c-space>", function()
    if vim.g.tth then
        vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. require("lib").get_file_cwd() .. "' true")
    else
        vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. require("lib").get_file_cwd() .. "' false")
    end
end, { silent = true }, "Toggle bottom or float terminal")

map("n", "<leader>gg", function()
    vim.cmd([[silent !tmux popup -d ]] .. vim.uv.cwd() .. [[ -xC -yC -w90\\% -h90\\% -E lazygit]])
end, { silent = true }, "Open lazygit in bottom terminal")

-- themes
map("n", "<leader>th", function()
    if vim.o.background == "dark" then
        vim.cmd.colorscheme(conf.options.light_theme)
        pcall(function()
            require("lualine").setup({ options = { theme = conf.options.light_theme } })
        end)
        os.execute("toggle-theme light")
    else
        vim.cmd.colorscheme(conf.options.theme)
        pcall(function()
            require("lualine").setup({ options = { theme = conf.options.theme } })
        end)
        os.execute("toggle-theme dark")
    end
end, { noremap = true }, "Toggle theme")

--

map("n", "<C-W><C-J>", "<cmd>resize +5<CR>", md, "Increase height +5")
map("n", "<C-W><C-K>", "<cmd>resize -5<CR>", md, "Decrease height -5")
map("n", "<C-W><C-L>", "<cmd>vertical resize +5<CR>", md, "Increase width +5")
map("n", "<C-W><C-H>", "<cmd>vertical resize -5<CR>", md, "Decrease width -5")
map("n", "<C-W>q", "<cmd>close<CR>", md, "Close window")
map("n", "<C-W><C-Q>", "<cmd>close<CR>", md, "Close window")

-- Folding
map("n", "]z", "zjmzzMzvzz15<c-e>`z", md, "Next Fold")
map("n", "[z", "zkmzzMzvzz15<c-e>`z", md, "Previous Fold")
map("n", "zO", ":zczO", md, "Open all folds under cursor")
map("n", "zC", "zcV:foldc!<CR>", md, "Close all folds under cursor")
map("n", "z<Space>", "mzzMzvzz15<c-e>`z", md, "Show only current Fold")
map("n", "<Space><Space>", 'za"{{{"', md, "Toggle Fold")
map("x", "<Space><Space>", 'zf"}}}"', md, "Toggle Fold")

-- Yank
map("n", "<leader>yy", "<cmd>.w! ~/.vbuf<CR>", md, "Yank to ~/.vbuf")
map("n", "<leader>yp", "<cmd>r ~/.vbuf<CR>", md, "Paste from ~/.vbuf")
map("x", "<leader>yy", ":'<,'>w! ~/.vbuf<CR>", md, "Yank to ~/.vbuf")
map("n", "<leader>yfl", ':let @+=expand("%") . \':\' . line(".")<CR>', md, "Yank file name and line")
map("n", "<leader>yfn", ':let @+=expand("%")<CR>', md, "Yank file name")
map("n", "<leader>yfp", ':let @+=expand("%:p")<CR>', md, "Yank file path")

-- Profiling
-- Start profiling
map(
    "n",
    "<leader>pS",
    "<cmd>profile start /tmp/profile_vim.log|profile func *|profile file *<CR>",
    md,
    "Profiling | Start"
)
-- Stop profiling
map(
    "n",
    "<leader>pT",
    "<cmd>profile stop|e /tmp/profile_vim.log|nmap <buffer> q :!rm /tmp/profile_vim.log<CR><CR>",
    md,
    "Profiling | Stop"
)

-- ;; Replace search
vim.cmd([[
nmap <expr>  MR  ':%s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
vmap <expr>  MR  ':s/\(' . @/ . '\)/\1/g<LEFT><LEFT>'
]])

-- Replace without yanking
map("v", "p", "P", md, "Replace without yanking")

-- Tunings
map("n", "Y", "y$", md, "Yank to end of line")
--
-- Don't cancel visual select when shifting
map("v", "<", "<gv", md, "Shift left and reselect")
map("v", ">", ">gv", md, "Shift right and reselect")

-- Keep the cursor in place while joining lines
map("n", "J", "mzJ`z", md, "Join lines")
map("n", "gJ", "mzgJ`z", md, "Join lines")
--
-- [S]plit line (sister to [J]oin lines) S is covered by cc.
map("n", "S", "mzi<CR><ESC>`z", md, "Split line")

-- Move to start of line
local function start_line(mode)
    mode = mode or "n"
    if mode == "v" then
        vim.api.nvim_exec("normal! gv", false)
    end

    local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    vim.api.nvim_exec("normal ^", false)

    local check_cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    if cursor[1] == check_cursor[1] and cursor[2] == check_cursor[2] then
        vim.api.nvim_exec("normal 0", false)
    end
end

map("n", "H", start_line, md, "Move to start of line")
map("n", "L", "$", md, "Move to end of line")
map("v", "H", start_line, md, "Move to start of line")
map("x", "L", "$", md, "Move to end of line")

-- Terminal
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- Don't move cursor when searching via *
map(
    "n",
    "*",
    ":let stay_star_view = winsaveview()<CR>*:call winrestview(stay_star_view)<CR>",
    md,
    "Search for word under cursor"
)

-- Thanks to Wansmer
-- https://github.com/Wansmer/nvim-config/blob/f7f63d3cf18a0e40ce5ae774944d53fdd9986321/lua/autocmd.lua#L38
-- local hl_ns = vim.api.nvim_create_namespace("hl_search")
-- local function manage_hlsearch(char)
--     local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
--     if vim.fn.mode() == "n" then
--         local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))
--         if vim.opt.hlsearch:get() ~= new_hlsearch then
--             vim.opt.hlsearch = new_hlsearch
--         end
--     end
-- end
-- vim.on_key(manage_hlsearch, hl_ns)

-- Keep search matches in the middle of the window.
map("n", "n", "nzzzv", md, "Next search match")
map("n", "N", "Nzzzv", md, "Previous search match")

-- Lazy mapping
map("n", "<leader>pu", "<cmd>Lazy sync<CR>", md, "Sync Packages")
map("n", "<leader>pl", "<cmd>Lazy home<CR>", md, "List Packages")
