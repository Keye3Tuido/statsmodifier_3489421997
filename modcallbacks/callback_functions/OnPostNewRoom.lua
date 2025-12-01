local Enums     = require('definitions.enums')
local Players   = require('statsmodifier.players')
local function OnPostNewRoom(self)
    if(Game():GetRoom():IsFirstVisit())then
        for pid,enp in Players:Iterator() do
            local collectibleId=Players:GetPocket(pid,enp)
            if(collectibleId)then
                enp:RemoveCollectible(enp:GetActiveItem(ActiveSlot.SLOT_POCKET2),false,ActiveSlot.SLOT_POCKET2)
                enp:SetPocketActiveItem(collectibleId,ActiveSlot.SLOT_POCKET2,true)
            end
        end
    end
    for playerId, entityPlayer in Players:Iterator() do
        local canfly=Players:GetPlayerStat(playerId, entityPlayer, Enums.Stats.FLYING)
        if(canfly)then
            if(canfly ~= 0) then
                entityPlayer:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BIBLE)
            else
                entityPlayer:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BIBLE)
            end
        end
    end
end

return OnPostNewRoom