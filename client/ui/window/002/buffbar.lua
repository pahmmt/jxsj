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

function uiBuffBar:OnOpen(nFlag)
  self:Update(nFlag)
end

function uiBuffBar:OnCreate()
  self.tbBuffsCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_BUFFS, self.MAX_BUFF, 1, tbBuffsCont)
  self.tbDeBuffsCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_DEBUFFS, self.MAX_BUFF, 1, tbDeBuffsCont)
end

function uiBuffBar:OnDestroy()
  tbObject:UnregContainer(self.tbBuffsCont)
  tbObject:UnregContainer(self.tbDeBuffsCont)
end

function uiBuffBar:Update(nFlag)
  local tbBuffList = me.GetBuffList()
  self.nBuffCount = 0
  self.nDeBuffCount = 0
  self.tbBuffsCont:ClearObj()
  self.tbDeBuffsCont:ClearObj()
  local nMax = #tbBuffList
  local nBuffCount = 0
  local nDeBuffCount = 0
  for i = nMax, 1, -1 do
    if tbBuffList[i].bHelpful == 1 and nBuffCount < self.MAX_BUFF then
      nBuffCount = nBuffCount + 1
    elseif tbBuffList[i].bHelpful == 0 and nDeBuffCount < self.MAX_BUFF then
      nDeBuffCount = nDeBuffCount + 1
    end
  end
  Wnd_SetSize(self.UIGROUP, self.OBJ_BUFFS, 29 * nBuffCount, 26)
  Wnd_SetSize(self.UIGROUP, self.OBJ_DEBUFFS, 29 * nDeBuffCount, 26)
  for i = nMax, 1, -1 do
    self:AddBuff(tbBuffList[i])
  end
  if nFlag ~= 1 and UiManager:WindowVisible(self.UIGROUP) == 1 then
    UiManager:OpenWindow(Ui.UI_BUFFBAR, 1) -- 重新打开一遍窗口就能看到了
  end
end

function uiBuffBar:AddBuff(tbBuff)
  if tbBuff.bHelpful == 1 and self.nBuffCount < self.MAX_BUFF then
    local tbBuffer = {}
    tbBuffer.nType = Ui.OBJ_BUFF
    tbBuffer.nBuffId = tbBuff.uId
    self.tbBuffsCont:SetObj(tbBuffer, self.nBuffCount, 0)
    self.nBuffCount = self.nBuffCount + 1
  elseif tbBuff.bHelpful == 0 and self.nDeBuffCount < self.MAX_BUFF then
    local tbDeBuffer = {}
    tbDeBuffer.nType = Ui.OBJ_BUFF
    tbDeBuffer.nBuffId = tbBuff.uId
    self.tbDeBuffsCont:SetObj(tbDeBuffer, self.nDeBuffCount, 0)
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
