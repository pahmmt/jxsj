-----------------------------------------------------
--文件名		：	viewplayer.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	查看玩家装备界面
------------------------------------------------------

local uiViewPlayer = Ui:GetClass("viewplayer")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr
local tbViewPlayerMgr = Ui.tbLogic.tbViewPlayerMgr

uiViewPlayer.PAGESET_MAIN = "PageSetMain"
uiViewPlayer.BTNCLOSE = "BtnClose"
uiViewPlayer.PAGEBASIC = "PageBasic"
uiViewPlayer.PAGEHISTORY = "PageHistory"
uiViewPlayer.BTNBASIC = "BtnBasic"
uiViewPlayer.BTNHISTORY = "BtnHistory"
uiViewPlayer.IMGPORTRAIT = "ImgPortrait"
uiViewPlayer.TXTBASICINFO = "TxtBasicInfo"
uiViewPlayer.TXTHISTROYNAME = "TxtHistroyName"
uiViewPlayer.TXTHISTROY = "TxtHistroy"
uiViewPlayer.BTNNORMALHISTROY = "BtnNormalHistroy"
uiViewPlayer.BTNHISTORYTASK = "BtnHistoryTask"
uiViewPlayer.BTNHISTORYCOMBAT = "BtnHistoryCombat"
uiViewPlayer.BTNVIEWSKILL = "BtnViewSkill"

uiViewPlayer.PAGESET_PARTNER = "PageSetPartner"
uiViewPlayer.PAGEPARTNER = "PagePartner"
uiViewPlayer.BTNPARTNER = "BtnPartner"
uiViewPlayer.TXTPARTNAME = "TxtPartName" -- 名字
uiViewPlayer.TXTSTARIMAGE = "TxtStar" -- 星级
uiViewPlayer.TXTSTRENGTH = "TxtStrength" -- 力量
uiViewPlayer.TXTVITALITY = "TxtVitality" -- 外功
uiViewPlayer.TXTDEXTERITY = "TxtDexterity" -- 身法
uiViewPlayer.TXTENERGY = "TxtEnergy" -- 内功
uiViewPlayer.TXTSKILLTITLE = "TxtSkillTitle"
uiViewPlayer.TXTFIGHTPOWER = "TxtFightPower"
uiViewPlayer.TXTALTERNAME = "TxtAlterName"

uiViewPlayer.IMGKINBADGE = "Img_KinBadge"

--uiViewPlayer.TXTPARTNEREQU = "TxtPartnerEquip";
uiViewPlayer.TB_TXTSKILLLEVEL = {} -- 技能下标控件数组
for i = 1, 10 do
  uiViewPlayer.TB_TXTSKILLLEVEL[i] = "TxtSKill" .. i .. "Level"
end

uiViewPlayer.PARTNERSKILL_ROW = 2
uiViewPlayer.PARTNERSKILL_COL = 5
uiViewPlayer.tbPartnerSkill = {}

local PAGE_BLOG = "BtnBlog"

local OBJ_EQUIP_PREVIEW = "ObjPreview"
local OBJ_PARTNER_SKILL_VIEW = "ObjPartnerSkillView"
local OBJ_PARTNER_EQUIP_VEIW = "ObjPartnerEquipView"
--local OBJ_PARTNER_PREVIEW	= "ObjPartnerView";

uiViewPlayer.EQUIPMENT = -- 装备控件表
  {
    { Item.EQUIPPOS_HEAD, "ObjHead", "ImgHead" },
    { Item.EQUIPPOS_BODY, "ObjBody", "ImgBody" },
    { Item.EQUIPPOS_BELT, "ObjBelt", "ImgBelt" },
    { Item.EQUIPPOS_WEAPON, "ObjWeapon", "ImgWeapon" },
    { Item.EQUIPPOS_FOOT, "ObjFoot", "ImgFoot" },
    { Item.EQUIPPOS_CUFF, "ObjCuff", "ImgCuff" },
    { Item.EQUIPPOS_AMULET, "ObjAmulet", "ImgAmulet" },
    { Item.EQUIPPOS_RING, "ObjRing", "ImgRing" },
    { Item.EQUIPPOS_NECKLACE, "ObjNecklace", "ImgNecklace" },
    { Item.EQUIPPOS_PENDANT, "ObjPendant", "ImgPendant" },
    { Item.EQUIPPOS_HORSE, "ObjHorse", "ImgHorse" },
    { Item.EQUIPPOS_MASK, "ObjMask", "ImgMask" },
    { Item.EQUIPPOS_BOOK, "ObjBook", "ImgBook" },
    { Item.EQUIPPOS_ZHEN, "ObjZhen", "ImgZhen" },
    { Item.EQUIPPOS_SIGNET, "ObjSignet", "ImgSignet" },
    { Item.EQUIPPOS_MANTLE, "ObjMantle", "ImgMantle" },
    { Item.EQUIPPOS_CHOP, "ObjChop", "ImgChop" },
    { Item.EQUIPPOS_ZHENYUAN_MAIN, "ObjZhenYuan", "ImgZhenYuan" },
    { Item.EQUIPPOS_ZHENYUAN_SUB1, "ObjZhenYuanSub1", "ImgZhenYuanSub1" },
    { Item.EQUIPPOS_ZHENYUAN_SUB2, "ObjZhenYuanSub2", "ImgZhenYuanSub2" },
    { Item.EQUIPPOS_GARMENT, "ObjGarment", "ImgGarment" },
    { Item.EQUIPPOS_OUTHAT, "ObjOutHat", "ImgOutHat" },
  }

uiViewPlayer.PARTNEREQUIP = -- 同伴装备控件列表
  {
    { Item.PARTNEREQUIP_WEAPON, "ObjPartWeapon", "ImgPartWeapon" }, -- 同伴装备--武器
    { Item.PARTNEREQUIP_BODY, "ObjPartBody", "ImgPartBody" }, -- 同伴装备--衣服
    { Item.PARTNEREQUIP_RING, "ObjPartRing", "ImgPartRing" }, -- 同伴装备--戒指
    { Item.PARTNEREQUIP_CUFF, "ObjPartCuff", "ImgPartCuff" }, -- 同伴装备--护腕
    { Item.PARTNEREQUIP_AMULET, "ObjPartAmulet", "ImgPartAmulet" }, -- 同伴装备--护身符
  }

function uiViewPlayer:OnCreate()
  self.tbEquipCont = {}
  for _, tb in ipairs(self.EQUIPMENT) do
    self.tbEquipCont[tb[1]] = tbObject:RegisterContainer(self.UIGROUP, tb[2], 1, 1, { bSwitch = 0, bShowCd = 0, bUse = 0 })
  end
  self.tbObjPreView = {}
  self.tbObjPreView = tbObject:RegisterContainer(self.UIGROUP, OBJ_EQUIP_PREVIEW)

  self.tbObjParnterSkillView = {}
  self.tbObjParnterSkillView = tbObject:RegisterContainer(self.UIGROUP, OBJ_PARTNER_SKILL_VIEW, 5, 2, { bShowCd = 1, bUse = 0, bLink = 0, bSwitch = 0 })

  self.tbObjPartnerEquipCont = {}
  for _, tb in pairs(self.PARTNEREQUIP) do
    self.tbObjPartnerEquipCont[tb[1]] = tbObject:RegisterContainer(self.UIGROUP, tb[2], 1, 1, { bSwitch = 0, bShowCd = 0, bUse = 0 })
  end
end

function uiViewPlayer:OnDestroy()
  for _, tbCont in pairs(self.tbEquipCont) do
    tbObject:UnregContainer(tbCont)
  end
  tbObject:UnregContainer(self.tbObjPreView)
  tbObject:UnregContainer(self.tbObjParnterSkillView)

  for _, tbCont in pairs(self.tbObjPartnerEquipCont) do
    tbObject:UnregContainer(tbCont)
  end
end

function uiViewPlayer:Init()
  self.nCurHistroyPage = 1
  self.nCurPage = 1
  self.tbPlayerInfo = nil
  self.nNpcId = 0
  self.tbPreViewPart = {
    [Npc.NPCRES_PART_HELM] = { nResId = 0, nChangeColorScheme = 0 },
    [Npc.NPCRES_PART_ARMOR] = { nResId = 0, nChangeColorScheme = 0 },
    [Npc.NPCRES_PART_WEAPON] = { nResId = 0, nChangeColorScheme = 0 },
  }
  --self.tbPreViewPart		= {};
end

function uiViewPlayer:OnOpen(...)
  local szRoleName, nLevel, nPkValue, nFaction, bSex, szMateName, nPortrait, nNpcId, nKinBadge, szAlterName = unpack(arg)
  if not szRoleName or not nLevel or not nPkValue or not nFaction or not bSex or not szMateName or not nPortrait or not nNpcId or not nKinBadge then
    return
  end
  self.nNpcId = nNpcId
  if self.nNpcId == 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTNVIEWSKILL, 0)
  end
  self:OnViewPlayer(szRoleName, nLevel, nPkValue, nFaction, bSex, szMateName, nPortrait, nKinBadge, szAlterName)
  self:OnUpdatePartnerEquip()

  if Player.tbFightPower:IsFightPowerValid() ~= 1 then
    Wnd_Hide(self.UIGROUP, self.TXTFIGHTPOWER)
  end
end

function uiViewPlayer:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTNCLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTNBASIC then
    self.nCurPage = 1
    self:Update()
  elseif szWnd == self.BTNHISTORY then
    self.nCurPage = 2
    self:Update()
  elseif szWnd == self.BTNPARTNER then
    self.nCurPage = 3
    self:Update()
  elseif szWnd == self.BTNNORMALHISTROY then
    self:OnUpdateHistroy(1)
  elseif szWnd == self.BTNHISTORYTASK then
    self:OnUpdateHistroy(2)
  elseif szWnd == self.BTNHISTORYCOMBAT then
    self:OnUpdateHistroy(3)
  elseif PAGE_BLOG == szWnd then
    UiManager:OpenWindow(Ui.UI_BLOGVIEWPLAYER, self.tbPlayerInfo[1])
  elseif self.BTNVIEWSKILL == szWnd then
    if self.nNpcId ~= 0 then
      ProcessNpcById(self.nNpcId, UiManager.emACTION_VIEWSKILL)
    end
  end
end

function uiViewPlayer:Update()
  if self.tbPlayerInfo == nil then
    return
  end

  if self.nCurPage == 1 then
    self:OnUpdateBasicInfo()
  elseif self.nCurPage == 2 then
    self:OnUpdateHistroy()
  end

  --me.CallServerScript({ "PartnerCmd", "ApplyViewPartnerInfo", self.nNpcId});
end

function uiViewPlayer:OnUpdateBasicInfo()
  self:UpdatePlayerInfo()
  self:UpdateEquipment()
end

function uiViewPlayer:OnUpdatePartner()
  if EventManager.IVER_bOpenPartner == 0 then
    Txt_SetTxt(self.UIGROUP, self.TXTPARTNAME, " ")
    Txt_SetTxt(self.UIGROUP, self.TXTSTRENGTH, " ")
    Txt_SetTxt(self.UIGROUP, self.TXTDEXTERITY, " ")
    Txt_SetTxt(self.UIGROUP, self.TXTVITALITY, " ")
    Txt_SetTxt(self.UIGROUP, self.TXTENERGY, " ")
    Txt_SetTxt(self.UIGROUP, self.TXTSKILLTITLE, " ")
    return 0
  end

  local pViewPartner = me.GetViewPartner()

  local szName = pViewPartner.szName
  local nPartnerTemp = pViewPartner.GetValue(Partner.emKPARTNERATTRIBTYPE_TEMPID)
  local nLevel = pViewPartner.GetValue(Partner.emKPARTNERATTRIBTYPE_LEVEL)
  local nStarLevel = Partner:GetSelfStartCount(pViewPartner)
  local tbPotential = {}
  for i = 1, 4 do
    tbPotential[i] = pViewPartner.GetAttrib(i - 1)
  end
  local tbSkills = {}
  for j = 1, pViewPartner.nSkillCount do
    table.insert(tbSkills, pViewPartner.GetSkill(j - 1))
  end

  Txt_SetTxt(self.UIGROUP, self.TXTPARTNAME, "同伴名称：" .. szName .. "  " .. nLevel .. "级")

  Txt_SetTxt(self.UIGROUP, self.TXTSTRENGTH, "增加力量：" .. tbPotential[1])
  Txt_SetTxt(self.UIGROUP, self.TXTDEXTERITY, "增加身法：" .. tbPotential[2])
  Txt_SetTxt(self.UIGROUP, self.TXTVITALITY, "增加外功：" .. tbPotential[3])
  Txt_SetTxt(self.UIGROUP, self.TXTENERGY, "增加内功：" .. tbPotential[4])
  Txt_SetTxt(self.UIGROUP, self.TXTFIGHTPOWER, "战斗力：" .. (Partner:GetFightPowerAdded(pViewPartner, 1) or "--"))

  Txt_SetTxt(self.UIGROUP, self.TXTSKILLTITLE, "同伴" .. szName .. "的技能")
  self:OnUpdatePartnerSkill(tbSkills)

  self:OnUpdatePartnerStar(nStarLevel)

  self:OnUpdatePartnerEquip()
end

function uiViewPlayer:OnUpdatePartnerSkill(tbSkills)
  if not tbSkills then
    return
  end

  self.tbPartnerSkill = tbSkills
  self.tbObjParnterSkillView:ClearObj()

  local nX, nY = 0, 0
  for nIndex, tbSkill in pairs(tbSkills) do
    if nIndex > self.PARTNERSKILL_COL then
      nY = 1
    end
    nX = nIndex % self.PARTNERSKILL_COL - 1
    if nX < 0 then
      nX = nX + self.PARTNERSKILL_COL
    end

    local tbSkillObj = {}
    tbSkillObj.nType = Ui.OBJ_FIGHTSKILL
    tbSkillObj.nSkillId = tbSkill.nId

    self.tbObjParnterSkillView:SetObj(tbSkillObj, nX, nY)
    ObjBox_Clear(self.UIGROUP, Ui.OBJ_FIGHTSKILL)
    ObjBox_HoldObject(self.UIGROUP, OBJ_PARTNER_SKILL_VIEW, Ui.CGOG_SKILL_SHORTCUT, tbSkillObj.nSkillId)
    Txt_SetTxt(self.UIGROUP, self.TB_TXTSKILLLEVEL[nIndex], tbSkill.nLevel)
  end
end

function uiViewPlayer:OnUpdatePartnerStar(nStarLevel)
  if not nStarLevel then
    return
  end

  local szFillStar, szEmptyStar = "", ""
  if Partner.tbStarLevel and Partner.tbStarLevel[nStarLevel] then
    szFillStar = string.format("<pic=%s>", Partner.tbStarLevel[nStarLevel].nFillStar - 1)
    szEmptyStar = string.format("<pic=%s>", Partner.tbStarLevel[nStarLevel].nEmptyStar - 1)
  else
    szFillStar = "★"
    szEmptyStar = "☆"
  end

  local nFillStarCount = math.floor(nStarLevel / 2)
  local nEmptyStarCount = nStarLevel % 2
  local szStarTip = "\n "
  for i = 1, nFillStarCount do
    szStarTip = szStarTip .. szFillStar
    if i % 3 == 0 then
      szStarTip = szStarTip .. " "
    end
  end
  if nEmptyStarCount >= 1 then
    szStarTip = szStarTip .. szEmptyStar
  end

  Txt_SetTxt(self.UIGROUP, self.TXTSTARIMAGE, szStarTip)
end

-- 虽然名字是同伴装备，但实际是存在了玩家的身上，实际上是玩家的装备，所以同伴装备的查看方式
-- 应该与玩家装备的一致，不能从同伴身上获取
function uiViewPlayer:OnUpdatePartnerEquip()
  local tbPartnerEquip = me.GetPlayerPartnerEquipList()

  for i = 1, #self.PARTNEREQUIP do
    self.tbObjPartnerEquipCont[self.PARTNEREQUIP[i][1]]:ClearObj()
  end

  for i = 1, #tbPartnerEquip do
    local tbObj = nil
    local pItem = KItem.GetItemObj(tbPartnerEquip[i].uId)
    if pItem then
      tbObj = {}
      tbObj.nType = Ui.OBJ_ITEM
      tbObj.pItem = pItem
    end

    local nEquipPos = tbPartnerEquip[i].nPart + 1
    self.tbObjPartnerEquipCont[self.PARTNEREQUIP[nEquipPos][1]]:SetObj(tbObj)
  end
end

-- 鼠标进入技能View时触发
function uiViewPlayer:OnObjGridEnter(szWnd, nX, nY)
  if Wnd_Visible(self.UIGROUP, "Main") == 0 then
    return
  end

  if szWnd == OBJ_PARTNER_SKILL_VIEW then
    local nOffset = 0
    if nY > 0 then
      nOffset = self.PARTNERSKILL_COL
    else
      nOffset = 1
    end
    local uId = nX + nOffset + nY
    if self.tbPartnerSkill[uId] then
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, FightSkill:GetDesc(self.tbPartnerSkill[uId].nId, self.tbPartnerSkill[uId].nLevel))
    end
  end
end

function uiViewPlayer:FillNpcRes(pItem, nSex)
  if not pItem then
    return
  end
  local nItemResId = pItem.GetResourceId(nSex)
  local nItemColorScheme = pItem.GetChangeColorScheme

  if pItem.nDetail == Item.EQUIP_HELM then
    self.tbPreViewPart[Npc.NPCRES_PART_HELM] = {
      nResId = nItemResId or 0,
      nChangeColorScheme = nItemColorScheme or 0,
    }
  elseif pItem.nDetail == Item.EQUIP_ARMOR then
    self.tbPreViewPart[Npc.NPCRES_PART_ARMOR] = {
      nResId = nItemResId or 0,
      nChangeColorScheme = nItemColorScheme or 0,
    }
  elseif pItem.nDetail == Item.EQUIP_MELEE_WEAPON or pItem.nDetail == Item.EQUIP_RANGE_WEAPON then
    self.tbPreViewPart[Npc.NPCRES_PART_WEAPON] = {
      nResId = nItemResId or 0,
      nChangeColorScheme = nItemColorScheme or 0,
    }
  end
end

function uiViewPlayer:OnUpdatePreView(nSex)
  self.tbObjPreView:ClearObj()
  local tbObj = {}
  tbObj.nType = Ui.OBJ_NPCRES
  tbObj.nTemplateId = (nSex == 0) and -1 or -2
  tbObj.nAction = Npc.ACT_STAND1
  tbObj.tbPart = self.tbPreViewPart
  tbObj.nDir = 0
  tbObj.bRideHorse = 0
  self.tbObjPreView:SetObj(tbObj)
end

function uiViewPlayer:UpdateEquipment()
  local tbEquips = me.GetPlayerEquipList()

  for i = 1, #self.EQUIPMENT do
    self.tbEquipCont[self.EQUIPMENT[i][1]]:ClearObj()
  end

  for i = 1, #tbEquips do
    local tbObj = nil
    local pItem = KItem.GetItemObj(tbEquips[i].uId)
    if pItem then
      self:FillNpcRes(pItem, self.tbPlayerInfo[5])
      tbObj = {}
      tbObj.nType = Ui.OBJ_ITEM
      tbObj.pItem = pItem
      self:OnUpdatePreView(pItem, self.tbPlayerInfo[5])
    end
    if self.EQUIPMENT[tbEquips[i].nPart + 1] and self.tbEquipCont[self.EQUIPMENT[tbEquips[i].nPart + 1][1]] then
      self.tbEquipCont[self.EQUIPMENT[tbEquips[i].nPart + 1][1]]:SetObj(tbObj)
    end
  end
  self:OnUpdatePreView(self.tbPlayerInfo[5])
end

function uiViewPlayer:UpdatePlayerInfo()
  local szInfo = "姓名：" .. self.tbPlayerInfo[1]
  szInfo = szInfo .. "\n等级：" .. self.tbPlayerInfo[2]
  if Ui.nVersion == 1 then
    szInfo = szInfo .. "   恶名值：" .. self.tbPlayerInfo[3]
  end

  szInfo = szInfo .. "\n门派：" .. Player:GetFactionRouteName(self.tbPlayerInfo[4])
  --	local szMate = "夫人："
  --	if self.tbPlayerInfo[5] == 1 then
  --		szMate = "相公："
  --	end
  local szMate = "侠侣："
  if self.tbPlayerInfo[6] == "" then
    self.tbPlayerInfo[6] = "无"
  end
  szInfo = szInfo .. "\n" .. szMate .. self.tbPlayerInfo[6]
  Txt_SetTxt(self.UIGROUP, self.TXTBASICINFO, szInfo)

  local szSpr, nType = tbViewPlayerMgr:GetPortraitSpr(self.tbPlayerInfo[1], self.tbPlayerInfo[7], self.tbPlayerInfo[5])

  Img_SetImage(self.UIGROUP, self.IMGPORTRAIT, nType, szSpr)

  if self.tbPlayerInfo[4] == 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTNVIEWSKILL, 0)
  end

  --族徽绘制
  if self.tbPlayerInfo[8] > 0 and Kin.tbKinBadge[self.tbPlayerInfo[8]] then
    Img_SetImage(self.UIGROUP, self.IMGKINBADGE, 1, Kin.tbKinBadge[self.tbPlayerInfo[8]].BrightBadge)
  end

  szInfo = "曾用名：" .. (self.tbPlayerInfo[9] or "")
  if Ui.nVersion == 2 then
    szInfo = szInfo .. "\n恶名值：" .. self.tbPlayerInfo[3]
  end
  Txt_SetTxt(self.UIGROUP, self.TXTALTERNAME, szInfo)
end

function uiViewPlayer:OnUpdateHistroy(nPage)
  if nPage ~= nil then
    self.nCurHistroyPage = nPage
  end
  local szHistroy = "temp" .. self.nCurHistroyPage --GetHistroy(self.nCurHistroyPage);
  Txt_SetTxt(self.UIGROUP, self.TXTHISTROYNAME, self.tbPlayerInfo[1])
  Txt_SetTxt(self.UIGROUP, self.TXTHISTROY, szHistroy)
end

function uiViewPlayer:OnViewPlayer(szRoleName, nLevel, nPkValue, nFaction, bSex, szMateName, nPortrait, nKinBadge, szAlterName)
  local tbPlayer = { szRoleName, nLevel, nPkValue, nFaction, bSex, szMateName, nPortrait, nKinBadge, szAlterName }
  self.tbPlayerInfo = tbPlayer
  if self.tbPlayerInfo == nil then
    return
  end
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGEBASIC) -- 设置首页
  PgSet_ActivePage(self.UIGROUP, self.PAGESET_PARTNER, self.PAGEPARTNER) -- 设置首页
  self.nCurPage = 1
  self:Update()
end

function uiViewPlayer:OnViewPlayerSkill()
  UiManager:OpenWindow(Ui.UI_VIEW_FIGHTSKILL)
end

function uiViewPlayer:RegisterMessage()
  local tbRegMsg = {}
  for _, tbEquip in pairs(self.tbEquipCont) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, tbEquip:RegisterMessage())
  end

  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjParnterSkillView:RegisterMessage())

  for _, tbPartnerEquip in pairs(self.tbObjPartnerEquipCont) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, tbPartnerEquip:RegisterMessage())
  end

  return tbRegMsg
end

-- 注册事件更新回调
function uiViewPlayer:RegisterEvent()
  local tbRegEvent = {}
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjParnterSkillView:RegisterEvent())

  for _, tbPartnerEquip in pairs(self.tbObjPartnerEquipCont) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, tbPartnerEquip:RegisterEvent())
  end

  return tbRegEvent
end
