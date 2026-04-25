-- ─── 属性列表及操作符定义 ────────────────────────────────────
-- modType 仅供 PanelState.executeCommand stats 路径使用（渲染已改用 col2/col3）

local StatsDefs = {}

-- 属性命令列表
StatsDefs.Stats = {
    { key = "speed",     label = "移速",     desc = "修改玩家移动速度。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。", modType = "op_value",
      col2 = { { type = "op_list" }, { type = "checkbox", id = "force", label = "强制模式(_)" }, { type = "button", id = "run_empty", label = "[空参执行]" } }, col3 = { inputLabel = "参数:", hint = nil } },
    { key = "tears",     label = "射速",     desc = "修改玩家射速。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。", modType = "op_value",
      col2 = { { type = "op_list" }, { type = "checkbox", id = "force", label = "强制模式(_)" }, { type = "button", id = "run_empty", label = "[空参执行]" } }, col3 = { inputLabel = "参数:", hint = nil } },
    { key = "damage",    label = "伤害",     desc = "修改玩家伤害。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。", modType = "op_value",
      col2 = { { type = "op_list" }, { type = "checkbox", id = "force", label = "强制模式(_)" }, { type = "button", id = "run_empty", label = "[空参执行]" } }, col3 = { inputLabel = "参数:", hint = nil } },
    { key = "range",     label = "射程",     desc = "修改玩家射程。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。", modType = "op_value",
      col2 = { { type = "op_list" }, { type = "checkbox", id = "force", label = "强制模式(_)" }, { type = "button", id = "run_empty", label = "[空参执行]" } }, col3 = { inputLabel = "参数:", hint = nil } },
    { key = "shotspeed", label = "弹速",     desc = "修改玩家弹速。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。", modType = "op_value",
      col2 = { { type = "op_list" }, { type = "checkbox", id = "force", label = "强制模式(_)" }, { type = "button", id = "run_empty", label = "[空参执行]" } }, col3 = { inputLabel = "参数:", hint = nil } },
    { key = "luck",      label = "幸运",     desc = "修改玩家幸运值。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。", modType = "op_value",
      col2 = { { type = "op_list" }, { type = "checkbox", id = "force", label = "强制模式(_)" }, { type = "button", id = "run_empty", label = "[空参执行]" } }, col3 = { inputLabel = "参数:", hint = nil } },
    { key = "fly",       label = "飞行",     desc = "修改玩家飞行能力。非0赋予飞行，0剥夺飞行，空参清除修改。", modType = "value",
      col2 = { { type = "label", text = "输入0/1:" }, { type = "hint", text = "0剥夺 / 非0赋予" }, { type = "button", id = "run_empty", label = "[空参执行]" } }, col3 = { inputLabel = "参数:", hint = nil } },
    { key = "size",      label = "体型",     desc = "修改玩家体型。支持设置(=)、增加(+)、乘以(*)三种操作。空参取消修改。", modType = "op_value",
      col2 = { { type = "op_list" }, { type = "checkbox", id = "force", label = "强制模式(_)" }, { type = "button", id = "run_empty", label = "[空参执行]" } }, col3 = { inputLabel = "参数:", hint = nil } },
    { key = "all",       label = "全部清除", desc = "清除指定玩家的所有属性修改。无需参数。", modType = "none",
      col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },
}

-- 操作符列表（用于 op_value 类型）
StatsDefs.Operators = {
    { key = "",  label = "SET(=)",   desc = "设置为指定值" },
    { key = "+", label = "PLUS(+)",  desc = "在当前值上增加" },
    { key = "*", label = "TIMES(*)", desc = "乘以指定倍数" },
}

-- 强制模式标记
StatsDefs.ForceFlag = { key = "_", label = "强制模式(_)", desc = "强制模式,不参与属性计算" }

return StatsDefs
