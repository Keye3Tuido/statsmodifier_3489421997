local function die(self, playerId, entityPlayer, val, valArg)
    entityPlayer:Die()
    return true
end

return die