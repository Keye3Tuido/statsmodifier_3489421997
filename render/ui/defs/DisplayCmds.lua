-- ─── Display 分组命令配置 ────────────────────────────────────
local F = require('render.ui.defs.factories')

return {
    name  = "Display",
    label = "[显示]",
    commands = {
        { key = "entity", label = "实体显示", desc = "打开/关闭实体信息显示。显示所有实体的类型和属性。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = F.showToggleFn("entity") },
        { key = "id",     label = "ID显示",   desc = "打开/关闭玩家ID显示。在每个玩家头顶显示其ID。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = F.showToggleFn("id") },
        { key = "info",   label = "属性显示", desc = "打开/关闭玩家属性修改状态显示。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = F.showToggleFn("info") },
        { key = "mouse",  label = "鼠标显示", desc = "打开/关闭鼠标位置三维度坐标显示（世界/屏幕/渲染坐标）。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = F.showToggleFn("mouse") },
    },
}
