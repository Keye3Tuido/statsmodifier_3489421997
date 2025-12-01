local Players                   = require('statsmodifier.players')
local GetCollectibleIdByName    = require('operations.utils').GetCollectibleIdByName
local function pocket(self, playerId, entityPlayer, val, valArg)
    if(valArg=='')then
        Isaac.ConsoleOutput('No item specified\n')
        return false
    end
    if(not val) then
        val=GetCollectibleIdByName(valArg)
    end
    if val==CollectibleType.COLLECTIBLE_NULL then
        Isaac.ConsoleOutput('Cleared pocket item\n')
        Players:SetPocket(playerId,entityPlayer,CollectibleType.COLLECTIBLE_NULL)
        return true
    end
    local collectible = Isaac.GetItemConfig():GetCollectible(val)
    if(not collectible)then
        Isaac.ConsoleOutput('Item not found\n')
        return false
    end
    if(val~=0 and collectible.Type~=ItemType.ITEM_ACTIVE)then
        Isaac.ConsoleOutput('Item is not an Active Item\n')
        return false
    end
    Players:SetPocket(playerId,entityPlayer,val)
    return true
end

return pocket