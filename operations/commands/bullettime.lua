local show = require('operations.manage_show')

local function bullettime(self, playerId, entityPlayer, val, valArg)
    val=tonumber(valArg)
    if(not val or val>1)then
        show.TimeSpeedMultiplier = 1
    else
        show.TimeSpeedMultiplier = math.max(0,val)
    end
    return true
end

return bullettime