<!-- omit in toc -->
# 指令介绍

$\bf\color{red}{所有指令不区分大小写，可使用指令前两位字母作为指令缩写}$
> 例如`UncoverEverything`,`UN`,`un`均代表同一指令


<!-- omit in toc -->
## 指令速查

- [基础显示功能](#基础显示功能)
  - [`entity`](#entity)
  - [`id`](#id)
  - [`info`](#info)
  - [`mouse`](#mouse)
- [玩家属性修改](#玩家属性修改)
  - [`damage`](#damage)
  - [`luck`](#luck)
  - [`range`](#range)
  - [`shotspeed`](#shotspeed)
  - [`speed`](#speed)
  - [`tears`](#tears)
- [隐藏属性修改](#隐藏属性修改)
  - [`fly`](#fly)
  - [`size`](#size)
- [清除所有属性修改](#清除所有属性修改)
  - [`all`](#all)
  - [`clean`](#clean)
- [玩家功能修改](#玩家功能修改)
  - [`blind`](#blind)
  - [`bombs`](#bombs)
  - [`coins`](#coins)
  - [`die`](#die)
  - [`gc`](#gc)
  - [`gigabombs`](#gigabombs)
  - [`golden`](#golden)
  - [`gulp`](#gulp)
  - [`keys`](#keys)
  - [`lost`](#lost)
  - [`playertype`](#playertype)
  - [`pocket`](#pocket)
  - [`rc`](#rc)
  - [`revive`](#revive)
  - [`wavycap`](#wavycap)
- [游戏状态修改](#游戏状态修改)
  - [`ascent`](#ascent)
  - [`bullettime`](#bullettime)
  - [`changechallenge`](#changechallenge)
  - [`delirium`](#delirium)
  - [`eastereggs`](#eastereggs)
  - [`finish`](#finish)
  - [`icansee`](#icansee)
  - [`madeinheaven`](#madeinheaven)
  - [`mirrormineshaft`](#mirrormineshaft)
  - [`rush`](#rush)
  - [`seeds`](#seeds)
  - [`timecounter`](#timecounter)
  - [`tp`](#tp)
  - [`uncovereverything`](#uncovereverything)
- [不支持缩写的指令](#不支持缩写的指令)
  - [`version`](#version)

---

## 基础显示功能

### `entity`

打开/关闭实体信息显示。
指令格式：
`entity`

[点我返回速查](#指令速查)

### `id`

打开/关闭玩家ID显示。
指令格式：
`id`

[点我返回速查](#指令速查)

### `info`

打开/关闭玩家属性修改状态显示。
指令格式：
`info`

[点我返回速查](#指令速查)

### `mouse`

打开/关闭鼠标位置三维度坐标显示。
指令格式：
`mouse`

[点我返回速查](#指令速查)

---

## 玩家属性修改

### `damage`

修改玩家伤害，指令格式为：`damageNN MM`，即设置ID为`NN`的玩家伤害为`MM`。
`MM`可为负数，也可为`±inf`表示无穷大。
其他指令格式：

1. `damageNN +MM`: 将ID为`NN`的玩家的伤害增加`MM`
2. `damageNN *MM`: 将ID为`NN`的玩家的伤害乘以`MM`
3. `damageNN _MM`: **强制**设置ID为`NN`的玩家的伤害为`MM`，该属性不参与游戏内的属性计算
4. `damageNN _+MM`: **强制**将ID为`NN`的玩家的伤害增加`MM`，该属性不参与游戏内的属性计算
5. `damageNN _*MM`: **强制**将ID为`NN`的玩家的伤害乘以`MM`，该属性不参与游戏内的属性计算
6. `damageNN`：取消ID为`NN`的玩家伤害修改

`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `luck`

修改玩家幸运值，指令格式为：`luckNN MM`，即设置ID为`NN`的玩家幸运值为`MM`。
`MM`可为负数，也可为`±inf`表示无穷大。
其他指令格式：

1. `luckNN +MM`: 将ID为`NN`的玩家的幸运值增加`MM`
2. `luckNN *MM`: 将ID为`NN`的玩家的幸运值乘以`MM`
3. `luckNN _MM`: **强制**设置ID为`NN`的玩家的幸运值为`MM`，该属性不参与游戏内的属性计算
4. `luckNN _+MM`: **强制**将ID为`NN`的玩家的幸运值增加`MM`，该属性不参与游戏内的属性计算
5. `luckNN _*MM`: **强制**将ID为`NN`的玩家的幸运值乘以`MM`，该属性不参与游戏内的属性计算
6. `luckNN`：取消ID为`NN`的玩家幸运值修改

`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `range`

修改玩家射程，指令格式为：`rangeNN MM`，即设置ID为`NN`的玩家射程为`MM`。
`MM`可为负数，也可为`±inf`表示无穷大。
其他指令格式：

1. `rangeNN +MM`: 将ID为`NN`的玩家的射程增加`MM`
2. `rangeNN *MM`: 将ID为`NN`的玩家的射程乘以`MM`
3. `rangeNN _MM`: **强制**设置ID为`NN`的玩家的射程为`MM`，该属性不参与游戏内的属性计算
4. `rangeNN _+MM`: **强制**将ID为`NN`的玩家的射程增加`MM`，该属性不参与游戏内的属性计算
5. `rangeNN _*MM`: **强制**将ID为`NN`的玩家的射程乘以`MM`，该属性不参与游戏内的属性计算
6. `rangeNN`：取消ID为`NN`的玩家射程修改

`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `shotspeed`

修改玩家弹速，指令格式为：`shotspeedNN MM`，即设置ID为`NN`的玩家弹速为`MM`。
`MM`可为负数，也可为`±inf`表示无穷大。
其他指令格式：

1. `shotspeedNN +MM`: 将ID为`NN`的玩家的弹速增加`MM`
2. `shotspeedNN *MM`: 将ID为`NN`的玩家的弹速乘以`MM`
3. `shotspeedNN _MM`: **强制**设置ID为`NN`的玩家的弹速为`MM`，该属性不参与游戏内的属性计算
4. `shotspeedNN _+MM`: **强制**将ID为`NN`的玩家的弹速增加`MM`，该属性不参与游戏内的属性计算
5. `shotspeedNN _*MM`: **强制**将ID为`NN`的玩家的弹速乘以`MM`，该属性不参与游戏内的属性计算
6. `shotspeedNN`：取消ID为`NN`的玩家弹速修改

`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `speed`

修改玩家移动速度，指令格式为：`speedNN MM`，即设置ID为`NN`的玩家移动速度为`MM`。
`MM`可为负数，也可为`±inf`表示无穷大。
其他指令格式：

1. `speedNN +MM`: 将ID为`NN`的玩家的移动速度增加`MM`
2. `speedNN *MM`: 将ID为`NN`的玩家的移动速度乘以`MM`
3. `speedNN _MM`: **强制**设置ID为`NN`的玩家的移动速度为`MM`，该属性不参与游戏内的属性计算
4. `speedNN _+MM`: **强制**将ID为`NN`的玩家的移动速度增加`MM`，该属性不参与游戏内的属性计算
5. `speedNN _*MM`: **强制**将ID为`NN`的玩家的移动速度乘以`MM`，该属性不参与游戏内的属性计算
6. `speedNN`：取消ID为`NN`的玩家速度修改

`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `tears`

修改玩家射速，指令格式为：`tearsNN MM`，即设置ID为`NN`的玩家射速为`MM`。
`MM`可为负数，也可为`±inf`表示无穷大。
其他指令格式：

1. `tearsNN +MM`: 将ID为`NN`的玩家的射速增加`MM`
2. `tearsNN *MM`: 将ID为`NN`的玩家的射速乘以`MM`
3. `tearsNN _MM`: **强制**设置ID为`NN`的玩家的射速为`MM`，该属性不参与游戏内的属性计算
4. `tearsNN _+MM`: **强制**将ID为`NN`的玩家的射速增加`MM`，该属性不参与游戏内的属性计算
5. `tearsNN _*MM`: **强制**将ID为`NN`的玩家的射速乘以`MM`，该属性不参与游戏内的属性计算
6. `tearsNN`：取消ID为`NN`的玩家射速修改

`NN`可省略，默认为0。

[点我返回速查](#指令速查)

---

## 隐藏属性修改

### `fly`

修改玩家飞行能力，指令格式为：`flyNN MM`。
`MM`为0，则剥夺ID为`NN`的玩家飞行能力；
`MM`不为0，则赋予ID为`NN`的玩家飞行能力。
`MM`参数为空时，清除对ID为`NN`的玩家飞行能力的修改。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `size`

修改玩家体型，指令格式为：`sizeNN MM`，即设置ID为`NN`的玩家体型为`MM`。
`MM`可为负数，也可为`±inf`表示无穷大。
其他指令格式：

1. `sizeNN +MM`: 将ID为`NN`的玩家的体型增加`MM`
2. `sizeNN *MM`: 将ID为`NN`的玩家的体型乘以`MM`
3. `sizeNN`：取消ID为`NN`的玩家体型修改

`NN`可省略，默认为0。

[点我返回速查](#指令速查)

---

## 清除所有属性修改

### `all`

清除指定玩家的所有属性修改，指令格式为：`allNN`，即清除ID为`NN`的玩家的所有属性修改。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `clean`

清除所有玩家的所有属性修改，指令格式为：`clean`。

[点我返回速查](#指令速查)

---

## 玩家功能修改

### `blind`

指令格式为：`blindNN`，即切换ID为`NN`的玩家的蒙眼状态。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `bombs`

给予玩家炸弹，指令格式为：`bombsNN MM`，即给予ID为`NN`的玩家`MM`个炸弹。
`MM`可为负数，也可为`±inf`表示无穷大。
`MM`为空时，清空玩家的炸弹。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `coins`

给予玩家硬币，指令格式为：`coinsNN MM`，即给予ID为`NN`的玩家`MM`个硬币。
`MM`可为负数，也可为`±inf`表示无穷大。
`MM`为空时，清空玩家的硬币。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `die`

杀死玩家，指令格式为：`dieNN`，即杀死ID为`NN`的玩家。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `gc`

给予玩家道具。
指令格式：

1. `gcNN MM`：给予ID为`NN`的玩家道具`MM`，`MM`为道具ID；
2. `gcNN _MM`：给予ID为`NN`的玩家道具`MM`，`MM`为道具ID；若`MM`为主动道具，则将其放置在角色副手；
3. `gcNN SS`：给予ID为`NN`的玩家道具`SS`，`SS`为道具名称；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**不会**被忽略，`SS`中的标点符号需**省略**。
4. `gcNN _SS`：给予ID为`NN`的玩家道具`SS`，`SS`为道具名称；若`SS`为主动道具，则将其放置在角色副手；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**不会**被忽略，`SS`中的标点符号需**省略**。
    > 若要给予模组道具，**需要输入道具全名，且全名大小写敏感、空格敏感、不支持出现特殊字符**。

`MM`、`SS`均**支持**添加错误道具。
`NN`可省略，默认为0。

道具ID和道具名称参考：[道具列表](https://wofsauge.github.io/IsaacDocs/rep/enums/CollectibleType.html?h=collectibletype)

[点我返回速查](#指令速查)

### `gigabombs`

给予玩家巨型炸弹，指令格式为：`gigabombsNN MM`，即给予ID为`NN`的玩家`MM`个巨型炸弹。
`MM`可为负数，也可为`±inf`表示无穷大。
当`MM`为空时，将玩家`NN`的大炸弹变回普通炸弹。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `golden`

给予玩家金炸弹、金钥匙

[点我返回速查](#指令速查)

### `gulp`

玩家获得被吞下的饰品。

1. `gulpNN MM`：给予ID为`NN`的玩家被吞下的饰品`MM`，`MM`为饰品ID；
2. `gulpNN SS`：给予ID为`NN`的玩家被吞下的饰品`SS`，`SS`为饰品名称；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**不会**被忽略，`SS`中的标点符号需**省略**。
    > 若要给予模组饰品，**需要输入饰品全名，且全名大小写敏感、空格敏感、不支持出现特殊字符**。
3. `gulpNN`：ID为`NN`的玩家吞下当前饰品栏中的饰品。

`NN`可省略，默认为0。

饰品ID和饰品名称参考：[饰品列表](https://wofsauge.github.io/IsaacDocs/rep/enums/TrinketType.html?h=trinkettype)

[点我返回速查](#指令速查)

### `keys`

给予玩家钥匙，指令格式为：`keysNN MM`，即给予ID为`NN`的玩家`MM`个钥匙。
`MM`可为负数，也可为`±inf`表示无穷大。
`MM`为空时，清空玩家的钥匙。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `lost`

将玩家在接触白火后的灵魂形态和普通形态之间切换，指令格式为：`lostNN`，即切换ID为`NN`的玩家的灵魂形态和普通形态。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)


### `playertype`

修改玩家角色类型。
指令格式：

1. `playertypeNN MM`：将ID为`NN`的玩家角色修改为`MM`，`MM`为角色类型的ID；
2. `playertypeNN SS`：将ID为`NN`的玩家角色修改为`SS`，`SS`为角色名称；`SS`不区分大小写，可使用子串作为名称缩写;
3. `playertypeNN _SS`：将ID为`NN`的玩家角色修改为`SS`的堕化版本，`SS`为角色名称；`SS`不区分大小写，可使用子串作为名称缩写；
    >  若要修改为模组角色，**需要输入角色全名，且全名大小写敏感、空格敏感、不支持出现特殊字符**。
4. `playertypeNN`：查看ID为`NN`的玩家当前角色类型及名称。

`NN`可省略，默认为0。

角色类型和角色名称参考：[玩家类型](https://wofsauge.github.io/IsaacDocs/rep/enums/PlayerType.html?h=playertype)

[点我返回速查](#指令速查)

### `pocket`

在每个首次访问的新房间中给予玩家一次性主动道具。
指令格式：

1. `pocketNN MM`：在每个首次访问的新房间中给予ID为`NN`的玩家道具`MM`，`MM`为道具ID；
2. `pocketNN SS`：在每个首次访问的新房间中给予ID为`NN`的玩家道具`SS`，`SS`为道具名称；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**不会**被忽略，`SS`中的标点符号需**省略**。
    >若要给予模组道具，**需要输入道具全名，且全名大小写敏感、空格敏感、不支持出现特殊字符**。
3. `pocketNN 0`：ID为`NN`的玩家不再获得一次性道具。

`MM`、`SS`均**支持**添加错误道具。
`NN`可省略，默认为0。

道具ID和道具名称参考：[道具列表](https://wofsauge.github.io/IsaacDocs/rep/enums/CollectibleType.html?h=collectibletype)

[点我返回速查](#指令速查)

### `rc`

移除玩家道具。
指令格式：

1. `rcNN MM`：移除ID为`NN`的玩家道具`MM`，`MM`为道具ID；
2. `rcNN _MM`：移除ID为`NN`的玩家道具`MM`，`MM`为道具ID；若`MM`为主动道具，则优先从角色副手移除；
3. `rcNN SS`：移除ID为`NN`的玩家道具`SS`，`SS`为道具名称；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**不会**被忽略，`SS`中的标点符号需**省略**。
4. `rcNN _SS`：移除ID为`NN`的玩家道具`SS`，`SS`为道具名称；若`SS`为主动道具，则优先从角色副手移除；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**不会**被忽略，`SS`中的标点符号需**省略**。
    > 若要移除模组道具，**需要输入道具全名，且全名大小写敏感、空格敏感、不支持出现特殊字符**。

`MM`、`SS`均**支持**移除错误道具。
`NN`可省略，默认为0。

道具ID和道具名称参考：[道具列表](https://wofsauge.github.io/IsaacDocs/rep/enums/CollectibleType.html?h=collectibletype)

[点我返回速查](#指令速查)

### `revive`

复活玩家，指令格式为：`reviveNN`，即复活ID为`NN`的玩家。
只能在玩家实体被移除前使用该指令，使用该指令复活玩家后，菜单中将不能继续游戏。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

### `wavycap`

修改玩家迷幻蘑菇的致幻层数，指令格式为：`wavycapNN MM`，即设置ID为`NN`的玩家迷幻蘑菇的致幻层数为`MM`。
若`MM`为空，则显示当前致幻层数。
`NN`可省略，默认为0。

[点我返回速查](#指令速查)

---

## 游戏状态修改

### `ascent`

切换标签-触发回溯线的值，该值决定了陵墓II/炼狱II的头目房是否生成爸爸的便条。
指令格式：`ascent`

[点我返回速查](#指令速查)

### `bullettime`

减速游戏。
指令格式：

1. `bullettime MM`：将游戏速度修改为`MM`倍速，`MM`不大于1、不小于0；
2. `bullettime`：不再减速游戏。

[点我返回速查](#指令速查)

### `changechallenge`

切换当前挑战标签。
指令格式：

1. `changechallenge`：查看当前挑战标签。
2. `changechallenge MM`：切换当前挑战标签为`MM`，`MM`为挑战标签ID；
3. `changechallenge SS`：切换当前挑战标签为`SS`，`SS`为挑战标签名称；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**会**被忽略（挑战45的名称是“Delete This”）。
    > 若要切换模组挑战，**需要输入挑战全名，且全名大小写敏感、空格敏感、不支持出现特殊字符**。
4. `changechallenge 0`：清除挑战标签。

挑战ID和名称参考：[挑战列表](https://wofsauge.github.io/IsaacDocs/rep/enums/Challenge.html?h=challenge)

[点我返回速查](#指令速查)

### `delirium`

如果当前层存在精神错乱，则移除迷宫诅咒并传送至精神错乱房间。
指令格式：`delirium`

[点我返回速查](#指令速查)

### `eastereggs`

添加/删除彩蛋种子效果。
指令格式：

1. `eastereggs`：查看当前所有彩蛋种子效果。
2. `eastereggs MM`：添加彩蛋种子效果`MM`，`MM`为彩蛋种子ID；
3. `eastereggs _MM`：删除彩蛋种子效果`MM`，`MM`为彩蛋种子ID；
4. `eastereggs SS`：添加彩蛋种子效果`SS`，`SS`为彩蛋种子名称；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**会**被忽略；
5. `eastereggs _SS`：删除彩蛋种子效果`SS`，`SS`为彩蛋种子名称；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**会**被忽略；
6. `eastereggs 0`：清除所有彩蛋种子效果。

彩蛋种子ID和名称参考：[彩蛋种子列表](https://wofsauge.github.io/IsaacDocs/rep/enums/SeedEffect.html?h=seedeffect)

[点我返回速查](#指令速查)

### `finish`

结束当前游戏。
指令格式：`finish`

[点我返回速查](#指令速查)

### `icansee`

移除诅咒、我去“我能永远看清”效果、揭示全图、显示究极隐藏房位置、显示所有问号道具图标（包括支线问号道具，不支持错误道具）。
指令格式：`icansee`

[点我返回速查](#指令速查)

### `madeinheaven`

加速游戏。
指令格式：

1. `madeinheaven MM`：将游戏速度修改为`MM`倍速，`MM`不小于1；
2. `madeinheaven`：不再加速游戏。

[点我返回速查](#指令速查)

### `mirrormineshaft`

如果当前层存在镜子房间或矿井房间，则移除迷宫诅咒并传送至对应房间房间。
指令格式：`mirrormineshaft`

[点我返回速查](#指令速查)

### `rush`

尝试在当前房间生成头目车轮战(BossRush)和蓝子宫(BlueWomb)入口。
指令格式：`rush`

[点我返回速查](#指令速查)

### `seeds`

不重新开始游戏，修改当前游戏的种子。
指令格式：
`seeds DD`：将当前游戏的种子修改为`DD`，`DD`**大小写不敏感、空格不敏感**；`DD`支持彩蛋种子。

[点我返回速查](#指令速查)

### `timecounter`

修改游戏内计时器，指令格式为：`timecounter MM`，即将游戏内计时器修改为`MM`秒。
`MM`可为负数，也可为`±inf`表示无穷大。

[点我返回速查](#指令速查)

### `tp`

当目标房间已初始化时，传送玩家至指定房间。
指令格式：

1. `tp`：显示当前房间坐标和维度；
2. `tp MM`：传送玩家至房间坐标为`MM`的房间；
3. `tp SS`：传送玩家至类型为`SS`的房间，`SS`为房间类型名称；`SS`不区分大小写，可使用子串作为名称缩写；`SS`中的空格**不会**被忽略。使用房间类型名称作为参数时，**参数名仅支持地图上不存在的房间**。

房间坐标和房间类型参考：[房间类型列表](https://wofsauge.github.io/IsaacDocs/rep/enums/GridRooms.html?h=gridrooms)

[点我返回速查](#指令速查)

### `uncovereverything`

移除诅咒，显示该层当前维度所有房间和红房间，并开启所有红房间的门和隐藏房的门。
指令格式：`uncovereverything`

[点我返回速查](#指令速查)

---

## 不支持缩写的指令

### `version`

在控制台输出模组版本号和模组绝对路径。
指令格式：`version`

[点我返回速查](#指令速查)