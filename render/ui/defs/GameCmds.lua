-- ─── Game 分组命令配置 ───────────────────────────────────────
local F = require('render.ui.defs.factories')

return {
    name  = "Game",
    label = "[游戏]",
    commands = {
        { key = "ascent",          label = "回溯标签",     desc = "切换回溯线标签。该值决定了陵墓II/炼狱II的头目房是否生成爸爸的便条。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = function(_)
              local ok, state = pcall(function()
                  return Game():GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT)
              end)
              return (ok and state ~= nil) and { { label = "Flag", value = state and "ON" or "OFF" } } or nil
          end },

        { key = "bullettime",      label = "游戏减速",     desc = "减速游戏。输入0~1之间的倍速值。空参恢复正常速度。",
          col2 = { { type = "label", text = "输入倍速:" }, { type = "hint", text = "0~1之间的值" }, { type = "button", id = "run_empty", label = "[空参执行]" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = F.timeSpeedFn() },

        { key = "challenge",       label = "切换挑战",     desc = "切换当前挑战标签。选择或输入挑战ID/名称（不区分大小写，可用子串缩写）。0清除挑战。空参查看当前挑战。",
          col2 = { { type = "button", id = "run_empty", label = "[空参执行]" }, { type = "enum_list", options = "ChallengeOptions" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = function(_)
              local ok, cid = pcall(function() return Isaac.GetChallenge() end)
              if ok and cid ~= nil then
                  return { { label = "Challenge", value = cid == 0 and "None (0)" or tostring(cid) } }
              end
              return nil
          end },

        { key = "clean",           label = "清空状态修改", desc = "清除所有玩家的所有属性修改。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "delirium",        label = "精神错乱",     desc = "如果当前层存在精神错乱，则移除迷宫诅咒并传送至精神错乱房间。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "eastereggs",      label = "彩蛋种子",     desc = "添加/删除彩蛋种子效果。选择添加，勾选删除模式(_)则删除。0清除所有效果。空参查看当前效果。",
          col2 = { { type = "button", id = "run_empty", label = "[空参执行]" }, { type = "checkbox", id = "underscore", label = "删除模式(_)" }, { type = "enum_list", options = "EasterEggOptions" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = function(_)
              local ok, result = pcall(function()
                  local seed = Game():GetSeeds()
                  local count = seed:CountSeedEffects()
                  if count == 0 then return { { label = "Active", value = "None" } } end
                  local items = {}
                  local Utils = require('operations.utils')
                  for i = 1, 79 do
                      if seed:HasSeedEffect(i) then
                          table.insert(items, { label = tostring(i), value = Utils.GetEasterEggNameById(i) })
                      end
                  end
                  return items
              end)
              return (ok and result) and result or nil
          end },

        { key = "finish",          label = "结束游戏",     desc = "结束当前游戏。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "icansee",         label = "全图揭示",     desc = "移除诅咒、揭示全图、显示究极隐藏房位置、显示所有问号道具图标。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "madeinheaven",    label = "游戏加速",     desc = "加速游戏。输入不小于1的倍速值。空参恢复正常速度。",
          col2 = { { type = "label", text = "输入倍速:" }, { type = "hint", text = "不小于1的值" }, { type = "button", id = "run_empty", label = "[空参执行]" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = F.timeSpeedFn() },

        { key = "mirrormineshaft", label = "镜子/矿井",    desc = "如果当前层存在镜子房间或矿井房间，则移除迷宫诅咒并传送至对应房间。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "rush",            label = "车轮战入口",   desc = "尝试在当前房间生成头目车轮战(BossRush)和蓝子宫(BlueWomb)入口。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "seeds",           label = "修改种子",     desc = "不重新开始游戏，修改当前游戏的种子。大小写不敏感、空格不敏感，支持彩蛋种子。",
          col2 = { { type = "label", text = "输入种子:" }, { type = "hint", text = "种子代码" }, { type = "search_results" } },
          col3 = { inputLabel = "参数:", hint = nil } },

        { key = "timecounter",     label = "计时器",       desc = "修改游戏内计时器（单位：秒）。支持负数和±inf。",
          col2 = { { type = "label", text = "输入秒数:" }, { type = "hint", text = "整数 / ±inf" }, { type = "button", id = "run_empty", label = "[空参执行]" } },
          col3 = { inputLabel = "参数:", hint = nil } },

        { key = "tp",              label = "传送",         desc = "传送玩家至指定房间。输入房间坐标或类型名称（不区分大小写，可用子串缩写）。空参显示当前房间信息。",
          col2 = { { type = "button", id = "run_empty", label = "[空参执行]" }, { type = "enum_list", options = "TPOptions" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = function(_)
              local ok, info = pcall(function()
                  local level = Game():GetLevel()
                  local roomIdx = level:GetCurrentRoomIndex()
                  local roomDesc = level:GetCurrentRoomDesc()
                  local roomName = roomDesc and roomDesc.Data and roomDesc.Data.Name or ""
                  return tostring(roomIdx) .. (roomName ~= "" and (" " .. roomName) or "")
              end)
              return (ok and info) and { { label = "Room", value = info } } or nil
          end },

        { key = "uncovereverything", label = "揭示全部",   desc = "移除诅咒，显示该层当前维度所有房间和红房间，并开启所有红房间的门和隐藏房的门。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },
    },
}
