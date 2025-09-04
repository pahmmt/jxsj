-- zhouchenfei
-- 2012/9/24 15:07:30
-- 大天灯脚本

Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local tbXiaoTianDeng = Npc:GetClass("zhounian2012_xiaotiandeng")
local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012

tbXiaoTianDeng.nFireProcessTime = 2
tbXiaoTianDeng.nRandomItemId = 369
tbXiaoTianDeng.nMaxHeBiRate = 10
tbXiaoTianDeng.nHongZhuDetTime = 30

function tbXiaoTianDeng:OnDialog()
  local nFlag, szError, bIsMsg = self:IsCanFireXiaoTianDeng(me)
  if 1 ~= nFlag then
    if bIsMsg then
      me.Msg(szError)
      return 0
    end
    Dialog:Say(szError)
    return 0
  end

  local nIsHaveBi = ZhouNianQing2012:IsHaveDoubleBi(me)
  if ZhouNianQing2012:IsCanHaveBi(me) == 0 then
    nIsHaveBi = 1
  end

  local nNeedFreeBag = 2
  if 0 == nIsHaveBi then
    nNeedFreeBag = nNeedFreeBag + 1
  end

  if me.CountFreeBagCell() < nNeedFreeBag then
    Dialog:Say(string.format("你的背包不足%s格，请清理后再来！", nNeedFreeBag))
    return 0
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
  GeneralProcess:StartProcess("点灯中...", self.nFireProcessTime * Env.GAME_FPS, { self.SuccessFire, self, him.dwId, me.nId }, nil, tbEvent)
end

function tbXiaoTianDeng:IsCanFireXiaoTianDeng(pPlayer)
  local nFlag, szError = ZhouNianQing2012:IsOpenEvent()
  if 1 ~= nFlag then
    return 0, szError
  end

  local nOpenFlag = ZhouNianQing2012:IsOpenXiaoTianDengEventTime()
  if 0 == nOpenFlag then
    return 0, "活动未开启无法点灯，请稍等！"
  end

  local nFlag, szError = ZhouNianQing2012:IsCanJoinEvent(pPlayer)
  if 1 ~= nFlag then
    return nFlag, szError
  end

  local nUseCount = ZhouNianQing2012:GetUseHongZhuCount(pPlayer)
  if nUseCount >= ZhouNianQing2012.MAX_HONGZHU_USE_COUNT then
    return 0, string.format("你已经点燃了%s次小天灯，这个时间段不能再点了！", ZhouNianQing2012.MAX_HONGZHU_USE_COUNT)
  end

  local tbResult = pPlayer.FindItemInBags(unpack(ZhouNianQing2012.tbItem_HongZhu))
  if #tbResult <= 0 then
    return 0, "您身上没有红喜蜡烛，无法点小天灯，请先到大天灯处许愿！"
  end

  local nHongZhuTime = ZhouNianQing2012:GetUseHongZhuTime(pPlayer)
  local nNowTime = GetTime()
  if (nNowTime - nHongZhuTime) <= self.nHongZhuDetTime then
    return 0, string.format("每点燃一次小天灯后必须等待%s秒才可以再次点燃，您还需要等待<color=yellow>%s秒<color>后才能点燃。", self.nHongZhuDetTime, (self.nHongZhuDetTime - (nNowTime - nHongZhuTime))), 1
  end
  return 1
end

function tbXiaoTianDeng:SuccessFire(nNpcId, nPlayerId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end

  local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
  if not pPlayer then
    return 0
  end

  local nFlag, szError = self:IsCanFireXiaoTianDeng(pPlayer)
  if 1 ~= nFlag then
    pPlayer.Msg(szError)
    return 0
  end

  local nIsHaveBi = ZhouNianQing2012:IsHaveDoubleBi(pPlayer)
  if ZhouNianQing2012:IsCanHaveBi(pPlayer) == 0 then
    nIsHaveBi = 1
  end
  local nNeedFreeBag = 2
  if 0 == nIsHaveBi then
    nNeedFreeBag = nNeedFreeBag + 1
  end

  if pPlayer.CountFreeBagCell() < nNeedFreeBag then
    pPlayer.Msg(string.format("你的背包不足%s格，请清理后再来！", nNeedFreeBag))
    return 0
  end

  local nNowTime = GetTime()
  local nUseCount = ZhouNianQing2012:GetUseHongZhuCount(pPlayer)
  ZhouNianQing2012:SetUseHongZhuCount(pPlayer, nUseCount + 1)
  local pAwardItem = pPlayer.AddItem(unpack(ZhouNianQing2012.tbItem_XiaoTianDengLiBao))
  if pAwardItem then
    pPlayer.SetItemTimeout(pAwardItem, os.date("%Y/%m/%d/00/00/00", nNowTime + ZhouNianQing2012.nTime_XiaoTianDengLiBao)) -- 领取当天有效
    pAwardItem.Bind(1)
    pAwardItem.Sync()
  end
  if 0 == nIsHaveBi then
    local nRate = MathRandom(self.nMaxHeBiRate)
    local nAwardIndex = 2
    if nRate <= math.floor(self.nMaxHeBiRate / 2) then
      nAwardIndex = 1
    end
    local tbItem = ZhouNianQing2012.tbDoubleBi[nAwardIndex]
    local pItem = pPlayer.AddItem(unpack(tbItem))
    if pItem then
      pPlayer.SetItemTimeout(pItem, os.date("%Y/%m/%d/00/00/00", nNowTime + 3600 * 24)) -- 领取当天有效
      pItem.Bind(1)
      pItem.Sync()
    end
  end

  ZhouNianQing2012:AddZiKa_XiaoTianDeng(pPlayer)
  if nUseCount + 1 >= ZhouNianQing2012.MAX_HONGZHU_USE_COUNT then
    local tbResult = pPlayer.FindItemInBags(unpack(ZhouNianQing2012.tbItem_HongZhu))
    if #tbResult > 0 then
      for _, tbInfo in pairs(tbResult) do
        if tbInfo.pItem then
          if pPlayer.DelItem(tbInfo.pItem, Player.emKLOSEITEM_USE) ~= 1 then
            Dbg:WriteLog("ZhouNianQing2012", "zhounian2012_xiaotiandeng", pPlayer.szName, "delete failed")
          end
          pPlayer.Msg("红喜蜡烛使用次数已用完！")
        end
      end
    end
  end
  ZhouNianQing2012:SetUseHongZhuTime(pPlayer, nNowTime)
  local _, x, y = pPlayer.GetWorldPos()
  local nTempId = pNpc.nTemplateId
  local nSkillId = ZhouNianQing2012.tbXiaoTianDengNpcId[nTempId]
  if nSkillId then
    pPlayer.CastSkill(nSkillId, 1, x * 32, y * 32, 1)
  end
  pNpc.Delete()
  Dbg:WriteLog("ZhouNianQing2012", "SuccessFire", pPlayer.szName)
  local tbLi = ZhouNianQing2012.tbItem_XiaoTianDengLiBao
  StatLog:WriteStatLog("stat_info", "sizhounian_2012", "xiaotiandeng", pPlayer.nId, string.format("%s_%s_%s_%s,%s", tbLi[1], tbLi[2], tbLi[3], tbLi[4], 1))
end
