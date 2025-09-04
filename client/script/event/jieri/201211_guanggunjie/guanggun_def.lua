-- 文件名　：guanggun_def.lua
-- 创建者　：LQY
-- 创建时间：2012-10-30 14:37:11
-- 说　　明：2012光棍节配置
-- 嚯嚯
SpecialEvent.GuangGun2012 = SpecialEvent.GuangGun2012 or {}
local tbGuangGun = SpecialEvent.GuangGun2012 or {}

tbGuangGun.IS_OPEN = 1 -- 系统开关
-- 任务变量
tbGuangGun.TASK_GROUP = 2208
tbGuangGun.GETSONG = 1 --领取歌曲KEY
tbGuangGun.LOVEARROW_COUNT = 2 --爱神箭使用次数
tbGuangGun.GETLOVEARROW = 3 --领取爱神箭的KEY
tbGuangGun.LASTUSEARROW = 13 --上次使用箭的时间
tbGuangGun.GETPARTNER = 14 --是否已获得跟宠
tbGuangGun.GIRLGETCOUNT = 15 --女玩家唱歌领取奖励次数
tbGuangGun.LIGHTNPC = { 4, 5, 6, 7, 8, 9, 10, 11, 12 } --NPC点亮情况
tbGuangGun.NPCS_ID = { --9个NPCID
  [3509] = 1,
  [3532] = 2,
  [11011] = 3,
  [3529] = 4,
  [3550] = 5,
  [3520] = 6,
  [3505] = 7,
  [3556] = 8,
  [3478] = 9,
}
tbGuangGun.NPCS_NAME = {
  "少林派-玄  悲",
  "翠烟门-丹碧秀",
  "古墓派-悠絮语", --9个NPC的名字
  "峨眉派-凌风雁",
  "武当派-路晓然",
  "五毒教-胡献姬",
  "天王帮-裴翼飞",
  "昆仑派-游乐天",
  "明  教-谢舒荣",
}

-- 活动设置
tbGuangGun.tbRunDay = --活动起止日期（包含）
  {
    20121109,
    20121111,
  }
tbGuangGun.tbTime = --第二个活动时间
  {
    { 1200, 1400 },
    { 1900, 2300 },
  }
tbGuangGun.nLevel = 50 --等级要求
tbGuangGun.nLoveArrow_Time = 30 * 60 * Env.GAME_FPS --爱神箭使用间隔&BUFF持续作用时间
tbGuangGun.nLaZhuLiveTime = 10 * 60 * Env.GAME_FPS --蜡烛存活时间
tbGuangGun.nArrowDis = 10 --使用爱神箭的距离
tbGuangGun.nGuangMuKunId = 11180 --活动NPCID
tbGuangGun.nLaZhuId = 11181 --活动蜡烛ID
tbGuangGun.LoveArrowId = { 18, 1, 1848, 1 } --爱神之箭ID
tbGuangGun.BoxId = { 18, 1, 1855, 1 } --爱神箭奖励宝箱
tbGuangGun.nSongTime = 10 * Env.GAME_FPS --唱歌的时间
tbGuangGun.nArrowTime = 5 * Env.GAME_FPS --射箭的时间
tbGuangGun.BoxPar = {
  [1] = { 18, 1, 1856, 1 }, --帅哥盒子
  [2] = { 18, 1, 1857, 1 }, --美女盒子
}
tbGuangGun.tbSongs = --歌曲列表
  {
    { { 18, 1, 1849, 1 }, "哥哥妹妹坐船头" },
    { { 18, 1, 1850, 1 }, "单身情歌" },
    { { 18, 1, 1851, 1 }, "葫芦娃" },
    { { 18, 1, 1852, 1 }, "那一夜" },
    { { 18, 1, 1853, 1 }, "青藏高原" },
    { { 18, 1, 1854, 1 }, "最炫民族风" },
  }
tbGuangGun.tbPartner = --奖励跟宠
  {
    [1] = { { 18, 1, 1858, 1 }, { 18, 1, 1859, 1 } },
    [2] = { { 18, 1, 1860, 1 }, { 18, 1, 1861, 1 } },
  }
tbGuangGun.tbNpc = --活动NPC刷新点
  {
    [1] = { 24, 1777, 3534 },
    [2] = { 29, 1647, 3941 },
    [3] = { 25, 1651, 3163 },
  }
tbGuangGun.tbEvent = {
  Player.ProcessBreakEvent.emEVENT_MOVE,
  Player.ProcessBreakEvent.emEVENT_ATTACK,
  Player.ProcessBreakEvent.emEVENT_SITE,
  Player.ProcessBreakEvent.emEVENT_USEITEM,
  Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
  Player.ProcessBreakEvent.emEVENT_DROPITEM,
  Player.ProcessBreakEvent.emEVENT_SENDMAIL,
  Player.ProcessBreakEvent.emEVENT_TRADE,
  Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
  Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  Player.ProcessBreakEvent.emEVENT_ATTACKED,
  Player.ProcessBreakEvent.emEVENT_DEATH,
  Player.ProcessBreakEvent.emEVENT_LOGOUT,
}
tbGuangGun.nLoveState = 2979 --爱神的祝福
tbGuangGun.nSonging = 2980 --唱歌的状态
tbGuangGun.tbNpcChat = --NPC唠叨唠叨
  {
    "本人还算不错，平时诚心拜佛，朋友都算蛮多，不嫌女人啰嗦，爱情却没着落，不想光棍生活。<enter><enter><color=pink>【活动一：爱神协助早“脱光”】<color><enter>活动时间：<enter>11月9日-11月11日全天<enter><color=pink>【活动二：光棍节歌声送祝福】<color><enter>活动时间：<enter>11月9日-11月11日，12:00-14:00、19:00-23:00<enter><color=pink>【活动奖励】<color><enter><color=yellow>高额绑金、绑银、玄晶、光棍节独家跟宠<color>",
    "蚂蚁蝴蝶都恋爱了，树上鸟儿也成双了，牛郎织女也相会了，光棍也该摘摘帽了。还在等什么？光棍节快乐！<enter><enter><color=pink>【活动一：爱神协助早“脱光”】<color><enter>活动时间：<enter>11月9日-11月11日全天<enter><color=pink>【活动二：光棍节歌声送祝福】<color><enter>活动时间：<enter>11月9日-11月11日，12:00-14:00、19:00-23:00<enter><color=pink>【活动奖励】<color><enter><color=yellow>高额绑金、绑银、玄晶、光棍节独家跟宠<color>",
    "人这一生其实可短暂了，眼睛一闭一睁，一辈子就过去了，你说对吗？所以青春不常在，抓紧谈恋爱；节日活动多，祝大家光棍不再来。<enter><enter><color=pink>【活动一：爱神协助早“脱光”】<color><enter>活动时间：<enter>11月9日-11月11日全天<enter><color=pink>【活动二：光棍节歌声送祝福】<color><enter>活动时间：<enter>11月9日-11月11日，12:00-14:00、19:00-23:00<enter><color=pink>【活动奖励】<color><enter><color=yellow>高额绑金、绑银、玄晶、光棍节独家跟宠<color>",
    "光棍好，光棍妙，光棍的生活呱呱叫；自己欢，自己笑，光棍的世界真美妙。光棍节日又来到，祝你幸福甜蜜乐陶陶！<enter><enter><color=pink>【活动一：爱神协助早“脱光”】<color><enter>活动时间：<enter>11月9日-11月11日全天<enter><color=pink>【活动二：光棍节歌声送祝福】<color><enter>活动时间：<enter>11月9日-11月11日，12:00-14:00、19:00-23:00<enter><color=pink>【活动奖励】<color><enter><color=yellow>高额绑金、绑银、玄晶、光棍节独家跟宠<color>",
  }
tbGuangGun.tbNpcListen = --NPC听完之后。。
  {
    "啊哈，唱得真是不错啊，多谢多谢！<pic=0>",
    "好久没听过这么美妙的歌声了，谢谢！<pic=1>",
    "真好听，你们也光棍节快乐！<pic=20>",
    "嗯？刚才是什么奇怪的声音在响？<pic=15>",
    "哈哈，哈哈，哈哈……<pic=4>",
    "今天怎么这么多人对我唱歌……<pic=0>",
    "那首江南四大藕你们会唱么？<pic=28>",
    "真好！再来一首~再来一首~<pic=26>",
    "别人唱歌要钱，你们唱歌是要命<pic=29>",
  }
------奖励配置
tbGuangGun.nSongMoney = 10000 --唱歌得绑银
tbGuangGun.nSongExp = 30 --唱歌得经验
tbGuangGun.tbArrowAward = --爱神箭的绑金
  {
    { 300, 30 },
    { 900, 30 },
    { 1999, 60 },
    { 5, 11111, 120 }, --第三次5%的概率
  }
tbGuangGun.AWARDBOY = {
  [1] = { "stone", "玄晶", 1, 4, 6 },
  [2] = { "stone", "玄晶", 1, 20, 7 },
  [3] = { "stone", "玄晶", 1, 15, 8, "8级玄晶" },
  [4] = { "stone", "玄晶", 1, 1, 9, "9级玄晶" },
  [5] = { "money", "绑银", 300000, 10, 0 },
  [6] = { "money", "绑银", 600000, 30, 0 },
  [7] = { "money", "绑银", 1000000, 15, 0 },
  [8] = { "money", "绑银", 2990000, 5, 0, "2990000绑银" },
}
tbGuangGun.AWARDGIRL = {
  [1] = { "stone", "玄晶", 1, 14, 6 },
  [2] = { "stone", "玄晶", 1, 20, 7 },
  [3] = { "stone", "玄晶", 1, 5, 8, "8级玄晶" },
  [4] = { "stone", "玄晶", 1, 1, 9, "9级玄晶" },
  [5] = { "money", "绑银", 300000, 35, 0 },
  [6] = { "money", "绑银", 600000, 15, 0 },
  [7] = { "money", "绑银", 1000000, 7, 0 },
  [8] = { "money", "绑银", 2990000, 3, 0, "2990000绑银" },
}
tbGuangGun.ANNOUN = {
  [1] = "家族成员%s打开光棍节情缘宝盒获得了%s",
  [2] = "您的好友%s打开光棍节情缘宝盒获得了%s",
  [3] = "家族成员%s在光棍节之际向心仪之人发出了爱神之箭。",
  [4] = "你的好友%s在光棍节之际向心仪之人发出了爱神之箭。",
  [5] = "家族成员%s在红烛前许下心愿，希望光棍节之际能有一名%s相伴左右。",
  [6] = "你的好友%s在红烛前许下心愿，希望光棍节之际能有一名%s相伴左右。",
  [7] = "爱神降临，使%s打开<color=green>光棍节情缘宝盒<color>获得了<color=pink>%s<color>",
  [8] = "爱神降临，使%s愿望成真，获得了一个<color=pink>%s跟宠<color>",
  [9] = "%s发射了光棍节爱神之箭，意外获得<color=pink>11111绑金<color>",
  [10] = "家族成员%s打开<color=green>光棍节情缘宝盒<color>获得了光棍节%s跟宠",
  [11] = "您的好友%s打开<color=green>光棍节情缘宝盒<color>获得了光棍节%s跟宠",
}
tbGuangGun.PARTBOY = 10 --男玩家获得跟宠概率
tbGuangGun.PARTGIRL = 5 --女玩家获得跟宠概率
tbGuangGun.tbGiveStone = --奖励玄晶Id
  {
    [5] = { 18, 1, 114, 5 },
    [6] = { 18, 1, 114, 6 },
    [7] = { 18, 1, 114, 7 },
    [8] = { 18, 1, 114, 8 },
    [9] = { 18, 1, 114, 9 },
  }
------------------
----通用函数
-- 时间判断
-- return 0:活动前  1:活动中  2:活动后
function tbGuangGun:CheckTime()
  if self.IS_OPEN ~= 1 then
    return 2, "光棍节活动已经结束。"
  end
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nNowDate < self.tbRunDay[1] then
    return 0, "光棍节活动还没开始。"
  end
  if nNowDate > self.tbRunDay[2] then
    return 2, "光棍节活动已经结束。"
  end
  return 1
end

-- 玩家资格判断
function tbGuangGun:CheckPlayer(nPlayerId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0, "玩家不见了。"
  end
  if pPlayer.nLevel < self.nLevel then
    return 0, string.format("你的等级不足%d级，不能参加本活动！", self.nLevel)
  end
  if pPlayer.nFaction <= 0 then
    return 0, "你尚未加入门派，不能参加本活动！"
  end
  --if pPlayer.IsAccountLock() ~= 0 then
  --return 0,"你的账号处于锁定状态，无法进行该操作！";
  --end
  return 1
end

-- 取活动KEY
function tbGuangGun:GetKey()
  local nNowDate = tonumber(GetLocalDate("%m%d"))
  return nNowDate
end

--获取两个角色之间的距离
function tbGuangGun:GetDis(pMan, pOtherMan)
  if not pMan or not pOtherMan then
    return 9999
  end
  local nMap1, nX1, nY1 = pMan.GetWorldPos()
  local nMap2, nX2, nY2 = pOtherMan.GetWorldPos()
  if nX1 == 0 or nY1 == 0 or nX2 == 0 or nY2 == 0 then
    return 9999
  end
  if nMap1 ~= nMap2 then
    return 9999
  end
  local nDis = ((nX1 - nX2) ^ 2 + (nY1 - nY2) ^ 2) ^ 0.5
  return nDis
end

--是否在第二个活动的活动时间
function tbGuangGun:IsTimeOk()
  local nNowTime = tonumber(GetLocalDate("%H%M"))
  for _, tbTime in pairs(self.tbTime) do
    if nNowTime >= tbTime[1] and nNowTime <= tbTime[2] then
      return 1
    end
  end
  return 0
end
--能否在这个地图使用道具
function tbGuangGun:IsMapOk(nMapId)
  local szMapClass = GetMapType(nMapId) or ""
  if szMapClass == "village" then
    return 1
  end
  if szMapClass == "city" then
    return 1
  end
  return 0
end

function tbGuangGun:BindMoneyOut(pPlayer1, pPlayer2, nValue)
  if not pPlayer1 or not pPlayer2 then
    return 0, "有个玩家不见了。"
  end
  if nValue <= 0 then
    return 1
  end
  if pPlayer1.GetBindMoney() + nValue > pPlayer1.GetMaxCarryMoney() then
    return 0, pPlayer1.szName .. "绑银即将超出上限，请让他整理一下绑银再来吧。"
  end
  if pPlayer2.GetBindMoney() + nValue > pPlayer2.GetMaxCarryMoney() then
    return 0, pPlayer2.szName .. "绑银即将超出上限，请让他整理一下绑银再来吧。"
  end
  return 1
end
-----启动配置
function tbGuangGun:OnServerStart()
  if self.IS_OPEN ~= 1 then
    return
  end
  --刷NPC
  for _, tbPoint in pairs(self.tbNpc) do
    if SubWorldID2Idx(tbPoint[1]) >= 0 then
      KNpc.Add2(self.nGuangMuKunId, 1, -1, tbPoint[1], tbPoint[2], tbPoint[3])
    end
  end
end

if MODULE_GAMESERVER then
  if tbGuangGun:CheckTime() ~= 2 then
    --注册启动回调
    ServerEvent:RegisterServerStartFunc(SpecialEvent.GuangGun2012.OnServerStart, SpecialEvent.GuangGun2012)
  end
end
