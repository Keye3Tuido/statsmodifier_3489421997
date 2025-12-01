local Utils = require('operations.utils')
local GetEasterEggByName = Utils.GetEasterEggByName
local GetEasterEggNameById = Utils.GetEasterEggNameById
local function eggs(self, playerId, entityPlayer, val, valArg)
    local count
    valArg,count=valArg:gsub('_','')
    local remove=(count>0)
    local seed=Game():GetSeeds()
    if(valArg=='')then
        goto EggsOutput
    end
    val=tonumber(valArg)
    if(not val)then
        val=GetEasterEggByName(valArg)
    end
    if(val==0)then
        seed:ClearSeedEffects()
        Isaac.ConsoleOutput('Cleared Seed Effects.\n')
        return true
    end

    if(val>0) then
        if(not remove)then
            if(seed:CanAddSeedEffect(val)) then
                seed:AddSeedEffect(val)
                Isaac.ConsoleOutput('Added Egg'..val..' : '..GetEasterEggNameById(val)..' .\n')
            else
                Isaac.ConsoleOutput('Failed to add.\n')
            end
        else
            if(seed:HasSeedEffect(val))then
                seed:RemoveSeedEffect(val)
                Isaac.ConsoleOutput('Removed Egg'..val..' : '..GetEasterEggNameById(val).. '.\n')
            end
        end
    else
        Isaac.ConsoleOutput('No Such EasterEgg.\n')
        return false
    end
    ::EggsOutput::
    count=seed:CountSeedEffects()
    if(count~=0) then
        local eggs='Currently Effective EasterEggs:\n'
        for i=1,79 do
            if(seed:HasSeedEffect(i)) then
                eggs=eggs..i..' '..GetEasterEggNameById(i)..'\n'
                count=count-1
                if(count<=0)then break end
            end
        end
        Isaac.ConsoleOutput(eggs)
    else
        Isaac.ConsoleOutput('No Currently Effective EasterEggs.\n')
    end
    return true
end

return eggs