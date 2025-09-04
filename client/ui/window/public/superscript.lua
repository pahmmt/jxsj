-------------------------------------------------------
-- 文件名　：superscript.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-03-18 14:45:44
-- 文件描述：
-------------------------------------------------------

local uiSuperScript = Ui:GetClass("superscript")

uiSuperScript.TXT_DIRNUM = "TxtDirNum"
uiSuperScript.TXT_FILENUM = "TxtFileNum"
uiSuperScript.TXT_TRACE = "TxtTraceBack"
uiSuperScript.EDT_TITLE = "EdtTitle"
uiSuperScript.EDT_TEXT = "EdtText"
uiSuperScript.LST_DIR = "LstDirList"
uiSuperScript.LST_FILE = "LstFileList"
uiSuperScript.BTN_UPDATEALL = "BtnUpdateAll"
uiSuperScript.BTN_UPDATEFILE = "BtnUpdateFile"
uiSuperScript.BTN_UPDATEGC = "BtnUpdateFileGC"
uiSuperScript.BTN_UPDATEDIR = "BtnUpdateDir"
uiSuperScript.BTN_CLOSE = "BtnClose"

function uiSuperScript:UpdateDirList(tbDirList)
  self.tbDirList = tbDirList
  Txt_SetTxt(self.UIGROUP, self.TXT_DIRNUM, string.format("<color=orange>目录数量：%d<color>", #self.tbDirList))
  Lst_Clear(self.UIGROUP, self.LST_DIR)
  Lst_SetCell(self.UIGROUP, self.LST_DIR, 1, 0, "<color=orange>返回上层<color>")
  for nIndex, szDir in ipairs(self.tbDirList) do
    Lst_SetCell(self.UIGROUP, self.LST_DIR, nIndex + 1, 0, string.format("<color=green>%s<color>", szDir))
  end
end

function uiSuperScript:UpdateFileList(tbFileList)
  self.tbFileList = tbFileList
  Txt_SetTxt(self.UIGROUP, self.TXT_FILENUM, string.format("<color=orange>文件数量：%d<color>", #self.tbFileList))
  Lst_Clear(self.UIGROUP, self.LST_FILE)
  for nIndex, tbFile in ipairs(self.tbFileList) do
    if tbFile[2] == 0 then
      Lst_SetCell(self.UIGROUP, self.LST_FILE, nIndex, 0, string.format("<color=red>%s<color>", tbFile[1]))
      Lst_SetCell(self.UIGROUP, self.LST_FILE, nIndex, 1, string.format("<color=red>%s<color>", "禁止重载"))
    elseif tbFile[2] == 2 then
      Lst_SetCell(self.UIGROUP, self.LST_FILE, nIndex, 0, string.format("<color=cyan>%s<color>", tbFile[1]))
      Lst_SetCell(self.UIGROUP, self.LST_FILE, nIndex, 1, string.format("<color=cyan>%s<color>", "OK"))
    else
      Lst_SetCell(self.UIGROUP, self.LST_FILE, nIndex, 0, string.format("<color=yellow>%s<color>", tbFile[1]))
    end
  end
  local nCurSelect = Lst_GetCurKey(self.UIGROUP, self.LST_FILE)
  if self.tbFileList[nCurSelect] then
    Lst_SetCurKey(self.UIGROUP, self.LST_FILE, nCurSelect)
  else
    Lst_SetCurKey(self.UIGROUP, self.LST_FILE, #self.tbFileList)
  end
end

function uiSuperScript:OnRecvData(tbSortDir, tbSortFile)
  if tbSortDir and tbSortFile and type(tbSortDir) == "table" and type(tbSortFile) == "table" then
    self:UpdateDirList(tbSortDir)
    self:UpdateFileList(tbSortFile)
  end
end

function uiSuperScript:OnUpdateFile(szFileName, nRet, szRet)
  for nIndex, tbFile in ipairs(self.tbFileList) do
    if tbFile[1] == szFileName then
      Lst_SetCell(self.UIGROUP, self.LST_FILE, nIndex, 0, string.format("<color=cyan>%s<color>", tbFile[1]))
      if nRet == 1 then
        Lst_SetCell(self.UIGROUP, self.LST_FILE, nIndex, 1, string.format("<color=cyan>%s<color>", "OK"))
      else
        Lst_SetCell(self.UIGROUP, self.LST_FILE, nIndex, 1, string.format("<color=red>%s<color>", "FAILED"))
      end
      Txt_SetTxt(self.UIGROUP, self.TXT_TRACE, szRet)
    end
  end
end

function uiSuperScript:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_UPDATEFILE then
    local nCurSelect = Lst_GetCurKey(self.UIGROUP, self.LST_FILE)
    if self.tbFileList[nCurSelect] then
      local szCmd = string.format('?pl Lib._SuperScript:DoSelectFile("%s", %d)', self.tbFileList[nCurSelect][1], 1)
      SendChannelMsg("GM", szCmd)
    end
  elseif szWnd == self.BTN_UPDATEGC then
    local nCurSelect = Lst_GetCurKey(self.UIGROUP, self.LST_FILE)
    if self.tbFileList[nCurSelect] then
      local szCmd = string.format('?pl Lib._SuperScript:DoSelectFile("%s", %d)', self.tbFileList[nCurSelect][1], 2)
      SendChannelMsg("GM", szCmd)
    end
  elseif szWnd == self.BTN_UPDATEALL then
    local szCmd = string.format("?pl Lib._SuperScript:DoUpdateAllFile()")
    SendChannelMsg("GM", szCmd)
  elseif szWnd == self.BTN_UPDATEDIR then
    local szCmd = string.format("?pl Lib._SuperScript:LoadScriptFile()")
    SendChannelMsg("GM", szCmd)
  end
end

function uiSuperScript:OnListSel(szWnd, nParam)
  if szWnd == self.LST_DIR then
    local szCmd = ""
    if nParam == 1 then
      szCmd = string.format("?pl Lib._SuperScript:DoParentDir()")
    else
      szCmd = string.format('?pl Lib._SuperScript:DoSubDir("%s")', self.tbDirList[nParam - 1])
    end
    SendChannelMsg("GM", szCmd)
  end
end
