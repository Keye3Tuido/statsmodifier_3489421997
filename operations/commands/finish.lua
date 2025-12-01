local function finish(self, playerId, entityPlayer, val, valArg)
    Game():FinishChallenge()
    return true
end

return finish