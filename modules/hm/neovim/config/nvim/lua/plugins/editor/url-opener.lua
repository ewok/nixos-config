local lib = require("lib")
local reg_ft, map = lib.reg_ft, lib.map

return {
    {
        "ruifm/gitlinker.nvim",
        opts = {
            opts = { print_url = false },
            mappings = nil,
        },
    },
    {
        "chrishrb/gx.nvim",
        keys = {
            { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } },
        },
        cmd = { "Browse" },
        init = function()
            vim.g.netrw_nogx = 1
        end,
        opts = {
            handler_options = {
                select_for_search = true,
            },
            handlers = {
                plugin = true,
                github = true,
                brewfile = false,
                package_json = true,
                search = true,
                go = true,
                gitlinker = {
                    name = "gitlinker",
                    handle = function(mode, _, _)
                        local linker = require("gitlinker")
                        mode = mode == "n" and "n" or "v"
                        linker.get_buf_range_url(mode, { silent = true })
                    end,
                },
                tf = {
                    name = "tf",
                    filetype = { "terraform" },
                    handle = function(mode, line, _)
                        local helper = require("gx.helper")
                        local atype = helper.find(line, mode, "(%w+) ")
                        if atype == "resource" or atype == "data" then
                            local provider = helper.find(line, mode, '%w+ "(%w+)_.*" ')
                            local resource = helper.find(line, mode, 'resource "%w+_([a-zA-Z_]+)" ')
                            local data = helper.find(line, mode, 'data "%w+_([a-zA-Z_]+)" ')
                            local url = provider == "aws"
                                    and "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/" .. (resource and "resources/" .. resource or data and "data-sources/" .. data)
                                or provider == "terraform" and "https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/" .. (resource and "resources/" .. resource or data and "data-sources/" .. data)
                                or provider == "gitlab" and "https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/" .. (resource and "resources/" .. resource or data and "data-sources/" .. data)
                                or provider == "databricks" and "https://registry.terraform.io/providers/databricks/databricks/latest/docs/" .. (resource and "resources/" .. resource or data and "data-sources/" .. data)
                                or nil
                            return url
                        end
                    end,
                },
            },
        },
    },
}
