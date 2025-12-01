require('definitions.options')

local StatsModifier = require('statsmodifier.statsmodifier')
if(StatsModifier)then
    Isaac.ConsoleOutput('StatsModifier v' .. StatsModifier.Version .. ' - Keye3Tuido\n')
    require('statsmodifier.players')(StatsModifier)
    require('modcallbacks.addCallbacks')(StatsModifier)
else
    error('Failed to load StatsModifier!\n')
end