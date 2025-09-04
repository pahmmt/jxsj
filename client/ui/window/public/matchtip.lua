-- 文件名　：matchtip.lua
-- 创建者　：zounan
-- 创建时间：2010-03-17 14:50:45
-- 描  述  ：活动提示界面
local uiMatchTip = Ui:GetClass("matchtip")
local tbCalendar = Ui.tbLogic.tbCalendar
local tbTimer = Ui.tbLogic.tbTimer

uiMatchTip.TXT_TITLE = "TxtTitle"
uiMatchTip.TXT_MSG1 = "TxtMsg1"
uiMatchTip.TXT_MSG2 = "TxtMsg2"
uiMatchTip.TXT_PAGE = "TxtPageDesc"

uiMatchTip.BUTTON_SORT_ITEM = "BtnHornTip"
uiMatchTip.BUTTON_MATCH1 = "BtnMatch1"
uiMatchTip.BUTTON_MATCH2 = "BtnMatch2"
uiMatchTip.BUTTON_MATCH3 = "BtnMatch3"
uiMatchTip.BUTTON_CLOSE = "BtnClose"
uiMatchTip.BUTTON_LEFT = "BtnLeft"
uiMatchTip.BUTTON_RIGHT = "BtnRight"

uiMatchTip.BUTTON_OK = "BtnOK"

uiMatchTip.TXT_MATCHNAME1 = "TxtMatchName1"
uiMatchTip.TXT_MATCHTIME1 = "TxtMatchTime1"
uiMatchTip.TXT_MATCHLEFT1 = "TxtMatchLeft1"

uiMatchTip.nCurPage = 1
uiMatchTip.nTotalPage = 1
uiMatchTip.COUNT_PER_PAGE = 3
uiMatchTip.TIMER_UPDATE = 30 * Env.GAME_FPS

uiMatchTip.tbMatch = {}
uiMatchTip.tbNotifyMatch = {}
uiMatchTip.nTimerId = 0

-- 全拷贝table，注意不能出现table环链~否则会死循环
function uiMatchTip:CopyTable(tbSourTable, tbDisTable)
  if not tbSourTable or not tbDisTable then
    return 0
  end
  for varField, varData in pairs(tbSourTable) do
    if type(varData) == "table" then
      tbDisTable[varField] = {}
      self:CopyTable(varData, tbDisTable[varField])
    else
      tbDisTable[varField] = varData
    end
  end
end

function uiMatchTip:OnOpen(szState, tbNotifyMatch)
  if not self[szState] then
    print("【ERROR】 MATCHTIP NO SUCH STATE", szState)
    return 0
  end
  return self[szState](self, tbNotifyMatch)
end

function uiMatchTip:OnClose()
  if self.nTimerId ~= 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
end

function uiMatchTip:OpenWithMatch(tbNotifyMatch)
  self.tbNotifyMatch = {}
  self:CopyTable(tbNotifyMatch, self.tbNotifyMatch)

  self.nTotalPage = math.ceil(#self.tbNotifyMatch / self.COUNT_PER_PAGE)
  if #self.tbNotifyMatch == 0 then
    print(">uiMatchTip:OpenWithMatch tbNotifyMatch = 0 ")
    return 0
  end
  self.nCurPage = 1
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "活 动 提 示")
  Txt_SetTxt(self.UIGROUP, self.TXT_MSG1, "精彩活动即将开始。")
  Txt_SetTxt(self.UIGROUP, self.TXT_MSG2, "点击活动名称前往报名处。")
  Wnd_Show(self.UIGROUP, self.BUTTON_LEFT)
  Wnd_Show(self.UIGROUP, self.BUTTON_RIGHT)
  self:OnUpdatePage(1)
  self:UpdatePageNumber()
  self.nTimerId = tbTimer:Register(self.TIMER_UPDATE, self.OnUpdatePage, self)
end

function uiMatchTip:OpenWithOnLine()
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "上线活动提示")
  Txt_SetTxt(self.UIGROUP, self.TXT_MSG1, "今天可以参加的活动")
  Txt_SetTxt(self.UIGROUP, self.TXT_MSG2, "点击图标前往报名处。")
  Wnd_Show(self.UIGROUP, self.BUTTON_LEFT)
  Wnd_Show(self.UIGROUP, self.BUTTON_RIGHT)
  self:OnUpdatePage(1)
  self:UpdatePageNumber()
  self.nTimerId = tbTimer:Register(self.TIMER_UPDATE, self.OnUpdatePageOnOff, self, 0)
end

function uiMatchTip:OpenWithOffLine()
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, "下 线 提 示")
  Txt_SetTxt(self.UIGROUP, self.TXT_MSG1, "今天还没完成的活动")
  Txt_SetTxt(self.UIGROUP, self.TXT_MSG2, "点击活动名称前往报名处。")
  Wnd_Show(self.UIGROUP, self.BUTTON_LEFT)
  Wnd_Show(self.UIGROUP, self.BUTTON_RIGHT)
  self:OnUpdatePage()
  self:UpdatePageNumber()
  self.nTimerId = tbTimer:Register(self.TIMER_UPDATE, self.OnUpdatePageOnOff, self)
end

function uiMatchTip:Clear()
  for i = 1, self.COUNT_PER_PAGE do
    Wnd_Hide(self.UIGROUP, string.format("BtnMatch%d", i))
    Wnd_Hide(self.UIGROUP, string.format("BtnGame%d", i))
    self:SetTxtEx(string.format("TxtMatchName%d", i), " ")
    Txt_SetTxt(self.UIGROUP, string.format("TxtMatchTime%d", i), "")
    Txt_SetTxt(self.UIGROUP, string.format("TxtMatchLeft%d", i), "")
  end
end

function uiMatchTip:OnUpdatePage(bUpdateAll)
  self:Clear()
  local nStart = (self.nCurPage - 1) * self.COUNT_PER_PAGE
  local nCurTime = tonumber(GetLocalDate("%H%M"))
  for i = 1, self.COUNT_PER_PAGE do
    local nIndex = nStart + i
    if not self.tbNotifyMatch[nIndex] then
      break
    end
    self:ShowMatchDesc(i, nIndex, self.tbNotifyMatch[nIndex], nCurTime, bUpdateAll)
  end
  --	self:UpdatePageNumber();
end

function uiMatchTip:ShowMatchDesc(i, nIndex, tbMatch, nCurTime, bUpdateAll)
  if not tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex] then
    print("【error】,tbMatch is nil", tbMatch.nMatchIndex)
    return
  end

  --	if bUpdateAll and bUpdateAll == 1 then
  local szName = tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].szName
  Wnd_Show(self.UIGROUP, string.format("BtnMatch%d", i))
  if tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].szMatchSpr and tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].szMatchSpr ~= "" then
    Img_SetImage(self.UIGROUP, string.format("BtnMatch%d", i), 1, tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].szMatchSpr)
  end

  local varLinkNpc = tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].varLinkNpc
  local szLinkNpc = tbCalendar:GetVar(varLinkNpc, "")
  if not szLinkNpc or szLinkNpc == "" then
    print(">>error>>uiMatchTip:ShowMatchDesc, szLinkNpc:", szLinkNpc)
  end
  local szTxtEx = self:ParseLink(szLinkNpc, szName)
  --			local szTip = UiManager.tbLinkClass[szType]:GetTip(szLink);
  --			Wnd_SetTip(self.UIGROUP, string.format("BtnMatch%d",i),szTip);
  --Txt_SetTxt(self.UIGROUP,string.format("TxtMatchName%d",i), string.format("<color=green>%s<color>",szName));
  self:SetTxtEx(string.format("TxtMatchName%d", i), szTxtEx)
  local tbTime = tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].tbTime[tbMatch.nTimeIndex]
  Txt_SetTxt(self.UIGROUP, string.format("TxtMatchTime%d", i), string.format("<color=green>下场开始:%s<color>", self:Num2Time(tbTime[2])))
  local nLeft = self:ComputeMinute(tbTime[2], nCurTime)
  Txt_SetTxt(self.UIGROUP, string.format("TxtMatchLeft%d", i), string.format("<color=green>剩余: %s<color>", self:Num2Time(nLeft)))
  local nMatchId = tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].nMatchId
  Wnd_Show(self.UIGROUP, string.format("BtnGame%d", i))
  local nChecked = tbCalendar.tbMatchNotify[nMatchId]
  Btn_Check(self.UIGROUP, string.format("BtnGame%d", i), nChecked)
  Wnd_SetTip(self.UIGROUP, string.format("BtnGame%d", i), "开启此活动报名提醒")
end

function uiMatchTip:OnUpdatePageOnOff()
  self:Clear()
  local nStart = (self.nCurPage - 1) * self.COUNT_PER_PAGE
  for i = 1, self.COUNT_PER_PAGE do
    local nIndex = nStart + i
    if not self.tbNotifyMatch[nIndex] then
      break
    end
    self:ShowMatchOnOff(i, nIndex, self.tbNotifyMatch[nIndex])
  end
  --	self:UpdatePageNumber();
end

function uiMatchTip:ShowMatchOnOff(i, nIndex, tbMatch)
  if not tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex] then
    print("【error】,tbMatch is nil", tbMatch.nMatchIndex)
    return
  end
  local szName = tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].szName
  local tbTime = tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].tbTime[tbMatch.nTimeIndex]
  Wnd_Show(self.UIGROUP, string.format("BtnMatch%d", i))
  Txt_SetTxt(self.UIGROUP, string.format("TxtMatchName%d", i), string.format("<color=green>%s<color>", szName))
  Txt_SetTxt(self.UIGROUP, string.format("TxtMatchTime%d", i), "")
  --	Txt_SetTxt(self.UIGROUP,string.format("TxtMatchLeft%d",i),string.format("<color=green>剩余: %s<color>",self:Num2Time(nLeft)));
end

function uiMatchTip:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:CloseWindow(Ui.UI_HORNTIP)
  --	elseif  szWnd == uiMatchTip.BUTTON_MATCH1 then
  --		self:AutoGoPos(1);
  --		UiManager:CloseWindow(self.UIGROUP);
  --	elseif  szWnd == uiMatchTip.BUTTON_MATCH2 then
  --		self:AutoGoPos(2);
  --		UiManager:CloseWindow(self.UIGROUP);
  --	elseif  szWnd == uiMatchTip.BUTTON_MATCH3 then
  --		self:AutoGoPos(3);
  --		UiManager:CloseWindow(self.UIGROUP);
  elseif szWnd == uiMatchTip.BUTTON_LEFT then
    if self.nCurPage > 1 then
      self.nCurPage = self.nCurPage - 1
      self:OnUpdatePage(1)
      self:UpdatePageNumber()
    end
  elseif szWnd == uiMatchTip.BUTTON_RIGHT then
    if self.nCurPage < self.nTotalPage then
      self.nCurPage = self.nCurPage + 1
      self:OnUpdatePage(1)
      self:UpdatePageNumber()
    end
  elseif szWnd == self.BUTTON_OK then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:CloseWindow(Ui.UI_HORNTIP)
  end

  for i = 1, self.COUNT_PER_PAGE do
    if szWnd == string.format("BtnGame%d", i) then
      self:SetMatchRemind(i, nParam)
    end
  end
end

function uiMatchTip:AutoGoPos(nIndex)
  nIndex = nIndex + (self.nCurPage - 1) * self.COUNT_PER_PAGE
  local tbMatch = self.tbNotifyMatch[nIndex]
  if not tbMatch then
    print("【error】uiMatchTip,tbNotifyMatch is nil", nMatchIndex)
    return
  end

  if not tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex] then
    print("【error】uiMatchTip,tbMatch is nil", tbMatch.nMatchIndex)
    return
  end
  local varLinkNpc = tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].varLinkNpc
  local szLinkNpc = tbCalendar:GetVar(varLinkNpc, "")

  if not szLinkNpc or szLinkNpc == "" then
    me.Msg("没有寻路的NPC")
    return
  end

  local szType, szLink = self:ParseLink(szLinkNpc)
  UiManager.tbLinkClass[szType]:OnClick(szLink)
end

function uiMatchTip:SetMatchRemind(nIndex, nParam)
  nIndex = nIndex + (self.nCurPage - 1) * self.COUNT_PER_PAGE
  local tbMatch = self.tbNotifyMatch[nIndex]
  if not tbMatch then
    print("【error】uiMatchTip,tbNotifyMatch is nil", nMatchIndex)
    return
  end

  if not tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex] then
    print("【error】uiMatchTip,tbMatch is nil", tbMatch.nMatchIndex)
    return
  end

  local nMatchId = tbCalendar.tbTimingMatch.tbMatch[tbMatch.nMatchIndex].nMatchId
  tbCalendar.tbMatchNotify[nMatchId] = nParam
  Btn_Check(self.UIGROUP, string.format("BtnGame%d", nIndex), nParam)
end

function uiMatchTip:UpdatePageNumber()
  --	print(">>>>left, right",(self.nCurPage == 1) and 0 or 1,(self.nCurPage == self.nTotalPage) and 0 or 1);
  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_LEFT, 1);
  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_RIGHT, 1);
  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_LEFT, (self.nCurPage == 1) and 0 or 1);
  --	Wnd_SetEnable(self.UIGROUP, self.BUTTON_RIGHT, (self.nCurPage == self.nTotalPage) and 0 or 1);
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE, string.format("%d/%d", self.nCurPage, self.nTotalPage))
end

function uiMatchTip:Num2Time(nTime)
  local nHour = math.floor(nTime / 100)
  local nMin = nTime % 100
  local szTime = string.format("%02d:%02d", nHour, nMin)
  return szTime
end

function uiMatchTip:ComputeMinute(nTime, nSubTime)
  if tbCalendar:IsTimeNotify(nSubTime, nTime) == 0 then
    return 0
  end

  local nMinute = nTime % 100
  local nMinuteSub = nSubTime % 100
  nMinute = nMinute - nMinuteSub
  if nMinute < 0 then
    nMinute = nMinute + 60
  end
  return nMinute
end

--解析 <link=npcpos:***,2,2>|<link=npcpos:***,2,2>
function uiMatchTip:ParseLink(szText, szName)
  local tbSplit = Lib:SplitStr(szText, "|")
  local nRandom = MathRandom(#tbSplit)

  --替换显示名称
  local tbSplit = Lib:SplitStr(tbSplit[nRandom], ":")
  local tbLinkInfo = Lib:SplitStr(tbSplit[2], ",")
  tbLinkInfo[1] = szName
  local szNewText = tbSplit[1] .. ":"
  for nIdx, szInfo in ipairs(tbLinkInfo) do
    if nIdx == 1 then
      szNewText = szNewText .. szInfo
    else
      szNewText = szNewText .. "," .. szInfo
    end
  end

  return szNewText
end

function uiMatchTip:SetTxtEx(szWnd, szText)
  Ui.tbLogic.tbTimer:Register(1, self.OnTimer_SetText, self, szWnd, szText)
end

--延迟处理
function uiMatchTip:OnTimer_SetText(szWnd, szText)
  if szText and string.len(szText) > 0 then
    TxtEx_SetText(self.UIGROUP, szWnd, szText)
  end
  return 0
end
