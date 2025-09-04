-- zhouchenfei
-- 2012/9/24 15:30:59
-- 烟花活动
Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

local tbYanHua = Item:GetClass("zhounian2012_yanhua")
tbYanHua.nFireProcessTime = 3
tbYanHua.nWaitingFireTime = 30

function tbYanHua:OnUse()
  local nFlag, szMsg = ZhouNianQing2012:IsOpenEvent()
  if 1 ~= nFlag then
    me.Msg(szMsg)
    return 0
  end

  local nUseCount = ZhouNianQing2012:GetUseYanHuaCount(me)
  if nUseCount >= ZhouNianQing2012.MAX_YANHUA_USE_COUNT then
    me.Msg("烟花使用次数已用完！")
    return 1
  end

  local nYear = it.GetGenInfo(1)
  local nTime = it.GetGenInfo(2)
  if nYear > 0 then
    local nDate = tonumber(GetLocalDate("%Y%m%d%H%M%S"))
    local nCanDate = (nYear * 1000000 + nTime)
    local nSec1 = Lib:GetDate2Time(nDate)
    local nSec2 = Lib:GetDate2Time(nCanDate) + self.nWaitingFireTime * 60
    if nSec1 < nSec2 then
      local nDetSec = nSec2 - nSec1
      local szMsg = ""
      if nDetSec >= 60 then
        nDetSec = math.floor(nDetSec / 60)
        szMsg = string.format("每点燃一次烟花后必须等待%s分钟才可以再次点燃，您还需要等待<color=yellow>%s分钟<color>后才能点燃。", self.nWaitingFireTime, nDetSec)
      else
        szMsg = string.format("每点燃一次烟花后必须等待%s分钟才可以再次点燃，您还需要等待<color=yellow>%s秒<color>后才能点燃。", self.nWaitingFireTime, nDetSec)
      end
      me.Msg(szMsg)
      return 0
    end
  end
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
  GeneralProcess:StartProcess("点烟花中...", self.nFireProcessTime * Env.GAME_FPS, { self.SuccessUse, self, it.dwId, me.nId }, nil, tbEvent)
end

function tbYanHua:SuccessUse(dwItemId, nPlayerId)
  local pItem = KItem.GetObjById(dwItemId)
  if not pItem then
    return 0
  end

  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end

  local nUseCount = ZhouNianQing2012:GetUseYanHuaCount(pPlayer)
  if nUseCount >= ZhouNianQing2012.MAX_YANHUA_USE_COUNT then
    pPlayer.Msg("烟花使用次数已用完！")
    if pPlayer.DelItem(pItem, Player.emKLOSEITEM_USE) ~= 1 then
      return
    end
    return 0
  end

  if nUseCount < 0 then
    nUseCount = 0
  end

  nUseCount = nUseCount + 1
  ZhouNianQing2012:SetUseYanHuaCount(pPlayer, nUseCount)

  local nAddResult = ZhouNianQing2012:GetRandomItem(pPlayer, nUseCount)
  local nYearDate = tonumber(GetLocalDate("%Y%m%d"))
  local nTimeDate = tonumber(GetLocalDate("%H%M%S"))
  pItem.SetGenInfo(1, nYearDate)
  pItem.SetGenInfo(2, nTimeDate)
  pItem.Sync()
  ZhouNianQing2012:FireYanHua(pPlayer)
  Dbg:WriteLog("YanHua", "SuccessUse", pPlayer.szName, nUseCount)
  if nUseCount >= ZhouNianQing2012.MAX_YANHUA_USE_COUNT then
    if pPlayer.DelItem(pItem, Player.emKLOSEITEM_USE) ~= 1 then
      return 1
    end
    pPlayer.Msg("烟花使用次数已用完！")
  end

  return 1
end

function tbYanHua:GetTip(nState)
  local nUseCount = ZhouNianQing2012:GetUseYanHuaCount(me)
  local szTip = ""
  szTip = szTip .. string.format("<color=0x8080ff>右键点击使用<color>\n")
  szTip = szTip .. string.format("<color=yellow>已使用次数: %s/%s<color>", nUseCount, ZhouNianQing2012.MAX_YANHUA_USE_COUNT)
  return szTip
end
