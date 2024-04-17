return { {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    init = function()
        local map = require "lib".map
        local conf = require "conf"
        map("n", "-", "<CMD>Oil<CR>", {}, "Open parent directory")
        if not conf.nvim_tree then
            map("n", "<leader>fp", "<CMD>Oil<CR>", {}, "Open parent directory")
        end
    end,
    config = function()
        require "oil".setup({
            columns = {
                "icon",
                -- "permissions",
                -- "size",
                -- "mtime",
            },
            skip_confirm_for_simple_edits = true,
            win_options = {
                signcolumn = "yes:2",
                winbar = " oil://%{v:lua.string.gsub(v:lua.require('oil').get_current_dir(), v:lua.os.getenv('HOME'), '~')}",
            },
            delete_to_trash = true,
            use_default_keymaps = false,
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-s>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["q"] = "actions.close",
                ["R"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["gc"] = "actions.cd",
                ["gC"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
        })
        require("oil-git-status").setup()
    end
},
    {
        "refractalize/oil-git-status.nvim",
        config = false
    }
}
