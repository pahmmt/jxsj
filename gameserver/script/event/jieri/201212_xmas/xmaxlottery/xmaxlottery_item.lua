-- 幸运大转盘
-- 2012/12/6 10:57:16
-- zhouchenfei

-- 玩家点开始后，就已经决定了是什么
-- 根据玩家的结果，随机出图案，记录到图案表里
-- 当玩家点完5次后

Require("\\script\\event\\jieri\\201212_xmas\\xmaxlottery\\xmaxlottery_def.lua")

local XmasLottery2012 = SpecialEvent.XmasLottery2012

------------------------------------------------------------
-- 圣诞奖励宝盒
------------------------------------------------------------
local tbItem = Item:GetClass("xmax2012_luckybox")

XmasLottery2012.MAX_RANDOM_NUM = 10000
XmasLottery2012.tbExAwardRandomList = {
  [1] = { 1000, 2000 },
  [2] = { 500, 1000 },
}

tbItem.nRandom_BindCoinAward = 2000
tbItem.tbAwardCoin = {
  [1] = 100,
  [2] = 300,
  [3] = 700,
  [4] = 1300,
  [5] = 2300,
}

XmasLottery2012.nTime_WaiZhuang = 3 * 24 * 60 * 60
XmasLottery2012.nTime_Pat = 7 * 24 * 60 * 60

function tbItem:OnUse()
  local nType = tonumber(it.GetExtParam(1))
  local nRound = it.GetGenInfo(1)
  local nNeed = 1 + XmasLottery2012:GetExAwardNeedBag(me, nType)
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  local szItemName = it.szName

  -- 这里是有20%的机率出绑金
  if nType ~= 1 then
    local nBindCoin = self.tbAwardCoin[nRound]
    if nBindCoin and nBindCoin > 0 then
      local nRandom = MathRandom(XmasLottery2012.MAX_RANDOM_NUM)
      if nRandom <= self.nRandom_BindCoinAward then
        me.AddBindCoin(nBindCoin)

        Dbg:WriteLog("XmasLottery2012", "ApplyGetLuckyGameAward", me.szName, nType, "BindCoin", nBindCoin)
        XmasLottery2012:GiveWaiZhuangAwardEx(me, nType, szItemName)
        XmasLottery2012:GivePatAwardEx(me, nType, szItemName)
        XmasLottery2012:SendAnnouce(me, 1, szItemName, nBindCoin)
        StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_award", me.nId, string.format("bindcoin,%s", nBindCoin))
        return 1
      end
    end
  end

  if 1 == nType then
    XmasLottery2012:GiveReputeAward(me, szItemName)
  else
    local nValue = XmasLottery2012.tbAwardValue[nType]
    local nOpenDay = math.floor((GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) / (60 * 60 * 24))
    local tbAward = Lib._CalcAward:RandomAward(3, 4, 2, nValue, Lib:_GetXuanReduce(nOpenDay), { 8, 2, 0 })
    local nMaxMoney = XmasLottery2012:GetMaxMoney(tbAward)
    if nMaxMoney + me.GetBindMoney() > me.GetMaxCarryMoney() then
      Dialog:Say("对不起，您身上的绑定银两可能会超出上限，请整理后再来领取。")
      return 0
    end
    XmasLottery2012:RandomAward(me, tbAward, 1, szItemName)
  end

  XmasLottery2012:GiveWaiZhuangAwardEx(me, nType, szItemName)
  XmasLottery2012:GivePatAwardEx(me, nType, szItemName)

  return 1
end

function XmasLottery2012:GiveWaiZhuangAwardEx(pPlayer, nType, szItemName)
  local nIsGetMaxk = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASKID_GET_EX_AWARD_MASK)
  if nIsGetMaxk ~= 0 then
    return 0
  end

  if nType ~= 1 and nType ~= 2 then
    return 0
  end

  local nRandom = MathRandom(self.MAX_RANDOM_NUM)
  local nNeedRandom = self.tbExAwardRandomList[nType][1]
  if not nNeedRandom or nRandom > nNeedRandom then
    return 0
  end

  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_GET_EX_AWARD_MASK, 1)
  local pItem = pPlayer.AddItem(18, 1, 1879, 1)
  if not pItem then
    return 0
  end

  pItem.Bind(1)
  pItem.SetTimeOut(0, GetTime() + self.nTime_WaiZhuang)
  pItem.Sync(0)
  Dbg:WriteLog("XmasLottery2012", "GiveWaiZhuangAwardEx", pPlayer.szName, nType, pItem.szName)
  self:SendAnnouce(pPlayer, 4, szItemName)
  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_award", me.nId, string.format("18,1,1879,1,1"))
  return 1
end

function XmasLottery2012:GivePatAwardEx(pPlayer, nType, szItemName)
  local nIsGetMaxk = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASKID_GET_EX_AWARD_PAT)
  if nIsGetMaxk ~= 0 then
    return 0
  end

  if nType ~= 1 and nType ~= 2 then
    return 0
  end

  local nRandom = MathRandom(self.MAX_RANDOM_NUM)
  local nNeedRandom = self.tbExAwardRandomList[nType][2]
  if not nNeedRandom or nRandom > nNeedRandom then
    return 0
  end

  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASKID_GET_EX_AWARD_PAT, 1)
  local pItem = pPlayer.AddItem(18, 1, 1900, 1)
  if not pItem then
    return 0
  end

  pItem.Bind(1)
  pItem.SetTimeOut(0, GetTime() + self.nTime_Pat)
  pItem.Sync()
  Dbg:WriteLog("XmasLottery2012", "GivePatAwardEx", pPlayer.szName, pItem.szName)
  self:SendAnnouce(pPlayer, 5, szItemName)
  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_award", pPlayer.nId, string.format("18,1,1900,1,1"))
  return 1
end

function XmasLottery2012:GetExAwardNeedBag(pPlayer, nType)
  if not pPlayer then
    return 0
  end

  if nType ~= 1 and nType ~= 2 then
    return 0
  end

  local nNeedBag = 0
  local nIsGetMaxk = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASKID_GET_EX_AWARD_MASK)
  if nIsGetMaxk == 0 then
    nNeedBag = nNeedBag + 1
  end

  nIsGetMaxk = pPlayer.GetTask(self.TASK_GROUP_ID, self.TASKID_GET_EX_AWARD_PAT)
  if nIsGetMaxk == 0 then
    nNeedBag = nNeedBag + 1
  end

  return nNeedBag
end

function XmasLottery2012:GetMaxMoney(tbAward)
  local nMaxValue = 0
  for _, tbInfo in ipairs(tbAward) do
    if tbInfo[1] == "绑银" and nMaxValue < tbInfo[2] then
      nMaxValue = tbInfo[2]
    end
  end
  return nMaxValue
end

function XmasLottery2012:RandomAward(pPlayer, tbAward, nType, szItemName)
  local nRate = MathRandom(1000000)
  local nAdd = 0
  local nFind = 0
  for i, tbInfo in ipairs(tbAward) do
    nAdd = nAdd + tbInfo[3]
    if nRate <= nAdd then
      nFind = i
      break
    end
  end
  if nFind > 0 then
    local tbFind = tbAward[nFind]
    if tbFind[1] == "玄晶" then
      if nType == 1 then
        pPlayer.AddItemEx(18, 1, 114, tbFind[2])
        StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_award", pPlayer.nId, string.format("18,1,114,%s,1", tbFind[2]))
      else
        pPlayer.AddItemEx(18, 1, 1, tbFind[2])
        StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_award", pPlayer.nId, string.format("18,1,1,%s,1", tbFind[2]))
      end
      self:SendAnnouce(pPlayer, 3, szItemName, tbFind[2])
    elseif tbFind[1] == "绑金" then
      local nBindCoin = math.floor(tbFind[2])
      pPlayer.AddBindCoin(nBindCoin)
      StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_award", pPlayer.nId, string.format("bindcoin,%s", nBindCoin))
      self:SendAnnouce(pPlayer, 2, szItemName, nBindCoin)
    elseif tbFind[1] == "绑银" then
      local nBindMoney = math.floor(tbFind[2])
      pPlayer.AddBindMoney(nBindMoney)
      self:SendAnnouce(pPlayer, 1, szItemName, nBindMoney)
      StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_award", pPlayer.nId, string.format("bindmoney,%s", nBindMoney))
    end
    Dbg:WriteLog("XmasLottery2012", "xmax2012_luckybox", pPlayer.szName, nType, tbFind[1], tbFind[2])
  end
end

function XmasLottery2012:GiveReputeAward(pPlayer, szItemName)
  if not pPlayer then
    return 0
  end
  local nLevelLingTu = pPlayer.GetReputeLevel(8, 1)
  local nLevelWuLinLianSai = pPlayer.GetReputeLevel(7, 1)

  --判断声望等级
  local nRand = 1
  if nLevelLingTu < 4 and nLevelWuLinLianSai < 4 then
    nRand = MathRandom(3, 6)
  elseif nLevelLingTu < 4 and nLevelWuLinLianSai >= 4 then
    nRand = MathRandom(2, 6)
  elseif nLevelLingTu >= 4 and nLevelWuLinLianSai < 4 then
    nRand = MathRandom(2, 6)
    if nRand == 2 then
      nRand = 1
    end
  else
    nRand = MathRandom(1, 6)
  end
  local pItemEx = pPlayer.AddItemEx(unpack(self.tbYouLong[nRand]))
  if not pItemEx then
    Dbg:WriteLog("XmasLottery2012", "Give paizi failed", pPlayer.szName)
    return 0
  end
  self:SendAnnouce(pPlayer, 6, szItemName, pItemEx.szName)
  local szLog = string.format("%s,%s,%s,%s,1", self.tbYouLong[nRand][1], self.tbYouLong[nRand][2], self.tbYouLong[nRand][3], self.tbYouLong[nRand][4])
  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "card_award", pPlayer.nId, szLog)
  pItemEx.Bind(1)

  return 1
end

function XmasLottery2012:SendAnnouce(pPlayer, nItemType, szItemName, nValue)
  local szKinMsg = "开启了<color=pink>" .. szItemName .. "<color>获得了"
  local nIsGlobal = 0
  local nIsKin = 0
  local nIsFriend = 0
  local szGlobalMsg = pPlayer.szName .. "开启了<color=pink>" .. szItemName .. "<color>获得了"
  if nItemType == 1 then -- 绑银
    if nValue < 1000000 then
      return 0
    end
    nValue = math.floor(nValue)
    szKinMsg = szKinMsg .. string.format("%s绑银", nValue)
    szGlobalMsg = szGlobalMsg .. string.format("%s绑银", nValue)
    if nValue > 2000000 then
      nIsGlobal = 1
    end
  elseif nItemType == 2 then -- 绑金
    if nValue < 2000 then
      return 0
    end
    nValue = math.floor(nValue)
    szKinMsg = szKinMsg .. string.format("%s绑金", nValue)
    szGlobalMsg = szGlobalMsg .. string.format("%s绑金", nValue)
  elseif nItemType == 3 then -- 玄晶
    if nValue < 7 then
      return 0
    end
    szKinMsg = szKinMsg .. string.format("一个%s级玄晶", nValue)
    szGlobalMsg = szGlobalMsg .. string.format("一个%s级玄晶", nValue)
    if nValue >= 9 then
      nIsGlobal = 1
    end
  elseif nItemType == 4 then -- 跟宠
    szKinMsg = szKinMsg .. string.format("<color=pink>绝版跟宠【熊宝】<color>")
    szGlobalMsg = szGlobalMsg .. string.format("<color=pink>绝版跟宠【熊宝】<color>")
    nIsGlobal = 1
  elseif nItemType == 5 then -- 外装
    szKinMsg = szKinMsg .. string.format("<color=pink>圣诞外装箱<color>")
    szGlobalMsg = szGlobalMsg .. string.format("<color=pink>圣诞外装箱<color>")
    nIsGlobal = 1
  elseif nItemType == 6 then
    szKinMsg = szKinMsg .. string.format("<color=pink>%s<color>", nValue)
    szGlobalMsg = szGlobalMsg .. string.format("<color=pink>%s<color>", nValue)
    nIsGlobal = 1
  else
    return 0
  end

  Player:SendMsgToKinOrTong(pPlayer, szKinMsg, 0)
  pPlayer.SendMsgToFriend(string.format("您的好友[<color=yellow>%s<color>]%s", pPlayer.szName, szKinMsg))
  if nIsGlobal == 1 then
    KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, szGlobalMsg)
  end
  return 1
end

------------------------------------------------------------
-- 圣诞铃铛
------------------------------------------------------------
local tbLingDang = Item:GetClass("xmax2012_lingdang")

function tbLingDang:OnUse()
  if XmasLottery2012:IsGameOpen(me) ~= 1 then
    me.Msg("不在活动期间，不能使用！")
    return 0
  end

  local szMapClass = GetMapType(me.nMapId) or ""
  if szMapClass ~= "village" and szMapClass ~= "city" then
    me.Msg("只有城市和新手村才能打开！")
    return 0
  end

  me.CallClientScript({ "UiManager:OpenWindow", "UI_LUCKYFAN" })
  return 0
end

------------------------------------------------------------
-- 圣诞外装箱
------------------------------------------------------------
local tbWaiZhuangBox = Item:GetClass("xmax2012_waizhuang")

tbWaiZhuangBox.tbWaiZhuangList = {
  [Env.SEX_MALE] = {
    {
      { 1, 25, 45, 1 },
      { 1, 26, 47, 1 },
    },
  },
  [Env.SEX_FEMALE] = {
    {
      { 1, 25, 44, 1 },
      { 1, 26, 46, 1 },
    },
    {
      { 1, 25, 44, 1 },
      { 1, 26, 48, 1 },
    },
  },
}

function tbWaiZhuangBox:OnUse()
  local nTime = tonumber(it.GetExtParam(1))
  if me.CountFreeBagCell() < 2 then
    me.Msg("你的背包空格不足2格，请先清理背包！")
    return 0
  end

  local tbItem = self.tbWaiZhuangList[me.nSex]

  local szMsg = [[你可以选择以下外装：
<color=yellow>女性圣诞外装1——桃夕韵雪装【女】（双辫）<color>
<color=yellow>女性圣诞外装2——桃夕韵雪装【女】（双髻）<color>]]
  if me.nSex == Env.SEX_MALE then
    szMsg = [[你可以选择以下外装：
<color=yellow>炽染寒华装【男】<color>]]
  end
  local tbOpt = {}

  for nIndex, tbInfo in pairs(tbItem) do
    tbOpt[#tbOpt + 1] = { string.format("%s圣诞外装%s", Env.SEX_NAME[me.nSex], nIndex), self.OnSureSelect, self, it.dwId, nIndex, nTime }
  end

  Dialog:Say(szMsg, tbOpt)
  return 0
end

function tbWaiZhuangBox:OnSureSelect(nItemId, nIndex, nTime)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end

  if me.CountFreeBagCell() < 2 then
    me.Msg("你的背包空格不足2格，请先清理背包！")
    return 0
  end

  local tbItem = self.tbWaiZhuangList[me.nSex]
  local tbInfo = tbItem[nIndex]
  pItem.Delete(me)
  for _, tbOneItem in pairs(tbInfo) do
    local pItemEx = me.AddItem(unpack(tbOneItem))
    Lib:ShowTB(tbOneItem)
    if pItemEx then
      pItemEx.Bind(1)
      if nTime > 0 then
        pItemEx.SetTimeOut(0, GetTime() + nTime * 3600 * 24)
      end
      pItemEx.Sync()
    else
      Dbg:WriteLog("XmasLottery2012", "xmax2012_luckybox", me.szName, nIndex, pItem.szName, "failed")
    end
  end
end
