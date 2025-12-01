local function giga_bombs(self, playerId, entityPlayer, val, valArg)
    entityPlayer:AddBombs(val or 0)
    entityPlayer:AddGigaBombs(val or -entityPlayer:GetNumGigaBombs())
    return true
end

return giga_bombs