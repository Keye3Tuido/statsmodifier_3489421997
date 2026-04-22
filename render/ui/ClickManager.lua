local ClickManager = {}

local wasMousePressed = false
-- 右键拖拽滚动状态
local wasRightPressed = false
local rightDragColumn = 0  -- 0=none, 1=col1, 2=col2

-- 列区域坐标（由渲染器每帧设置）
ClickManager.col1Area = { x = 0, y = 0, w = 0, h = 0 }
ClickManager.col2Area = { x = 0, y = 0, w = 0, h = 0 }
-- 列的总条目数和可见条目数（由渲染器每帧设置）
-- 初始值设为安全默认值，防止第一帧渲染前右键拖拽时除零
ClickManager.col1Total = 1
ClickManager.col1Visible = 1
ClickManager.col2Total = 1
ClickManager.col2Visible = 1

function ClickManager.IsInside(mx, my, x, y, width, height)
    return mx >= x
       and mx <= x + width
       and my >= y
       and my <= y + height
end

function ClickManager.Update(panelState, uiElements)
    local worldPos = Input.GetMousePosition(true)
    local screenPos = Isaac.WorldToScreen(worldPos)
    local mx = screenPos.X
    local my = screenPos.Y

    panelState.hoveredElement = nil

    -- ─── 左键点击 ───
    local isPressed = Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT)
    local clicked = isPressed and not wasMousePressed
    wasMousePressed = isPressed

    -- ─── 右键拖拽滚动（模拟滚动条）───
    local isRightPressed = Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_RIGHT)

    if isRightPressed and not wasRightPressed then
        -- 右键刚按下：判断在哪一列
        local a1 = ClickManager.col1Area
        local a2 = ClickManager.col2Area
        if ClickManager.IsInside(mx, my, a1.x, a1.y, a1.w, a1.h) then
            rightDragColumn = 1
        elseif ClickManager.IsInside(mx, my, a2.x, a2.y, a2.w, a2.h) then
            rightDragColumn = 2
        else
            rightDragColumn = 0
        end
    end

    if isRightPressed and rightDragColumn > 0 then
        -- 按住右键时：将鼠标 Y 在列区域内的相对位置映射到滚动偏移
        -- 鼠标在列顶部 → scrollOffset = 0
        -- 鼠标在列底部 → scrollOffset = maxOffset
        local area, total, visible
        if rightDragColumn == 1 then
            area = ClickManager.col1Area
            total = ClickManager.col1Total
            visible = ClickManager.col1Visible
        else
            area = ClickManager.col2Area
            total = ClickManager.col2Total
            visible = ClickManager.col2Visible
        end

        local maxOffset = math.max(0, total - visible)
        if maxOffset > 0 and area.h > 0 then
            -- 计算鼠标在列区域内的比例 (0~1)
            local ratio = (my - area.y) / area.h
            ratio = math.max(0, math.min(1, ratio))
            local newOffset = math.floor(ratio * maxOffset + 0.5)

            if rightDragColumn == 1 then
                panelState.scrollOffset = newOffset
            else
                panelState.scrollOffset2 = newOffset
            end
        end
    end

    if not isRightPressed then
        rightDragColumn = 0
    end
    wasRightPressed = isRightPressed

    -- ─── 悬停和左键点击检测 ───
    for _, element in ipairs(uiElements) do
        if ClickManager.IsInside(mx, my, element.x, element.y, element.width, element.height) then
            panelState.hoveredElement = element.id

            if clicked and element.action then
                element.action()
            end

            break
        end
    end
end

return ClickManager
