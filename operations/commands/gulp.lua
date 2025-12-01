local GetTrinketIdByName = require('operations.utils').GetTrinketIdByName
local function gulp(self, playerId, entityPlayer, val, valArg)
    local useflag=UseFlag.USE_NOANIM|UseFlag.USE_NOCOSTUME|UseFlag.USE_ALLOWNONMAIN|UseFlag.USE_NOANNOUNCER|UseFlag.USE_CUSTOMVARDATA|UseFlag.USE_NOHUD
    if(valArg=='') then
        entityPlayer:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER,useflag)
        return true
    end
    local count
    valArg,count = valArg:gsub('_','')
    if(count ~= 0) then
        count=TrinketType.TRINKET_GOLDEN_FLAG
    end
    val = tonumber(valArg)
    if(val and(val<0 or val%1 ~= 0)) then val=nil end
    if(not val) then
        val=GetTrinketIdByName(valArg)
    end
    val=val or TrinketType.TRINKET_NULL
    if(val <= 0) then
        Isaac.ConsoleOutput('No Such Trinket.\n')
        return false
    end
    local parent=entityPlayer.Parent
    entityPlayer.Parent=nil

    local currentTrinket0=entityPlayer:GetTrinket(0)
    local currentTrinket1=entityPlayer:GetTrinket(1)
    if currentTrinket1~=TrinketType.TRINKET_NULL then
        entityPlayer:TryRemoveTrinket(currentTrinket1)
    end
    if currentTrinket0~=TrinketType.TRINKET_NULL then
        entityPlayer:TryRemoveTrinket(currentTrinket0)
    end
    
    entityPlayer:AddTrinket(val|count)
    entityPlayer:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER,useflag)

    if currentTrinket0 > 0 then
        entityPlayer:AddTrinket(currentTrinket0,false)
    end
    if currentTrinket1 > 0 then
        entityPlayer:AddTrinket(currentTrinket1,false)
    end

    entityPlayer.Parent=parent
    return true
end

return gulp