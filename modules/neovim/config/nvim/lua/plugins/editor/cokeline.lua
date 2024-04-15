return {
    "willothy/nvim-cokeline",
    event = { "VeryLazy" },
    init = function()
        local map = require("lib").map

        map("n", "<C-W>d", "<cmd>lua require('scope.core').delete_buf()<cr>", { silent = true }, "Close current buffer")
        map(
            "n",
            "<C-W><C-D>",
            "<cmd>lua require('scope.core').delete_buf()<cr>",
            { silent = true },
            "Close current buffer"
        )
    end,
    config = function()
        local conf = require("conf")
        local map = require("lib").map
        local opts = { noremap = true, silent = true }

        local cokeline = require("cokeline")
        local mapping = require("cokeline.mappings")
        local get_hex = require("cokeline.hlgroups").get_hl_attr
        local get_mode = require("lualine.utils.mode").get_mode

        local function normal_fg()
            return get_hex("lualine_a_normal", "fg")
        end

        local function normal_bg()
            return get_hex("lualine_a_normal", "bg")
        end

        local function insert_fg()
            return get_hex("lualine_a_insert", "fg")
        end

        local function insert_bg()
            return get_hex("lualine_a_insert", "bg")
        end

        local function command_fg()
            return get_hex("lualine_a_command", "fg")
        end

        local function command_bg()
            return get_hex("lualine_a_command", "bg")
        end

        local function visual_fg()
            return get_hex("lualine_a_visual", "fg")
        end

        local function visual_bg()
            return get_hex("lualine_a_visual", "bg")
        end

        local function inactive_fg()
            return get_hex("lualine_a_inactive", "fg")
        end

        local function inactive_bg()
            return get_hex("lualine_a_inactive", "bg")
        end

        local function active_fg()
            local mode = get_mode()
            if mode == "VISUAL" or mode == "V-BLOCK" or mode == "V-LINE" or mode == "V-REPLACE" then
                return visual_fg()
            elseif mode == "COMMAND" then
                return command_fg()
            elseif mode == "INSERT" then
                return insert_fg()
            else
                return normal_fg()
            end
        end

        local function active_bg()
            local mode = get_mode()
            if mode == "VISUAL" or mode == "V-BLOCK" or mode == "V-LINE" or mode == "V-REPLACE" then
                return visual_bg()
            elseif mode == "COMMAND" then
                return command_bg()
            elseif mode == "INSERT" then
                return insert_bg()
            else
                return normal_bg()
            end
        end

        local function win_fg(buffer)
            if buffer.is_focused then
                return active_fg()
            else
                return inactive_fg()
            end
        end

        local function win_bg(buffer)
            if buffer.is_focused then
                return active_bg()
            else
                return inactive_bg()
            end
        end

        local function tab_fg(tab)
            if tab.is_active then
                return active_fg()
            else
                return inactive_fg()
            end
        end

        local function tab_bg(tab)
            if tab.is_active then
                return active_bg()
            else
                return inactive_bg()
            end
        end
        cokeline.setup({
            buffers = {
                filter_visible = function(buffer)
                    return buffer.type ~= "terminal" and buffer.type ~= "help" and buffer.type ~= "nofile"
                end,
                new_buffers_position = "directory",
            },
            sidebar = {
                filetype = { "NvimTree", "undotree", "mind", "aerial" },
                components = {
                    {
                        text = function(buffer)
                            return buffer.filetype
                        end,
                        style = "bold",
                    },
                },
            },
            default_hl = { bg = inactive_bg },
            components = {
                {
                    text = function(buffer)
                        if buffer.is_focused then
                            return conf.separator.right
                        else
                            return conf.separator.alt_right
                        end
                    end,
                    fg = win_bg,
                },
                { text = " ", fg = win_fg, bg = win_bg },
                {
                    text = function(buffer)
                        return (buffer.is_readonly and "🔒 " or "")
                            .. (buffer.is_modified and "● " or "")
                            .. buffer.devicon.icon
                            .. buffer.unique_prefix
                            .. buffer.filename
                    end,
                    style = function(buffer)
                        return buffer.is_focused and "bold" or nil
                    end,
                    fg = win_fg,
                    bg = win_bg,
                },
                {
                    text = function(buffer)
                        if buffer.diagnostics.errors ~= 0 then
                            return " " .. conf.icons.diagnostic.Error .. " " .. buffer.diagnostics.errors
                        elseif buffer.diagnostics.warnings ~= 0 then
                            return " " .. conf.icons.diagnostic.Warn .. " " .. buffer.diagnostics.warnings
                        else
                            return ""
                        end
                    end,
                    fg = function(buffer)
                        if buffer.diagnostics.errors ~= 0 then
                            return get_hex("ErrorMsg", "fg")
                        elseif buffer.diagnostics.warnings ~= 0 then
                            return get_hex("IncSearch", "bg")
                        else
                            return nil
                        end
                    end,
                    style = function(buffer)
                        return buffer.is_focused and "bold" or nil
                    end,
                    bg = win_bg,
                },
                { text = " ", fg = win_fg, bg = win_bg },
                {
                    text = function(buffer)
                        if buffer.is_focused then
                            return conf.separator.left
                        else
                            return conf.separator.alt_left
                        end
                    end,
                    fg = function(buffer)
                        if buffer.is_focused then
                            return active_bg()
                        else
                            return inactive_fg()
                        end
                    end,
                },
            },
            tabs = {
                placement = "right",
                components = {
                    {
                        text = function(tab)
                            if tab.number == 1 and tab.is_last then
                                return ""
                            else
                                return tab.is_active and conf.separator.right or conf.separator.alt_right
                            end
                        end,
                        fg = function(tab)
                            return tab.is_active and active_bg() or inactive_fg()
                        end,
                    },
                    {
                        text = function(tab)
                            if tab.number == 1 and tab.is_last then
                                return ""
                            else
                                return " " .. tab.number .. " "
                            end
                        end,
                        fg = tab_fg,
                        bg = tab_bg,
                    },
                    {
                        text = function(tab)
                            if tab.number == 1 and tab.is_last then
                                return ""
                            else
                                return tab.is_active and conf.separator.left or conf.separator.alt_left
                            end
                        end,
                        fg = tab_bg,
                    },
                },
            },
            rhs = {
                { text = " " },
                {
                    text = function()
                        return string.gsub(vim.fn.getcwd(), os.getenv("HOME"), "~")
                    end,
                },
                { text = " " },
            },
        })

        map("n", "<S-Tab>", '<Cmd>lua require("cokeline.mappings").by_step("focus", -1)<CR>', opts, "Buffer/Tabs")
        map("n", "<Tab>", '<Cmd>lua require("cokeline.mappings").by_step("focus", 1)<CR>', opts, "Buffer/Tabs")

        map("n", "<leader>b", function()
            local buff_hint = [[
^^         Buffers           ^^     Tabs
^^---------------            ^^---------------
_j_, _k_: next/previous      ^^ _L_, _H_: next/previous
_d_: delete                  ^^ _D_: delete
_a_: new                     ^^ _A_: new
_o_: remain only             ^^ _O_: remain only
any : quit
]]

            local hydra = require("hydra")
            hydra({
                name = "Buffers/Tabs",
                hint = buff_hint,
                config = {
                    hint = {
                        float_opts = {
                            style = "minimal",
                        },
                    },
                    on_enter = function()
                        require("nvim-tree.api").tree.find_file({ open = true, focus = false })
                    end,
                    on_key = function()
                        require("nvim-tree.api").tree.find_file({ open = true, focus = false })
                    end,
                    on_exit = function()
                        require("lib").close_sidebar("NvimTree")
                    end,
                },
                mode = "n",
                body = "<leader>b",
                heads = {
                    {
                        "j",
                        function()
                            mapping.by_step("focus", 1)
                        end,
                    },
                    {
                        "k",
                        function()
                            mapping.by_step("focus", -1)
                        end,
                    },
                    {
                        "d",
                        function()
                            require("scope.core").delete_buf()
                        end,
                        { desc = "delete" },
                    },
                    {
                        "a",
                        function()
                            vim.cmd("enew")
                        end,
                        { desc = "new", exit = true },
                    },
                    {
                        "o",
                        function()
                            vim.cmd("BufOnly")
                        end,
                        { desc = "only", exit = true },
                    },
                    {
                        "L",
                        function()
                            vim.cmd("tabnext")
                        end,
                    },
                    {
                        "H",
                        function()
                            vim.cmd("tabprevious")
                        end,
                    },
                    {
                        "D",
                        function()
                            vim.cmd("tabclose")
                        end,
                        { desc = "delete" },
                    },
                    {
                        "A",
                        function()
                            vim.cmd("$tabnew")
                        end,
                        { desc = "new", exit = true },
                    },
                    {
                        "O",
                        function()
                            vim.cmd("tabonly")
                        end,
                        { desc = "only", exit = true },
                    },
                },
            }):activate()
        end, opts, "Buffer/Tabs")
    end,
}
