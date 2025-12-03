local show = require('operations.manage_show')

local isAccelerating = false

local function OnPostUpdate()
    if show.TimeSpeedMultiplier <= 1 then return end
    if(isAccelerating)then return end
    isAccelerating = true
    show.accumulator=show.accumulator+show.fractionPart
    for _=1,show.integerPart-1 do
        Game():Update()
    end
    if(show.accumulator>=1)then
        show.accumulator=show.accumulator-1
        Game():Update()
    end
    isAccelerating = false
end

return OnPostUpdate