local function coins(self, playerId, entityPlayer, val, valArg)
    entityPlayer:AddCoins(val or -entityPlayer:GetNumCoins())
    return true
end

return coins