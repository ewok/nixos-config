local function yabai(commands)
	for _, cmd in ipairs(commands) do
		os.execute("/opt/homebrew/bin/yabai -m " .. cmd)
	end
end

local function alt(key, commands)
	hs.hotkey.bind({ "alt" }, key, function()
		yabai(commands)
	end)
end
local function altShift(key, commands)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabai(commands)
	end)
end
local function altCtrl(key, commands)
	hs.hotkey.bind({ "alt", "ctrl" }, key, function()
		yabai(commands)
	end)
end
local function altCtrlRepeat(key, commands)
	hs.hotkey.bind(
		{ "alt", "ctrl" },
		key,
		function()
			yabai(commands)
		end,
		nil,
		function()
			yabai(commands)
		end
	)
end

-- alpha
alt("f", { "window --toggle zoom-fullscreen" })
alt("m", { "space --toggle mission-control" })
alt("p", { "window --toggle pip" })
alt("g", { "space --toggle padding", "space --toggle gap" })
alt("r", { "space --rotate 90" })
altShift("f", { "window --toggle float", "window --grid 4:4:1:1:2:2" })

-- special characters
alt("s", { "space --layout stack" })
alt("e", { "space --layout bsp" })

alt("q", { "window --toggle split" })

-- resize
altCtrlRepeat("h", { "window --resize left:-20:0" })
altCtrlRepeat("k", { "window --resize top:0:-20" })
altCtrlRepeat("j", { "window --resize top:0:20" })
altCtrlRepeat("l", { "window --resize left:20:0" })

--
-- local function altShiftNumber(number)
-- 	altShift(number, { "window --space " .. number, "space --focus " .. number })
-- end
--
-- for i = 1, 9 do
-- 	local num = tostring(i)
-- 	alt(num, { "space --focus " .. num })
-- 	altShiftNumber(num)
-- end

-- NOTE: use as arrow keys
local homeRow = { h = "west", j = "south", k = "north", l = "east" }

for key, direction in pairs(homeRow) do
	alt(key, { "window --focus " .. direction })
	altShift(key, { "window --warp " .. direction })
end

-- -- Set up the logger
-- local log = hs.logger.new("WindowMover", "info")

-- -- Function to get spaceId by space name
-- function getSpaceIdByName(spaceName)
--     local spaceNames = hs.spaces.missionControlSpaceNames()
--     for uuid, desktops in pairs(spaceNames) do
--         log.i("UUID: " .. uuid) -- Log the UUID
--         for index, name in pairs(desktops) do
--             log.i("Index: " .. index .. ", Name: " .. tostring(name)) -- Log the index and name
--             if spaceName == tostring(name) then
--                 log.i("Found spaceId for " .. spaceName .. ": " .. index)
--                 return index
--             end
--         end
--     end
--     log.w("Space not found: " .. spaceName)
--     return nil
-- end

-- -- Function to move focused window to a specific space
-- function moveFocusedWindowToSpace(spaceNumber)
--     local spaceName = "Desktop " .. spaceNumber
--     log.i("Attempting to move window to " .. spaceName)
--     -- local spaceId = getSpaceIdByName(spaceName)
--     -- if spaceId then
--     local focusedWindow = hs.window.focusedWindow()
--     if focusedWindow then
--         log.i("Moving window " .. focusedWindow:title() .. " to spaceId " .. spaceName)
--         hs.spaces.moveWindowToSpace(focusedWindow:id(), spaceNumber)
--     else
--         log.w("No focused window")
--         hs.alert.show("No focused window")
--     end
--     -- else
--     --     log.w("Space not found: " .. spaceName)
--     --     hs.alert.show("Space not found: " .. spaceName)
--     -- end
-- end

-- -- Bind keys cmd + shift + 1-6
-- for i = 1, 9 do
--     hs.hotkey.bind({ "alt", "shift" }, tostring(i), function()
--         -- log.i("Hotkey pressed: cmd + shift + " .. i)
--         moveFocusedWindowToSpace(i)
--     end)
-- end

hs.hotkey.bind({ "alt" }, "return", function()
	hs.execute("open -a Wezterm -n")
end)

local function moveWindowToSpace(spaceNumber)
	local win = hs.window.focusedWindow()
	if not win then
		hs.alert.show("No focused window")
		return
	end

	-- Calculate window header position (near top-left)
	local frame = win:frame()
	local headerX = frame.x + 100
	local headerY = frame.y + 10

	-- Store current mouse position
	local currentMouse = hs.mouse.getAbsolutePosition()

	-- Move mouse to window header
	hs.mouse.setAbsolutePosition({ x = headerX, y = headerY })
	hs.timer.usleep(10000) -- Wait 10ms

	-- Mouse down (press and hold)
	local mouseDown =
		hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, { x = headerX, y = headerY })
	mouseDown:post()
	hs.timer.usleep(10000) -- Wait 10ms

	-- Press Alt + number key (while holding mouse)
	-- spaces = require("hs.spaces")
	-- spaces.gotoSpace(spaceNumber)              -- follow window to new space
	hs.eventtap.keyStroke({ "alt" }, tostring(spaceNumber), 0)
	hs.timer.usleep(10000) -- Wait 10ms

	-- Mouse up (release)
	local mouseUp = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, { x = headerX, y = headerY })
	mouseUp:post()
	hs.timer.usleep(10000) -- Wait 10ms

	-- Restore original mouse position
	hs.mouse.setAbsolutePosition(currentMouse)

	hs.alert.show("Moved window to space " .. spaceNumber)
end

for i = 1, 9 do
	hs.hotkey.bind({ "alt", "shift" }, tostring(i), function()
		moveWindowToSpace(i)
	end)
end

-- Use my own keybinding for layouts, native is too slow
local layouts = hs.keycodes.layouts()

hs.hotkey.bind({ "cmd" }, "space", function()
	local current = hs.keycodes.currentLayout()
	local idx = hs.fnutils.indexOf(layouts, current)
	if idx then
		local nextIdx = (idx % #layouts) + 1
		hs.keycodes.setLayout(layouts[nextIdx])
		hs.alert.show(layouts[nextIdx])
	else
		hs.alert.show("Current layout not found in list")
	end
end)
