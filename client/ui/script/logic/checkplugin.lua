--author: zhaoyu	2010/6/7 9:22:41

Ui.tbCheckPlugin = Ui.tbCheckPlugin or {}
local tbCheckPlugin = Ui.tbCheckPlugin
tbCheckPlugin.tbIgnoreList = {}
tbCheckPlugin.tbErrorPluginName = {}
tbCheckPlugin.nColor = 0
tbCheckPlugin.tbColorList = { "yellow", "red", "green", "blue", "orange" }
tbCheckPlugin.bOpenReport = 0

function tbCheckPlugin:SaveIgnore()
  local szFilePath = "\\user\\ignorelist.dat"
  local szData = Lib:Val2Str(self.tbIgnoreList)
  KFile.WriteFile(szFilePath, szData)
end

function tbCheckPlugin:LoadIgnoreList()
  local szFilePath = "\\user\\ignorelist.dat"
  local szData = KIo.ReadTxtFile(szFilePath)
  self.tbIgnoreList = {}
  if szData then
    self.tbIgnoreList = Lib:Str2Val(szData)
  end
end

function tbCheckPlugin:AskIgnore(szName, nVersion)
  self.nColor = self.nColor + 1
  if self.nColor > #self.tbColorList then
    self.nColor = 1
  end
  local szMsgFmt = string.format("您的插件<color=%s>[%%s]<color>加载出错了，您可以关闭此插件，以防游戏运行出错。", self.tbColorList[self.nColor])

  local tbMsg = {}
  tbMsg.szMsg = string.format(szMsgFmt, szName)
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "确定", "忽略" }
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      tbCheckPlugin.tbIgnoreList[szName] = nVersion
    end
    tbCheckPlugin:BeginReport(nVersion)
    return 1
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function tbCheckPlugin:BeginReport(nVersion)
  local bOver = 1
  for szName, _ in pairs(self.tbErrorPluginName) do
    if self.tbIgnoreList[szName] == nil or self.tbIgnoreList[szName] ~= nVersion then
      bOver = 0
      self:AskIgnore(szName, nVersion)
      self.tbErrorPluginName[szName] = nil
      break
    end
  end
  if bOver == 1 then
    UiManager:CloseWindow(Ui.UI_MSGBOX)
    self:SaveIgnore()
  end
end

function tbCheckPlugin:ReportPluginError(nVersion)
  if self.tbErrorPluginName == nil then
    return
  end
  self:LoadIgnoreList()
  self:BeginReport(nVersion)
end

function tbCheckPlugin:GetPluginNameByPath(szPath)
  for _, tbInfo in ipairs(Ui.tbPluginInfoList) do
    if tbInfo.nLoadState == 1 and tbInfo.szPluginPath == szPath then
      return tbInfo.szPluginName
    end
  end
end

function tbCheckPlugin:AnalyzeStack(szTxt)
  local tbError = {}
  for i = 1, 100 do
    local _, nLineTail, szLine = string.find(szTxt, "(.-)\n")
    if szLine == nil then
      break
    end
    --print(i, szLine);
    local _, _, szPath = string.find(szLine, ".-(\\interface\\.-\\).*")
    if szPath ~= nil then
      local szName = self:GetPluginNameByPath(szPath)
      if szName then
        table.insert(tbError, szName)
      end
    end
    szTxt = string.sub(szTxt, nLineTail + 1, string.len(szTxt))
  end
  return tbError
end

function tbCheckPlugin:CheckLoadError(szTxt)
  if self.bOpenReport ~= 1 then
    return
  end
  local tbError = self:AnalyzeStack(szTxt)
  for _, szName in ipairs(tbError) do
    self.tbErrorPluginName[szName] = 1
  end
end

function tbCheckPlugin:CheckRuntimeError(szTxt)
  if self.bOpenReport ~= 1 then
    return
  end
  local tbError = self:AnalyzeStack(szTxt)
  for _, szName in ipairs(tbError) do
    me.Msg(string.format("您的插件<color=yellow>[%s]<color>运行时出现了错误，可能会影响游戏的稳定性。", szName))
  end
end

function tbCheckPlugin:CheckSendDataError()
  if self.bOpenReport ~= 1 then
    return
  end
  local szTxt = debug.traceback()
  local tbError = self:AnalyzeStack(szTxt)
  for _, szName in ipairs(tbError) do
    me.Msg(string.format("您的插件<color=yellow>[%s]<color>正在恶意发送协议，可能会导致连接不稳定甚至掉线等情况。", szName))
  end
end

function tbCheckPlugin:CheckOpenReport()
  local szFilePath = "\\ReportError.txt"
  local szData = KIo.ReadTxtFile(szFilePath)
  if type(szData) ~= "nil" then
    self.bOpenReport = 1
  end
end

function tbCheckPlugin:OpenReportError(bOpen)
  self.bOpenReport = bOpen
end
--tbCheckPlugin:CheckOpenReport();
