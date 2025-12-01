local Input2Id          = require('definitions.produce_input')
local Players           = require('statsmodifier.players')
local CommandsList      = require('operations.commandslist')

local Manage_Commands = {}

function Manage_Commands:ProduceCmd(cmd,playerId,valArg)

    local cmdId=Input2Id.CommandsID[cmd]
    local entityPlayer
    local val=tonumber(valArg)
    if(val and val%1 ~= 0) then
        val = nil
    end
    playerId,entityPlayer=Players:GetIdPlayer(playerId)
    if(playerId and entityPlayer) then
        for k,v in pairs(CommandsList) do
            if cmdId == k then
                return v(self,playerId,entityPlayer,val,valArg)
            end
        end
    end
end

return Manage_Commands