local Manage_Show = require('operations.manage_show')
local function info(self, playerId, entityPlayer, val, valArg)
    Manage_Show.showStatsInfo = not Manage_Show.showStatsInfo
    return true
end

return info