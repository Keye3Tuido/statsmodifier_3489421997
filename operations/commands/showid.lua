local Manage_Show = require('operations.manage_show')
local function showid(self, playerId, entityPlayer, val, valArg)
    Manage_Show.showPlayerId = not Manage_Show.showPlayerId
    return true
end

return showid