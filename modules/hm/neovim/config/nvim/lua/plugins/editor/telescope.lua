local lib = require("lib")
local map = lib.map
local conf = require("conf")

return {
    {
        "allaman/emoji.nvim",
        keys = {
            {
                "<leader>fe",
                ":Telescope emoji theme=cursor<CR>",
                mode = "n",
                desc = "Emoji",
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        keys = {
            {
                "<leader>fd",
                "<cmd>Telescope todo-comments theme=dropdown<cr>",
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
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" }, -- using dressing for now
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        cmd = "Telescope",
        init = function()
            map(
                "n",
                "<leader>fo",
                "<CMD>Telescope find_files<CR>",
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
            map(
                "n",
                "<leader>fm",
                "<CMD>Telescope marks theme=dropdown<CR>",
                { silent = true },
                "Find marks in the current workspace"
            )
            map(
                "n",
                "<leader>/",
                "<CMD>Telescope current_buffer_fuzzy_find theme=ivy previewer=false<CR>",
                { silent = true },
                "Find string in current buffer"
            )
            map(
                "c",
                "<c-r>",
                '<cmd>Telescope command_history theme=ivy sorting_strategy=descending layout_config={"prompt_position":"bottom"}<cr>',
                { silent = true },
                "Find all command history"
            )
            map("n", "<leader>fsh", "<cmd>Telescope help_tags<CR>", { silent = true }, "Help tags")
            map("n", "<leader>fss", "<cmd>Telescope vim_options<CR>", { silent = true }, "Settings")
            map("n", "<leader>fsa", "<cmd>Telescope autocommands<CR>", { silent = true }, "Autocommands")
            map("n", "<leader>fsf", "<cmd>Telescope filetypes<CR>", { silent = true }, "Filetypes")
            map("n", "<leader>fsi", "<cmd>Telescope highlights<CR>", { silent = true }, "Highlights")
            map("n", "<leader>fsk", "<cmd>Telescope keymaps<CR>", { silent = true }, "Keymaps")
            map("n", "<leader>fsc", "<cmd>Telescope colorscheme<CR>", { silent = true }, "Colorschemes")
            map("n", "<leader>fj", "<cmd>Telescope jumplist theme=dropdown<CR>", { silent = true }, "Find jumps")
            map("n", "<leader>fb", "<cmd>Telescope buffers theme=dropdown<CR>", { silent = true }, "Buffers")
            if conf.packages.neotree == false then
                map("n", ";", function()
                    require("lib.telescope_buffers_tree").open({
                        theme = "dropdown",
                        theme_opts = {
                            layout_config = {
                                -- width = 80,
                                height = function(_, _, max_lines)
                                    local percentage = 0.4
                                    local min = 40
                                    return math.max(math.floor(percentage * max_lines), min)
                                end,
                                width = function(_, max_columns)
                                    local percentage = 0.2
                                    local min = 60
                                    return math.max(math.floor(percentage * max_columns), min)
                                end,
                            },
                        },
                        action_key = ";",
                        action = function()
                            if conf.packages.oil then
                                vim.cmd("Oil")
                                return
                            end
                            if conf.packages.fyler then
                                vim.cmd("Fyler")
                                return
                            end
                        end,
                    })
                end, { silent = true }, "Buffers")
            end
        end,
        config = function()
            local ts = require("telescope")
            local act = require("telescope.actions")

            local telescope_narrow_matches = function(bufnr)
                local builtin = require("telescope.builtin")
                local actions_state = require("telescope.actions.state")
                local map_entries = require("telescope.actions.utils").map_entries
                local matches = {}

                if actions_state.get_current_picker(bufnr).prompt_title ~= "Live Grep" then
                    map_entries(bufnr, function(entry)
                        table.insert(matches, entry[0] or entry[1])
                    end)
                    builtin.live_grep({ search_dirs = matches })
                else
                    map_entries(bufnr, function(entry)
                        table.insert(matches, entry.filename)
                    end)
                    matches = vim.fn.uniq(vim.fn.sort(matches)) -- Remove duplicates
                    builtin.find_files({ search_dirs = matches })
                end
            end

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
                            ["<C-f>"] = telescope_narrow_matches,
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
                    find_files = {
                        find_command = {
                            "rg",
                            "--ignore",
                            "--hidden",
                            "--files",
                            "--iglob",
                            "!.git",
                            "--ignore-vcs",
                            "--ignore-file",
                            "~/.config/git/gitexcludes",
                        },
                    },
                    buffers = {
                        sort_buffers = function(bufnr_a, bufnr_b)
                            local name_a = vim.api.nvim_buf_get_name(bufnr_a)
                            local name_b = vim.api.nvim_buf_get_name(bufnr_b)

                            -- Empty buffers go last
                            if name_a == "" then
                                return false
                            end
                            if name_b == "" then
                                return true
                            end

                            local cwd = vim.loop.cwd() or ""

                            -- Make paths relative to CWD if possible
                            local rel_a = name_a:gsub("^" .. vim.pesc(cwd) .. "/", "")
                            local rel_b = name_b:gsub("^" .. vim.pesc(cwd) .. "/", "")

                            -- Count depth (number of directory separators)

                            local depth_a = select(2, rel_a:gsub("/", ""))
                            local depth_b = select(2, rel_b:gsub("/", ""))

                            -- Prioritize files in current directory (depth 0)
                            if depth_a ~= depth_b then
                                return depth_a < depth_b
                            end

                            -- Sort alphabetically
                            return rel_a < rel_b
                        end,
                        sort_mru = false,

                        show_all_buffers = true,
                        select_current = true,
                        theme = "dropdown",
                        initial_mode = "normal",
                        previewer = false,
                        -- layout_config = {
                        --     -- width = 80,
                        --     height = 0.9,
                        --     width = function(_, max_columns)
                        --         local percentage = 0.5
                        --         local min = 80
                        --         return math.max(math.floor(percentage * max_columns), min)
                        --     end,
                        -- },
                        -- path_display = { "truncate" },
                        -- path_display = { "smart" },
                        -- path_display = { "filename_first" },
                        path_display = function(_, path)
                            local tail = require("telescope.utils").path_tail(path)
                            return string.format("%s (%s)", tail, path)
                        end,
                        mappings = {
                            i = {
                                ["<c-d>"] = act.delete_buffer,
                            },
                            n = {
                                [";"] = function(bufnr)
                                    act.close(bufnr)
                                    if conf.packages.oil then
                                        vim.cmd("Oil")
                                        return
                                    end
                                    if conf.packages.fyler then
                                        vim.cmd("Fyler")
                                        return
                                    end
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
                        case_mode = "ignore_case",
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            ts.load_extension("fzf")
            ts.load_extension("ui-select")
        end,
    },
}
