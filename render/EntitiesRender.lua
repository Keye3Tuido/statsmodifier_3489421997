local Manage_Show = require('operations.manage_show')
local EntityIdToRender = {}

local function ShowEntities()
    local es=Isaac.GetRoomEntities()
    for _,e in ipairs(es) do
        local ep=e.Position
        ep=Isaac.WorldToScreen(ep)
        if(Game():GetRoom():IsMirrorWorld())then ep.X=Isaac.GetScreenWidth()-ep.X end
        local subType=e.SubType
        if(e.SubType>0x80000000)then
            subType=e.SubType-0x100000000
        end
        local str=e.Type..'.'..e.Variant..'.'..subType
        table.insert(EntityIdToRender, {
            text = str,
            position = ep,
            color = KColor(0,1,1,0.7)
        })
    end
end

local function ShowGridEntities()
    local room=Game():GetRoom()
    local size=room:GetGridSize()
    for i=0,size-1 do
        local ge=room:GetGridEntity(i)
        if(ge)then
            local gep=room:GetGridPosition(i)
            gep=Isaac.WorldToScreen(gep)
            if(Game():GetRoom():IsMirrorWorld())then gep.X=Isaac.GetScreenWidth()-gep.X end
            local str=ge:GetType()..'.'..ge:GetVariant()
            table.insert(EntityIdToRender, {
                text = str,
                position = gep,
                color = KColor(1,1,1,0.3)
            })
        end
    end
end

local function RenderText(str, pos, kcolor)
    local f = Font()
    f:Load("font/terminus.fnt")
    f:DrawStringScaled(
        str,
        pos.X - f:GetStringWidth(str) / 2,
        pos.Y - f:GetBaselineHeight() / 2,
        0.5, 0.5,
        kcolor,
        f:GetStringWidth(str),
        true
    )
end

local function RenderSmartText()
    local groups = {}
    for _, item in ipairs(EntityIdToRender) do
        local key = (item.position.X//5) ..','..(item.position.Y//5)
        groups[key] = groups[key] or {}
        table.insert(groups[key], item)
    end

    for _, group in pairs(groups) do
        local center = Vector.Zero
        for _, item in ipairs(group) do
            center = center + item.position
        end
        center = center / #group

        local verticalOffset = -5 * (#group - 1) / 2
        for _, item in ipairs(group) do
            local renderPos = Vector(center.X, center.Y + verticalOffset)
            RenderText(item.text, renderPos, item.color)
            verticalOffset = verticalOffset + 5
        end
    end
end

local function EntitiesRender()
    if(not Manage_Show.showEntityId)then return end
    EntityIdToRender = {}
    ShowGridEntities()
    ShowEntities()
    RenderSmartText()
end

return EntitiesRender