Require("\\ui\\script\\logic\\messagelist.lua")

local tbMsgList = Ui.tbLogic.tbMessageList

local tbNormalElem = {}

function tbNormalElem:Init(tbInfo, szName)
  self.szText = tbInfo[1]
  self.nColor = tbInfo[2]
  self.nBlkColor = tbInfo[3]
  self.IsSystem = tbInfo[4]

  local bFiterColor = 1
  if self.IsSystem == 1 then
    bFiterColor = 0
  end

  local nId = MessageList_PushString(self.tbManager.UIGROUP, self.tbManager.szMessageListName or szName, 0, self.szText, self.nColor, self.nBlkColor, bFiterColor)
  return nId
end

function tbNormalElem:Clear() end

function tbNormalElem:GetShowMsg(tbInfo)
  return tbInfo[1]
end

tbMsgList:RegisterBaseClass("normal", tbNormalElem)
