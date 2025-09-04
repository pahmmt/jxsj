-------------------------------------------------------------------
--File: autofight_setting.lua
--Author: luobaohang
--Date: 2008-3-4 15:10:41
--Describe: 自动打怪配置
-------------------------------------------------------------------
if not MODULE_GAMECLIENT then
  return
end

Require("\\script\\player\\define.lua")

local preEnv = _G --保存旧的环境
setfenv(1, AutoAi) --设置当前环境

------------------------------各门派的辅助技能列表----------------------
ASSIST_SKILL_LIST = {
  [preEnv.Player.FACTION_NONE] = {}, -- 无门派
  [preEnv.Player.FACTION_SHAOLIN] = { 26 }, -- 少林
  [preEnv.Player.FACTION_TIANWANG] = { 46, 55 }, -- 天王
  [preEnv.Player.FACTION_TANGMEN] = {}, -- 唐门
  [preEnv.Player.FACTION_WUDU] = { 78 }, -- 五毒
  [preEnv.Player.FACTION_EMEI] = { 835, 1249, 836, 838 }, -- 峨嵋
  [preEnv.Player.FACTION_CUIYAN] = { 115 }, -- 翠烟
  [preEnv.Player.FACTION_GAIBANG] = { 132, 489 }, -- 丐帮
  [preEnv.Player.FACTION_TIANREN] = { 850 }, -- 天忍
  [preEnv.Player.FACTION_WUDANG] = { 161, 783 }, -- 武当,497纯阳无极太费蓝,有没有必要呢?
  [preEnv.Player.FACTION_KUNLUN] = { 177, 180, 191, 697 }, -- 昆仑
  [preEnv.Player.FACTION_MINGJIAO] = {}, -- 明教
  [preEnv.Player.FACTION_DUANSHI] = { 230 }, -- 大理
  [preEnv.Player.FACTION_GUMU] = { 2808 }, -- 古墓
}

-----------------------------------常用修改-----------------------------
ATTACK_RANGE = 600 --打怪范围，超过此范围走向定点（启动自动打怪的地方）
KEEP_RANGE_MODE = 1 --1为只要超过打怪范围就走向定点，2为寻不到怪时才走向定点
NPC_AVOID_ATTACK = "木人;木桩;沙袋;" --避免攻击这些名字（全名）的Npc
LIFE_RETURN = 20 --逃跑生命百分比
MANA_LEFT = 30 --内剩下多少就补内（百分比）
EAT_FOOD_LIFE = 60 --血少于多少判断吃食物
MAX_SKILL_RANGE = 600 --限制技能最大攻击范围，若当前技能攻击距离大于此值，接近与目标距离在此范围内才会开始攻击
FOOD_SKILL_ID = 476

RESUME_GOUHUO_FIRED = 1 -- AutoAi:Resume函数，篝火已点燃
TIME_WINE_EFFECT = 3 * 60 -- 喝酒效果持续时间
TIME_FIRE_EFFECT = 15 * 60 -- 普通篝火持续时间

WINES = {
  [1] = { 18, 1, 48, 1 }, -- 西北望
  [2] = { 18, 1, 49, 1 }, -- 稻花香
  [3] = { 18, 1, 50, 1 }, -- 女儿红
  [4] = { 18, 1, 51, 1 }, -- 杏花村
  [5] = { 18, 1, 52, 1 }, -- 烧刀子
}
JINXI = {
  [1] = { 18, 1, 2, 1 }, -- 金犀1级
  [2] = { 18, 1, 2, 2 }, -- 金犀2级
  [3] = { 18, 1, 2, 3 }, -- 金犀3级
  [4] = { 18, 1, 2, 4 }, -- 金犀4级
  [5] = { 18, 1, 2, 5 }, -- 金犀5级
}
XIULIANZHU = { 18, 1, 16, 1 }
WINE_SKILL_ID = 378
FIRE_SKILL_ID = 377
ENHANCE_EXP_SKILL_ID = 332 -- 修炼珠

-----------------------------------物品拾取------------------------------
--必捡装备（填写装备名字包含的字符串，绕过价值量判断）
ITEM_PICK_LIST = "面具;"
--排除品（物品名字包含这些字符串的必不捡起来）
ITEM_NOPICK_LIST = "赏善令;罚恶令;"

-----------------------------------基本默认设置---------------------------
EAT_SLEEP = 3 --喝药判断的廷时
ACTIVE_RADIUS = 800 --活动范围
VISION_RADIUS = 1000 --视野范围
NPC_ONLY_ATTACK = ";" --只攻击这些名字（全名）的Npc（注意未尾要加分号）
HEAD_STATE_SKILLID = 94 -- 头顶状态技能ID

------------------------------------ END ----------------------------------
preEnv.setfenv(1, preEnv) --恢复全局环境
