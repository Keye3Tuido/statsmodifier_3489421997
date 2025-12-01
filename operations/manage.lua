local Manage_Players    = require('operations.manage_players')
local Manage_Commands   = require('operations.manage_commands')

local Manage = {}

-------------------------------------------------------------------------
Manage.NewPlayers       = Manage_Players.NewPlayers
Manage.UpdatePlayerList = Manage_Players.UpdatePlayerList
Manage.ClearAll         = Manage_Players.ClearAll
Manage.EvaluateStat     = Manage_Players.EvaluateStat
Manage.Evaluate         = Manage_Players.Evaluate
Manage.UpdateStat       = Manage_Players.UpdateStat
Manage.ReSetAll         = Manage_Players.ReSetAll
Manage.ProduceStat      = Manage_Players.ProduceStat
Manage.ProduceCmd       = Manage_Commands.ProduceCmd

return Manage