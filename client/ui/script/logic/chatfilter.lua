-------------------------------------------------------
-- 文件名　：chatfilter.lua
-- 创建者　：wangzhiguang
-- 创建时间：2011-06-17
-- 文件描述：客户端对收到的聊天信息进行过滤
-------------------------------------------------------

Require("\\ui\\script\\logic\\msgchannel.lua")

local SETTING_PATH = "\\user\\chat\\filter\\setting.txt"

--聊天频道分类
ChatFilter.CHAT_TYPE_NEAR = 1
ChatFilter.CHAT_TYPE_WORLD = 2
ChatFilter.CHAT_TYPE_CITY = 3
ChatFilter.CHAT_TYPE_PRIVATE = 4
ChatFilter.CHAT_TYPE_FACTION = 5
ChatFilter.CHAT_TYPE_KIN_TONG = 6

local tbFileName = {
  [ChatFilter.CHAT_TYPE_NEAR] = "near.txt",
  [ChatFilter.CHAT_TYPE_WORLD] = "world.txt",
  [ChatFilter.CHAT_TYPE_CITY] = "city.txt",
  [ChatFilter.CHAT_TYPE_PRIVATE] = "private.txt",
  [ChatFilter.CHAT_TYPE_FACTION] = "faction.txt",
  [ChatFilter.CHAT_TYPE_KIN_TONG] = "kintong.txt",
}

ChatFilter.tbHistory = {
  [ChatFilter.CHAT_TYPE_NEAR] = {},
  [ChatFilter.CHAT_TYPE_WORLD] = {},
  [ChatFilter.CHAT_TYPE_CITY] = {},
  [ChatFilter.CHAT_TYPE_PRIVATE] = {},
  [ChatFilter.CHAT_TYPE_FACTION] = {},
  [ChatFilter.CHAT_TYPE_KIN_TONG] = {},
}

local tbMsgChannel = Ui.tbLogic.tbMsgChannel
local tbTypeMap = {
  [tbMsgChannel.CHANNEL_WORLD] = ChatFilter.CHAT_TYPE_WORLD,
  [tbMsgChannel.CHANNEL_CITY] = ChatFilter.CHAT_TYPE_CITY,
  [tbMsgChannel.CHANNEL_NEAR] = ChatFilter.CHAT_TYPE_NEAR,
  [tbMsgChannel.CHANNEL_FACTION] = ChatFilter.CHAT_TYPE_FACTION,
  [tbMsgChannel.CHANNEL_KIN] = ChatFilter.CHAT_TYPE_KIN_TONG,
  [tbMsgChannel.CHANNEL_TONG] = ChatFilter.CHAT_TYPE_KIN_TONG,
}

function ChatFilter:GetChatTypeByChannelName(szChannelName)
  return tbTypeMap[szChannelName]
end

function ChatFilter:ShowAddFilterUi(szSender, szChatText)
  self:OpenInputDialog(szChatText)
  UiManager:OpenWindow(Ui.UI_CHATFILTER)
end

function ChatFilter:OpenInputDialog(szChatText)
  local tbParam = {}
  tbParam.tbTable = self
  tbParam.fnAccept = self.OnAddFilter
  tbParam.nMaxLen = 256
  tbParam.szTitle = "请输入过滤关键字"
  tbParam.varDefault = szChatText
  UiManager:OpenWindow(Ui.UI_TEXTINPUT, tbParam)
end

function ChatFilter:OnAddFilter(szFilter)
  if szFilter and #szFilter > 0 then
    self:AddFilter(szFilter)
    if UiManager:WindowVisible(Ui.UI_CHATFILTER) == 1 then
      Ui(Ui.UI_CHATFILTER):UpdateFilterList()
    end
  end
end

function ChatFilter:SaveSetting()
  local szData = Lib:Val2Str(self.tbFilter)
  KFile.WriteFile(SETTING_PATH, szData)
end

function ChatFilter:LoadSetting()
  local tbFilter = nil
  local szData = KIo.ReadTxtFile(SETTING_PATH)
  if szData then
    tbFilter = Lib:Str2Val(szData)
  end
  if tbFilter then
    self.tbFilter = tbFilter
  else
    self.tbFilter = {}
    KFile.WriteFile(SETTING_PATH, "")
  end
end

function ChatFilter:GetFilterList()
  return self.tbFilter
end

function ChatFilter:GetFilteredCount(nChatType)
  return self.tbFilteredCount[nChatType] or 0
end

function ChatFilter:AddFilter(szFilter)
  for _, szTemp in ipairs(self.tbFilter) do
    if szTemp == szFilter then
      return 0
    end
  end
  table.insert(self.tbFilter, szFilter)
  self:SaveSetting()
  return 1
end

function ChatFilter:RemoveFilter(szFilter)
  local nIndex = nil
  for n, szTemp in ipairs(self.tbFilter) do
    if szTemp == szFilter then
      nIndex = n
      break
    end
  end
  if nIndex then
    table.remove(self.tbFilter, nIndex)
    self:SaveSetting()
    return 1
  else
    return 0
  end
end

function ChatFilter:Init()
  self.tbFilteredCount = {
    [self.CHAT_TYPE_NEAR] = 0,
    [self.CHAT_TYPE_WORLD] = 0,
    [self.CHAT_TYPE_CITY] = 0,
    [self.CHAT_TYPE_PRIVATE] = 0,
    [self.CHAT_TYPE_FACTION] = 0,
    [self.CHAT_TYPE_KIN_TONG] = 0,
  }
  self:LoadSetting()
end

-- 子字符串匹配
function ChatFilter:IsChatMsgAllowed(nType, szSender, szChatMsg)
  for _, szFilter in ipairs(self.tbFilter or {}) do
    --注意，string.find的第4个参数指定了plain匹配而不是pattern匹配
    if string.find(szChatMsg, szFilter, 1, 1) then
      self:AppendFilterHistory(nType, szSender, szChatMsg)
      local nCount = self.tbFilteredCount[nType]
      self.tbFilteredCount[nType] = nCount + 1
      if UiManager:WindowVisible(Ui.UI_CHATFILTER) == 1 then
        Ui(Ui.UI_CHATFILTER):UpdateFilteredCount()
      end
      return 0
    end
  end
  return 1
end

function ChatFilter:AppendFilterHistory(nType, szSender, szChatMsg)
  local szData = GetLocalDate("%Y-%m-%d %H:%M:%S\r\n") .. szSender .. ":" .. szChatMsg
  table.insert(self.tbHistory[nType], szData)
end

-- path example:
-- \user\4cb1b2e89ladbdab649\chatfilter\world.txt
function ChatFilter:WriteFilterHistoryToFile(nType)
  local szFileName = tbFileName[nType]
  if not szFileName then
    return
  end
  local szFullPath = GetRootPath() .. GetPlayerPrivatePath() .. "chatfilter\\" .. szFileName
  local szHistory = table.concat(self.tbHistory[nType], "\r\n\r\n")
  KIo.WriteFile(szFullPath, szHistory)
  return szFullPath
end

function ChatFilter:ClearHistory(nType)
  self.tbHistory[nType] = {}
  self.tbFilteredCount[nType] = 0
end

function ChatFilter:ShowFilterHistory(nChatType)
  local szFullPath = self:WriteFilterHistoryToFile(nChatType)
  self:ClearHistory(nChatType)
  ShellExecute(szFullPath)
  Ui(Ui.UI_CHATFILTER):UpdateFilteredCount()
end
