-- 文件名　：activegift.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-11-01 09:09:03
-- 功能    ：

local uiOnLineBankPay = Ui:GetClass("onlinebankpay")

uiOnLineBankPay.TXT_PAYMONEY = "TxtPayMoney"
uiOnLineBankPay.PRG_PAYMONEY = "PrgPayMoney"
uiOnLineBankPay.BTN_PAYAWARD = "BtnPayAward"
uiOnLineBankPay.TXT_PAYAWARD = "TxtPayAward"
uiOnLineBankPay.IMG_PAYMONEY = "BtnPayImg"
uiOnLineBankPay.BTN_CLOSE = "BtnClose"
uiOnLineBankPay.BTN_GETPOINT = "BtnGetPoint"
uiOnLineBankPay.TXT_CONSUMEPOINT = "TxtConsumePoint"

uiOnLineBankPay.COUNT_BTN_AWARD = 3
----------------------------------------------------------------
-- 窗口消息处理
function uiOnLineBankPay:OnOpen(nPayMoney, nPoint, tbAwardInfo)
  self.OnOpenFlag = 1
  self:UpdatePanel(nPayMoney, nPoint, tbAwardInfo)
end

function uiOnLineBankPay:OnClose()
  UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
  self.OnOpenFlag = nil
end

function uiOnLineBankPay:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_GETPOINT then
    me.CallServerScript({ "ApplyGetConsumePoint" })
  else
    for i = 1, self.COUNT_BTN_AWARD do
      if szWnd == self.BTN_PAYAWARD .. i then --领取累计天数奖励
        self:GetAward(i)
      end
    end
  end
end

function uiOnLineBankPay:OnMouseEnter(szWnd)
  for i = 1, self.COUNT_BTN_AWARD do
    local szTempBtn = self.BTN_PAYAWARD .. i
    if szTempBtn == szWnd then
      local tbAward = {}
      local tbOneAwardInfo = self.tbAwardInfo[i]
      if tbOneAwardInfo then
        tbAward = tbOneAwardInfo.tbAward
        local _, _, nX, nY = Wnd_GetPos(self.UIGROUP, szWnd)
        UiManager:OpenWindow(Ui.UI_ACTIVEGETAWAED, tbAward)
        UiManager:MoveWindow(Ui.UI_ACTIVEGETAWAED, nX + 25, nY + 25)
      end
    end
  end
end

function uiOnLineBankPay:OnMouseLeave(szWnd)
  if "Main" == szWnd then
    Timer:Register(2, self.OnTimerClose, self)
  end
end

----------------------------------------------------------------
-- 自身逻辑消息处理

function uiOnLineBankPay:UpdatePanel(nPayMoney, nPoint, tbAwardInfo)
  if not self.OnOpenFlag then
    return 0
  end
  self.nPayMoney = nPayMoney or 0
  self.nPoint = (nPoint or 0) * 30
  self.tbAwardInfo = tbAwardInfo or {}
  self:UpdateItemAwardPage()
  self:UpdateConsumePointPage()
end

function uiOnLineBankPay:UpdateItemAwardPage()
  Txt_SetTxt(self.UIGROUP, self.TXT_PAYMONEY, string.format("%s元<color=203,203,203>（1元=额外30点奇珍阁消耗积分）<color>", self.nPayMoney))
  self:UpdatePayProgress()
  self:UpdateItemAwardBtn()
end

function uiOnLineBankPay:UpdatePayProgress()
  Prg_SetPos(self.UIGROUP, self.PRG_PAYMONEY, math.floor(self.nPayMoney / 1000 * 1000))
end

function uiOnLineBankPay:UpdateItemAwardBtn()
  for i = 1, self.COUNT_BTN_AWARD do
    local BntActive = self.BTN_PAYAWARD .. i
    local TxtActive = self.TXT_PAYAWARD .. i
    local ImgBntActive = self.IMG_PAYMONEY .. i
    --设置按钮tip
    --		Wnd_SetTip(self.UIGROUP, BntActive, szActiveInfo);
    --设置按钮状态
    local bActive = 0
    local bCanGActive = 0
    local szName = ""
    local tbOneAwardInfo = self.tbAwardInfo[i]
    if tbOneAwardInfo then
      bActive = tbOneAwardInfo.nGetState
      szName = tbOneAwardInfo.szName
    end

    if bActive == 2 then
      Txt_SetTxt(self.UIGROUP, TxtActive, szName .. "<color=green>已领取<color>")
    elseif bActive == 1 then
      Txt_SetTxt(self.UIGROUP, TxtActive, szName .. "<color=0xffDFCBB7>可领取<color>")
    else
      Txt_SetTxt(self.UIGROUP, TxtActive, szName .. "<color=red>未达到<color>")
    end
  end
end

function uiOnLineBankPay:UpdateConsumePointPage()
  if self.nPoint > 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETPOINT, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETPOINT, 0)
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_CONSUMEPOINT, "" .. self.nPoint)
end

function uiOnLineBankPay:GetAward(nId)
  local tbOneAwardInfo = self.tbAwardInfo[nId]
  if not tbOneAwardInfo then
    return 0
  end

  local bActive = tbOneAwardInfo.nGetState
  local tbAward = {}
  local nFlag = 1

  if not bActive or bActive ~= 1 then
    UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
    return
  end

  me.CallServerScript({ "ApplyGetOnlineBankPayAward", nId })
  UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
end

function uiOnLineBankPay:OnTimerClose()
  if Ui(Ui.UI_ACTIVEGETAWAED).bEnterFlag ~= 1 then
    UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
  end
  return 0
end
