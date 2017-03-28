-----------------------------------------------
-- Set up
-----------------------------------------------

hyper = {"cmd", "alt"}
hyperShift = {"shift","cmd", "alt"}
hyperCtlr = {"ctrl","cmd", "alt"}

hs.window.animationDuration = 0

require("hs.application")
require("hs.window")

require('watcher')
require('position')
require('focus')

-----------------------------------------------
-- hyper c to center window
-----------------------------------------------

hs.hotkey.bind(hyper, 'c', function()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.w = max.w * 0.7
        f.h = max.h * 0.7
        f.x = (max.w - f.w)/2
        f.y = (max.h - f.h)/2
        win:setFrame(f)
    else
        hs.alert.show("No active window")
    end
end)
