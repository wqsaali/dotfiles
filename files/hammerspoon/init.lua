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
require('applications')

-----------------------------------------------
-- Tilling
-----------------------------------------------

local tiling = require "hs.tiling"
hs.hotkey.bind(hyper, "`", function() tiling.cycleLayout() end)
hs.hotkey.bind(hyper, ",", function() tiling.cycle(1) end)
hs.hotkey.bind(hyper, ".", function() tiling.cycle(-1) end)
hs.hotkey.bind(hyper, "space", function() tiling.promote() end)
hs.hotkey.bind(hyper, "/", function() tiling.goToLayout("fullscreen") end)

-----------------------------------------------
-- Lock
-----------------------------------------------

hs.hotkey.bind(hyper, 'l', function()
  -- os.execute("open '/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'")
  os.execute("/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend")
end)

