Names=require('definitions.names')
local Utils={}
local ChallengeName=Names.ChallengeName

----------------------------------------------------------------------------

function Utils.GetCollectibleIdByName(name)
    if not name or #name == 0 then return 0 end
    local id=Isaac.GetItemIdByName(name)
    if id > 0 then return id end
    name = name:lower():gsub(' ','_')
    for i=1,Isaac.GetItemConfig():GetCollectibles().Size-1 do
        local collectible=Isaac.GetItemConfig():GetCollectible(i)
        if(collectible and collectible.Name:lower():match(name)) then
            return i
        end
    end
    local i=-1
    while(ItemConfig.Config.IsValidCollectible(i))do
        local collectible=Isaac.GetItemConfig():GetCollectible(i)
        if(collectible and collectible.Name:lower():match(name)) then
            return i
        end
        i=i-1
    end
    return CollectibleType.COLLECTIBLE_NULL
end

local names,ids={},{}
for k,v in pairs(PlayerType) do
    if v~=PlayerType.PLAYER_POSSESSOR and v~=PlayerType.NUM_PLAYER_TYPES then
        names[v]=names[v] or {}
        names[v][#names[v]+1]=(k:match('^(PLAYER_.*)$')or''):lower()
        ids[#ids+1] = v
    end
end
table.sort(ids)
function Utils.GetPlayerIdByName(name)
    if not name or #name == 0 then return -1 end
    name=name:lower():gsub(' ','')
    local count
    name,count = name:gsub('_','')
    local tainted = count>0
    local id=Isaac.GetPlayerTypeByName(name,tainted)
    if id > -1 then return id,tainted end
    for _,i in ipairs(ids) do
        for _,v in pairs(names[i])do
            if (v:match('_b$')~=nil)==tainted then
                if v:match(name) then
                    return i,tainted
                end
            end
        end
    end
    return PlayerType.PLAYER_POSSESSOR
end


function Utils.GetChallengeIdByName(name)
    if not name or #name==0 then return -1 end
    local id=Isaac.GetChallengeIdByName(name)
    if(id > -1) then return id end

    name = name:lower():gsub(' ','')
    for i=1,45 do
        if(ChallengeName[i]:lower():gsub(' ',''):match(name)) then
            return i
        end
    end
    return -1
end

local eggs,nums={},{}
for k,v in pairs(SeedEffect) do
    local egg=k:match('^(SEED_.*)$')
    if egg and egg~='NORMAL' then
        eggs[v]=eggs[v] or {}
        eggs[v][#eggs[v]+1] = egg:lower()
        nums[#nums+1] = v
    end
end
function Utils.GetEasterEggByName(name)
    if not name or #name == 0 then return -1 end
    local seed = Seeds.GetSeedEffect(name)
    if seed ~= SeedEffect.SEED_NORMAL then return seed end
    name=name:lower():gsub(' ','_')
    for _,i in ipairs(nums) do
        for _,v in pairs(eggs[i]) do
            if v:match(name) then
                return i
            end
        end
    end
    return -1
end
function Utils.GetEasterEggNameById(id)
    return eggs[id][1] or 'not found'
    
end

function Utils.GetTrinketIdByName(name)
    if not name or #name == 0 then return 0 end
    local id=Isaac.GetTrinketIdByName(name)
    if id > 0 then return id end
    name = name:lower():gsub(' ','_')
    for i=1,Isaac.GetItemConfig():GetTrinkets().Size-1 do
        local trinket=Isaac.GetItemConfig():GetTrinket(i)
        if(trinket and trinket.Name:lower():match(name)) then
            return i
        end
    end
    return TrinketType.TRINKET_NULL
end

local rooms,idxs={},{}
for k,v in pairs(GridRooms) do
    local room=k:match('^(ROOM_.*_IDX)$')
    if room then
        rooms[v]=rooms[v] or {}
        rooms[v][#rooms[v]+1] = room:lower()
        idxs[#idxs+1] = v
    end
end
table.sort(idxs,function(a,b) return a>b end)
function Utils.GetRoomIdx(room)
    if not room or #room==0 then return GridRooms.NO_ROOM_IDX end
    room=room:lower():gsub(' ','_')
    for _,i in ipairs(idxs) do
        for _,v in pairs(rooms[i]) do
            if v:match(room) then
                return i
            end
        end
    end
    return GridRooms.NO_ROOM_IDX
end

function Utils.DiscoverMap(dimension)
    if(not dimension) then dimension=-1 end
    local level=Game():GetLevel()
    level:RemoveCurses(LevelCurse.CURSE_OF_DARKNESS|LevelCurse.CURSE_OF_THE_LOST|LevelCurse.CURSE_OF_THE_UNKNOWN|LevelCurse.CURSE_OF_MAZE|LevelCurse.CURSE_OF_BLIND)
    level:SetCanSeeEverything(true)
    local rooms={}
    local roomsList=level:GetRooms()
    local nowCount=roomsList.Size
    local lastCount
    local function OpenDoors(roomDesc)
        local index = roomDesc.SafeGridIndex
        local doors = roomDesc.Data and roomDesc.Data.Doors
        for j=0,7 do
            if(not doors or doors&1==1)then
                level:MakeRedRoomDoor(index,j)
                level:UncoverHiddenDoor(index,j)
            end
            doors = doors and doors>>1
        end
        rooms[index]=true
        roomDesc.DisplayFlags=RoomDescriptor.DISPLAY_ALL
    end
    OpenDoors(level:GetRoomByIdx(level:GetCurrentRoomDesc().SafeGridIndex)) -- 优先从当前房间开始开门
    while lastCount~=nowCount do
        lastCount=nowCount
        for i=0,nowCount-1 do
            local room=roomsList:Get(i)
            local roomIndex=room.SafeGridIndex
            room=level:GetRoomByIdx(roomIndex, dimension)
            if not rooms[roomIndex] then
                OpenDoors(room)
            end
        end
        roomsList=level:GetRooms()
        nowCount=roomsList.Size
    end
    level:UpdateVisibility()
end

local function GetCurrentDesc(dim)
    local level=Game():GetLevel()
    return GetPtrHash(level:GetRoomByIdx(level:GetCurrentRoomIndex(),dim))
end
function Utils.GetDimension()
    for i=0,2 do
        if GetCurrentDesc(-1)==GetCurrentDesc(i) then
            return i
        end
    end
end

return Utils