local CommandDefs = require('render.ui.CommandDefs')
local InputManager = require('render.ui.InputManager')
local ClickManager = require('render.ui.ClickManager')
local StatsModifier = require('statsmodifier.statsmodifier')

local CommandUIRender = {}

-- ─── 布局常量 ───────────────────────────────────────────────
local PW = 360
local PH = 200
local HEADER_H = 16
local COL1_W = 105
local COL2_W = 125
local COL3_W = PW - COL1_W - COL2_W
local FONT_SCALE = 0.28  -- 幼圆字体缩放比例
local LH = 7            -- 行高
local ITEM_PAD = 1      -- 行间额外间距
local PAD = 3
local CHAR_W = 3        -- youyuan 0.28 scale
local COL_HEADER_H = 7  -- 列标题高度
local SCROLLBAR_W = 2   -- 滚动条宽度

-- ─── 白色背景 Sprite ──────────────────────────────────────
local bgSprite = nil
local function getBgSprite()
    if bgSprite then return bgSprite end
    bgSprite = Sprite()
    bgSprite:Load("gfx/ui/white_pixel.anm2", true)
    bgSprite:Play("Idle", true)
    return bgSprite
end

-- ─── youyuan 字体 ───────────────────────────────────────────
local uiFont = nil
local function getFont()
    if uiFont then return uiFont end
    uiFont = Font()
    uiFont:Load(StatsModifier.Path .. '/font/youyuan/youyuan.fnt')
    return uiFont
end

local cursorFrame = 0

local function getPanelOrigin()
    local sw = Isaac.GetScreenWidth and Isaac.GetScreenWidth() or 480
    local sh = Isaac.GetScreenHeight and Isaac.GetScreenHeight() or 270
    return math.floor((sw - PW) / 2), math.floor((sh - PH) / 2)
end

--- 计算共享布局坐标（Render 和 GetUIElements 共用）
local function getLayout()
    local bx, by = getPanelOrigin()
    local colHeaderY = by + HEADER_H + 2
    local contentY = colHeaderY + COL_HEADER_H + 1
    local bottomBarH = LH + 6
    local feedbackH = LH + 4
    local contentH = PH - HEADER_H - COL_HEADER_H - bottomBarH - feedbackH - 6
    local rowH = LH + ITEM_PAD
    return {
        bx = bx, by = by,
        colHeaderY = colHeaderY,
        contentY = contentY,
        contentH = contentH,
        bottomBarH = bottomBarH,
        feedbackH = feedbackH,
        rowH = rowH,
    }
end

local function drawRect(x, y, w, h, r, g, b, a)
    local spr = getBgSprite()
    spr.Scale = Vector(w, h)
    spr.Color = Color(r, g, b, a or 1, 0, 0, 0)
    spr:Render(Vector(x, y), Vector(0, 0), Vector(0, 0))
end

local function drawText(text, x, y, kcolor)
    getFont():DrawStringScaledUTF8(tostring(text), x, y, FONT_SCALE, FONT_SCALE, kcolor, 0, false)
end

-- ─── 颜色常量 ──────────────────────────────────────────────
local C_NORMAL    = KColor(0.2, 0.2, 0.25, 1)
local C_HOVER     = KColor(0.0, 0.35, 0.7, 1)
local C_SEL_TEXT  = KColor(1, 1, 1, 1)
local C_INPUT     = KColor(0.0, 0.5, 0.0, 1)
local C_LABEL     = KColor(0.45, 0.45, 0.5, 1)
local C_GROUP     = KColor(0.15, 0.2, 0.45, 1)
local C_SUCCESS   = KColor(0.0, 0.6, 0.0, 1)
local C_ERROR     = KColor(0.8, 0.0, 0.0, 1)
local C_PAGE      = KColor(0.0, 0.3, 0.6, 1)
local C_PAGE_HI   = KColor(0.0, 0.5, 1.0, 1)
local C_HINT      = KColor(0.5, 0.5, 0.55, 1)
local C_FORCE_ON  = KColor(0.85, 0.45, 0.0, 1)
local C_PID       = KColor(0.0, 0.55, 0.0, 1)
local C_PID_EDIT  = KColor(0.0, 0.65, 0.2, 1)
local C_PID_HI    = KColor(0.0, 0.75, 0.3, 1)
local C_SCROLL    = KColor(0.45, 0.45, 0.5, 1)
local C_DESC      = KColor(0.25, 0.25, 0.3, 1)
local C_COL_HDR   = KColor(0.35, 0.35, 0.5, 1)
local C_STATUS_HDR = KColor(0.1, 0.4, 0.7, 1)
local C_STATUS_LBL = KColor(0.3, 0.3, 0.5, 1)
local C_STATUS_VAL = KColor(0.0, 0.55, 0.3, 1)
local C_RUN_EMPTY  = KColor(0.6, 0.3, 0.0, 1)
local C_RUN_EMPTY_H= KColor(0.8, 0.4, 0.0, 1)

-- 选中行背景色
local SEL_R, SEL_G, SEL_B = 0.133, 0.4, 0.8
-- 悬停行背景色
local HOV_R, HOV_G, HOV_B = 0.85, 0.9, 1.0

-- 滚动条颜色
local TRACK_R, TRACK_G, TRACK_B = 0.85, 0.85, 0.85
local THUMB_R, THUMB_G, THUMB_B = 0.6, 0.6, 0.6

-- ─── 滚动条渲染辅助 ────────────────────────────────────────
--- 在指定区域右侧绘制滚动条
--- @param x number 列右边缘 x 坐标
--- @param y number 内容区域顶部 y 坐标
--- @param h number 内容区域高度
--- @param totalItems number 总条目数
--- @param visibleItems number 可见条目数
--- @param scrollOffset number 当前滚动偏移
local function drawScrollbar(x, y, h, totalItems, visibleItems, scrollOffset)
    if totalItems <= visibleItems then return end

    local trackX = x - SCROLLBAR_W
    local trackY = y
    local trackH = h

    -- 绘制轨道
    drawRect(trackX, trackY, SCROLLBAR_W, trackH, TRACK_R, TRACK_G, TRACK_B, 1)

    -- 计算滑块
    local thumbH = math.max(4, math.floor((visibleItems / totalItems) * trackH))
    local maxOffset = math.max(1, totalItems - visibleItems)
    local thumbY = trackY + math.floor((scrollOffset / maxOffset) * (trackH - thumbH))

    -- 绘制滑块
    drawRect(trackX, thumbY, SCROLLBAR_W, thumbH, THUMB_R, THUMB_G, THUMB_B, 1)
end


-- ─── 主渲染函数 ────────────────────────────────────────────

function CommandUIRender.Render(panelState)
    local L = getLayout()
    local bx, by = L.bx, L.by
    local contentY = L.contentY
    local contentH = L.contentH
    local rowH = L.rowH
    cursorFrame = (cursorFrame + 1) % 60

    -- ═══ 背景 + 边框 ═══
    drawRect(bx, by, PW, PH, 1, 1, 1, 1)
    drawRect(bx, by, PW, 1, 0.55, 0.55, 0.55)
    drawRect(bx, by + PH - 1, PW, 1, 0.55, 0.55, 0.55)
    drawRect(bx, by, 1, PH, 0.55, 0.55, 0.55)
    drawRect(bx + PW - 1, by, 1, PH, 0.55, 0.55, 0.55)

    local hov = panelState.hoveredElement

    -- ═══ 顶部栏 ═══
    drawRect(bx + 1, by + 1, PW - 2, HEADER_H - 1, 0.92, 0.92, 0.92)
    drawRect(bx, by + HEADER_H, PW, 1, 0.55, 0.55, 0.55)

    local tabY = by + 3
    local sc = (panelState.category == "stats") and C_PAGE or C_LABEL
    local cc = (panelState.category == "commands") and C_PAGE or C_LABEL
    if hov == "tab_stats" then sc = C_PAGE_HI end
    if hov == "tab_commands" then cc = C_PAGE_HI end
    drawText("[属性]", bx + PAD, tabY, sc)
    drawText("[指令]", bx + PAD + 46, tabY, cc)

    -- 活动标签下划线
    if panelState.category == "stats" then
        drawRect(bx + PAD, by + HEADER_H - 2, 38, 2, 0.0, 0.3, 0.8, 1)
    else
        drawRect(bx + PAD + 46, by + HEADER_H - 2, 54, 2, 0.0, 0.3, 0.8, 1)
    end

    -- 玩家 ID（绿色）
    local pidVal = panelState.playerIdText
    if panelState.editingPlayerId then
        pidVal = pidVal .. (cursorFrame < 30 and "_" or "")
    end
    local pc = panelState.editingPlayerId and C_PID_EDIT or C_PID
    if hov == "player_id" then pc = C_PID_HI end
    drawText("PlayerID:" .. pidVal, bx + PW - 76, tabY, pc)

    -- ═══ 列标题行 ═══
    drawRect(bx + 1, L.colHeaderY, PW - 2, COL_HEADER_H, 0.96, 0.96, 0.96)
    drawText("指令列表", bx + PAD, L.colHeaderY, C_COL_HDR)
    drawText("选项", bx + COL1_W + PAD + 1, L.colHeaderY, C_COL_HDR)
    drawText("输入", bx + COL1_W + COL2_W + PAD + 1, L.colHeaderY, C_COL_HDR)

    -- ═══ 列分隔线 ═══
    drawRect(bx + COL1_W, contentY, 1, contentH, 0.7, 0.7, 0.7)
    drawRect(bx + COL1_W + COL2_W, contentY, 1, contentH, 0.7, 0.7, 0.7)

    -- ═══ 第一列：指令列表 ═══
    local col1X = bx + PAD
    local itemList = panelState.getItemList()
    local maxVisible = math.floor(contentH / rowH)
    InputManager.maxVisibleItems = maxVisible
    ClickManager.col1Total = #itemList
    ClickManager.col1Visible = maxVisible
    local startIdx = panelState.scrollOffset + 1
    local endIdx = math.min(startIdx + maxVisible - 1, #itemList)

    for i = startIdx, endIdx do
        local item = itemList[i]
        local row = i - startIdx
        local iy = contentY + row * rowH + 1

        if item.type == "group" then
            drawRect(bx + 1, iy, COL1_W - 2, LH + 1, 0.86, 0.87, 0.92, 1)
            drawText(item.label, col1X, iy, C_GROUP)
        elseif panelState.selectedIndex == i then
            drawRect(bx + 1, iy, COL1_W - 2, LH + 1, SEL_R, SEL_G, SEL_B, 1)
            drawText(item.label, col1X + 4, iy, C_SEL_TEXT)
        elseif hov == ("item_" .. i) then
            drawRect(bx + 1, iy, COL1_W - 2, LH + 1, HOV_R, HOV_G, HOV_B, 1)
            drawText(item.label, col1X + 4, iy, C_HOVER)
        else
            drawText(item.label, col1X + 4, iy, C_NORMAL)
        end
    end

    -- 滚动指示器（文字箭头）
    if panelState.scrollOffset > 0 then
        drawText("▲", bx + COL1_W - 12, contentY, C_SCROLL)
    end
    if endIdx < #itemList then
        drawText("▼", bx + COL1_W - 12, contentY + contentH - LH, C_SCROLL)
    end

    -- 第一列滚动条
    drawScrollbar(bx + COL1_W, contentY, contentH, #itemList, maxVisible, panelState.scrollOffset)

    -- ═══ 第二列：限定符 / 选项 / 描述 ═══
    local col2X = bx + COL1_W + PAD + 1
    local def = panelState.selectedDef

    if def then
        -- [?] 帮助按钮
        local helpBtnC = (hov == "help_btn") and C_PAGE_HI or C_PAGE
        drawText("[?]", bx + COL1_W + COL2_W - 18, contentY + 1, helpBtnC)

        local modY = contentY + 2

        if def.modType == "op_value" then
            local ops = CommandDefs.Operators
            for i, op in ipairs(ops) do
                local oy = modY + (i - 1) * rowH
                if panelState.selectedModIndex == i then
                    drawRect(bx + COL1_W + 1, oy, COL2_W - 2, LH + 1, SEL_R, SEL_G, SEL_B, 1)
                    drawText(op.label, col2X, oy, C_SEL_TEXT)
                elseif hov == ("mod_" .. i) then
                    drawRect(bx + COL1_W + 1, oy, COL2_W - 2, LH + 1, HOV_R, HOV_G, HOV_B, 1)
                    drawText(op.label, col2X, oy, C_HOVER)
                else
                    drawText(op.label, col2X, oy, C_NORMAL)
                end
            end
            -- 强制模式
            local forceY = modY + #ops * rowH + 2
            local forceLabel = panelState.forceMode and "[x] 强制模式(_)" or "[ ] 强制模式(_)"
            if hov == "mod_force" then
                drawText(forceLabel, col2X, forceY, C_HOVER)
            elseif panelState.forceMode then
                drawText(forceLabel, col2X, forceY, C_FORCE_ON)
            else
                drawText(forceLabel, col2X, forceY, C_LABEL)
            end

        elseif def.modType == "enum" then
            local optionsList = CommandDefs.GetOptions(def.options)
            if optionsList then
                -- underscore modifier checkbox
                local checkboxOffset = 0
                if def.hasUnderscoreModifier then
                    local uLabel = panelState.underscoreMode
                        and ("[x] " .. (def.underscoreLabel or "Prefix(_)"))
                        or  ("[ ] " .. (def.underscoreLabel or "Prefix(_)"))
                    if hov == "mod_underscore" then
                        drawText(uLabel, col2X, modY, C_HOVER)
                    elseif panelState.underscoreMode then
                        drawText(uLabel, col2X, modY, C_FORCE_ON)
                    else
                        drawText(uLabel, col2X, modY, C_LABEL)
                    end
                    checkboxOffset = rowH + 2
                end

                local listY = modY + checkboxOffset
                local availH = contentY + contentH - listY
                local maxOpts = math.floor(availH / rowH)
                panelState.maxVisibleCol2 = maxOpts
                ClickManager.col2Total = #optionsList
                ClickManager.col2Visible = maxOpts
                local startOpt = panelState.scrollOffset2 + 1
                local endOpt = math.min(startOpt + maxOpts - 1, #optionsList)

                for i = startOpt, endOpt do
                    local opt = optionsList[i]
                    local row = i - startOpt
                    local oy = listY + row * rowH
                    if panelState.selectedOptionIndex == i then
                        drawRect(bx + COL1_W + 1, oy, COL2_W - 2, LH + 1, SEL_R, SEL_G, SEL_B, 1)
                        drawText(opt.label, col2X, oy, C_SEL_TEXT)
                    elseif hov == ("opt_" .. i) then
                        drawRect(bx + COL1_W + 1, oy, COL2_W - 2, LH + 1, HOV_R, HOV_G, HOV_B, 1)
                        drawText(opt.label, col2X, oy, C_HOVER)
                    else
                        drawText(opt.label, col2X, oy, C_NORMAL)
                    end
                end

                -- 滚动指示器
                if panelState.scrollOffset2 > 0 then
                    drawText("▲", bx + COL1_W + COL2_W - 12, listY, C_SCROLL)
                end
                if endOpt < #optionsList then
                    drawText("▼", bx + COL1_W + COL2_W - 12, listY + availH - LH, C_SCROLL)
                end

                -- 第二列滚动条
                drawScrollbar(bx + COL1_W + COL2_W, listY, availH, #optionsList, maxOpts, panelState.scrollOffset2)
            end

        elseif def.modType == "text" then
            if def.hasUnderscoreModifier then
                local uLabel = panelState.underscoreMode
                    and ("[x] " .. (def.underscoreLabel or "Prefix(_)"))
                    or  ("[ ] " .. (def.underscoreLabel or "Prefix(_)"))
                if hov == "mod_underscore" then
                    drawText(uLabel, col2X, modY, C_HOVER)
                elseif panelState.underscoreMode then
                    drawText(uLabel, col2X, modY, C_FORCE_ON)
                else
                    drawText(uLabel, col2X, modY, C_LABEL)
                end
                modY = modY + rowH + 2
            end
            drawText("输入ID或名称:", col2X, modY, C_NORMAL)
            drawText("ID或名称子串", col2X, modY + LH, C_HINT)
            local reY = modY + LH * 2 + 4
            local reC = (hov == "run_empty") and C_RUN_EMPTY_H or C_RUN_EMPTY
            drawText("[空参执行]", col2X, reY, reC)

            -- ═══ 搜索结果列表 ═══
            local searchResults = panelState.getSearchResults()
            if searchResults then
                local searchY = reY + rowH + 2
                drawRect(bx + COL1_W + 1, searchY - 1, COL2_W - 2, 1, 0.8, 0.8, 0.85)
                local availH = contentY + contentH - searchY
                local maxSearchVisible = math.floor(availH / rowH)
                panelState.maxVisibleCol3 = maxSearchVisible
                local startSR = panelState.scrollOffset3 + 1
                local endSR = math.min(startSR + maxSearchVisible - 1, #searchResults)

                for i = startSR, endSR do
                    local sr = searchResults[i]
                    local row = i - startSR
                    local sy = searchY + row * rowH
                    if hov == ("sr_" .. i) then
                        drawRect(bx + COL1_W + 1, sy, COL2_W - 2, LH + 1, HOV_R, HOV_G, HOV_B, 1)
                        drawText(sr.label, col2X, sy, C_HOVER)
                    else
                        drawText(sr.label, col2X, sy, C_NORMAL)
                    end
                end

                -- 搜索结果滚动指示器
                if panelState.scrollOffset3 > 0 then
                    drawText("▲", bx + COL1_W + COL2_W - 12, searchY, C_SCROLL)
                end
                if endSR < #searchResults then
                    drawText("▼", bx + COL1_W + COL2_W - 12, searchY + availH - LH, C_SCROLL)
                end

                -- 搜索结果滚动条
                drawScrollbar(bx + COL1_W + COL2_W, searchY, availH, #searchResults, maxSearchVisible, panelState.scrollOffset3)
            end

        elseif def.modType == "none" then
            drawText("无需参数", col2X, modY, C_LABEL)
            drawText("按回车执行", col2X, modY + LH, C_HINT)

        elseif def.modType == "value" then
            drawText("输入数值:", col2X, modY, C_NORMAL)
            drawText("数字 / inf / -inf", col2X, modY + LH, C_HINT)
            local reY = modY + LH * 2 + 4
            local reC = (hov == "run_empty") and C_RUN_EMPTY_H or C_RUN_EMPTY
            drawText("[空参执行]", col2X, reY, reC)
        end
    else
        drawText("选择一个指令", col2X, contentY + 4, C_LABEL)
    end

    -- ═══ 第三列：参数输入 + 状态信息 ═══
    local col3X = bx + COL1_W + COL2_W + PAD + 1
    local statusStartY = contentY

    if def and def.modType ~= "none" then
        drawText("参数:", col3X, contentY + 1, C_LABEL)
        local inputY = contentY + LH + 4
        local inputW = COL3_W - PAD * 2 - 2
        local inputH = LH + 4
        drawRect(bx + COL1_W + COL2_W + 2, inputY - 1, inputW, inputH, 0.88, 0.88, 0.88)
        drawRect(bx + COL1_W + COL2_W + 3, inputY, inputW - 2, inputH - 2, 0.96, 0.98, 0.96)
        local cursor = (not panelState.editingPlayerId and cursorFrame < 30) and "_" or ""
        drawText(panelState.paramText .. cursor, col3X, inputY + 1, C_INPUT)

        if def.modType == "enum" and panelState.selectedOptionIndex and panelState.selectedOptionIndex > 0 then
            local optionsList = CommandDefs.GetOptions(def.options)
            if optionsList and optionsList[panelState.selectedOptionIndex] then
                local selOpt = optionsList[panelState.selectedOptionIndex]
                drawText("已选:", col3X, inputY + inputH + 4, C_LABEL)
                drawText(selOpt.label, col3X, inputY + inputH + 4 + LH, C_DESC)
                statusStartY = inputY + inputH + 4 + LH * 2 + 4
            else
                statusStartY = inputY + inputH + 6
            end
        else
            statusStartY = inputY + inputH + 6
        end
    else
        statusStartY = contentY + 4
    end

    -- ═══ 第三列：状态信息 ═══
    if def then
        local ok, statusInfo = pcall(function() return panelState.getStatusInfo() end)
        if ok and statusInfo and #statusInfo > 0 then
            local sy = statusStartY
            drawText("状态:", col3X, sy, C_STATUS_HDR)
            sy = sy + LH + 2
            drawRect(bx + COL1_W + COL2_W + 2, sy - 1, COL3_W - PAD * 2 - 2, 1, 0.85, 0.85, 0.85)
            sy = sy + 2
            for _, info in ipairs(statusInfo) do
                drawText(info.label .. ":", col3X, sy, C_STATUS_LBL)
                sy = sy + LH
                local maxChars = math.floor((COL3_W - PAD * 2) / CHAR_W)
                local val = tostring(info.value)
                if #val > maxChars then
                    val = val:sub(1, maxChars - 2) .. ".."
                end
                drawText(val, col3X, sy, C_STATUS_VAL)
                sy = sy + LH + 2
            end
        end
    end

    -- ═══ 反馈区域 ═══
    local feedbackY = by + PH - L.bottomBarH - L.feedbackH - 2
    drawRect(bx + 1, feedbackY, PW - 2, L.feedbackH, 0.94, 0.95, 0.96)
    if panelState.feedbackTimer > 0 then
        local fbC = panelState.feedbackIsError and C_ERROR or C_SUCCESS
        local msg = panelState.feedbackMsg
        local maxChars = math.floor((PW - PAD * 4) / CHAR_W)
        if #msg > maxChars then
            msg = msg:sub(1, maxChars - 2) .. ".."
        end
        drawText(msg, bx + PAD + 1, feedbackY + 2, fbC)
    end

    -- ═══ 底部提示栏 ═══
    local hintY = by + PH - L.bottomBarH
    drawRect(bx + 1, hintY, PW - 2, L.bottomBarH - 1, 0.93, 0.93, 0.93)
    drawText("[\\]开关  [Tab]切换  [Enter]执行  分栏内按住右键可上下拖动", bx + PAD, hintY + 3, C_HINT)

    -- ═══ 设置列区域（供 ClickManager 使用）═══
    ClickManager.col1Area = { x = bx + 1, y = contentY, w = COL1_W - 2, h = contentH }
    ClickManager.col2Area = { x = bx + COL1_W + 1, y = contentY, w = COL2_W - 2, h = contentH }

    -- ═══ 帮助弹窗覆盖层 ═══
    if panelState.showHelp and def then
        drawRect(bx, by, PW, PH, 0, 0, 0, 0.4)
        local popW = PW - 20
        local popH = PH - 20
        local popX = bx + 10
        local popY = by + 10
        drawRect(popX, popY, popW, popH, 1, 1, 1, 1)
        drawRect(popX, popY, popW, 1, 0.4, 0.4, 0.5)
        drawRect(popX, popY + popH - 1, popW, 1, 0.4, 0.4, 0.5)
        drawRect(popX, popY, 1, popH, 0.4, 0.4, 0.5)
        drawRect(popX + popW - 1, popY, 1, popH, 0.4, 0.4, 0.5)
        drawText(def.label, popX + PAD, popY + 3, C_PAGE)
        local closeC = (panelState.hoveredElement == "help_close") and C_ERROR or C_LABEL
        drawText("[X]", popX + popW - 16, popY + 3, closeC)
        -- 描述文字（多行，使用像素宽度测量换行）
        local descText = def.desc or ""
        local maxPixelW = popW - PAD * 2 - 4
        local font = getFont()
        local dy = popY + LH + 8
        while #descText > 0 and dy < popY + popH - LH - 2 do
            -- 逐字符累积像素宽度，找到合适的换行点
            local lineBytes = 0
            local pos = 1
            while pos <= #descText do
                local b = descText:byte(pos)
                local charLen
                if b < 0x80 then charLen = 1
                elseif b < 0xE0 then charLen = 2
                elseif b < 0xF0 then charLen = 3
                else charLen = 4 end
                if pos + charLen - 1 > #descText then break end
                local testStr = descText:sub(1, lineBytes + charLen)
                local testW = font:GetStringWidthUTF8(testStr) * FONT_SCALE
                if testW > maxPixelW then break end
                lineBytes = lineBytes + charLen
                pos = pos + charLen
            end
            if lineBytes == 0 then break end  -- 防止死循环
            local line = descText:sub(1, lineBytes)
            descText = descText:sub(lineBytes + 1)
            drawText(line, popX + PAD + 2, dy, C_DESC)
            dy = dy + LH
        end
    end
end


-- ─── UI 元素位置信息 ───────────────────────────────────────

function CommandUIRender.GetUIElements(panelState)
    local L = getLayout()
    local bx, by = L.bx, L.by
    local contentY = L.contentY
    local contentH = L.contentH
    local rowH = L.rowH
    local elements = {}

    -- 类别标签
    table.insert(elements, {
        id = "tab_stats", x = bx + PAD, y = by + 3,
        width = 42, height = LH,
        action = function() panelState.setCategory("stats") end,
    })
    table.insert(elements, {
        id = "tab_commands", x = bx + PAD + 46, y = by + 3,
        width = 58, height = LH,
        action = function() panelState.setCategory("commands") end,
    })

    -- 玩家 ID
    table.insert(elements, {
        id = "player_id", x = bx + PW - 76, y = by + 3,
        width = 72, height = LH,
        action = function()
            if not panelState.editingPlayerId then
                panelState.playerIdText = ""
                panelState.editingPlayerId = true
            else
                panelState.confirmPlayerId()
            end
        end,
    })

    -- 第一列
    local itemList = panelState.getItemList()
    local maxVisible = math.floor(contentH / rowH)
    local startIdx = panelState.scrollOffset + 1
    local endIdx = math.min(startIdx + maxVisible - 1, #itemList)

    for i = startIdx, endIdx do
        local item = itemList[i]
        if item.type ~= "group" then
            local row = i - startIdx
            local iy = contentY + row * rowH + 1
            table.insert(elements, {
                id = "item_" .. i, x = bx + 1, y = iy,
                width = COL1_W - 2, height = LH + 1,
                action = function() panelState.selectItem(i) end,
            })
        end
    end

    -- 第二列
    local def = panelState.selectedDef
    if def then
        local modY = contentY + 2

        -- [?] 帮助按钮
        table.insert(elements, {
            id = "help_btn", x = bx + COL1_W + COL2_W - 18, y = contentY + 1,
            width = 16, height = LH,
            action = function() panelState.showHelp = true end,
        })

        if def.modType == "op_value" then
            local ops = CommandDefs.Operators
            for i, _ in ipairs(ops) do
                local oy = modY + (i - 1) * rowH
                table.insert(elements, {
                    id = "mod_" .. i, x = bx + COL1_W + 1, y = oy,
                    width = COL2_W - 2, height = LH + 1,
                    action = function() panelState.selectModifier(i) end,
                })
            end
            local forceY = modY + #ops * rowH + 2
            table.insert(elements, {
                id = "mod_force", x = bx + COL1_W + 1, y = forceY,
                width = COL2_W - 2, height = LH + 1,
                action = function() panelState.toggleForce() end,
            })

        elseif def.modType == "enum" then
            local checkboxOffset = 0
            if def.hasUnderscoreModifier then
                table.insert(elements, {
                    id = "mod_underscore", x = bx + COL1_W + 1, y = modY,
                    width = COL2_W - 2, height = LH + 1,
                    action = function() panelState.toggleUnderscore() end,
                })
                checkboxOffset = rowH + 2
            end

            local optionsList = CommandDefs.GetOptions(def.options)
            if optionsList then
                local listY = modY + checkboxOffset
                local availH = contentY + contentH - listY
                local maxOpts = math.floor(availH / rowH)
                local startOpt = panelState.scrollOffset2 + 1
                local endOpt = math.min(startOpt + maxOpts - 1, #optionsList)

                for i = startOpt, endOpt do
                    local row = i - startOpt
                    local oy = listY + row * rowH
                    table.insert(elements, {
                        id = "opt_" .. i, x = bx + COL1_W + 1, y = oy,
                        width = COL2_W - 2, height = LH + 1,
                        action = function() panelState.selectOption(i) end,
                    })
                end
            end

        elseif def.modType == "text" and def.hasUnderscoreModifier then
            table.insert(elements, {
                id = "mod_underscore", x = bx + COL1_W + 1, y = modY,
                width = COL2_W - 2, height = LH + 1,
                action = function() panelState.toggleUnderscore() end,
            })
            -- Match Render(): modY advances by rowH+2, then reY = modY + LH*2 + 4
            local adjustedModY = modY + rowH + 2
            local reY = adjustedModY + LH * 2 + 4
            table.insert(elements, {
                id = "run_empty", x = bx + COL1_W + PAD + 1, y = reY,
                width = 60, height = LH + 1,
                action = function()
                    panelState.paramText = ""
                    panelState.executeCommand()
                end,
            })
            -- Search result click elements
            local searchResults = panelState.getSearchResults()
            if searchResults then
                local searchY = reY + rowH + 2
                local availH = contentY + contentH - searchY
                local maxSearchVisible = math.floor(availH / rowH)
                local startSR = panelState.scrollOffset3 + 1
                local endSR = math.min(startSR + maxSearchVisible - 1, #searchResults)
                for si = startSR, endSR do
                    local row = si - startSR
                    local sy = searchY + row * rowH
                    table.insert(elements, {
                        id = "sr_" .. si, x = bx + COL1_W + 1, y = sy,
                        width = COL2_W - 2, height = LH + 1,
                        action = (function(idx)
                            return function() panelState.selectSearchResult(idx) end
                        end)(si),
                    })
                end
            end
        elseif def.modType == "text" then
            local reY = modY + LH * 2 + 4
            table.insert(elements, {
                id = "run_empty", x = bx + COL1_W + PAD + 1, y = reY,
                width = 60, height = LH + 1,
                action = function()
                    panelState.paramText = ""
                    panelState.executeCommand()
                end,
            })
            -- Search result click elements
            local searchResults = panelState.getSearchResults()
            if searchResults then
                local searchY = reY + rowH + 2
                local availH = contentY + contentH - searchY
                local maxSearchVisible = math.floor(availH / rowH)
                local startSR = panelState.scrollOffset3 + 1
                local endSR = math.min(startSR + maxSearchVisible - 1, #searchResults)
                for si = startSR, endSR do
                    local row = si - startSR
                    local sy = searchY + row * rowH
                    table.insert(elements, {
                        id = "sr_" .. si, x = bx + COL1_W + 1, y = sy,
                        width = COL2_W - 2, height = LH + 1,
                        action = (function(idx)
                            return function() panelState.selectSearchResult(idx) end
                        end)(si),
                    })
                end
            end
        elseif def.modType == "value" then
            local reY = modY + LH * 2 + 4
            table.insert(elements, {
                id = "run_empty", x = bx + COL1_W + PAD + 1, y = reY,
                width = 60, height = LH + 1,
                action = function()
                    panelState.paramText = ""
                    panelState.executeCommand()
                end,
            })
        end
    end

    -- 帮助弹窗关闭按钮
    if panelState.showHelp then
        local popW = PW - 20
        local popX = bx + 10
        local popY = by + 10
        table.insert(elements, {
            id = "help_close", x = popX + popW - 16, y = popY + 3,
            width = 14, height = LH,
            action = function() panelState.showHelp = false end,
        })
    end

    return elements
end

return CommandUIRender
