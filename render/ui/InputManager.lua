local InputManager = {}

InputManager.backspaceFrameCounter = 0
InputManager.backspaceHeld = false

-- 第一列可见行数（由渲染器设置）
InputManager.maxVisibleItems = 16

InputManager.KeyCharMap = {}
for i = 0, 25 do
    InputManager.KeyCharMap[Keyboard.KEY_A + i] = string.char(string.byte('a') + i)
end
for i = 0, 9 do
    InputManager.KeyCharMap[Keyboard.KEY_0 + i] = string.char(string.byte('0') + i)
end
InputManager.KeyCharMap[Keyboard.KEY_EQUAL]        = '='
InputManager.KeyCharMap[Keyboard.KEY_MINUS]        = '-'
InputManager.KeyCharMap[Keyboard.KEY_PERIOD]       = '.'
InputManager.KeyCharMap[Keyboard.KEY_KP_ADD]       = '+'
InputManager.KeyCharMap[Keyboard.KEY_KP_MULTIPLY]  = '*'
InputManager.KeyCharMap[Keyboard.KEY_KP_SUBTRACT]  = '-'
InputManager.KeyCharMap[Keyboard.KEY_KP_DECIMAL]   = '.'
InputManager.KeyCharMap[Keyboard.KEY_SPACE]        = ' '
-- 小键盘数字 0-9
for i = 0, 9 do
    InputManager.KeyCharMap[Keyboard.KEY_KP_0 + i] = string.char(string.byte('0') + i)
end

InputManager.ShiftKeyCharMap = {
    [Keyboard.KEY_MINUS] = '_',
    [Keyboard.KEY_8]     = '*',
    [Keyboard.KEY_EQUAL] = '+',
}

local function isShiftHeld()
    return Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0)
        or Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT, 0)
end

function InputManager.Update(panelState)
    -- 1. Hotkey: '\' 键
    if Input.IsButtonTriggered(Keyboard.KEY_BACKSLASH, 0) then
        panelState.toggleVisible()
        return
    end

    if not panelState.visible then return end

    -- 帮助弹窗打开时只响应 \ 键关闭弹窗
    if panelState.showHelp then
        if Input.IsButtonTriggered(Keyboard.KEY_BACKSLASH, 0) then
            panelState.showHelp = false
        end
        return
    end

    -- 3. 编辑玩家 ID 模式
    if panelState.editingPlayerId then
        for i = 0, 9 do
            if Input.IsButtonTriggered(Keyboard.KEY_0 + i, 0)
            or Input.IsButtonTriggered(Keyboard.KEY_KP_0 + i, 0) then
                panelState.appendPlayerId(tostring(i))
            end
        end
        if Input.IsButtonTriggered(Keyboard.KEY_BACKSPACE, 0) then
            panelState.deletePlayerId()
        end
        if Input.IsButtonTriggered(Keyboard.KEY_ENTER, 0)
        or Input.IsButtonTriggered(Keyboard.KEY_TAB, 0) then
            panelState.confirmPlayerId()
        end
        return
    end

    -- 4. Tab 切换类别
    if Input.IsButtonTriggered(Keyboard.KEY_TAB, 0) then
        if panelState.category == "stats" then
            panelState.setCategory("commands")
        else
            panelState.setCategory("stats")
        end
    end

    -- 5. 上下方向键滚动
    -- 如果选中了 enum 类型命令，Up/Down 滚动第二列；
    -- 如果选中了 text 类型命令且有搜索结果，Up/Down 滚动搜索结果；
    -- 否则滚动第一列
    local def = panelState.selectedDef
    local isEnumSelected = def and def.modType == "enum"
    local hasSearchResults = def and def.modType == "text" and panelState.getSearchResults() ~= nil

    if Input.IsButtonTriggered(Keyboard.KEY_UP, 0) then
        if isEnumSelected then
            panelState.scrollCol2Up()
        elseif hasSearchResults then
            panelState.scrollCol3Up()
        else
            panelState.scrollUp()
        end
    end
    if Input.IsButtonTriggered(Keyboard.KEY_DOWN, 0) then
        if isEnumSelected then
            panelState.scrollCol2Down(panelState.maxVisibleCol2)
        elseif hasSearchResults then
            panelState.scrollCol3Down(panelState.maxVisibleCol3)
        else
            panelState.scrollDown(InputManager.maxVisibleItems)
        end
    end
    -- Page Up / Page Down 始终滚动第一列
    if Input.IsButtonTriggered(Keyboard.KEY_PAGE_UP, 0) then
        for _ = 1, 5 do panelState.scrollUp() end
    end
    if Input.IsButtonTriggered(Keyboard.KEY_PAGE_DOWN, 0) then
        for _ = 1, 5 do panelState.scrollDown(InputManager.maxVisibleItems) end
    end

    -- 6. 回车执行指令
    if Input.IsButtonTriggered(Keyboard.KEY_ENTER, 0) then
        panelState.executeCommand()
        return
    end

    local shiftHeld = isShiftHeld()

    -- 7. 参数输入
    for key, char in pairs(InputManager.KeyCharMap) do
        if Input.IsButtonTriggered(key, 0) then
            if shiftHeld and InputManager.ShiftKeyCharMap[key] then
                panelState.appendParam(InputManager.ShiftKeyCharMap[key])
            else
                panelState.appendParam(char)
            end
        end
    end

    -- 8. 退格删除参数
    if Input.IsButtonPressed(Keyboard.KEY_BACKSPACE, 0) then
        if not InputManager.backspaceHeld then
            panelState.deleteParam()
            InputManager.backspaceHeld = true
            InputManager.backspaceFrameCounter = 0
        else
            InputManager.backspaceFrameCounter = InputManager.backspaceFrameCounter + 1
            if InputManager.backspaceFrameCounter >= 4 then
                panelState.deleteParam()
                InputManager.backspaceFrameCounter = 0
            end
        end
    else
        InputManager.backspaceHeld = false
        InputManager.backspaceFrameCounter = 0
    end
end

return InputManager
