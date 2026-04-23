local InputManager     = require('render.ui.InputManager')
local ClickManager     = require('render.ui.ClickManager')
local PanelState       = require('render.ui.PanelState')
local CommandUIRender  = require('render.ui.CommandUIRender')
local Players          = require('statsmodifier.players')

local CommandUI = {}

-- 上一帧 UI 是否可见
local wasVisible = false
-- 上一帧玩家数量（用于检测玩家变动）
local lastNumPlayers = -1

function CommandUI.Update()
    InputManager.Update(PanelState)

    if PanelState.visible then
        ClickManager.Update(PanelState, CommandUIRender.GetUIElements(PanelState))

        -- 每帧刷新玩家名称（只要有合法数字 ID 就尝试获取）
        if not PanelState.editingPlayerId then
            PanelState.refreshPlayerName()
        end

        -- 检测玩家数量变动，自动校验当前 PlayerID
        local numPlayers = Game():GetNumPlayers()
        if numPlayers ~= lastNumPlayers then
            lastNumPlayers = numPlayers
            if not PanelState.editingPlayerId then
                local id = tonumber(PanelState.playerIdText)
                if id and id > 0 then
                    local ok, player = pcall(function() return Players:GetPlayerById(id) end)
                    if not ok or not player then
                        PanelState.playerIdText = "0"
                        PanelState.playerName = ""
                        PanelState.setFeedback("PlayerID " .. tostring(id) .. " lost, reset to 0", true)
                    end
                end
                PanelState.refreshPlayerName()
            end
        end
    end

    if PanelState.feedbackTimer > 0 then
        PanelState.feedbackTimer = PanelState.feedbackTimer - 1
        if PanelState.feedbackTimer <= 0 then
            PanelState.feedbackMsg = ""
            PanelState.feedbackTimer = 0
        end
    end

    -- UI 打开时禁用玩家控制（阻止鼠标射击）
    if PanelState.visible then
        local numPlayers = Game():GetNumPlayers()
        for i = 0, numPlayers - 1 do
            local player = Game():GetPlayer(i)
            if player then
                player.ControlsEnabled = false
            end
        end
    end

    -- UI 刚关闭时恢复玩家控制
    if wasVisible and not PanelState.visible then
        local numPlayers = Game():GetNumPlayers()
        for i = 0, numPlayers - 1 do
            local player = Game():GetPlayer(i)
            if player then
                player.ControlsEnabled = true
            end
        end
    end
    wasVisible = PanelState.visible
end

function CommandUI.Render()
    if not PanelState.visible then return end
    CommandUIRender.Render(PanelState)
end

function CommandUI.Toggle()
    PanelState.toggleVisible()
end

function CommandUI.IsVisible()
    return PanelState.visible
end

--- MC_INPUT_ACTION 回调
--- 参数: (self, entity, inputHook, buttonAction)
function CommandUI.OnInputAction(_, _, inputHook, _)
    if not PanelState.visible then return end
    return inputHook == InputHook.GET_ACTION_VALUE and 0
end

return CommandUI
