local uiPkModel = Ui:GetClass("pkmodel")

uiPkModel.BTN_PK = "BtnPk"

uiPkModel.PKMODE = {
  [Player.emKPK_STATE_PRACTISE] = { "练功模式", 0xFF7BD794, "\\image\\ui\\002a\\pkmodel\\anneal.spr" },
  [Player.emKPK_STATE_CAMP] = { "阵营模式", 0xFFFFC352, "\\image\\ui\\002a\\pkmodel\\camp_pk.spr" },
  [Player.emKPK_STATE_TONG] = { "帮会模式", 0xFF399ED6, "\\image\\ui\\002a\\pkmodel\\tong_pk.spr" },
  [Player.emKPK_STATE_KIN] = { "家族模式", 0xFF399ED6, "\\image\\ui\\002a\\pkmodel\\tong_pk.spr" },
  [Player.emKPK_STATE_BUTCHER] = { "屠杀模式", 0xFFF7595A, "\\image\\ui\\002a\\pkmodel\\butcher.spr" },
  [Player.emKPK_STATE_UNION] = { "联盟模式", 0xFF399ED6, "\\image\\ui\\002a\\pkmodel\\tong_pk.spr" },
  [Player.emKPK_STATE_EXTENSION] = { "自定义模式", 0xFFFFC352, "\\image\\ui\\002a\\pkmodel\\camp_pk.spr" },
}

function uiPkModel:Init() end

function uiPkModel:OnOpen()
  self:UpdatePKModel()
end

function uiPkModel:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_PK then
    if me.IsFreshPlayer() == 1 then
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "50级以下的玩家或白名玩家不能切换战斗模式！")
      return
    end
    UiManager:SwitchWindow(Ui.UI_FIGHTMODE)
  end
end

function uiPkModel:UpdatePKModel()
  if me.nPkModel == Player.emKPK_STATE_PRACTISE then
    me.Msg("PK状态变为练功模式！")
  elseif me.nPkModel == Player.emKPK_STATE_CAMP then
    me.Msg("PK状态变为阵营模式！")
  elseif me.nPkModel == Player.emKPK_STATE_TONG then
    local nKinId = me.GetKinMember()
    if me.dwTongId > 0 then
      me.Msg("PK状态变为帮会模式！")
      self.PKMODE[me.nPkModel][1] = "帮会模式"
    elseif nKinId and nKinId > 0 then
      me.Msg("PK状态变为家族模式！")
      self.PKMODE[me.nPkModel][1] = "家族模式"
    elseif nKinId and nKinId <= 0 and me.dwTongId <= 0 then
      return
    end
  elseif me.nPkModel == Player.emKPK_STATE_BUTCHER then
    me.Msg("PK状态变为屠杀模式！")
  elseif me.nPkModel == Player.emKPK_STATE_UNION then
    me.Msg("PK状态变为联盟模式")
  elseif me.nPkModel == Player.emKPK_STATE_EXTENSION then
    me.Msg("PK状态变为自定义模式")
  elseif me.nPkModel == Player.emKPK_STATE_KIN then
    me.Msg("PK状态变为家族模式！")
  end

  Btn_SetTxt(self.UIGROUP, self.BTN_PK, self.PKMODE[me.nPkModel][1])
  Btn_SetTextColor(self.UIGROUP, self.BTN_PK, self.PKMODE[me.nPkModel][2])
  Img_SetImage(self.UIGROUP, self.BTN_PK, 1, self.PKMODE[me.nPkModel][3])
end

function uiPkModel:ChangeToNextModel()
  if me.IsFreshPlayer() == 1 then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "50级以下的玩家或白名玩家不能切换战斗模式！")
    return
  end

  local tbSel = {
    --Player.emKPK_STATE_PRACTISE,
    Player.emKPK_STATE_CAMP,
    Player.emKPK_STATE_TONG,
    --Player.emKPK_STATE_KIN,
    Player.emKPK_STATE_BUTCHER,
  }
  local nNowSel = 0
  for i, v in ipairs(tbSel) do
    if v == me.nPkModel then
      nNowSel = i
      break
    end
  end
  nNowSel = nNowSel % #tbSel + 1

  -- 注意顺序，逻辑上暗示家族在帮会的后面了，不然代码难写
  local nKinId, _ = me.GetKinMember()
  if nKinId == 0 and tbSel[nNowSel] == Player.emKPK_STATE_TONG then
    nNowSel = nNowSel % #tbSel + 1
  end
  --	if (tbSel[nNowSel] == Player.emKPK_STATE_KIN) then
  --		local nKinId, _ = me.GetKinMember();
  --		if (nKinId == 0) then
  --			nNowSel = nNowSel % #tbSel + 1;
  --		end
  --	end

  me.nPkModel = tbSel[nNowSel]

  self:WriteStatLog("PK状态切换")
end

--写log
function uiPkModel:WriteStatLog(szField)
  Log:Ui_SendLog(szField, 1)
end

function uiPkModel:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_PK_MODEL, self.UpdatePKModel },
  }
  return tbRegEvent
end
