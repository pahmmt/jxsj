-----------------------------------------------------
--文件名		：	buffbar.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	玩家Buff
------------------------------------------------------

local uiBuffBar = Ui:GetClass("buffbar")
local tbObject = Ui.tbLogic.tbObject

uiBuffBar.OBJ_BUFFS = "ObjBuffs"
uiBuffBar.OBJ_DEBUFFS = "ObjDeBuffs"
uiBuffBar.nBuffCount = 0
uiBuffBar.nDeBuffCount = 0
uiBuffBar.MAX_BUFF = 16 -- 增益buff和减益buff最多各这么多个

local tbBuffsCont = { bShowCd = 1, bUse = 0, bLink = 0, bSwitch = 0 } -- 不允许链接操作
local tbDeBuffsCont = { bShowCd = 1, bUse = 0, bLink = 0, bSwitch = 0 } -- 不允许链接操作

function uiBuffBar:OnOpen()
  self:Update()
end

function uiBuffBar:OnCreate()
  self.tbBuffsCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_BUFFS, self.MAX_BUFF, 1, tbBuffsCont)
  self.tbDeBuffsCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_DEBUFFS, self.MAX_BUFF, 1, tbDeBuffsCont)
end

function uiBuffBar:OnDestroy()
  tbObject:UnregContainer(self.tbBuffsCont)
  tbObject:UnregContainer(self.tbDeBuffsCont)
end

function uiBuffBar:Update()
  local tbBuffList = me.GetBuffList()
  self.nBuffCount = 0
  self.nDeBuffCount = 0
  self.tbBuffsCont:ClearObj()
  self.tbDeBuffsCont:ClearObj()

  local nMax = #tbBuffList
  for i = nMax, 1, -1 do
    self:AddBuff(tbBuffList[i])
  end
end

function uiBuffBar:AddBuff(tbBuff)
  if tbBuff.bHelpful == 1 and self.nBuffCount < self.MAX_BUFF then
    local tbBuffer = {}
    tbBuffer.nType = Ui.OBJ_BUFF
    tbBuffer.nBuffId = tbBuff.uId
    self.tbBuffsCont:SetObj(tbBuffer, self.MAX_BUFF - self.nBuffCount - 1, 0)
    self.nBuffCount = self.nBuffCount + 1
  elseif tbBuff.bHelpful == 0 and self.nDeBuffCount < self.MAX_BUFF then
    local tbDeBuffer = {}
    tbDeBuffer.nType = Ui.OBJ_BUFF
    tbDeBuffer.nBuffId = tbBuff.uId
    self.tbDeBuffsCont:SetObj(tbDeBuffer, self.MAX_BUFF - self.nDeBuffCount - 1, 0)
    self.nDeBuffCount = self.nDeBuffCount + 1
  end
end

function uiBuffBar:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_BUFF_CHANGE, self.Update },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbBuffsCont:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbDeBuffsCont:RegisterEvent())
  return tbRegEvent
end

function uiBuffBar:RegisterMessage()
  local tbRegMsg = Lib:MergeTable(self.tbBuffsCont:RegisterMessage(), self.tbDeBuffsCont:RegisterMessage())
  return tbRegMsg
end
