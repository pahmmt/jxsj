----chatnewmsg.lua
----作者：孙多良
----2012-06-08
----info：

local uiChat_newmsg = Ui:GetClass("chatnewmsg")

uiChat_newmsg.TxtNewMsg = "TxtNewMsg"
uiChat_newmsg.DEF_SHOW_TIME = 8 * 18

function uiChat_newmsg:OnOpen(szChannelName, szName, szMsg)
  self:UpdateTxt(szChannelName, szName, szMsg)
end

function uiChat_newmsg:UpdateTxt(szChannelName, szName, szMsg)
  if self.TimerId then
    Timer:Close(self.TimerId)
    self.TimerId = nil
  end

  local tbMsgPad = Ui(Ui.UI_MSGPAD)
  local tbTabCont = tbMsgPad.tbChannelTabMgr.tbTabCont
  local szActiveTab = Ui(Ui.UI_CHATTAB).szActiveTabName
  if not tbTabCont[szActiveTab] then
    return 0
  end
  if not tbTabCont[szActiveTab].tbChannelCont[szChannelName] then
    return 0
  end
  --窗口在分页上方

  self:ShowTxt(szChannelName, szName, szMsg)
  self.TimerId = Timer:Register(self.DEF_SHOW_TIME, self.ShowTxtEnd, self)
end

function uiChat_newmsg:ShowTxt(szChannelName, szName, szMsg)
  local tbMsgChannel = Ui.tbLogic.tbMsgChannel
  local szSendChannelPic = tbMsgChannel.tbChannelPic[szChannelName][1]
  local szSend = string.format("<pic=%s>%s:%s", szSendChannelPic, szName, self:Flite(szMsg))
  TxtEx_SetText(self.UIGROUP, self.TxtNewMsg, szSend)
end

function uiChat_newmsg:ShowTxtEnd()
  self.TimerId = nil
  UiManager:CloseWindow(self.UIGROUP)
  return 0
end

uiChat_newmsg.tbKey = {
  --标签key = {类型(1取道具名，0直接显示描述)，显示描述}
  ["item="] = { 1, "物品名" },
  ["sell="] = { 1, "物品名" },
  ["teamapply="] = { 0, "<申请入队>" },
  ["achievementdsc="] = { 3, "成就" },
  ["pos="] = { 4, "坐标" },
}

--过滤标签点击标签
function uiChat_newmsg:Flite(szMsg)
  for szKey in pairs(self.tbKey) do
    local nFlag, szMsgRetrun = self:Find(szMsg, szKey)
    if nFlag == 1 then
      szMsg = szMsgRetrun
      break
    end
  end
  return szMsg
end

function uiChat_newmsg:Find(szMsg, szKey)
  local nFindFlag = 0
  if not self.tbKey[szKey] then
    return nFindFlag, szMsg
  end

  local nType = self.tbKey[szKey][1]
  local szShowMsg = self.tbKey[szKey][2]
  local nS, nE = string.find(szMsg, "<" .. szKey)
  if nS and nS > 0 then
    local nS2, nE2 = string.find(szMsg, ">", nS)
    if nS2 and nS2 > 0 then
      local szKeyHead = string.sub(szMsg, 1, nS - 1)
      local szKeyParam = string.sub(szMsg, nE + 1, nS2 - 1)
      local szKeyBottom = string.sub(szMsg, nS2 + 1, -1)
      if nType == 1 then
        local tbParam = Lib:SplitStr(szKeyParam, ",")
        szShowMsg = string.format("<%s>", KItem.GetNameById(tonumber(tbParam[2]), tonumber(tbParam[3]), tonumber(tbParam[4]), tonumber(tbParam[5])))
      end
      if nType == 3 then
        local nAchievementId = tonumber(szKeyParam) or 0
        local tbParam = Achievement:GetAchievementInfoById(nAchievementId) or {}
        szShowMsg = string.format("<%s>", (tbParam.szAchivementName or ""))
      end
      if nType == 4 then
        local tbParam = Lib:SplitStr(szKeyParam, ",")
        local szMapName = GetMapPath(tonumber(tbParam[1]))
        local nPosX = math.floor(tonumber(tbParam[2]) / 8)
        local nPosY = math.floor(tonumber(tbParam[3]) / 16)
        szShowMsg = string.format("<%s,%s,%s>", szMapName, nPosX, nPosY)
      end
      nFindFlag = 1
      szMsg = szKeyHead .. szShowMsg .. szKeyBottom
    end
  end
  return nFindFlag, szMsg
end
