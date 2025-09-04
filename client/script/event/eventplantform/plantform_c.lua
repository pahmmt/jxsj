-- 2009-9-19 15:46:41
-- 家族竞技平台客户端脚本

if not MODULE_GAMECLIENT then
  return
end

EPlatForm.nSaveTime = 0
EPlatForm.tbPlatformInfo = {}

function EPlatForm:GetKinEventPlatformData()
  if self.nSaveTime > 0 and (GetTime() - self.nSaveTime) <= 10 then
    return self.tbPlatformInfo
  end
  me.CallServerScript({ "PlatformDataApplyCmd" })
  return nil
end

function EPlatForm:SyncKinPlatformInfo(tbPlatformInfo)
  self.nSaveTime = GetTime()
  if not tbPlatformInfo then
    return 0
  end
  self.tbPlatformInfo = tbPlatformInfo
  CoreEventNotify(UiNotify.emCOREEVENT_KIN_PLATFORM_INFO)
end
