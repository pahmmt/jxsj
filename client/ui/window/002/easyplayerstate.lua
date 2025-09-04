local tbPlayerState = Ui:GetClass("easyplayerstate")
local tbTimer = Ui.tbLogic.tbTimer
local PRG_LIFE = "ImgPartLife"
local PRG_MANA = "ImgPartMana"
local PRG_STAMINA = "ImgPartStamina"
local IMG_BGRES = "ImgBgRes"
local IMG_BGRESBG = "ImgBgResBg"
local BTN_UNLOCK = "BtnUnLock"

local tbSkillCountBgResPath = {
  [2817] = "\\image\\ui\\002a\\playerstate\\jiangumubeijing1.spr",
  [2818] = "\\image\\ui\\002a\\playerstate\\jiangumubeijing2.spr",
  [2846] = "\\image\\ui\\002a\\playerstate\\zhengumubeijing.spr",
}

local tbSkillCountResPath = {
  [2817] = "\\image\\ui\\002a\\playerstate\\jin.spr",
  [2818] = "\\image\\ui\\002a\\playerstate\\jue.spr",
  [2846] = "\\image\\ui\\002a\\playerstate\\cuncunsi.spr",
}
local tbBuffCountResPath = {
  [2817] = "\\image\\ui\\002a\\playerstate\\number_yellow.spr",
  [2818] = "\\image\\ui\\002a\\playerstate\\number_blue.spr",
  [2846] = "\\image\\ui\\002a\\playerstate\\number_blue.spr",
}
-- 技能资源显示
local tbSkillCountRes = {
  [Env.FACTION_ID_GUMU] = { -- skillid, path
    [1] = { 2817, 2818 },
    [2] = { 2846 },
  },
}

function tbPlayerState:OnOpen()
  if UiManager:WindowVisible(Ui.UI_PLAYERSTATE) == 1 then
    UiManager:CloseWindow(Ui.UI_PLAYERSTATE)
  end
  self:UpdateAll()
end

function tbPlayerState:OnMouseEnter(szWnd) end

function tbPlayerState:OnMouseLeave(szWnd)
  Wnd_HideMouseHoverInfo()
end

function tbPlayerState:UpdateAll()
  self:UpdateLife()
  self:UpdateMana()
  self:UpdateStamina()
  self:UpdateSkillCountRes()
end

function tbPlayerState:UpdateLife()
  Prg_SetPos(self.UIGROUP, PRG_LIFE, me.nCurLife / me.nMaxLife * 1000)
end

function tbPlayerState:UpdateMana()
  Prg_SetPos(self.UIGROUP, PRG_MANA, me.nCurMana / me.nMaxMana * 1000)
end

function tbPlayerState:UpdateStamina()
  Prg_SetPos(self.UIGROUP, PRG_STAMINA, me.nCurStamina / me.nMaxStamina * 1000)
end

function tbPlayerState:UpdateSkillCountRes()
  if UiVersion ~= Ui.Version002 then
    return
  end
  local nFaction = me.nFaction
  local nRouteId = me.nRouteId
  local nShowCount = 0
  if tbSkillCountRes[nFaction] and tbSkillCountRes[nFaction][nRouteId] then
    nShowCount = #tbSkillCountRes[nFaction][nRouteId]
    for i = 1, nShowCount do
      local nSkillId = tbSkillCountRes[nFaction][nRouteId][i]
      local nSkillLevel = 0
      local tbBuffList = me.GetBuffList()
      local nFlag = 0
      for j = 1, #tbBuffList do
        local tbInfo = me.GetBuffInfo(tbBuffList[j].uId)
        if tbInfo then
          if tbInfo.nSkillId == nSkillId then
            nFlag = 1
            nSkillLevel = tbInfo.nLevel
            break
          end
        end
      end
      local nBuffCount = 0
      local nMaxBuffCount = -1
      if nFlag == 1 then
        nBuffCount, nMaxBuffCount = self:GetBuffCount(nSkillId, nSkillLevel)
      end
      local szImageBgRes = IMG_BGRES .. i
      local szImageBgResBg = IMG_BGRESBG .. i
      local szImageBgResCount = szImageBgRes .. "Count"
      local szImageResBgCountPath = tbSkillCountBgResPath[nSkillId]
      local szImageResCountPath = tbSkillCountResPath[nSkillId]
      local szBuffCountResPath = tbBuffCountResPath[nSkillId]

      if nBuffCount > 0 then
        Wnd_Show(self.UIGROUP, szImageBgResBg)
        Wnd_Show(self.UIGROUP, szImageBgRes)
        Wnd_Show(self.UIGROUP, szImageBgResCount)
        Img_SetImage(self.UIGROUP, szImageBgRes, 1, szImageResCountPath)
        if nBuffCount == nMaxBuffCount then
          Img_SetFrame(self.UIGROUP, szImageBgRes, 2)
        else
          Img_SetFrame(self.UIGROUP, szImageBgRes, 1)
        end
        Img_SetImage(self.UIGROUP, szImageBgResCount, 1, szBuffCountResPath)
        Img_SetFrame(self.UIGROUP, szImageBgResCount, nBuffCount - 1)
      else
        Wnd_Show(self.UIGROUP, szImageBgResBg)
        Wnd_Show(self.UIGROUP, szImageBgRes)
        Wnd_Hide(self.UIGROUP, szImageBgResCount)
        Img_SetImage(self.UIGROUP, szImageBgRes, 1, szImageResCountPath)
        Img_SetFrame(self.UIGROUP, szImageBgRes, 0)
      end
    end
  end
  for i = nShowCount + 1, 3 do
    Wnd_Hide(self.UIGROUP, IMG_BGRESBG .. i)
    Wnd_Hide(self.UIGROUP, IMG_BGRES .. i)
    Wnd_Hide(self.UIGROUP, IMG_BGRES .. i .. "Count")
  end
end

function tbPlayerState:GetBuffCount(nSkillId, nLevel)
  local tbStateInfo = KFightSkill.GetStateInfo(nSkillId, nLevel)
  if not tbStateInfo then
    return 0, -1
  end
  for szDesc, tbMagic in pairs(tbStateInfo.tbWholeMagic) do
    if szDesc == "superposemagic" and tbMagic[2] > 0 then
      return tbMagic[2], tbMagic[1] -- 返回当前次数和最大次数
    end
  end
  return 0, -1
end

function tbPlayerState:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_UNLOCK then
    local nOrgX, nOrgY = Wnd_GetPos(self.UIGROUP)
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_PLAYERSTATE)
    Wnd_SetPos(Ui.UI_PLAYERSTATE, "Main", nOrgX, nOrgY - 17)
  end
end

function tbPlayerState:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_FACTION, self.UpdateSkillCountRes },
    { UiNotify.emCOREEVENT_CHANGE_FACTION_FINISHED, self.UpdateSkillCountRes },
    { UiNotify.emCOREEVENT_SYNC_LIFE, self.UpdateLife },
    { UiNotify.emCOREEVENT_SYNC_MANA, self.UpdateMana },
    { UiNotify.emCOREEVENT_SYNC_ROUTE, self.UpdateSkillCountRes },
    { UiNotify.emCOREEVENT_SYNC_STAMINA, self.UpdateStamina },
    { UiNotify.emCOREEVENT_BUFF_CHANGE, self.UpdateSkillCountRes },
  }
  return tbRegEvent
end
