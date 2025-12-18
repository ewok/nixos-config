local lib = require("lib")
local map = lib.map
local reg_ft = lib.reg_ft

local commit_prompt = [[
You are an expert at following the Conventional Commit specification.
commit message must:
- follow Conventional Commits
- have a goal at the end
- do not set goal if type = chore
- message structure must be:
<type>[scope]: <description>

[body with details, one per line, started with a minus sign]

[goal]

example:
fix(authentication): add password regex pattern

- `extends` key in config file is now used for extending other config files
- passwords now are following security protocol

goal: enhance security level

Given the git diff listed below, please generate a commit message for me:
```diff
%s
```
]]

return {
    {
        "ravitemer/mcphub.nvim",
        cmd = { "MCPHub" },
        init = function()
            map("n", "<leader>cm", "<cmd>MCPHub<cr>", { noremap = true }, "MCPHub")
        end,
        config = function()
            -- https://ravitemer.github.io/mcphub.nvim/configuration.html
            require("mcphub").setup({ port = 37373, use_bundled_binary = true })
        end,
        build = "bundled_build.lua",
    },
    {
        "olimorris/codecompanion.nvim",
        version = "v17.33.0",
        -- event = "InsertEnter",
        cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
        init = function()
            map({ "n", "v" }, "<Leader>cac", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
            map({ "n", "v" }, "<Leader>caa", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
            map("v", "gA", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
            map("n", "<c-g>a", ":CodeCompanion /add<cr>", { noremap = true, silent = false })
            map("v", "<c-g>a", ":'<,'>CodeCompanion /add<cr>", { noremap = true, silent = false })
            vim.cmd("cab cc CodeCompanion")
            reg_ft("gitcommit", function(ev)
                map(
                    "n",
                    "cc",
                    ":CodeCompanion /commit<cr>",
                    { noremap = true, silent = true, nowait = true, buffer = ev.buf },
                    "[gpt] Add commit"
                )
            end)
        end,
        config = function()
            require("codecompanion").setup({
                prompt_library = {
                    ["Add Prompt"] = {
                        strategy = "inline",
                        description = "Prompt the LLM from Neovim",
                        opts = {
                            index = 50,
                            is_default = true,
                            is_slash_cmd = true,
                            short_name = "add",
                            user_prompt = true,
                            placement = "add",
                            start_in_insert_mode = true,
                        },
                        prompts = {
                            {
                                role = "system",
                                content = function(context)
                                    return string.format(
                                        "I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing",
                                        context.filetype
                                    )
                                end,
                            },
                        },
                    },
                    ["Generate a Commit Message"] = {
                        strategy = "inline",
                        description = "Generate a commit message",
                        opts = {
                            index = 10,
                            is_default = true,
                            is_slash_cmd = true,
                            short_name = "commit",
                            auto_submit = true,
                            user_prompt = false,
                            placement = "before",
                        },
                        prompts = {
                            {
                                role = "user",
                                content = function()
                                    return string.format(
                                        commit_prompt,
                                        vim.fn.system("git diff --no-ext-diff --staged")
                                    )
                                end,
                                opts = { contains_code = true },
                            },
                        },
                    },
                },
                strategies = {
                    chat = { adapter = { name = "openai", model = "gpt-4o" } },
                    inline = { adapter = { name = "openai", model = "gpt-4o-mini" } },
                },
                extensions = {
                    mcphub = {
                        callback = "mcphub.extensions.codecompanion",
                        opts = { make_vars = true, make_slash_commands = true, show_result_in_chat = true },
                    },
                },
            })
        end,
    },
    {
        "github/copilot.vim",
        -- event = "VeryLazy",
        cmd = "Copilot",
        keys = {
            {
                "<leader>co",
                function()
                    vim.cmd("Copilot enable")
                    vim.schedule(function()
                        vim.cmd("Copilot status")
                    end)
                    vim.notify("Copilot Enabled", vim.log.levels.INFO, { title = "Copilot" })
                end,
                mode = "n",
                desc = "Start Copilot",
            },
            -- {
            --     "<leader>cad",
            --     function()
            --         vim.cmd("Copilot disable")
            --         vim.notify("Copilot Disabled", vim.log.levels.INFO, { title = "Copilot" })
            --     end,
            --     mode = "n",
            --     desc = "Stop Copilot",
            -- },
        },
        config = function()
            vim.g.copilot_loaded = true
        end,
        init = function()
            vim.g.copilot_no_maps = true
        end,
    },
}
