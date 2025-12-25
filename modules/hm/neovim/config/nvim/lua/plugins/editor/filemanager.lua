local lib = require("lib")
local map = lib.map
local reg_ft = lib.reg_ft
local conf = require("conf")

return {
    {
        "stevearc/oil.nvim",
        cmd = { "Oil" },
        dependencies = { "refractalize/oil-git-status.nvim" },
        init = function()
            map("n", "<space><space>", "<CMD>Oil<CR>", { noremap = true }, "Open Files")
        end,
        config = function()
            local oil = require("oil")
            local act = require("oil.actions")
            local oil_git = require("oil-git-status")

            reg_ft("oil", function(ev)
                -- vim.o.number = false

                -- map("n", "<C-t>", function()
                --     vim.cmd("tab split")
                --     oil.select()
                -- end, { buffer = ev.buf }, "Open in Tab")

                map("n", "w", "<cmd>w<cr>", { buffer = ev.buf })

                -- vim.api.nvim_create_autocmd("BufEnter", {
                --     buffer = ev.buf,
                --     callback = function()
                --         map("n", "h", act.parent.callback, { buffer = ev.buf }, "Go to Parent Directory")
                --         map("n", "l", act.select.callback, { buffer = ev.buf }, "select entry")
                --         map("n", "<C-v>", act.select_vsplit.callback, { buffer = ev.buf }, "Open in Vertical Split")
                --     end,
                -- })

                -- vim.api.nvim_create_autocmd("ModeChanged", {
                --     buffer = ev.buf,
                --     callback = function()
                --         -- check if mode is visual or insert
                --         if has_value({ "v", "i" }, vim.fn.mode()) then
                --             umap("n", "h", { buffer = ev.buf })
                --             umap("n", "l", { buffer = ev.buf })
                --             umap("n", "<C-v>", { buffer = ev.buf })
                --             vim.notify("Disabled h/l in oil buffer to prevent accidental navigation")
                --         end
                --     end,
                -- })
            end)

            oil.setup({
                float = {
                    padding = 2,
                    max_width = 0.5,
                    max_height = 0.8,
                    border = conf.options.float_border,
                    win_options = { winblend = 0 },
                    get_win_title = nil,
                    preview_split = "auto",
                },
                default_file_explorer = true,
                columns = { "size", "icon" },
                skip_confirm_for_simple_edits = false,
                prompt_save_on_select_new_entry = true,
                cleanup_delay_ms = 2000,
                constrain_cursor = "editable",
                watch_for_changes = true,
                win_options = {
                    signcolumn = "yes:2",
                    number = false,
                    wrap = false,
                    foldcolumn = "0",
                    spell = false,
                    list = false,
                    conceallevel = 3,
                    -- concealcursor = "nvic",
                },
                delete_to_trash = false,
                use_default_keymaps = false,
                view_options = { show_hidden = true },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    -- ["<CR>"] = "actions.select",
                    -- ["l"] = "actions.select",
                    -- ["<C-v>"] = "actions.select_vsplit",
                    -- ["<C-s>"] = "actions.select_split",
                    -- ["<C-p>"] = "actions.preview",
                    -- ["h"] = "actions.parent",
                    -- ["u"] = "actions.parent",
                    ["q"] = "actions.close",
                    -- [";"] = "actions.close",
                    ["R"] = "actions.refresh",
                    ["@"] = "actions.open_cwd",
                    ["."] = "actions.cd",
                    ["gs"] = "actions.change_sort",
                    ["gx"] = "actions.open_external",
                    ["g."] = "actions.toggle_hidden",
                    ["gR"] = "actions.toggle_trash",
                },
            })
            oil_git.setup({})
        end,
    },
    {
        "nvim-mini/mini.files",
        version = "*",
        dependencies = { "nvim-mini/mini.icons" },
        enable = false,
        config = function()
            local mini_files = require("mini.files")
            mini_files.setup({
                mappings = {
                    go_in = "L",
                    go_in_plus = "l",
                },
            })

            local function map_split(buf_id, lhs, direction)
                local function rhs()
                    -- Make new window and set it as target
                    local cur_target = mini_files.get_explorer_state().target_window
                    local new_target = vim.api.nvim_win_call(cur_target, function()
                        vim.cmd(direction .. " split")
                        return vim.api.nvim_get_current_win()
                    end)
                    mini_files.set_target_window(new_target)
                    mini_files.go_in({ close_on_file = true })
                end

                vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Split " .. direction })
            end

            local ui_open = function()
                vim.ui.open(mini_files.get_fs_entry().path)
            end

            -- Set focused directory as current working directory
            local set_cwd = function()
                local path = (mini_files.get_fs_entry() or {}).path
                if path == nil then
                    return vim.notify("Cursor is not on valid entry")
                end
                vim.fn.chdir(vim.fs.dirname(path))
            end

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesBufferCreate",
                callback = function(args)
                    map("n", "g.", set_cwd, { buffer = args.data.buf_id }, "Set cwd")
                    map("n", "gx", ui_open, { buffer = args.data.buf_id }, "OS open")
                    map("n", "<esc>", function()
                        mini_files.close()
                    end, { buffer = args.data.buf_id }, "Close")
                    map("n", ";", function()
                        mini_files.close()
                    end, { buffer = args.data.buf_id }, "Close")
                    map_split(args.data.buf_id, "<C-s>", "belowright horizontal")
                    map_split(args.data.buf_id, "<C-v>", "belowright vertical")
                    map_split(args.data.buf_id, "<C-t>", "tab")
                end,
            })
        end,
        init = function()
            map(
                "n",
                "<space><space>",
                "<CMD>lua if not require('mini.files').close() then require('mini.files').open() end<CR>",
                { noremap = true },
                "Open Files"
            )
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        init = function()
            map(
                "n",
                ";",
                "<CMD>Neotree buffers focus dir=/ reveal toggle float<CR>",
                { noremap = true },
                "Open buffers"
            )
        end,
        config = function()
            local call_filesystem = function()
                vim.cmd("Neotree close")
                vim.cmd("Neotree focus filesystem float reveal")
            end
            local call_close = function()
                vim.cmd("Neotree close")
            end
            local call_oil = function(state)
                local node = state.tree:get_node()
                if node then
                    if node.type == "file" then
                        vim.cmd("Oil " .. vim.fn.fnamemodify(node.path, ":h"))
                        return
                    end
                    if node.type == "directory" then
                        vim.cmd("Oil " .. node.path)
                        return
                    end
                end
            end

            require("neo-tree").setup({
                close_if_last_window = true,
                popup_border_style = conf.options.float_border,
                enable_git_status = true,
                enable_diagnostics = true,
                open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
                sort_case_insensitive = false,
                bind_to_cwd = false,
                event_handlers = {
                    {
                        event = "file_open_requested",
                        handler = function()
                            require("neo-tree.command").execute({ action = "close" })
                        end,
                    },
                },
                window = {
                    position = "left",
                    width = 40,
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    mappings = {
                        ["<space>"] = { "toggle_node", nowait = true },
                        ["l"] = "open",
                        ["<C-p>"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
                        ["<C-l>"] = "focus_preview",
                        ["<C-s>"] = "open_split",
                        ["<C-v>"] = "open_vsplit",
                        ["<C-t>"] = "open_tabnew",
                        ["<cr>"] = "open",
                        ["h"] = "close_node",
                        ["zc"] = "close_all_nodes",
                        ["zo"] = "expand_all_nodes",
                        ["a"] = { "add", config = { show_path = "relative" } },
                        ["o"] = { "add", config = { show_path = "relative" } },
                        ["A"] = { "add_directory", config = { show_path = "relative" } },
                        ["c"] = { "copy", config = { show_path = "relative" } },
                        ["m"] = { "move", config = { show_path = "relative" } },
                        ["u"] = "navigate_up",
                        ["C"] = "noop",
                        ["z"] = "noop",
                        ["s"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "s" } },
                        ["oc"] = "noop",
                        ["od"] = "noop",
                        ["og"] = "noop",
                        ["om"] = "noop",
                        ["on"] = "noop",
                        ["os"] = "noop",
                        ["ot"] = "noop",
                        ["sc"] = { "order_by_created", nowait = false },
                        ["sd"] = { "order_by_diagnostics", nowait = false },
                        ["sg"] = { "order_by_git_status", nowait = false },
                        ["sm"] = { "order_by_modified", nowait = false },
                        ["sn"] = { "order_by_name", nowait = false },
                        ["ss"] = { "order_by_size", nowait = false },
                        ["st"] = { "order_by_type", nowait = false },
                        -- ["/"] = "noop",
                        ["f"] = "noop",
                        ["D"] = "noop",
                        ["#"] = "noop",
                    },
                    fuzzy_finder_mappings = {
                        ["<down>"] = "move_cursor_down",
                        ["<C-j>"] = "move_cursor_down",
                        ["<up>"] = "move_cursor_up",
                        ["<C-k>"] = "move_cursor_up",
                        ["<esc>"] = "close",
                    },
                },
                filesystem = {
                    filtered_items = {
                        hide_by_name = { ".direnv" },
                        hide_by_pattern = { "*.meta", "*/src/*/tsconfig.json" },
                        always_show = { ".gitignored" },
                        always_show_by_pattern = { ".env*", ".gitlab*" },
                        never_show = { ".DS_Store", "thumbs.db" },
                        never_show_by_pattern = { ".null-ls_*" },
                    },
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false,
                    },
                    group_empty_dirs = true,
                    hijack_netrw_behavior = "open_default",
                    use_libuv_file_watcher = false,
                    window = {
                        mappings = {
                            [";"] = call_close,
                            ["ga"] = "git_add_file",
                            ["gs"] = "git_add_file",
                            ["gu"] = "git_unstage_file",
                            ["b"] = "noop",
                            ["i"] = call_oil,
                        },
                    },
                },
                buffers = {
                    bind_to_cwd = false,
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false,
                    },
                    group_empty_dirs = true,
                    show_unloaded = true,
                    window = {
                        mappings = {
                            [";"] = call_filesystem,
                            ["ga"] = "git_add_file",
                            ["gs"] = "git_add_file",
                            ["gu"] = "git_unstage_file",
                            ["bd"] = "noop",
                            ["a"] = "noop",
                            ["o"] = "noop",
                            ["A"] = "noop",
                            ["m"] = "noop",
                            ["b"] = "noop",
                            ["r"] = "noop",
                            ["c"] = "noop",
                            ["p"] = "noop",
                            ["x"] = "noop",
                            ["y"] = "noop",
                            ["i"] = call_oil,
                            ["d"] = function(state)
                                local node = state.tree:get_node()
                                if node then
                                    if node.type ~= "file" then
                                        return
                                    end
                                    vim.api.nvim_buf_delete(node.extra.bufnr, { force = false, unload = false })
                                    require("neo-tree.sources.manager").refresh(state.name)
                                end
                            end,
                        },
                    },
                },
            })
        end,
    },
}
