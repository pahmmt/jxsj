Ui.tbLogic.tbPreUpdate = Ui.tbLogic.tbPreUpdate or {}
local tbPreUpdate = Ui.tbLogic.tbPreUpdate
local tbSaveData = Ui.tbLogic.tbSaveData

tbPreUpdate.DATA_KEY = "PreUpdate"

function tbPreUpdate:OnEnterGame()
  self.tbDataValue = tbSaveData:Load(self.DATA_KEY) or {}
  self.tbDataValue.bPreUpdateOn = self.tbDataValue.bPreUpdateOn or 1
  self.tbDataValue.nSpeedLimit = self.tbDataValue.nSpeedLimit or 50
  self:__SetPreUpdateSpeedLimit()
end

function tbPreUpdate:OnShowPreUpdateCfg()
  Ui(Ui.UI_SYSTEM):PreUpdateShowCfg(self.tbDataValue.bPreUpdateOn, self.tbDataValue.nSpeedLimit)
end

function tbPreUpdate:GetCurSpeed()
  return math.floor(GetPreUpdateCurSpeed() / 1024) --KB/S
end

--  nPercent表示下载进度 0表示开始更新 100表示更新完毕
function tbPreUpdate:ShowDownLoadStatus(nPercent)
  if 0 == nPercent then
    -- 弹出开始泡泡
    Ui.tbLogic.tbPopMgr:ShowPopTip(120)
    me.CallServerScript({ "PreUpdateLog", "preupdate begin" })
  elseif 100 == nPercent then
    -- 弹出结束泡泡
    Ui.tbLogic.tbPopMgr:ShowPopTip(121)
    me.CallServerScript({ "PreUpdateLog", "preupdate finish" })
  end
end

function tbPreUpdate:ShowMergeBaseLog(szMergeLog)
  me.CallServerScript({ "PreUpdateLog", szMergeLog })
end

function tbPreUpdate:UsePreUpdate()
  me.CallServerScript({ "PreUpdateLog", "UsePreUpdate" })
end

function tbPreUpdate:SetPreUpdateSpeedLimit(nSpeedLimit)
  self.tbDataValue.nSpeedLimit = nSpeedLimit
  if self.tbDataValue.bPreUpdateOn == 1 then
    SetPreUpdateSpeedLimit(nSpeedLimit * 1024)
  end
  Ui(Ui.UI_SYSTEM):PreUpdateShowMaxSpeed(nSpeedLimit)
  tbSaveData:Save(self.DATA_KEY, self.tbDataValue)
end

function tbPreUpdate:SetPreUpdateOn(bPreUpdateOn)
  --  self.tbDataValue = self.tbDataValue or {};
  if self.tbDataValue.bPreUpdateOn == bPreUpdateOn then
    return
  end

  self.tbDataValue.bPreUpdateOn = bPreUpdateOn
  self:__SetPreUpdateSpeedLimit()
  tbSaveData:Save(self.DATA_KEY, self.tbDataValue)
end

function tbPreUpdate:__SetPreUpdateSpeedLimit()
  if self.tbDataValue.bPreUpdateOn == 0 then
    SetPreUpdateSpeedLimit(0)
  else
    SetPreUpdateSpeedLimit(self.tbDataValue.nSpeedLimit * 1024)
  end
end
