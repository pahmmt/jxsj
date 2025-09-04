--=================================================
-- 文件名　：msgachievementdsc.lua
-- 创建者　：furuilei
-- 创建时间：2010-07-27 10:49:50
-- 功能描述：成就系统，成就描述标签
--=================================================

Require("\\ui\\script\\logic\\messagelist.lua")

local tbMsgList = Ui.tbLogic.tbMessageList

local tbAchievementDscElem = {}

function tbAchievementDscElem:Init(tbInfo)
  local szName, nAchievementId = self:CreateLink(tbInfo[1])
  if not szName or not nAchievementId or nAchievementId <= 0 then
    return
  end
  self.nAchievementId = nAchievementId

  local szText = "<" .. szName .. ">"
  local nId = MessageList_PushBtn(self.tbManager.UIGROUP, self.tbManager.szMessageListName, 0, szText, "blue", "black", 0)
  return nId
end

function tbAchievementDscElem:GetShowMsg(tbInfo)
  local szName = self:CreateLink(tbInfo)

  if not szName then
    return ""
  end

  return "<" .. szName .. ">"
end

function tbAchievementDscElem:CreateLink(tbParams)
  local nAchievementId = tonumber(tbParams[1]) or 0
  local szAchievementName = Achievement:GetAchievementName(nAchievementId)
  return szAchievementName, nAchievementId
end

-- 左键点击操作，打开成就界面
function tbAchievementDscElem:LeftClick()
  local tbAchievementInfo = self:GetAchievementInfo()
  if not tbAchievementInfo then
    return
  end

  local szName = tbAchievementInfo.szAchivementName or ""
  local szDesc = tbAchievementInfo.szDesc or ""
  local bFinished = Achievement:CheckFinished(self.nAchievementId) or 0
  local nLevel = tbAchievementInfo.nLevel or 0
  local szLevel = ""
  for i = 1, nLevel do
    szLevel = szLevel .. "★"
  end
  local szFinished = ""
  if 1 == bFinished then
    szFinished = "<color=green>你已经完成该成就<color>"
  else
    szFinished = "<color=red>你还没有完成该成就<color>"
  end

  local szMsg = string.format("\n<color=gold>%s<color>\n<color=yellow>%s<color>\n\n%s", szLevel, szDesc, szFinished)
  ShowEquipLink(szName, szMsg, "")
end

function tbAchievementDscElem:Clear() end

function tbAchievementDscElem:GetAchievementInfo()
  local nAchievementId = self.nAchievementId
  if not nAchievementId or nAchievementId <= 0 then
    return
  end

  local nGroupId, nSubGroupId, nIndex = Achievement:GetIndexInfoById(nAchievementId)
  if not nGroupId or not nSubGroupId or not nIndex then
    return
  end

  local tbAchievementInfo = Achievement:GetAchievementInfo(nGroupId, nSubGroupId, nIndex)
  return tbAchievementInfo
end

tbAchievementDscElem.ShiftLeftClick = tbAchievementDscElem.LeftClick
tbAchievementDscElem.CtrlLeftClick = tbAchievementDscElem.LeftClick

tbMsgList:RegisterBaseClass("achievementdsc", tbAchievementDscElem)
