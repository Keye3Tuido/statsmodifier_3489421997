-- ═══════════════════════════════════════════════════════════════════════════
-- CommandsList: 指令路由表
-- ═══════════════════════════════════════════════════════════════════════════
-- 【增加新指令时，只需在此文件修改两处：】
--   1. 在 Funcs 表中加一行: mycommand = require('operations.commands.mycommand')
--   2. 在 CommandsList 表中加全名（必须）+ 缩写别名（可选）
-- 其余步骤见 enums.lua / CommandDefs.lua / addCallbacks.lua 各自的说明注释。
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 指令实现函数表 ──────────────────────────────────────────
local Funcs = {
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
    wrap                = require('operations.commands.wrap'),
    anonymous           = require('operations.commands.anonymous'),
    -- new_command = require('operations.commands.new_command'),
}

-- ─── 控制台输入 → 实现函数（全名 + 缩写别名）────────────────
-- 函数应当有 boolean 返回值，表示是否成功执行指令。
local CommandsList = {
    -- [显示]
    ['entity']           = Funcs.entity,           ['en'] = Funcs.entity,
    ['id']               = Funcs.showid,
    ['info']             = Funcs.info,             ['in'] = Funcs.info,
    ['mouse']            = Funcs.mouse,            ['mo'] = Funcs.mouse,
    -- [玩家]
    ['blind']            = Funcs.blind,            ['bl'] = Funcs.blind,
    ['bombs']            = Funcs.bombs,            ['bo'] = Funcs.bombs,
    ['coins']            = Funcs.coins,            ['co'] = Funcs.coins,
    ['die']              = Funcs.die,              ['di'] = Funcs.die,
    ['gc']               = Funcs.giveitem,
    ['gigabombs']        = Funcs.giga_bombs,       ['gi'] = Funcs.giga_bombs,
    ['golden']           = Funcs.golden,           ['go'] = Funcs.golden,
    ['gulp']             = Funcs.gulp,             ['gu'] = Funcs.gulp,
    ['keys']             = Funcs.keys,             ['ke'] = Funcs.keys,
    ['lost']             = Funcs.lost,             ['lo'] = Funcs.lost,
    ['playertype']       = Funcs.change_player_type, ['pl'] = Funcs.change_player_type,
    ['pocket']           = Funcs.pocket,           ['po'] = Funcs.pocket,
    ['rc']               = Funcs.removeitem,
    ['revive']           = Funcs.revive,           ['re'] = Funcs.revive,
    ['wavycap']          = Funcs.wavycap,          ['wa'] = Funcs.wavycap,
    -- [游戏]
    ['ascent']           = Funcs.ascent,           ['as'] = Funcs.ascent,
    ['bullettime']       = Funcs.bullettime,       ['bu'] = Funcs.bullettime,
    ['challenge']        = Funcs.challenge,        ['ch'] = Funcs.challenge,
    ['clean']            = Funcs.clean,            ['cl'] = Funcs.clean,
    ['delirium']         = Funcs.delirium,         ['de'] = Funcs.delirium,
    ['eastereggs']       = Funcs.eggs,             ['ea'] = Funcs.eggs,
    ['finish']           = Funcs.finish,           ['fi'] = Funcs.finish,
    ['icansee']          = Funcs.icansee,          ['ic'] = Funcs.icansee,
    ['madeinheaven']     = Funcs.madeinheaven,     ['ma'] = Funcs.madeinheaven,
    ['mirrormineshaft']  = Funcs.mirror_mineshaft, ['mi'] = Funcs.mirror_mineshaft,
    ['rush']             = Funcs.bossrush_hush,    ['ru'] = Funcs.bossrush_hush,
    ['seeds']            = Funcs.seeds,            ['se'] = Funcs.seeds,
    ['timecounter']      = Funcs.set_time,         ['ti'] = Funcs.set_time,
    ['tp']               = Funcs.tp,
    ['uncovereverything']= Funcs.uncover,          ['un'] = Funcs.uncover,
    -- [其他]
    ['anonymous']        = Funcs.anonymous,        ['an'] = Funcs.anonymous,
    ['version']          = Funcs.version,
    ['wrap']             = Funcs.wrap,             ['wr'] = Funcs.wrap,
}

return CommandsList