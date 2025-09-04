--=================================================
-- 文件名　：finishachieve.lua
-- 创建者　：furuilei
-- 创建时间：2010-07-20 15:40:36
-- 功能描述：成就达成界面
--=================================================

local uiFinishAchieve = Ui:GetClass("finishachieve")
local tbTimer = Ui.tbLogic.tbTimer

uiFinishAchieve.IMG_CUP = "Img_Cup"
uiFinishAchieve.EFFECT_FINISH = "Effect_Finish"
uiFinishAchieve.TXT_NAME = "Txt_Name"
uiFinishAchieve.BTN_CLOSE = "Btn_Close"

uiFinishAchieve.PATH_EFFECT = "\\image\\effect\\other\\achi_finished.spr"

function uiFinishAchieve:OnOpen(nAchievementId)
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  local szMsg = self:GetInfo(nAchievementId)
  if not szMsg then
    return
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_NAME, szMsg)
  Img_PlayAnimation(self.UIGROUP, self.EFFECT_FINISH, 0, Env.GAME_FPS * 3, 1 - 1)

  self.nTimerId = tbTimer:Register(Env.GAME_FPS * 10, self.ReachTimeClose, self)
end

function uiFinishAchieve:ReachTimeClose()
  UiManager:CloseWindow(self.UIGROUP)
  return 0
end

function uiFinishAchieve:OnClose()
  if self.nTimerId and self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
end

function uiFinishAchieve:OnAnimationOver(szWnd)
  if not szWnd then
    return
  end
  Img_SetImage(self.UIGROUP, self.EFFECT_FINISH, 1, self.PATH_EFFECT)
  Img_SetFrame(self.UIGROUP, self.EFFECT_FINISH, 40)
end

function uiFinishAchieve:OnButtonClick(szWnd)
  if not szWnd then
    return
  end

  if szWnd == self.IMG_CUP then
    self:OpenAchievementWnd()
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiFinishAchieve:OpenAchievementWnd()
  if not self.tbAchievementInfo or Lib:CountTB(self.tbAchievementInfo) <= 0 then
    return
  end

  local tbInfo = self.tbAchievementInfo
  local nGroupId = tbInfo.nGroupId or 1
  local nSubGroupId = tbInfo.nSubGroupId or 1
  local nIndex = tbInfo.nIndex or 1
  UiManager:OpenWindow(Ui.UI_ACHIEVEMENT, 1, nGroupId, nSubGroupId, nIndex)
end

function uiFinishAchieve:GetInfo(nAchievementId)
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  local nGroupId, nSubGroupId, nIndex = Achievement:GetIndexInfoById(nAchievementId)
  local tbAchievementInfo = Achievement:GetAchievementInfo(nGroupId, nSubGroupId, nIndex)
  if not tbAchievementInfo then
    return
  end
  self.tbAchievementInfo = tbAchievementInfo

  local szName = tbAchievementInfo.szAchivementName or ""
  local nPoint = tbAchievementInfo.nPoint or 0
  local nLevel = tbAchievementInfo.nLevel or 0

  local szMsg = ""
  szMsg = string.format("<color=yellow>%s<color>\n点数：<color=yellow>%s<color>\n等级：", szName, nPoint)
  for i = 1, nLevel do
    szMsg = szMsg .. "<color=yellow>★<color>"
  end
  return szMsg
end

function uiFinishAchieve:OnMouseEnter(szWnd)
  if not szWnd then
    return
  end

  if self.IMG_CUP == szWnd or self.EFFECT_FINISH == szWnd or self.TXT_NAME == szWnd or self.BTN_CLOSE == szWnd then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", "点击左侧奖杯图标打开成就界面")
  end
end
