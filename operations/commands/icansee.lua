local function icansee(self,playerId,entityPlayer,val,valArg)
    local level=Game():GetLevel()
    level:RemoveCurses(LevelCurse.CURSE_OF_DARKNESS|LevelCurse.CURSE_OF_THE_LOST|LevelCurse.CURSE_OF_THE_UNKNOWN|LevelCurse.CURSE_OF_MAZE|LevelCurse.CURSE_OF_BLIND)
    level:SetCanSeeEverything(true)
    local rooms=level:GetRooms()
    for i=0,rooms.Size-1 do
        local room=level:GetRoomByIdx(rooms:Get(i).SafeGridIndex)
        room.DisplayFlags=RoomDescriptor.DISPLAY_ALL
    end
    level:UpdateVisibility()


    local mod=RegisterMod('',1)
    local function f1(_,collectible)
        local sprite=collectible:GetSprite()
        local c=Isaac.GetItemConfig():GetCollectible(collectible.SubType)
        if(not (sprite and c) or collectible.SubType>0x80000000)then return end
        sprite:ReplaceSpritesheet(1,c.GfxFileName)
        sprite:LoadGraphics()
    end
    local function f2()
        mod:RemoveCallback(ModCallbacks.MC_POST_PICKUP_RENDER,f1)
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_LEVEL,f2)
    end
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER,f1,PickupVariant.PICKUP_COLLECTIBLE)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL,f2)
    return true
end

return icansee