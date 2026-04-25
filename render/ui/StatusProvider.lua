-- ═══════════════════════════════════════════════════════════════════════════
-- StatusProvider: 状态查询模块
-- ═══════════════════════════════════════════════════════════════════════════
-- 导出单一函数 getStatus(category, def, playerId)
-- 返回 { {label=..., value=...}, ... } 或 nil
--
-- 命令的状态查询函数 statusFn 现已直接内联在 CommandDefs.lua 的每条指令
-- 定义中，无需在此处单独注册。
-- Stat 属性的状态由本模块的 statStatus 统一处理。
-- ═══════════════════════════════════════════════════════════════════════════

local Players = require('statsmodifier.players')
local Enums   = require('definitions.enums')

local StatusProvider = {}

-- ─── Stat 枚举映射 ──────────────────────────────────────────
local statKeyToEnum = {
    speed     = Enums.Stats.SPEED,
    tears     = Enums.Stats.TEARS,
    damage    = Enums.Stats.DAMAGE,
    range     = Enums.Stats.RANGE,
    shotspeed = Enums.Stats.SHOTSPEED,
    luck      = Enums.Stats.LUCK,
    fly       = Enums.Stats.FLYING,
    size      = Enums.Stats.SIZE,
    all       = Enums.Stats.ALL,
}

local opNames = { [1] = "SET", [2] = "PLUS", [3] = "TIMES" }

-- ─── Stats 类状态查询 ───────────────────────────────────────
local function statStatus(statKey, playerId)
    local statId = statKeyToEnum[statKey]
    if not statId then return nil end

    if statKey == "all" then
        return { { label = "Info", value = "清除所有属性修改" } }
    end

    local ok, val, force = pcall(function()
        return Players:GetPlayerStat(playerId, nil, statId)
    end)
    if ok and val ~= nil then
        local opOk, op = pcall(function()
            return Players:GetOp(playerId, nil, statId)
        end)
        local opStr = (opOk and op) and (opNames[op] or tostring(op)) or "?"
        local forceStr = force and " [forced]" or ""
        return { { label = "Current", value = tostring(val) .. " " .. opStr .. forceStr } }
    else
        return { { label = "Current", value = "未修改" } }
    end
end

-- ─── 公开接口 ───────────────────────────────────────────────

--- 获取指令的实时状态信息
--- @param category string "stats" | "commands"
--- @param def table 指令定义表（来自 CommandDefs）
--- @param playerId number 玩家 ID
--- @return table|nil { {label=..., value=...}, ... }
function StatusProvider.getStatus(category, def, playerId)
    if not def then return nil end

    if category == "stats" then
        return statStatus(def.key, playerId)
    end

    if category == "commands" and def.statusFn then
        return def.statusFn(playerId)
    end

    return nil
end

return StatusProvider
