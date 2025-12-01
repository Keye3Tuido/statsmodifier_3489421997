local Enums         = require('definitions.enums')
local Input2Id      = require('definitions.produce_input')
local ProduceCmd    = require('operations.manage').ProduceCmd
local ProduceStat   = require('operations.manage').ProduceStat
local Players       = require('statsmodifier.players')
local function OnExecuteCmd(self,arg1,arg2)
    local statArg,playerIdArg=arg1:match('^%s*(%a+)(%d*)')
    if(statArg) then statArg=statArg:lower() end
    local valArg=arg2:match('^ *(.*) *$')
    local playerId=tonumber(playerIdArg)
    if(not playerId) then
        playerId = 0
    end
    local entityPlayer=Players:GetPlayerById(playerId)
    if(not entityPlayer) then
        -- Isaac.ConsoleOutput('StatsModifier: Player Not Found: ' .. tostring(playerId) .. '\n')
        return      -- Run Other Commands Callbacks
    end
    
    local retVal = ProduceCmd(self,statArg,playerId,valArg)
    if retVal then  -- 执行成功
        Players:Save()
        return 'StatsModifier: Command Executed Successfully.'
    elseif retVal == false then -- 执行失败
        Isaac.ConsoleOutput('StatsModifier: Command Failed.\n')
        return      -- Run Other Commands Callbacks
    end
    -- 非命令


    local ops,op=0,Enums.Ops.SET
    valArg,ops=valArg:lower():gsub(Input2Id.OpsID[Enums.Ops.PLUS],'')
    if(ops>0) then
        op=Enums.Ops.PLUS
    end
    ops=0
    valArg,ops=valArg:lower():gsub(Input2Id.OpsID[Enums.Ops.TIMES],'')
    if(ops>0) then
        op=Enums.Ops.TIMES
    end
    
    local force
    valArg,force=valArg:lower():gsub('_','')
    if(force>0) then
        force=true
    else
        force=false
    end

    local val
    if(valArg == 'inf') then
        val=Enums.Infinity.INF
    elseif(valArg == '-inf') then
        val=Enums.Infinity.NINF
    else
        val=tonumber(valArg)
    end
    if(not val) then force = nil end


    local stat = Input2Id.StatsID[statArg]
    if(not stat) then
        -- Isaac.ConsoleOutput('StatsModifier: Invalid Stat: ' .. tostring(statArg) .. '\n')
        return      -- Run Other Commands Callbacks
    end
    if(ProduceStat(self,playerId,entityPlayer,stat,val,force,op))then
        Players:Save()
        return 'StatsModifier: Stat Modified Successfully.'
    end
end

return OnExecuteCmd