Ui.tbLogic.tbAgreementMgr = {}
local tbAgreementMgr = Ui.tbLogic.tbAgreementMgr

tbAgreementMgr.SECTION = "game.exe"
tbAgreementMgr.KEY = "agreement"
tbAgreementMgr.CONFIGFILE = "version.cfg"

local AGREEMENTFILE = "\\setting\\misc\\agreement.txt"

function tbAgreementMgr:Init()
  self.szAgreeData = ""
end

function tbAgreementMgr:IsAgree()
  local szReadFileKey = "agreement"
  local szRootPath = GetRootPath()
  local szFilePath = szRootPath .. self.CONFIGFILE
  local bSuccess = KFile.IniFile_Load(szFilePath, szReadFileKey)
  local szOrgCrc = ""
  if bSuccess == 1 then
    szOrgCrc = KFile.IniFile_GetData(szReadFileKey, self.SECTION, self.KEY)
  end
  KFile.IniFile_UnLoad(szReadFileKey)
  local nOrgCrc = tonumber(szOrgCrc)
  -- 取协议文件大小
  local szTxtContent = KIo.ReadTxtFile(AGREEMENTFILE)
  self.szAgreeData = szTxtContent
  local nNowCRC = TOOLS_MiscCRC32(self.szAgreeData)

  if nOrgCrc == nNowCRC then
    return 1
  else
    return 0
  end
end

function tbAgreementMgr:SetAgree(bAgree)
  -- 取协议文件大小
  local szTxtContent = KIo.ReadTxtFile(AGREEMENTFILE)
  self.szAgreeData = szTxtContent
  local nNowCRC = TOOLS_MiscCRC32(self.szAgreeData)

  local szReadFileKey = "SetAgree"
  local szRootPath = GetRootPath()
  local szFilePath = szRootPath .. self.CONFIGFILE
  local bSuccess = KFile.IniFile_Load(szFilePath, szReadFileKey)
  if bSuccess == 1 then
    if bAgree == 0 then
      KFile.IniFile_SetData(szReadFileKey, self.SECTION, self.KEY, "")
    else
      KFile.IniFile_SetData(szReadFileKey, self.SECTION, self.KEY, tostring(nNowCRC))
    end
    KFile.IniFile_SaveFile(szReadFileKey, szFilePath)
  end
  KFile.IniFile_UnLoad(szReadFileKey)
  UiManager.bAgreementFlag = bAgree
end

function tbAgreementMgr:ShowTip()
  local tbMsg = {}
  tbMsg.szMsg = "登陆剑侠世界，必须同意协议"
  tbMsg.nOptCount = 1
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function tbAgreementMgr:ShowAgreement()
  if IVER_g_nTwVersion == 1 then
    UiManager:OpenWindow(Ui.UI_AGREEMENT, self.szAgreeData)
    return
  end
  local bAgree
  bAgree = self:IsAgree()
  if bAgree == 0 then
    UiManager:OpenWindow(Ui.UI_AGREEMENT, self.szAgreeData)
  elseif bAgree == 1 then
    return
  end
end
