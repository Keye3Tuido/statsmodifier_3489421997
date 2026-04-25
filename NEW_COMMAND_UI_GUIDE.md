# 新增指令到配置 UI：完整流程（手写版）

本文描述本仓库"新增一条命令并接入三列 UI"的完整流程。

重要约束：
- 不再使用任何 UI 模板函数。
- 每条命令必须手写 `col2` 和 `col3`。
- `col2` / `col3` 的文案也在命令条目内直接维护。

---

## 0. 流程总览

1. 在 `definitions/enums.lua` 增加命令枚举（建议）
2. 在 `operations/commands/` 新建命令实现
3. 在 `operations/commandslist.lua` 注册路由
4. 在 `render/ui/defs/` 对应分组文件中手写该命令的 `col2` / `col3`
5. 如需枚举选项，在 `render/ui/defs/EnumOptions.lua` 新增选项表
6. 如需引擎回调，再更新 `modcallbacks/addCallbacks.lua`
7. 最后做最小联调检查

---

## 1. 增加枚举（可选但建议）

文件：`definitions/enums.lua`

```lua
Enums.Commands = {
    -- ...existing
    MYCOMMAND = 108,
}
```

说明：
- 编号必须唯一。
- 枚举名建议与命令语义一致。

---

## 2. 新建命令实现

文件：`operations/commands/mycommand.lua`

```lua
local function mycommand(self, playerId, entityPlayer, val, valArg)
    -- self: manage_commands 上下文
    -- val: 只有 valArg 可转整数时才有值，否则是 nil

    if valArg == "" then
        Isaac.ConsoleOutput("mycommand empty\n")
        return true
    end

    Isaac.ConsoleOutput("mycommand arg=" .. tostring(valArg) .. "\n")
    return true
end

return mycommand
```

返回约定：
- `true`：执行成功
- `false`：执行失败

---

## 3. 注册命令路由

文件：`operations/commandslist.lua`

### 3.1 注册函数

```lua
local Funcs = {
    -- ...existing
    mycommand = require('operations.commands.mycommand'),
}
```

### 3.2 注册全名和缩写

```lua
local CommandsList = {
    -- ...existing
    ['mycommand'] = Funcs.mycommand,
    ['mc'] = Funcs.mycommand,
}
```

---

## 4. 手写 UI 条目（核心）

### 4.0 CommandDefs 文件结构

CommandDefs 已拆分为以下子文件：

| 文件 | 内容 |
|------|------|
| `render/ui/defs/DisplayCmds.lua` | Display 分组（entity / id / info / mouse） |
| `render/ui/defs/PlayerCmds.lua`  | Player 分组（玩家状态类指令） |
| `render/ui/defs/GameCmds.lua`    | Game 分组（游戏流程类指令） |
| `render/ui/defs/OtherCmds.lua`   | Other 分组（杂项指令） |
| `render/ui/defs/EnumOptions.lua` | 可列举选项数据（ChallengeOptions / EasterEggOptions 等） |
| `render/ui/defs/StatsDefs.lua`   | 属性命令列表（Stats / Operators / ForceFlag） |
| `render/ui/defs/factories.lua`   | 状态查询辅助工厂（playerNumFn / showToggleFn） |
| `render/ui/CommandDefs.lua`      | 汇总入口，只做 require 和组装；**勿在此直接添加命令** |

新增命令应追加到对应分组文件的 `commands` 数组中。

### 4.1 手写条目最小模板

在对应分组文件（如 `render/ui/defs/GameCmds.lua`）的 `commands` 数组末尾追加：

```lua
{ key = "mycommand", label = "我的命令", desc = "命令说明",
  col2 = {
      { type = "label", text = "输入参数:" },
      { type = "hint", text = "提示文本" },
      { type = "button", id = "run_empty", label = "[空参执行]" },
      { type = "search_results" },
  },
  col3 = { inputLabel = "参数:", hint = nil },
  statusFn = nil,
}
```

### 4.2 支持的控件类型

`col2` 支持：
- `{ type = "op_list" }` — 运算符列表（SET / PLUS / TIMES），用于属性修改类
- `{ type = "checkbox", id = "force"|"underscore", label = "..." }` — 复选框
- `{ type = "button", id = "run_empty", label = "..." }` — 空参执行按钮
- `{ type = "label", text = "..." }` — 普通说明文字
- `{ type = "hint", text = "..." }` — 灰色提示文字
- `{ type = "enum_list", options = "XXXOptions" }` — 可列举选项（占满剩余高度，必须放最后）
- `{ type = "search_results" }` — 搜索结果（占满剩余高度，必须放最后）

`col3` 结构：
- `{ inputLabel = "参数:", hint = "提示" }` — 显示输入框
- 或 `nil` — 不显示输入框（无参命令）

### 4.3 枚举选项表

当使用 `enum_list` 时，在 `render/ui/defs/EnumOptions.lua` 新增选项表：

```lua
-- 文件：render/ui/defs/EnumOptions.lua
local EnumOptions = {}
-- ... 其他选项 ...
EnumOptions.MyModeOptions = {
    { value = "0", label = "0: Off" },
    { value = "1", label = "1: On" },
}
return EnumOptions
```

然后在命令的 `col2` 中引用选项表的键名：

```lua
col2 = {
    { type = "button", id = "run_empty", label = "[空参执行]" },
    { type = "enum_list", options = "MyModeOptions" },
}
```

### 4.4 statusFn（可选）

```lua
statusFn = function(playerId)
    return {
        { label = "Status", value = "ON" },
        { label = "Count", value = "3" },
    }
end
```

---

## 5. 可选：新增回调

文件：`modcallbacks/addCallbacks.lua`

仅当命令必须依赖引擎事件时才新增：

```lua
local OnMyCallback = require('modcallbacks.callback_functions.OnMyCallback')

return function(StatsModifier)
    -- ...existing
    StatsModifier:AddCallback(ModCallbacks.MC_POST_UPDATE, OnMyCallback)
end
```

---

## 6. 两个完整示例

### 示例 A：文本搜索命令

在 `render/ui/defs/PlayerCmds.lua` 的 `commands` 数组中追加：

```lua
{ key = "myfind", label = "查找", desc = "按名称查找",
  col2 = {
      { type = "checkbox", id = "underscore", label = "副手(_)" },
      { type = "label", text = "输入关键字:" },
      { type = "hint", text = "名称子串" },
      { type = "button", id = "run_empty", label = "[空参执行]" },
      { type = "search_results" },
  },
  col3 = { inputLabel = "参数:", hint = "支持中文/英文" },
}
```

### 示例 B：枚举选择命令

第一步，在 `render/ui/defs/EnumOptions.lua` 添加：

```lua
EnumOptions.MyModeOptions = {
    { value = "0", label = "0: 关闭" },
    { value = "1", label = "1: 开启" },
}
```

第二步，在 `render/ui/defs/GameCmds.lua` 的 `commands` 中追加：

```lua
{ key = "mymode", label = "模式", desc = "切换模式",
  col2 = {
      { type = "button", id = "run_empty", label = "[空参执行]" },
      { type = "enum_list", options = "MyModeOptions" },
  },
  col3 = { inputLabel = "参数:", hint = nil },
}
```

---

## 7. 最小验收清单

1. 命令全名可执行，缩写（若有）可执行
2. 第一列能看到新命令，分组正确
3. 第二列控件顺序和文案正确
4. 第三列输入标签和提示正确
5. Enter 执行行为正确（含空参）
6. 枚举/搜索列表滚动正常
7. `statusFn` 显示正确（若配置）
8. 不影响其他命令（解耦回归）

---

## 8. 常见问题

Q1：命令显示了但执行不到？
- 检查 `commandslist.lua` 是否注册了 `Funcs` 和 `CommandsList` 映射。

Q2：枚举列表不显示？
- 检查 `col2` 是否存在 `enum_list`。
- 检查 `EnumOptions.lua` 中选项表键名是否与 `options` 字段一致。

Q3：下划线前缀不生效？
- 检查 `col2` 是否有 `checkbox` 且 `id = "underscore"`。
- 空参时不会拼接前缀。

Q4：新增命令后 UI 报错？
- 检查 `col2` 是否是数组结构。
- 检查每个控件字段是否完整（例如 `button` 必须有 `id` 和 `label`）。
- 确认枚举选项表已在 `EnumOptions.lua` 中定义并已 `return EnumOptions`。