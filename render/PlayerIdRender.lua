local Players       = require('statsmodifier.players')
local Manage_Show   = require('operations.manage_show')
local function PlayerIdRender(playerId,entityPlayer,renderOffset)
    if(not Manage_Show.showPlayerId) then return end
    playerId,entityPlayer=Players:GetIdPlayer(playerId,entityPlayer)
    if(not playerId) then return end
    local idString='ID:'..playerId
    local pos=entityPlayer.Position + entityPlayer.PositionOffset
    pos=Isaac.WorldToRenderPosition(pos) + (renderOffset or Vector.Zero)
    pos=pos-Vector((#idString-1)<<2,31.3*entityPlayer.SpriteScale.Y+12.5)
    Isaac.RenderText(idString,pos.X,pos.Y,Players:RenderColor(playerId,entityPlayer))
end

return PlayerIdRender