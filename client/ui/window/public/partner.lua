-----------------------------------------------------
--文件名		：	partner.lua
--创建者		：	fenghewen
--创建时间		：	2009-12-1
--功能描述		：	同伴系统界面
------------------------------------------------------
local uiPartner = Ui:GetClass("partner")
local tbObject = Ui.tbLogic.tbObject
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr

uiPartner.BUTTON_CLOSE = "BtnClose"
uiPartner.BUTTON_PRESENT = "BtnPresent"
uiPartner.BUTTON_ACTIVE = "BtnActive"
uiPartner.BUTTON_DISBAND = "BtnDisband"
uiPartner.BUTTON_LEVEL_UP = "BtnLevelUp"
uiPartner.BUTTON_BINDEQUIP = "BtnEquipBind"
uiPartner.BUTTON_CONVERT = "BtnConvert"

uiPartner.LIST_PARTNER = "LstPartner"

uiPartner.IMG_CONVERT = "ImgConvert"
uiPartner.TXT_ACCUMULATE_EXP = "TxtAccumulateExp"
uiPartner.TXT_NEED_EXP = "TxtNeedExp"
uiPartner.TXT_FRIENDSHIP = "TxtFriendship"
uiPartner.TXT_TALENT = "TxtTalent"
uiPartner.TXT_ADD_STR = "TxtAddStr"
uiPartner.TXT_ADD_DEX = "TxtAddDex"
uiPartner.TXT_ADD_VIT = "TxtAddVit"
uiPartner.TXT_ADD_ENG = "TxtAddEng"
uiPartner.TXT_START = "TxtStart"
uiPartner.TXT_PARTNER_LIST = "TxtPartnerList"
uiPartner.SZ_TXT_SKILL_LV = "TxtSkillLv"
uiPartner.TXT_FIGHTPOWER = "TxtFightPower"
uiPartner.TXT_SKILL_LV = {}
uiPartner.OBJ_PARTNER_PREVIEW = "ObjPartnerPreview"
uiPartner.OBJ_SKILL_PREVIEW = "ObjSkillPreview"
uiPartner.CONVERT_EFFECT = "ImgConvertEffect"
--uiPartner.OBJ_EQUIP_PREVIEW 	= "ObjEquipPreview";
uiPartner.TXT_COMMONMIJIINFO = "TxtCommonMijiInfo"
uiPartner.TXT_SPECIALMIJIINFO = "TxtSpecialMijiInfo"
uiPartner.TXT_EXPBOOKINFO = "TxtExpBookInfo"

uiPartner.OBJ_SKILL_CONFIGER = { bShowCd = 1, bUse = 0, bLink = 0, bSwitch = 0 } -- 对应同伴技能
uiPartner.ROWCOUNT = 5
uiPartner.PARTNER_VALUE = { TEMP_ID = 0, EXP = 1, LEVEL = 2, FRIENDSHIP = 3, TALENT = 4 } -- 对应代码中的 emPARTNER_VALUE
uiPartner.PARTNER_ATTRIB = { STR = 0, DEX = 1, VIT = 2, ENG = 3 } -- 对应代码中的 emPARTNER_ATTRIB
uiPartner.MAX_SKILL_COUNT = 10

-- 同伴装备栏
local PARTNER_EQUIP_OBJ_CONFIGER = {
  { Item.PARTNEREQUIP_WEAPON, "ObjWeapon", "ImgWeapon" }, -- 同伴装备--武器
  { Item.PARTNEREQUIP_BODY, "ObjBody", "ImgBody" }, -- 同伴装备--衣服
  { Item.PARTNEREQUIP_RING, "ObjRing", "ImgRing" }, -- 同伴装备--戒指
  { Item.PARTNEREQUIP_CUFF, "ObjCuff", "ImgCuff" }, -- 同伴装备--护腕
  { Item.PARTNEREQUIP_AMULET, "ObjAmulet", "ImgAmulet" }, -- 同伴装备--护身符
}

local PARTNER_EQUIP_TIP = -- 装备控件表
  {
    [Item.PARTNEREQUIP_WEAPON] = { "ObjWeapon", "ImgWeapon", "同伴装备之武器，主要强化角色攻击能力。" }, -- 同伴装备--武器
    [Item.PARTNEREQUIP_BODY] = { "ObjBody", "ImgBody", "同伴装备之衣服，主要强化角色防御能力。" }, -- 同伴装备--衣服
    [Item.PARTNEREQUIP_RING] = { "ObjRing", "ImgRing", "同伴装备之戒指，强化角色攻击力+防御力。" }, -- 同伴装备--戒指
    [Item.PARTNEREQUIP_CUFF] = { "ObjCuff", "ImgCuff", "同伴装备之护腕，强化角色防御力+攻击力。" }, -- 同伴装备--护腕
    [Item.PARTNEREQUIP_AMULET] = { "ObjAmulet", "ImgAmulet", "同伴装备之护身符，大幅度提升角色攻击能力。" }, -- 同伴装备--护身符
  }

local tbPartnerEquipCont = { bShowCd = 0, bUse = 0, bLink = 0, nRoom = Item.ROOM_PARTNEREQUIP } -- 对应同伴装备栏
-- 创建期，创建OBJ容器, 宠物列表
function uiPartner:OnCreate()
  self.nSelect = 1
  self.tbSkillIds = {}
  self.tbObjPartnerView = {}
  self.tbObjSkillView = {}
  self.tbObjEquipView = {}
  self.tbObjPartnerView = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_PARTNER_PREVIEW)
  self.tbObjSkillView = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_SKILL_PREVIEW, 5, 2, self.OBJ_SKILL_CONFIGER, "SkillView")
  --self.tbObjEquipView = tbObject:RegisterContainer(self.UIGROUP, self.OBJ_EQUIP_PREVIEW, 5, 1, tbPartnerEquipCont, "equiproom");
  self.tbObjEquipView = {}
  for i, tbCon in pairs(PARTNER_EQUIP_OBJ_CONFIGER) do
    local nPos = tbCon[1]
    self.tbObjEquipView[nPos] = tbObject:RegisterContainer(
      self.UIGROUP,
      tbCon[2],
      1,
      1,
      { nOffsetX = nPos, nRoom = Item.ROOM_PARTNEREQUIP }, -- 加上偏移量
      "equiproom"
    )
  end

  for i = 1, self.MAX_SKILL_COUNT do
    self.TXT_SKILL_LV[i] = self.SZ_TXT_SKILL_LV .. i
  end
end

function uiPartner:OnKillFocus(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

-- 销毁OBJ容器
function uiPartner:OnDestroy()
  tbObject:UnregContainer(self.tbObjPartnerView)
  tbObject:UnregContainer(self.tbObjSkillView)
  for _, tbCont in pairs(self.tbObjEquipView) do
    tbObject:UnregContainer(tbCont)
  end
end

function uiPartner:OnClose()
  for _, tbCont in pairs(self.tbObjEquipView) do
    tbCont:ClearRoom()
  end
end

function uiPartner:OnListSel(szWnd, nParam)
  if szWnd == self.LIST_PARTNER then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_PARTNER)
    self.nSelect = nKey
    self:UpdatePartner(self.nSelect - 1)
  end
end

-- 鼠标进入技能View时触发
function uiPartner:OnObjGridEnter(szWnd, nX, nY)
  if Wnd_Visible(self.UIGROUP, "Main") == 0 then
    return
  end

  if szWnd == self.OBJ_SKILL_PREVIEW then
    local nOffset = 0
    if nY > 0 then
      nOffset = 5
    else
      nOffset = 1
    end
    local uId = nX + nOffset + nY
    if self.tbSkillIds[uId] then
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, FightSkill:GetDesc(self.tbSkillIds[uId].nId, self.tbSkillIds[uId].nLevel))
    end
  end
end

-- 打开界面
function uiPartner:OnOpen()
  if Partner.bOpenPartner == 0 then
    return 0
  end

  Wnd_SetVisible(self.UIGROUP, "Main", 1)
  if me.nActivePartner ~= -1 then
    self.nSelect = me.nActivePartner + 1
  end
  self:Update()

  if Item.tbZhenYuan.bOpen ~= 1 then
    Wnd_Hide(self.UIGROUP, self.BUTTON_CONVERT)
    Wnd_Hide(self.UIGROUP, self.IMG_CONVERT)
  end

  if Player.tbFightPower:IsFightPowerValid() ~= 1 then
    Wnd_Hide(self.UIGROUP, self.TXT_FIGHTPOWER)
  end
end

-- 更新同伴列表
function uiPartner:UpdateList()
  Lst_Clear(self.UIGROUP, self.LIST_PARTNER)
  for nIndex = 1, me.nPartnerCount do
    local pPartner = me.GetPartner(nIndex - 1)
    if pPartner then
      Lst_SetCell(self.UIGROUP, self.LIST_PARTNER, nIndex, 1, "   " .. pPartner.szName)
      Lst_SetCell(self.UIGROUP, self.LIST_PARTNER, nIndex, 2, pPartner.GetValue(self.PARTNER_VALUE.LEVEL) .. "级")
    end
  end

  -- 激活的同伴加星标识
  if me.nActivePartner ~= -1 then
    local pPartner = me.GetPartner(me.nActivePartner)
    if pPartner then
      Lst_SetCell(self.UIGROUP, self.LIST_PARTNER, me.nActivePartner + 1, 1, "<color=orange>★ <color>" .. pPartner.szName)
    end
  end
end

-- 更新同伴
function uiPartner:Update()
  if Wnd_Visible(self.UIGROUP, "Main") == 0 then
    return
  end

  Wnd_SetEnable(self.UIGROUP, self.BUTTON_LEVEL_UP, 0)
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_PRESENT, 0)
  Txt_SetTxt(self.UIGROUP, self.TXT_PARTNER_LIST, "同伴列表（" .. me.nPartnerCount .. "/" .. me.nPartnerLimit .. "）")

  -- 更新同伴列表
  self:UpdateList()

  -- 设置列表选择
  if self.nSelect > me.nPartnerCount and me.nPartnerCount > 0 and me.nPartnerCount <= me.nPartnerLimit then
    if me.nActivePartner ~= -1 then
      self.nSelect = me.nActivePartner + 1
    else
      self.nSelect = 1
    end
  end
  Lst_SetCurKey(self.UIGROUP, self.LIST_PARTNER, self.nSelect)

  self:UpdatePartner(self.nSelect - 1)

  -- 更新同伴装备
  self:UpdatePartnerEquip()
  --self:UpdateEquipDur();
  return 1
end

-- 更新选择的同伴
function uiPartner:UpdatePartner(nPartnerIndex)
  self:UpdatePartnerInfo(nPartnerIndex)
  self:UpdatePartnerView(nPartnerIndex)
  self:UpdateSkillView(nPartnerIndex)
  self:UpdateMijiBookInfo(nPartnerIndex)
end

-- 更新秘籍经验书使用情况
function uiPartner:UpdateMijiBookInfo(nPartnerIndex)
  if UiVersion == Ui.Version001 then
    return
  end
  local nExpBookCount = me.GetTask(2112, 1)
  local nCurDate = tonumber(os.date("%Y%m%d", GetTime()))
  local nDate = me.GetTask(2112, 2) -- 日期
  if nCurDate ~= nDate then
    nExpBookCount = 0
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_EXPBOOKINFO, string.format("同伴经验书（当天）：<color=yellow>%s/40<color>本", nExpBookCount))
  if nPartnerIndex < 0 or nPartnerIndex >= me.nPartnerCount then
    Wnd_Hide(self.UIGROUP, self.TXT_COMMONMIJIINFO)
    Wnd_Hide(self.UIGROUP, self.TXT_SPECIALMIJIINFO)
    return
  end
  local pPartner = me.GetPartner(nPartnerIndex)
  if not pPartner then
    Wnd_Hide(self.UIGROUP, self.TXT_COMMONMIJIINFO)
    Wnd_Hide(self.UIGROUP, self.TXT_SPECIALMIJIINFO)
    return
  end
  local nCommonMijiCount = pPartner.GetValue(Partner.emKPARTNERATTRIBTYPE_SKILLBOOK)
  if nCommonMijiCount < 0 then
    nCommonMijiCount = 0
  end
  local nCountCommonEx = 0
  local nNum = 0
  for i = 1, 3 do
    nNum = math.fmod(nCommonMijiCount, 10 ^ i)
    nCountCommonEx = nCountCommonEx + math.floor(nNum / (10 ^ (i - 1)))
  end
  local nSpecialMijiCount = pPartner.GetValue(Partner.emKPARTNERATTRIBTYPE_SKILLBOOK)
  if nSpecialMijiCount < 0 then
    nSpecialMijiCount = 0
  end
  local nCountSpecialEx = math.floor(nSpecialMijiCount / 1000)
  Txt_SetTxt(self.UIGROUP, self.TXT_COMMONMIJIINFO, string.format("普通同伴秘籍<color=yellow>%s/2<color>本", nCountCommonEx))
  Txt_SetTxt(self.UIGROUP, self.TXT_SPECIALMIJIINFO, string.format("特殊同伴秘籍<color=yellow>%s/2<color>本", nCountSpecialEx))
end

-- 更新同伴外观
function uiPartner:UpdatePartnerView(nPartnerIndex)
  if not self.tbObjPartnerView.szObjGrid then
    print("No tbObjPartnerView")
    return
  end
  self.tbObjPartnerView:ClearObj()
  if nPartnerIndex < 0 or nPartnerIndex >= me.nPartnerCount then
    return
  end
  local pPartner = me.GetPartner(nPartnerIndex)
  if not pPartner then
    return
  end

  local tbPart = tbPreViewMgr:GetSelfPart()
  local nNpcId = Partner.tbPartnerAttrib[pPartner.GetValue(self.PARTNER_VALUE.TEMP_ID)].nEffectNpcId
  if not nNpcId then
    return
  end
  --local nNpcId =12;
  local tbObj = {}
  tbObj.nType = Ui.OBJ_NPCRES
  tbObj.nTemplateId = nNpcId
  tbObj.nAction = Npc.ACT_STAND1
  tbObj.tbPart = tbPart
  tbObj.nDir = 0
  tbObj.bRideHorse = 0
  self.tbObjPartnerView:SetObj(tbObj)
end

-- 更新技能的外观
function uiPartner:UpdateSkillView(nPartnerIndex)
  self.tbSkillIds = {}
  if not self.tbObjSkillView.szObjGrid then
    print("No tbObjSkillView")
    return
  end
  self.tbObjSkillView:ClearObj()
  self:ClearSkillLevel()
  if nPartnerIndex < 0 or nPartnerIndex >= me.nPartnerCount then
    return
  end
  local pPartner = me.GetPartner(nPartnerIndex)
  if not pPartner then
    return
  end

  for nIndex = 1, pPartner.nSkillCount do
    table.insert(self.tbSkillIds, pPartner.GetSkill(nIndex - 1))
  end

  --tbSkillIds = {{nId = 1, nLevel = 1},
  --				   {nId = 2, nLevel = 2},
  --				   {nId = 3, nLevel = 3},
  --				   {nId = 4, nLevel = 4},
  --				   {nId = 5, nLevel = 5},
  --				   {nId = 6, nLevel = 6},
  --				   {nId = 7, nLevel = 7},
  --				   {nId = 8, nLevel = 8},
  --				   {nId = 9, nLevel = 9},
  --				   };

  local nRow = 0
  local nLine = 0
  for nIndex, tbPartnerSkill in ipairs(self.tbSkillIds) do
    nRow = nIndex - 1
    if nIndex > self.ROWCOUNT and self.ROWCOUNT > 0 then
      nRow = nRow - self.ROWCOUNT
      nLine = math.floor(nRow / self.ROWCOUNT) + 1
    end
    local tbSkill = {}
    tbSkill.nType = Ui.OBJ_FIGHTSKILL
    tbSkill.nSkillId = tbPartnerSkill.nId
    self.tbObjSkillView:SetObj(tbSkill, nRow, nLine)
    ObjBox_Clear(self.UIGROUP, Ui.OBJ_FIGHTSKILL)
    ObjBox_HoldObject(self.UIGROUP, self.OBJ_SKILL_PREVIEW, Ui.CGOG_SKILL_SHORTCUT, tbPartnerSkill.nId)
    Txt_SetTxt(self.UIGROUP, self.TXT_SKILL_LV[nIndex], tbPartnerSkill.nLevel)
  end
end

function uiPartner:UpdateCellTips()
  for nPos, tbCont in pairs(self.tbObjEquipView) do
    local tbTips = PARTNER_EQUIP_TIP[nPos]
    local pItem = me.GetItem(tbCont.nRoom, tbCont.nOffsetX, tbCont.nOffsetY)
    if pItem and (tbCont.nOffsetX >= Item.PARTNEREQUIP_WEAPON and tbCont.nOffsetY <= Item.PARTNEREQUIP_AMULET) then
      Wnd_SetTip(self.UIGROUP, tbTips[2], "")
    else
      Wnd_SetTip(self.UIGROUP, tbTips[2], tbTips[3])
    end
  end
end

-- 更新同伴装备显示
function uiPartner:UpdatePartnerEquip()
  if Wnd_Visible(self.UIGROUP) == 1 then
    for i, tbCont in pairs(self.tbObjEquipView) do
      tbCont:UpdateRoom()
    end
    self:UpdateCellTips()
    self:UpdateMijiBookInfo(self.nSelect - 1)
  end
end

-- 同伴装备没有耐久。。。
function uiPartner:UpdateEquipDur()
  for _, tbCont in pairs(self.tbObjEquipView) do
    if tbCont then
      local pItem = me.GetItem(tbCont.nRoom, tbCont.nOffsetX, tbCont.nOffsetY)
      if pItem then
        if tbCont.nOffsetX >= Item.PARTNEREQUIP_WEAPON and tbCont.nOffsetY <= Item.PARTNEREQUIP_AMULET then
          ObjGrid_ShowSubScript(tbCont.szUiGroup, tbCont.szObjGrid, 1, 0, 0)
          local nPerDur = math.ceil((pItem.nCurDur / pItem.nMaxDur) * 100)
          if nPerDur > 0 and nPerDur <= 10 then
            ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "Red")
          elseif nPerDur > 10 and nPerDur <= 60 then
            ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "yellow")
          elseif nPerDur > 60 then
            ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "green")
          end

          local szDur = tostring(nPerDur) .. "%"
          ObjGrid_ChangeSubScript(tbCont.szUiGroup, tbCont.szObjGrid, szDur, 0, 0)
        end
      end
    end
  end
end

function uiPartner:ClearSkillLevel()
  for i = 1, self.MAX_SKILL_COUNT do
    Txt_SetTxt(self.UIGROUP, self.TXT_SKILL_LV[i], "")
  end
end

-- 更新激活同伴的信息
function uiPartner:UpdatePartnerInfo(nPartnerIndex)
  local szAccumulateExp = "当前积累经验："
  local szNeedExp = "升级所需经验："
  local szFriendship = "亲密度："
  local szTalent = "领悟度："
  local szAddStr = "增加力量："
  local szAddDex = "增加身法："
  local szTxtAddVit = "增加外功："
  local szTxtAddEng = "增加内功："
  local szFightPower = "增加战斗力："
  local szStart = ""

  if nPartnerIndex >= 0 and nPartnerIndex < me.nPartnerCount then
    local pPartner = me.GetPartner(nPartnerIndex)
    if pPartner then
      szStart = self:SetStart(nPartnerIndex)
      szAccumulateExp = szAccumulateExp .. pPartner.GetValue(self.PARTNER_VALUE.EXP)
      szNeedExp = szNeedExp .. Partner:GetNeedLevel(pPartner.GetValue(self.PARTNER_VALUE.LEVEL))
      local szTemp = string.format("%0.2f", pPartner.GetValue(self.PARTNER_VALUE.FRIENDSHIP) / 100)
      szFriendship = szFriendship .. szTemp
      local nTalent = pPartner.GetValue(self.PARTNER_VALUE.TALENT) % 1000
      szTalent = szTalent .. nTalent
      szAddStr = szAddStr .. pPartner.GetAttrib(self.PARTNER_ATTRIB.STR)
      szAddDex = szAddDex .. pPartner.GetAttrib(self.PARTNER_ATTRIB.DEX)
      szTxtAddVit = szTxtAddVit .. pPartner.GetAttrib(self.PARTNER_ATTRIB.VIT)
      szTxtAddEng = szTxtAddEng .. pPartner.GetAttrib(self.PARTNER_ATTRIB.ENG)

      szFightPower = szFightPower .. (Partner:GetFightPowerAdded(pPartner) or "--")

      local nRes = Partner:CanConvertToZhenYuan(pPartner)
      if nRes == 1 then
        Img_SetFrame(self.UIGROUP, self.IMG_CONVERT, 0)
      else
        Img_SetFrame(self.UIGROUP, self.IMG_CONVERT, 2)
      end
    end
  end

  local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_PARTNER)
  if me.nActivePartner ~= nKey - 1 or me.nActivePartner == -1 then
    Btn_SetTxt(self.UIGROUP, self.BUTTON_ACTIVE, "出手相助")
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_LEVEL_UP, 0)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_PRESENT, 0)
    --Wnd_SetEnable(self.UIGROUP,self.BUTTON_CONVERT, 0);
  else
    Btn_SetTxt(self.UIGROUP, self.BUTTON_ACTIVE, "袖手旁观")
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_LEVEL_UP, 1)
    Wnd_SetEnable(self.UIGROUP, self.BUTTON_PRESENT, 1)
    --Wnd_SetEnable(self.UIGROUP,self.BUTTON_CONVERT, 1);
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_START, szStart)
  Txt_SetTxt(self.UIGROUP, self.TXT_ACCUMULATE_EXP, szAccumulateExp)
  Txt_SetTxt(self.UIGROUP, self.TXT_NEED_EXP, szNeedExp)
  Txt_SetTxt(self.UIGROUP, self.TXT_FRIENDSHIP, szFriendship)
  Txt_SetTxt(self.UIGROUP, self.TXT_TALENT, szTalent)
  Txt_SetTxt(self.UIGROUP, self.TXT_ADD_STR, szAddStr)
  Txt_SetTxt(self.UIGROUP, self.TXT_ADD_DEX, szAddDex)
  Txt_SetTxt(self.UIGROUP, self.TXT_ADD_VIT, szTxtAddVit)
  Txt_SetTxt(self.UIGROUP, self.TXT_ADD_ENG, szTxtAddEng)
  Txt_SetTxt(self.UIGROUP, self.TXT_FIGHTPOWER, szFightPower)
end

-- 设置星级
function uiPartner:SetStart(nPartnerIndex)
  local szTip = "\n  "
  if not nPartnerIndex then
    return szTip
  end
  local tbSetting = Partner.tbStarLevel
  local pPartner = me.GetPartner(nPartnerIndex)
  if not pPartner then
    return szTip
  end
  local nStartCount = Partner:GetSelfStartCount(pPartner)
  local szFillStar = ""
  local szEmptyStar = ""
  if tbSetting and tbSetting[nStartCount] then
    szFillStar = string.format("<pic=%s>", tbSetting[nStartCount].nFillStar - 1)
    szEmptyStar = string.format("<pic=%s>", tbSetting[nStartCount].nEmptyStar - 1)
  else
    szFillStar = "★"
    szEmptyStar = "☆"
  end
  --local nStartCount = 15;
  --local szFillStar = string.format("<pic=%s>", 153);
  --local szEmptyStar = string.format("<pic=%s>", 152);

  for i = 1, math.floor(nStartCount / 2) do
    szTip = szTip .. szFillStar
    if i % 3 == 0 then
      szTip = szTip .. " "
    end
  end
  if nStartCount % 2 ~= 0 then
    szTip = szTip .. szEmptyStar
  end
  return szTip
end

-- 按键点击
function uiPartner:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_PRESENT then
    if me.nActivePartner >= 0 and me.nActivePartner <= me.nPartnerLimit then
      me.CallServerScript({ "PartnerCmd", "SendGift", me.nActivePartner })
    end
  elseif szWnd == self.BUTTON_LEVEL_UP then
    if me.nActivePartner >= 0 and me.nActivePartner <= me.nPartnerLimit then
      me.CallServerScript({ "PartnerCmd", "UpgradeLevel", me.nActivePartner })
    end
  elseif szWnd == self.BUTTON_ACTIVE then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_PARTNER)
    if nKey > 0 and nKey <= me.nPartnerLimit then
      me.CallServerScript({ "PartnerCmd", "CallPartner", nKey - 1 })
    else
      me.Msg("请选择你要操作的同伴")
    end
  elseif szWnd == self.BUTTON_DISBAND then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_PARTNER)
    if nKey > 0 and nKey <= me.nPartnerLimit then
      me.CallServerScript({ "PartnerCmd", "DissolvePartner", nKey - 1 })
    else
      me.Msg("请选择你要解散的同伴")
    end
  elseif szWnd == self.BUTTON_BINDEQUIP then
    me.CallServerScript({ "PartnerCmd", "BindEquip", me.nId })
  elseif szWnd == self.BUTTON_CONVERT then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_PARTNER)
    if nKey > 0 and nKey <= me.nPartnerLimit then
      me.CallServerScript({ "PartnerCmd", "Convert", nKey - 1 })
    else
      me.Msg("请选择你要转化的同伴")
    end
  end
end

-- 注册事件更新回调
function uiPartner:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_PARTNER, self.Update },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.UpdatePartnerEquip },
    --{ UiNotify.emUIEVENT_EQUIP_REFRESH, 	self.UpdateEquipDur},
  }
  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjSkillView:RegisterEvent())
  for _, tbCont in pairs(self.tbObjEquipView) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, tbCont:RegisterEvent())
  end
  return tbRegEvent
end

-- 注册技能界面OBJ的消息回调
function uiPartner:RegisterMessage()
  local tbRegMsg = self.tbObjSkillView:RegisterMessage()
  for _, tbCont in pairs(self.tbObjEquipView) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, tbCont:RegisterMessage())
  end
  return tbRegMsg
end

function uiPartner:SetEquipPosHighLight(tbObj)
  local nRet = 1
  if not tbObj or tbObj.nType ~= Ui.OBJ_OWNITEM then
    self:ReleaseEquipPosHighLight()
    return
  end
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if (not pItem) or not pItem.nEquipPos or (pItem.nEquipPos < Item.EQUIPPOS_NUM) then
    self:ReleaseEquipPosHighLight()
    return
  end
  local nPosition = pItem.nEquipPos - Item.EQUIPPOS_NUM
  local tbEquipWnd = self:GetEquipWndTableItem(nPosition)
  if tbEquipWnd then
    self.m_szHighLightEquipPos = tbEquipWnd[3]
    Img_SetFrame(self.UIGROUP, self.m_szHighLightEquipPos, 0)
  end
end

function uiPartner:ReleaseEquipPosHighLight()
  if self.m_szHighLightEquipPos == nil then
    return
  end
  Img_SetFrame(self.UIGROUP, self.m_szHighLightEquipPos, 1)
  self.m_szHighLightEquipPos = nil
end

function uiPartner:GetEquipWndTableItem(nPosition)
  for _, tbEquipItem in ipairs(PARTNER_EQUIP_OBJ_CONFIGER) do
    if tbEquipItem[1] == nPosition then
      return tbEquipItem
    end
  end
end

function uiPartner:OnMouseEnter(szWnd)
  local szTip = ""
  if szWnd == self.IMG_CONVERT then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LIST_PARTNER)
    local pPartner = me.GetPartner(nKey - 1)
    if pPartner then
      local nRes = Partner:CanConvertToZhenYuan(pPartner)
      szTip = nRes == 1 and "1级可凝聚真元" or "不可凝聚真元"
    end
  end

  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

-- bPlay为1表示播放，为0表示停止播放
function uiPartner:PlayerAnimate(bPlay)
  if bPlay == 1 and Wnd_Visible(self.UIGROUP, self.CONVERT_EFFECT) == 0 then
    Wnd_Show(self.UIGROUP, self.CONVERT_EFFECT)
    Img_PlayAnimation(self.UIGROUP, self.CONVERT_EFFECT, 1)
  elseif bPlay == 0 and Wnd_Visible(self.UIGROUP, self.CONVERT_EFFECT) == 1 then
    Img_StopAnimation(self.UIGROUP, self.CONVERT_EFFECT)
    Wnd_Hide(self.UIGROUP, self.CONVERT_EFFECT)
  end
end
