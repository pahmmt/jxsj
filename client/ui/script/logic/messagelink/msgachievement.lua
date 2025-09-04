--=================================================
-- 文件名　：msgachievement.lua
-- 创建者　：furuilei
-- 创建时间：2010-07-21 15:07:47
-- 功能描述：聊天栏成就标签
--=================================================

Require("\\ui\\script\\logic\\messagelist.lua")

local tbMsgList = Ui.tbLogic.tbMessageList

local tbAchievementElem = {}

function tbAchievementElem:Init(tbInfo)
  local szName, nAchievementId = self:CreateLink(tbInfo[1])
  if not szName or not nAchievementId or nAchievementId <= 0 then
    return
  end
  self.nAchievementId = nAchievementId

  local szText = "<" .. szName .. ">"
  local nId = MessageList_PushBtn(self.tbManager.UIGROUP, self.tbManager.szMessageListName, 0, szText, "blue", "black", 0)
  return nId
end

function tbAchievementElem:GetShowMsg(tbInfo)
  local szName = self:CreateLink(tbInfo)

  if not szName then
    return ""
  end

  return "<" .. szName .. ">"
end

function tbAchievementElem:CreateLink(tbParams)
  local nAchievementId = tonumber(tbParams[1]) or 0
  local szAchievementName = Achievement:GetAchievementName(nAchievementId)
  return szAchievementName, nAchievementId
end

-- 左键点击操作，打开成就界面
function tbAchievementElem:LeftClick()
  local nGroupId, nSubGroupId, nIndex = Achievement:GetIndexInfoById(self.nAchievementId)
  if not nGroupId or not nSubGroupId or not nIndex then
    return
  end
  UiManager:OpenWindow(Ui.UI_ACHIEVEMENT, 1, nGroupId, nSubGroupId, nIndex)
end

function tbAchievementElem:Clear() end

tbAchievementElem.ShiftLeftClick = tbAchievementElem.LeftClick
tbAchievementElem.CtrlLeftClick = tbAchievementElem.LeftClick

tbMsgList:RegisterBaseClass("achievement", tbAchievementElem)
