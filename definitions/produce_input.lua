local Enums = require("definitions.enums")
local Stats=Enums.Stats
local Commands=Enums.Commands
local Input2Id ={}

Input2Id.StatsID={
    ['speed']       = Stats.SPEED,      ['sp'] = Stats.SPEED,
    ['tears']       = Stats.TEARS,      ['te'] = Stats.TEARS,
    ['damage']      = Stats.DAMAGE,     ['da'] = Stats.DAMAGE,
    ['range']       = Stats.RANGE,      ['ra'] = Stats.RANGE,
    ['shotspeed']   = Stats.SHOTSPEED,  ['sh'] = Stats.SHOTSPEED,
    ['luck']        = Stats.LUCK,       ['lu'] = Stats.LUCK,
    ['fly']         = Stats.FLYING,     ['fl'] = Stats.FLYING,
    ['size']        = Stats.SIZE,       ['si'] = Stats.SIZE,
    ['all']         = Stats.ALL,        ['al'] = Stats.ALL,
}

Input2Id.CommandsID={
    ['blind']               = Commands.BLIND,                   ['bl'] = Commands.BLIND,
    ['icansee']             = Commands.ICANSEE,                 ['ic'] = Commands.ICANSEE,
    ['uncovereverything']   = Commands.UNCOVER,                 ['un'] = Commands.UNCOVER,
    ['coins']               = Commands.COINS,                   ['co'] = Commands.COINS,
    ['bombs']               = Commands.BOMBS,                   ['bo'] = Commands.BOMBS,
    ['gigabombs']           = Commands.GIGA_BOMBS,              ['gi'] = Commands.GIGA_BOMBS,
    ['keys']                = Commands.KEYS,                    ['ke'] = Commands.KEYS,
    ['golden']              = Commands.GOLDEN,                  ['go'] = Commands.GOLDEN,
    ['playertype']          = Commands.CHANGE_PLAYER_TYPE,      ['pl'] = Commands.CHANGE_PLAYER_TYPE,
    ['die']                 = Commands.DIE,                     ['di']= Commands.DIE,
    ['revive']              = Commands.REVIVE,                  ['re'] = Commands.REVIVE,
    ['challenge']           = Commands.CHALLENGE,               ['ch'] = Commands.CHALLENGE,
    ['eastereggs']          = Commands.EGGS,                    ['ea'] = Commands.EGGS,
    ['timecounter']         = Commands.SET_TIME,                ['ti'] = Commands.SET_TIME,
    ['clean']               = Commands.CLEAN,                   ['cl'] = Commands.CLEAN,
    ['info']                = Commands.INFO,                    ['in'] = Commands.INFO,
    ['gulp']                = Commands.GULP,                    ['gu'] = Commands.GULP,
    ['finish']              = Commands.FINISH,                  ['fi'] = Commands.FINISH,
    ['seeds']               = Commands.SEEDS,                   ['se'] = Commands.SEEDS,
    ['entity']              = Commands.ENTITY,                  ['en'] = Commands.ENTITY,
    ['pocket']              = Commands.POCKET,                  ['po'] = Commands.POCKET,
    ['mouse']               = Commands.MOUSE,                   ['mo'] = Commands.MOUSE,
    ['madeinheaven']        = Commands.MADEINHEAVEN,            ['ma'] = Commands.MADEINHEAVEN,
    ['rush']                = Commands.BOSSRUSH_HUSH,           ['ru'] = Commands.BOSSRUSH_HUSH,
    ['delirium']            = Commands.DELIRIUM,                ['de'] = Commands.DELIRIUM,
    ['wavycap']             = Commands.WAVYCAP,                 ['wa'] = Commands.WAVYCAP,
    ['lost']                = Commands.LOST,                    ['lo'] = Commands.LOST,
    ['mirrormineshaft']     = Commands.MIRROR_MINESHAFT,        ['mi'] = Commands.MIRROR_MINESHAFT,
    ['ascent']              = Commands.ASCENT,                  ['as'] = Commands.ASCENT,
    ['bullettime']          = Commands.BULLETTIME,              ['bu'] = Commands.BULLETTIME,


    -------------------------------------------- 下面的指令无缩写形式
    ['gc']                  = Commands.GIVEITEM,
    ['rc']                  = Commands.REMOVEITEM,
    ['tp']                  = Commands.TP,
    ['id']                  = Commands.SHOWID,
    ['version']             = Commands.VERSION,
    ['wrap']                = Commands.WRAP,                    ['wr'] = Commands.WRAP,
    ['anonymous']           = Commands.ANONYMOUS,               ['an'] = Commands.ANONYMOUS,
}

Input2Id.OpsID={                -- gsub pattern
    [Enums.Ops.SET]     = '=',
    [Enums.Ops.PLUS]    = '%+',
    [Enums.Ops.TIMES]   = '%*',
}

return Input2Id