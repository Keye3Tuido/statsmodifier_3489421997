local function revive(self, playerId, entityPlayer, val, valArg)
    entityPlayer:Revive()
    return true
end

return revive