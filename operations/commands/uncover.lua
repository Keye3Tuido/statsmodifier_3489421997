local DiscoverMap = require('operations.utils').DiscoverMap
local function uncover(self, playerId, entityPlayer, val, valArg)
    DiscoverMap()
    return true
end

return uncover