-------------------------------------------------------
-- Watcher to load the configuration in case of changes
-------------------------------------------------------

hs.pathwatcher.new(hs.configdir, hs.reload):start()
hs.alert.show("Config loaded")
