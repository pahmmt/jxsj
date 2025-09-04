Ui.tbLogic.tbViewPlayerMgr = {}
local tbViewPlayerMgr = Ui.tbLogic.tbViewPlayerMgr
tbViewPlayerMgr.tbPlayerInfo = {}

function tbViewPlayerMgr:Init()
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_VIEWPLAYER, self.OnViewPlayer, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_VIEW_NPC_SKILL, self.OnViewPlayerSkill, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_VIEW_PLAYERPARTNER, self.OnViewPlayerPartner, self)
end

function tbViewPlayerMgr:OnViewPlayer(szRoleName, nLevel, nPkValue, nFaction, bSex, szMateName, nPortrait, nKinBadge, szAlterName)
  local tbTemp = me.GetTempTable("Npc")
  local nNpcId = 0
  if tbTemp.tbViewPlayer then
    nNpcId = tbTemp.tbViewPlayer.nNpcId or 0
    tbTemp.tbViewPlayer.nNpcId = 0
  end

  UiManager:OpenWindow(Ui.UI_VIEWPLAYER, szRoleName, nLevel, nPkValue, nFaction, bSex, szMateName, nPortrait, nNpcId, nKinBadge, szAlterName)
end

function tbViewPlayerMgr:OnViewPlayerSkill()
  Ui(Ui.UI_VIEWPLAYER):OnViewPlayerSkill()
end

function tbViewPlayerMgr:OnViewPlayerPartner()
  Ui(Ui.UI_VIEWPLAYER):OnUpdatePartner()
end

tbViewPlayerMgr.tbDefaultMyImg = {
  [0] = "\\image\\ui\\001a\\portrait\\male_001_mormal.spr",
  [1] = "\\image\\ui\\001a\\portrait\\female_001_normal.spr",
}

tbViewPlayerMgr.tbDefaultMySmallImg = {
  [0] = "\\image\\ui\\001a\\portrait\\male_001_team.spr",
  [1] = "\\image\\ui\\001a\\portrait\\female_001_team.spr",
}

if UiVersion == Ui.Version002 then
  tbViewPlayerMgr.tbDefaultMyImg = {
    [1] = "\\image\\ui\\002a\\playerpanel\\protrait_myportrait_tenc.spr",
    [2] = "\\image\\ui\\002a\\playerpanel\\protrait_myportrait_sina.spr",
  }
end

function tbViewPlayerMgr:GetPortraitSpr(szPlayerName, nPortrait, nSex, bSmall)
  local szSpr = ""
  if nPortrait <= 100 then
    local szSpr = GetPortraitSpr(nPortrait, nSex, bSmall)
    return szSpr, 1
  end

  local szDefault = ""

  if 1 == bSmall then
    if UiVersion == Ui.Version001 then
      szDefault = self.tbDefaultMySmallImg[nSex]
    end
    return szDefault, 1
  end

  if UiVersion == Ui.Version002 then
    szDefault = self.tbDefaultMyImg[nPortrait - 100]
  else
    szDefault = self.tbDefaultMyImg[nSex]
  end

  local szTempSpr = Sns:GetImagePath(nPortrait - 100, szPlayerName)
  if not szTempSpr then
    return szDefault, 1
  end

  local nStart = string.find(szTempSpr, ".jpg")
  if not nStart or nStart <= 0 then
    return szDefault, 1
  end

  local tbImage = GetImageParam(szTempSpr, 0)
  if not tbImage then
    return szDefault, 1
  end

  return szTempSpr, 0
end

function tbViewPlayerMgr:GetMyPortraitSpr(nPortrait, nSex)
  local szSpr = GetPortraitSpr(nPortrait, nSex)
  if nPortrait <= 100 then
    return szSpr, 1
  end

  local szDefault = ""
  if UiVersion == Ui.Version002 then
    szDefault = self.tbDefaultMyImg[nPortrait - 100]
  else
    szDefault = self.tbDefaultMyImg[nSex]
  end

  if not szSpr then
    return szDefault, 1
  end

  local nStart = string.find(szSpr, ".jpg")
  if not nStart or nStart <= 0 then
    return szDefault, 1
  end

  local tbImage = GetImageParam(szSpr, 0)
  if not tbImage then
    return szDefault, 1
  end

  return szSpr, 0
end
