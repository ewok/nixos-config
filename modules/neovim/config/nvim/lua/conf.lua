local path_join = require("lib").path_join

local M = {}

M.is_nix = "{{ is_nix }}" == "true" and true or false

M.home_dir = os.getenv("HOME")
M.data_dir = vim.fn.stdpath("data")
M.config_dir = vim.fn.stdpath("config")
M.cache_dir = vim.fn.stdpath("cache")
M.notes_dir = path_join(M.home_dir, "Notes")

M.options = {
    transparent = true,
    float_border = true,
    download_source = "https://github.com/",
    snippets_directory = path_join(M.config_dir, "snippets"),
    auto_save = true,
    auto_switch_input = false,
    auto_restore_cursor_position = true,
    auto_remove_new_lines_comment = true,
    auto_toggle_rnu = true,
    auto_hide_cursorline = true,
    rainbow_parents = false,
    theme = M.is_nix and "{{ conf.theme.name }}" or "onedark",
    light_theme = M.is_nix and "{{ conf.theme.light_name }}" or "onedark",
    spelllang = { "nospell", "en_us", "ru_ru" },
    large_file_size = 1024 * 1024 * 20,
    direnv = false,
    nvim_tree = false,
    -- possible to use list of filetypes
    treesitter_nvim_highlighting = false,
    undotree = false,
    pbclip = "{{ conf.orb }}" == "true" and true or false,
}

M.separator = M.is_nix
        and {
            left = "{{ conf.theme.separator_left }}",
            right = "{{ conf.theme.separator_right }}",
            alt_left = "{{ conf.theme.alt_separator_left }}",
            alt_right = "{{ conf.theme.alt_separator_right }}",
        }
    or {
        right = "",
        left = "",
        alt_right = "",
        alt_left = "",
    }

M.colors = M.is_nix
        and {
            base00 = "#{{ conf.colors.base00 }}",
            base01 = "#{{ conf.colors.base01 }}",
            base02 = "#{{ conf.colors.base02 }}",
            base03 = "#{{ conf.colors.base03 }}",
            base04 = "#{{ conf.colors.base04 }}",
            base05 = "#{{ conf.colors.base05 }}",
            base06 = "#{{ conf.colors.base06 }}",
            base07 = "#{{ conf.colors.base07 }}",
            base08 = "#{{ conf.colors.base08 }}",
            base09 = "#{{ conf.colors.base09 }}",
            base0A = "#{{ conf.colors.base0A }}",
            base0B = "#{{ conf.colors.base0B }}",
            base0C = "#{{ conf.colors.base0C }}",
            base0D = "#{{ conf.colors.base0D }}",
            base0E = "#{{ conf.colors.base0E }}",
            base0F = "#{{ conf.colors.base0F }}",
        }
    or {
        base00 = "#282c34",
        base01 = "#353b45",
        base02 = "#3e4451",
        base03 = "#545862",
        base04 = "#565c64",
        base05 = "#abb2bf",
        base06 = "#b6bdca",
        base07 = "#c8ccd4",
        base08 = "#e06c75",
        base09 = "#d19a66",
        base0A = "#e5c07b",
        base0B = "#98c379",
        base0C = "#56b6c2",
        base0D = "#61afef",
        base0E = "#c678dd",
        base0F = "#be5046",
    }

M.icons = {}

-- Platforms
M.icons.platform = { unix = "", dos = "", mac = "" }

-- Diagnostics
M.icons.diagnostic = { Error = "", Warn = "", Info = "", Hint = "" }

-- Tag level
M.icons.tag_level = {
    Fixme = "☠",
    Hack = "✄",
    Warn = "☢",
    Note = "✐",
    Todo = "✓",
    Perf = "↻",
}

-- ;; Linux
-- ;; (tset icons :tag_level {:Fixme "ﰡ"
-- ;;                         :Hack "ﰠ"
-- ;;                         :Warn ""
-- ;;                         :Note "ﮉ"
-- ;;                         :Todo "ﮉ"
-- ;;                         :Perf "ﮉ"})
--
-- ;; MacOs
-- (tset icons :lsp_kind {:Array ""
--                        :Boolean "◩"
--                        :Class ""
--                        :Color ""
--                        :Constant ""
--                        :Constructor ""
--                        :Enum ""
--                        :EnumMember ""
--                        :Event ""
--                        :Field ""
--                        :File ""
--                        :Folder ""
--                        :Function "󰊕"
--                        :Interface ""
--                        :Key "󰌋"
--                        :Keyword ""
--                        :Method "󰆧"
--                        :Module ""
--                        :Namespace ""
--                        :Null :0
--                        :Number ""
--                        :Object ""
--                        :Operator ""
--                        :Property ""
--                        :Reference ""
--                        :Snippet ""
--                        :String "󰉿"
--                        :Struct ""
--                        :Text ""
--                        :TypeParameter ""
--                        :Unit ""
--                        :Value ""
--                        :Variable ""})
--
-- (tset icons :wk {:breadcrumb " " :separator " " :group " "})
--
M.icons.lsp_kind = {
    Array = "󰅪",
    Boolean = "◩",
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "󰊕",
    Interface = "",
    Key = "󰌋",
    Keyword = "",
    Method = "󰆧",
    Module = "",
    -- Namespace = "",
    Namespace = "",
    Null = "0",
    Number = "",
    Object = "",
    Operator = "",
    Package = "",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "󰉿",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "",
}

M.icons.wk = {
    breadcrumb = " ",
    separator = " ",
    group = " ",
}

M.icons.source = {
    buffer = "",
    calc = "",
    cmdline = "",
    codeium = "",
    nvim_lsp = "",
    path = "",
    snippy = "",
}

M.in_tmux = os.getenv("TMUX") ~= nil

M.lisp_langs = { "clojure", "common-lisp", "emacs-lisp", "lisp", "scheme", "timl", "edn", "fennel" }

M.ui_ft = {
    "aerial",
    "gitcommit",
    "dbui",
    "help",
    "lspinfo",
    "lsp-installer",
    "notify",
    "NvimTree",
    "NvimTree_*",
    "packer",
    "spectre_panel",
    "startuptime",
    "TelescopePrompt",
    "TelescopeResults",
    "terminal",
    "toggleterm",
    "undotree",
    "mind",
}
--
M.openai_token = M.is_nix and "{{ conf.openai_token }}" or ""

return M
