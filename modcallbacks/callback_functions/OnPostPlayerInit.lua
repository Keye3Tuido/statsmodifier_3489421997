local UpdatePlayerList = require('operations.manage').UpdatePlayerList
local function OnPostPlayerInit(self)
    UpdatePlayerList(self)
end

return OnPostPlayerInit