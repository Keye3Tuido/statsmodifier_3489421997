local Manage_Show = require('operations.manage_show')
local function entity(self, playerId, entityPlayer, val, valArg)
    Manage_Show.showEntityId=not Manage_Show.showEntityId
    return true
end

return entity