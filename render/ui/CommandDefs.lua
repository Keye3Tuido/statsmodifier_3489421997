-- ═══════════════════════════════════════════════════════════════════════════
-- CommandDefs: 指令 UI 配置汇总入口（各分组独立配置文件，本文件只做组装）
-- ═══════════════════════════════════════════════════════════════════════════
--
-- 【文件结构】
--   render/ui/defs/factories.lua   → 状态查询辅助工厂（playerNumFn / showToggleFn / timeSpeedFn）
--   render/ui/defs/EnumOptions.lua → 可列举选项数据（ChallengeOptions / EasterEggOptions 等）
--   render/ui/defs/StatsDefs.lua   → 属性命令列表（Stats / Operators / ForceFlag）
--   render/ui/defs/DisplayCmds.lua → Display 分组
--   render/ui/defs/PlayerCmds.lua  → Player 分组
--   render/ui/defs/GameCmds.lua    → Game 分组
--   render/ui/defs/OtherCmds.lua   → Other 分组
--
-- 【增加新指令】请参见 NEW_COMMAND_UI_GUIDE.md
-- ═══════════════════════════════════════════════════════════════════════════

local CommandDefs = {}

-- ─── 加载各子模块 ────────────────────────────────────────────
local EnumOptions = require('render.ui.defs.EnumOptions')
local StatsDefs   = require('render.ui.defs.StatsDefs')

-- 将枚举选项表挂载到 CommandDefs，供 GetOptions(key) 按字符串查找
for k, v in pairs(EnumOptions) do CommandDefs[k] = v end

-- 属性相关数据
CommandDefs.Stats     = StatsDefs.Stats
CommandDefs.Operators = StatsDefs.Operators
CommandDefs.ForceFlag = StatsDefs.ForceFlag

-- 命令分组
CommandDefs.CommandGroups = {
    require('render.ui.defs.DisplayCmds'),
    require('render.ui.defs.PlayerCmds'),
    require('render.ui.defs.GameCmds'),
    require('render.ui.defs.OtherCmds'),
}

-- ─── col2 工具函数 ───────────────────────────────────────────
-- 判断 def 的 col2 是否包含指定类型（可选匹配 id）的控件
function CommandDefs.col2HasType(def, widgetType, widgetId)
    if not def or not def.col2 then return false end
    for _, w in ipairs(def.col2) do
        if w.type == widgetType then
            if widgetId == nil or w.id == widgetId then return true end
        end
    end
    return false
end

-- 从 def 的 col2 中取出 enum_list 对应的选项表
function CommandDefs.col2GetEnumOptions(def)
    if not def or not def.col2 then return nil end
    for _, w in ipairs(def.col2) do
        if w.type == "enum_list" then return CommandDefs.GetOptions(w.options) end
    end
    return nil
end

-- ─── 获取选项表 ──────────────────────────────────────────────
function CommandDefs.GetOptions(optionsKey)
    if not optionsKey then return nil end
    return CommandDefs[optionsKey]
end

-- ─── 构建扁平命令列表（带分组标记，用于第一列渲染）──────────
-- 每个条目: { type="group"|"cmd", ... }
CommandDefs._flatCommands = nil
function CommandDefs.GetFlatCommands()
    if CommandDefs._flatCommands then return CommandDefs._flatCommands end
    CommandDefs._flatCommands = {}
    for _, group in ipairs(CommandDefs.CommandGroups) do
        -- 分组标题
        table.insert(CommandDefs._flatCommands, {
            type = "group",
            label = group.label,
        })
        -- 组内命令
        for _, cmd in ipairs(group.commands) do
            table.insert(CommandDefs._flatCommands, {
                type     = "cmd",
                key      = cmd.key,
                label    = cmd.label,
                desc     = cmd.desc,
                col2     = cmd.col2,
                col3     = cmd.col3,
                statusFn = cmd.statusFn,
            })
        end
    end
    return CommandDefs._flatCommands
end

return CommandDefs
