local Enums = require("definitions.enums")
local Stats=Enums.Stats
local Input2Id ={}

-- 属性名 → 属性枚举（含缩写别名）
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

-- 操作符 gsub 模式
Input2Id.OpsID={
    [Enums.Ops.SET]     = '=',
    [Enums.Ops.PLUS]    = '%+',
    [Enums.Ops.TIMES]   = '%*',
}

return Input2Id