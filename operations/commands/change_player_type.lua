local GetPlayerIdByName = require('operations.utils').GetPlayerIdByName
local function change_player_type(self, playerId, entityPlayer, val, valArg)
    local taintedPrefix=''
    if(valArg=='')then
        local type=entityPlayer:GetPlayerType()
        for k,v in pairs(PlayerType)do
            if v==type then
                taintedPrefix=k:match('_B$') and '(Tainted)' or ''
                break
            end
        end
        Isaac.ConsoleOutput('Player'..playerId..' : '..taintedPrefix..entityPlayer:GetName()..'.\n')
        return true
    end
    local tainted
    if(not val) then
        val,tainted=GetPlayerIdByName(valArg)
    end
    if val~=PlayerType.PLAYER_POSSESSOR then
        entityPlayer:ChangePlayerType(val)
        entityPlayer.SubType=val
        taintedPrefix=tainted and '(Tainted)' or ''
        Isaac.ConsoleOutput('Player'..playerId..' : '..taintedPrefix..entityPlayer:GetName()..'.\n')
        -- local mod=RegisterMod('',1)
        -- local function cpt(_,player)
        --     if(player==entityPlayer)then
        --         entityPlayer:ChangePlayerType(val)
        --         entityPlayer.SubType=val
        --     end
        --     Isaac.ConsoleOutput('Player'..playerId..' --> '..taintedPrefix..entityPlayer:GetName()..'.\n')
        --     mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_INIT, cpt)
        -- end
        -- mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, cpt)
        -- Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PLAYER_INIT, mod, entityPlayer)
    else
        Isaac.ConsoleOutput('No Such Player.\n')
        return false
    end
    return true
end

return change_player_type