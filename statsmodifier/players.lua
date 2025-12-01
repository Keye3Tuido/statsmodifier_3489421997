local json          =require('json')
local Enums         =require('definitions.enums')
local function Hash(entityPlayer)
    if(not entityPlayer) then return end
    -- return entityPlayer.InitSeed     -- 不适用多玩家，小退即变
    -- return GetPtrHash(entityPlayer)  -- 内存更新时（重新加载模组、重新加载游戏等）会变化
    -- return entityPlayer:GetCollectibleRNG(Isaac.GetItemIdByName('StatsModifier')):GetSeed() -- 额外新增道具会影响世界线
    return entityPlayer:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION):GetSeed() -- 不支持多玩家创世记
end
local Memory={
    [Enums.Stats.SPEED]='MoveSpeed',
    [Enums.Stats.TEARS]='MaxFireDelay',
    [Enums.Stats.DAMAGE]='Damage',
    [Enums.Stats.RANGE]='TearRange',
    [Enums.Stats.SHOTSPEED]='ShotSpeed',
    [Enums.Stats.LUCK]='Luck',
    [Enums.Stats.FLYING]='CanFly',
    [Enums.Stats.SIZE]='SpriteScale'
}
local SetVal={
    MoveSpeed=function(sp) return sp end,
    MaxFireDelay=function(te) return 30/te-1 end,
    Damage=function(da) return da end,
    TearRange=function(ra) return ra*40 end,
    ShotSpeed=function(sh) return sh end,
    Luck=function(lu) return lu end,
    CanFly=function(fl) return (fl~=0) end,
    SpriteScale=function(si) return Vector(si,si)end
}
local PlusVal={
    MoveSpeed=function(le,sp) return le+sp end,
    MaxFireDelay=function(le,te) return (30/(30/(le+1)+te))-1 end,
    Damage=function(le,da) return le+da end,
    TearRange=function(le,ra) return le+40*ra end,
    ShotSpeed=function(le,sh) return le+sh end,
    Luck=function(le,lu) return le+lu end,
    CanFly=function(le,fl) return (fl~=0) end,
    SpriteScale=function(le,si) return le+Vector(si,si)end
}
local TimesVal={
    MoveSpeed=function(le,sp) return le*sp end,
    MaxFireDelay=function(le,te) return (le+1)/te-1 end,
    Damage=function(le,da) return le*da end,
    TearRange=function(le,ra) return (le*ra)*40 end,
    ShotSpeed=function(le,sh) return le*sh end,
    Luck=function(le,lu) return le*lu end,
    CanFly=function(le,fl) return (fl~=0) end,
    SpriteScale=function(le,si) return le*si end
}
local GetColor={
    [false]={ -- not forced
        [Enums.Ops.SET]     ={0,1,0},       -- set      绿
        [Enums.Ops.PLUS]    ={0,.7,.7},     -- plus     青蓝
        [Enums.Ops.TIMES]   ={0,.3,1}       -- times    深宝蓝
    },
    [true]={ -- forced
        [Enums.Ops.SET]     ={1,0,0},       -- set      红
        [Enums.Ops.PLUS]    ={1,0,1},       -- plus     粉
        [Enums.Ops.TIMES]   ={1,1,0}        -- times    黄
    }
}


local function CreatePlayersList(StatsModifier)
    local HashToId={}
    local IdToEntity={}
    local IdStats={}
    local IdStatsForced={}
    local IdCanShoot={}
    local IdPocket={}
    local IdOps={}
    local IdOriginalStats={}
    return {
        GamePlayerIterator=function(self)
            local playerNums=Game():GetNumPlayers()
            local curId=0
            return function()
                local playerPtrHash,playerId,entityPlayer
                if(curId<playerNums) then
                    entityPlayer=Game():GetPlayer(curId)
                    playerPtrHash=Hash(entityPlayer)
                    playerId=curId
                    curId = curId + 1
                    return playerPtrHash,playerId,entityPlayer
                end
            end
        end,
        UpdatePlayerList=function(self,playerId_legacy,entityPlayer_legacy)
            self:Load()
            local playerPtrHash_legacy
            if(playerId_legacy and entityPlayer_legacy) then
                playerPtrHash_legacy=Hash(entityPlayer_legacy)
            end
            
            playerId_legacy=playerId_legacy or HashToId[playerPtrHash_legacy]
            entityPlayer_legacy=IdToEntity[playerId_legacy]
            local playerPtrHash_present,playerId_present,entityPlayer_present
            local newHashToId={}
            local newIdToEntity={}
            local newIdStats={}
            local newIdStatsForced={}
            local newIdCanShoot={}
            local newIdPocket={}
            local newIdOps={}
            local newIdOriginalStats={}
            for pph,pid,enp in self:GamePlayerIterator() do
                newHashToId[pph]=pid
                newIdToEntity[pid]=enp
                if(pph == playerPtrHash_legacy) then
                    playerPtrHash_present=pph
                    playerId_present=pid
                    entityPlayer_present=enp
                end
                local legacy=HashToId[pph]
                if(legacy and IdStats[legacy]) then
                    newIdStats[pid]=IdStats[legacy]
                    newIdStatsForced[pid]=IdStatsForced[legacy]
                    newIdCanShoot[pid]=IdCanShoot[legacy]
                    newIdPocket[pid]=IdPocket[legacy]
                    newIdOps[pid]=IdOps[legacy]
                    newIdOriginalStats[pid]=IdOriginalStats[legacy]
                else
                    newIdStats[pid]={}
                    newIdStatsForced[pid]={}
                    newIdCanShoot[pid]=nil
                    newIdPocket[pid]=nil
                    newIdOps[pid]={}
                    newIdOriginalStats[pid]={}
                end
            end
            HashToId=newHashToId
            IdToEntity=newIdToEntity
            IdStats=newIdStats
            IdStatsForced=newIdStatsForced
            IdCanShoot=newIdCanShoot
            IdPocket=newIdPocket
            IdOps=newIdOps
            IdOriginalStats=newIdOriginalStats
            return playerPtrHash_present,playerId_present,entityPlayer_present
        end,
        GetIdHash=function(self,entityPlayer)
            if(not entityPlayer) then return end
            if(not self:PlayerExists(nil,entityPlayer)) then
                entityPlayer=select(3,self:UpdatePlayerList(nil,entityPlayer))
                if(not entityPlayer) then
                    return
                end
            end
            local playerPtrHash=Hash(entityPlayer)
            local playerId=HashToId[playerPtrHash]
            return playerId,playerPtrHash
        end,
        GetPlayerId=function(self,entityPlayer)
            return select(1,self:GetIdHash(entityPlayer))
        end,
        GetPlayerById=function(self,playerId)
            if(not self:PlayerExists(playerId)) then
                playerId=select(1,self:UpdatePlayerList(playerId))
                if(not playerId) then
                    return
                end
            end
            return IdToEntity[playerId]
        end,
        GetIdPlayer=function(self,playerId,entityPlayer)
            playerId=playerId or self:GetPlayerId(entityPlayer)
            entityPlayer=entityPlayer or self:GetPlayerById(playerId)
            if(playerId and entityPlayer) then
                return playerId,entityPlayer
            end
        end,
        PlayerExists=function(self,playerId,entityPlayer)
            playerId,entityPlayer=
            playerId or HashToId[Hash(entityPlayer)],
            entityPlayer or IdToEntity[playerId]
            if(playerId and entityPlayer and entityPlayer:Exists()) then
                return true
            end
            return false
        end,
        GetPlayerStat=function(self,playerId,entityPlayer,stat)
            if(not stat and stat~=Enums.Stats.ALL) then return end
            playerId=select(1,self:GetIdPlayer(playerId,entityPlayer))
            if(not playerId) then return end
            IdStats[playerId]=IdStats[playerId] or {}
            IdStatsForced[playerId]=IdStatsForced[playerId] or {}
            return IdStats[playerId][stat],IdStatsForced[playerId][stat]
        end,
        SetPlayerStat=function(self,playerId,entityPlayer,stat,val,force)
            if(not stat and stat~=Enums.Stats.ALL) then return end
            playerId=select(1,self:GetIdPlayer(playerId,entityPlayer))
            if(not playerId) then return end
            IdStats[playerId]=IdStats[playerId] or {}
            IdStats[playerId][stat] = val
            IdStatsForced[playerId]=IdStatsForced[playerId] or {}
            IdStatsForced[playerId][stat] = force
        end,
        ClearPlayerStats=function(self,playerId,entityPlayer)
            playerId=select(1,self:GetIdPlayer(playerId,entityPlayer))
            if(not playerId) then return end
            IdStats[playerId]={}
            IdStatsForced[playerId]={}
            IdCanShoot[playerId]=nil

            entityPlayer:UpdateCanShoot()
            if(entityPlayer:CanShoot())then
                entityPlayer:TryRemoveNullCostume(NullItemID.ID_BLINDFOLD)
            else
                entityPlayer:AddNullCostume(NullItemID.ID_BLINDFOLD)
            end

            IdPocket[playerId]=nil
            IdOps[playerId]={}
            IdOriginalStats[playerId]={}
        end,
        IsStatForced=function(self,playerId,entityPlayer,stat)
            if(not stat and stat~=Enums.Stats.ALL) then return end
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            return select(2,self:GetPlayerStat(playerId,entityPlayer,stat))
        end,
        Iterator=function(self)
            local iterIndex=nil
            return function()
                local playerId
                local entityPlayer
                playerId,entityPlayer=next(IdToEntity,iterIndex)
                iterIndex=playerId
                return playerId,entityPlayer
            end
        end,
        RenderColor=function(self,playerId,entityPlayer,stat)
            if(not stat) then return 1,1,1,1 end
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not(playerId and Enums.StatsShouldRender[stat])) then return 0,0,0,0 end
            local val,force
            val,force=self:GetPlayerStat(playerId,entityPlayer,stat)
            if(not val) then return 1,1,1,1 end
            local op=self:GetOp(playerId,entityPlayer,stat)
            local red=0
            local green=0
            local blue=0
            local alpha=1
            red,green,blue=table.unpack(GetColor[force][op])
            return red,green,blue,alpha
        end,
        RenderKColor=function(self,playerId,entityPlayer,stat)
            return KColor(self:RenderColor(playerId,entityPlayer,stat))
        end,
        GetMaxPlayers=function(self)
            return #IdToEntity+1
        end,
        Compute=function(self,playerId,entityPlayer,stat)
            if(not stat or stat == Enums.Stats.ALL) then return end
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            
            local val=self:GetPlayerStat(playerId,entityPlayer,stat)
            if(not val) then return end
            local key=Memory[stat]
            local op=self:GetOp(playerId,entityPlayer,stat)
            if(op==Enums.Ops.SET) then
                entityPlayer[key]=SetVal[key](val)
            elseif(op==Enums.Ops.PLUS) then
                entityPlayer[key]=PlusVal[key](self:GetOriginalStat(playerId,entityPlayer,stat),val)
            elseif(op==Enums.Ops.TIMES) then
                entityPlayer[key]=TimesVal[key](self:GetOriginalStat(playerId,entityPlayer,stat),val)
            end
            if key=='MaxFireDelay' then
                entityPlayer.FireDelay=entityPlayer[key]
            end
        end,
        GetOp=function(self,playerId,entityPlayer,stat)
            if(not stat and stat~=Enums.Stats.ALL) then return end
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            IdOps[playerId]=IdOps[playerId] or {}
            return IdOps[playerId][stat]
        end,
        SetOp=function(self,playerId,entityPlayer,stat,val)
            if(not stat and stat~=Enums.Stats.ALL) then return end
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            IdOps[playerId]=IdOps[playerId] or {}
            IdOps[playerId][stat]=val
        end,
        IsMultiPlayer=function(self)
            local Players={}
            local MainPlayerId={}
            for id,ep in pairs(IdToEntity) do
                if(not(ep.Parent or Players[ep]))then
                    Players[ep]=true
                    table.insert(MainPlayerId,id)
                end
            end
            table.sort(MainPlayerId)
            return #MainPlayerId>1,MainPlayerId
        end,
        CanShoot=function(self,playerId,entityPlayer)
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            return IdCanShoot[playerId]
        end,
        SetBlind=function(self,playerId,entityPlayer,blind)
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            IdCanShoot[playerId]=(blind==true)
        end,
        GetPocket=function(self,playerId,entityPlayer)
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            return IdPocket[playerId]
        end,
        SetPocket=function(self,playerId,entityPlayer,collectibleId)
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            if(collectibleId==0)then collectibleId=nil end
            IdPocket[playerId]=collectibleId
        end,
        GetPlayerNums=function(self)
            return #IdToEntity+1
        end,
        TrackOriginalStat=function(self,playerId,entityPlayer,stat)
            if(not stat and stat~=Enums.Stats.ALL) then return end
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end

            IdOriginalStats[playerId]=IdOriginalStats[playerId] or {}
            IdOriginalStats[playerId][stat]=entityPlayer[Memory[stat]]
        end,
        GetOriginalStat=function(self,playerId,entityPlayer,stat)
            if(not stat and stat~=Enums.Stats.ALL) then return end
            playerId,entityPlayer=self:GetIdPlayer(playerId,entityPlayer)
            if(not playerId) then return end
            IdOriginalStats[playerId]=IdOriginalStats[playerId] or {}
            return IdOriginalStats[playerId][stat]
        end,
        Save=function(self)
            local sHashToId,sIdStats,sIdStatsForced,sIdCanShoot,sIdPocket,sIdOps,sIdOriginalStats={},{},{},{},{},{},{}
            for hash,id in pairs(HashToId)do
                sHashToId[tostring(hash)]=id
            end
            for id,stats in pairs(IdStats)do
                sIdStats[tostring(id)]={}
                for stat,val in pairs(stats)do
                    sIdStats[tostring(id)][tostring(stat)]=val
                end
            end
            for id,stats in pairs(IdStatsForced)do
                sIdStatsForced[tostring(id)]={}
                for stat,val in pairs(stats)do
                    sIdStatsForced[tostring(id)][tostring(stat)]=val
                end
            end
            for id,canShoot in pairs(IdCanShoot)do
                sIdCanShoot[tostring(id)]=canShoot
            end
            for id,pocket in pairs(IdPocket)do
                sIdPocket[tostring(id)]=pocket
            end
            for id,ops in pairs(IdOps)do
                sIdOps[tostring(id)]={}
                for stat,val in pairs(ops)do
                    sIdOps[tostring(id)][tostring(stat)]=val
                end
            end
            for id,stats in pairs(IdOriginalStats)do
                sIdOriginalStats[tostring(id)]={}
                for stat,val in pairs(stats)do
                    sIdOriginalStats[tostring(id)][tostring(stat)]=val
                end
            end
            local PersistentData={sHashToId,sIdStats,sIdStatsForced,sIdCanShoot,sIdPocket,sIdOps,sIdOriginalStats}
            StatsModifier:SaveData(json.encode(PersistentData))
        end,
        Load=function(self)
            if(StatsModifier:HasData())then
                local res,PersistentData=pcall(json.decode,StatsModifier:LoadData())
                if(not res)then
                    StatsModifier:RemoveData()
                    return
                end
                local sHashToId,sIdStats,sIdStatsForced,sIdCanShoot,sIdPocket,sIdOps,sIdOriginalStats
                sHashToId,sIdStats,sIdStatsForced,sIdCanShoot,sIdPocket,sIdOps,sIdOriginalStats=table.unpack(PersistentData)
                HashToId={}
                sHashToId=sHashToId or {}
                for hash,id in pairs(sHashToId)do
                    HashToId[tonumber(hash)]=id
                end
                IdStats={}
                sIdStats=sIdStats or {}
                for id,stats in pairs(sIdStats)do
                    IdStats[tonumber(id)]={}
                    stats=stats or {}
                    for stat,val in pairs(stats)do
                        IdStats[tonumber(id)][tonumber(stat)]=val
                    end
                end
                IdStatsForced={}
                sIdStatsForced=sIdStatsForced or {}
                for id,stats in pairs(sIdStatsForced)do
                    IdStatsForced[tonumber(id)]={}
                    stats=stats or {}
                    for stat,val in pairs(stats)do
                        IdStatsForced[tonumber(id)][tonumber(stat)]=val
                    end
                end
                IdCanShoot={}
                sIdCanShoot=sIdCanShoot or {}
                for id,canShoot in pairs(sIdCanShoot)do
                    IdCanShoot[tonumber(id)]=canShoot
                end
                IdPocket={}
                sIdPocket=sIdPocket or {}
                for id,pocket in pairs(sIdPocket)do
                    if(pocket=='')then pocket=nil end
                    IdPocket[tonumber(id)]=pocket
                end
                IdOps={}
                sIdOps=sIdOps or {}
                for id,op in pairs(sIdOps)do
                    IdOps[tonumber(id)]={}
                    op=op or {}
                    for stat,val in pairs(op)do
                        IdOps[tonumber(id)][tonumber(stat)]=val
                    end
                end
                IdOriginalStats={}
                sIdOriginalStats=sIdOriginalStats or {}
                for id,stats in pairs(sIdOriginalStats)do
                    IdOriginalStats[tonumber(id)]={}
                    stats=stats or {}
                    for stat,val in pairs(stats)do
                        IdOriginalStats[tonumber(id)][tonumber(stat)]=val
                    end
                end
            end
        end
    }
end

local PlayersList={
    who=nil,
    data=nil,
}

setmetatable(PlayersList,{
    __call=function(self,StatsModifier)      -- 首次调用必须传入Mod对象
        self.who=StatsModifier or self.who
        self.data=CreatePlayersList(self.who)
        return self.data
    end,

    __index=function(self,key)
        if(not self.data) then
            self(self.who)
        end
        return self.data[key]
    end
})

return PlayersList