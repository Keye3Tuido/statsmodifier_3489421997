local Enums         = require('definitions.enums')
local Players       = require('statsmodifier.players')
local manage        = require('operations.manage')
local function OnPEffectUpdate(self,entityPlayer)
    for _,stat in pairs(Enums.Stats) do
        if(stat ~= Enums.Stats.ALL and Players:IsStatForced(nil,entityPlayer,stat)) then
            manage:UpdateStat(nil,entityPlayer,stat)
        end
    end
end

return OnPEffectUpdate