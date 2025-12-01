local function lost(self, playerId, entityPlayer, val, valArg)
    local effects = entityPlayer:GetEffects()
    local lostCurse = NullItemID.ID_LOST_CURSE
    if effects:HasNullEffect(lostCurse) then
        effects:RemoveNullEffect(lostCurse)
    else
        effects:AddNullEffect(lostCurse)
    end
    return true
end

return lost