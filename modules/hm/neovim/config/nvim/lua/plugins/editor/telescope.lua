local lib = require("lib")
local map = lib.map
local get_existing_up_dir = lib.get_existing_up_dir
local conf = require("conf")

return {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- { "nvim-telescope/telescope-ui-select.nvim" }, -- using dressing for now
    {
        "folke/todo-comments.nvim",
        keys = {
            {
                "<leader>fd",
                function()
                    local ts = require("telescope")
                    ts.extensions["todo-comments"].todo()
                end,
                desc = "Find todo tag in the current workspace",
                mode = "n",
            },
        },
        opts = {
            keywords = {
                NOTE = { icon = conf.icons.Note, color = "#97CDFB" },
                TODO = { icon = conf.icons.Todo, color = "#B5E8E0" },
                PERF = { icon = conf.icons.Pref, color = "#F8BD96" },
                WARN = { icon = conf.icons.Warn, color = "#FAE3B0" },
                HACK = { icon = conf.icons.Hack, color = "#DDB6F2" },
                FIX = { icon = conf.icons.Fixme, color = "#DDB6F2", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        cmd = "Telescope",
        init = function()
            map(
                "n",
                "<leader>fo",
                ":lua require'telescope.builtin'.find_files({find_command = {'rg','--ignore','--hidden','--files','--iglob','!.git','--ignore-vcs','--ignore-file','~/.config/git/gitexcludes'}})<CR>",
                { silent = true },
                "Find files in the current workspace"
            )
            map(
                "n",
                "<leader>ff",
                "<CMD>Telescope live_grep<CR>",
                { silent = true },
                "Find string in the current workspace"
            )
            map(
                "n",
                "<leader>f*",
                ":Telescope live_grep default_text=<c-r>/<cr>",
                { silent = true },
                "Find string in the current workspace"
            )
            map(
                "n",
                "<leader>fc",
                ":Telescope live_grep default_text=<c-r>=expand('<cword>')<cr><cr>",
                { silent = true },
                "Find string in the current workspace"
            )
            map("n", "<leader>f.", "<CMD>Telescope resume<CR>", { silent = true }, "Find last lookup")
            map("n", "<leader>fm", "<CMD>Telescope marks<CR>", { silent = true }, "Find marks in the current workspace")
            map(
                "n",
                "<leader>f/",
                "<CMD>Telescope current_buffer_fuzzy_find<CR>",
                { silent = true },
                "Find string in current buffer"
            )
            map("n", "<leader>f:", "<cmd>Telescope command_history<cr>", { silent = true }, "Find all command history")
            map("n", "<leader>fsh", "<cmd>Telescope help_tags<CR>", { silent = true }, "Help tags")
            map("n", "<leader>fss", "<cmd>Telescope vim_options<CR>", { silent = true }, "Settings")
            map("n", "<leader>fsa", "<cmd>Telescope autocommands<CR>", { silent = true }, "Autocommands")
            map("n", "<leader>fsf", "<cmd>Telescope filetypes<CR>", { silent = true }, "Filetypes")
            map("n", "<leader>fsi", "<cmd>Telescope highlights<CR>", { silent = true }, "Highlights")
            map("n", "<leader>fsk", "<cmd>Telescope keymaps<CR>", { silent = true }, "Keymaps")
            map("n", "<leader>fsc", "<cmd>Telescope colorscheme<CR>", { silent = true }, "Colorschemes")
            map("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", { silent = true }, "Find jumps")
            map("n", "<leader>fM", "<cmd>Telescope man_pages<CR>", { silent = true }, "Find man pages")
            map("n", "<leader>fb", "<cmd>Telescope buffers initial_mode=normal<CR>", { silent = true }, "Buffers")
        end,
        config = function()
            local ts = require("telescope")
            local act = require("telescope.actions")
            ts.setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--ignore",
                        "--iglob",
                        "!.git",
                        "--ignore-vcs",
                        "--ignore-file",
                        conf.home_dir .. "/.config/git/gitexcludes",
                    },
                    color_devicons = true,
                    file_ignore_patterns = { "node_modules" },
                    layout_strategy = "flex",
                    set_env = { COLORTERM = "truecolor" },
                    layout_config = {
                        flex = {
                            height = 0.95,
                            width = 0.95,
                            flip_columns = 130,
                            prompt_position = "bottom",
                            horizontal = {
                                width = 0.99,
                                height = 0.95,
                                preview_width = 0.5,
                            },
                            vertical = {
                                width = 0.99,
                                height = 0.99,
                                preview_height = 0.7,
                            },
                        },
                    },
                    mappings = {
                        i = {
                            ["<c-j>"] = act.move_selection_next,
                            ["<c-k>"] = act.move_selection_previous,
                            ["<c-s>"] = act.select_horizontal,
                            ["<c-v>"] = act.select_vertical,
                            ["<c-t>"] = act.select_tab,
                            ["<c-q>"] = act.smart_send_to_qflist + act.open_qflist,
                            ["<c-i>"] = act.toggle_selection + act.move_selection_previous,
                            ["<esc>"] = act.close,
                        },
                        n = {
                            ["<esc>"] = act.close,
                            q = act.close,
                            l = act.select_default,
                            ["<c-s>"] = act.select_horizontal,
                            ["<c-v>"] = act.select_vertical,
                            ["<c-t>"] = act.select_tab,
                            ["/"] = function()
                                vim.cmd("startinsert")
                            end,
                            ["<c-q>"] = act.smart_send_to_qflist + act.open_qflist,
                            ["<c-i>"] = act.toggle_selection + act.move_selection_next,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        show_all_buffers = true,
                        sort_mru = true,
                        select_current = true,
                        theme = "dropdown",
                        previewer = false,
                        layout_config = { width = 0.6 },
                        -- truncate
                        path_display = { "filename_first" },
                        mappings = {
                            i = {
                                ["<c-d>"] = act.delete_buffer,
                            },
                            n = {
                                [";"] = function(bufnr)
                                    act.close(bufnr)
                                    vim.cmd("Oil")
                                    -- local mf = require("mini.files")
                                    -- mf.open(get_existing_up_dir(vim.api.nvim_buf_get_name(0)), false)
                                end,
                                dd = act.delete_buffer,
                            },
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    -- ["ui-select"] = {
                    --     require("telescope.themes").get_dropdown({}),
                    -- },
                },
            })
            ts.load_extension("fzf")
            -- ts.load_extension("ui-select")
        end,
    },
}
