Require("\\ui\\script\\logic\\messagelist.lua")

local tbMsgList = Ui.tbLogic.tbMessageList

local tbTeamApply = {}

function tbTeamApply:Init(tbInfo)
  local tbInfo = self:CreateLink(tbInfo[1])
  if not tbInfo then
    return
  end

  self.tbInfo = tbInfo

  local szText = "<" .. tbInfo.szDesc .. ">"
  local nId = MessageList_PushBtn(self.tbManager.UIGROUP, self.tbManager.szMessageListName, 0, szText, "gold", "black", 0)
  return nId
end

function tbTeamApply:GetShowMsg(tbInfo)
  local tbInfo = self:CreateLink(tbInfo)

  if not tbInfo then
    return ""
  end

  return "<" .. tbInfo.szDesc .. ">"
end

function tbTeamApply:CreateLink(tbParams)
  if #tbParams < 3 then
    return nil
  end
  local tbInfo = {}

  tbInfo.nPlayerId = tonumber(tbParams[1]) or 0
  tbInfo.szTeamName = tbParams[2]
  tbInfo.nTeamId = tonumber(tbParams[3]) or 0
  tbInfo.nTeamNum = tonumber(tbParams[4]) or 0

  local szText = ""
  if tbInfo.nTeamNum <= 0 then
    szText = "队伍解散"
  elseif tbInfo.nTeamNum >= 6 then
    szText = "队伍满员"
  else
    szText = "队伍未满"
  end

  tbInfo.szDesc = string.format("申请入队：%s", szText)
  return tbInfo
end

function tbTeamApply:Clear() end

function tbTeamApply:LeftClick()
  if self.tbInfo and self.tbInfo.nPlayerId and self.tbInfo.szTeamName then
    if self.tbInfo.nTeamId == 0 then
      return
    end
    me.TeamApply(self.tbInfo.nPlayerId, self.tbInfo.szTeamName, self.tbInfo.nTeamId, 1)
  end
end

tbTeamApply.ShiftLeftClick = tbTeamApply.LeftClick
tbTeamApply.CtrlLeftClick = tbTeamApply.LeftClick

tbMsgList:RegisterBaseClass("teamapply", tbTeamApply)
