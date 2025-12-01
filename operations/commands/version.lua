local StatsModifier = require('statsmodifier.statsmodifier')

local function version(self,playerId,entityPlayer,val,valArg)
    Isaac.ConsoleOutput("StatsModifier Version: " .. StatsModifier.Version .. "\n")
    Isaac.ConsoleOutput("StatsModifier Path: " .. StatsModifier.Path .. "\n")
    return true
end

return version