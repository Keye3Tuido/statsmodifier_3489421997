-- 安全包装切换指令
-- 包装 AddPriorityCallback、RemoveCallback、RunCallback、RunCallbackWithParam 和 GetCallbacks
-- 使回调函数报错时不会导致游戏崩溃

local D = require('debug')

-- 包装状态（模块级局部变量）
local isWrapped = false
local origFuncs = {}   -- 原始函数 -> 包装函数 的映射
local wrapMap = {}     -- 包装函数 -> 原始函数 的反向映射
local hookedCallbacks = {}  -- 已处理过的回调 ID 集合

--- 将一个函数包装为安全版本（pcall 包裹）
local function wrapFunc(f)
    if wrapMap[f] then return f end  -- 已经是包装函数
    if origFuncs[f] then return origFuncs[f] end  -- 已有包装版本
    local function safe(...)
        local results = {pcall(f, ...)}
        if results[1] then
            return table.unpack(results, 2)
        end
        -- 报错时静默吞掉，不崩溃
    end
    origFuncs[f] = safe
    wrapMap[safe] = f
    return safe
end

--- 包装指定回调 ID 下的所有已注册函数
local function wrapCallbackId(callbackId)
    local callbacks = Isaac.GetCallbacks(callbackId)
    for _, entry in pairs(callbacks) do
        local f = entry.Function
        if f and not wrapMap[f] then
            entry.Function = wrapFunc(f)
        end
    end
    hookedCallbacks[callbackId] = true
end

--- 解包指定回调 ID 下的所有函数（恢复原始版本）
local function unwrapCallbackId(callbackId)
    local callbacks = Isaac.GetCallbacks(callbackId)
    for _, entry in pairs(callbacks) do
        local f = entry.Function
        if f and wrapMap[f] then
            entry.Function = wrapMap[f]
        end
    end
end

--- 开启安全包装
local function doWrap()
    if isWrapped then return end
    isWrapped = true

    -- 包装所有已注册的回调
    for _, callbackId in pairs(ModCallbacks) do
        wrapCallbackId(callbackId)
    end

    -- 设置 debug hook 拦截新注册的回调，自动包装
    D.sethook(function(event)
        local info = D.getinfo(2, 'f')
        if not info then return end
        local caller = info.func

        -- 拦截 AddPriorityCallback / AddCallback：包装第 4 个参数（回调函数）
        if caller == Isaac.AddPriorityCallback or caller == Isaac.AddCallback then
            local _, callbackId = D.getlocal(2, 2)
            if callbackId then
                -- 标记此回调 ID 需要处理
                if not hookedCallbacks[callbackId] then
                    hookedCallbacks[callbackId] = true
                end
            end
            local _, f = D.getlocal(2, 4)
            if f and not wrapMap[f] then
                D.setlocal(2, 4, wrapFunc(f))
            end

        -- 拦截 RemoveCallback：用包装版本查找
        elseif caller == Isaac.RemoveCallback then
            local _, f = D.getlocal(2, 3)
            if f and not wrapMap[f] and origFuncs[f] then
                D.setlocal(2, 3, origFuncs[f])
            end

        -- 拦截 GetCallbacks / RunCallback / RunCallbackWithParam：确保返回包装版本
        elseif caller == Isaac.GetCallbacks
            or caller == Isaac.RunCallback
            or caller == Isaac.RunCallbackWithParam then
            local _, callbackId = D.getlocal(2, 1)
            if callbackId and not hookedCallbacks[callbackId] then
                wrapCallbackId(callbackId)
            end
        end
    end, 'c')

    Isaac.ConsoleOutput('StatsModifier: Wrapped.\n')
end

--- 关闭安全包装
local function doUnwrap()
    if not isWrapped then return end

    -- 清除 debug hook
    D.sethook()

    -- 恢复所有回调的原始函数
    for callbackId, _ in pairs(hookedCallbacks) do
        unwrapCallbackId(callbackId)
    end

    -- 清理状态
    origFuncs = {}
    wrapMap = {}
    hookedCallbacks = {}
    isWrapped = false

    Isaac.ConsoleOutput('StatsModifier: Unwrapped.\n')
end

--- 查询当前包装状态
local function isCurrentlyWrapped()
    return isWrapped
end

-- 导出查询函数供 StatusProvider 使用
-- 挂在全局表上以便跨模块访问
_StatsModifier_IsWrapped = isCurrentlyWrapped

local function wrap(self, playerId, entityPlayer, val, valArg)
    if isWrapped then
        doUnwrap()
    else
        doWrap()
    end
    return true
end

return wrap
