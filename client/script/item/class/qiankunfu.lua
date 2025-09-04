-------------------------------------------------------------------
--File:
--Author: 	sunduoliang
--Date: 	2008-4-14 9:00
--Describe:	乾坤符
-------------------------------------------------------------------
Require("\\script\\item\\class\\qiankunfulogic.lua")

-- 乾坤符
local tbItem = Item:GetClass("qiankunfu")
tbItem.nTime = 10 -- 延时的时间(秒)
function tbItem:OnUse()
  local pPlayer = me
  self:ShowOnlineMember(it.dwId, pPlayer.nId)
  return 0
end

function tbItem:ShowOnlineMember(nItemId, nPlayerId)
  local tbOnlineMember = {}
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer == nil then
    return 0
  end
  local tbTeamMemberList = KTeam.GetTeamMemberList(pPlayer.nTeamId)
  if tbTeamMemberList == nil then
    Dialog:Say("没有队友，不能使用乾坤符！")
    return 0
  else
    for _, nMemPlayerId in pairs(tbTeamMemberList) do
      if nMemPlayerId ~= nPlayerId then
        local szMemName = KGCPlayer.GetPlayerName(nMemPlayerId)
        local nOnline = KGCPlayer.OptGetTask(nMemPlayerId, KGCPlayer.TSK_ONLINESERVER)
        local szOnline = "[离线]"
        if nOnline > 0 then
          szOnline = "[在线]"
        end
        tbOnlineMember[#tbOnlineMember + 1] = { string.format("%s%s", szMemName, szOnline), self.SelectMember, self, nMemPlayerId, nPlayerId, nOnline, nItemId }
      end
    end
  end

  if #tbOnlineMember <= 0 then
    Dialog:Say("没有队友，不能使用乾坤符！")
    return 0
  end
  tbOnlineMember[#tbOnlineMember + 1] = { "取消" }
  Dialog:Say("你想到哪位队友那里去？", tbOnlineMember)
end

function tbItem:SelectMember(nMemberPlayerId, nPlayerId, nOnline, nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if pPlayer == nil then
    return 0
  end
  if nOnline <= 0 then
    Dialog:Say("该队友不在线，无法传送到该队友身边。")
    return 0
  end
  local szMemberName = KGCPlayer.GetPlayerName(nMemberPlayerId)
  local nNowOnline = KGCPlayer.OptGetTask(nMemberPlayerId, KGCPlayer.TSK_ONLINESERVER)
  if nNowOnline <= 0 then
    Dialog:Say("该队友已经下线，无法传送到该队友身边。")
    return 0
  end

  GlobalExcute({ "Item.tbQianKunFu:ReCordPlayerMapId_GS", nMemberPlayerId, nPlayerId, nItemId })

  local tbEvent = { -- 会中断延时的事件
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
  if 0 == pPlayer.nFightState then -- 玩家在非战斗状态下传送无延时正常传送
    self:DoSelectMember(nMemberPlayerId, nPlayerId, nItemId)
    return 0
  end
  GeneralProcess:StartProcess(string.format("正在传送去队友[%s]那...", szMemberName), self.nTime * Env.GAME_FPS, { self.DoSelectMember, self, nMemberPlayerId, nPlayerId, nItemId }, nil, tbEvent) -- 在战斗状态下需要nTime秒的延时
end

-- 功能:	传送玩家去报名点
-- 参数:	nMapId 要传至的报名点的Id
function tbItem:DoSelectMember(nMemberPlayerId, nPlayerId, nItemId)
  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  local nOnline = KGCPlayer.OptGetTask(nMemberPlayerId, KGCPlayer.TSK_ONLINESERVER)
  if nOnline <= 0 then
    Dialog:Say("该队友已经下线，无法传送到该队友身边。")
    return 0
  end
  if Item.tbQianKunFu:CheckMember(nPlayerId, nMemberPlayerId) ~= 1 then
    pPlayer.Msg("你没有该队友，可能是该队友已经离开队伍！")
    return 0
  end
  GCExcute({ "Item.tbQianKunFu:SelectMemberPos", nMemberPlayerId, nPlayerId, nItemId, nMapId })
end

function tbItem:GetTip(nState)
  local nUseCount = it.GetGenInfo(1, 0)
  local nLastCount = Item.tbQianKunFu.tbItemList[it.nParticular] - nUseCount
  local szTip = ""
  szTip = szTip .. string.format("<color=0x8080ff>右键点击使用<color>\n")
  szTip = szTip .. string.format("<color=yellow>剩余使用次数: %s<color>", nLastCount)
  return szTip
end

tbItem.tbQianKunFuSet = {
  { 18, 1, 85, 1 },
  { 18, 1, 91, 1 },
}

-- 客户端直接传送到某一个玩家
function tbItem:OnClientCall(nTargerPlayerID, nSure)
  local nFlag = KItem.CheckLimitUse(me.nMapId, "chuansong")
  if nFlag ~= 1 then
    me.Msg("该地图禁止使用乾坤符")
    return 0
  end
  local tbTeamMemberList = KTeam.GetTeamMemberList(me.nTeamId)
  if tbTeamMemberList == nil then
    return 0
  end
  local tbFind = {}
  for i = 1, #self.tbQianKunFuSet do
    local tbTempFind = me.FindItemInBags(unpack(self.tbQianKunFuSet[i]))
    Lib:MergeTable(tbFind, tbTempFind)
  end
  if not tbFind or #tbFind <= 0 then
    -- 金币不足引导充值
    if me.nCoin < 200 then
      local szMsg = "你的身上已经没有乾坤符，购买乾坤符需要花费<color=yellow>200金币<color>，你的金币余额已经不足，是否充值？"
      local tbOpt = {
        { "<color=yellow>我要充值<color>", self.OnOpenOnlinePay, self },
        { "暂不充值" },
      }
      Dialog:Say(szMsg, tbOpt)
    else
      local szMsg = "“传”功能可瞬间将您传送至队友身边，让您更方便的参与队伍活动。每使用一个<color=yellow>乾坤符<color>有<color=yellow>10次<color>队友传送机会。使用该功能需要背包里有乾坤符。"
      local tbOpt = {
        { "<color=yellow>消耗200金币购买一个{乾坤符}<color>", self.ApplyBuyQiankunfu, self },
        { "暂不购买" },
      }

      Dialog:Say(szMsg, tbOpt)
    end

    return 0
  end
  local nItemId = tbFind[1].pItem.dwId
  local nRemainTimes = Item.tbQianKunFu.tbItemList[tbFind[1].pItem.nParticular] - tbFind[1].pItem.GetGenInfo(1, 0)
  for _, tbTemp in pairs(tbFind) do
    local nTempRemainTime = Item.tbQianKunFu.tbItemList[tbTemp.pItem.nParticular] - tbTemp.pItem.GetGenInfo(1, 0)
    if nTempRemainTime < nRemainTimes then
      nItemId = tbTemp.pItem.dwId
      nRemainTimes = nTempRemainTime
    end
  end
  local nPlayerId = me.nId
  local nFlag = 0
  local nOnline = 0
  local szMemberName = ""
  for _, nMemPlayerId in pairs(tbTeamMemberList) do
    if nMemPlayerId ~= nPlayerId and nMemPlayerId == nTargerPlayerID then
      szMemberName = KGCPlayer.GetPlayerName(nMemPlayerId)
      nOnline = KGCPlayer.OptGetTask(nMemPlayerId, KGCPlayer.TSK_ONLINESERVER)
      nFlag = 1
      break
    end
  end
  if nFlag == 1 then
    if nOnline <= 0 then
      Dialog:Say("该队友已经下线，无法传送到该队友身边。")
      return
    end
    if nSure == 1 then
      self:SelectMember(nTargerPlayerID, nPlayerId, nOnline, nItemId)
    else
      local szMsg = string.format("确定传送到队友[%s]身边吗？", szMemberName)
      local tbOpt = {
        { "确定", self.OnClientCall, self, nTargerPlayerID, 1 },
        { "我再考虑一下" },
      }
      Dialog:Say(szMsg, tbOpt)
    end
  else
    Dialog:Say("你没有该队友，可能是该队友已经离开队伍！")
  end
end

function tbItem:ApplyBuyQiankunfu()
  if me.IsAccountLock() ~= 0 then
    me.Msg("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    me.Msg("背包空间不足，请整理出一个背包空间！")
    return 0
  end
  if me.nCoin < 200 then
    me.Msg("金币数量不足")
    return 0
  end
  me.ApplyAutoBuyAndUse(22, 1, 0)
  Dbg:WriteLog("Player", me.szName, "ApplyBuyQiankunfu", 22)
end

-- 直接打开充值界面
function tbItem:OnOpenOnlinePay()
  if IVER_g_nSdoVersion == 1 then
    me.CallClientScript({ "OpenSDOWidget" })
    return
  end
  local szZoneName = GetZoneName()
  me.CallClientScript({ "Ui:ServerCall", "UI_PAYONLINE", "OnRecvZoneOpen", szZoneName })
end
