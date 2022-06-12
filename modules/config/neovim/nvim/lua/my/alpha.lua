local icons = require "my.icons"

table.insert(pkgs, "goolord/alpha-nvim")
local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  print("Alpha is not loaded.")
  return
end

local dashboard = require "alpha.themes.dashboard"
dashboard.section.header.val = {
  [[                    | |  ( )                (_)]],
  [[   _____      _____ | | _|/ ___   _ ____   ___ _ __ ___]],
  [[  / _ \ \ /\ / / _ \| |/ / / __| | '_ \ \ / / | '_ ` _ \]],
  [[ |  __/\ V  V / (_) |   <  \__ \ | | | \ V /| | | | | | |]],
  [[  \___| \_/\_/ \___/|_|\_\ |___/ |_| |_|\_/ |_|_| |_| |_|]],
}
dashboard.section.buttons.val = {
  dashboard.button("f", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
  dashboard.button("e", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button(
    "p",
    icons.git.Repo .. " Find project",
    ":lua require('telescope').extensions.projects.projects()<CR>"
  ),
  dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
  dashboard.button("s", icons.ui.SignIn .. " Find Session", ":Telescope sessions save_current=false <CR>"),
  dashboard.button("q", icons.diagnostics.Error .. " Quit", ":qa<CR>"),
}

dashboard.section.buttons.opts.hl = "Keyword"
dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
