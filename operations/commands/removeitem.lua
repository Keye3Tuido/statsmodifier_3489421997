local GetCollectibleIdByName = require('operations.utils').GetCollectibleIdByName
local function removeitem(self, playerId, entityPlayer, val, valArg)
    if(valArg=='')then
        Isaac.ConsoleOutput('No item specified\n')
        return false
    end
    local count,pocket=0,ActiveSlot.SLOT_PRIMARY
    valArg,count=valArg:gsub('_','')
    if(count>0)then
        pocket=ActiveSlot.SLOT_POCKET
    end
    val=tonumber(valArg)
    if(not val)then
        val=GetCollectibleIdByName(valArg)
    end
    if(val==CollectibleType.COLLECTIBLE_NULL)then
        Isaac.ConsoleOutput('Item not found\n')
        return false
    end
    entityPlayer:RemoveCollectible(val,false,pocket)
    if CollectibleType.COLLECTIBLE_NULL == entityPlayer:GetActiveItem(ActiveSlot.SLOT_POCKET) then
        entityPlayer:SetPocketActiveItem(CollectibleType.COLLECTIBLE_NULL, ActiveSlot.SLOT_POCKET, false)
    end
    return true
end

return removeitem