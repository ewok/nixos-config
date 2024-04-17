return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = { "Telescope" },
        init = function()
            local map = require("lib").map
            map("n", "<leader>fo",
                [[:lua require"telescope.builtin".find_files({find_command = {"rg","--ignore","--hidden","--files","--iglob","!.git","--ignore-vcs","--ignore-file","~/.config/git/gitexcludes"}})<CR>]]
                , { silent = true }, "Find files in the current workspace")
            map("n", "<leader>ff", "<CMD>Telescope live_grep<CR>", { silent = true },
                "Find string in the current workspace")
            map("n", "<leader>fh", "<CMD>Telescope oldfiles<CR>", { silent = true }, "Find telescope history")
            map("n", "<leader>f.", "<CMD>Telescope resume<CR>", { silent = true }, "Find last lookup")
            map("n", "<leader>fM", "<CMD>Telescope marks<CR>", { silent = true }, "Find marks in the current workspace")
            map("n", "<leader>fb", "<CMD>Telescope buffers<CR>", { silent = true }, "Find all buffers")
            map(
                "n",
                "<leader>f/",
                "<CMD>Telescope current_buffer_fuzzy_find<CR>",
                { silent = true },
                "Find string in current buffer"
            )
            map("n", "<leader>f:", "<cmd>Telescope command_history", { silent = true }, "Find all command history")
            map("n", "<leader>fss", "<cmd>Telescope vim_options<CR>", { silent = true }, "Settings")
            map("n", "<leader>fH", "<cmd>Telescope help_tags<CR>", { silent = true }, "Help tags")
            map("n", "<leader>fsa", "<cmd>Telescope autocommands<CR>", { silent = true }, "Autocommands")
            map("n", "<leader>fsf", "<cmd>Telescope filetypes<CR>", { silent = true }, "Filetypes")
            map("n", "<leader>fsh", "<cmd>Telescope highlights<CR>", { silent = true }, "Highlights")
            map("n", "<leader>fsk", "<cmd>Telescope keymaps<CR>", { silent = true }, "Keymaps")
            map("n", "<leader>fsc", "<cmd>Telescope colorscheme<CR>", { silent = true }, "Colorschemes")
        end,
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            local vimgrep_arguments = {
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
                os.getenv("HOME") .. "/.config/git/gitexcludes",
            }

            telescope.setup({
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                    color_devicons = true,
                    file_ignore_patterns = { "node_modules" },
                    layout_strategy = "flex",
                    set_env = { "COLORTERM", "truecolor" },
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
                            ["<c-j>"] = actions.move_selection_next,
                            ["<c-k>"] = actions.move_selection_previous,
                            ["<c-s>"] = actions.select_horizontal,
                            ["<c-v>"] = actions.select_vertical,
                            ["<c-t>"] = actions.select_tab,
                            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<c-i>"] = actions.toggle_selection + actions.move_selection_previous,
                            ["<esc>"] = actions.close,
                        },
                        n = {
                            ["<esc>"] = actions.close,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        show_all_buffers = true,
                        sort_lastused = true,
                        theme = "dropdown",
                        previewer = false,
                        mappings = {
                            i = {
                                ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                            }
                        }
                    }
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            telescope.load_extension("fzf")
            -- vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", command = "normal zx" })
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
