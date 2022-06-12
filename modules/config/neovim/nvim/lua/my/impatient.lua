--
table.insert(pkgs, "lewis6991/impatient.nvim")

local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
  print("Impation is not loaded!")
  return
end

impatient.enable_profile()
