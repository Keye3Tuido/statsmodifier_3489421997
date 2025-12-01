local show = require('operations.manage_show')

local function madeinheaven(self, playerId, entityPlayer, val, valArg)
    val=tonumber(valArg)
    if(not val or val<1)then
        show.TimeSpeedMultiplier = 1
    else
        show.TimeSpeedMultiplier = val
    end
    show.accumulator = 0
    show.integerPart = math.floor(show.TimeSpeedMultiplier)
    show.fractionPart = show.TimeSpeedMultiplier - show.integerPart
    return true
end

return madeinheaven