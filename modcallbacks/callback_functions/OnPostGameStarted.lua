local Manage = require('operations.manage')
local NewPlayers = Manage.NewPlayers
local function OnPostGameStarted(self, isContinued)
    -- 每次进入游戏（新游戏或继续）默认关闭 Command UI
    local ok, PanelState = pcall(require, 'render.ui.PanelState')
    if ok and PanelState then
        PanelState.close()
    end
    if not isContinued then
        NewPlayers(self)
    end
end

return OnPostGameStarted