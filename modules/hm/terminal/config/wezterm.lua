local wezterm = require("wezterm")

local function file_exists(name)
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
end

wezterm.on("user-var-changed", function(window, pane, name, value)
    if name == "THEME" then
        wezterm.reload_configuration()
    end
end)

wezterm.on("window-focus-changed", function(window, pane)
    wezterm.reload_configuration()
end)

local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return "Dark"
end

function Scheme_for_appearance(appearance)
    if file_exists(wezterm.home_dir .. "/Documents/theme_dark") then
        return "{{theme}}"
    end
    if file_exists(wezterm.home_dir .. "/Documents/theme_light") then
        return "{{light_theme}}"
    end
    if appearance():find("Light") then
        return "{{light_theme}}"
    end
    return "{{theme}}"
end

local config = wezterm.config_builder()

config.color_scheme = Scheme_for_appearance(get_appearance)

-- {{^steamdeck}}
-- MacOS
config.font = wezterm.font("FiraCode Nerd Font Propo", {
    weight = "Bold",
    stretch = "Condensed",
})
config.font_size = 14.6
config.font_shaper = "Harfbuzz"
config.freetype_load_target = "Light"
-- config.line_height = 0.9
-- config.freetype_load_target = "HorizontalLcd"
-- config.foreground_text_hsb = {
--     hue = 1.0,
--     saturation = 1.0,
--     brightness = 0.9,  -- default is 1.0
-- }
-- {{/steamdeck}}
-- {{#steamdeck}}
-- SteamOs
config.font = wezterm.font("FiraCode Nerd Font", {
    weight = "Regular",
    stretch = "Condensed",
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
-- {{/steamdeck}}

config.enable_tab_bar = false
config.enable_scroll_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.warn_about_missing_glyphs = false

return config
