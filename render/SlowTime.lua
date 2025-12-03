local show = require('operations.manage_show')


local function SlowTime()
    if show.TimeSpeedMultiplier >= 1 then return end
    if Game():IsPaused() then return end
    if show.TimeSpeedMultiplier < show.RenderTimeScale then
        show.BulletTimeUpdateNums = show.BulletTimeUpdateNums * 1.2
    elseif show.TimeSpeedMultiplier > show.RenderTimeScale then
        show.BulletTimeUpdateNums = math.max(1, show.BulletTimeUpdateNums/2)
    end
    for i=1, math.floor(show.BulletTimeUpdateNums) do
        Isaac.GetRoomEntities()
    end
end

return SlowTime