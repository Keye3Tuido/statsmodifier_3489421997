-- ─── Player 分组命令配置 ─────────────────────────────────────
local F = require('render.ui.defs.factories')

local function _getPlayers() return require('statsmodifier.players') end

return {
    name  = "Player",
    label = "[玩家]",
    commands = {
        { key = "blind",      label = "蒙眼",     desc = "切换蒙眼状态。蒙眼后角色无法发射眼泪。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = function(playerId)
              local ok, canShoot = pcall(function() return _getPlayers():CanShoot(playerId) end)
              if ok and canShoot ~= nil then
                  return { { label = "Status", value = canShoot and "Normal" or "Blind" } }
              elseif ok then return { { label = "Status", value = "Normal" } } end
              return nil
          end },

        { key = "bombs",      label = "炸弹",     desc = "给予玩家炸弹。支持负数和±inf。空参清空炸弹。",
          col2 = { { type = "label", text = "输入数值:" }, { type = "hint", text = "数字 / inf / -inf" }, { type = "button", id = "run_empty", label = "[空参执行]" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = F.playerNumFn(function(ep) return ep:GetNumBombs() end, "Current") },

        { key = "coins",      label = "硬币",     desc = "给予玩家硬币。支持负数和±inf。空参清空硬币。",
          col2 = { { type = "label", text = "输入数值:" }, { type = "hint", text = "数字 / inf / -inf" }, { type = "button", id = "run_empty", label = "[空参执行]" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = F.playerNumFn(function(ep) return ep:GetNumCoins() end, "Current") },

        { key = "die",        label = "死亡",     desc = "杀死当前玩家。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "gc",         label = "给予道具", desc = "给予玩家道具。输入道具ID或名称子串（不区分大小写）。前缀_将主动道具放入副手。支持添加错误道具。",
          col2 = { { type = "checkbox", id = "underscore", label = "副手(_)" }, { type = "label", text = "输入ID或名称:" }, { type = "hint", text = "ID或名称子串" }, { type = "search_results" } },
          col3 = { inputLabel = "参数:", hint = nil } },

        { key = "gigabombs",  label = "巨型炸弹", desc = "给予玩家巨型炸弹。支持负数和±inf。空参将大炸弹变回普通炸弹。",
          col2 = { { type = "label", text = "输入数值:" }, { type = "hint", text = "数字 / inf / -inf" }, { type = "button", id = "run_empty", label = "[空参执行]" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = F.playerNumFn(function(ep) return ep:GetNumGigaBombs() end, "GigaBombs") },

        { key = "golden",     label = "金掉落",   desc = "给予玩家金炸弹和金钥匙。无需参数。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "gulp",       label = "吞饰品",   desc = "玩家获得被吞下的饰品。输入饰品ID或名称子串（不区分大小写）。空参吞下当前饰品栏中的饰品。",
          col2 = { { type = "checkbox", id = "underscore", label = "金饰品(_)" }, { type = "label", text = "输入ID或名称:" }, { type = "hint", text = "ID或名称子串" }, { type = "button", id = "run_empty", label = "[空参执行]" }, { type = "search_results" } },
          col3 = { inputLabel = "参数:", hint = nil } },

        { key = "keys",       label = "钥匙",     desc = "给予玩家钥匙。支持负数和±inf。空参清空钥匙。",
          col2 = { { type = "label", text = "输入数值:" }, { type = "hint", text = "数字 / inf / -inf" }, { type = "button", id = "run_empty", label = "[空参执行]" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = F.playerNumFn(function(ep) return ep:GetNumKeys() end, "Current") },

        { key = "lost",       label = "白火形态", desc = "切换玩家灵魂形态和普通形态（白火效果）。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } },
          statusFn = function(playerId)
              local ok, hasEffect = pcall(function()
                  local ep = _getPlayers():GetPlayerById(playerId)
                  if not ep then return nil end
                  return ep:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
              end)
              if ok and hasEffect ~= nil then
                  return { { label = "Status", value = hasEffect and "Soul Form" or "Normal" } }
              end
              return nil
          end },

        { key = "playertype", label = "角色类型", desc = "修改玩家角色类型。选择或输入角色ID/名称（不区分大小写，可用子串缩写）。前缀_切换为堕化版本。空参查看当前角色。",
          col2 = { { type = "button", id = "run_empty", label = "[空参执行]" }, { type = "enum_list", options = "PlayerTypeOptions" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = function(playerId)
              local ok, info = pcall(function()
                  local ep = _getPlayers():GetPlayerById(playerId)
                  if not ep then return nil end
                  return ep:GetName() .. " (" .. tostring(ep:GetPlayerType()) .. ")"
              end)
              return (ok and info) and { { label = "Current", value = info } } or nil
          end },

        { key = "pocket",     label = "口袋道具", desc = "在每个首次访问的新房间中给予玩家一次性主动道具。输入道具ID或名称，0取消。",
          col2 = { { type = "label", text = "输入道具:" }, { type = "hint", text = "ID或名称子串" }, { type = "search_results" } },
          col3 = { inputLabel = "参数:", hint = nil } },

        { key = "rc",         label = "移除道具", desc = "移除玩家道具。输入道具ID或名称子串（不区分大小写）。前缀_优先从副手移除主动道具。支持移除错误道具。",
          col2 = { { type = "checkbox", id = "underscore", label = "副手优先(_)" }, { type = "label", text = "输入ID或名称:" }, { type = "hint", text = "ID或名称子串" }, { type = "search_results" } },
          col3 = { inputLabel = "参数:", hint = nil } },

        { key = "revive",     label = "复活",     desc = "复活玩家。只能在玩家实体被移除前使用。复活后菜单中将不能继续游戏。",
          col2 = { { type = "label", text = "无需参数" }, { type = "hint", text = "按回车执行" } } },

        { key = "wavycap",    label = "致幻层数", desc = "修改玩家迷幻蘑菇的致幻层数。空参查看当前致幻层数。",
          col2 = { { type = "label", text = "输入数值:" }, { type = "hint", text = "数字 / inf / -inf" }, { type = "button", id = "run_empty", label = "[空参执行]" } },
          col3 = { inputLabel = "参数:", hint = nil },
          statusFn = function(playerId)
              local ok, count = pcall(function()
                  local ep = _getPlayers():GetPlayerById(playerId)
                  if not ep then return nil end
                  local effects = ep:GetEffects()
                  return effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_WAVY_CAP)
                       + effects:GetNullEffectNum(NullItemID.ID_WAVY_CAP_1)
              end)
              return (ok and count ~= nil) and { { label = "WavyCap layers", value = tostring(count) } } or nil
          end },
    },
}
