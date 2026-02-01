local map = require("lib").map

return {
    {
        "Saecki/crates.nvim",
        ft = { "rust", "toml" },
        opts = {
        },
        config = function(_, opts)
            local crates = require("crates")
            crates.setup(opts)

            local m = function(lhs, rhs, desc)
                map("n", lhs, rhs, { silent = true, noremap = true }, desc)
            end

            m("<leader>rc", crates.show_popup, "Crates: popup")
            m("<leader>ru", crates.update_crate, "Crates: update")
            m("<leader>rU", crates.update_all_crates, "Crates: update all")
            m("<leader>rv", crates.show_versions_popup, "Crates: versions")
        end,
    },
}
