-------------------------------------------------------
-- 文件名　：spbattle_signup.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-12-02 14:59:16
-- 文件描述：
-------------------------------------------------------

local uiSpbattleSignup = Ui:GetClass("spbattle_signup")

uiSpbattleSignup.TXT_JOIN = "TxtVar1"
uiSpbattleSignup.TXT_QUEUE = "TxtVar2"
uiSpbattleSignup.TXT_STATE = "TxtVar3"
uiSpbattleSignup.BTN_JOIN = "BtnJoin"
uiSpbattleSignup.BTN_CANCEL = "BtnCancel"
uiSpbattleSignup.BTN_CLOSE = "BtnClose"
uiSpbattleSignup.BTN_TRANS = "BtnTrans"
uiSpbattleSignup.BTN_GLOBAL_AREA = "btn_global_area"
function uiSpbattleSignup:OnOpen()
  self:Update()
end

function uiSpbattleSignup:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_JOIN then
    me.CallServerScript({ "ApplySuperBattleJoin" })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_CANCEL then
    me.CallServerScript({ "ApplySuperBattleCancel" })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_TRANS then
    me.CallServerScript({ "ApplySuperBattleTrans" })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_GLOBAL_AREA then
    UiManager:OpenWindow(Ui.UI_GLOBAL_AREA)
  end
end

function uiSpbattleSignup:OnRecvData(nOpen, nAttend, nQueue, nState)
  self.nOpen = nOpen
  self.nAttend = nAttend
  self.nQueue = nQueue
  self.nState = nState
  self:Update()
end

function uiSpbattleSignup:Update()
  Txt_SetTxt(self.UIGROUP, self.TXT_JOIN, string.format("<color=yellow>%s / 2<color>", self.nAttend or 0))
  Txt_SetTxt(self.UIGROUP, self.TXT_QUEUE, string.format("<color=yellow>%s / 160<color>", self.nQueue or 0))

  local szState = (self.nState == 1) and "已在等待队列中..." or "尚未加入队列"
  Txt_SetTxt(self.UIGROUP, self.TXT_STATE, string.format("<color=yellow>%s<color>", szState))

  if self.nOpen ~= 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_JOIN, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CANCEL, 0)
  elseif self.nState == 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_JOIN, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CANCEL, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_JOIN, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CANCEL, 0)
  end
end
