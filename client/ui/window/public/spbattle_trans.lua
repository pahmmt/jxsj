-------------------------------------------------------
-- 文件名　：spbattle_trans.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-02 14:59:16
-- 文件描述：
-------------------------------------------------------

local uiSpbattleTrans = Ui:GetClass("spbattle_trans")

uiSpbattleTrans.BTN_TRANS = "BtnTrans"
uiSpbattleTrans.BTN_CLOSE = "BtnClose"
uiSpbattleTrans.TXT_TIME = "TxtTime"

function uiSpbattleTrans:OnOpen()
  self:Update()
end

function uiSpbattleTrans:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_TRANS then
    me.CallServerScript({ "ApplySuperBattleTrans" })
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiSpbattleTrans:OnRecvData(nTime)
  self.nTime = nTime
  self:Update()
end

function uiSpbattleTrans:Update()
  Txt_SetTxt(self.UIGROUP, self.TXT_TIME, string.format("剩余进入战场时间：<color=cyan>%s秒<color>", self.nTime or 0))
end
