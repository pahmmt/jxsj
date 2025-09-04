Require("\\ui\\script\\logic\\messagelist.lua")

local tbMsgList = Ui.tbLogic.tbMessageList

local tbTweetElem = {}

function tbTweetElem:Init(tbInfo)
  local tbLinkParams = tbInfo[1]
  self.nSnsId = tonumber(tbLinkParams[1])
  self.szAccount = tbLinkParams[2]
  self.szTweetId = tbLinkParams[3]

  self.szText = self:GetShowMsg(tbInfo)
  local nId = MessageList_PushBtn(self.tbManager.UIGROUP, self.tbManager.szMessageListName or szName, 0, self.szText, "blue", "black", 0)
  return nId
end

function tbTweetElem:Clear() end

function tbTweetElem:GetShowMsg(tbInfo)
  return "<ËÙ¶ÈÎ§¹Û>"
end

function tbTweetElem:LeftClick()
  local tbSns = Sns:GetSnsObject(self.nSnsId)
  local szUrl = tbSns:GetTweetUrl(self.szAccount, self.szTweetId)
  Sns:GoToUrl(szUrl)
end

tbMsgList:RegisterBaseClass("tweet", tbTweetElem)
