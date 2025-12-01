local ChallengeName = require('definitions.names').ChallengeName
local GetChallengeIdByName = require('operations.utils').GetChallengeIdByName
local function challenge(self, playerId, entityPlayer, val, valArg)
    if(valArg=='')then
        local gamechallenge=Isaac.GetChallenge()
        if(gamechallenge==0)then
            Isaac.ConsoleOutput('No Challenge.\n')
        else
            Isaac.ConsoleOutput('Current Challenge Name:'..ChallengeName[gamechallenge]..'.\n')
        end
        return true
    end
    val=tonumber(valArg)
    if(not val) then
        val=GetChallengeIdByName(valArg)
    end
    if(val < 0) then
        Isaac.ConsoleOutput('No Such Challenge.\n')
        return false
    end
    Game().Challenge=val
    if(val == 0) then
        Isaac.ConsoleOutput('Cleared Challenge.\n')
        return true
    end
    local challengeName=ChallengeName[val]
    if(val>45) then challengeName = valArg end
    Isaac.ConsoleOutput('Current Challenge Name:'..challengeName..'.\n')
    return true
end

return challenge