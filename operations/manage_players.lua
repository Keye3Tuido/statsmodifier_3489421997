local Enums             = require('definitions.enums')
local Players           = require('statsmodifier.players')
local Manage_Players = {}


function Manage_Players:NewPlayers()
    Players()
    Players:Save()
end

function Manage_Players:UpdatePlayerList()
    Players:UpdatePlayerList()
end

function Manage_Players:ClearAll()
    for playerId,entityPlayer in Players:Iterator() do
        Manage_Players:ReSetAll(playerId,entityPlayer)
        Manage_Players:Evaluate(playerId,entityPlayer)
        Players:Save()
    end
end

function Manage_Players:EvaluateStat(playerId,entityPlayer,stat)
    if(not stat) then return end
    playerId,entityPlayer=Players:GetIdPlayer(playerId,entityPlayer)
    if(not entityPlayer) then return end
    entityPlayer:AddCacheFlags(Enums.CacheFlags[stat])
    entityPlayer:EvaluateItems()
end

function Manage_Players:Evaluate(playerId,entityPlayer)
    for _,stat in pairs(Enums.Stats) do
        if(stat ~= Enums.Stats.ALL) then
            Manage_Players:EvaluateStat(playerId,entityPlayer,stat)
        end
    end
end

function Manage_Players:UpdateStat(playerId,entityPlayer,stat)
    Players:Compute(playerId,entityPlayer,stat)
end

function Manage_Players:ReSetAll(playerId,entityPlayer)
    playerId,entityPlayer=Players:GetIdPlayer(playerId,entityPlayer)
    if(not entityPlayer) then return end
    Players:ClearPlayerStats(playerId,entityPlayer)
end

function Manage_Players:ProduceStat(playerId,entityPlayer,stat,val,force,op)
    playerId,entityPlayer=Players:GetIdPlayer(playerId,entityPlayer)
    if(not playerId) then return false end

    if(stat == Enums.Stats.ALL) then
        Manage_Players:ReSetAll(playerId,entityPlayer)
        Manage_Players:Evaluate(playerId,entityPlayer)
        return true
    end

    if(stat == Enums.Stats.FLYING) then
        force = false
        if(val) then
            if(val ~= 0)then
                entityPlayer:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BIBLE)
            else
                entityPlayer:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BIBLE)
            end
        end
    end
    Players:SetPlayerStat(playerId,entityPlayer,stat,val,force)
    Players:SetOp(playerId,entityPlayer,stat,op)
    Manage_Players:EvaluateStat(playerId,entityPlayer,stat)
    if(Players:IsStatForced(playerId,entityPlayer,stat) and val ~= nil) then
        Manage_Players:UpdateStat(playerId,entityPlayer,stat)
    end
    return true
end

return Manage_Players