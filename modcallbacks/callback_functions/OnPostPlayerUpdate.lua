local Players = require('statsmodifier.players')
local function OnPostPlayerUpdate(self,entityPlayer)
    local canShoot=Players:CanShoot(nil,entityPlayer)
    if(canShoot==nil)then canShoot=entityPlayer:CanShoot()end
    local originalChallenge=Isaac.GetChallenge()
    if(canShoot) then
        Game().Challenge=Challenge.CHALLENGE_NULL
    else
        Game().Challenge=Challenge.CHALLENGE_SOLAR_SYSTEM
    end
    entityPlayer:UpdateCanShoot()
    Game().Challenge=originalChallenge

    --Discarded
    -- local id=Isaac.GetItemIdByName("StatsModifier")
    -- for _=1,entityPlayer:GetCollectibleNum(id) do
    --     entityPlayer:RemoveCollectible(id,true)
    -- end
end

return OnPostPlayerUpdate