local show={
    showEntityId = false,
    showStatsInfo = false,
    showMouse = false,
    showPlayerId = false,
    TimeSpeedMultiplier = 1,
    integerPart = 1,  -- Used for calculating the integer part of TimeSpeedMultiplier
    fractionPart = 0,  -- Used for calculating the fractional part of TimeSpeedMultiplier
    accumulator = 0,     -- Used for accelerating time speed
    RenderTimeScale = 1,
    BulletTimeUpdateNums = 1        -- 时间减速时，每帧执行无关计算的次数
}

return show