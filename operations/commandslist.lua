local Enums = require('definitions.enums')
local Commands={
    blind               = require('operations.commands.blind'),
    bombs               = require('operations.commands.bombs'),
    challenge           = require('operations.commands.challenge'),
    change_player_type  = require('operations.commands.change_player_type'),
    clean               = require('operations.commands.clean'),
    coins               = require('operations.commands.coins'),
    die                 = require('operations.commands.die'),
    eggs                = require('operations.commands.eggs'),
    entity              = require('operations.commands.entity'),
    finish              = require('operations.commands.finish'),
    giga_bombs          = require('operations.commands.giga_bombs'),
    giveitem            = require('operations.commands.giveitem'),
    golden              = require('operations.commands.golden'),
    gulp                = require('operations.commands.gulp'),
    icansee             = require('operations.commands.icansee'),
    info                = require('operations.commands.info'),
    keys                = require('operations.commands.keys'),
    mouse               = require('operations.commands.mouse'),
    pocket              = require('operations.commands.pocket'),
    removeitem          = require('operations.commands.removeitem'),
    revive              = require('operations.commands.revive'),
    seeds               = require('operations.commands.seeds'),
    set_time            = require('operations.commands.set_time'),
    showid              = require('operations.commands.showid'),
    uncover             = require('operations.commands.uncover'),
    madeinheaven        = require('operations.commands.madeinheaven'),
    bossrush_hush       = require('operations.commands.bossrush_hush'),
    delirium            = require('operations.commands.delirium'),
    wavycap             = require('operations.commands.wavycap'),
    lost                = require('operations.commands.lost'),
    tp                  = require('operations.commands.tp'),
    mirror_mineshaft    = require('operations.commands.mirror_mineshaft'),
    ascent              = require('operations.commands.ascent'),
    bullettime          = require('operations.commands.bullettime'),
    version             = require('operations.commands.version'),
    -- new_command = require('operations.commands.new_command'),
    -- 函数名小写，与enums.Commands中的key一致
    -- 新增功能还应当更新produce_input.Input2Id.CommandsID表
    -- 函数应当有boolean返回值，表示是否成功执行指令
}

local CommandsList={}
for cmd,id in pairs(Enums.Commands) do
    CommandsList[id]=Commands[cmd:lower()]
end

return CommandsList