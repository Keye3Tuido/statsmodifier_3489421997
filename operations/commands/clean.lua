local ClearAll = require('operations.manage_players').ClearAll
local function clean(self, playerId, entityPlayer, val, valArg)
    ClearAll(self)
    return true
end

return clean