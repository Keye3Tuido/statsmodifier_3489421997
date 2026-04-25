-- ─── Other 分组命令配置 ──────────────────────────────────────

return {
    name  = "Other",
    label = "[其他]",
    commands = {
        { key = "version",   label = "版本号",       desc = "在控制台输出模组版本号和模组绝对路径。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = function(_)
              local ok, info = pcall(function()
                  local sm = require('statsmodifier.statsmodifier')
                  return {
                      { label = "Version", value = sm.Version or "?" },
                      { label = "Path",    value = sm.Path    or "?" },
                  }
              end)
              return (ok and info) and info or nil
          end },

        { key = "wrap",      label = "安全包装",     desc = "切换安全包装状态。包装所有回调函数，使回调报错时不会导致游戏崩溃。使用debug库拦截新注册的回调并自动包装。对Repentogon不生效。可能影响性能。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = function(_)
              local wrapped = _StatsModifier_IsWrapped and _StatsModifier_IsWrapped()
              return { { label = "Status", value = wrapped and "Wrapped" or "Unwrapped" } }
          end },

        { key = "anonymous", label = "清理匿名回调", desc = "删除所有匿名模组的回调函数。用于清理未正确注销的回调。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },
    },
}
