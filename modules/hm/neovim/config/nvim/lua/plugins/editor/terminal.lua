local lib = require("lib")
local map = lib.map
local get_file_cwd = lib.get_file_cwd
local conf = require("conf")

if conf.in_tmux then
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

    map("n", "<leader><leader>tt", function()
        vim.g.tth = false
        vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. get_file_cwd() .. "' t")
    end, { silent = true }, "Open bottom terminal")

    map("n", "<leader><leader>tf", function()
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
        vim.cmd("silent !~/.config/tmux/tmux_toggle '" .. vim.uv.cwd() .. "' f gg gg")
        -- vim.cmd("silent !tmux popup -d " .. vim.uv.cwd() .. " -xC -yC -w90\\% -h90\\% -E lazygit")
    end, { silent = true }, "Open lazygit in float terminal")
end

if conf.in_zellij then
    -- Horizontal split (bottom pane with auto-layout)
    map("n", "<C-W>S", function()
        vim.cmd("silent !zellij run -c --cwd " .. vim.fn.shellescape(get_file_cwd()) .. " -- bash")
        vim.cmd("silent !zellij action next-swap-layout 2>/dev/null || true")
    end, { noremap = true, silent = true }, "Split window horizontally")

    -- Toggle bottom terminal (tab-scoped, create or fullscreen zoom)
    map("n", "<c-space>", function()
        vim.cmd("silent !~/.config/zellij/scripts/zellij_toggle " .. vim.fn.shellescape(get_file_cwd()) .. " -- bash")
    end, { silent = true }, "Toggle bottom terminal")

    -- Lazygit in floating terminal (unchanged)
    map("n", "<leader>gg", function()
        vim.cmd(
            "silent !zellij run --floating -c --cwd "
                .. vim.uv.cwd()
                .. " -x 5\\% -y 5\\% --width 90\\% --height 90\\%  --  gg"
        )
    end, { silent = true }, "Open lazygit in float terminal")
end

return {
    -- {
    --     "christoomey/vim-tmux-navigator",
    --     event = { "VeryLazy" },
    --     init = function()
    --         vim.g.tmux_navigator_save_on_switch = 2
    --         vim.g.tmux_navigator_disable_when_zoomed = 1
    --     end,
    -- },
    {
        "swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "navigate left or tab" } },
            { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
            { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
            { "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" } },
        },
        opts = {},
    },
}
