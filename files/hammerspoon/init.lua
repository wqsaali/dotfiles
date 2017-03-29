-----------------------------------------------
-- Set up
-----------------------------------------------

hyper = {"cmd", "alt"}
hyperShift = {"shift","cmd", "alt"}
hyperCtlr = {"ctrl","cmd", "alt"}

browser = 'Google Chrome'
term = 'iterm'

hs.window.animationDuration = 0

require("hs.application")
require("hs.window")

require('watcher')
require('position')
require('focus')

-----------------------------------------------
-- Lock
-----------------------------------------------

hs.hotkey.bind(hyper, 'l', function()
  -- os.execute("open '/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'")
  os.execute("/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend")
end)

-----------------------------------------------
-- Applications
-----------------------------------------------

hs.hotkey.bind(hyper, "return", function()
  hs.application.launchOrFocus(term)
end)

hs.hotkey.bind(hyper, "b", function()
  hs.application.launchOrFocus(browser)
end)
