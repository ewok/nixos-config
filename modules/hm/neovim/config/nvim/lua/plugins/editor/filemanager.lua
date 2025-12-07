local lib = require("lib")
local map, umap = lib.map, lib.umap
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
                vim.o.number = false

                map("n", "<C-t>", function()
                    vim.cmd("tab split")
                    oil.select()
                end, { buffer = ev.buf }, "Open in Tab")

                map("n", "w", "<cmd>w<cr>", { buffer = ev.buf })

                vim.api.nvim_create_autocmd("BufEnter", {
                    buffer = ev.buf,
                    callback = function()
                        map("n", "h", act.parent.callback, { buffer = ev.buf }, "Go to Parent Directory")
                        map("n", "l", act.select.callback, { buffer = ev.buf }, "select entry")
                    end,
                })

                vim.api.nvim_create_autocmd("InsertEnter", {
                    buffer = ev.buf,
                    callback = function()
                        umap("n", "h", { buffer = ev.buf })
                        umap("n", "l", { buffer = ev.buf })
                        vim.notify("Disabled h/l in oil buffer to prevent accidental navigation")
                    end,
                })
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
                    ["<CR>"] = "actions.select",
                    -- ["l"] = "actions.select",
                    ["<C-v>"] = "actions.select_vsplit",
                    ["<C-s>"] = "actions.select_split",
                    ["<C-p>"] = "actions.preview",
                    -- ["h"] = "actions.parent",
                    -- ["u"] = "actions.parent",
                    ["q"] = "actions.close",
                    ["<Esc>"] = "actions.close",
                    [";"] = "actions.close",
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
}
