local function ascent(self,playerId,entityPlayer,val,valArg)
    local flag = GameStateFlag.STATE_BACKWARDS_PATH_INIT
    local currentState = Game():GetStateFlag(flag)
    currentState = not currentState
    Game():SetStateFlag(flag, currentState)
    Isaac.ConsoleOutput('Ascent triggered: ' .. tostring(currentState) .. '\n')
    return true
end

return ascent