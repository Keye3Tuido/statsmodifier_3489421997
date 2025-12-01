local UpdatePlayerList = require('operations.manage').UpdatePlayerList
local function OnPostPlayerRemove(self)
    UpdatePlayerList(self)
end

return OnPostPlayerRemove