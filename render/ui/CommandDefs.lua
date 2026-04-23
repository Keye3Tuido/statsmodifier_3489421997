-- ═══════════════════════════════════════════════════════════════════════════
-- CommandDefs: 指令定义模块
-- ═══════════════════════════════════════════════════════════════════════════
--
-- 如何添加新指令:
-- 1. 在 CommandGroups 中找到合适的分组（Display/Player/Game/Other），
--    或创建新分组 { name = "...", label = "[...]", commands = {} }
-- 2. 在该分组的 commands 表中添加一个条目:
--    {
--      key       = "mycommand",       -- 指令键名（与 OnExecuteCmd 匹配）
--      label     = "MyCommand",       -- 第一列显示名
--      desc      = "指令的中文描述",   -- 帮助弹窗中显示的描述
--      modType   = "none"|"value"|"text"|"enum"|"op_value",
--                                     -- none:  无参数，直接执行
--                                     -- value: 数值输入（支持 inf/-inf）
--                                     -- text:  文本输入（ID或名称）
--                                     -- enum:  可列举选项（第二列下拉）
--                                     -- op_value: 属性修改（SET/PLUS/TIMES + Force）
--      options   = "XXXOptions",      -- (仅 enum) 指向本模块中的选项表名
--      hasUnderscoreModifier = true,  -- (可选) 是否支持 _ 前缀修饰符
--      underscoreLabel = "副手(_)",   -- (可选) _ 修饰符的显示文本
--      statusKey = "mycommand",       -- (可选) StatusProvider 中的状态查询键
--    }
-- 3. 如果 modType == "enum"，在本模块中添加对应的选项表:
--    CommandDefs.XXXOptions = { { value = "0", label = "0: ..." }, ... }
-- 4. 如果需要状态显示，在 StatusProvider.lua 的 StatusFuncs 表中添加对应条目。
-- ═══════════════════════════════════════════════════════════════════════════

local CommandDefs = {}

-- ─── 属性列表（走 stat 解析路径）─────────────────────────────
CommandDefs.Stats = {
    { key = "speed",     label = "移速",     desc = "修改玩家移动速度。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。",       modType = "op_value", statusKey = "speed" },
    { key = "tears",     label = "射速",     desc = "修改玩家射速。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。",        modType = "op_value", statusKey = "tears" },
    { key = "damage",    label = "伤害",    desc = "修改玩家伤害。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。",           modType = "op_value", statusKey = "damage" },
    { key = "range",     label = "射程",     desc = "修改玩家射程。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。",       modType = "op_value", statusKey = "range" },
    { key = "shotspeed", label = "弹速", desc = "修改玩家弹速。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。",       modType = "op_value", statusKey = "shotspeed" },
    { key = "luck",      label = "幸运",      desc = "修改玩家幸运值。支持设置(=)、增加(+)、乘以(*)三种操作，可用强制模式(_)绕过游戏属性计算。空参取消修改。",             modType = "op_value", statusKey = "luck" },
    { key = "fly",       label = "飞行",    desc = "修改玩家飞行能力。非0赋予飞行，0剥夺飞行，空参清除修改。",                    modType = "value", statusKey = "fly" },
    { key = "size",      label = "体型",      desc = "修改玩家体型。支持设置(=)、增加(+)、乘以(*)三种操作。空参取消修改。",                             modType = "op_value", statusKey = "size" },
    { key = "all",       label = "全部清除",       desc = "清除指定玩家的所有属性修改。无需参数。",                     modType = "none", statusKey = "all" },
}

-- 操作符列表（用于 op_value 类型）
CommandDefs.Operators = {
    { key = "",  label = "SET(=)",   desc = "设置为指定值" },
    { key = "+", label = "PLUS(+)",  desc = "在当前值上增加" },
    { key = "*", label = "TIMES(*)", desc = "乘以指定倍数" },
}

-- 强制模式标记
CommandDefs.ForceFlag = { key = "_", label = "强制模式(_)", desc = "强制模式,不参与属性计算" }

-- ─── 可列举选项数据 ──────────────────────────────────────────

-- Challenge 选项 (45 items + clear)
CommandDefs.ChallengeOptions = {
    { value = "0",  label = "0: Clear" },
    { value = "1",  label = "1: Pitch Black" },
    { value = "2",  label = "2: High Brow" },
    { value = "3",  label = "3: Head Trauma" },
    { value = "4",  label = "4: Darkness Falls" },
    { value = "5",  label = "5: The Tank" },
    { value = "6",  label = "6: Solar System" },
    { value = "7",  label = "7: Suicide King" },
    { value = "8",  label = "8: Cat Got Your Tongue" },
    { value = "9",  label = "9: Demo Man" },
    { value = "10", label = "10: Cursed!" },
    { value = "11", label = "11: Glass Cannon" },
    { value = "12", label = "12: When Life Gives You Lemons" },
    { value = "13", label = "13: BEANS!" },
    { value = "14", label = "14: Its In The Cards" },
    { value = "15", label = "15: Slow Roll" },
    { value = "16", label = "16: Computer Savy" },
    { value = "17", label = "17: WAKA WAKA" },
    { value = "18", label = "18: The Host" },
    { value = "19", label = "19: The Family Man" },
    { value = "20", label = "20: Purist" },
    { value = "21", label = "21: XXXXXXXXL" },
    { value = "22", label = "22: SPEED!" },
    { value = "23", label = "23: Blue Bomber" },
    { value = "24", label = "24: PAY TO PLAY" },
    { value = "25", label = "25: Have a heart" },
    { value = "26", label = "26: I RULE!" },
    { value = "27", label = "27: BRAINS!" },
    { value = "28", label = "28: PRIDE DAY!" },
    { value = "29", label = "29: Onan's Streak" },
    { value = "30", label = "30: The Guardian" },
    { value = "31", label = "31: Backasswards" },
    { value = "32", label = "32: Aprils fool" },
    { value = "33", label = "33: Pokey mans" },
    { value = "34", label = "34: Ultra hard" },
    { value = "35", label = "35: PONG" },
    { value = "36", label = "36: Scat Man" },
    { value = "37", label = "37: Bloody Mary" },
    { value = "38", label = "38: Baptism by Fire" },
    { value = "39", label = "39: Isaac's Awakening" },
    { value = "40", label = "40: Seeing Double" },
    { value = "41", label = "41: Pica Run" },
    { value = "42", label = "42: Hot Potato" },
    { value = "43", label = "43: Cantripped!" },
    { value = "44", label = "44: Red Redemption" },
    { value = "45", label = "45: Delete This" },
}

-- EasterEggs 选项 (SeedEffect enum)
CommandDefs.EasterEggOptions = {
    { value = "0",   label = "0: Clear All" },
    { value = "1",   label = "1: MOVEMENT_PITCH" },
    { value = "2",   label = "2: HEALTH_PITCH" },
    { value = "3",   label = "3: CAMO_ISAAC" },
    { value = "4",   label = "4: CAMO_ENEMIES" },
    { value = "5",   label = "5: CAMO_PICKUPS" },
    { value = "6",   label = "6: CAMO_EVERYTHING" },
    { value = "7",   label = "7: FART_SOUNDS" },
    { value = "8",   label = "8: OLD_TV" },
    { value = "9",   label = "9: DYSLEXIA" },
    { value = "10",  label = "10: NO_HUD" },
    { value = "11",  label = "11: PICKUPS_SLIDE" },
    { value = "12",  label = "12: CONTROLS_REVERSED" },
    { value = "13",  label = "13: ALL_CHAMPIONS" },
    { value = "14",  label = "14: INVISIBLE_ISAAC" },
    { value = "15",  label = "15: INVISIBLE_ENEMIES" },
    { value = "16",  label = "16: INFINITE_BASEMENT" },
    { value = "17",  label = "17: ALWAYS_CHARMED" },
    { value = "18",  label = "18: ALWAYS_CONFUSED" },
    { value = "19",  label = "19: ALWAYS_AFRAID" },
    { value = "20",  label = "20: ALWAYS_ALT_FEAR" },
    { value = "21",  label = "21: CHARMED_AND_AFRAID" },
    { value = "23",  label = "23: EXTRA_BLOOD" },
    { value = "24",  label = "24: POOP_TRAIL" },
    { value = "25",  label = "25: PACIFIST" },
    { value = "26",  label = "26: DAMAGE_WHEN_STOPPED" },
    { value = "27",  label = "27: DAMAGE_ON_INTERVAL" },
    { value = "28",  label = "28: DAMAGE_ON_TIME_LIMIT" },
    { value = "29",  label = "29: PILLS_NEVER_IDENTIFY" },
    { value = "30",  label = "30: MYSTERY_TAROT_CARDS" },
    { value = "32",  label = "32: ENEMIES_RESPAWN" },
    { value = "33",  label = "33: ITEMS_COST_MONEY" },
    { value = "35",  label = "35: BIG_HEAD" },
    { value = "36",  label = "36: SMALL_HEAD" },
    { value = "37",  label = "37: BLACK_ISAAC" },
    { value = "38",  label = "38: GLOWING_TEARS" },
    { value = "41",  label = "41: SLOW_MUSIC" },
    { value = "42",  label = "42: ULTRA_SLOW_MUSIC" },
    { value = "43",  label = "43: FAST_MUSIC" },
    { value = "44",  label = "44: ULTRA_FAST_MUSIC" },
    { value = "46",  label = "46: NO_FACE" },
    { value = "47",  label = "47: HIGH_DAMAGE" },
    { value = "48",  label = "48: MASSIVE_DAMAGE" },
    { value = "52",  label = "52: ICE_PHYSICS" },
    { value = "53",  label = "53: KAPPA" },
    { value = "54",  label = "54: CHRISTMAS" },
    { value = "55",  label = "55: KIDS_MODE" },
    { value = "56",  label = "56: PERM_CURSE_DARKNESS" },
    { value = "57",  label = "57: PERM_CURSE_LABYRINTH" },
    { value = "58",  label = "58: PERM_CURSE_LOST" },
    { value = "59",  label = "59: PERM_CURSE_UNKNOWN" },
    { value = "60",  label = "60: PERM_CURSE_MAZE" },
    { value = "61",  label = "61: PERM_CURSE_BLIND" },
    { value = "62",  label = "62: PERM_CURSE_CURSED" },
    { value = "63",  label = "63: PREV_CURSE_DARKNESS" },
    { value = "64",  label = "64: PREV_CURSE_LABYRINTH" },
    { value = "65",  label = "65: PREV_CURSE_LOST" },
    { value = "66",  label = "66: PREV_CURSE_UNKNOWN" },
    { value = "67",  label = "67: PREV_CURSE_MAZE" },
    { value = "68",  label = "68: PREV_CURSE_BLIND" },
    { value = "70",  label = "70: PREVENT_ALL_CURSES" },
    { value = "71",  label = "71: NO_BOSS_ROOM_EXITS" },
    { value = "72",  label = "72: PICKUPS_TIMEOUT" },
    { value = "73",  label = "73: INVINCIBLE" },
    { value = "74",  label = "74: SHOOT_IN_MOVE_DIR" },
    { value = "75",  label = "75: SHOOT_OPP_MOVE_DIR" },
    { value = "76",  label = "76: AXIS_ALIGNED_CTRL" },
    { value = "77",  label = "77: SUPER_HOT" },
    { value = "78",  label = "78: RETRO_VISION" },
    { value = "79",  label = "79: G_FUEL" },
}

-- TP 选项 (GridRooms enum, negative IDs for special rooms)
CommandDefs.TPOptions = {
    { value = "-1",  label = "-1: Devil" },
    { value = "-2",  label = "-2: Error" },
    { value = "-3",  label = "-3: Debug" },
    { value = "-4",  label = "-4: Dungeon" },
    { value = "-5",  label = "-5: BossRush" },
    { value = "-6",  label = "-6: BlackMarket" },
    { value = "-7",  label = "-7: MegaSatan" },
    { value = "-8",  label = "-8: BlueWomb" },
    { value = "-9",  label = "-9: TheVoid" },
    { value = "-10", label = "-10: SecretExit" },
    { value = "-11", label = "-11: GideonDungeon" },
    { value = "-12", label = "-12: Genesis" },
    { value = "-13", label = "-13: SecretShop" },
    { value = "-14", label = "-14: RotgutDungeon1" },
    { value = "-15", label = "-15: RotgutDungeon2" },
    { value = "-16", label = "-16: BlueRoom" },
    { value = "-17", label = "-17: ExtraBoss" },
    { value = "-18", label = "-18: AngelShop" },
    { value = "-19", label = "-19: Deathmatch" },
    { value = "-20", label = "-20: LilPortal" },
}

-- PlayerType 选项 (vanilla characters)
CommandDefs.PlayerTypeOptions = {
    { value = "0",  label = "0: Isaac" },
    { value = "1",  label = "1: Magdalene" },
    { value = "2",  label = "2: Cain" },
    { value = "3",  label = "3: Judas" },
    { value = "4",  label = "4: Blue Baby" },
    { value = "5",  label = "5: Eve" },
    { value = "6",  label = "6: Samson" },
    { value = "7",  label = "7: Azazel" },
    { value = "8",  label = "8: Lazarus" },
    { value = "9",  label = "9: Eden" },
    { value = "10", label = "10: The Lost" },
    { value = "11", label = "11: Lazarus II" },
    { value = "12", label = "12: Black Judas" },
    { value = "13", label = "13: Lilith" },
    { value = "14", label = "14: Keeper" },
    { value = "15", label = "15: Apollyon" },
    { value = "16", label = "16: The Forgotten" },
    { value = "17", label = "17: The Soul" },
    { value = "18", label = "18: Bethany" },
    { value = "19", label = "19: Jacob" },
    { value = "20", label = "20: Esau" },
    { value = "_isaac",      label = "T.Isaac" },
    { value = "_magdalene",  label = "T.Magdalene" },
    { value = "_cain",       label = "T.Cain" },
    { value = "_judas",      label = "T.Judas" },
    { value = "_bluebaby",   label = "T.Blue Baby" },
    { value = "_eve",        label = "T.Eve" },
    { value = "_samson",     label = "T.Samson" },
    { value = "_azazel",     label = "T.Azazel" },
    { value = "_lazarus",    label = "T.Lazarus" },
    { value = "_eden",       label = "T.Eden" },
    { value = "_thelost",    label = "T.Lost" },
    { value = "_lilith",     label = "T.Lilith" },
    { value = "_keeper",     label = "T.Keeper" },
    { value = "_apollyon",   label = "T.Apollyon" },
    { value = "_theforgotten",label = "T.Forgotten" },
    { value = "_bethany",    label = "T.Bethany" },
    { value = "_jacob",      label = "T.Jacob" },
}


-- ─── 命令列表 ────────────────────────────────────────────────
-- group: 功能分组
-- modType: none=无参数, value=数值, text=文本, enum=可列举选项
-- options: 可列举的选项列表（用于第二列显示）
-- hasUnderscoreModifier: 是否支持 _ 前缀修饰符（gc/rc/eastereggs）
-- statusKey: StatusProvider 中的状态查询键
CommandDefs.CommandGroups = {
    {
        name = "Display",
        label = "[显示]",
        commands = {
            { key = "entity",  label = "实体显示",  desc = "打开/关闭实体信息显示。显示所有实体的类型和属性。",     modType = "none", statusKey = "entity" },
            { key = "id",      label = "ID显示",  desc = "打开/关闭玩家ID显示。在每个玩家头顶显示其ID。",                       modType = "none", statusKey = "id" },
            { key = "info",    label = "属性显示",     desc = "打开/关闭玩家属性修改状态显示。",                          modType = "none", statusKey = "info" },
            { key = "mouse",   label = "鼠标显示",    desc = "打开/关闭鼠标位置三维度坐标显示（世界/屏幕/渲染坐标）。",     modType = "none", statusKey = "mouse" },
        },
    },
    {
        name = "Player",
        label = "[玩家]",
        commands = {
            { key = "blind",      label = "蒙眼",      desc = "切换蒙眼状态。蒙眼后角色无法发射眼泪。",                                    modType = "none", statusKey = "blind" },
            { key = "bombs",      label = "炸弹",      desc = "给予玩家炸弹。支持负数和±inf。空参清空炸弹。",                                  modType = "value", statusKey = "bombs" },
            { key = "coins",      label = "硬币",      desc = "给予玩家硬币。支持负数和±inf。空参清空硬币。",                                  modType = "value", statusKey = "coins" },
            { key = "die",        label = "死亡",        desc = "杀死当前玩家。",                                                  modType = "none" },
            { key = "gc",         label = "给予道具",   desc = "给予玩家道具。输入道具ID或名称子串（不区分大小写）。前缀_将主动道具放入副手。支持添加错误道具。",                                 modType = "text", hasUnderscoreModifier = true, underscoreLabel = "副手(_)", statusKey = "gc" },
            { key = "gigabombs",  label = "巨型炸弹",  desc = "给予玩家巨型炸弹。支持负数和±inf。空参将大炸弹变回普通炸弹。",                            modType = "value", statusKey = "gigabombs" },
            { key = "golden",     label = "金掉落",     desc = "给予玩家金炸弹和金钥匙。无需参数。",                                             modType = "none" },
            { key = "gulp",       label = "吞饰品",       desc = "玩家获得被吞下的饰品。输入饰品ID或名称子串（不区分大小写）。空参吞下当前饰品栏中的饰品。",                                  modType = "text", hasUnderscoreModifier = true, underscoreLabel = "金饰品(_)", allowEmpty = true },
            { key = "keys",       label = "钥匙",       desc = "给予玩家钥匙。支持负数和±inf。空参清空钥匙。",                                   modType = "value", statusKey = "keys" },
            { key = "lost",       label = "白火形态",       desc = "切换玩家灵魂形态和普通形态（白火效果）。",                                          modType = "none", statusKey = "lost" },
            { key = "playertype", label = "角色类型", desc = "修改玩家角色类型。选择或输入角色ID/名称（不区分大小写，可用子串缩写）。前缀_切换为堕化版本。空参查看当前角色。",                                 modType = "enum", options = "PlayerTypeOptions", statusKey = "playertype" },
            { key = "pocket",     label = "口袋道具",     desc = "在每个首次访问的新房间中给予玩家一次性主动道具。输入道具ID或名称，0取消。",                                    modType = "text" },
            { key = "rc",         label = "移除道具", desc = "移除玩家道具。输入道具ID或名称子串（不区分大小写）。前缀_优先从副手移除主动道具。支持移除错误道具。",                                 modType = "text", hasUnderscoreModifier = true, underscoreLabel = "副手优先(_)" },
            { key = "revive",     label = "复活",     desc = "复活玩家。只能在玩家实体被移除前使用。复活后菜单中将不能继续游戏。",                                   modType = "none" },
            { key = "wavycap",    label = "致幻层数",    desc = "修改玩家迷幻蘑菇的致幻层数。空参查看当前致幻层数。",                                        modType = "value", statusKey = "wavycap" },
        },
    },
    {
        name = "Game",
        label = "[游戏]",
        commands = {
            { key = "ascent",           label = "回溯标签",       desc = "切换回溯线标签。该值决定了陵墓II/炼狱II的头目房是否生成爸爸的便条。",                                modType = "none", statusKey = "ascent" },
            { key = "bullettime",       label = "游戏减速",   desc = "减速游戏。输入0~1之间的倍速值。空参恢复正常速度。",                            modType = "value", statusKey = "bullettime" },
            { key = "challenge",        label = "切换挑战",    desc = "切换当前挑战标签。选择或输入挑战ID/名称（不区分大小写，可用子串缩写）。0清除挑战。空参查看当前挑战。",                       modType = "enum", options = "ChallengeOptions", statusKey = "challenge" },
            { key = "clean",            label = "清空状态修改",        desc = "清除所有玩家的所有属性修改。",                                          modType = "none" },
            { key = "delirium",         label = "精神错乱",     desc = "如果当前层存在精神错乱，则移除迷宫诅咒并传送至精神错乱房间。",                                modType = "none" },
            { key = "eastereggs",       label = "彩蛋种子",   desc = "添加/删除彩蛋种子效果。选择添加，勾选删除模式(_)则删除。0清除所有效果。空参查看当前效果。",                      modType = "enum", options = "EasterEggOptions", hasUnderscoreModifier = true, underscoreLabel = "删除模式(_)", statusKey = "eastereggs" },
            { key = "finish",           label = "结束游戏",       desc = "结束当前游戏。",                                             modType = "none" },
            { key = "icansee",          label = "全图揭示",      desc = "移除诅咒、揭示全图、显示究极隐藏房位置、显示所有问号道具图标。",                        modType = "none" },
            { key = "madeinheaven",     label = "游戏加速", desc = "加速游戏。输入不小于1的倍速值。空参恢复正常速度。",                              modType = "value", statusKey = "madeinheaven" },
            { key = "mirrormineshaft",  label = "镜子/矿井",       desc = "如果当前层存在镜子房间或矿井房间，则移除迷宫诅咒并传送至对应房间。",                                 modType = "none" },
            { key = "rush",             label = "车轮战入口",         desc = "尝试在当前房间生成头目车轮战(BossRush)和蓝子宫(BlueWomb)入口。",                                modType = "none" },
            { key = "seeds",            label = "修改种子",        desc = "不重新开始游戏，修改当前游戏的种子。大小写不敏感、空格不敏感，支持彩蛋种子。",                      modType = "text" },
            { key = "timecounter",      label = "计时器",  desc = "修改游戏内计时器（单位：秒）。支持负数和±inf。",                            modType = "value" },
            { key = "tp",               label = "传送",           desc = "传送玩家至指定房间。输入房间坐标或类型名称（不区分大小写，可用子串缩写）。空参显示当前房间信息。",                                      modType = "enum", options = "TPOptions", statusKey = "tp" },
            { key = "uncovereverything",label = "揭示全部",      desc = "移除诅咒，显示该层当前维度所有房间和红房间，并开启所有红房间的门和隐藏房的门。",                              modType = "none" },
        },
    },
    {
        name = "Other",
        label = "[其他]",
        commands = {
            { key = "version", label = "版本号", desc = "在控制台输出模组版本号和模组绝对路径。", modType = "none", statusKey = "version" },
            { key = "wrap", label = "安全包装", desc = "切换安全包装状态。包装所有回调函数，使回调报错时不会导致游戏崩溃。使用debug库拦截新注册的回调并自动包装。对Repentogon不生效。可能影响性能。", modType = "none", statusKey = "wrap" },
            { key = "anonymous", label = "清理匿名回调", desc = "删除所有匿名模组的回调函数。用于清理未正确注销的回调。", modType = "none" },
        },
    },
}

-- ─── 获取选项表 ──────────────────────────────────────────────
function CommandDefs.GetOptions(optionsKey)
    if not optionsKey then return nil end
    return CommandDefs[optionsKey]
end

-- ─── 构建扁平命令列表（带分组标记，用于第一列渲染）──────────
-- 每个条目: { type="group"|"cmd", ... }
CommandDefs._flatCommands = nil
function CommandDefs.GetFlatCommands()
    if CommandDefs._flatCommands then return CommandDefs._flatCommands end
    CommandDefs._flatCommands = {}
    for _, group in ipairs(CommandDefs.CommandGroups) do
        -- 分组标题
        table.insert(CommandDefs._flatCommands, {
            type = "group",
            label = group.label,
        })
        -- 组内命令
        for _, cmd in ipairs(group.commands) do
            table.insert(CommandDefs._flatCommands, {
                type = "cmd",
                key = cmd.key,
                label = cmd.label,
                desc = cmd.desc,
                modType = cmd.modType,
                options = cmd.options,
                hasUnderscoreModifier = cmd.hasUnderscoreModifier,
                underscoreLabel = cmd.underscoreLabel,
                statusKey = cmd.statusKey,
                allowEmpty = cmd.allowEmpty,
            })
        end
    end
    return CommandDefs._flatCommands
end

return CommandDefs
