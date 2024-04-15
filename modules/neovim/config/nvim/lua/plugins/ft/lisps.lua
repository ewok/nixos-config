return {
    {

        "Olical/conjure",
        ft = { "python", "clojure", "fennel", "lua" },
        config = function()
            vim.g["conjure#mapping#prefix"] = "<leader>c"
            vim.g["conjure#mapping#def_word"] = "g"
            vim.g["conjure#mapping#doc_word"] = "h"
        end,
    },
    {
        "guns/vim-sexp",
        ft = { "python", "clojure", "fennel", "lua" },
        init = function()
            vim.g.sexp_filetypes = table.concat(require("conf").lisp_langs, ",")
            vim.g.sexp_mappings = {
                sexp_outer_list = "af",
                sexp_inner_list = "if",
                sexp_outer_top_list = "aF",
                sexp_inner_top_list = "iF",
                sexp_outer_string = "as",
                sexp_inner_string = "is",
                sexp_outer_element = "ae",
                sexp_inner_element = "ie",
                sexp_move_to_prev_bracket = "[[",
                sexp_move_to_next_bracket = "]]",
                sexp_move_to_prev_element_head = "B",
                sexp_move_to_next_element_head = "W",
                sexp_move_to_prev_element_tail = "gE",
                sexp_move_to_next_element_tail = "E",
                sexp_round_head_wrap_list = "<(",
                sexp_round_tail_wrap_list = ">)",
                sexp_square_head_wrap_list = "<[",
                sexp_square_tail_wrap_list = ">]",
                sexp_curly_head_wrap_list = "<{",
                sexp_curly_tail_wrap_list = "}",
                sexp_round_head_wrap_element = "<W(",
                sexp_round_tail_wrap_element = ">W)",
                sexp_square_head_wrap_element = "<W[",
                sexp_square_tail_wrap_element = ">W]",
                sexp_curly_head_wrap_element = "<W{",
                sexp_curly_tail_wrap_element = ">W}",
                sexp_insert_at_list_head = "<I",
                sexp_insert_at_list_tail = ">I",
                sexp_splice_list = "dsf",
                sexp_convolute = "<?",
                sexp_raise_list = "<rf",
                sexp_raise_element = "<re",
                sexp_swap_list_backward = "<F",
                sexp_swap_list_forward = ">F",
                sexp_swap_element_backward = "<E",
                sexp_swap_element_forward = ">E",
                sexp_emit_head_element = "-(",
                sexp_emit_tail_element = "-)",
                sexp_capture_prev_element = "+(",
                sexp_capture_next_element = "+)",
            }
        end,
        config = function()
            local map = require("lib").map
            local reg_ft = require("lib").reg_ft

            for _, x in ipairs(require("conf").lisp_langs) do
                reg_ft(x, function()
                    map("n", "m", "<cmd>WhichKey m<cr>", { buffer = true }, "Menu")
                    map("n", "mh", function()
                        local hydra = require("hydra")
                        hydra({
                            name = "Move (",
                            config = {
                                hint = {
                                    type = "statusline",
                                },
                            },
                            mode = "n", -- assuming normal mode, change to 'i', 'v', etc. as necessary
                            heads = {
                                { "h", "<Plug>(sexp_capture_prev_element)", { desc = "left" } },
                                { "l", "<Plug>(sexp_emit_head_element)", { desc = "right" } },
                                { "q", nil, { exit = true } },
                            },
                        }):activate()
                    end, { buffer = true }, "Move (")
                    map("n", "ml", function()
                        local hydra = require("hydra")
                        hydra({
                            name = "Move",
                            config = {
                                hint = { type = "statusline" },
                            },
                            heads = {
                                { "h", "<Plug>(sexp_emit_tail_element)", { desc = "left" } },
                                { "l", "<Plug>(sexp_capture_next_element)", { desc = "right" } },
                                { "q", nil, { exit = true } },
                            },
                        }):activate()
                    end, { buffer = true }, "Move )")
                    map("n", "me", function()
                        local hydra = require("hydra")
                        hydra({
                            name = "Move Element",
                            config = { hint = { type = "statusline" } },
                            heads = {
                                { "h", "<Plug>(sexp_swap_element_backward)", { desc = "left" } },
                                { "l", "<Plug>(sexp_swap_element_forward)", { desc = "right" } },
                                { "r", "<Plug>(sexp_raise_element)", { desc = "raise" } },
                                { "q", nil, { exit = true } },
                            },
                        }):activate()
                    end, { buffer = true }, "Move Element")
                    map("n", "mf", function()
                        local hydra = require("hydra")
                        hydra({
                            name = "Move Form",
                            config = { hint = { type = "statusline" } },
                            heads = {
                                { "h", "<Plug>(sexp_swap_list_backward)", { desc = "left" } },
                                { "l", "<Plug>(sexp_swap_list_forward)", { desc = "right" } },
                                { "r", "<Plug>(sexp_raise_list)", { desc = "raise" } },
                                { "q", nil, { exit = true } },
                            },
                        }):activate()
                    end, { buffer = true }, "Move Form")
                end)
            end
        end,
    },
}
