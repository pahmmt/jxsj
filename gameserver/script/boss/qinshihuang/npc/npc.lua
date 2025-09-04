-------------------------------------------------------
-- 文件名　：npc.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-06-15 15:28:48
-- 文件描述：
-------------------------------------------------------

-- 秦陵安全区 NPC 对话
-- By Peres 2009/06/13 PM 06:55

local tbF1_Npc_1 = Npc:GetClass("qinling_safenpc1_1")
local tbF1_Npc_2 = Npc:GetClass("qinling_safenpc1_2")
local tbF1_Npc_3 = Npc:GetClass("qinling_safenpc1_3")
local tbF1_Npc_4 = Npc:GetClass("qinling_safenpc1_4")

local tbF2_Npc_1 = Npc:GetClass("qinling_safenpc2_1")
local tbF2_Npc_2 = Npc:GetClass("qinling_safenpc2_2")
local tbF2_Npc_3 = Npc:GetClass("qinling_safenpc2_3")

-- 第一层的 NPC
function tbF1_Npc_1:OnDialog()
  Dialog:Say("宗冈：你居然能在这个地方活下来，并且居然能找到我这里，算是你的实力。如果身上有些伤的话，就用我的药敷敷吧……当然，是要收钱的。", { "<color=gold>[绑定银两]<color>我要买药", self.OnBuyYaoByBind, self }, { "<color=gold>[绑定银两]<color>我要买菜", self.OnBuyCaiByBind, self }, { "我要买药", self.OnBuyYao, self }, { "结束对话" })
end

function tbF1_Npc_2:OnDialog()
  Dialog:Say("宋湫湫：始皇帝不愧是始皇帝，我宋湫湫开过这么多死人墓，第一次看到这么险恶的地方……天呐，附近这都是些啥妖怪啊？<enter><color=yellow>我发布的任务每周最多可完成5次，每天可完成1次。<color>")
end

function tbF1_Npc_3:OnDialog()
  Dialog:Say("诸葛小草：咳咳……我刚刚快被那些游魂给生吞了，吓死老子了。你还留在这里干什么？想看那腐烂了上千年的秦始皇尸体？别做梦了。", { "大哥您还是送我回去吧！", self.OnLeave, self }, { "结束对话" })
end

function tbF1_Npc_3:OnLeave()
  me.SetLogoutRV(0)
  Boss.Qinshihuang:_MapResetState(me)
  me.NewWorld(Boss.Qinshihuang:GetLeaveMapPos())
end

function tbF1_Npc_4:OnDialog()
  Dialog:Say("关一刀：哼哼，来这里被吓傻了吧？我这里有一些很好的配方，能使你穿的这身破烂立马脱胎换骨……不过前提是你要买得起。", { "让我看看你说的是什么好东西", self.OnShop, self }, { "结束对话" })
end

-- 第二层的 NPC
function tbF2_Npc_1:OnDialog()
  Dialog:Say(
    "野叟：这位侠士你好像很面熟，如果需要什么跌打刀伤药来找我老头子就是了。对了，如果你在外面捡到什么没用的瓶瓶罐罐，就拿来给我吧！",
    { "<color=gold>[绑定银两]<color>我要买药", self.OnBuyYaoByBind, self },
    { "<color=gold>[绑定银两]<color>我要买菜", self.OnBuyCaiByBind, self },
    { "我要买药", self.OnBuyYao, self },
    { "我捡到一些奇怪的东西……", self.ChangeMask, self },
    { "我要兑换青铜武器炼化图谱", self.ChangeRefine, self }, -- 武器炼化图谱
    { "声望兑换青铜武器炼化图谱", self.OnChangeReputeToRefine, self },
    { "结束对话" }
  )
end

function tbF2_Npc_2:OnDialog()
  Dialog:Say("张元：啊，能来到第三层说明你已经有了和我张元相当的实力。可千万别小瞧了我这摸金校尉的名号，在整个发丘门里只有四个被我们赛门主封为摸金校尉的人。当然……赛门主他自己也随着这陵墓归西了，不过我相信我们一定能完成他的遗嘱！")
end

function tbF2_Npc_3:OnDialog()
  Dialog:Say("白苗苗：赛门主归西之后，留下了这一批从各个帝王古墓里收集来的神兵利器，相信他也希望能有最合适的人拿起这些神器，在江湖上闯出一番英名。你觉得你配拿起它们吗？", { "购买120级武器<color=gold>（金）<color>", self.OnShop, self, 1 }, { "购买120级武器<color=gold>（木）<color>", self.OnShop, self, 2 }, { "购买120级武器<color=gold>（水）<color>", self.OnShop, self, 3 }, { "购买120级武器<color=gold>（火）<color>", self.OnShop, self, 4 }, { "购买120级武器<color=gold>（土）<color>", self.OnShop, self, 5 }, { "结束对话" })
end

-- 买药
function tbF1_Npc_1:OnBuyYaoByBind()
  me.OpenShop(14, 7)
end

function tbF1_Npc_1:OnBuyYao()
  me.OpenShop(14, 1)
end

function tbF2_Npc_1:OnBuyYaoByBind()
  me.OpenShop(14, 7)
end

function tbF2_Npc_1:OnBuyYao()
  me.OpenShop(14, 1)
end

-- 买菜
function tbF1_Npc_1:OnBuyCaiByBind()
  me.OpenShop(21, 7)
end

function tbF2_Npc_1:OnBuyCaiByBind()
  me.OpenShop(21, 7)
end

tbF2_Npc_1.tbData = {
  { 18, 1, 370, 100 },
  { 18, 1, 371, 300 },
  { 18, 1, 372, 100 },
}

-- 兑换面具
function tbF2_Npc_1:ChangeMask()
  Dialog:Say(
    "野叟：在这种地方无论你捡到了什么都是很宝贵的，如果你捡到了一些自己都不懂如何使用的东西，拿来给我，或许我会有意外的惊喜给你哦！",
    { "我捡到了一块精致的凤羽布", self.ChangeItemGift, self, 1 }, -- 20 格背包
    { "我捡到了一封手绢上的书信", self.ChangeItemGift, self, 2 }, -- 24 格背包
    { "我捡到了一顶奇怪的发冠", self.ChangeItemGift, self, 3 }, -- 秦始皇面具
    { "结束对话" }
  )
end

function tbF2_Npc_1:ChangeRefine()
  local tbParam = {
    tbAward = { { nGenre = 18, nDetail = 2, nParticular = 385, nLevel = 1, nCount = 1, nBind = 1 } },
    tbMareial = { { nGenre = 18, nDetail = 1, nParticular = 377, nLevel = 1, nCount = 5 } },
  }
  Dialog:OpenGift("放入五个和氏璧，可以兑换一个炼化图谱", tbParam)
end

function tbF2_Npc_1:OnChangeReputeToRefine()
  Dialog:Say("你想要通过减少<color=yellow>500 点秦陵·发丘门<color>声望来换取一个110级青铜武器炼化图谱吗？<color=yellow>只能减少当前声望等级内的点数。<color>", {
    { "是的", self.ChangeReputeToRefine, self },
    { "不了" },
  })
end

function tbF2_Npc_1:ChangeReputeToRefine()
  local nDelRepute = 500
  local nRepute = me.GetReputeValue(9, 2)
  local nLevel = me.GetReputeLevel(9, 2)
  if nDelRepute > nRepute then
    Dialog:Say("您当前等级的声望不足以再减少 <color=yellow>500 点<color>！")
    return
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("背包空间不足，不能兑换青铜武器炼化图谱。")
    return
  end

  me.AddRepute(9, 2, -1 * nDelRepute)
  local nNowRepute = me.GetReputeValue(9, 2)
  local nNowLevel = me.GetReputeLevel(9, 2)
  local szLog = string.format("%s delete %d repute, last Repute: %d, Level: %d, now Repute: %d, level: %d!!", me.szName, nDelRepute, nRepute, nLevel, nNowRepute, nNowLevel)
  Dbg:WriteLogEx(Dbg.LOG_INFO, "Qinshihuang", "npc", "ChangeReputeToRefine", szLog)
  local pItem = me.AddItem(18, 2, 385, 1, 1, 1)
  if not pItem then
    Dbg:WriteLogEx(Dbg.LOG_INFO, "Qinshihuang", "ChangeReputeToRefine", string.format("%s get the item failed!", me.szName))
    return
  end
  Dbg:WriteLogEx(Dbg.LOG_INFO, "Qinshihuang", "ChangeReputeToRefine", string.format("%s get the item success!", me.szName))
end

function tbF2_Npc_1:ChangeItemGift(nItemId)
  local szMsg = {
    [1] = "野叟：你捡到了一块精致的凤羽布？我这里有一个<color=green>赵姬香袋（20格背包）<color>可以和你换，不过你得<color=yellow>再贴上 100 个夜明珠<color>才行哦！<color=red>兑换后该物品将会绑定！<color>",
    [2] = "野叟：你捡到了一封手绢上的书信？我这里有一个<color=green>阿若公主的记忆（24格背包）<color>可以和你换，不过你得<color=yellow>再贴上 300 个夜明珠<color>才行哦！<color=red>兑换后该物品将会绑定！<color>",
    [3] = "野叟：你捡到了一顶奇怪的发冠？我这里有一个<color=green>秦始皇面具<color>可以和你换，不过你得<color=yellow>再贴上 100 个夜明珠<color>才行哦！<color=red>兑换后该物品将会绑定！<color>",
  }
  Dialog:Say(szMsg[nItemId], { "<color=yellow>是的，夜明珠我已经准备好了<color>", self.ChangeItem, self, nItemId }, { "算了" })
end

function tbF2_Npc_1:ChangeItem(nItemId)
  local tbData = {
    { 100, 21, 8, 3, 1, 18, 1, 370, 1 },
    { 300, 21, 9, 5, 1, 18, 1, 371, 1 },
    { 100, 1, 13, 24, 1, 18, 1, 372, 1 },
  }

  local nFind = me.GetItemCountInBags(18, 1, 357, 1)
  if nFind < tbData[nItemId][1] then
    Dialog:Say("野叟：你……你确定你身上有<color=yellow>" .. tbData[nItemId][1] .. "个夜明珠<color>？不要糊弄我老头子啊！")
    return
  end

  local nFindItem = me.GetItemCountInBags(tbData[nItemId][6], tbData[nItemId][7], tbData[nItemId][8], tbData[nItemId][9])
  if nFindItem < 1 then
    Dialog:Say("野叟：你……你确定你身上带有那东西？不要糊弄我老头子啊！")
    return
  end

  local bRet1 = me.ConsumeItemInBags2(tbData[nItemId][1], 18, 1, 357, 1)
  local bRet2 = me.ConsumeItemInBags2(1, tbData[nItemId][6], tbData[nItemId][7], tbData[nItemId][8], tbData[nItemId][9])

  if bRet1 == 0 and bRet2 == 0 then
    local pItem = me.AddItem(tbData[nItemId][2], tbData[nItemId][3], tbData[nItemId][4], tbData[nItemId][5])
    if pItem then
      pItem.Bind(1)
      local szMsg = string.format("在秦始皇陵内成功兑换了%s，消耗了%d夜明珠", pItem.szName, tbData[nItemId][1])
      me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, szMsg)
    end
  end
end

-- 买炼化声望物品
function tbF1_Npc_4:OnShop()
  me.OpenShop(155, 1)
end

-- 买武器
function tbF2_Npc_3:OnShop(nSeries)
  local tbData = { 156, 157, 158, 159, 160 }
  me.OpenShop(tbData[nSeries], 1)
end

-------------------------------------------------------
-- by zhangjinpin@kingsoft
-------------------------------------------------------

-- 传送npc
local tbEnterNpc1 = Npc:GetClass("qinling_enternpc_1")

function tbEnterNpc1:OnDialog()
  local tbOpt = {
    { "是的，送我下去吧", self.EnterQingling },
    { "算了" },
  }

  local szMsg = "梁笑笑：自从我们的门主赛乾坤在这秦陵里被砍掉了脑袋后，那些小偷小盗的人已经不敢再去送死了。现在里面还有一些不怕死的帮众和一群被上头逼着来的无能官兵……怎么，难道你也想下去？"

  Dialog:Say(szMsg, tbOpt)
end

-- 进入秦陵
function tbEnterNpc1:EnterQingling()
  local bGreenServer = KGblTask.SCGetDbTaskInt(DBTASK_TIMEFRAME_OPEN)
  local nType = Ladder:GetType(0, 2, 1, 0) or 0 -- 由于ladder的tbconfig没有gs副本，所有特殊处理，获取战斗力等级排行榜的type
  local tbInfo = GetHonorLadderInfoByRank(nType, 50) -- 等级排行榜第50名
  local nLadderLevel = 0
  if tbInfo then
    nLadderLevel = tbInfo.nHonor
  end

  if me.GetTiredDegree1() == 2 then
    Dialog:Say("您太累了，还是休息下吧！")
    return
  end
  if Boss.Qinshihuang:_CheckState() ~= 1 then
    Dialog:Say("对不起，秦始皇陵系统暂时关闭", { "我知道了" })
    return
  end

  if bGreenServer == 1 then --绿色服务器限制
    if nLadderLevel < 100 then
      Dialog:Say("梁笑笑：皇陵还未开放，本服50人达到100级后将会自动开启。", { "我知道了" })
      return
    end
  end

  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    Dialog:Say("梁笑笑：当前我们进去探访的精英现在还没音信呢！你还是不要进去送死了。", { "我知道了" })
    return
  end

  -- 100级才可以进入
  if me.nLevel < 100 then
    Dialog:Say("梁笑笑：就凭你这身板也想进去？还是多加修炼吧！", { "我知道了" })
    return
  end

  -- 门派限制
  if me.nFaction <= 0 then
    Dialog:Say("梁笑笑：白名也想进去？赶快找个门派加入吧！", { "我知道了" })
    return
  end

  local nUseTime = me.GetTask(Boss.Qinshihuang.TASK_GROUP_ID, Boss.Qinshihuang.TASK_USE_TIME)

  -- 剩余时间为0
  if nUseTime >= Boss.Qinshihuang.MAX_DAILY_TIME then
    Dialog:Say("梁笑笑：你今天在里面呆的时间太久了，再下去肯定承受不住里面的毒气，还是等明天再来吧！", { "我知道了" })
    return
  end

  if me.GetSkillState(CrossTimeRoom.nLimitJoinHuanglingBuffId) > 0 then
    Dialog:Say("梁笑笑：你已经进入过了阴阳时光殿副本了，在阴阳时光锁状态时间之内，你无法进入秦始皇陵！", { "我知道了" })
    return
  end

  if Boss.Qinshihuang:_CheckTime() == 1 then
    StatLog:WriteStatLog("stat_info", "huangling", "join", me.nId)
  end

  me.SetFightState(0)
  me.NewWorld(1536, 1567, 3629) -- 1层安全区
end

-- 传送阵
local tbPassNpc1 = Npc:GetClass("qinling_pass1")
local tbPassNpc2 = Npc:GetClass("qinling_pass2")

function tbPassNpc1:OnDialog()
  -- 启动进度条
  local tbBreakEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SIT,
    Player.ProcessBreakEvent.emEVENT_RIDE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_CHANGEEQUIP,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_REVIVE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  }
  GeneralProcess:StartProcess("传送到秦始皇陵五层·南", 20 * Env.GAME_FPS, { self.OnPassSouth, self }, nil, tbBreakEvent)
end

function tbPassNpc1:OnPassSouth()
  me.NewWorld(1540, 1790, 3183)
end

function tbPassNpc2:OnDialog()
  -- 启动进度条
  local tbBreakEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SIT,
    Player.ProcessBreakEvent.emEVENT_RIDE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_CHANGEEQUIP,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_REVIVE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  }
  GeneralProcess:StartProcess("传送到秦始皇陵五层·北", 20 * Env.GAME_FPS, { self.OnPassNorth, self }, nil, tbBreakEvent)
end

function tbPassNpc2:OnPassNorth()
  me.NewWorld(1540, 1915, 3312)
end

-- 神捕吴用
local tbEnterNpc2 = Npc:GetClass("qinling_enternpc_2")

function tbEnterNpc2:OnDialog()
  local szMsg = "吴用：哼！那群废物非得老子拿刀顶着他们才肯下去。要知道这秦始皇陵一开，有多少盗墓的人想要进去搬金砖，岂能让这些本来属于皇上的东西白白送人！话说回来你来这是干嘛的？……没事最好给老子爬远点！"
  Dialog:Say(szMsg, { "结束对话" })
end

-- 路路通
local tbFreewayNpc = Npc:GetClass("qinling_npc_freeway")

function tbFreewayNpc:OnDialog()
  local szMsg = "请选择你要传送的地图："
  local tbOpt = {}
  for i, tbInfo in ipairs(Boss.Qinshihuang.tbTranList) do
    table.insert(tbOpt, { tbInfo[0], self.Transfer, self, i })
  end
  tbOpt[#tbOpt + 1] = { "我知道了" }
  Dialog:Say(szMsg, tbOpt)
end

function tbFreewayNpc:Transfer(nIndex)
  local tbData = Boss.Qinshihuang.tbTranList[nIndex]
  if not tbData then
    return 0
  end
  local szMsg = "请选择你要传送的区域："
  local tbOpt = {}
  for i, tbInfo in ipairs(tbData) do
    if i ~= 0 then
      table.insert(tbOpt, { tbInfo[1], self.DoTransfer, self, tbInfo[2] })
    end
  end
  tbOpt[#tbOpt + 1] = { "我知道了" }
  Dialog:Say(szMsg, tbOpt)
end

function tbFreewayNpc:DoTransfer(tbPos)
  local tbBreakEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SIT,
    Player.ProcessBreakEvent.emEVENT_RIDE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_CHANGEEQUIP,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_REVIVE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
  }
  GeneralProcess:StartProcess("传送中", 8 * Env.GAME_FPS, { self.DoTransferEnd, self, tbPos }, nil, tbBreakEvent)
end

function tbFreewayNpc:DoTransferEnd(tbPos)
  if tbPos[1] == 1540 and Boss.Qinshihuang:CheckOpenQinFive() ~= 1 then
    Dialog:SendBlackBoardMsg(me, "里面神秘莫测，此时还是不要进去为好！")
    return 0
  end
  me.SetFightState(1)
  me.NewWorld(unpack(tbPos))
end
