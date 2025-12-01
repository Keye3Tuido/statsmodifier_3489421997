local Manage_Show = require('operations.manage_show')
local function mouse(self, playerId, entityPlayer, val, valArg)
    Manage_Show.showMouse=not Manage_Show.showMouse
    return true
end

return mouse