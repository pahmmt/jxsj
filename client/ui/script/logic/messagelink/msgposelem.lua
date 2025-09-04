Require("\\ui\\script\\logic\\messagelist.lua")

local tbMsgList = Ui.tbLogic.tbMessageList

local tbPosElem = {}

function tbPosElem:Init(tbInfo)
  local tbPos = self:CreateLink(tbInfo[1])
  if not tbPos then
    return
  end

  self.tbPos = tbPos

  local szText = "<" .. tbPos.szDesc .. ">"
  local nId = MessageList_PushBtn(self.tbManager.UIGROUP, self.tbManager.szMessageListName, 0, szText, "blue", "black", 0)
  return nId
end

function tbPosElem:GetShowMsg(tbInfo)
  local tbPos = self:CreateLink(tbInfo)

  if not tbPos then
    return ""
  end

  return "<" .. tbPos.szDesc .. ">"
end

function tbPosElem:CreateLink(tbParams)
  local nMapId = tonumber(tbParams[1]) or 0
  local szMapName = GetMapNameFormId(nMapId)
  if not szMapName or szMapName == "" then
    return nil
  end
  local tbPos = { nMapId = nMapId }
  if #tbParams >= 3 then
    tbPos.nX = tonumber(tbParams[2])
    tbPos.nY = tonumber(tbParams[3])
    if not tbPos.nX or not tbPos.nY then
      return nil
    end
    if tbPos.nX <= 0 or tbPos.nX >= 32000 then
      return nil
    end
    if tbPos.nY <= 0 or tbPos.nY >= 32000 then
      return nil
    end
    tbPos.szDesc = string.format("%s:%d,%d", szMapName, tbPos.nX / 8, tbPos.nY / 16)
  else
    tbPos.szDesc = szMapName
  end
  return tbPos
end

function tbPosElem:Clear() end

function tbPosElem:LeftClick()
  Ui.tbLogic.tbAutoPath:OnChatClick(self.tbPos)
end

tbPosElem.ShiftLeftClick = tbPosElem.LeftClick
tbPosElem.CtrlLeftClick = tbPosElem.LeftClick

tbMsgList:RegisterBaseClass("pos", tbPosElem)
