-------------------------------------------------------
-- 文件名　：autofight.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-10-21 14:55:33
-- 文件描述：
-------------------------------------------------------

local uiAutoFight = Ui:GetClass("autofight")
local tbObject = Ui.tbLogic.tbObject
local tbAutoFightData = Ui.tbLogic.tbAutoFightData
local tbTempItem = Ui.tbLogic.tbTempItem
local tbMouse = Ui.tbLogic.tbMouse
local tbTimer = Ui.tbLogic.tbTimer

uiAutoFight.BUTTON_CLOSE = "BtnClose"
uiAutoFight.BUTTON_EXIT = "BtnExit"
uiAutoFight.BUTTON_SAVE = "BtnSave"
uiAutoFight.TXX_INFOR = "TxtExInFor"
uiAutoFight.BUTTON_AUTOFIGHT = "BtnAutoFight"
uiAutoFight.BUTTON_PICKITEM = "BtnPickItem"
uiAutoFight.TXT_PICKITEMSTAR = "TxtPickItemStar"
uiAutoFight.TXT_LIFE = "TxtLife"
uiAutoFight.TXT_LIFE = "TxtLife"
uiAutoFight.OBJ_SkILL = "ObjSkill"
uiAutoFight.PAGE = "Page"
uiAutoFight.SCROLL_ITEMSTAR = "ScrbarItemStar"
uiAutoFight.SCROLL_LIFE = "ScrbarLife"
uiAutoFight.DATA_KEY = "AutoFight"
uiAutoFight.OBJ_SkILL_ROW = 2
uiAutoFight.OBJ_SkILL_LINE = 1
uiAutoFight.BUTTON_TEAM = "BtnTeam"
uiAutoFight.BUTTON_REPAIR = "BtnRepair"
uiAutoFight.BUTTON_DRINK = "BtnDrink"

uiAutoFight.BUTTON_PVP_MODE = "BtnPvpMode"
uiAutoFight.BUTTON_AUTO_MED = "BtnAutoMed"
uiAutoFight.OBJ_MEDICAMENT = "ObjMedicament"
uiAutoFight.OBJ_MEDICAMENT_ROW = 2
uiAutoFight.OBJ_MEDICAMENT_LINE = 1

-- 不显示CD特效，不可使用，不可链接
local tbObjMedicamentCont = { bShowCd = 0, bUse = 0, bLink = 0 }
local tbObjSkillCont = { bShowCd = 0, bUse = 0, bLink = 0, bSwitch = 0 }

function uiAutoFight:Init()
  self.bAutoFight = 0
  self.bPickItem = 0
  --	self.nAcceptTeam	= 0;
  self.nAutoRepair = 0
  self.nPickStar = 0
  --self.nLifeRet		= 0;
  self.nLeftSkillId = 0
  self.nRightSkillId = 0
  self.nAutoDrink = 0
  self.tbFightSetting = {}
  self.nPvpMode = 0
  --self.tbLeftMed	= nil;
  --self.tbRightMed	= nil;
end

function uiAutoFight:OnCreate()
  self.tbObjSkillCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_SkILL, self.OBJ_SkILL_ROW, self.OBJ_SkILL_LINE, tbObjSkillCont)
  self.tbObjMedicamentCont = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_MEDICAMENT, self.OBJ_MEDICAMENT_ROW, self.OBJ_MEDICAMENT_LINE, tbObjMedicamentCont)
end

function uiAutoFight:OnDestroy()
  tbObject:UnregContainer(self.tbObjSkillCont)
  tbObject:UnregContainer(self.tbObjMedicamentCont)
end

function uiAutoFight:OnObjGridSwitch(szWnd, nX, nY)
  if szWnd == self.OBJ_SkILL then
    if nX == 0 then
      UiManager:SwitchWindow(Ui.UI_SKILLTREE, "AUTOLEFTSKILL")
    elseif nX == 1 then
      UiManager:SwitchWindow(Ui.UI_SKILLTREE, "AUTORIGHTSKILL")
    end
  end
end

function uiAutoFight:OnOpen()
  self:LoadSetting()
  self.bAutoFight = me.nAutoFightState
  self:UpdateWnd()
  local szText = "<a=infor>功能说明<a>"
  TxtEx_SetText(self.UIGROUP, self.TXX_INFOR, szText)
end

function uiAutoFight:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE or szWnd == self.BUTTON_EXIT then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_SAVE then
    self:SaveData()
    self:UpdateAction()
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_AUTOFIGHT then
    self.bAutoFight = nParam
  elseif szWnd == self.BUTTON_PVP_MODE then
    self.nPvpMode = nParam
  elseif szWnd == self.BUTTON_AUTO_MED then
    if nParam == 1 then
      self:StartAutoMed()
    elseif nParam == 0 then
      self:StopAutoMed()
    end
  elseif szWnd == self.BUTTON_PICKITEM then
    self.bPickItem = nParam

  --	elseif szWnd == self.BUTTON_TEAM then
  --		self.nAcceptTeam = nParam;
  elseif szWnd == self.BUTTON_REPAIR then
    self.nAutoRepair = nParam
  elseif szWnd == self.BUTTON_DRINK then
    self.nAutoDrink = nParam
  end
end

function uiAutoFight:SaveData()
  if self.tbObjMedicamentCont.tbMedInfo then
    self.tbLeftMed = self.tbObjMedicamentCont.tbMedInfo[1]
    self.tbRightMed = self.tbObjMedicamentCont.tbMedInfo[2]
  end

  self.tbFightSetting = {
    nUnPickCommonItem = self.bPickItem,
    nPickValue = self.nPickStar,
    nLifeRet = self.nLifeRet,
    nSkill1 = self.nLeftSkillId,
    nSkill2 = self.nRightSkillId,
    nAutoRepair = self.nAutoRepair,
    --		nAcceptTeam 		= self.nAcceptTeam,
    nAutoDrink = self.nAutoDrink,
    nPvpMode = self.nPvpMode,
    tbLeftMed = self.tbLeftMed,
    tbRightMed = self.tbRightMed,
  }

  me.SetAutoTarget(self.nPvpMode)
  tbAutoFightData:Save(self.tbFightSetting)
end

-- 超链接点击
function uiAutoFight:Link_infor_OnClick(szWnd, szLinkData)
  local tbOpt = {
    { "自动切换技能打怪", self.HelpDialog, self, 1 },
    { "pvp模式", self.HelpDialog, self, 2 },
    { "自动连续吃药", self.HelpDialog, self, 3 },
    { "为什么提供自动战斗功能", self.HelpDialog, self, 4 },
    { "结束对话" },
  }
  Dialog:Say("自动战斗使用帮助", tbOpt)
end

function uiAutoFight:HelpDialog(nIndex)
  tbTimer:Register(3, self.OnHelpDialog, self, nIndex)
end

function uiAutoFight:OnHelpDialog(nIndex)
  local tbOpt = {
    [1] = "<color=yellow>1 自动切换技能打怪<color><enter><enter>    自动战斗支持最多3个技能切换使用，攻击时会依次尝试使用“攻击技能设置”栏内的两个技能和左键技能，若该技能处于cd中，则使用下一个技能；若技能释放成功，便不会尝试后面的技能,而会又重头开始重复上述过程。<enter>    如果想要循环使用多个技能，最好将使用间隔最长或威力大的技能设在前面。如剑昆仑，3个技能依次设为“雷动九天”，“天际迅雷”和“狂雷震地”。",
    [2] = "<color=yellow>2 pvp模式<color><enter><enter>    由于部分门派路线pk时需要释放的技能较多，而快捷键吃药和使用技能有一定程度上的冲突，所以我们新增了自动战斗的pvp模式，可以使用自动战斗来辅助操作，勾选pvp模式复选框后再开启自动战斗，只要左键点击敌人，既可使用自动战斗设置的“连招”来攻击敌人，也不会有各种针对于打怪的打坐，反击，跑回自动战斗开始点等妨碍pk的行为。",
    [3] = "<color=yellow>3 自动连续吃药<color><enter><enter>    通常情况的自动战斗，当角色血量低于设置的百分比时，便会使用1个药物，当药效消失后才会使用下一个，而勾选了自动连续吃药选项后，则会连续使用设置的药物直到血量比例超过设置的百分比。<enter>主要在pk情况下使用，当然，技巧熟练的玩家吃药会比自动吃药节约不少。",
    [4] = "为什么提供了自动战斗功能？<enter><enter>    <color=red>1 让大家健康游戏，减少疲劳<color><enter>    我们希望通过自动战斗功能减少大家打怪练级的枯燥感，让大家有更好地游戏体验。<enter>    自动战斗是一个基本功能，绝不会通过这个功能收取任何费用,请大家安心使用！<enter>    <color=red>2 自动战斗不是外挂，绝不鼓励大家挂机离开电脑<color><enter>    游戏一定要自己亲自来玩才会更有乐趣，自动战斗仅是为了解放大家双手，但要想玩好，仍然是需要在电脑前保持对游戏的关注。",
  }
  Dialog:Say(tbOpt[nIndex])
  return 0
end

function uiAutoFight:OnScorllbarPosChanged(szWnd, nParam)
  if szWnd == self.SCROLL_ITEMSTAR then
    local nStar = nParam
    self.nPickStar = nStar / 2
  elseif szWnd == self.SCROLL_LIFE then
    local nLifeRet = nParam * 10
    self.nLifeRet = nLifeRet
  end
  self:UpdateLable()
end

-- 更新打怪设置
function uiAutoFight:UpdateAction()
  local tbAutoAiCfg = {
    nAutoFight = self.bAutoFight,
    nUnPickCommonItem = self.bPickItem,
    nPickValue = self.nPickStar,
    nLifeRet = self.nLifeRet,
    nSkill1 = self.nLeftSkillId,
    nSkill2 = self.nRightSkillId,
    nAutoRepair = self.nAutoRepair,
    --		nAcceptTeam		  	= self.nAcceptTeam,
    nAutoDrink = self.nAutoDrink,
    nPvpMode = self.nPvpMode,
    tbLeftMed = self.tbLeftMed,
    tbRightMed = self.tbRightMed,
  }
  AutoAi:UpdateCfg(tbAutoAiCfg)
end

function uiAutoFight:UpdateLable()
  Txt_SetTxt(self.UIGROUP, self.TXT_PICKITEMSTAR, "拾取不低于" .. self.nPickStar .. "星装备")
  if UiVersion == Ui.Version001 then
    Txt_SetTxt(self.UIGROUP, self.TXT_LIFE, "生命值低于" .. self.nLifeRet .. "%时候使用药物")
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_LIFE, "生命低于" .. self.nLifeRet .. "%时使用药物")
  end
end

-- 更新界面显示
function uiAutoFight:UpdateWnd()
  Btn_Check(self.UIGROUP, self.BUTTON_AUTOFIGHT, self.bAutoFight)
  Btn_Check(self.UIGROUP, self.BUTTON_PICKITEM, self.bPickItem)

  --	Btn_Check(self.UIGROUP, self.BUTTON_TEAM, self.nAcceptTeam);
  Btn_Check(self.UIGROUP, self.BUTTON_REPAIR, self.nAutoRepair)

  --	Btn_Check(self.UIGROUP, self.BUTTON_TEAM, self.nAcceptTeam);
  Btn_Check(self.UIGROUP, self.BUTTON_DRINK, self.nAutoDrink)

  ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_ITEMSTAR, self.nPickStar * 2)
  ScrBar_SetCurValue(self.UIGROUP, self.SCROLL_LIFE, self.nLifeRet / 10)
  self:UpdateLable()

  self.tbObjSkillCont:ClearObj()
  local tbLeftObj = nil
  tbLeftObj = {}
  tbLeftObj.nType = Ui.OBJ_FIGHTSKILL
  tbLeftObj.nSkillId = self.nLeftSkillId
  self.tbObjSkillCont:SetObj(tbLeftObj, 0, 0)

  local tbRightObj = nil
  tbRightObj = {}
  tbRightObj.nType = Ui.OBJ_FIGHTSKILL
  tbRightObj.nSkillId = self.nRightSkillId
  self.tbObjSkillCont:SetObj(tbRightObj, 1, 0)

  Btn_Check(self.UIGROUP, self.BUTTON_PVP_MODE, self.nPvpMode)
  Btn_Check(self.UIGROUP, self.BUTTON_AUTO_MED, self.nAutoMed or 0)

  -- 设置两种药
  for nPos = 0, 1 do
    local tbObj = self.tbObjMedicamentCont:GetObj(nPos)
    if tbObj and (tbObj.nType == Ui.OBJ_TEMPITEM) then
      self.tbObjMedicamentCont:SetObj(nil, nPos)
      self.tbObjMedicamentCont:DestroyTempItem(tbObj)
    end
  end

  self.tbObjMedicamentCont:ClearObj()

  if self.tbLeftMed then
    local tbLeftMedObj = self.tbObjMedicamentCont:LoadMedObj(self.tbLeftMed)
    self.tbObjMedicamentCont:SetObj(tbLeftMedObj, 0, 0)
  end

  if self.tbRightMed then
    local tbRightMedObj = self.tbObjMedicamentCont:LoadMedObj(self.tbRightMed)
    self.tbObjMedicamentCont:SetObj(tbRightMedObj, 1, 0)
  end
end

function uiAutoFight:LoadSetting()
  self.tbFightSetting = tbAutoFightData:Load()
  if self.tbFightSetting then
    self.bPickItem = self.tbFightSetting.nUnPickCommonItem
    self.nPickStar = self.tbFightSetting.nPickValue
    self.nLifeRet = self.tbFightSetting.nLifeRet
    self.nLeftSkillId = self.tbFightSetting.nSkill1
    self.nRightSkillId = self.tbFightSetting.nSkill2
    self.nAutoRepair = self.tbFightSetting.nAutoRepair
    --		self.nAcceptTeam 	= self.tbFightSetting.nAcceptTeam;
    self.nAutoDrink = self.tbFightSetting.nAutoDrink
    self.nPvpMode = self.tbFightSetting.nPvpMode
    self.tbLeftMed = self.tbFightSetting.tbLeftMed
    self.tbRightMed = self.tbFightSetting.tbRightMed
  end
end

function uiAutoFight:OnClose()
  self.tbObjSkillCont:ClearObj()

  for nPos = 0, 1 do
    local tbObj = self.tbObjMedicamentCont:GetObj(nPos)
    if tbObj and (tbObj.nType == Ui.OBJ_TEMPITEM) then
      self.tbObjMedicamentCont:SetObj(nil, nPos)
      self.tbObjMedicamentCont:DestroyTempItem(tbObj)
    end
  end

  self.tbObjMedicamentCont:ClearObj()
end

function uiAutoFight:UpdateSkill(nLeftSkillId, nRightSkillId)
  if nLeftSkillId and nLeftSkillId > 0 then
    self.nLeftSkillId = nLeftSkillId
  end

  if nRightSkillId and nRightSkillId > 0 then
    self.nRightSkillId = nRightSkillId
  end
  self:UpdateWnd()
end

function uiAutoFight:OnChangeFactionFinished()
  if UiManager:WindowVisible(Ui.UI_AUTOFIGHT) == 1 then
    self:SaveData()
    tbAutoFightData:OnChangeFactionFinished()
    self:OnOpen()
  else
    tbAutoFightData:OnChangeFactionFinished()
  end
end

function uiAutoFight:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emUIEVENT_SELECT_SKILL, self.UpdateSkill },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem },
    { UiNotify.emCOREEVENT_CHANGE_FACTION_FINISHED, self.OnChangeFactionFinished },
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjSkillCont:RegisterEvent())
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjMedicamentCont:RegisterEvent())
  return tbRegEvent
end

function uiAutoFight:RegisterMessage()
  local tbRegMsg = {}
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjSkillCont:RegisterMessage())
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjMedicamentCont:RegisterMessage())
  return tbRegMsg
end

function uiAutoFight:OnSyncItem(nRoom, nX, nY)
  for nPos = 0, 1 do
    self.tbObjMedicamentCont:Update(nPos)
  end
end

-- 格式化物件
function tbObjMedicamentCont:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end

  tbObj.szBgImage = pItem.szIconImage
  tbObj.szCdSpin = self.CDSPIN_MEDIUM
  tbObj.szCdFlash = self.CDFLASH_MEDIUM

  tbObj.bShowSubScript = 1
  return tbObj
end

-- 更新物件
function tbObjMedicamentCont:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem
  local nCount = me.GetSameItemCountInBags(pItem)

  ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(nCount), nX, nY)
  self:UpdateItemCd(pItem.nCdType)
end

-- 鼠标拾起事件
function tbObjMedicamentCont:PickMouse(tbObj, nX, nY)
  self:SetObj(nil, nX, nY)
  self:SaveMedObj(nX)

  return 1
end

-- 鼠标交换事件
function tbObjMedicamentCont:SwitchMouse(tbMouseObj, tbObj, nX, nY)
  if self:CheckObj(tbMouseObj) ~= 1 then
    me.Msg("该物品不能放入药品设置栏！")
    return 0
  end

  self:PickMouse(tbObj, nX, nY)

  if tbObj.nType == Ui.OBJ_TEMPITEM then
    self:DestroyTempItem(tbObj)
  end

  self:DropMouse(tbMouseObj, nX, nY)

  return 1
end

-- 鼠标放落事件
function tbObjMedicamentCont:DropMouse(tbMouseObj, nX, nY)
  if self:CheckObj(tbMouseObj) ~= 1 then
    me.Msg("该物品不能放入药品设置栏！")
    return 0
  end

  if tbMouseObj.nType == Ui.OBJ_OWNITEM then
    local pItem = me.GetItem(tbMouseObj.nRoom, tbMouseObj.nX, tbMouseObj.nY)
    if not pItem then
      return 0
    end

    local tbObj = self:CreateTempItem(pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, pItem.nSeries)
    self:SetObj(tbObj, nX, nY)

    tbMouse:ResetObj()
  elseif tbMouseObj.nType == Ui.OBJ_TEMPITEM then
    tbMouse:SetObj(nil)
    self:SetObj(tbMouseObj, nX, nY)
  else
    return 0
  end

  self:SaveMedObj(nX)

  return 1
end

-- 判断物件是否可以放入
function tbObjMedicamentCont:CheckObj(tbObj)
  if tbObj.nType == Ui.OBJ_OWNITEM then
    local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
    if pItem and pItem.CanBeShortcut() == 1 then
      return 1
    end
  elseif tbObj.nType == Ui.OBJ_TEMPITEM then
    if tbObj.pItem.CanBeShortcut() == 1 then
      return 1
    end
  end

  return 0
end

-- 创建临时物件
function tbObjMedicamentCont:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nSeries)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, nSeries)
  if not pItem then
    return
  end

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem

  return tbObj
end

-- 删除临时物件
function tbObjMedicamentCont:DestroyTempItem(tbObj)
  if tbObj.nType ~= Ui.OBJ_TEMPITEM then
    return tbObj
  end

  tbTempItem:Destroy(tbObj.pItem)
  return nil
end

-- 载入物件
function tbObjMedicamentCont:LoadMedObj(tbMedInfo)
  if not tbMedInfo then
    return nil
  end

  local nGenre = Lib:LoadBits(tbMedInfo.nLow, 0, 15)
  local nDetail = Lib:LoadBits(tbMedInfo.nLow, 16, 31)
  local nParticular = Lib:LoadBits(tbMedInfo.nHigh, 0, 15)
  local nLevel = Lib:LoadBits(tbMedInfo.nHigh, 16, 23)
  local nSeries = Lib:LoadBits(tbMedInfo.nHigh, 24, 31)

  return self:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nSeries)
end

-- 保存GDPLS为两个数
function tbObjMedicamentCont:SaveMedObj(nPosition)
  if not self.tbMedInfo then
    self.tbMedInfo = {}
  end

  local tbObj = self:GetObj(nPosition)
  if tbObj and tbObj.nType == Ui.OBJ_TEMPITEM then
    local pItem = tbObj.pItem
    local nLow = Lib:SetBits(pItem.nGenre, pItem.nDetail, 16, 31)
    local nHigh = Lib:SetBits(pItem.nParticular, pItem.nLevel, 16, 23)
    nHigh = Lib:SetBits(nHigh, pItem.nSeries, 24, 31)
    self.tbMedInfo[nPosition + 1] = { nLow = nLow, nHigh = nHigh }
  else
    self.tbMedInfo[nPosition + 1] = nil
  end
end

-- 开启自动吃药
function uiAutoFight:StartAutoMed()
  if not self.tbFightSetting or #self.tbFightSetting <= 0 then
    self:LoadSetting()
  end

  if not self.nAutoMed or self.nAutoMed == 0 then
    self.nTimerID = tbTimer:Register(3, self.OnTimerAutoMed, self)
    me.Msg("<color=orange>开始自动吃药<pic=99>")
    me.Msg("<color=green>当前吃药血量设置百分比：<color=yellow>" .. self.nLifeRet .. "%<color=green>")

    if not self.tbLeftMed and not self.tbRightMed then
      me.Msg("<color=yellow>警告：您还没有设置自动使用的药品！<color>")
    else
      local tbFindLeft, nLeftCount = self:GetMedObj(self.tbLeftMed)
      if tbFindLeft and nLeftCount >= 1 then
        me.Msg("<color=green>自动使用：<color=yellow>" .. tbFindLeft[1].pItem.szName .. "<color=green>，剩余：<color=yellow>" .. nLeftCount .. "<color=green>个。")
      end

      local tbFindRight, nRightCount = self:GetMedObj(self.tbRightMed)
      if tbFindRight and nRightCount >= 1 then
        me.Msg("<color=green>备用药品：<color=yellow>" .. tbFindRight[1].pItem.szName .. "<color=green>，剩余：<color=yellow>" .. nRightCount .. "<color=green>个。")
      end

      if nLeftCount + nRightCount >= 0 and nLeftCount + nRightCount < 10 then
        Ui(Ui.UI_TASKTIPS):Begin("<color=yellow>警告：自动使用的药物数量过少，危险！<color>")
      end
    end

    self.nAutoMed = 1
  elseif self.nAutoMed == 1 then
    self:StopAutoMed()
  end
end

-- 关闭自动吃药
function uiAutoFight:StopAutoMed()
  if self.nTimerID and self.nTimerID > 0 then
    tbTimer:Close(self.nTimerID)
    self.nTimerID = 0
    self.nAutoMed = 0
    me.Msg("<color=orange>停止自动吃药<pic=88>")
  end
end

-- 获取物品GDPLS
function uiAutoFight:GetMedObj(tbMedInfo)
  if not tbMedInfo then
    return nil, 0
  end

  local nGenre = Lib:LoadBits(tbMedInfo.nLow, 0, 15)
  local nDetail = Lib:LoadBits(tbMedInfo.nLow, 16, 31)
  local nParticular = Lib:LoadBits(tbMedInfo.nHigh, 0, 15)
  local nLevel = Lib:LoadBits(tbMedInfo.nHigh, 16, 23)
  local nSeries = Lib:LoadBits(tbMedInfo.nHigh, 24, 31)

  local tbFind = me.FindItemInBags(nGenre, nDetail, nParticular, nLevel, nSeries)
  local nCount = me.GetItemCountInBags(nGenre, nDetail, nParticular, nLevel)

  return tbFind, nCount
end

-- 定时器
function uiAutoFight:OnTimerAutoMed()
  if me.nCurLife * 100 / me.nMaxLife < self.nLifeRet then
    local tbFindLeft, nLeftCount = self:GetMedObj(self.tbLeftMed)
    local tbFindRight, nRightCount = self:GetMedObj(self.tbRightMed)

    if tbFindLeft and nLeftCount >= 1 then
      me.UseItem(tbFindLeft[1].pItem)
    elseif tbFindRight and nRightCount >= 1 then
      me.UseItem(tbFindRight[1].pItem)
    end

    if nLeftCount + nRightCount > 0 and nLeftCount + nRightCount < 10 then
      Ui(Ui.UI_TASKTIPS):Begin("<color=yellow>警告：自动使用的药物数量过少，危险！<color>")
    end
  end

  return 3
end
