local CommandDefs      = require('render.ui.CommandDefs')
local Players          = require('statsmodifier.players')
local StatusProvider   = require('render.ui.StatusProvider')
local OnExecuteCmd     = require('modcallbacks.callback_functions.OnExecuteCmd')
local StatsModifier    = require('statsmodifier.statsmodifier')

local PanelState = {}

-- ─── UI 显示状态 ────────────────────────────────────────────
PanelState.visible = false

-- ─── 三列选择状态 ──────────────────────────────────────────
PanelState.category = "stats"         -- "stats" | "commands"
PanelState.selectedIndex = 0          -- 第一列选中的条目索引（1-based, 0=未选）
PanelState.selectedDef = nil          -- 选中的指令定义表

-- 第二列：限定符/可选参数
PanelState.selectedModIndex = 0
PanelState.forceMode = false
PanelState.underscoreMode = false     -- _ 前缀修饰符（gc/rc/eastereggs）
PanelState.selectedOptionIndex = 0    -- enum 类型选中的选项索引

-- 第三列：参数输入
PanelState.paramText = ""

-- ─── 玩家 ID ───────────────────────────────────────────────
PanelState.playerIdText = "0"
PanelState.editingPlayerId = false

-- ─── 反馈消息 ──────────────────────────────────────────────
PanelState.feedbackMsg = ""
PanelState.feedbackTimer = 0
PanelState.feedbackIsError = false

-- ─── 鼠标悬停 ──────────────────────────────────────────────
PanelState.hoveredElement = nil

-- ─── 帮助弹窗 ──────────────────────────────────────────────
PanelState.showHelp = false  -- 是否显示帮助弹窗

-- ─── 滚动偏移 ──────────────────────────────────────────────
PanelState.scrollOffset = 0
PanelState.scrollOffset2 = 0  -- 第二列滚动
PanelState.scrollOffset3 = 0  -- 搜索结果滚动
PanelState.maxVisibleCol2 = 10  -- 第二列可见行数（由渲染器设置）
PanelState.maxVisibleCol3 = 10  -- 搜索结果可见行数（由渲染器设置）


--- 获取第一列的条目列表
function PanelState.getItemList()
    if PanelState.category == "stats" then
        return CommandDefs.Stats
    else
        return CommandDefs.GetFlatCommands()
    end
end

--- 打开 UI
function PanelState.open()
    if PanelState.visible then return end
    PanelState.visible = true
    PanelState.editingPlayerId = false
end

--- 关闭 UI
function PanelState.close()
    if not PanelState.visible then return end
    PanelState.visible = false
    PanelState.editingPlayerId = false
end

--- 切换 UI
function PanelState.toggleVisible()
    if PanelState.visible then
        PanelState.close()
    else
        PanelState.open()
    end
end

--- 切换类别
function PanelState.setCategory(cat)
    if PanelState.category == cat then return end
    PanelState.category = cat
    PanelState.selectedIndex = 0
    PanelState.selectedDef = nil
    PanelState.selectedModIndex = 0
    PanelState.forceMode = false
    PanelState.underscoreMode = false
    PanelState.selectedOptionIndex = 0
    PanelState.paramText = ""
    PanelState.scrollOffset = 0
    PanelState.scrollOffset2 = 0
    PanelState.scrollOffset3 = 0
end

--- 选择第一列的指令
function PanelState.selectItem(index)
    local list = PanelState.getItemList()
    if index < 1 or index > #list then return end
    local item = list[index]
    -- 跳过分组标题
    if item.type == "group" then return end
    PanelState.selectedIndex = index
    PanelState.selectedDef = item
    -- 清空第二列和第三列
    PanelState.selectedModIndex = 0
    PanelState.forceMode = false
    PanelState.underscoreMode = false
    PanelState.selectedOptionIndex = 0
    PanelState.paramText = ""
    PanelState.scrollOffset2 = 0
    PanelState.scrollOffset3 = 0
end

function PanelState.selectModifier(index)
    PanelState.selectedModIndex = index
end

function PanelState.toggleForce()
    PanelState.forceMode = not PanelState.forceMode
end

function PanelState.toggleUnderscore()
    PanelState.underscoreMode = not PanelState.underscoreMode
end

--- 选择 enum 选项（第二列可列举选项）
function PanelState.selectOption(index)
    local def = PanelState.selectedDef
    if not def or def.modType ~= "enum" then return end
    local optionsList = CommandDefs.GetOptions(def.options)
    if not optionsList or index < 1 or index > #optionsList then return end
    PanelState.selectedOptionIndex = index
    -- 将选项值填入参数文本
    PanelState.paramText = optionsList[index].value
end

function PanelState.appendParam(ch)
    PanelState.paramText = PanelState.paramText .. ch
    PanelState.scrollOffset3 = 0
end

function PanelState.deleteParam()
    if #PanelState.paramText > 0 then
        PanelState.paramText = PanelState.paramText:sub(1, -2)
        PanelState.scrollOffset3 = 0
    end
end

function PanelState.appendPlayerId(ch)
    if ch:match('%d') then
        PanelState.playerIdText = PanelState.playerIdText .. ch
    end
end

function PanelState.deletePlayerId()
    if #PanelState.playerIdText > 0 then
        PanelState.playerIdText = PanelState.playerIdText:sub(1, -2)
    end
end

--- 验证并确认玩家 ID，退出编辑模式时调用
function PanelState.confirmPlayerId()
    PanelState.editingPlayerId = false
    local id = tonumber(PanelState.playerIdText)
    if not id then
        PanelState.playerIdText = "0"
        PanelState.setFeedback("PlayerID invalid, reset to 0", true)
        return
    end
    -- 检查玩家是否存在
    local ok, player = pcall(function() return Players:GetPlayerById(id) end)
    if not ok or not player then
        PanelState.playerIdText = "0"
        PanelState.setFeedback("PlayerID " .. tostring(id) .. " not found, reset to 0", true)
    end
end

function PanelState.getPlayerId()
    local id = tonumber(PanelState.playerIdText)
    if not id then return 0 end
    return id  -- 直接返回输入的 ID，执行时由 OnExecuteCmd 处理不存在的情况
end

function PanelState.setFeedback(msg, isError)
    PanelState.feedbackMsg = msg or ""
    PanelState.feedbackIsError = isError or false
    PanelState.feedbackTimer = isError and 180 or 120
end

--- 滚动第一列
function PanelState.scrollUp()
    if PanelState.scrollOffset > 0 then
        PanelState.scrollOffset = PanelState.scrollOffset - 1
    end
end

function PanelState.scrollDown(maxVisible)
    local list = PanelState.getItemList()
    local maxOffset = math.max(0, #list - maxVisible)
    if PanelState.scrollOffset < maxOffset then
        PanelState.scrollOffset = PanelState.scrollOffset + 1
    end
end

--- 滚动第二列
function PanelState.scrollCol2Up()
    if PanelState.scrollOffset2 > 0 then
        PanelState.scrollOffset2 = PanelState.scrollOffset2 - 1
    end
end

function PanelState.scrollCol2Down(maxVisible)
    local def = PanelState.selectedDef
    if not def or def.modType ~= "enum" then return end
    local optionsList = CommandDefs.GetOptions(def.options)
    if not optionsList then return end
    local maxOffset = math.max(0, #optionsList - maxVisible)
    if PanelState.scrollOffset2 < maxOffset then
        PanelState.scrollOffset2 = PanelState.scrollOffset2 + 1
    end
end

--- 滚动搜索结果列表（第二列内）
function PanelState.scrollCol3Up()
    if PanelState.scrollOffset3 > 0 then
        PanelState.scrollOffset3 = PanelState.scrollOffset3 - 1
    end
end

function PanelState.scrollCol3Down(maxVisible)
    local results = PanelState.getSearchResults()
    if not results then return end
    local maxOffset = math.max(0, #results - maxVisible)
    if PanelState.scrollOffset3 < maxOffset then
        PanelState.scrollOffset3 = PanelState.scrollOffset3 + 1
    end
end

--- 获取当前参数文本的搜索匹配结果（用于 gc/rc/gulp/pocket 的实时搜索）
--- 返回 { {value=id, label="id: name"}, ... } 或 nil
function PanelState.getSearchResults()
    local def = PanelState.selectedDef
    if not def then return nil end
    local key = def.key
    local text = PanelState.paramText
    if text == "" then return nil end

    -- Only for item/trinket commands
    local isCollectible = (key == "gc" or key == "rc" or key == "pocket")
    local isTrinket = (key == "gulp")
    if not isCollectible and not isTrinket then return nil end

    local results = {}
    -- 与 Utils.GetCollectibleIdByName 保持一致的匹配逻辑：
    -- 1. 转小写
    -- 2. 空格替换为下划线（道具名内部用下划线分隔）
    -- 3. 转义 Lua 模式特殊字符，避免 match 报错
    local searchName = text:lower():gsub(' ', '_')
    -- 转义 Lua 模式特殊字符: ( ) . % + - * ? [ ] ^ $
    searchName = searchName:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$])', '%%%1')
    if searchName == "" then return nil end
    local maxResults = 50

    local ok, _ = pcall(function()
        if isCollectible then
            local config = Isaac.GetItemConfig()
            for i = 1, config:GetCollectibles().Size - 1 do
                local item = config:GetCollectible(i)
                if item and item.Name and item.Name:lower():match(searchName) then
                    table.insert(results, { value = tostring(i), label = i .. ": " .. item.Name })
                    if #results >= maxResults then break end
                end
            end
        elseif isTrinket then
            local config = Isaac.GetItemConfig()
            for i = 1, config:GetTrinkets().Size - 1 do
                local trinket = config:GetTrinket(i)
                if trinket and trinket.Name and trinket.Name:lower():match(searchName) then
                    table.insert(results, { value = tostring(i), label = i .. ": " .. trinket.Name })
                    if #results >= maxResults then break end
                end
            end
        end
    end)

    if #results > 0 then return results end
    return nil
end

--- 从搜索结果中选择一项
function PanelState.selectSearchResult(index)
    local results = PanelState.getSearchResults()
    if not results or index < 1 or index > #results then return end
    PanelState.paramText = results[index].value
end

--- 获取当前选中命令的实时状态信息（委托给 StatusProvider）
--- 返回 { {label=..., value=...}, ... } 或 nil
function PanelState.getStatusInfo()
    local def = PanelState.selectedDef
    if not def then return nil end

    local playerId = PanelState.getPlayerId()
    local statusKey = def.statusKey or def.key
    return StatusProvider.getStatus(PanelState.category, statusKey, playerId)
end

--- 组装指令并执行
function PanelState.executeCommand()
    local def = PanelState.selectedDef
    if not def then
        PanelState.setFeedback("未选择指令", true)
        return
    end

    local playerId = PanelState.getPlayerId()
    local arg1, arg2

    if PanelState.category == "stats" then
        arg1 = def.key .. tostring(playerId)
        if def.modType == "none" then
            arg2 = ""
        elseif def.modType == "value" then
            arg2 = PanelState.paramText
        elseif def.modType == "op_value" then
            local opChar = ""
            local mods = CommandDefs.Operators
            if PanelState.selectedModIndex >= 1 and PanelState.selectedModIndex <= #mods then
                opChar = mods[PanelState.selectedModIndex].key
            end
            local forceChar = PanelState.forceMode and "_" or ""
            arg2 = opChar .. forceChar .. PanelState.paramText
        end
    else
        arg1 = def.key .. tostring(playerId)
        local paramText = PanelState.paramText

        -- 如果命令有 underscore modifier 且已勾选，在参数前加 _
        if def.hasUnderscoreModifier and PanelState.underscoreMode and paramText ~= "" then
            paramText = "_" .. paramText
        end

        if paramText ~= "" then
            arg2 = paramText
        else
            arg2 = ""
        end
    end

    local ok, result = pcall(OnExecuteCmd, StatsModifier, arg1, arg2)
    if ok then
        if result and type(result) == "string" then
            PanelState.setFeedback(result, false)
        else
            PanelState.setFeedback("已执行", false)
        end
    else
        PanelState.setFeedback("Error: " .. tostring(result), true)
    end
end

return PanelState
