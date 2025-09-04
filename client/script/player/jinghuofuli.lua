-- Tên tệp　：jinghuofuli.lua
-- Người tạo　：bigfly
-- Thời gian tạo：2009-7-7 17:59:54
-- Mô tả tệp：Script phúc lợi Tinh Hoạt

Require("\\script\\player\\player.lua")

local tbBuyJingHuo = Player.tbBuyJingHuo or {} -- Hỗ trợ tải lại
Player.tbBuyJingHuo = tbBuyJingHuo

tbBuyJingHuo.MAX_JINGHUOCOUNT = 10000 -- Tích lũy tối đa 10000 nhóm
tbBuyJingHuo.DAY_GIVECOUNT = 1 -- Mỗi ngày cho 1 nhóm
tbBuyJingHuo.MAX_BUY_FULIJINGHUO_COUNT = 8 -- Số lượng Tinh Hoạt phúc lợi có thể mua tích lũy tối đa

tbBuyJingHuo.tbItem = {
  [1] = {
    nWareId = 47,
    TASK_GROUPID = 2024,
    TASK_ID1 = 9,
    TASK_ID2 = 10,
    TASK_EXBUY_COUNT_ID = 23,
    nUseMax = 5,
    nCoin = 16,
    szTypeName = "Tiểu Tinh Khí Tán",
    szDesValue = "2500 Tinh Lực",
    szDes = "Tiểu Tinh Lực Tán giảm 60% (5 cái)",
  }, --Tiểu Tinh Khí Tán
  [2] = {
    nWareId = 48,
    TASK_GROUPID = 2024,
    TASK_ID1 = 11,
    TASK_ID2 = 12,
    TASK_EXBUY_COUNT_ID = 24,
    nUseMax = 5,
    nCoin = 16,
    szTypeName = "Tiểu Hoạt Khí Tán",
    szDesValue = "2500 Hoạt Lực",
    szDes = "Tiểu Hoạt Lực Tán giảm 60% (5 cái)",
  }, --Tiểu Hoạt Khí Tán
}
tbBuyJingHuo.nLevelMax = 60
tbBuyJingHuo.nTaskGroupId = 2024
tbBuyJingHuo.nTaskId_FirstOpen = 25

tbBuyJingHuo.tbWeekend = {
  [0] = 0,
  [1] = 6,
  [2] = 5,
  [3] = 4,
  [4] = 3,
  [5] = 2,
  [6] = 1,
  [7] = 0,
}

-- Tính toán trong khoảng thời gian này có bao nhiêu cuối tuần, tính cả khoảng thời gian đầu và cuối
function tbBuyJingHuo:CalcWeekend(nStartDay, nEndDay)
  local nStartTime = Lib:GetDate2Time(nStartDay)
  local nEndTime = Lib:GetDate2Time(nEndDay)

  local nLastDay = Lib:GetLocalDay(nStartTime)
  local nNowDay = Lib:GetLocalDay(nEndTime)

  local nStartWeekday = tonumber(os.date("%w", nStartTime))
  local nEndWeekday = tonumber(os.date("%w", nEndTime))

  local nDayDet = nNowDay - nLastDay

  local nWeekendCount = 0

  if nDayDet <= 0 then
    return nWeekendCount
  end

  local nDet = self.tbWeekend[nStartWeekday]

  -- Nếu trong tuần này
  if nDayDet <= nDet then
    if nEndWeekday == 0 then
      nWeekendCount = 2
    elseif nEndWeekday == 6 then
      nWeekendCount = 1
    end
  else
    nWeekendCount = math.floor((nDayDet - self.tbWeekend[nStartWeekday]) / 7) * 2
    local nMod = math.fmod((nDayDet - self.tbWeekend[nStartWeekday]), 7)
    if nMod > 0 then
      if nEndWeekday == 6 then
        nWeekendCount = nWeekendCount + 1
      end
    end
    if nStartWeekday <= 6 and nStartWeekday > 0 then
      nWeekendCount = nWeekendCount + 2
    elseif nStartWeekday == 0 then
      nWeekendCount = nWeekendCount + 1
    end
  end

  return nWeekendCount
end

function tbBuyJingHuo:BuyItem(nType, nBuyCount, nFlag)
  local nPrestigeKe = KGblTask.SCGetDbTaskInt(DBTASK_JINGHUOFULI_KE)
  local nPrestige = self:GetTodayPrestige()
  if nPrestigeKe > 0 then
    nPrestige = nPrestigeKe
  end
  if nPrestige <= 0 then
    Dialog:Say("Vẫn chưa có bảng xếp hạng uy danh toàn khu, không thể biết yêu cầu uy danh để nhận ưu đãi hôm nay, vui lòng đợi sau khi có xếp hạng rồi hãy đến tìm ta")
    return 0
  end

  if me.IsInPrison() == 1 then
    Dialog:Say("Không thể nhận phúc lợi trong Thiên Lao.")
    return 0
  end

  if me.nLevel < self.nLevelMax then
    Dialog:Say("Cấp độ của bạn cần đạt 60 mới có thể nhận phúc lợi.")
    return 0
  end

  --	--Xếp hạng phán đoán
  --	if me.nPrestige < nPrestige then
  --		Dialog:Say("Uy danh giang hồ của bạn không đủ<color=red>"..nPrestige.." điểm<color>, không thể mua ưu đãi"..tbItem.szTypeName);
  --		return 0;
  --	end

  local tbItem = self.tbItem[nType]
  if me.nPrestige >= nPrestige then
    self:UpdateFuliCount(me, nType)
  end

  local nOrgCount = self:GetOrgJingHuoCount(me, nType)
  local nExCount = self:GetExJingHuoBuyCount(me, nType)
  local nNum = nBuyCount * tbItem.nUseMax

  if nBuyCount <= 0 then
    Dialog:Say(string.format("Bạn không có số lượng cần mua. [Kiếm Hiệp Thế Giới] <color=red>Phúc lợi Tinh Hoạt giảm 60%<color> mang đến cho bạn cuộc sống game với lợi ích cao."))
    return 0
  end

  local nCheckFlag = self:CheckBuyState(me, nType)
  if 2 == nCheckFlag then
    local szMsg = string.format("Cơ hội mua phúc lợi Tinh Hoạt giảm 60% của bạn hôm nay vẫn chưa được sử dụng, tăng thêm %s điểm uy danh giang hồ là có thể kích hoạt. [Kiếm Hiệp Thế Giới] phúc lợi Tinh Hoạt giảm 60% mang đến cho bạn cuộc sống game với lợi ích cao.\nBạn có thể nhanh chóng tăng uy danh giang hồ bằng cách “Nạp thẻ nhận uy danh giang hồ hàng tuần” (mức 15 tệ: 10 điểm/tuần, mức 50 tệ: 30 điểm/tuần) hoặc “Sử dụng Lệnh Bài Uy Danh Giang Hồ” (20 điểm):", nPrestige - me.nPrestige)
    local tbOpt = {
      { "Mở [Kỳ Trân Các] mua <color=yellow>Lệnh Bài Uy Danh Giang Hồ<color>", self.OpenQiZhenge, self },
      { "Để ta suy nghĩ" },
    }

    if SpecialEvent.ChongZhiRepute:CheckISCanGetRepute() == 0 then
      if SpecialEvent.ChongZhiRepute:CheckIsSetExt() ~= 1 then
        table.insert(tbOpt, 1, { "Kích hoạt nhân vật nhận uy danh giang hồ", SpecialEvent.ChongZhiRepute.OnJiHuoGetRepute, SpecialEvent.ChongZhiRepute })
      end
    else
      if me.nLevel >= 60 then
        local nResultRepute, nSumRepute = SpecialEvent.ChongZhiRepute:Check2()
        if nResultRepute < 0 then
          table.insert(tbOpt, 1, { "Nạp thẻ để nhận tư cách nhận phúc lợi Tinh Hoạt hàng tuần", self.OpenChongZhi, self })
        elseif nResultRepute == 0 then
          if me.GetExtMonthPay() < IVER_g_nPayLevel2 then
            table.insert(tbOpt, 1, { "Nạp thẻ để nhận tư cách nhận phúc lợi Tinh Hoạt hàng tuần", self.OpenChongZhi, self })
          end
        elseif nResultRepute > 0 then
          if me.GetExtMonthPay() < IVER_g_nPayLevel2 then
            table.insert(tbOpt, 1, { "Nạp thẻ để nhận tư cách nhận phúc lợi Tinh Hoạt hàng tuần", self.OpenChongZhi, self })
          end
          table.insert(tbOpt, 1, { "Nhận uy danh giang hồ nạp thẻ tuần này", SpecialEvent.ChongZhiRepute.OnDialog, SpecialEvent.ChongZhiRepute })
        end
      end
    end
    Dialog:Say(szMsg, tbOpt)
    return 0
  elseif 0 == nCheckFlag then
    Dialog:Say(string.format("Hôm nay bạn đã hết cơ hội mua phúc lợi Tinh Hoạt. [Kiếm Hiệp Thế Giới] <color=red>Phúc lợi Tinh Hoạt giảm 60%<color> mang đến cho bạn cuộc sống game với lợi ích cao."))
    return 0
  end

  if nOrgCount + nExCount <= 0 then
    Dialog:Say(string.format("Hôm nay bạn đã hết cơ hội mua phúc lợi Tinh Hoạt. [Kiếm Hiệp Thế Giới] <color=red>Phúc lợi Tinh Hoạt giảm 60%<color> mang đến cho bạn cuộc sống game với lợi ích cao."))
    return 0
  end

  if nBuyCount > nOrgCount + nExCount then
    Dialog:Say(string.format("Số lượng bạn muốn mua vượt quá số lượng cho phép. [Kiếm Hiệp Thế Giới] <color=red>Phúc lợi Tinh Hoạt giảm 60%<color> mang đến cho bạn cuộc sống game với lợi ích cao."))
    return 0
  end

  if not nFlag then
    Dialog:Say(string.format("Bạn có chắc chắn muốn mua <color=yellow>%s<color> cái <color=yellow>%s<color> không?", nNum, tbItem.szTypeName), { { "Ta chắc chắn mua", self.BuyItem, self, nType, nBuyCount, 1 }, { "Để ta suy nghĩ thêm" } })
    return 0
  end

  if IVER_g_nSdoVersion == 0 and me.GetJbCoin() < (tbItem.nCoin * nNum) then
    Dialog:Say(string.format("Đồng của bạn không đủ, mua <color=yellow>%s<color> cái %s cần <color=red>%s<color> Đồng.", nNum, tbItem.szTypeName, tbItem.nCoin * nNum))
    return 0
  end

  if me.CountFreeBagCell() < nNum then
    Dialog:Say(string.format("Túi đồ của bạn không đủ chỗ, cần %s ô trống.", nNum))
    return 0
  end
  me.ApplyAutoBuyAndUse(tbItem.nWareId, nBuyCount)
  if IVER_g_nSdoVersion == 0 then
    Dialog:Say(string.format("Bạn đã mua thành công %s cái %s", nNum, tbItem.szTypeName))
  end
  local szLog = string.format("Đã mua thành công %s cái %s", nNum, tbItem.szTypeName)

  --Thống kê số lần người chơi mua phúc lợi Tinh Hoạt (mua Tinh Lực và Hoạt Lực trong cùng một ngày chỉ tính là 1)
  Stats.Activity:AddCount(me, Stats.TASK_COUNT_FULIJINGHUO, nBuyCount, 1)

  -- Cập nhật thời gian nhận phúc lợi
  Stats:UpdateGetFuliTime()
  Dbg:WriteLog("Player.tbBuyJingHuo", "Mua Tinh Hoạt ưu đãi", me.szAccount, me.szName, szLog)
  return 1
end

function tbBuyJingHuo:OpenChongZhi()
  c2s:ApplyOpenOnlinePay()
end

function tbBuyJingHuo:OpenQiZhenge()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_IBSHOP" })
end

function tbBuyJingHuo:GetTodayPrestige()
  local nPrestige = KGblTask.SCGetDbTaskInt(DBTASD_EVENT_PRESIGE_RESULT)
  return nPrestige
end

function tbBuyJingHuo:OnLogin(bExchangeServer)
  if bExchangeServer == 1 then
    return
  end
  self:OpenBuJingHuo(me)
end

function tbBuyJingHuo:OpenBuJingHuo(pPlayer, nOpenType)
  local nPrestigeKe = KGblTask.SCGetDbTaskInt(DBTASK_JINGHUOFULI_KE)
  local nPrestige = self:GetTodayPrestige()
  if nPrestigeKe > 0 then
    nPrestige = nPrestigeKe
  end
  if nPrestige <= 0 then
    return 0, "Vẫn chưa có bảng xếp hạng uy danh toàn khu, không thể biết yêu cầu uy danh để nhận ưu đãi hôm nay, vui lòng đợi sau khi có xếp hạng rồi hãy đến tìm ta"
  end

  if pPlayer.nLevel < self.nLevelMax then
    return 0, "Cấp độ của bạn cần đạt 60 mới có thể nhận phúc lợi."
  end

  if pPlayer.nPrestige >= nPrestige then
    for i, tbItem in pairs(self.tbItem) do
      self:UpdateFuliCount(pPlayer, i)
    end
  end
  if nOpenType == 3 then -- Giao diện phúc lợi đặc quyền cập nhật số lần Tinh Hoạt
    return 0
  end
  local nOpenWindow = 0
  for i, tbItem in pairs(self.tbItem) do
    local nFlag = self:CheckBuyState(pPlayer, i)
    if nFlag == 1 then
      nOpenWindow = 1
      break
    end

    if nFlag == 2 then
      nOpenWindow = 2
    end
  end

  if not nOpenType or nOpenType ~= 1 then
    if pPlayer.GetTask(self.nTaskGroupId, self.nTaskId_FirstOpen) <= 0 then
      pPlayer.SetTask(self.nTaskGroupId, self.nTaskId_FirstOpen, 1)
      nOpenWindow = 1
    end
  end

  if nOpenWindow == 1 then
    KPlayer.CallAllClientScript({ "GblTask:s2c_SetTask", DBTASD_EVENT_PRESIGE_RESULT, nPrestige })
    KPlayer.CallAllClientScript({ "GblTask:s2c_SetTask", DBTASK_JINGHUOFULI_KE, nPrestigeKe })
    pPlayer.CallClientScript({ "UiManager:OpenWindow", "UI_JINGHUOFULI" })
    return 1
  elseif nOpenWindow == 2 then
    return 2
  end

  return 0, "Hôm nay bạn đã hết cơ hội mua phúc lợi Tinh Hoạt. [Kiếm Hiệp Thế Giới] <color=red>Phúc lợi Tinh Hoạt giảm 60%<color> mang đến cho bạn cuộc sống game với lợi ích cao."
end

function tbBuyJingHuo:CheckBuyState(pPlayer, nJinghuoType)
  local nFlag = 0
  local nRefresh = 0
  local tbItem = self.tbItem[nJinghuoType]

  local nOrgCount = self:GetOrgJingHuoCount(pPlayer, nJinghuoType)
  local nExCount = self:GetExJingHuoBuyCount(pPlayer, nJinghuoType)
  if nOrgCount + nExCount > 0 then
    nFlag = 1
  end

  local nLastDay = pPlayer.GetTask(tbItem.TASK_GROUPID, tbItem.TASK_ID1)
  local nNowDay = tonumber(GetLocalDate("%Y%m%d"))
  if nLastDay >= nNowDay then
    nRefresh = 1
  end

  -- Mở thông qua Lễ Quan và Tu Luyện Châu
  if nFlag == 0 then
    if nRefresh == 1 then
      return 0
    else
      return 2
    end
  end
  return 1
end

function tbBuyJingHuo:UpdateFuliCount(pPlayer, nType)
  local tbItem = self.tbItem[nType]
  local nDay = pPlayer.GetTask(tbItem.TASK_GROUPID, tbItem.TASK_ID1)
  local nNowDay = tonumber(GetLocalDate("%Y%m%d"))
  if nNowDay > nDay then
    pPlayer.SetTask(tbItem.TASK_GROUPID, tbItem.TASK_ID1, nNowDay)
    pPlayer.SetTask(tbItem.TASK_GROUPID, tbItem.TASK_ID2, 0)
  end
end

function tbBuyJingHuo:GetPillInfo()
  local tbPillInfo = {}
  for nType, tbItem in ipairs(self.tbItem) do
    local nOrgCount = self:GetOrgJingHuoCount(me, nType)
    local nExCount = self:GetExJingHuoBuyCount(me, nType)
    tbPillInfo[nType] = {
      tbItem.szDes,
      tbItem.nCoin * tbItem.nUseMax,
      tbItem.szDesValue,
      nOrgCount + nExCount,
    }
  end
  return tbPillInfo
end

function tbBuyJingHuo:OnDailyEvent_UpdateJingHuoUseCount(nDay)
  me.SetTask(self.nTaskGroupId, self.nTaskId_FirstOpen, 0)
  local nPrestigeKe = KGblTask.SCGetDbTaskInt(DBTASK_JINGHUOFULI_KE)
  local nPrestige = self:GetTodayPrestige()
  if nPrestigeKe > 0 then
    nPrestige = nPrestigeKe
  end
  if nPrestige <= 0 then
    return 0
  end

  if me.nPrestige < nPrestige then
    return 0
  end

  if me.nLevel < self.nLevelMax then
    return 0
  end

  local nNowDay = tonumber(GetLocalDate("%Y%m%d"))
  for i, tbItem in pairs(self.tbItem) do
    local nAddCount = nDay - 1
    if nAddCount < 0 then
      nAddCount = 0
    end

    -- Tính số lần chưa sử dụng của ngày hôm qua
    local nTotalCount = me.GetTask(tbItem.TASK_GROUPID, tbItem.TASK_ID2)
    local nLastDay = me.GetTask(tbItem.TASK_GROUPID, tbItem.TASK_ID1)

    local nStartTime = Lib:GetDate2Time(nLastDay)
    local nEndTime = Lib:GetDate2Time(nNowDay)
    local nStartWeekday = tonumber(os.date("%w", nStartTime))
    local nEndWeekday = tonumber(os.date("%w", nEndTime))

    if nLastDay > 0 then
      local nWeekendCount = self:CalcWeekend(nLastDay, nNowDay)

      if nStartWeekday == 6 or nStartWeekday == 0 then
        nWeekendCount = nWeekendCount - 1
      end
      if nEndWeekday == 6 or nEndWeekday == 0 then
        nWeekendCount = nWeekendCount - 1
      end
      if nWeekendCount < 0 then
        nWeekendCount = 0
      end

      -- Nếu chưa mua, và là ngày hôm qua thì cộng số lần của ngày hôm qua vào số lần bổ sung
      if nLastDay < nNowDay then
        local nCount = math.floor(nTotalCount / 5)
        local nResult = 0

        if nStartWeekday == 0 or nStartWeekday == 6 then
          nResult = 2 - nCount
        else
          nResult = 1 - nCount
        end

        if nResult < 0 then
          nResult = 0
        end
        nAddCount = nAddCount + nResult
      end

      -- Đây là nhân đôi cuối tuần
      if nWeekendCount > 0 then
        nAddCount = nAddCount + nWeekendCount
      end
    end

    local nLastCount = self:GetExJingHuoBuyCount(me, i)
    if nLastCount + nAddCount > self.MAX_BUY_FULIJINGHUO_COUNT then
      nAddCount = self.MAX_BUY_FULIJINGHUO_COUNT - nLastCount
      if nAddCount < 0 then
        nAddCount = 0
      end
    end

    if nAddCount > 0 then
      self:AddExJingHuoBuyCount(me, i, nAddCount)
      self:AddExUseCount(i, nAddCount * tbItem.nUseMax)
    end
    self:UpdateFuliCount(me, i) -- Tính phúc lợi Tinh Hoạt trong ngày khi qua ngày mới
  end
end

-- Tăng số lần sử dụng Tinh Hoạt
function tbBuyJingHuo:AddExUseCount(nType, nCount)
  if 1 == nType then
    Item:GetClass("jingqisan"):AddExUseCount(nCount)
  elseif 2 == nType then
    Item:GetClass("huoqisan"):AddExUseCount(nCount)
  end
end

function tbBuyJingHuo:AddOrgJingHuoBuyCount(pPlayer, nType)
  local nCount = pPlayer.GetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_ID2)
  pPlayer.SetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_ID2, nCount + 5)
end

-- Dấu hiệu ghi lại người chơi mua phúc lợi Tinh Hoạt ban đầu là
function tbBuyJingHuo:GetOrgJingHuoCount(pPlayer, nType)
  -- Tính số lần chưa sử dụng của ngày hôm qua
  local nTotalCount = pPlayer.GetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_ID2)
  local nLastDay = pPlayer.GetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_ID1)
  local nNowDay = tonumber(GetLocalDate("%Y%m%d"))
  local nLastTime = Lib:GetDate2Time(nLastDay)
  local nLastWeek = tonumber(os.date("%w", nLastTime))

  local nCount = math.floor(nTotalCount / 5)
  local nResult = 0

  if nLastDay ~= nNowDay then
    return 0
  end

  if nLastWeek == 0 or nLastWeek == 6 then
    nResult = 2 - nCount
  else
    nResult = 1 - nCount
  end

  if nResult < 0 then
    nResult = 0
  end

  return nResult
end

function tbBuyJingHuo:AddExJingHuoBuyCount(pPlayer, nType, nCount)
  local nOrgCount = pPlayer.GetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_EXBUY_COUNT_ID)
  pPlayer.SetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_EXBUY_COUNT_ID, nOrgCount + nCount)
end

function tbBuyJingHuo:DelExJingHuoBuyCount(pPlayer, nType, nCount)
  local nOrgCount = pPlayer.GetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_EXBUY_COUNT_ID)
  local nDelCount = nOrgCount - nCount
  if nDelCount < 0 then
    nDelCount = 0
  end
  pPlayer.SetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_EXBUY_COUNT_ID, nDelCount)
end

function tbBuyJingHuo:GetExJingHuoBuyCount(pPlayer, nType)
  return pPlayer.GetTask(self.tbItem[nType].TASK_GROUPID, self.tbItem[nType].TASK_EXBUY_COUNT_ID)
end

if MODULE_GAMESERVER then
  PlayerSchemeEvent:RegisterGlobalDailyEvent({ Player.tbBuyJingHuo.OnDailyEvent_UpdateJingHuoUseCount, Player.tbBuyJingHuo })
end
