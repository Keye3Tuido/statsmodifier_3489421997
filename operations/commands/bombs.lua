local function bombs(self, playerId, entityPlayer, val, valArg)
    entityPlayer:AddBombs(val or -entityPlayer:GetNumBombs())
    return true
end

return bombs