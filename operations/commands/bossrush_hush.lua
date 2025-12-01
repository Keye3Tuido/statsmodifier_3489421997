local function bossrush_hush(self,playerId,entityPlayer,val,valArg)
    local room=Game():GetRoom()
    room:TrySpawnBossRushDoor(true)
    room:TrySpawnBlueWombDoor(true,true)
    return true
end

return bossrush_hush