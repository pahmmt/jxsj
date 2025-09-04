-- zhouchenfei
-- 2012/9/24 15:29:25
-- 基本脚本函数

Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_def.lua")

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

function ZhouNianQing2012:IsOpenEvent()
  local nNowTime = GetTime()
  local nNowDate = tonumber(os.date("%Y%m%d", nNowTime))
  if nNowDate < ZhouNianQing2012.nEventStartTime then
    return 0, "活动未开启，请稍等！"
  end

  if nNowDate > ZhouNianQing2012.nEventEndTime then
    return 0, "活动已结束！"
  end

  return 1
end

function ZhouNianQing2012:GetOpenDaTianDengEventTimeIndex()
  local nNowTime = GetTime()
  local nNowFormatTime = tonumber(os.date("%H%M", nNowTime))
  for nIndex, tbTime in pairs(self.tbDaTianDengEventTime) do
    if nNowFormatTime >= tbTime[1] and nNowFormatTime < tbTime[2] then
      return nIndex
    end
  end
  return 0
end

function ZhouNianQing2012:IsOpenXiaoTianDengEventTime()
  local nNowTime = GetTime()
  local nNowFormatTime = tonumber(os.date("%H%M", nNowTime))
  for nIndex, tbTime in pairs(self.tbXiaoTianDengEventTime) do
    if nNowFormatTime >= tbTime[1] and nNowFormatTime < tbTime[2] then
      return 1
    end
  end
  return 0
end

function ZhouNianQing2012:GetUseYanHuaCount(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_YANHUA_USE_COUNT)
end

function ZhouNianQing2012:SetUseYanHuaCount(pPlayer, nCount)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_YANHUA_USE_COUNT, nCount)
end

function ZhouNianQing2012:GetYanHuaGetTime(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_YANHUA_GET_TIME)
end

function ZhouNianQing2012:SetYanHuaGetTime(pPlayer, nTime)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_YANHUA_GET_TIME, nTime)
end

function ZhouNianQing2012:GetLastPromiseTime(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_PROMISE_TIME)
end

function ZhouNianQing2012:SetLastPromiseTime(pPlayer, nLastTime)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_PROMISE_TIME, nLastTime)
end

function ZhouNianQing2012:GetLastPromiseIndex(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_PROMISE_TYPE)
end

function ZhouNianQing2012:SetLastPromiseIndex(pPlayer, nIndex)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_PROMISE_TYPE, nIndex)
end

function ZhouNianQing2012:GetPromiseAwardIndex(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_PROMISE_AWARD)
end

function ZhouNianQing2012:SetPromiseAwardIndex(pPlayer, nIndex)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_PROMISE_AWARD, nIndex)
end

function ZhouNianQing2012:GetUseHongZhuCount(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_HONGZHU_USE_COUNT)
end

function ZhouNianQing2012:SetUseHongZhuCount(pPlayer, nCount)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_HONGZHU_USE_COUNT, nCount)
end

function ZhouNianQing2012:GetUseHongZhuTime(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_HONGZHU_USE_TIME)
end

function ZhouNianQing2012:SetUseHongZhuTime(pPlayer, nTime)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_HONGZHU_USE_TIME, nTime)
end

function ZhouNianQing2012:GetHeBiCount(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_HEBI_USE_COUNT)
end

function ZhouNianQing2012:SetHeBiCount(pPlayer, nCount)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_HEBI_USE_COUNT, nCount)
end

function ZhouNianQing2012:GetHeBiTime(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_HEBI_USE_TIME)
end

function ZhouNianQing2012:SetHeBiTime(pPlayer, nTime)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_HEBI_USE_TIME, nTime)
end

function ZhouNianQing2012:GetHongBaoTime(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID, self.TASK_ID_GET_HONGBAO)
end

function ZhouNianQing2012:SetHongBaoTime(pPlayer, nTime)
  pPlayer.SetTask(self.TASK_GROUP_ID, self.TASK_ID_GET_HONGBAO, nTime)
end

--- 字卡，用的是不同的taskid，需要注意
function ZhouNianQing2012:GetZiKaTime(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID_ZIKA, self.TASK_ID_ZIKA_DATE)
end

function ZhouNianQing2012:SetZiKaTime(pPlayer, nTime)
  pPlayer.SetTask(self.TASK_GROUP_ID_ZIKA, self.TASK_ID_ZIKA_DATE, nTime)
end

function ZhouNianQing2012:GetZiKaCount(pPlayer)
  return pPlayer.GetTask(self.TASK_GROUP_ID_ZIKA, self.TASK_ID_ZIKA_COUNT)
end

function ZhouNianQing2012:SetZiKaCount(pPlayer, nCount)
  pPlayer.SetTask(self.TASK_GROUP_ID_ZIKA, self.TASK_ID_ZIKA_COUNT, nCount)
end

function ZhouNianQing2012:IsCanJoinEvent(pPlayer)
  if pPlayer.nLevel < self.nJoinLevel then
    return 0, string.format("等级超过%s级的玩家才能参加活动！", self.nJoinLevel)
  end

  if pPlayer.nFaction <= 0 then
    return 0, "你目前尚未加入门派，武艺不精，还是等加入门派后再来把！"
  end
  return 1
end
