local Enums={}

Enums.Infinity={
    INF=1e308,
    NINF=-1e308
}

Enums.Stats={
    SPEED=1,
    TEARS=2,
    DAMAGE=3,
    RANGE=4,
    SHOTSPEED=5,
    LUCK=6,
    FLYING=7,   -- No Renderer
    SIZE=8,     -- No Renderer
    ALL=9,      -- No Renderer
}

Enums.StatsShouldRender={
    [Enums.Stats.SPEED]=true,
    [Enums.Stats.TEARS]=true,
    [Enums.Stats.DAMAGE]=true,
    [Enums.Stats.RANGE]=true,
    [Enums.Stats.SHOTSPEED]=true,
    [Enums.Stats.LUCK]=true,
    [Enums.Stats.FLYING]=false, -- No Renderer
    [Enums.Stats.SIZE]=false,   -- No Renderer
    [Enums.Stats.ALL]=false,    -- No Renderer
}


Enums.Commands={
    BLIND=20,
    ICANSEE=21,
    COINS=22,
    BOMBS=23,
    GIGA_BOMBS=24,
    KEYS=25,
    GOLDEN=26,
    CHANGE_PLAYER_TYPE=27,
    GIVEITEM=28,
    REMOVEITEM=29,
    SET_TIME=30,
    DIE=31,
    REVIVE=32,
    CHALLENGE=33,
    EGGS=34,
    GULP=35,
    UNCOVER=36,
    FINISH=37,
    SEEDS=38,
    ENTITY=39,
    POCKET=40,
    DELIRIUM=41,
    BOSSRUSH_HUSH=42,
    WAVYCAP=43,
    LOST=44,
    TP=45,
    MIRROR_MINESHAFT=46,
    ASCENT=47,
    SHOWID=100,
    CLEAN=101,
    INFO=102,
    MOUSE=103,
    MADEINHEAVEN=104,
    BULLETTIME=105,
    VERSION=1000,
    -- 新指令的key应当与函数名一致
}

Enums.CacheFlags={
    [Enums.Stats.SPEED]=CacheFlag.CACHE_SPEED,
    [Enums.Stats.TEARS]=CacheFlag.CACHE_FIREDELAY,
    [Enums.Stats.DAMAGE]=CacheFlag.CACHE_DAMAGE,
    [Enums.Stats.RANGE]=CacheFlag.CACHE_RANGE,
    [Enums.Stats.SHOTSPEED]=CacheFlag.CACHE_SHOTSPEED,
    [Enums.Stats.LUCK]=CacheFlag.CACHE_LUCK,
    [Enums.Stats.FLYING]=CacheFlag.CACHE_FLYING,
    [Enums.Stats.SIZE]=CacheFlag.CACHE_SIZE,
}

Enums.Ops={
    SET=1,
    PLUS=2,
    TIMES=3
}


return Enums