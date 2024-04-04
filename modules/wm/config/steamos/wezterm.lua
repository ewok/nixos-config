local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font", {
    weight='Regular',
    stretch="Condensed",
})
config.font_size = 10.0
config.font_shaper = "Harfbuzz"
-- config.freetype_load_target = "Light"
-- config.freetype_load_target = "HorizontalLcd"
-- config.foreground_text_hsb = {
--     hue = 1.0,
--     saturation = 1.0,
--     brightness = 0.9,  -- default is 1.0
-- }

config.color_scheme = 'OneDark (base16)'

config.enable_tab_bar = false
config.enable_scroll_bar = false
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = "RESIZE"

return config