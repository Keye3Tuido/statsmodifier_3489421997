local StatsModifier = RegisterMod("StatsModifier", 1)
local debug = require("debug")
local source = debug.getinfo(1,'S').source
StatsModifier.Version = '7.0.0'
StatsModifier.Path = source:match("^@(.*)/statsmodifier/statsmodifier%.lua$")
StatsModifier.FolderName = source:match("/([^/]+)/statsmodifier/statsmodifier%.lua$")


return StatsModifier