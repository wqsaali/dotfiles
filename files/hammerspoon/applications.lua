-----------------------------------------------
-- Applications
-----------------------------------------------

hs.hotkey.bind(hyper, "return", function()
  hs.application.launchOrFocus(term)
end)

hs.hotkey.bind(hyper, "b", function()
  hs.application.launchOrFocus(browser)
end)
