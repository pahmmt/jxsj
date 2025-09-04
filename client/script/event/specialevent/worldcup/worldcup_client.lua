-- 文件名　：worldcup_client.lua
-- 创建者　：furuilei
-- 创建时间：2010-05-19 09:59:29
-- 功能描述：世界杯客户端逻辑

-- Require("\\script\\event\\specialevent\\worldcup\\worldcup_def.lua")

SpecialEvent.tbWroldCup = SpecialEvent.tbWroldCup or {}
local tbEvent = SpecialEvent.tbWroldCup

function tbEvent:OpenCollectionWnd_Client(tbTeamLevel, nMyValue)
  nMyValue = nMyValue or 0
  if not tbTeamLevel then
    return
  end

  local tbInfo = self:GetInfo_Client(tbTeamLevel, nMyValue)
  if not tbInfo then
    return
  end

  -- Lib:ShowTB(tbInfo);
  UiManager:OpenWindow(Ui.UI_CARDVIEW, tbInfo)
end

function tbEvent:GetInfo_Client(tbTeamLevel, nMyValue)
  if not tbTeamLevel then
    return
  end

  local tbInfo = {}
  tbInfo.szTitle = "世界杯卡片"
  tbInfo.szDesc = string.format("下面是您目前收藏的球队卡片的情况。收集卡片，积攒积分，世界杯结束后可以在盛夏活动推广员处领取积分奖励。您当前积分为<color=yellow>%s<color>。", nMyValue)
  self:GetBtnInfo_Client(tbInfo)
  self:GetCardInfo_Client(tbInfo, tbTeamLevel)

  return tbInfo
end

function tbEvent:GetBtnInfo_Client(tbInfo)
  if not tbInfo then
    return
  end

  --	local tbBtn1 = {};
  --	tbBtn1.szName = "积分算法";
  --	tbBtn1.szCallBack = "SpecialEvent.tbWroldCup:_CallBack_Score_Intro()"
  local tbBtn1 = {}
  tbBtn1.szName = "查询排名"
  tbBtn1.szCallBack = "SpecialEvent.tbWroldCup:_CallBack_GetRankInfo()"
  local tbBtn2 = {}
  tbBtn2.szName = "离开"
  tbInfo.tbBtn1 = tbBtn1
  tbInfo.tbBtn2 = tbBtn2
  --	tbInfo.tbBtn3 = tbBtn3;
end

function tbEvent:GetCardInfo_Client(tbInfo, tbTeamLevel)
  if not tbInfo or not tbTeamLevel then
    return
  end
  tbInfo.tbItemInfo = {}
  for nIndex = 1, tbEvent.MAX_CARD_NUM do
    local tbTempItemInfo = {}
    tbTempItemInfo.tbGDPL = self:GetCardGDPL_Client(nIndex)
    tbTempItemInfo.nEffectId = self:GetEffectLevel_Client(nIndex, tbTeamLevel)
    tbTempItemInfo.nCount = self:GetCardNum_Client(nIndex)
    tbTempItemInfo.nLevel = tbTeamLevel[nIndex]
    if tbTempItemInfo.nCount and tbTempItemInfo.nCount > 0 then
      table.insert(tbInfo.tbItemInfo, tbTempItemInfo)
    end
  end

  local _Sort_Client = function(a, b)
    return a.nLevel > b.nLevel
  end

  table.sort(tbInfo.tbItemInfo, _Sort_Client)
end

function tbEvent:GetCardGDPL_Client(nCardIndex)
  if not nCardIndex then
    return
  end

  if nCardIndex <= 0 or nCardIndex > tbEvent.MAX_CARD_NUM then
    return
  end

  local tbGDPL = { 18, 1, 660, 1 }
  tbGDPL[4] = nCardIndex
  return tbGDPL
end

function tbEvent:GetEffectLevel_Client(nCardIndex, tbTeamLevel)
  if not nCardIndex or not tbTeamLevel then
    return 1
  end

  if nCardIndex <= 0 or nCardIndex > tbEvent.MAX_CARD_NUM then
    return
  end

  local nLevel = tbTeamLevel[nCardIndex] or 0

  local nEffectId = self.tbEffect_Level[nLevel] or 1
  return nEffectId
end

function tbEvent:GetCardNum_Client(nCardIndex)
  if not nCardIndex then
    return 1
  end

  if nCardIndex <= 0 or nCardIndex > tbEvent.MAX_CARD_NUM then
    return
  end

  local nTskId = self.TASKID_START + nCardIndex - 1
  local nNum = me.GetTask(self.TASK_GROUP, nTskId)
  return nNum
end

--======================

-- 查看自己收集排名
function tbEvent:_CallBack_GetRankInfo()
  me.CallServerScript({ "GetMyRank_Num" })
end
