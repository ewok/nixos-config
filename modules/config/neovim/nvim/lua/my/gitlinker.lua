--
local wkmap = require'my.wk'.map
table.insert(pkgs, "ruifm/gitlinker.nvim")

local status_ok, gitlinker = pcall(require, "gitlinker")
if not status_ok then
  print("Gitlinker is not loaded!")
  return
end

gitlinker.setup({
  opts = {
    callbacks = {
      ["gitlab.diskarte.net"] = require("gitlinker.hosts").get_gitlab_type_url,
    },
    -- remote = 'github', -- force the use of a specific remote
    -- adds current line nr in the url for normal mode
    add_current_line_on_normal_mode = true,
    -- callback for what to do with the url
    action_callback = require("gitlinker.actions").open_in_browser,
    -- print the url after performing the action
    print_url = true,
    -- mapping to call url generation
    mappings = nil,
  },
})

wkmap({
  ['<leader>gg'] = { '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', "Browse" }
}, { mode = 'n', silent = true })

wkmap({
  ['<leader>gg'] = { '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', "Browse" }
}, { mode = 'v', })
