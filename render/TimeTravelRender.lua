local show = require('operations.manage_show')
local function TimeTravelRender()
    local X=Isaac.GetScreenWidth()/2
    local Y=Isaac.GetScreenHeight()-10
    if(show.TimeSpeedMultiplier == 1) then return end
    local text
    local color
    if show.TimeSpeedMultiplier > 1 then
        text = 'Made In Heaven: '..show.TimeSpeedMultiplier..'x'
        color = {r=0, g=1, b=1}
    else
        text = 'Bullet Time: '..(1/show.TimeSpeedMultiplier)..'x'
        color = {r=1, g=1, b=0}
    end
    Isaac.RenderScaledText(text, X-Isaac.GetTextWidth(text)/4, Y, .5, .5, color.r, color.g, color.b, 1)
end

return TimeTravelRender