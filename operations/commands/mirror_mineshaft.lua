local function mirror_mineshaft(self, playerId, entityPlayer, val, valArg)
    local rooms=Game():GetLevel():GetRooms()
    for i=0,rooms.Size-1 do
        local room = rooms:Get(i)
        local name = room.Data.Name
        if name == 'Mirror Room' or name == 'Secret Entrance' then
            Game():GetLevel():RemoveCurses(LevelCurse.CURSE_OF_MAZE) -- Remove the Curse of the Maze
            Game():StartRoomTransition(room.SafeGridIndex, Direction.NO_DIRECTION)
            return true
        end
    end

    Isaac.ConsoleOutput('No MirrorRoom and Mineshaft found\n')
    return false -- No MirrorRoom and Mineshaft found
end

return mirror_mineshaft