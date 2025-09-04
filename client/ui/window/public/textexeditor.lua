-- 文件名　：textexeditor.lua
-- 创建者　：fanzai
-- 创建时间：2008-03-06 09:56:28

local uiTextexEditor = Ui:GetClass("textexeditor") -- 支持重载

--uiTextexEditor.TXT_TEXTNUM 		= "TxtTextNum";
uiTextexEditor.TXX_SHOW = "TxtExShow"
uiTextexEditor.EDT_TITLE = "EdtTitle"
uiTextexEditor.EDT_TEXT = "EdtText"
uiTextexEditor.TXT_REMARK = "TxtRemark"
uiTextexEditor.LST_TEXTLIST = "LstTextList"
uiTextexEditor.BTN_SAVE = "BtnSave"
uiTextexEditor.BTN_DELETE = "BtnDelete"
uiTextexEditor.BTN_CLOSE = "BtnClose"
uiTextexEditor.BTN_SEARCH = "BtnSearch"
uiTextexEditor.CMB_CLASS = "CmbGMClass"

uiTextexEditor.SZFILENAME = "\\text.lua"
uiTextexEditor.SZFILEGM = "\\gm.lua"

function uiTextexEditor:OnOpen()
  local szFileContent = KIo.ReadTxtFile(self.SZFILENAME)
  local szFileGm = KIo.ReadTxtFile(self.SZFILEGM)

  if szFileContent then
    local fnFile = loadstring(szFileContent)
    self.tbTextList = fnFile()
  else
    self.tbTextList = {}
  end

  if szFileGm then
    local fnFile = loadstring(szFileGm)
    self.tbGm = fnFile()
  else
    self.tbGm = {}
  end

  self.curClass = 0 --默认显示自定义的指令
  self.searchKey = ""
  ClearComboBoxItem(self.UIGROUP, self.CMB_CLASS)
  ComboBoxAddItem(self.UIGROUP, self.CMB_CLASS, 0, "自定义")
  for nIndex, tbInfo in ipairs(self.tbGm) do
    ComboBoxAddItem(self.UIGROUP, self.CMB_CLASS, nIndex, tbInfo.ClassName)
  end
  ComboBoxSelectItem(self.UIGROUP, self.CMB_CLASS, 0)
  self:RefreshList()
end

function uiTextexEditor:RefreshList()
  local tbTextList = {}
  if 0 == self.curClass then
    tbTextList = self.tbTextList
  else
    tbTextList = self.tbGm[self.curClass]
  end

  local nCurSelect = Lst_GetCurKey(self.UIGROUP, self.LST_TEXTLIST)

  --Txt_SetTxt(self.UIGROUP, self.TXT_TEXTNUM, string.format("文字数量：%d条", #tbTextList));
  local tbIndexShowKey = {} --记录显示出来的指令Index
  local tbIndex = {} --为显示出来的指令建立索引
  Lst_Clear(self.UIGROUP, self.LST_TEXTLIST)
  if "" == self.searchKey then
    for nIndex, tbText in ipairs(tbTextList) do
      Lst_SetCell(self.UIGROUP, self.LST_TEXTLIST, nIndex, 0, tbText[1])
      table.insert(tbIndexShowKey, nIndex)
      tbIndex[nIndex] = 1
    end
  else
    for nIndex, tbText in ipairs(tbTextList) do
      if string.find(tbText[1], self.searchKey) then
        Lst_SetCell(self.UIGROUP, self.LST_TEXTLIST, nIndex, 0, tbText[1])
        table.insert(tbIndexShowKey, nIndex)
        tbIndex[nIndex] = 1
      end
    end
  end

  if tbIndex[nCurSelect] then
    Lst_SetCurKey(self.UIGROUP, self.LST_TEXTLIST, nCurSelect)
  else
    if tbIndexShowKey[1] then
      Lst_SetCurKey(self.UIGROUP, self.LST_TEXTLIST, tbIndexShowKey[1])
    else
      Lst_SetCurKey(self.UIGROUP, self.LST_TEXTLIST, 1)
    end
  end
end

function uiTextexEditor:SelText(nIndex)
  local tbText = {}
  if 0 == self.curClass then
    tbText = self.tbTextList[nIndex]
  else
    tbText = self.tbGm[self.curClass][nIndex]
  end
  if tbText then
    Edt_SetTxt(self.UIGROUP, self.EDT_TITLE, tbText[1])
    Edt_SetTxt(self.UIGROUP, self.EDT_TEXT, tbText[2])
    if not tbText[3] then
      tbText[3] = ""
    end
    TxtEx_SetText(self.UIGROUP, self.TXT_REMARK, (#tbText[3] == 0) and " " or tbText[3])
    TxtEx_SetText(self.UIGROUP, self.TXX_SHOW, tbText[2])
  else
    Edt_SetTxt(self.UIGROUP, self.EDT_TITLE, "文字标题")
    Edt_SetTxt(self.UIGROUP, self.EDT_TEXT, "文字内容")
    TxtEx_SetText(self.UIGROUP, self.TXT_REMARK, " ")
    TxtEx_SetText(self.UIGROUP, self.TXX_SHOW, "文字内容")
  end

  Wnd_SetFocus(self.UIGROUP, self.EDT_TEXT)
end

function uiTextexEditor:SaveText()
  local tbTextList = {}
  if 0 == self.curClass then
    tbTextList = self.tbTextList
  else
    tbTextList = self.tbGm[self.curClass]
  end

  local szTitle = Edt_GetTxt(self.UIGROUP, self.EDT_TITLE)
  local szText = Edt_GetTxt(self.UIGROUP, self.EDT_TEXT)
  local szSaveRemark = ""
  local nSaveIdx = #tbTextList + 1

  for nIndex, tbText in ipairs(tbTextList) do
    if tbText[1] == szTitle then
      nSaveIdx = nIndex
      szSaveRemark = tbText[3] or ""
      break
    end
  end

  tbTextList[nSaveIdx] = { szTitle, szText, szSaveRemark }
  self.searchKey = ""
  if 0 == self.curClass then
    self:RefreshList()
    self:SaveFile()
  end

  --执行指令
  Lst_SetCurKey(self.UIGROUP, self.LST_TEXTLIST, nSaveIdx)
  self.nGmTextNum = self.nGmTextNum or 0
  self.tbGmTextList = self.tbGmTextList or {}
  if self.tbGmTextList[self.nGmTextNum] then
    me.Msg("指令执行太快,请稍后!!")
    return 0
  end
  self.tbGmTextList = {}
  self.nGmTextNum = 0
  if string.sub(szText, 1, 2) == "??" then
    GM:DoCommand(string.sub(szText, 3))
  elseif string.sub(szText, 1, 3) == "?gc" then
    local nSplit = 100
    if string.len(szText) > nSplit then
      nSplit = 85
      szText = string.sub(szText, 4)
      local szGm = '?pl GCExcute{"GM:DoCommand",[==['

      for i = 1, math.ceil(string.len(szText) / nSplit) do
        local szMsg = string.sub(szText, nSplit * (i - 1) + 1, nSplit * i)
        if i == 1 then
          szMsg = szGm .. "GM.__STR=[=[" .. szMsg .. "]=]]==]}"
        else
          szMsg = szGm .. "GM.__STR=GM.__STR..[=[" .. szMsg .. "]=]]==]}"
        end
        table.insert(self.tbGmTextList, szMsg)
      end

      local szGmMsg = szGm .. "loadstring(GM.__STR)()]==]}"
      table.insert(self.tbGmTextList, szGmMsg)
      Timer:Register(3, self.DoGmTextListFun, self)
    else
      SendChannelMsg("GM", szText)
    end
  elseif string.sub(szText, 1, 1) == "?" then
    local nSplit = 100
    if string.len(szText) > nSplit then
      local szGm = ""
      if string.sub(szText, 1, 3) == "?pl" then
        szText = string.sub(szText, 4)
        szGm = "?pl "
      elseif string.sub(szText, 1, 6) == "?gm ds" then
        szGm = "?pl "
        szText = string.sub(szText, 7)
      else
        return 0
      end

      table.insert(self.tbGmTextList, szGm .. 'GM.__STR=""')
      for i = 1, math.ceil(string.len(szText) / nSplit) do
        local szMsg = string.sub(szText, nSplit * (i - 1) + 1, nSplit * i)
        if i == 1 then
          szMsg = szGm .. "GM.__STR=[=[" .. szMsg .. "]=]"
        else
          szMsg = szGm .. "GM.__STR=GM.__STR..[=[" .. szMsg .. "]=]"
        end
        table.insert(self.tbGmTextList, szMsg)
      end
      local szGmMsg = szGm .. "loadstring(GM.__STR)()"
      table.insert(self.tbGmTextList, szGmMsg)
      Timer:Register(1, self.DoGmTextListFun, self)
    else
      SendChannelMsg("GM", szText)
    end
  end
end

function uiTextexEditor:DoGmTextListFun()
  self.nGmTextNum = self.nGmTextNum + 1
  if not self.nGmTextNum or not self.tbGmTextList[self.nGmTextNum] then
    self.nGmTextNum = 0
    self.tbGmTextList = {}
    return 0
  end
  SendChannelMsg("GM", self.tbGmTextList[self.nGmTextNum])
end

function uiTextexEditor:DelText()
  local szTitle = Edt_GetTxt(self.UIGROUP, self.EDT_TITLE)
  local tbTextList = {}
  if 0 == self.curClass then
    tbTextList = self.tbTextList
  else
    tbTextList = self.tbGm[self.curClass]
  end
  for nIndex, tbText in ipairs(tbTextList) do
    if tbText[1] == szTitle then
      table.remove(tbTextList, nIndex)
      self:RefreshList()
      self:SaveFile()
      if not tbTextList[nIndex] then
        nIndex = nIndex - 1
      end
      Lst_SetCurKey(self.UIGROUP, self.LST_TEXTLIST, 1)
      break
    end
  end
end

function uiTextexEditor:Search()
  local szTitle = Edt_GetTxt(self.UIGROUP, self.EDT_TITLE)
  self.searchKey = szTitle
  Lst_SetCurKey(self.UIGROUP, self.LST_TEXTLIST, 1)
  self:RefreshList()
end

function uiTextexEditor:SaveFile()
  local szValue = Lib:Val2Str(self.tbTextList)
  KIo.WriteFile(self.SZFILENAME, "return " .. szValue)
end

function uiTextexEditor:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_SAVE then
    self:SaveText()
  elseif szWnd == self.BTN_DELETE then
    self:DelText()
  elseif szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SEARCH then
    self:Search()
  end
end

function uiTextexEditor:OnListSel(szWnd, nParam)
  if szWnd == self.LST_TEXTLIST then
    self:SelText(nParam)
  end
end

function uiTextexEditor:OnEditEnter(szWnd)
  if szWnd == self.EDT_TITLE or szWnd == self.EDT_TEXT then
    self:SaveText()
  end
end

function uiTextexEditor:OnEditChange(szWnd)
  if szWnd == self.EDT_TEXT then
    local szText = Edt_GetTxt(self.UIGROUP, self.EDT_TEXT)
    TxtEx_SetText(self.UIGROUP, self.TXX_SHOW, szText)
  end
end

function uiTextexEditor:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.CMB_CLASS then
    self.curClass = nIndex
    Lst_SetCurKey(self.UIGROUP, self.LST_TEXTLIST, 1)
    self.searchKey = ""
    self:RefreshList()
  end
end

function uiTextexEditor:Link_test_OnClick(szWnd, szLinkData)
  print("没用！没用！没用！")
end

function uiTextexEditor:Link_test_GetTip(szWnd, szLinkData)
  return "没有用！"
end
