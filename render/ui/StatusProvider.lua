-- ═══════════════════════════════════════════════════════════════════════════
-- StatusProvider: 数据驱动的状态查询模块
-- ═══════════════════════════════════════════════════════════════════════════
-- 导出单一函数 getStatus(category, key, playerId)
-- 返回 { {label=..., value=...}, ... } 或 nil
--
-- 添加新命令的状态显示：在 StatusFuncs 表中添加一个条目即可。
-- 键名对应 CommandDefs 中的 statusKey 字段。
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
local function statStatus(key, playerId)
    local statId = statKeyToEnum[key]
    if not statId then return nil end

    if key == "all" then
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

-- ─── Commands 类状态查询表 ──────────────────────────────────
-- 每个条目是一个函数 function(playerId) -> statusInfo 或 nil
local StatusFuncs = {}

StatusFuncs["blind"] = function(playerId)
    local ok, isBlind = pcall(function()
        return Players:CanShoot(playerId)
    end)
    if ok and isBlind ~= nil then
        local status = isBlind and "Blind" or "Normal"
        return { { label = "Status", value = status } }
    elseif ok then
        return { { label = "Status", value = "Normal" } }
    end
    return nil
end

StatusFuncs["coins"] = function(playerId)
    local ok, count = pcall(function()
        local ep = Players:GetPlayerById(playerId)
        if not ep then return nil end
        return ep:GetNumCoins()
    end)
    if ok and count ~= nil then
        return { { label = "Current", value = tostring(count) } }
    end
    return nil
end

StatusFuncs["bombs"] = function(playerId)
    local ok, count = pcall(function()
        local ep = Players:GetPlayerById(playerId)
        if not ep then return nil end
        return ep:GetNumBombs()
    end)
    if ok and count ~= nil then
        return { { label = "Current", value = tostring(count) } }
    end
    return nil
end

StatusFuncs["keys"] = function(playerId)
    local ok, count = pcall(function()
        local ep = Players:GetPlayerById(playerId)
        if not ep then return nil end
        return ep:GetNumKeys()
    end)
    if ok and count ~= nil then
        return { { label = "Current", value = tostring(count) } }
    end
    return nil
end

StatusFuncs["wavycap"] = function(playerId)
    local ok, count = pcall(function()
        local ep = Players:GetPlayerById(playerId)
        if not ep then return nil end
        local effects = ep:GetEffects()
        local c1 = effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_WAVY_CAP)
        local c2 = effects:GetNullEffectNum(NullItemID.ID_WAVY_CAP_1)
        return c1 + c2
    end)
    if ok and count ~= nil then
        return { { label = "WavyCap layers", value = tostring(count) } }
    end
    return nil
end

StatusFuncs["challenge"] = function(_)
    local ok, cid = pcall(function()
        return Isaac.GetChallenge()
    end)
    if ok and cid ~= nil then
        local val = cid == 0 and "None (0)" or tostring(cid)
        return { { label = "Challenge", value = val } }
    end
    return nil
end

StatusFuncs["madeinheaven"] = function(_)
    local ok, mult = pcall(function()
        local ms = require('operations.manage_show')
        return ms.TimeSpeedMultiplier
    end)
    if ok and mult ~= nil then
        return { { label = "TimeSpeed", value = tostring(mult) .. "x" } }
    end
    return nil
end

StatusFuncs["bullettime"] = function(_)
    local ok, mult = pcall(function()
        local ms = require('operations.manage_show')
        return ms.TimeSpeedMultiplier
    end)
    if ok and mult ~= nil then
        return { { label = "TimeSpeed", value = tostring(mult) .. "x" } }
    end
    return nil
end

StatusFuncs["tp"] = function(_)
    local ok, info = pcall(function()
        local game = Game()
        local level = game:GetLevel()
        local roomIdx = level:GetCurrentRoomIndex()
        local roomDesc = level:GetCurrentRoomDesc()
        local roomName = roomDesc and roomDesc.Data and roomDesc.Data.Name or ""
        return tostring(roomIdx) .. (roomName ~= "" and (" " .. roomName) or "")
    end)
    if ok and info then
        return { { label = "Room", value = info } }
    end
    return nil
end

local function toggleStatus(key)
    return function(_)
        local ok, state = pcall(function()
            local ms = require('operations.manage_show')
            if key == "entity" then return ms.showEntityId
            elseif key == "id" then return ms.showPlayerId
            elseif key == "info" then return ms.showStatsInfo
            elseif key == "mouse" then return ms.showMouse
            end
        end)
        if ok and state ~= nil then
            local val = state and "ON" or "OFF"
            return { { label = "Status", value = val } }
        end
        return nil
    end
end

StatusFuncs["entity"] = toggleStatus("entity")
StatusFuncs["id"]     = toggleStatus("id")
StatusFuncs["info"]   = toggleStatus("info")
StatusFuncs["mouse"]  = toggleStatus("mouse")

StatusFuncs["eastereggs"] = function(_)
    local ok, result = pcall(function()
        local seed = Game():GetSeeds()
        local count = seed:CountSeedEffects()
        if count == 0 then
            return { { label = "Active", value = "None" } }
        end
        local items = {}
        local Utils = require('operations.utils')
        for i = 1, 79 do
            if seed:HasSeedEffect(i) then
                local name = Utils.GetEasterEggNameById(i)
                table.insert(items, { label = tostring(i), value = name })
            end
        end
        return items
    end)
    if ok and result then return result end
    return nil
end

StatusFuncs["playertype"] = function(playerId)
    local ok, info = pcall(function()
        local ep = Players:GetPlayerById(playerId)
        if not ep then return nil end
        return ep:GetName() .. " (" .. tostring(ep:GetPlayerType()) .. ")"
    end)
    if ok and info then
        return { { label = "Current", value = info } }
    end
    return nil
end

StatusFuncs["ascent"] = function(_)
    local ok, state = pcall(function()
        return Game():GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT)
    end)
    if ok and state ~= nil then
        return { { label = "Flag", value = state and "ON" or "OFF" } }
    end
    return nil
end

StatusFuncs["gigabombs"] = function(playerId)
    local ok, count = pcall(function()
        local ep = Players:GetPlayerById(playerId)
        if not ep then return nil end
        return ep:GetNumGigaBombs()
    end)
    if ok and count ~= nil then
        return { { label = "GigaBombs", value = tostring(count) } }
    end
    return nil
end

StatusFuncs["lost"] = function(playerId)
    local ok, hasEffect = pcall(function()
        local ep = Players:GetPlayerById(playerId)
        if not ep then return nil end
        return ep:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
    end)
    if ok and hasEffect ~= nil then
        return { { label = "Status", value = hasEffect and "Soul Form" or "Normal" } }
    end
    return nil
end

StatusFuncs["wrap"] = function(_)
    if _StatsModifier_IsWrapped and _StatsModifier_IsWrapped() then
        return { { label = "Status", value = "Wrapped" } }
    else
        return { { label = "Status", value = "Unwrapped" } }
    end
end

StatusFuncs["version"] = function(_)
    local ok, info = pcall(function()
        local sm = require('statsmodifier.statsmodifier')
        return {
            { label = "Version", value = sm.Version or "?" },
            { label = "Path", value = sm.Path or "?" },
        }
    end)
    if ok and info then return info end
    return nil
end

-- ─── 公开接口 ───────────────────────────────────────────────

--- 获取指令的实时状态信息
--- @param category string "stats" | "commands"
--- @param key string 指令的 statusKey
--- @param playerId number 玩家 ID
--- @return table|nil { {label=..., value=...}, ... }
function StatusProvider.getStatus(category, key, playerId)
    if not key then return nil end

    if category == "stats" then
        return statStatus(key, playerId)
    end

    if category == "commands" then
        local fn = StatusFuncs[key]
        if fn then
            return fn(playerId)
        end
    end

    return nil
end

return StatusProvider
