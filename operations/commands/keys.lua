local function keys(self, playerId, entityPlayer, val, valArg)
    entityPlayer:AddKeys(val or -entityPlayer:GetNumKeys())
    return true
end

return keys