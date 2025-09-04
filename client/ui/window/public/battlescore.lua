-- 文件名　	：battlescore.lua
-- 创建者　	：furuilei
-- 创建时间	：2010-05-13 09:23:21
-- 描述		：侠客岛即时战报

local uiBattleScore = Ui:GetClass("battlescore")

--=======================================================

uiBattleScore.MAXNUM_JT = 10 -- 最多显示10个军团的信息

uiBattleScore.BTN_CLOSE = "BtnClose"
uiBattleScore.TXT_MYJTPLAYERNUM = "Txt_MyJTPlayerNum"
uiBattleScore.TXT_MYJTNAME = "Txt_MyJunTuanName"
uiBattleScore.TXT_REMAINTIME = "Txt_RemainTime"
uiBattleScore.TXT_KILLPLAYERSCORE = "Txt_KillPlayerScore"
uiBattleScore.TXT_KILLPLAYERNUM = "Txt_KillPlayerNum"
uiBattleScore.TXT_GAINRESSCORE = "Txt_GainResScore"
uiBattleScore.TXT_GAINRESNUM = "Txt_GainResNum"
uiBattleScore.TXT_PRORESSCORE = "Txt_ProResScore"
uiBattleScore.TXT_PRORESNUM = "Txt_ProResNum"
uiBattleScore.TXT_PLAYERRANK = "Txt_PlayerRank"
uiBattleScore.TXT_PLAYERTOTALSCORE = "Txt_PlayerTotalScore"
uiBattleScore.LST_JTINFO = "Lst_JTInfo"

--=======================================================

function uiBattleScore:OnOpen()
  local _, tbInfo = me.GetCampaignDate()
  self:UpdateInfo(tbInfo)
end

function uiBattleScore:OnButtonClick(szWnd)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiBattleScore:UpdateInfo(tbInfo)
  if not tbInfo then
    return 0
  end

  -- 军团名称
  local szMyJTName = "本方军团："
  if tbInfo.szJunTuanName then
    szMyJTName = szMyJTName .. tbInfo.szJunTuanName
  end

  -- 军团人数
  local szJTPlayerNum = "本方军团人数："
  if tbInfo.nJunTuanPlayerNum then
    szJTPlayerNum = szJTPlayerNum .. tbInfo.nJunTuanPlayerNum
  end

  -- 剩余时间
  local szRemainTime = "战局剩余时间："
  if tbInfo.nRemainTime then
    szRemainTime = szRemainTime .. self:GetLeftTime(tbInfo.nRemainTime)
  end

  local tbPlayerScore = tbInfo.tbPlayerScore or {}
  tbPlayerScore.tbKillPeople = tbPlayerScore.tbKillPeople or {}
  tbPlayerScore.tbGainRes = tbPlayerScore.tbGainRes or {}
  tbPlayerScore.tbProtectRes = tbPlayerScore.tbProtectRes or {}
  local nKillPlayerNum = tbPlayerScore.tbKillPeople.nCount or 0
  local nKillPlayerScore = tbPlayerScore.tbKillPeople.nScore or 0
  local nGainResNum = tbPlayerScore.tbGainRes.nCount or 0
  local nGainResScore = tbPlayerScore.tbGainRes.nScore or 0
  local nProResNum = tbPlayerScore.tbProtectRes.nCount or 0
  local nProResScore = tbPlayerScore.tbProtectRes.nScore or 0
  local nPlayerTotalScore = tbPlayerScore.nTotalScore or 0
  local nPlayerRank = tbPlayerScore.nRank or 0

  Txt_SetTxt(self.UIGROUP, self.TXT_MYJTNAME, szMyJTName)
  Txt_SetTxt(self.UIGROUP, self.TXT_MYJTPLAYERNUM, szJTPlayerNum)
  Txt_SetTxt(self.UIGROUP, self.TXT_REMAINTIME, szRemainTime)
  Txt_SetTxt(self.UIGROUP, self.TXT_KILLPLAYERNUM, nKillPlayerNum)
  Txt_SetTxt(self.UIGROUP, self.TXT_KILLPLAYERSCORE, nKillPlayerScore)
  Txt_SetTxt(self.UIGROUP, self.TXT_GAINRESNUM, nGainResNum)
  Txt_SetTxt(self.UIGROUP, self.TXT_GAINRESSCORE, nGainResScore)
  Txt_SetTxt(self.UIGROUP, self.TXT_PRORESNUM, nProResNum)
  Txt_SetTxt(self.UIGROUP, self.TXT_PRORESSCORE, nProResScore)
  Txt_SetTxt(self.UIGROUP, self.TXT_PLAYERTOTALSCORE, string.format("<color=gold>个人积分<color> %s", nPlayerTotalScore))
  Txt_SetTxt(self.UIGROUP, self.TXT_PLAYERRANK, string.format("<color=gold>排名<color> %s", nPlayerRank))

  local tbJTScore = tbInfo.tbJunTuanScore or {}
  for i, tbJTInfo in ipairs(tbJTScore) do
    local szJTName = tbJTInfo.szJunTuanName or ""
    local nJTScore = tbJTInfo.nScore or 0
    local nJTThrone = tbJTInfo.nThrone or 0
    Lst_SetCell(self.UIGROUP, self.LST_JTINFO, i, 0, szJTName)
    Lst_SetCell(self.UIGROUP, self.LST_JTINFO, i, 1, nJTScore)
    Lst_SetCell(self.UIGROUP, self.LST_JTINFO, i, 2, nJTThrone)
  end
end

function uiBattleScore:GetLeftTime(nLeftSec)
  if not nLeftSec or nLeftSec <= 0 then
    return 0
  end
  local nLeftMin = math.floor(nLeftSec / 60) -- 剩余分钟数
  local nLeftHour = math.floor(nLeftMin / 60) -- 剩余消失数
  nLeftMin = math.mod(nLeftMin, 60)
  local szRet = string.format("%s小时%s分钟", nLeftHour, nLeftMin)
  return szRet
end

-- 同步活动数据
function uiBattleScore:SyncCampaignDate(szType)
  if szType == "xkland_report" then
    local _, tbInfo = me.GetCampaignDate()
    self:UpdateInfo(tbInfo)
  end
end

function uiBattleScore:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_BATTLESCORE, self.SyncCampaignDate },
  }
  return tbRegEvent
end

-- 注册活动界面，才能用 ` 键打开
UiShortcutAlias:RegisterCampaignUi("xkland_report", Ui.UI_BATTLESCORE)
