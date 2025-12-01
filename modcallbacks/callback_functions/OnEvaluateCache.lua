local Players       = require('statsmodifier.players')
local manage        = require('operations.manage')
local OnEvaluateCache=function(self,entityPlayer,stat)
    Players:TrackOriginalStat(nil,entityPlayer,stat)
    if(not Players:IsStatForced(nil,entityPlayer,stat)) then
        manage:UpdateStat(nil,entityPlayer,stat)
    end
end


return function(self,entityPlayer,stat)
    return OnEvaluateCache(self,entityPlayer,stat)
end