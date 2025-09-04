------------------------------------------------------
-- 文件名　：xmas2012_item.lua
-- 创建者　：dengyong
-- 创建时间：2012-12-10 22:01:09
-- 描  述  ：
------------------------------------------------------
local tbItem = Item:GetClass("xmas2012_race_item")

tbItem.tbAwardValue = {
  [1877] = 255000,
  [1878] = 345000,
}
tbItem.tbExtAwardItem = { 18, 1, 1880, 1 }
tbItem.nCount = 2

function tbItem:OnUse()
  local nAwardValue = self.tbAwardValue[it.nParticular]
  if not nAwardValue then
    return 0
  end

  local nOpenDay = math.floor((GetTime() - KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)) / (60 * 60 * 24))
  local tbAward = Lib._CalcAward:RandomAward(3, 4, 2, nAwardValue, Lib:_GetXuanReduce(nOpenDay), { 8, 2, 0 })
  local nMaxMoney = SpecialEvent.ZhouNianQing2012:GetMaxMoney(tbAward)
  if nMaxMoney + me.GetBindMoney() > me.GetMaxCarryMoney() then
    Dialog:Say("对不起，您身上的绑定银两可能会超出上限，请整理后再来领取。")
    return 0
  end
  if me.CountFreeBagCell() < self.nCount + 1 then
    Dialog:Say(string.format("请留出%d格背包空间。", self.nCount + 1))
    return 0
  end
  local tbAward = SpecialEvent.ZhouNianQing2012:RandomAward(me, tbAward, 1, "Xmas2012_Race", "AwardBox")
  local szLog = "GetNoAward"
  if tbAward then
    if tbAward[1] == "玄晶" then
      szLog = string.format("18_1_114_%d,1", tbAward[2])
    elseif tbAward[1] == "绑金" then
      szLog = string.format("Bindcoin,%d", tbAward[2])
    elseif tbAward[1] == "绑银" then
      szLog = string.format("Bindmoney,%d", tbAward[2])
    end
  end
  StatLog:WriteStatLog("stat_info", "shengdanjie_2012", "sled_award", me.nId, szLog)

  --	local tbTime = os.date("*t", GetTime());
  --	local nY, nM, nD = Lib:AddDay(tbTime.year, tbTime.month, tbTime.day, 1);
  --	local szTime = string.format("%4d/%02d/%02d/00/00/00", nY, nM, nD);
  local nPassTime = Lib:GetLocalDayTime(GetTime())
  local nLeftTime = 24 * 3600 - nPassTime
  for i = 1, self.nCount do
    local pItem = me.AddItemEx(self.tbExtAwardItem[1], self.tbExtAwardItem[2], self.tbExtAwardItem[3], self.tbExtAwardItem[4], { bTimeOut = 1 }, nil, GetTime() + nLeftTime)
    --me.SetItemTimeout(pItem, szTime, 1);
    --pItem.Sync();
  end

  return 1
end
