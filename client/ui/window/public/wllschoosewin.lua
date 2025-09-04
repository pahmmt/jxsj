local uiWllsChooseWin = Ui:GetClass("wllschoosewin")

uiWllsChooseWin.BTN_ACCEPT = "BtnAccept"
uiWllsChooseWin.BTN_CANCEL = "BtnCancel"
uiWllsChooseWin.BTN_CHOOSE = "BtnChoose"
uiWllsChooseWin.nMaxNum_Choose = 3
uiWllsChooseWin.TXT_PLAYERINFO = "TxtVsPlayerInfo"
uiWllsChooseWin.nMaxNum_PlayerInfo = 3

function uiWllsChooseWin:OnOpen(tbPlayerList)
  self.tbPlayerRound = {}
  --	Lib:ShowTB(tbPlayerList);
  if tbPlayerList then
    for i, tbInfo in ipairs(tbPlayerList) do
      local szPlayerName = ""
      for _, szName in pairs(tbInfo.tbPlayer) do
        szPlayerName = szPlayerName .. " " .. szName
      end
      self.tbPlayerRound[i] = { szPlayerName = szPlayerName, nOrgIndex = tbInfo.nOrgIndex }
    end
  end
  self:UpdatePlayerInfo()
end

function uiWllsChooseWin:OnClose() end

function uiWllsChooseWin:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_ACCEPT then
    self:ApplySureMatchRound()
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWndName == self.BTN_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  end

  for i = 1, self.nMaxNum_Choose do
    if szWndName == self.BTN_CHOOSE .. i then
      self:TurnUpPlayer(i)
      break
    end
  end
end

function uiWllsChooseWin:ApplySureMatchRound()
  local tbTemp = {}
  for i, tbInfo in pairs(self.tbPlayerRound) do
    if tbInfo and tbInfo.nOrgIndex then
      tbTemp[tbInfo.nOrgIndex] = i
    end
  end
  me.CallServerScript({ "ApplySureMatchRoundCmd", tbTemp })
end

-- 上移当前玩家
function uiWllsChooseWin:TurnUpPlayer(nIndex)
  if nIndex <= 1 or nIndex > self.nMaxNum_Choose then
    return 0
  end
  local tbUp = self.tbPlayerRound[nIndex]
  local tbDown = self.tbPlayerRound[nIndex - 1]
  self.tbPlayerRound[nIndex] = tbDown
  self.tbPlayerRound[nIndex - 1] = tbUp
  self:UpdatePlayerInfo()
  return 1
end

function uiWllsChooseWin:UpdatePlayerInfo()
  for i = 1, self.nMaxNum_Choose do
    Wnd_Hide(self.UIGROUP, self.BTN_CHOOSE .. i)
  end

  for i = 1, self.nMaxNum_PlayerInfo do
    Wnd_Hide(self.UIGROUP, self.TXT_PLAYERINFO .. i)
  end

  for i, tbInfo in ipairs(self.tbPlayerRound) do
    local szMsg = string.format("   第%s轮     %s", i, tbInfo.szPlayerName or "无参赛队员")
    if UiVersion == Ui.Version002 then
      szMsg = tbInfo.szPlayerName or "无参赛队员"
    end
    if i > 1 then
      Wnd_Show(self.UIGROUP, self.BTN_CHOOSE .. i)
    end
    Wnd_Show(self.UIGROUP, self.TXT_PLAYERINFO .. i)
    Txt_SetTxt(self.UIGROUP, self.TXT_PLAYERINFO .. i, szMsg)
  end
  return 1
end
