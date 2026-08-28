hs.hotkey.bind({}, "F18", function()
  hs.application.launchOrFocus("Brave Browser")
end)

hs.hotkey.bind({}, "F19", function()
  hs.application.launchOrFocus("Ghostty")
end)

hs.hotkey.bind({}, "F20", function()
  hs.application.launchOrFocus("Zed")
end)

hs.hotkey.bind({}, "F17", function()
  hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind({}, "F16", function()
  hs.application.launchOrFocus("Obsidian")
end)

local braveSearchHotkey = hs.hotkey.new({ "cmd" }, "s", function()
  hs.eventtap.keyStroke({ "cmd" }, "l", 0)
end)

local function sync_brave_search_hotkey()
  local frontmost = hs.application.frontmostApplication()
  local is_brave = frontmost and frontmost:name() == "Brave Browser"

  if is_brave then
    braveSearchHotkey:enable()
  else
    braveSearchHotkey:disable()
  end
end

local braveWatcher = hs.application.watcher.new(function(_, event_type)
  if event_type == hs.application.watcher.activated or event_type == hs.application.watcher.deactivated then
    sync_brave_search_hotkey()
  end
end)

braveWatcher:start()

sync_brave_search_hotkey()
