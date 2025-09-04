------------------------------------------------------
-- 文件名　：dragonball.lua
-- 创建者　：dengyong
-- 创建时间：2012-02-28 10:16:33
-- 描  述  ：传说集齐七颗龙珠就能召唤出神龙满足自己一个愿望！
------------------------------------------------------
local tbBall = Item:GetClass("dragonball")

tbBall.MAX_LEVEL = 5
tbBall.PROCESS_TIME = 3 * Env.GAME_FPS -- 3秒

local function IsReputeFull(pPlayer, nReputeCamp, nReputeClass)
  local nReputeValue = pPlayer.GetReputeValue(nReputeCamp, nReputeClass)
  if nReputeValue == -1 then
    return 1
  end
  return 0
end

-- key值是龙珠当前所在状态
--local tbMaskLayerFiles =
--{
--	[0] = {"\\image\\item\\other\\scriptitem\\xuanjing_001_s.spr", ""},
--	[1] = {"\\image\\item\\other\\scriptitem\\xuanjing_001_s.spr", "\\image\\effect\\other\\zhenyuan_maskicon.spr"},
--	[2] = {"\\image\\item\\other\\scriptitem\\xuanjing_002_s.spr", ""},
--	[3] = {"\\image\\item\\other\\scriptitem\\xuanjing_002_s.spr", "\\image\\effect\\other\\zhenyuan_maskicon.spr"},
--	[4] = {"\\image\\item\\other\\scriptitem\\xuanjing_003_s.spr", ""},
--	[5] = {"\\image\\item\\other\\scriptitem\\xuanjing_003_s.spr", "\\image\\effect\\other\\zhenyuan_maskicon.spr"},
--	[6] = {"\\image\\item\\other\\scriptitem\\xuanjing_004_s.spr", ""},
--	[7] = {"\\image\\item\\other\\scriptitem\\xuanjing_004_s.spr", "\\image\\effect\\other\\zhenyuan_maskicon.spr"},
--	[8] = {"\\image\\item\\other\\scriptitem\\xuanjing_005_s.spr", ""},
--	[9] = {"\\image\\item\\other\\scriptitem\\xuanjing_005_s.spr", "\\image\\effect\\other\\zhenyuan_maskicon.spr"},
--	[10] = {"\\image\\item\\other\\scriptitem\\xuanjing_006_s.spr", ""},
--}

local tbMaskLayerFiles = {
  [0] = { "\\image\\item\\other\\scriptitem\\dsb_01_0.spr", "" },
  [1] = { "\\image\\item\\other\\scriptitem\\dsb_01_1.spr", "\\image\\effect\\other\\new_jin3.spr" },
  [2] = { "\\image\\item\\other\\scriptitem\\dsb_02_0.spr", "" },
  [3] = { "\\image\\item\\other\\scriptitem\\dsb_02_1.spr", "\\image\\effect\\other\\new_jin3.spr" },
  [4] = { "\\image\\item\\other\\scriptitem\\dsb_03_0.spr", "" },
  [5] = { "\\image\\item\\other\\scriptitem\\dsb_03_1.spr", "\\image\\effect\\other\\new_jin3.spr" },
  [6] = { "\\image\\item\\other\\scriptitem\\dsb_04_0.spr", "" },
  [7] = { "\\image\\item\\other\\scriptitem\\dsb_04_1.spr", "\\image\\effect\\other\\new_jin3.spr" },
  [8] = { "\\image\\item\\other\\scriptitem\\dsb_05_0.spr", "" },
  [9] = { "\\image\\item\\other\\scriptitem\\dsb_05_1.spr", "\\image\\effect\\other\\new_jin3.spr" },
  [10] = { "\\image\\item\\other\\scriptitem\\dsb_01_0.spr", "" },
}
-- key值是龙珠当前所在状态对应的等级
local tbUseCost = { --g,d,p,l,num,wareId,warePrice
  --[4] = {18,1,1676,1, 1, 610, 20},
  --[5] = {18,1,1676,1, 3, 610, 20},
  -- 精力，活力
  [4] = { 330, 330 },
  [5] = { 990, 990 },
}

-- key值是龙珠当前所在状态对应的等级
local tbReputeAward = {
  { 15, 1, 3 },
  { 15, 1, 4 },
  { 15, 1, 5 },
  { 15, 1, 12 },
  { 15, 1, 16 },
}

function tbBall:InitIconImage()
  local nState = self:GetCurState(it)
  local szIcon = ""
  if nState and tbMaskLayerFiles[nState] then
    szIcon = tbMaskLayerFiles[nState][1]
  end

  return szIcon
end

function tbBall:CalcValueInfo()
  local nState = self:GetCurState(it)
  local szTransIcon = nil
  if nState and tbMaskLayerFiles[nState] then
    szTransIcon = tbMaskLayerFiles[nState][2]
  end

  -- 作为一个scriptitem,原始价值量就是最终价值量
  return it.nOrgValue, 1, "white", szTransIcon, "", self:InitIconImage()
end

function tbBall:GetTip()
  local nState, bActive, nLevel = self:GetCurState(it)
  local bReputeFull = IsReputeFull(me, unpack(Item.XIAYIN_REPUTE_ID))

  local szTip = "参加逍遥谷、白虎堂、藏宝图、鄂伦河原、宋金战场、跨服宋金都可汲取天地元气后可以萃取其中的精华来获得<color=yellow>龙魂·侠影<color>声望，最多5次，每日凌晨3点会重置可萃取次数。<enter>"
  szTip = szTip .. string.format("<color=yellow>当前萃取次数：%d/5<color><enter>", nLevel - 1)

  if nLevel <= Item.DRAGONBALL_MAX_STATE_LEVEL then
    szTip = szTip .. string.format("<color=yellow>本次萃取可获得%d点龙魂·侠影声望<color><enter><enter>", tbReputeAward[nLevel][3])
  else
    szTip = szTip .. (bReputeFull == 1 and "<enter>" or "<color=red>龙影珠元气已耗尽，今天再无法萃取其中精华<color><enter><enter>")
  end

  szTip = szTip .. "<color=green>光华变幻莫测的珠子，隐隐有龙形光影在其中流转。<color>"

  if bReputeFull == 1 then
    szTip = szTip .. "<enter><enter><color=cyan>您的龙魂·侠影声望已满，可前往白秋琳处销毁龙影珠。<color>"
  elseif bActive == 1 then
    szTip = szTip .. "<enter><enter><color=cyan>当前可右键点击使用。<color>"
  end

  return szTip
end

-- private方法，请不要在外部调用该方法；有了这个接口就使得龙珠都是独立的个体
-- 这里操作的是GenInfo(),不要操作角色任务变量
function tbBall:GetCurState(pItem)
  local tbInfo = pItem.GetGenInfo()
  local nState = tbInfo[1]
  local bActive = nState % 2
  local nLevel = math.floor(nState / 2) + 1

  return nState, bActive, nLevel
end

-- 这里操作的是GenInfo(),不要操作角色任务变量
function tbBall:SetCurState(pItem, nState)
  -- 理论上外部已经保证了nState的取值范围，这个判断可以不要
  if nState >= Item.DRAGONBALL_MAX_STATE_LEVEL * 2 then
    nState = Item.DRAGONBALL_MAX_STATE_LEVEL * 2
  end

  pItem.SetGenInfo(1, nState)
  local nRet = pItem.Regenerate(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries, pItem.nEnhTimes, pItem.nLucky, pItem.GetGenInfo(), 0, 0, 0)
  return nRet
end

function tbBall:GetUseCost(nStateLevel)
  return tbUseCost[nStateLevel]
end

function tbBall:UseCost(nState, nLevel, dwId)
  local tbCost = self:GetUseCost(nLevel)
  if not tbCost then
    return 1
  end

  if dwId then
    local tbOpt = {
      { "是", self.CheckPermission, self, { self.GeneralProcess, self, dwId, tbCost }, tbCost },
      { "我再想想" },
    }

    local szMsg = "此刻龙影珠元气澎湃十分狂暴，需要一些辅材方能萃取。"
    if tbCost[1] ~= tbCost[2] then
      szMsg = szMsg .. string.format("\n\n您是否需要花费<color=gold>精力%d点<color>和<color=gold>活力%d点<color>来萃取龙影珠精华？", tbCost[1], tbCost[2])
    else
      szMsg = szMsg .. string.format("\n\n你是否需要花费<color=gold>精活%d点<color>来萃取龙影珠精华？（萃取后可获得<color=yellow>%d点<color>龙魂·侠影声望）", tbCost[1], tbReputeAward[nLevel][3])
    end

    Dialog:Say(szMsg, tbOpt)
    return 0
  else
    if me.dwCurMKP < tbCost[1] or me.dwCurGTP < tbCost[2] then
      me.Msg("你的精活不足，无法萃取。")
      return 0
    end

    me.ChangeCurMakePoint(0 - tbCost[1])
    me.ChangeCurGatherPoint(0 - tbCost[2])

    return 1
  end

  return 0
end

function tbBall:OnUse(nParam)
  if IsReputeFull(me, unpack(Item.XIAYIN_REPUTE_ID)) == 1 then
    me.Msg("您的龙魂·侠影声望已满！")
    return 0
  end

  if Item:CheckDragonBallState(me, it) ~= 1 then
    me.Msg("龙影珠状态异常，可先去秋姨处销毁，然后再去龙五太爷处重新领取。")
    return 0
  end

  local nState, bActive, nLevel = self:GetCurState(it)
  if nLevel > Item.DRAGONBALL_MAX_STATE_LEVEL then
    me.Msg("今日龙影珠已经萃取完毕，须待下一个寅时（凌晨3点）之后方可再度汲取元气而萃取。")
    return 0
  elseif not bActive or bActive == 0 then
    me.Msg("您的龙影珠尚未汲取足够的元气，无法使用。")
    Dialog:SendBlackBoardMsg(me, "您的龙影珠尚未汲取足够的元气，无法使用。")
    return 0 -- 没有被激活
  end

  if self:UseCost(nState, nLevel, it.dwId) ~= 1 then
    return 0
  end

  self:GeneralProcess(it.dwId)

  return 0
end

function tbBall:GeneralProcess(dwId)
  local tbEvent = {
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
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
  }

  -- process里面维护了me，但没有维护it
  GeneralProcess:StartProcess("萃取精华中...", self.PROCESS_TIME, { self.OnSureUse, self, dwId }, nil, tbEvent)
end

function tbBall:OnSureUse(dwId)
  if IsReputeFull(me, unpack(Item.XIAYIN_REPUTE_ID)) == 1 then
    me.Msg("您的龙魂·侠影声望已满！")
    return 0
  end

  local pItem = KItem.GetObjById(dwId)
  if not pItem then
    return 0
  end

  if Item:CheckDragonBallState(me, pItem) ~= 1 then
    me.Msg("龙影珠状态异常，可先去秋姨处销毁，然后再去龙五太爷处重新领取。")
    return 0
  end

  local nState, bActive, nLevel = self:GetCurState(pItem)
  if self:UseCost(nState, nLevel) ~= 1 then
    return 0
  end

  local nState, bActive, nLevel = self:GetCurState(pItem)

  -- 释放特效技能
  me.CallClientScript({ "Item:Dragonball_AddState" })

  local nRet = Item:SetDragonBallState(me, pItem, nState + 1)
  if nRet == 0 then
    Dbg:WriteLog("DragonBall", "OnUse", me.szName .. " SetState Failed!")
  else
    me.AddRepute(unpack(tbReputeAward[nLevel])) -- 获得声望奖励
    Dialog:SendBlackBoardMsg(me, "恭喜你成功萃取到龙影珠精华，<color=yellow>龙魂侠影声望获得了提升。<color>")
    local nCostLog = 0
    if self:GetUseCost(nLevel) then
      Player:SendMsgToKinOrTong(me, "萃取到了龙影珠中澎湃的元气，龙魂·侠影声望大幅度提升。", 0)
      me.SendMsgToFriend(string.format("您的好友<color=green>%s<color>萃取到了龙影珠中澎湃的元气，龙魂·侠影声望大幅度提升。", me.szName))
      nCostLog = self:GetUseCost(nLevel)[1]
    end

    StatLog:WriteStatLog("stat_info", "dragon_ball", "use", me.nId, string.format("%d,%d", tbReputeAward[nLevel][3], nCostLog))
  end

  return 0
end

function tbBall:CheckPermission(tbOption, tbInfo)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return 0
  end
  if me.dwCurMKP < tbInfo[1] or me.dwCurGTP < tbInfo[2] then
    me.Msg("你的精力和活力不足，无法萃取。")
    return 0
  end
  Lib:CallBack(tbOption)
end

---------------------------------------------------------------------------------------------------------------------
Item.DRAGONBALL_MAX_STATE_LEVEL = 5 -- 这是状态等级，每一状态等级又对应两个状态
Item.USE_STATE_EFFECT_ID = 87 -- 使用特效ID
Item.DRAGONBALL_GDPL = { 18, 1, 1699, 1 } -- 龙珠GDPL
Item.XIAYIN_REPUTE_ID = { 15, 1 } -- 龙魂·侠影ID

-- 设置龙珠状态
-- nFindType为0表示只搜索背包；否则表示搜索背包和仓库；默认为0
function Item:SetDragonBallState(pPlayer, pBall, nSetState, nFindType)
  nFindType = nFindType or 0
  if not pPlayer then
    return
  end

  if IsReputeFull(pPlayer, unpack(Item.XIAYIN_REPUTE_ID)) == 1 then
    --pPlayer.Msg("您的龙魂·侠影声望已满！");
    return 0
  end

  -- nState取值0 -- 10，为10时表示满值状态，不可再更改
  -- 如果身上没有龙珠，不可设置任务变量
  if not pBall then
    local tbRes = {}
    if nFindType == 0 then
      tbRes = pPlayer.FindItemInBags(unpack(self.DRAGONBALL_GDPL)) -- 只搜索背包
    else
      tbRes = pPlayer.FindItemInAllPosition(unpack(self.DRAGONBALL_GDPL)) -- 搜索背包和仓库
    end
    if not tbRes or Lib:CountTB(tbRes) ~= 1 then
      return 0
    end

    pBall = tbRes[1].pItem
  end

  if nSetState >= self.DRAGONBALL_MAX_STATE_LEVEL * 2 then
    nSetState = self.DRAGONBALL_MAX_STATE_LEVEL * 2
  end

  self:CheckPlayerDragonBallInfo(pPlayer)

  if nSetState > 0 and nSetState == pPlayer.GetTask(Player.TASK_MAIN_GROUP, Player.TASK_SUB_GROUP_STATE) then
    return 0
  end

  local tbDragonBall = Item:GetClass("dragonball")
  pPlayer.SetTask(Player.TASK_MAIN_GROUP, Player.TASK_SUB_GROUP_STATE, nSetState)
  -- 同时要更新身上龙珠的信息，保证显示信息的正确
  return tbDragonBall:SetCurState(pBall, nSetState)
end

-- 获取龙珠状态
function Item:GetDragonBallState(pPlayer)
  local nState = pPlayer.GetTask(Player.TASK_MAIN_GROUP, Player.TASK_SUB_GROUP_STATE)
  local bActive = nState % 2
  local nLevel = math.floor(nState / 2) + 1

  return nState, bActive, nLevel
end

-- 检查龙珠道具信息是否正确
function Item:CheckDragonBallState(pPlayer, pBall)
  self:CheckPlayerDragonBallInfo(pPlayer)
  local nState = pPlayer.GetTask(Player.TASK_MAIN_GROUP, Player.TASK_SUB_GROUP_STATE)
  local nBallState = pBall.GetGenInfo(1)

  local nRet = 0
  if pBall.szClass == "dragonball" and nState == nBallState then
    nRet = 1
  end

  return nRet
end

-- 激活龙珠。 第二个参数为龙珠道具对象，若不指定，则到背包中去查找
function Item:ActiveDragonBall(pPlayer, pBall)
  self:CheckPlayerDragonBallInfo(pPlayer)

  local nState, bActive, nLevel = self:GetDragonBallState(pPlayer)

  if (bActive and bActive == 1) or (nState >= self.DRAGONBALL_MAX_STATE_LEVEL * 2) then
    return 0
  end

  local nRet = self:SetDragonBallState(pPlayer, pBall, nState + 1)
  if nRet ~= 0 then
    pPlayer.Msg("<color=yellow>经过天地元气的洗练，你的龙影珠可以萃取精华了。<color>")
    Dialog:SendBlackBoardMsg(pPlayer, "经过天地元气的洗练，你的龙影珠可以萃取精华了。")
  end
  return nRet
end

function Item:SyncPlayerDataToBall(pPlayer, pBall)
  self:CheckPlayerDragonBallInfo(pPlayer)
  local nState = pPlayer.GetTask(Player.TASK_MAIN_GROUP, Player.TASK_SUB_GROUP_STATE)
  if not pBall then
    local tbRes = pPlayer.FindItemInBags(unpack(self.DRAGONBALL_GDPL))
    if not tbRes or Lib:CountTB(tbRes) ~= 1 then
      return 0
    end

    pBall = tbRes[1].pItem
  end

  local tbDragonBall = Item:GetClass("dragonball")
  return tbDragonBall:SetCurState(pBall, nState)
end

function Item:CheckPlayerDragonBallInfo(pPlayer)
  local nToday = Lib:GetLocalDay(GetTime())
  local nLocalDayTime = Lib:GetLocalDayTime(GetTime()) -- 今天已经过去的时间
  if nLocalDayTime < 3 * 3600 then -- 跨天了但在3点之前，认为是前一天
    nToday = nToday - 1
  end
  if nToday ~= pPlayer.GetTask(Player.TASK_MAIN_GROUP, Player.TASK_SUB_GROUP_RESET_DAY) then
    pPlayer.SetTask(Player.TASK_MAIN_GROUP, Player.TASK_SUB_GROUP_STATE, 0)
    pPlayer.SetTask(Player.TASK_MAIN_GROUP, Player.TASK_SUB_GROUP_RESET_DAY, nToday)
  end
end

function Item:Dragonball_AddState()
  me.AddSkillEffect(self.USE_STATE_EFFECT_ID)
end
