local Renderer          = require('render.renderer')
local MouseRender       = Renderer.MouseRender
local HUDRender         = Renderer.HUDRender
local EntitiesRender    = Renderer.EntitiesRender
local GetRenderTimeScale = Renderer.GetRenderTimeScale
local SlowTime          = Renderer.SlowTime
local TimeTravelRender  = Renderer.TimeTravelRender
local function OnPostRender()
    MouseRender()
    HUDRender()
    EntitiesRender()
    GetRenderTimeScale()
    SlowTime()
    TimeTravelRender()
end

return OnPostRender