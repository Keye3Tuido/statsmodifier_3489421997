local Utils = require("operations.utils")
local GetDimension = Utils.GetDimension
local GetRoomIdx = Utils.GetRoomIdx
local function tp(self, playerId, entityPlayer, val, valArg)
    local level = Game():GetLevel()
    if valArg == '' then
        local room=level:GetCurrentRoomDesc()
        Isaac.ConsoleOutput('Current : Room[ID='..tostring(level:GetCurrentRoomIndex())..'][Name='..room.Data.Name..']\n')
        Isaac.ConsoleOutput('Current Dimension : '..tostring(GetDimension())..'\n')
        return true
    end
    val = val or GetRoomIdx(valArg)
    if val == GridRooms.NO_ROOM_IDX then
        Isaac.ConsoleOutput('Invalid room\n')
        return false
    end
    local room=level:GetRoomByIdx(val)
    if not(room and room.Data) then
        Isaac.ConsoleOutput('No initialized room was found\n')
        return false
    end
    Game():StartRoomTransition(val, Direction.NO_DIRECTION)
    Isaac.ConsoleOutput('Teleported to : Room[ID='..tostring(val)..'][Name='..room.Data.Name..']\n')
    return true
end

return tp