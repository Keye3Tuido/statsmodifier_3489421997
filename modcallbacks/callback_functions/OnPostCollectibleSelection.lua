-- Discarded
local function OnPostCollectibleSelection(self, entityPickup, Variant, SubType)
    if Variant == PickupVariant.PICKUP_COLLECTIBLE and SubType == Isaac.GetItemIdByName('StatsModifier') then
        return{Variant, SubType - 1}
    end
end

return OnPostCollectibleSelection