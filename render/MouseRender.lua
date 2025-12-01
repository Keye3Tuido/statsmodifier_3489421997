local Manage_Show = require('operations.manage_show')
local function RenderPosColor(head,tail,cor,pos,r,g,b,a)
    Isaac.RenderScaledText(head..string.format('%.3f',cor.X)..','..string.format('%.3f',cor.Y)..' '..tail,pos.X,pos.Y,0.5,0.5,r,g,b,a)
end
local function MouseRender()
    if(Manage_Show.showMouse)then
        local gameCoordinates=Input.GetMousePosition(true)
        -- local renderCoordinates=Input.GetMousePosition(false)
        local renderCoordinates=Isaac.WorldToRenderPosition(gameCoordinates)
        local screenCoordinates=Isaac.WorldToScreen(gameCoordinates)
        if Game():GetRoom():IsMirrorWorld() then
            local center = Isaac.WorldToRenderPosition(Vector(320, 240))
            gameCoordinates.X = gameCoordinates.X - 2 * Isaac.ScreenToWorldDistance(screenCoordinates - center).X
        end
        RenderPosColor('<---','Screen',screenCoordinates,screenCoordinates+Vector(0,-2),0,1,1,1)
        RenderPosColor('    ','Game',gameCoordinates,screenCoordinates+Vector(0,4),1,1,0,1)
        RenderPosColor('    ','Render',renderCoordinates,screenCoordinates+Vector(0,10),1,0,1,1)
    end
end

return MouseRender