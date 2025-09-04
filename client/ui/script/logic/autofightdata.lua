Ui.tbLogic.tbAutoFightData = {}
local tbAutoFightData = Ui.tbLogic.tbAutoFightData
local tbSaveData = Ui.tbLogic.tbSaveData

tbAutoFightData.DATA_KEY = "AutoFight"
tbAutoFightData.FACTION_TAG = "_FACTION_"
function tbAutoFightData:Init()
  self.bAutoFight = 0
  self.bPickItem = 0
  self.nPickStar = 0
  self.nLifeRet = 50
  self.nLeftSkillId = 0
  self.nRightSkillId = 0
  --	self.nAcceptTeam = 0;
  self.nAutoRepair = 0
  self.nAutoDrink = 0
  self.LoadData = {}
  self.tbData = {}
  -- by zhangjinpin@kingsoft
  self.nPvpMode = 0
  self.tbLeftMed = nil
  self.tbRightMed = nil
end

function tbAutoFightData:Load()
  self:Init()
  local tbFightSetting = tbSaveData:Load(self.DATA_KEY)

  if tbFightSetting.nUnPickCommonItem then
    self.bPickItem = tbFightSetting.nUnPickCommonItem
  end

  if tbFightSetting.nPickValue then
    self.nPickStar = tbFightSetting.nPickValue
  end

  if tbFightSetting.nLifeRet then
    self.nLifeRet = tbFightSetting.nLifeRet
  end

  if tbFightSetting.nSkill1 then
    self.nLeftSkillId = tbFightSetting.nSkill1
  end

  if tbFightSetting.nSkill2 then
    self.nRightSkillId = tbFightSetting.nSkill2
  end

  --	if tbFightSetting.nAcceptTeam then
  --		self.nAcceptTeam = tbFightSetting.nAcceptTeam;
  --	end

  if tbFightSetting.nAutoRepair then
    self.nAutoRepair = tbFightSetting.nAutoRepair
  end

  if tbFightSetting.nAutoDrink then
    self.nAutoDrink = tbFightSetting.nAutoDrink
  end

  -- by zhangjinpin@kingsoft
  if tbFightSetting.nPvpMode then
    self.nPvpMode = tbFightSetting.nPvpMode
  end

  if tbFightSetting.tbLeftMed then
    self.tbLeftMed = tbFightSetting.tbLeftMed
  end

  if tbFightSetting.tbRightMed then
    self.tbRightMed = tbFightSetting.tbRightMed
  end
  -- end

  tbFightSetting = {
    nUnPickCommonItem = self.bPickItem,
    nPickValue = self.nPickStar,
    nLifeRet = self.nLifeRet,
    nSkill1 = self.nLeftSkillId,
    nSkill2 = self.nRightSkillId,
    --		nAcceptTeam = self.nAcceptTeam,
    nAutoRepair = self.nAutoRepair,
    nAutoDrink = self.nAutoDrink,
    -- by zhangjinpin@kingsoft
    nPvpMode = self.nPvpMode,
    tbLeftMed = self.tbLeftMed,
    tbRightMed = self.tbRightMed,
  }

  self.LoadData = tbFightSetting
  return self.LoadData
end

function tbAutoFightData:ShortKey()
  self:Load()

  if me.nAutoFightState == 0 then
    self.bAutoFight = 1
  else
    self.bAutoFight = 0
  end

  me.SetAutoTarget(self.nPvpMode)

  local tbData = self.LoadData
  tbData.nAutoFight = self.bAutoFight

  return tbData
end

function tbAutoFightData:Save(tbFightSetting)
  tbSaveData:Save(self.DATA_KEY, tbFightSetting)
end

function tbAutoFightData:OnChangeFactionFinished()
  local nPrevFaction = Faction:GetPrevFaction(me)
  if nPrevFaction == nil then
    return
  end

  local tbFightSettingOld = tbSaveData:Load(self.DATA_KEY)
  tbSaveData:Save(self.DATA_KEY .. self.FACTION_TAG .. tostring(nPrevFaction), tbFightSettingOld)
  local tbFightSettingNew = tbSaveData:Load(self.DATA_KEY .. self.FACTION_TAG .. tostring(me.nFaction))
  tbSaveData:Save(self.DATA_KEY, tbFightSettingNew)
end
