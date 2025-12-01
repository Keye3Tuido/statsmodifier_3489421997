local function set_time(self, playerId, entityPlayer, val, valArg)
    if(val) then
        Game().TimeCounter=val*30
    else
        Game().TimeCounter=0
    end
    return true
end

return set_time