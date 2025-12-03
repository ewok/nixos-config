local lib = require("lib")
local map = lib.map

return {
    "nvim-mini/mini.files",
    version = "*",
    dependencies = { "nvim-mini/mini.icons" },
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
}
