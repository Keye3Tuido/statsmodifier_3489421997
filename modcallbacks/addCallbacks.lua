local Enums                 = require('definitions.enums')

local OnEvaluateCache       = require('modcallbacks.callback_functions.OnEvaluateCache')
local OnExecuteCmd          = require('modcallbacks.callback_functions.OnExecuteCmd')
local OnPEffectUpdate       = require('modcallbacks.callback_functions.OnPEffectUpdate')
-- local OnPostCollectibleSelection = require('modcallbacks.callback_functions.OnPostCollectibleSelection') -- Discarded
local OnPostGameStarted     = require('modcallbacks.callback_functions.OnPostGameStarted')
local OnPostNewRoom         = require('modcallbacks.callback_functions.OnPostNewRoom')
local OnPostPlayerInit      = require('modcallbacks.callback_functions.OnPostPlayerInit')
local OnPostPlayerRemove    = require('modcallbacks.callback_functions.OnPostPlayerRemove')
local OnPostPlayerRender    = require('modcallbacks.callback_functions.OnPostPlayerRender')
local OnPostPlayerUpdate    = require('modcallbacks.callback_functions.OnPostPlayerUpdate')
local OnPostRender          = require('modcallbacks.callback_functions.OnPostRender')
local OnPostUpdate          = require('modcallbacks.callback_functions.OnPostUpdate')

-----------------------------------------------------------------------------------------

return function(StatsModifier)
    for _,stat in pairs(Enums.Stats) do
        if(stat ~= Enums.Stats.ALL) then
            StatsModifier:AddCallback(
                ModCallbacks.MC_EVALUATE_CACHE,
                function(self,entityPlayer)
                    return OnEvaluateCache(self,entityPlayer,stat)
                end,
                Enums.CacheFlags[stat]
            )
        end
    end
    StatsModifier:AddCallback(ModCallbacks.MC_EXECUTE_CMD,OnExecuteCmd)
    StatsModifier:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE,OnPEffectUpdate)
    -- StatsModifier:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION,OnPostCollectibleSelection,PickupVariant.PICKUP_COLLECTIBLE) -- Discarded
    StatsModifier:AddCallback(ModCallbacks.MC_POST_GAME_STARTED,OnPostGameStarted)
    StatsModifier:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,OnPostNewRoom)
    StatsModifier:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT,OnPostPlayerInit)
    StatsModifier:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE,OnPostPlayerRemove,EntityType.ENTITY_PLAYER)
    StatsModifier:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER,OnPostPlayerRender)
    StatsModifier:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,OnPostPlayerUpdate)
    StatsModifier:AddCallback(ModCallbacks.MC_POST_RENDER,OnPostRender)
    StatsModifier:AddCallback(ModCallbacks.MC_POST_UPDATE,OnPostUpdate)

    -- 注册输入拦截回调：当 Command UI 打开时阻止游戏接收输入
    local CommandUI = require('render.CommandUI')
    StatsModifier:AddCallback(ModCallbacks.MC_INPUT_ACTION,CommandUI.OnInputAction)
end
