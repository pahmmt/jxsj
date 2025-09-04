--
-- FileName: payerfuli.lua
-- Author: hanruofei
-- Time: 2011/4/11 17:14
-- Comment: 充值优惠福利界面
--

local tbPayerFuli = Ui:GetClass("payerfuli")

tbPayerFuli.BTN_FULITEQUAN = "BtnFulitequan"

-- 按钮名称与特权功能类型对应关系
function tbPayerFuli:InitPrivateData()
  self.tbTequans = {
    ["getcai"] = { "BtnGetCai", 0, { 0 } },
    ["getchuansongfu"] = { "BtnGetChuansongfu", 0, { nMonthPay = EventManager.IVER_nPlayerFuli_Chuansong } },
    ["getqiankunfu"] = { "BtnGetQiankunfu", 0, { nMonthPay = EventManager.IVER_nPlayerFuli_Qiankunfu } },
    ["openhexuan"] = { "BtnOpenHexuan", 0, { 0 } },
    ["opencangku"] = { "BtnOpenCangku", 0, { 0 } },
    ["openauction"] = { "BtnOpenPaimai", 0, { 0 } },
    ["opentaskexp"] = { "BtnOpenTaskplatform", 0, { 0 } },
    ["payerlottery"] = { "BtnPayerLottery", 0, { nMonthConsumed = EventManager.IVER_nPlayerFuli_Lottery } }, -- 单位金币
  }

  self.tbButtonToType = {}
  for k, v in pairs(self.tbTequans) do
    self.tbButtonToType[v[1]] = k
  end
  self.nPayedMoney = 0
end

function tbPayerFuli:OnOpen()
  self:DoUpdate()
  me.CallServerScript({ "GetTequanValue" })
end

function tbPayerFuli:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_FULITEQUAN then
    if UiManager:WindowVisible(Ui.UI_FULITEQUAN) == 1 then
      UiManager:CloseWindow(Ui.UI_FULITEQUAN)
    else
      me.CallServerScript({ "PlayerCmd", "OpenFuliTequan", 1 })
    end
  else
    local szType = self.tbButtonToType[szWnd]
    if not szType then
      return
    end

    local tbTequanItem = self.tbTequans[szType]
    if not tbTequanItem then
      return
    end

    if tbTequanItem[2] == 0 and szType ~= "payerlottery" then
      return
    end

    me.CallServerScript({ "Tequan", szType })
  end
end

--
function tbPayerFuli:OnMouseEnter(szWnd)
  local szType = self.tbButtonToType[szWnd]
  if not szType then
    return
  end

  local tbTequanItem = self.tbTequans[szType]
  if not tbTequanItem then
    return
  end

  if tbTequanItem[2] == 1 then
    Img_SetFrame(self.UIGROUP, szWnd, 1)
  end

  if szWnd == "BtnGetChuansongfu" then
    local bIsFuFudaiVip = false
    local bIsChuanSong = false
    if self.nPayedMoney >= IVER_g_nPayLevel1 then
      bIsFuFudaiVip = true
    end

    if self.nPayedMoney >= EventManager.IVER_nPlayerFuli_Chuansong then
      bIsChuanSong = true
    end

    local szTip = ""
    local nCurDate = tonumber(GetLocalDate("%y%m%d"))
    if math.floor(me.GetTask(2038, 7) / 100) >= math.floor(nCurDate / 100) then
      szTip = string.format("使用无限传送符<enter><color=gold>本月充值%s元及以上玩家特权<color><enter><color=green>特权激活后至本月月底每日均可享受<color>", EventManager.IVER_nPlayerFuli_Chuansong)
    else
      if bIsChuanSong then
        szTip = string.format("领取一个无限传送符（30天）<enter><color=gold>本月充值%s元及以上玩家特权<color>", EventManager.IVER_nPlayerFuli_Chuansong)
      else
        szTip = string.format("领取一个无限传送符（30天）<enter><color=gray>本月充值%s元及以上玩家特权<color>", EventManager.IVER_nPlayerFuli_Chuansong)
      end
    end
    Wnd_SetTip(self.UIGROUP, szWnd, szTip)
  elseif szWnd == "BtnGetCai" then
    local bIsFuFudaiVip = false
    if self.nPayedMoney >= IVER_g_nPayLevel1 then
      bIsFuFudaiVip = true
    end
    local nUsedCount = 0
    local nDate = tonumber(GetLocalDate("%y%m%d"))
    if me.GetTask(2013, 2) == nDate then
      nUsedCount = me.GetTask(2013, 1)
    end
    local nDay = me.GetTask(2038, 10)
    local nTimes = me.GetTask(2038, 11)
    if Lib:GetLocalDay() > nDay then
      nTimes = 0
    end
    local szTip = string.format("每日领取5个练级菜。\n<color=gold>本月充值15元及以上玩家特权。\n<color><color=green>今日已领取：%s/5<color><enter>", nTimes)
    if bIsFuFudaiVip then
      szTip = string.format("%s<color=gold>已开启福袋次数：%s/20<color>", szTip, nUsedCount)
    else
      szTip = string.format("%s<color=gray>已开启福袋次数：%s/10<color>", szTip, nUsedCount)
    end
    Wnd_SetTip(self.UIGROUP, szWnd, szTip)
  elseif szWnd == "BtnGetQiankunfu" then
    local szTip = "领取一个乾坤符（10次，队友传送）<enter><color=gray>本月充值50元及以上玩家特权<color>"
    if self.nPayedMoney >= IVER_g_nPayLevel1 then
      szTip = "领取一个乾坤符（10次，队友传送）<enter><color=gold>本月充值50元及以上玩家特权<color>"
    end
    Wnd_SetTip(self.UIGROUP, szWnd, szTip)
  end
end

function tbPayerFuli:OnMouseLeave(szWnd)
  local szType = self.tbButtonToType[szWnd]
  if not szType then
    return
  end

  local tbTequanItem = self.tbTequans[szType]
  if not tbTequanItem then
    return
  end

  if tbTequanItem[2] == 1 then
    Img_SetFrame(self.UIGROUP, szWnd, 0)
  end
end

function tbPayerFuli:UpdateButtonState(szButtonName, bEnable)
  if not szButtonName or not self.tbButtonToType[szButtonName] then
    return
  end

  if bEnable == 1 then
    Img_SetFrame(self.UIGROUP, szButtonName, 0)
  elseif bEnable == 0 then
    Img_SetFrame(self.UIGROUP, szButtonName, 3)
  end
end

function tbPayerFuli:DoUpdate()
  for _, v in pairs(self.tbTequans) do
    self:UpdateButtonState(v[1], v[2])
  end
end

-- 根据月充值(单位元)和月消耗(单位金币)来更新界面
function tbPayerFuli:Update(nMonthPay, nMonthConsumed)
  self.nPayedMoney = nMonthPay

  if type(nMonthPay) ~= "number" or type(nMonthConsumed) ~= "number" then
    return
  end
  local tbTemp = {}
  for k, v in pairs(self.tbTequans) do
    local bEnable = 0
    local nMonthPayCondition = v[3].nMonthPay
    local nMonthConsumedCondition = v[3].nMonthConsumed
    if (not nMonthPayCondition or nMonthPay >= nMonthPayCondition) and (not nMonthConsumedCondition or nMonthConsumed >= nMonthConsumedCondition) then
      bEnable = 1
    end
    tbTemp[k] = bEnable
  end

  for k, v in pairs(tbTemp) do
    self.tbTequans[k][2] = v
  end

  self:DoUpdate()
end

tbPayerFuli:InitPrivateData()
