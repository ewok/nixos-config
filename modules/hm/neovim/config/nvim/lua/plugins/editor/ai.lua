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

run "git diff --no-ext-diff --staged" to get the diff.

write only the commit message, do not include anything else.
]]
-- %s

return {
    -- {
    --     "olimorris/codecompanion.nvim",
    --     -- version = "v17.33.0",
    --     cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    --     dependencies = {
    --         {
    --             "ravitemer/mcphub.nvim",
    --             cmd = { "MCPHub" },
    --             init = function()
    --                 map("n", "<leader>cm", "<cmd>MCPHub<cr>", { noremap = true }, "MCPHub")
    --             end,
    --             config = function()
    --                 -- https://ravitemer.github.io/mcphub.nvim/configuration.html
    --                 require("mcphub").setup({ port = 37373, use_bundled_binary = true })
    --             end,
    --             build = "bundled_build.lua",
    --         },
    --     },
    --     init = function()
    --         map({ "n", "v" }, "<Leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    --         map({ "n", "v" }, "<Leader>ac", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    --         map("v", "gA", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    --         -- map("n", "<c-g>a", ":CodeCompanion /myadd<cr>", { noremap = true, silent = false })
    --         -- map("v", "<c-g>a", ":'<,'>CodeCompanion /myadd<cr>", { noremap = true, silent = false })
    --         vim.cmd("cab cc CodeCompanion")
    --         reg_ft("gitcommit", function(ev)
    --             map(
    --                 "n",
    --                 "cc",
    --                 ":CodeCompanion /mycommit<cr>",
    --                 { noremap = true, silent = true, nowait = true, buffer = ev.buf },
    --                 "[gpt] Add commit"
    --             )
    --         end)
    --     end,
    --
    --     config = function()
    --         require("codecompanion").setup({
    --             prompt_library = {
    --                 ["Add Prompt"] = {
    --                     interaction = "inline",
    --                     description = "Prompt the LLM from Neovim",
    --                     opts = {
    --                         is_slash_cmd = true,
    --                         alias = "myadd",
    --                         user_prompt = true,
    --                         placement = "add",
    --                         -- modes = { "n", "v" },
    --                     },
    --                     prompts = {
    --                         {
    --                             role = "system",
    --                             content = function(context)
    --                                 return string.format(
    --                                     "I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing",
    --                                     context.filetype
    --                                 )
    --                             end,
    --                         },
    --                     },
    --                 },
    --                 ["Generate a Commit Message"] = {
    --                     interaction = "inline",
    --                     description = "Generate a commit message",
    --                     opts = {
    --                         is_slash_cmd = true,
    --                         alias = "mycommit",
    --                         auto_submit = true,
    --                         user_prompt = false,
    --                         placement = "before",
    --                     },
    --                     prompts = {
    --                         {
    --                             role = "user",
    --                             content = function()
    --                                 return string.format(
    --                                     commit_prompt,
    --                                     vim.fn.system("git diff --no-ext-diff --staged")
    --                                 )
    --                             end,
    --                             opts = { contains_code = true },
    --                         },
    --                     },
    --                 },
    --             },
    --             display = {
    --                 chat = {
    --                     show_token_count = true,
    --                 },
    --             },
    --             interactions = {
    --                 chat = {
    --                     adapter = { name = "copilot", model = "claude-sonnet-4" },
    --                     keymaps = {
    --                         send = {
    --                             modes = { n = "<C-s>", i = "<C-s>" },
    --                             opts = {},
    --                         },
    --                         close = {
    --                             modes = { n = "q", i = "<C-w>q" },
    --                             opts = {},
    --                         },
    --                     },
    --                 },
    --                 inline = { adapter = { name = "copilot", model = "gpt-5.1-codex-mini" } },
    --             },
    --             extensions = {
    --                 mcphub = {
    --                     callback = "mcphub.extensions.codecompanion",
    --                     opts = { make_vars = true, make_slash_commands = true, show_result_in_chat = true },
    --                 },
    --             },
    --         })
    --     end,
    -- },
    {
        "github/copilot.vim",
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
    -- {
    --     "zbirenbaum/copilot.lua",
    --     -- dependencies = {
    --     --     "copilotlsp-nvim/copilot-lsp",
    --     -- },
    --     keys = {
    --         {
    --             "<leader>co",
    --             function()
    --                 vim.schedule(function()
    --                     vim.cmd("Copilot status")
    --                 end)
    --                 vim.notify("Copilot Enabled", vim.log.levels.INFO, { title = "Copilot" })
    --             end,
    --             mode = "n",
    --             desc = "Start Copilot",
    --         },
    --     },
    --     cmd = "Copilot",
    --     config = function()
    --         require("copilot").setup({
    --             suggestion = {
    --                 enabled = true,
    --                 auto_trigger = true,
    --                 hide_during_completion = true,
    --                 debounce = 75,
    --                 trigger_on_accept = true,
    --                 keymap = {
    --                     accept = "<C-l>",
    --                     accept_word = false,
    --                     accept_line = false,
    --                     next = "<C-j>",
    --                     prev = "<C-k>",
    --                     dismiss = "<C-h>",
    --                 },
    --             },
    --             nes = {
    --                 enabled = false,
    --                 auto_trigger = true,
    --                 keymap = {
    --                     accept_and_goto = false,
    --                     accept = false,
    --                     dismiss = false,
    --                 },
    --             },
    --             copilot_model = "gpt-5.1-codex-mini",
    --         })
    --         vim.g.copilot_loaded = true
    --     end,
    -- },
    {
        "folke/sidekick.nvim",
        opts = {
            nes = { enabled = false },
            cli = {
                mux = {
                    enabled = true,
                    backend = "tmux",
                },
                prompts = {
                    commit = commit_prompt,
                },
                win = {
                    keys = {
                        buffers = { "<c-b>", "buffers", mode = "nt", desc = "open buffer picker" },
                        files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
                        prompt = { "<nop>", "prompt", mode = "t", desc = "insert prompt or context" },
                        stopinsert = { "<c-c>", "stopinsert", mode = "t", desc = "enter normal mode" },
                        hide_n = { "q", "hide", mode = "n", desc = "hide the terminal window" },
                        hide_t = { "<c-q>", "hide", mode = "t", desc = "hide the terminal window" },
                        hide_tab = { "<tab>", "hide", mode = "t", desc = "hide the terminal window" },
                        nav_left = { "<c-h>", "nav_left", expr = true, desc = "navigate to the left window" },
                        nav_down = { "<c-j>", "nav_down", expr = true, desc = "navigate to the below window" },
                        nav_up = { "<c-k>", "nav_up", expr = true, desc = "navigate to the above window" },
                        nav_right = { "<c-l>", "nav_right", expr = true, desc = "navigate to the right window" },
                    },
                },
            },
        },
        keys = {
            {
                "<tab>",
                function()
                    -- if #require("sidekick.status").cli() > 0 then
                        require("sidekick.cli").toggle({ filter = { installed = true } })
                    -- end
                    -- return "<Tab>" -- fallback to normal tab
                end,
                -- expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle({ filter = { installed = true } })
                end,
                desc = "Sidekick Toggle CLI",
            },
            {
                "<leader>as",
                function()
                    -- require("sidekick.cli").select()
                    require("sidekick.cli").select({ filter = { installed = true } })
                end,
                desc = "Select CLI",
            },
            {
                "<leader>ad",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "Detach a CLI Session",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}", filter = { installed = true } })
                end,
                mode = { "x", "n" },
                desc = "Send This",
            },
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}", filter = { installed = true } })
                end,
                desc = "Send File",
            },
            {
                "<leader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}", filter = { installed = true } })
                end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt({ filter = { installed = true } })
                end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
            {
                "<leader>ao",
                function()
                    require("sidekick.cli").toggle({ name = "opencode", focus = true })
                end,
                desc = "Sidekick Toggle Opencode",
            },
        },
    },
}
