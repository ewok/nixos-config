return require "conf".nvim_tree and {
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        init = function()
            local map = require("lib").map
            local toggle_sidebar = require("lib").toggle_sidebar
            map("n", "<leader>1", function()
                toggle_sidebar("NvimTree")
                vim.cmd("NvimTreeToggle")
            end, { noremap = true, silent = true }, "Open File Explorer")
            map("n", "<leader>fp", function()
                toggle_sidebar("NvimTree")
                vim.cmd("NvimTreeFocus")
            end, { noremap = true, silent = false }, "Find the current file and open it in file explorer")
        end,
        config = function()
            local conf = require("conf")
            local nvim_tree = require("nvim-tree")
            local api = require("nvim-tree.api")
            local map = require("lib").map

            local function on_attach(bufnr)
                local md = { buffer = bufnr, noremap = true, silent = true, nowait = true }
                map("n", "<CR>", api.node.open.edit, md, "Open")
                map("n", "o", api.node.open.edit, md, "Open")
                map("n", "l", api.node.open.edit, md, "Open")
                map("n", "<C-]>", api.tree.change_root_to_node, md, "CD")
                map("n", "C", api.tree.change_root_to_node, md, "CD")
                map("n", "v", api.node.open.vertical, md, "Open: Vertical Split")
                map("n", "s", api.node.open.horizontal, md, "Open: Horizontal Split")
                map("n", "t", api.node.open.tab, md, "Open: New Tab")
                map("n", "h", api.node.navigate.parent_close, md, "Close Directory")
                map("n", "<Tab>", api.node.open.preview, md, "Open Preview")
                map("n", "I", api.tree.toggle_gitignore_filter, md, "Toggle Git Ignore")
                map("n", "H", api.tree.toggle_hidden_filter, md, "Toggle Dotfiles")
                map("n", "r", api.tree.reload, md, "Refresh")
                map("n", "R", api.tree.reload, md, "Refresh")
                map("n", "a", api.fs.create, md, "Create")
                map("n", "d", api.fs.remove, md, "Delete")
                map("n", "m", api.fs.rename, md, "Rename")
                map("n", "M", api.fs.rename_sub, md, "Rename: Omit Filename")
                map("n", "x", api.fs.cut, md, "Cut")
                map("n", "c", api.fs.copy.node, md, "Copy")
                map("n", "p", api.fs.paste, md, "Paste")
                map("n", "[g", api.node.navigate.git.prev, md, "Prev Git")
                map("n", "[g", api.node.navigate.git.next, md, "Next Git")
                map("n", "u", api.tree.change_root_to_parent, md, "Up")
                map("n", "q", api.tree.close, md, "Close")
            end
            nvim_tree.setup({
                on_attach = on_attach,
                open_on_tab = false,
                disable_netrw = false,
                hijack_netrw = false,
                hijack_cursor = true,
                sync_root_with_cwd = false,
                reload_on_bufenter = true,
                update_focused_file = {
                    enable = true,
                },
                system_open = {
                    cmd = nil,
                    args = {},
                },
                view = {
                    side = "left",
                    width = 40,
                    signcolumn = "yes",
                    float = {
                        enable = false,
                        quit_on_focus_loss = false,
                        open_win_config = function()
                            local min = 30
                            local max = 50
                            local width_ratio = 0.3
                            local win_w = vim.api.nvim_win_get_width(0)
                            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                            local window_w = (function()
                                local _win_w = math.floor(win_w * width_ratio)
                                return _win_w > max and max or _win_w < min and min or _win_w
                            end)()
                            local window_h = math.floor(screen_h * 0.9)
                            return {
                                border = "rounded",
                                relative = "win",
                                col = win_w,
                                row = 1,
                                width = window_w,
                                height = window_h,
                                focusable = false,
                                anchor = "NE",
                            }
                        end,
                    },
                },
                diagnostics = {
                    enable = true,
                    show_on_dirs = true,
                    icons = {
                        hint = conf.icons.Hint,
                        info = conf.icons.Info,
                        warning = conf.icons.Warn,
                        error = conf.icons.Error,
                    },
                },
                actions = {
                    use_system_clipboard = true,
                    change_dir = {
                        enable = true,
                        global = true,
                        restrict_above_cwd = false,
                    },
                    open_file = {
                        resize_window = true,
                        quit_on_open = true,
                        window_picker = {
                            enable = false,
                        },
                    },
                },
                trash = {
                    cmd = "trash",
                    require_confirm = true,
                },
                filters = {
                    dotfiles = false,
                    custom = { "node_modules", "\\.cache", "__pycache__" },
                    exclude = {},
                },
                renderer = {
                    add_trailing = true,
                    group_empty = true,
                    highlight_git = true,
                    highlight_opened_files = "none",
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
            })
        end,
    }
    or {}
