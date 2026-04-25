-- ─── 状态查询辅助工厂（惰性 require，避免循环依赖）────────────
local function _getPlayers()    return require('statsmodifier.players') end
local function _getManageShow() return require('operations.manage_show') end

-- 工厂：查询玩家数值属性，返回 { {label=..., value=...} } 或 nil
local function playerNumFn(getter, label)
    return function(playerId)
        local ok, count = pcall(function()
            local ep = _getPlayers():GetPlayerById(playerId)
            if not ep then return nil end
            return getter(ep)
        end)
        return (ok and count ~= nil) and { { label = label, value = tostring(count) } } or nil
    end
end

-- 工厂：查询显示开关状态（entity/id/info/mouse）
local function showToggleFn(showKey)
    local keyGetters = {
        entity = function(ms) return ms.showEntityId end,
        id     = function(ms) return ms.showPlayerId end,
        info   = function(ms) return ms.showStatsInfo end,
        mouse  = function(ms) return ms.showMouse end,
    }
    return function(_)
        local getter = keyGetters[showKey]
        if not getter then return nil end
        local ok, state = pcall(function() return getter(_getManageShow()) end)
        return (ok and state ~= nil) and { { label = "Status", value = state and "ON" or "OFF" } } or nil
    end
end

-- 工厂：查询时间倍速
local function timeSpeedFn()
    return function(_)
        local ok, mult = pcall(function() return _getManageShow().TimeSpeedMultiplier end)
        return (ok and mult ~= nil) and { { label = "TimeSpeed", value = tostring(mult) .. "x" } } or nil
    end
end

return {
    playerNumFn  = playerNumFn,
    showToggleFn = showToggleFn,
    timeSpeedFn  = timeSpeedFn,
}
