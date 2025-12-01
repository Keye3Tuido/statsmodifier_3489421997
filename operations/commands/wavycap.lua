
local function wavycap(self,playerId,entityPlayer,val,valArg)
    local wavyCapCount = entityPlayer:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_WAVY_CAP)
    local wavyNullCount = entityPlayer:GetEffects():GetNullEffectNum(NullItemID.ID_WAVY_CAP_1)
    if not val then
        Isaac.ConsoleOutput("Wavy Cap effects num: " .. wavyCapCount + wavyNullCount .. '\n')
        return true
    end
    entityPlayer:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_WAVY_CAP, wavyCapCount)
    entityPlayer:GetEffects():RemoveNullEffect(NullItemID.ID_WAVY_CAP_1, wavyNullCount)
    entityPlayer:GetEffects():AddNullEffect(NullItemID.ID_WAVY_CAP_1, true, val)
    return true
end

return wavycap