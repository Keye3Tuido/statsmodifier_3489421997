local Manage = require('operations.manage')
local NewPlayers = Manage.NewPlayers
local function OnPostGameStarted(self,isContinued)
    if(not isContinued)then
        NewPlayers(self)
    end
end

return OnPostGameStarted