local GetCollectibleIdByName = require('operations.utils').GetCollectibleIdByName
local function giveitem(self, playerId, entityPlayer, val, valArg)
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
    if(not val) then
        val=GetCollectibleIdByName(valArg)
    end
    local collectible=Isaac.GetItemConfig():GetCollectible(val)
    if(not collectible) then
        Isaac.ConsoleOutput('Item not found\n')
        return false
    end
    local activeCharge=collectible.InitCharge

    local currentlyHeldActive=entityPlayer:GetActiveItem(pocket)
    if(collectible.Type ~= ItemType.ITEM_ACTIVE or currentlyHeldActive==ItemType.ITEM_NULL or
        (currentlyHeldActive~=ItemType.ITEM_NULL and entityPlayer:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG)
        and entityPlayer:GetActiveItem(ActiveSlot.SLOT_SECONDARY)==ItemType.ITEM_NULL and pocket==ActiveSlot.SLOT_PRIMARY)) then
    else
        entityPlayer:RemoveCollectible(currentlyHeldActive,false,pocket)
    end
    if(pocket==ActiveSlot.SLOT_PRIMARY)then
        entityPlayer:AddCollectible(val,activeCharge)
    else
        entityPlayer:SetPocketActiveItem(val,ActiveSlot.SLOT_POCKET,true)
    end
    return true
end

return giveitem
