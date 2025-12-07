local conf = require("conf")

return {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function()
        local npairs = require("nvim-autopairs")
        npairs.setup({
            disable_filetype = { "TelescopePrompt", "clojure", "fennel", "markdown" },
            disable_in_macro = true,
            disable_in_visualblock = true,
            disable_in_replace_mode = true,
            enable_moveright = true,
            enable_check_bracket_line = false,
            check_ts = true,
            map_bs = true,
            map_c_h = true,
            map_c_w = true,
        })
        npairs.get_rule("'")[1].not_filetypes = conf.lisp_langs
    end,
}
