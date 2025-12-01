local function delirium(self, playerId, entityPlayer, val, valArg)
    local rooms=Game():GetLevel():GetRooms()
    for i=0,rooms.Size-1 do
        local room = rooms:Get(i)
        if room.Data.Name == 'Delirium' then
            Game():GetLevel():RemoveCurses(LevelCurse.CURSE_OF_MAZE) -- Remove the Curse of the Maze
            Game():StartRoomTransition(room.SafeGridIndex, Direction.NO_DIRECTION)
            return true
        end
    end

    Isaac.ConsoleOutput('No Delirium room found\n')
    return false -- No Delirium room found
end

return delirium