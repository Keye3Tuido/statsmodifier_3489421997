local Renderer          = require('render.renderer')
local MouseRender       = Renderer.MouseRender
local HUDRender         = Renderer.HUDRender
local EntitiesRender    = Renderer.EntitiesRender
local GetRenderTimeScale = Renderer.GetRenderTimeScale
local SlowTime          = Renderer.SlowTime
local TimeTravelRender  = Renderer.TimeTravelRender
local CommandUI         = Renderer.CommandUI
local function OnPostRender()
    CommandUI.Update()
    MouseRender()
    HUDRender()
    EntitiesRender()
    GetRenderTimeScale()
    SlowTime()
    TimeTravelRender()
    CommandUI.Render()
end

return OnPostRender