local Renderer          = require('render.renderer')
local Players           = require('statsmodifier.players')
local PlayerIdRender    = Renderer.PlayerIdRender
local StatsInfoRender   = Renderer.StatsInfoRender
local function OnPostPlayerRender(self,entityPlayer,renderOffset)
    PlayerIdRender(nil,entityPlayer,renderOffset)
    StatsInfoRender(nil,entityPlayer,renderOffset)
end

return OnPostPlayerRender