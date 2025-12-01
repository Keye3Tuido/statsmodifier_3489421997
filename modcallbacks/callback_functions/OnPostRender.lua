local Renderer          = require('render.renderer')
local MouseRender       = Renderer.MouseRender
local HUDRender         = Renderer.HUDRender
local EntitiesRender    = Renderer.EntitiesRender
local TimeTravelRender  = Renderer.TimeTravelRender
local function OnPostRender()
    MouseRender()
    HUDRender()
    TimeTravelRender()
    EntitiesRender()
end

return OnPostRender