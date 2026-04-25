local Players           = require('statsmodifier.players')
local CommandsList      = require('operations.commandslist')

local Manage_Commands = {}

function Manage_Commands:ProduceCmd(cmd, playerId, valArg)
    local fn = CommandsList[cmd]
    if not fn then return nil end

    local val = tonumber(valArg)
    if val and val % 1 ~= 0 then val = nil end

    local entityPlayer
    playerId, entityPlayer = Players:GetIdPlayer(playerId)
    if playerId and entityPlayer then
        return fn(self, playerId, entityPlayer, val, valArg)
    end
end

return Manage_Commands