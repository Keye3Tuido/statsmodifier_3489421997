local show = require('operations.manage_show')

local lastTime = Isaac.GetTime()
local lastRenderFrame = Isaac.GetFrameCount()
local period = 2
local count = 0
local renderFramesPerSecond = 60

local function GetRenderTimeScale()
    count = count + 1
    if count >= period then
        local currentTime = Isaac.GetTime()
        local currentRenderFrame = Isaac.GetFrameCount()

        local deltaTime = currentTime - lastTime
        local deltaRenderFrames = currentRenderFrame - lastRenderFrame

        lastTime = currentTime
        lastRenderFrame = currentRenderFrame

        show.RenderTimeScale = 1e3 * deltaRenderFrames / deltaTime / renderFramesPerSecond
        count = 0
    end
end

return GetRenderTimeScale