--=================================================
-- 文件名　：installlog.lua
-- 创建者　：furuilei
-- 创建时间：2010-12-03 16:22:44
-- 功能描述：统计安装信息
--=================================================

Ui.tbLogic.tbInstallLog = Ui.tbLogic.tbInstallLog or {}
local tbInstallLog = Ui.tbLogic.tbInstallLog
tbInstallLog.SZFILE = "data.dat"
tbInstallLog.FILE_KEY = "data"
tbInstallLog.SECTION = "Client"
tbInstallLog.TB_SZINFO = {}

function tbInstallLog:ReportInstallInfo()
  if 0 == self:InitAllLogInfo() then
    return
  end

  for _, tbInfo in pairs(self.TB_SZINFO) do
    self.SZKEY = tbInfo.szSend or ""
    self.SZLOG = tbInfo.szLog or ""
    local nSend = self:CheckSend()
    if nSend > 0 then
      self:SendLog()
      self:DecSend()
    elseif nSend == -1 then
      self:SendLog()
    end
  end
end

function tbInstallLog:InitAllLogInfo()
  local bRet = 0
  local szPath = GetRootPath() .. self.SZFILE
  local bSuccess = KFile.IniFile_Load(szPath, self.FILE_KEY)
  if 1 == bSuccess then
    self.TB_SZINFO = {}
    local nCount = tonumber(KFile.IniFile_GetData(self.FILE_KEY, self.SECTION, "nCount"))
    if nCount <= 0 then
      return
    end

    for i = 1, nCount do
      local szName_Log = "szLog" .. i
      local szName_Send = "Send" .. i
      local tbTemp = {}
      tbTemp.szLog = KFile.IniFile_GetData(self.FILE_KEY, self.SECTION, szName_Log) or ""
      tbTemp.szSend = szName_Send or ""
      table.insert(self.TB_SZINFO, tbTemp)
    end

    bRet = 1
  end
  KFile.IniFile_UnLoad(self.FILE_KEY)
  return bRet
end

function tbInstallLog:CheckSend()
  local nSend = 0
  local szPath = GetRootPath() .. self.SZFILE
  local bSuccess = KFile.IniFile_Load(szPath, self.FILE_KEY)
  if 1 == bSuccess then
    nSend = tonumber(KFile.IniFile_GetData(self.FILE_KEY, self.SECTION, self.SZKEY)) or 0
  end
  KFile.IniFile_UnLoad(self.FILE_KEY)
  return nSend
end

function tbInstallLog:DecSend()
  local bSendLog = 0
  local szPath = GetRootPath() .. self.SZFILE
  local bSuccess = KFile.IniFile_Load(szPath, self.FILE_KEY)
  if 1 == bSuccess then
    local nSend = tonumber(KFile.IniFile_GetData(self.FILE_KEY, self.SECTION, self.SZKEY)) - 1
    if nSend < 0 then
      nSend = 0
    end
    KFile.IniFile_SetData(self.FILE_KEY, self.SECTION, self.SZKEY, tostring(nSend))
    KFile.IniFile_SaveFile(self.FILE_KEY, szPath)
  end
  KFile.IniFile_UnLoad(self.FILE_KEY)
end

function tbInstallLog:SendLog()
  me.CallServerScript({ "InstallInfoLog", self.SZLOG or "" })
end
