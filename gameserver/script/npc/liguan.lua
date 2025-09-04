local tbLiGuan = Npc:GetClass("liguan")

function tbLiGuan:OnDialog()
  local szMsg = "Xin chào, có gì ta có thể giúp ngươi không?"
  local tbOpt = {
    { "<color=yellow>Đổi Bồ Đề Quả và Quảng Hàn Nguyệt Quế Hoa<color>", self.ChangePutiGuoAndYueguihua, self },
    { "Nhận Phúc Lợi", self.FuLi, self },
    { "Đoán Hoa Đăng", GuessGame.OnDialog, GuessGame },
    { "Kết thúc đối thoại" },
  }

  --	if Baibaoxiang:CheckChangeBack() == 1 then
  --		table.insert(tbOpt, 3, {"<color=yellow>Ta đến để đổi vỏ sò<color>", self.ChangeBack, self});
  --	end
  --
  --	if Baibaoxiang:CheckState() == 1 then
  --		table.insert(tbOpt, 3, {"<color=yellow>Rương Báu Vật<color>", self.Baibaoxiang, self});
  --	end

  if VipPlayer:CheckPlayerIsVip(me.szAccount, me.szName) == 1 then
    table.insert(tbOpt, 3, { "Ưu đãi người chơi VIP", VipPlayer.OnDialog, VipPlayer, me })
  end

  --if SpecialEvent.VipReturn_6M:Check() == 1 then
  --	table.insert(tbOpt, 1, {"<color=yellow>Ưu đãi người chơi VIP 2010<color>", SpecialEvent.VipReturn_6M.OnDialog, SpecialEvent.VipReturn_6M});
  --end

  if Wldh.Qualification:CheckChangeBack() == 1 then
    table.insert(tbOpt, 3, { "<color=yellow>Thu hồi Anh Hùng Thiếp<color>", Wldh.Qualification.ChangeBackDialog, Wldh.Qualification })
  end

  if me.nLevel >= 50 then
    table.insert(tbOpt, 2, { "Ta muốn cầu phúc", self.QiFu, self })
  end
  if SpecialEvent.CompensateGM:CheckOnNpc() > 0 then
    table.insert(tbOpt, 2, { "<color=yellow>Nhận đền bù hoặc phần thưởng<color>", SpecialEvent.CompensateGM.OnAwardNpc, SpecialEvent.CompensateGM })
  end

  if Esport:CheckState() == 1 then
    szMsg = "Năm mới đã đến, lão phu đi khắp nơi chúc Tết, ngươi và ta có duyên nếu gặp nhau ở đâu đó, nhất định sẽ tặng ngươi quà làm kỷ niệm."
    local tbNewYearNpc = Npc:GetClass("esport_yanruoxue")
    table.insert(tbOpt, 2, { "Tìm hiểu hoạt động Lễ Quan chúc Tết, pháo hoa đầy trời", tbNewYearNpc.OnAboutYanHua, tbNewYearNpc })
    table.insert(tbOpt, 2, { "Tìm hiểu hoạt động năm mới", tbNewYearNpc.OnAboutNewYears, tbNewYearNpc })
  end

  if SpecialEvent.YuanXiao2009:CheckState() == 1 then
    table.insert(tbOpt, 2, { "Hoạt động ưu đãi người chơi mừng Tết Nguyên Tiêu", SpecialEvent.YuanXiao2009.OnDialog, SpecialEvent.YuanXiao2009 })
  end

  if EventManager.ExEvent.tbPlayerCallBack:IsOpen(me, 4) == 1 then
    table.insert(tbOpt, 2, { "Hoạt động triệu hồi người chơi cũ", EventManager.ExEvent.tbPlayerCallBack.OnDialog, EventManager.ExEvent.tbPlayerCallBack })
  end

  if SpecialEvent.ChangeLive:CheckState() == 1 then
    table.insert(tbOpt, 1, { "Liên quan đến chuyển từ Kiếm Võng sang Kiếm Thế", SpecialEvent.ChangeLive.OnDialog, SpecialEvent.ChangeLive })
  end

  if VipPlayer.VipReborn:CheckQualification(me) > 0 then
    table.insert(tbOpt, 1, { "<color=yellow>Liên quan đến chuyển server Vip<color>", VipPlayer.VipReborn.Npc.OnDialog, VipPlayer.VipReborn.Npc })
  end

  if Player.tbOffline:CheckExGive() == 1 then
    table.insert(tbOpt, 1, { "Đền bù thời gian ủy thác offline khi gộp server", Player.tbOffline.GiveExOfflineTime, Player.tbOffline })
  end

  if SpecialEvent.CompensateCozone:CheckFudaiCompenstateState(me) == 1 then
    table.insert(tbOpt, 1, { "Đền bù gộp server_Đền bù túi phúc", SpecialEvent.CompensateCozone.OnFudaiDialog, SpecialEvent.CompensateCozone })
  end
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  local nNowTime = tonumber(GetLocalDate("%H%M"))
  local nServerStarTime = tonumber(os.date("%Y%m%d", tonumber(KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME))))
  if nNowDate >= 20110913 and nNowDate <= 20111013 and nServerStarTime >= 20110910 then
    table.insert(tbOpt, 1, { "<color=yellow>Kiếm hiệp cũ chinh chiến vùng đất mới<color>", SpecialEvent.tbNewGateEvent.OnDialog, SpecialEvent.tbNewGateEvent })
    table.insert(tbOpt, 1, { "<color=yellow>Tựu trường có quà<color>", SpecialEvent.tbNewGateEvent.OnDialogStude, SpecialEvent.tbNewGateEvent })
  end
  if ((nNowDate > SpecialEvent.tbNewGateEvent.nStartTime and nNowDate <= SpecialEvent.tbNewGateEvent.nEndTime1) or (nNowDate == SpecialEvent.tbNewGateEvent.nStartTime and nNowTime >= SpecialEvent.tbNewGateEvent.nEndTime2)) and nServerStarTime >= SpecialEvent.tbNewGateEvent.nServerStarLimit then
    table.insert(tbOpt, 1, { "<color=yellow>Top 100 Gia Tộc Uy Vọng<color>", SpecialEvent.tbNewGateEvent.OnDialogKin, SpecialEvent.tbNewGateEvent })
  end
  if nNowDate >= SpecialEvent.tbNewGateEvent.nSeniorStartTime and nNowDate <= SpecialEvent.tbNewGateEvent.nSeniorEndTime and nServerStarTime >= SpecialEvent.tbNewGateEvent.nServerStarLimit then
    table.insert(tbOpt, 1, { "<color=yellow>Sư huynh sư tỷ dẫn ngươi xông pha giang hồ<color>", SpecialEvent.tbNewGateEvent.OnDialogSenior, SpecialEvent.tbNewGateEvent })
  end
  if nNowDate >= SpecialEvent.tbNewGateEvent.nFriendBackStarTime and nNowDate <= SpecialEvent.tbNewGateEvent.nFriendBackEndTime and nServerStarTime >= SpecialEvent.tbNewGateEvent.nServerStarLimit then
    table.insert(tbOpt, 1, { "<color=yellow>Quan hệ mật hữu ngươi và ta<color>", SpecialEvent.tbNewGateEvent.OnDialogNewBack, SpecialEvent.tbNewGateEvent })
  end
  if TimeFrame:GetState("OpenLevel150") >= 1 then
    table.insert(tbOpt, 1, { "<color=yellow>Đổi Lôi Đình Ấn<color>", self.ChangeSignt, self })
  end
  --Gói quà thăng cấp
  local nKinId, nExcutorId = me.GetKinMember()
  local cKin = nil
  if nKinId > 0 then
    cKin = KKin.GetKin(nKinId)
  end
  --Gia tộc Kim Bài, hiển thị trong thời gian nhận
  if cKin and cKin.GetGoldLogo() > 0 and nNowDate >= SpecialEvent.tbGoldBar.tbGetAwardTime[1] and nNowDate <= SpecialEvent.tbGoldBar.tbGetAwardTime[2] and tonumber(os.date("%Y%m%d%H", cKin.GetCreateTime())) < SpecialEvent.tbGoldBar.nCreatTimeLimit then
    table.insert(tbOpt, 1, { "<color=yellow>Nhận thưởng đền bù Gia tộc Kim Bài<color>", SpecialEvent.tbGoldBar.OnDailog_Back, SpecialEvent.tbGoldBar })
  end

  if SpecialEvent.tbOnlineBankPay.nIsOpen == 1 then
    table.insert(tbOpt, 1, {
      "<color=yellow>Đặc quyền nạp thẻ qua ngân hàng trực tuyến<color>",
      SpecialEvent.tbOnlineBankPay.ApplyOpenOnlineBankWindow,
      SpecialEvent.tbOnlineBankPay,
    })
  end

  local nGetFlag = self:__IsCanGetPlayerLevelGift(me)
  if nGetFlag == 1 then
    table.insert(tbOpt, 1, { "<color=yellow>Nhận lại Rương Trưởng Thành Tân Thủ<color>", self.__GetPlayerLevelGift, self })
  end

  Dialog:Say(szMsg, tbOpt)
end

tbLiGuan.nTaskGroupId = 2093
tbLiGuan.nTaskId = 78

function tbLiGuan:__IsCanGetPlayerLevelGift(pPlayer)
  local tbResult = pPlayer.FindItemInAllPosition(18, 1, 1509, 1)
  if #tbResult > 0 then
    return 0, "Ngươi đã có Rương Trưởng Thành Tân Thủ rồi, không cần nhận lại!"
  end

  local nIsGetAll = SpecialEvent.PlayerLevelUpGift:IsGetAllAward(pPlayer)
  if nIsGetAll == 1 then
    return 0, "Ngươi đã nhận hết quà trong Rương Trưởng Thành rồi!"
  end
  return 1
end

function tbLiGuan:__GetPlayerLevelGift(nFlag)
  local nFlag, szError = self:__IsCanGetPlayerLevelGift(me)
  if 1 ~= nFlag then
    Dialog:Say(szError)
    return 0
  end

  if me.CountFreeBagCell() < 1 then
    Dialog:Say("Túi đồ của ngươi không đủ chỗ, vui lòng chừa 1 ô trống rồi thử lại.")
    return 0
  end

  if not nFlag or nFlag ~= 1 then
    Dialog:Say("<color=yellow>[Tân Kiếm Thế] sẽ ra mắt bùng nổ vào ngày 12 tháng 9, nội dung hoàn toàn mới sẽ càn quét như vũ bão.<color><enter>Rương Tân Thủ đã thêm các mốc cấp 95/100, và một số mốc nạp thẻ. Khi đó, hiệp khách nào chưa có Rương Tân Thủ có thể nhận một Rương Tân Thủ tại đây, <color=green>có thể nhận phần thưởng trong các “mốc phần thưởng chưa nhận” trước đó<color>, sau khi đã nhận phần thưởng của một mốc nào đó sẽ không thể nhận lại.<enter><enter><color=red>Thời gian nhận kết thúc vào 24:00 ngày 20 tháng 9 năm 2012<color>", {
      { "Xác nhận nhận", self.__GetPlayerLevelGift, self, 1 },
      { "Để ta suy nghĩ lại" },
    })
    return 0
  end

  me.SetTask(self.nTaskGroupId, self.nTaskId, GetTime())

  local pItem = me.AddItem(18, 1, 1509, 1)
  if not pItem then
    Dbg:WriteLog("liguan", "__GetPlayerLevelGift", me.szName, "Nhận rương thất bại")
    return 0
  end
  Dbg:WriteLog("liguan", "__GetPlayerLevelGift", me.szName, "Nhận rương thành công")
  pItem.Bind(1)
  local nGetIndex = SpecialEvent.PlayerLevelUpGift:GetCurrFreeAwardIndex(me)
  if not nGetIndex then
    nGetIndex = SpecialEvent.PlayerLevelUpGift:GetMaxAwardIndex()
  end

  local nNowLevel = SpecialEvent.PlayerLevelUpGift:GetFreeAwardInfo(nGetIndex)
  if nNowLevel then
    pItem.SetGenInfo(1, nNowLevel)
  end
  pItem.Sync()
end

function tbLiGuan:QiFu()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_PLAYERPRAY" })
end

-- by zhangjinpin@kingsoft
function tbLiGuan:Baibaoxiang()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_BAIBAOXIANG" })
end

function tbLiGuan:ChangeBack()
  local tbOpt = {
    { "Vỏ Sò Vàng đổi Hồn Thạch Tinh Hoạt", self.DoChangeBack, self, 1 },
    { "Vỏ Sò Huyền Bí đổi Hồn Thạch Hoạt Lực", self.DoChangeBack, self, 2 },
    { "Rương Vỏ Sò Huyền Bí đổi Hồn Thạch Hoạt Lực", self.DoChangeBack, self, 3 },
    { "Kết thúc đối thoại" },
  }
  Dialog:Say("Tại đây có thể đổi Vỏ Sò Vàng/Vỏ Sò Huyền Bí/Rương Vỏ Sò Huyền Bí thành nguyên liệu", tbOpt)
end

function tbLiGuan:DoChangeBack(nType)
  local szMsg

  if nType == 1 then
    szMsg = "Ta muốn đổi Vỏ Sò Vàng: <color=yellow>1 Vỏ Sò Vàng có thể đổi thành 2 Hồn Thạch, 225 Tinh Lực, 200 Hoạt Lực<color>"
  elseif nType == 2 then
    szMsg = "Ta muốn đổi Vỏ Sò Huyền Bí: <color=yellow>1 Vỏ Sò Huyền Bí có thể đổi thành 1 Hồn Thạch, 100 Hoạt Lực<color>"
  elseif nType == 3 then
    szMsg = "Ta muốn đổi Rương Vỏ Sò Huyền Bí: <color=yellow>1 Rương Vỏ Sò Huyền Bí có thể đổi thành 200 Hồn Thạch, 20000 Hoạt Lực<color>"
  end

  Dialog:OpenGift(szMsg, nil, { Baibaoxiang.OnChangeBack, Baibaoxiang, nType })
end

function tbLiGuan:FuLi()
  --	local tbOpt =
  --	{
  --		{"Mua Phúc Lợi Tinh Hoạt", SpecialEvent.BuyJingHuo.OnDialog, SpecialEvent.BuyJingHuo},
  --		{"Bạc khóa đổi Bạc", SpecialEvent.CoinExchange.OnDialog, SpecialEvent.CoinExchange},
  --		{"Nhận lương", SpecialEvent.Salary.GetSalary, SpecialEvent.Salary},
  --	}
  --	if EventManager.IVER_bOpenChongZhiHuoDong  == 1 then
  --		table.insert(tbOpt, 3, {"Nhận Uy Danh Giang Hồ",SpecialEvent.ChongZhiRepute.OnDialog,SpecialEvent.ChongZhiRepute});
  --	end
  --	if SpecialEvent.NewPlayerGift:ShowOption()==1 then
  --		table.insert(tbOpt, {"Nhận Gói Quà Tân Thủ", SpecialEvent.NewPlayerGift.OnDialog, SpecialEvent.NewPlayerGift});
  --	end
  --
  --	table.insert(tbOpt, {"Kết thúc đối thoại"});
  --	Dialog:Say("Vui lòng chọn phúc lợi:", tbOpt);
  me.CallClientScript({ "UiManager:OpenWindow", "UI_FULITEQUAN" })
end

function tbLiGuan:ChangeSignt()
  Dialog:OpenGift("Vui lòng đặt vào <color=yellow>10 Mảnh Lôi Đình Ấn<color>, ta sẽ đổi cho ngươi một <color=yellow>Lôi Đình Ấn<color> hoàn chỉnh.", nil, { self.OnOpenGiftOk, self })
end

function tbLiGuan:OnOpenGiftOk(tbItemObj)
  local nCount = 0
  for _, pItem in pairs(tbItemObj) do
    local szItem = string.format("%s,%s,%s,%s", pItem[1].nGenre, pItem[1].nDetail, pItem[1].nParticular, pItem[1].nLevel)
    if "18,1,741,1" ~= szItem then
      Dialog:Say("Vật phẩm ngươi đặt vào không đúng, vui lòng đặt vào Mảnh Lôi Đình Ấn.")
      return 0
    end
    nCount = nCount + pItem[1].nCount
  end
  if nCount ~= 10 then
    Dialog:Say("Số lượng vật phẩm ngươi đặt vào không đúng, vui lòng đặt vào 10 Mảnh Lôi Đình Ấn.")
    return 0
  end
  -- Trừ vật phẩm
  for _, pItem in pairs(tbItemObj) do
    if me.DelItem(pItem[1]) ~= 1 then
      return 0
    end
  end
  me.AddItem(1, 16, 14, 2)
  Dbg:WriteLog("Người chơi[" .. me.szName .. "] đã đổi Lôi Đình Ấn.")
  return 1
end

function tbLiGuan:ChangePutiGuoAndYueguihua()
  local szMsg = "Đổi Quảng Hàn Nguyệt Quế Hoa và Bồ Đề Quả"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "1 Bồ Đề Quả đổi 5 Tinh Phách Đặc Biệt", self.ChangePutiguo, self }
  tbOpt[#tbOpt + 1] = { "1 Quảng Hàn Nguyệt Quế Hoa đổi 1 Rương Huyền Tinh", self.ChangeGuanghan, self }
  tbOpt[#tbOpt + 1] = { "Để ta suy nghĩ lại" }
  Dialog:Say(szMsg, tbOpt)
end

function tbLiGuan:ChangePutiguo()
  Dialog:OpenGift("Vui lòng đặt vào <color=yellow>1 Bồ Đề Quả_Tặng<color>, ta sẽ đổi cho ngươi 5 Tinh Phách Đặc Biệt.", nil, { self.OnOpenPutiguoGiftOk, self })
end

function tbLiGuan:OnOpenPutiguoGiftOk(tbItemObj)
  local nCount = 0
  for _, pItem in pairs(tbItemObj) do
    local szItem = string.format("%s,%s,%s,%s", pItem[1].nGenre, pItem[1].nDetail, pItem[1].nParticular, pItem[1].nLevel)
    if "18,1,564,2" ~= szItem then
      Dialog:Say("Vật phẩm ngươi đặt vào không đúng, vui lòng đặt vào Bồ Đề Quả_Tặng.")
      return 0
    end
    nCount = nCount + pItem[1].nCount
  end

  local nNeedBag = KItem.GetNeedFreeBag(18, 1, 544, 6, nil, nCount * 5)
  if me.CountFreeBagCell() < nNeedBag then
    local szAnnouce = "Túi đồ của ngươi không đủ chỗ, vui lòng chừa " .. nNeedBag .. " ô trống rồi thử lại."
    me.Msg(szAnnouce)
    return 0
  end

  -- Trừ vật phẩm
  for _, pItem in pairs(tbItemObj) do
    if me.DelItem(pItem[1]) ~= 1 then
      return 0
    end
  end
  local nAddCount = me.AddStackItem(18, 1, 544, 6, { bForceBind = 1 }, nCount * 5)
  if nAddCount ~= nCount * 5 then
    Dbg:WriteLog("OnOpenPutiguoGiftOk", "AddItem Failed", me.szName, nAddCount, nCount)
  end

  Dbg:WriteLog("OnOpenPutiguoGiftOk", "AddItem success", me.szName, nAddCount)
  return 1
end

function tbLiGuan:ChangeGuanghan()
  Dialog:OpenGift("Vui lòng đặt vào <color=yellow>1 Quảng Hàn Nguyệt Quế Hoa<color>, ta sẽ đổi cho ngươi 1 Rương Huyền Tinh.", nil, { self.OnOpenGuanghanGiftOk, self })
end

function tbLiGuan:OnOpenGuanghanGiftOk(tbItemObj)
  local nCount = 0
  for _, pItem in pairs(tbItemObj) do
    local szItem = string.format("%s,%s,%s,%s", pItem[1].nGenre, pItem[1].nDetail, pItem[1].nParticular, pItem[1].nLevel)
    if "18,1,462,1" ~= szItem then
      Dialog:Say("Vật phẩm ngươi đặt vào không đúng, vui lòng đặt vào Quảng Hàn Nguyệt Quế Hoa.")
      return 0
    end
    nCount = nCount + pItem[1].nCount
  end

  if me.CountFreeBagCell() < nCount then
    local szAnnouce = "Túi đồ của ngươi không đủ chỗ, vui lòng chừa " .. nCount .. " ô trống rồi thử lại."
    me.Msg(szAnnouce)
    return 0
  end

  -- Trừ vật phẩm
  for _, pItem in pairs(tbItemObj) do
    if me.DelItem(pItem[1]) ~= 1 then
      return 0
    end
  end

  local nAddCount = 0
  for i = 1, nCount do
    local pItem = me.AddItem(18, 1, 355, 1)
    if pItem then
      pItem.Bind(1)
      me.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/%S", GetTime() + 43200 * 60))
      pItem.Sync()
      nAddCount = nAddCount + 1
    else
      Dbg:WriteLog("OnOpenGuanghanGiftOk", "AddItem failed", me.szName)
    end
  end

  Dbg:WriteLog("OnOpenGuanghanGiftOk", "AddItem success", me.szName, nAddCount)
  return 1
end
