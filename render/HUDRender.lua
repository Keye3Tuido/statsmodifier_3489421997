local Enums     = require("definitions.enums")
local Players   = require("statsmodifier.players")

local function GetHUDDisplayID()
    local t=select(2,Players:IsMultiPlayer())
    if(#t==1)then return t[1],-1 end
    if(Game():GetPlayer(t[1]):GetPlayerType() == PlayerType.PLAYER_JACOB) then
        return t[1],Players:GetPlayerId(Game():GetPlayer(t[1]):GetOtherTwin())
    end
    local player0=Game():GetPlayer(t[1])
    if((player0:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B
        or player0:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B)
        and (player0:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        or (player0:GetOtherTwin()and player0:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)))) then
        local i=2
        if(#t==2)then
            i=-1
        else
            while i<=#t do
                if(Players:GetPlayerById(t[i])~=Players:GetPlayerId(player0:GetOtherTwin()))then
                    break
                end
            end
        end
        return Players:GetPlayerId(player0:GetMainTwin()),i
    end
    return t[1],t[2]
end

local function HUDRender()
    local roomData=Game():GetLevel():GetCurrentRoomDesc().Data
    if(roomData.Name=='Beast Room' or Options.FoundHUD == false) then return end
    if(not Players:PlayerExists(0,nil)) then return end
    local offset_x=Options.HUDOffset*20
    local offset_y=Options.HUDOffset*12
    if(Game().Difficulty==0 and not Game():GetSeeds():IsCustomRun())then offset_y=offset_y-16 end
    local bluebaby_b,bethany,bethany_b=0,0,0
    for _,enp in Players:Iterator() do
        if(enp.SubType==PlayerType.PLAYER_BETHANY)then
            bethany=1
        elseif(enp.SubType==PlayerType.PLAYER_BLUEBABY_B)then
            bluebaby_b=1
        elseif(enp.SubType==PlayerType.PLAYER_BETHANY_B)then
            bethany_b=1
        end
    end
    local total=bethany+bluebaby_b+bethany_b
    if(total==1)then
        total=9
    elseif(total==2)then
        total=20
    elseif(total==3)then
        total=31
    end
    offset_y=offset_y+total
    local f=Font()

    local jacob= false
    local multiPlayer = false
    local id1,id2=GetHUDDisplayID()
    if(id2>=0)then
        if(Game():GetPlayer(id1):GetPlayerType() == PlayerType.PLAYER_JACOB)then
            jacob=true
        else
            multiPlayer=true
        end
    else
        id2=id1
    end

    local markColor,markColor2
    f:Load('font/luaminioutlined.fnt')
    for _,stat in pairs(Enums.Stats) do
        markColor=Players:RenderKColor(id1,nil,stat)
        markColor2=Players:RenderKColor(id2,nil,stat)
        if(Enums.StatsShouldRender[stat]) then
            if(Players:GetPlayerStat(id1,nil,stat)) then
                if(jacob) then
                    if(stat == Enums.Stats.SPEED) then
                        f:DrawString('__',20+offset_x,107+offset_y,markColor,0,true)
                    else
                        f:DrawString('__',20+offset_x,88+stat*14+offset_y,markColor,0,true)
                    end
                elseif(multiPlayer) then
                    f:DrawString('__',18+offset_x,74+(14*stat)+offset_y,markColor,0,true)
                else
                    f:DrawString('__',20+offset_x,80+(12*stat)+offset_y,markColor,0,true)
                end
            end
            if((jacob or multiPlayer) and Players:GetPlayerStat(id2,nil,stat)) then
                if(jacob and stat~=Enums.Stats.SPEED) then
                    f:DrawString('__',22+offset_x,95+stat*14+offset_y,markColor2,0,false)
                elseif(multiPlayer) then
                    f:DrawString('__',22+offset_x,81+stat*14+offset_y,markColor2,0,true)
                end
            end
        end
    end
end

return HUDRender