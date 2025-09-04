-----------------------------------------------------
--文件名	：	skillprogress.lua
--创建者	：	tongxuehu@kingsoft.net
--创建时间	：	2007-5-18
--功能描述	：	技能引导条
------------------------------------------------------

local tbSkillProgress = Ui:GetClass("skillprogress")

local PRG_PROGRESS = "PrgProgress"
local TXT_MSG = "TxtMsg"
local TXT_PROGRESS = "TxtProgress"

function tbSkillProgress:OnOpen()
  local nTimerId, nInterval, szMsg = me.GetTimerBar()
  if nInterval and szMsg then
    if nInterval > 0 then
      Txt_SetTxt(self.UIGROUP, TXT_MSG, szMsg)
      Txt_SetTxt(self.UIGROUP, TXT_PROGRESS, "0%")
      Prg_SetTime(self.UIGROUP, PRG_PROGRESS, math.floor(nInterval / Env.GAME_FPS * 1000))
    else
      return 0
    end
  end
  return 1
end

function tbSkillProgress:OnEndProgress()
  UiManager:CloseWindow(self.UIGROUP)
end

function tbSkillProgress:OnProgressFull(szWnd)
  if szWnd == PRG_PROGRESS then
    self:OnEndProgress()
  end
end

function tbSkillProgress:AcrossPercent(nCurPercent)
  Txt_SetTxt(self.UIGROUP, TXT_PROGRESS, tostring(nCurPercent) .. "%")
end

function tbSkillProgress:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_STOPPROCESSTAG, self.OnEndProgress },
    { UiNotify.emCOREEVENT_STOPGENERALPROCESS, self.OnEndProgress },
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.OnEndProgress },
    { UiNotify.emCOREEVENT_PROGRESSBAR_ACROSSPERCENT, self.AcrossPercent }, -- TODO: xyf 不能这么搞！！，要CORE来通知
  }
  return tbRegEvent
end
