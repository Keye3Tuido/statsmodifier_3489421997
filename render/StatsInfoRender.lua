local Enums         = require('definitions.enums')
local Manage_Show   = require('operations.manage_show')
local Players       = require('statsmodifier.players')
local function StatsInfoRender(playerId,entityPlayer,renderOffset)
    if(not Manage_Show.showStatsInfo) then return end
    playerId,entityPlayer=Players:GetIdPlayer(playerId,entityPlayer)
    if(not playerId) then return end
    local f=Font()
    f:Load('font/luaminioutlined.fnt')
    local flagString='STDRSL'
    local pos=entityPlayer.Position + entityPlayer.PositionOffset
    pos=Isaac.WorldToRenderPosition(pos)+(renderOffset or Vector.Zero)
    pos=pos-Vector(20,44)
    for _,stat in pairs(Enums.Stats) do
        if(not Enums.StatsShouldRender[stat]) then
        else
            local drawColor=Players:RenderKColor(playerId,entityPlayer,stat)
            f:DrawString(string.sub(flagString,stat,stat),pos.X,pos.Y+(stat*6),drawColor,8,true)
        end
    end
end

return StatsInfoRender