-- 文件名　：horse_box_base.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-02-09 15:00:19
-- 功能    ：财宝兔箱子
Require("\\script\\event\\specialevent\\zhounianqing2012\\zhounianqing2012_public.lua")

local ZhouNianQing2012 = SpecialEvent.ZhouNianQing2012
ZhouNianQing2012.MAX_BIND_VALUE = 100000
local tbItem = Item:GetClass("zhounianqing2012_hehuanbi")

function tbItem:OnUse()
  local nOpenDay = math.floor((GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) / (60 * 60 * 24))
  local tbAward = Lib._CalcAward:RandomAward(3, 4, 2, ZhouNianQing2012.MAX_BIND_VALUE, Lib:_GetXuanReduce(nOpenDay), { 8, 2, 0 })
  local nMaxMoney = ZhouNianQing2012:GetMaxMoney(tbAward)
  if nMaxMoney + me.GetBindMoney() > me.GetMaxCarryMoney() then
    Dialog:Say("对不起，您身上的绑定银两可能会超出上限，请整理后再来领取。")
    return 0
  end
  local nNeed = 1
  if me.CountFreeBagCell() < nNeed then
    Dialog:Say(string.format("请留出%s格背包空间。", nNeed))
    return 0
  end
  ZhouNianQing2012:RandomAward(me, tbAward, 1)
  return 1
end

function ZhouNianQing2012:GetMaxMoney(tbAward)
  local nMaxValue = 0
  for _, tbInfo in ipairs(tbAward) do
    if tbInfo[1] == "绑银" and nMaxValue < tbInfo[2] then
      nMaxValue = tbInfo[2]
    end
  end
  return nMaxValue
end

function ZhouNianQing2012:RandomAward(pPlayer, tbAward, nType, szLogMdl, szLogClass)
  szLogMdl = szLogMdl or "ZhouNianQing2012"
  szLogClass = szLogClass or "hehuanbi"
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
      else
        pPlayer.AddItemEx(18, 1, 1, tbFind[2])
      end
    elseif tbFind[1] == "绑金" then
      pPlayer.AddBindCoin(tbFind[2])
    elseif tbFind[1] == "绑银" then
      pPlayer.AddBindMoney(tbFind[2])
    end

    Dbg:WriteLog(szLogMdl, szLogClass, pPlayer.szName, tbFind[1], tbFind[2])
    return tbFind
  end
end
