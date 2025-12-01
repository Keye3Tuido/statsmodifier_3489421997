local show = require('operations.manage_show')
local function TimeTravelRender()
    if(show.TimeSpeedMultiplier <= 1) then return end
    local X=Isaac.GetScreenWidth()/2-16
    local Y=Isaac.GetScreenHeight()-10
    Isaac.RenderScaledText('Made In Heaven: '..show.TimeSpeedMultiplier..'x', X, Y, .5, .5, 0, 1, 1, 1)
end

return TimeTravelRender