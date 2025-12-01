local function golden(self, playerId, entityPlayer, val, valArg)
    entityPlayer:AddGoldenBomb()
    entityPlayer:AddGoldenKey()
    return true
end

return golden