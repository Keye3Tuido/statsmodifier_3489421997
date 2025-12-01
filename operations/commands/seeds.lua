local GetEasterEggNameById = require('operations.utils').GetEasterEggNameById
local function seeds(self, playerId, entityPlayer, val, valArg)
    local gameSeeds=Game():GetSeeds()
    valArg=valArg:upper():gsub(' ','')
    valArg=valArg:sub(1,4)..' '..valArg:sub(5)
    if(Seeds.IsSpecialSeed(valArg))then
        val=Seeds.GetSeedEffect(valArg)
        local seed=Game():GetSeeds()
        if(val>0) then
            if(not seed:HasSeedEffect(val))then
                if(seed:CanAddSeedEffect(val)) then
                    seed:AddSeedEffect(val)
                    Isaac.ConsoleOutput('Added Egg'..val..' : '..GetEasterEggNameById(val)..' .\n')
                else
                    Isaac.ConsoleOutput('Failed to add.\n')
                end
            else
                seed:RemoveSeedEffect(val)
                Isaac.ConsoleOutput('Removed Egg'..val..' : '..GetEasterEggNameById(val)..'.\n')
            end
        else
            seed:ClearSeedEffects()
            Isaac.ConsoleOutput('Cleared Seed Effects.\n')
        end
        local count=seed:CountSeedEffects()
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
    if(Seeds.IsStringValidSeed(valArg))then
        gameSeeds:SetStartSeed(valArg)
        Isaac.ConsoleOutput('Change Seed to '..valArg..' .\n')
    else
        Isaac.ConsoleOutput('Invalid Seed.\n')
        return false
    end
    return true
end

return seeds