local function anonymous(self, playerId, entityPlayer, val, valArg)
    local count = 0
    for _, callbackId in pairs(ModCallbacks) do
        local callbacks = Isaac.GetCallbacks(callbackId)
        for x = #callbacks, 1, -1 do
            local m = callbacks[x].Mod
            if not (m and m.Name) then
                Isaac.RemoveCallback(m, callbackId, callbacks[x].Function)
                count = count + 1
            end
        end
    end
    Isaac.ConsoleOutput('Removed ' .. count .. ' anonymous callbacks.\n')
    return true
end
return anonymous
