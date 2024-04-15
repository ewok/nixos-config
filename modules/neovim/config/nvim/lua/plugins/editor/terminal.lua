local map = require("lib").map
local umap = require("lib").umap

local function open_callback(term)
    map('t', '<C-J>', '<c-\\><c-n><cmd>TmuxNavigateDown<cr>', { silent = true, buffer = term.bufnr }, 'Down')
    map('t', '<C-H>', '<c-\\><c-n><cmd>TmuxNavigateLeft<cr>', { silent = true, buffer = term.bufnr }, 'Left')
    map('t', '<C-K>', '<c-\\><c-n><cmd>TmuxNavigateUp<cr>', { silent = true, buffer = term.bufnr }, 'Up')
    map('t', '<C-L>', '<c-\\><c-n><cmd>TmuxNavigateRight<cr>', { silent = true, buffer = term.bufnr }, 'Right')
    map('n', '<C-N>', ':i<C-N>', { silent = true, buffer = term.bufnr }, 'Next')
    map('n', '<C-P>', ':i<C-P>', { silent = true, buffer = term.bufnr }, 'Previous')
    map('n', '<C-C>', ':i<C-C>', { silent = true, buffer = term.bufnr }, 'Break')
    map('t', '<C-U>', '<c-\\><c-n><C-U>', { silent = true, buffer = term.bufnr }, 'ScrollUp')
    map('t', '<C-Y>', '<c-\\><c-n><C-Y>', { silent = true, buffer = term.bufnr }, 'ScrollOneUp')
    map('n', '<CR>', ':i', { silent = true, buffer = term.bufnr }, 'Enter')
    umap('t', '<esc>')
end

local function open_callback_lazygit(term)
    umap('t', '<esc>')
    local keys = { '<C-CR>', '<C-Space>' }
    for _, key in ipairs(keys) do
        map('t', key, '<c-\\><c-n><cmd>close<cr>', { silent = true, buffer = term.bufnr }, "Escape lazygit terminal")
    end
    map('i', 'q', '<cmd>close<cr>', { silent = true, buffer = term.bufnr }, "Escape lazygit terminal")
    vim.cmd('startinsert')
end

local function close_callback()
    map('t', '<esc>', '<c-\\><c-n>', { silent = true }, "Escape terminal insert mode")
end

return {
    "akinsho/toggleterm.nvim",
    keys = { "<c-space>", "<leader>ot", "<leader>of", "<leader>gg" },
    config = function()
        local conf = require "conf"
        local toggleterm = require "toggleterm"
        local shell = vim.fn.executable("fish") == 1 and "fish" or "bash"

        toggleterm.setup {
            start_in_insert = true,
            shade_terminals = true,
            shading_factor = 10, -- changed from -10 to 10 as negative values are not valid
            persist_size = false,
            persist_mode = false,
            size = function(term)
                if term.direction == "horizontal" then
                    return vim.o.lines * 0.25
                else
                    return vim.o.columns * 0.25
                end
            end,
            on_open = function(term)
                vim.wo.spell = false
            end,
            highlights = {
                Normal = { guibg = conf.colors.base00 },
                NormalFloat = { link = "NormalFloat" },
                FloatBorder = { link = "FloatBorder" }
            },
            shell = shell
        }

        -- Setting terminals
        local terminal = require "toggleterm.terminal"
        local terms = terminal.Terminal
        local term = terms:new({
            direction = 'horizontal',
            count = 110,
            size = function(term)
                if term.direction == 'horizontal' then
                    return vim.o.lines * 0.25
                else
                    return vim.o.columns * 0.25
                end
            end,
            float_opts = {
                border = conf.options.float_border and 'rounded' or 'none',
                width = function() return vim.o.columns - 4 end,
                height = function() return vim.o.lines - 5 end
            },
            on_open = open_callback,
            on_close = close_callback
        })
        local horizontal_term = function() term:toggle(nil, "horizontal") end
        local float_term = function() term:toggle(nil, "float") end

        map("n", "<leader>ot", function()
            vim.g.tth = false
            horizontal_term()
        end, { silent = true }, "Open bottom terminal")
        map("n", "<leader>of", function()
            vim.g.tth = true
            float_term()
        end, { silent = true }, "Open floating terminal")
        map({ "n", "t" }, "<c-space>", function()
            if vim.g.tth then
                float_term()
            else
                horizontal_term()
            end
        end, { silent = true }, "Toggle bottom or float terminal")
        map("n", "<leader>gg", function()
            terms:new({
                cmd = "lazygit",
                hidden = true,
                count = 142,
                direction = "float",
                float_opts = {
                    border = conf.options.float_border and 'rounded' or 'none',
                    width = function() return vim.o.columns - 4 end,
                    height = function() return vim.o.lines - 5 end
                },
                on_open = open_callback_lazygit,
                on_close = close_callback
            }):toggle()
        end, { silent = true }, "Open LazyGit")
    end
}
