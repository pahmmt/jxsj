-- 文件名　：zhounianqing2012_item.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-09-26 09:26:34
-- 描述：

SpecialEvent.tbZhouNianQing2012 = SpecialEvent.tbZhouNianQing2012 or {}
local tbZhouNianQing2012 = SpecialEvent.tbZhouNianQing2012

-----------------------------------------------------------------------------------
--邀请礼包
-----------------------------------------------------------------------------------
local tbItem = Item:GetClass("zhounianqing2012_inivitebox")
tbItem.nMaxOtherRate = 100000
tbItem.nGetAwardMinRate = 200

function tbItem:OnUse()
  local nValue = tbZhouNianQing2012.tbValue[it.nLevel] or tbZhouNianQing2012.tbValue[1]
  local nOpenDay = math.floor((GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) / (60 * 60 * 24))
  local tbAward = Lib._CalcAward:RandomAward(3, 3, 2, nValue, Lib:_GetXuanReduce(nOpenDay), { 8, 2, 0 })
  local nMaxMoney = Kinsalary:GetMaxMoney(tbAward)
  if nMaxMoney + me.GetBindMoney() > me.GetMaxCarryMoney() then
    Dialog:Say("您身上的绑定银两可能会超出上限，请整理后再来领取。")
    return 0
  end
  local nNeed = 1
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end

  if it.nLevel >= 3 then
    local nRate = MathRandom(self.nMaxOtherRate)
    if nRate <= self.nGetAwardMinRate and not IpStatistics:IsStudioRole(me) then
      local nGetAwardInfo = KGblTask.SCGetDbTaskInt(DBTASK_INIVITE_OTHERAWARD)
      local nDate = math.floor(nGetAwardInfo / 100)
      local nCount = math.fmod(nGetAwardInfo, 100)
      local nNowDate = tonumber(GetLocalDate("%y%m%d"))
      if nNowDate ~= nDate then
        nCount = 0
      end
      if nCount < tbZhouNianQing2012.nMaxCount then
        me.AddWaitGetItemNum(1)
        GCExcute({ "SpecialEvent.tbZhouNianQing2012:CanGetHonor", me.nId, it.dwId })
      else
        return tbZhouNianQing2012:RandomAward(me, tbAward, it.nLevel)
      end
    else
      return tbZhouNianQing2012:RandomAward(me, tbAward, it.nLevel)
    end
  else
    return tbZhouNianQing2012:RandomAward(me, tbAward, it.nLevel)
  end
  return 0
end

-----------------------------------------------------------------------------------
--字卡
-----------------------------------------------------------------------------------
local tbCard = Item:GetClass("zhounianqing2012_card")
function tbCard:OnUse()
  if tonumber(GetLocalDate("%Y%m%d")) <= tbZhouNianQing2012.nEndTime then
    return 0
  end
  if 100 + me.GetBindMoney() > me.GetMaxCarryMoney() then
    Dialog:Say("您身上的绑定银两可能会超出上限，请整理后再来领取。")
    return 0
  end
  me.AddBindMoney(100)
  return 1
end
