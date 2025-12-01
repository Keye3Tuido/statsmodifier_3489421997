local Players=require('statsmodifier.players')
local function blind(self,playerId,entityPlayer,val,valArg)
    local canShoot=Players:CanShoot(playerId,entityPlayer)
    if(canShoot==nil)then canShoot=entityPlayer:CanShoot()end
    canShoot=not canShoot
    Players:SetBlind(playerId,entityPlayer,canShoot)
    if(canShoot)then
        entityPlayer:TryRemoveNullCostume(NullItemID.ID_BLINDFOLD)
    else
        entityPlayer:AddNullCostume(NullItemID.ID_BLINDFOLD)
    end
    return true
end

return blind