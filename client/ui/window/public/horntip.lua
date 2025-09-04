-- 文件名　：horntip.lua
-- 创建者　：zounan
-- 创建时间：2010-03-17 14:50:26
-- 描  述  ：喇叭提示
local uiHornTip = Ui:GetClass("horntip")
local tbCalendar = Ui.tbLogic.tbCalendar
uiHornTip.TXT_MSG = "TxtMsg"
uiHornTip.BTN_HORN = "BtnHornTip"
uiHornTip.BTN_CLOSE = "BtnClose"
uiHornTip.ANIMATION_INTERVAL = 18 * 20 --喇叭动画
uiHornTip.tbNotifyMatch = {}

function uiHornTip:OnOpen(tbNotifyMatch, szName)
  local nCount = 0
  for nIndex, tbInfo in pairs(tbNotifyMatch) do
    if tbInfo.nIsNotify == 1 and tbInfo.nIsShow == 0 then
      nCount = nCount + 1
    end
  end

  if nCount == 1 then
    self:SetTxtEx(self.TXT_MSG, string.format("%s活动即将开启", szName))
  else
    self:SetTxtEx(self.TXT_MSG, string.format("%d个定制活动将开启", nCount))
  end
  self.tbNotifyMatch = tbNotifyMatch
  Img_PlayAnimation(self.UIGROUP, self.BTN_HORN, 1, self.ANIMATION_INTERVAL) -- 喇叭动画
end

function uiHornTip:CreateNotifyMatchTable()
  local tbNewMatch = {}
  for nIndex, tbInfo in pairs(self.tbNotifyMatch) do
    if tbInfo.nIsNotify == 1 and tbInfo.nIsShow == 0 then
      table.insert(tbNewMatch, { nMatchIndex = nIndex, nTimeIndex = tbInfo.nTimeIndex })
    end
  end

  return tbNewMatch
end

function uiHornTip:SetMatchShow()
  for nIndex, tbInfo in pairs(self.tbNotifyMatch) do
    if tbInfo.nIsNotify == 1 and tbInfo.nIsShow == 0 then
      tbInfo.nIsShow = 1
    end
  end
end

function uiHornTip:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_HORN then
    local tbNewMatch = self:CreateNotifyMatchTable()
    if #tbNewMatch == 0 then
      UiManager:CloseWindow(self.UIGROUP)
      return
    end
    self:SetMatchShow()
    UiManager:OpenWindow(Ui.UI_MATCHTIP, "OpenWithMatch", tbNewMatch)
  elseif szWnd == self.BTN_CLOSE then
    self:SetMatchShow()
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiHornTip:SetTxtEx(szWnd, szText)
  Ui.tbLogic.tbTimer:Register(1, self.OnTimer_SetText, self, szWnd, szText)
end

--延迟处理
function uiHornTip:OnTimer_SetText(szWnd, szText)
  if szText and string.len(szText) > 0 then
    TxtEx_SetText(self.UIGROUP, szWnd, szText)
  end
  return 0
end
