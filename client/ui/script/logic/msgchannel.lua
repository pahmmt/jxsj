Ui.tbLogic.tbMsgChannel = {}
local tbMsgChannel = Ui.tbLogic.tbMsgChannel
local tbMessageList = Ui.tbLogic.tbMessageList

local szPathName001 = "\\image\\ui\\001a\\main\\chatchanel\\"
local szPathName002 = "\\image\\ui\\002a\\chatinput\\chanel\\"

tbMsgChannel.CHANNEL_WORLD = "World"
tbMsgChannel.CHANNEL_TEAM = "Team"
tbMsgChannel.CHANNEL_FRIEND = "Friend"
tbMsgChannel.CHANNEL_CITY = "City"
tbMsgChannel.CHANNEL_NEAR = "NearBy"
tbMsgChannel.CHANNEL_TONG = "Tong"
tbMsgChannel.CHANNEL_FACTION = "Faction"
tbMsgChannel.CHANNEL_KIN = "Kin"
tbMsgChannel.CHANNEL_SONG = "Song"
tbMsgChannel.CHANNEL_KING = "King"
tbMsgChannel.CHANNEL_SYSTEM = "GM"
tbMsgChannel.CHANNEL_ME = "Me" -- 不需要订阅
tbMsgChannel.CHANNEL_PERSONAL = "Personal" -- 不需要订阅
tbMsgChannel.CHANNEL_SERVER = "Server"
tbMsgChannel.CHANNEL_GLOBAL = "Global"

tbMsgChannel.CHANNEL_DYN = "Dyn" -- 不需要订阅
tbMsgChannel.tbSpeTitleImage = {}
tbMsgChannel.tbGVSprChat = {}

tbMsgChannel.TAB_COMMON = "公共"
tbMsgChannel.TAB_PRIVATE = "私聊"
tbMsgChannel.TAB_FRIEND = "好友"
tbMsgChannel.TAB_TONG = "帮聊"
tbMsgChannel.TAB_OTHER = "其他"
tbMsgChannel.TAB_CUSTOM = "自定义"
tbMsgChannel.TAB_TRANSFER = "源服"

tbMsgChannel.TB_TEXT_COLOR = {
  [tbMsgChannel.CHANNEL_GLOBAL] = "189,101,255",
  [tbMsgChannel.CHANNEL_WORLD] = "146,255,143",
  [tbMsgChannel.CHANNEL_TEAM] = "64,190,255",
  [tbMsgChannel.CHANNEL_FACTION] = "225,210,165",
  [tbMsgChannel.CHANNEL_FRIEND] = "orange",
  [tbMsgChannel.CHANNEL_CITY] = "169,255,224",
  [tbMsgChannel.CHANNEL_NEAR] = "255,255,255",
  [tbMsgChannel.CHANNEL_TONG] = "255,244,0",
  [tbMsgChannel.CHANNEL_KIN] = "190,190,240",
  [tbMsgChannel.CHANNEL_SONG] = "255,182,124",
  [tbMsgChannel.CHANNEL_KING] = "255,245,66",
  [tbMsgChannel.CHANNEL_SYSTEM] = "255,0,0",
  [tbMsgChannel.CHANNEL_ME] = "255,226,168",
  [tbMsgChannel.CHANNEL_PERSONAL] = "252,151,255",
  [tbMsgChannel.CHANNEL_DYN] = "255,182,124",
  [tbMsgChannel.CHANNEL_SERVER] = "0,255,0",
}

tbMsgChannel.TB_TEXT_BORDER_COLOR = {
  [tbMsgChannel.CHANNEL_GLOBAL] = "0,45,0",
  [tbMsgChannel.CHANNEL_WORLD] = "0,45,0",
  [tbMsgChannel.CHANNEL_TEAM] = "11,0,134",
  [tbMsgChannel.CHANNEL_FACTION] = "45,40,15",
  [tbMsgChannel.CHANNEL_FRIEND] = "black",
  [tbMsgChannel.CHANNEL_CITY] = "19,19,19",
  [tbMsgChannel.CHANNEL_NEAR] = "49,21,0",
  [tbMsgChannel.CHANNEL_TONG] = "73,0,0",
  [tbMsgChannel.CHANNEL_KIN] = "50,35,120",
  [tbMsgChannel.CHANNEL_SONG] = "87,57,8",
  [tbMsgChannel.CHANNEL_KING] = "87,57,8",
  [tbMsgChannel.CHANNEL_SYSTEM] = "black",
  [tbMsgChannel.CHANNEL_ME] = "204,88,0",
  [tbMsgChannel.CHANNEL_PERSONAL] = "80,17,117",
  [tbMsgChannel.CHANNEL_DYN] = "0,0,0",
  [tbMsgChannel.CHANNEL_SERVER] = "black",
}

tbMsgChannel.TB_MENUBK_COLOR = {
  [tbMsgChannel.CHANNEL_GLOBAL] = "32,32,32",
  [tbMsgChannel.CHANNEL_WORLD] = "32,32,32",
  [tbMsgChannel.CHANNEL_TEAM] = "32,32,32",
  [tbMsgChannel.CHANNEL_FACTION] = "32,32,32",
  [tbMsgChannel.CHANNEL_FRIEND] = "32,32,32",
  [tbMsgChannel.CHANNEL_CITY] = "32,32,32",
  [tbMsgChannel.CHANNEL_NEAR] = "32,32,32",
  [tbMsgChannel.CHANNEL_TONG] = "32,32,32",
  [tbMsgChannel.CHANNEL_KIN] = "32,32,32",
  [tbMsgChannel.CHANNEL_SONG] = "32,32,32",
  [tbMsgChannel.CHANNEL_KING] = "32,32,32",
  [tbMsgChannel.CHANNEL_SYSTEM] = "32,32,32",
  [tbMsgChannel.CHANNEL_ME] = "32,32,32",
  [tbMsgChannel.CHANNEL_PERSONAL] = "32,32,32",
  [tbMsgChannel.CHANNEL_DYN] = "32,32,32",
  [tbMsgChannel.CHANNEL_SERVER] = "0,0,255",
}

tbMsgChannel.CHANNEL_CUSTOM_PROC = {
  [tbMsgChannel.CHANNEL_GLOBAL] = "Global_Custom_Proc",
  [tbMsgChannel.CHANNEL_WORLD] = "World_Custom_Proc",
  [tbMsgChannel.CHANNEL_TEAM] = "Team_Custom_Proc",
  [tbMsgChannel.CHANNEL_FACTION] = "Faction_Custom_Proc",
  [tbMsgChannel.CHANNEL_FRIEND] = "Friend_Custom_Proc",
  [tbMsgChannel.CHANNEL_CITY] = "City_Custom_Proc",
  [tbMsgChannel.CHANNEL_NEAR] = "Near_Custom_Proc",
  [tbMsgChannel.CHANNEL_TONG] = "Tong_Custom_Proc",
  [tbMsgChannel.CHANNEL_KIN] = "Kin_Custom_Proc",
  [tbMsgChannel.CHANNEL_SONG] = "Song_Custom_Proc",
  [tbMsgChannel.CHANNEL_KING] = "King_Custom_Proc",
  [tbMsgChannel.CHANNEL_SYSTEM] = "System_Custom_Proc",
  [tbMsgChannel.CHANNEL_ME] = "Me_Custom_Proc",
  [tbMsgChannel.CHANNEL_PERSONAL] = "Personal_Custom_Proc",
  [tbMsgChannel.CHANNEL_DYN] = "Dyn_Custom_Proc",
}

function tbMsgChannel:Init()
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_OPEN_CHANNEL, self.OnOpenChannel, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_CHAT_OPEN_DYNCHANNEL, self.OnOpenDynChannel, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_CHAT_CLOSE_DYNCHANNEL, self.OnCloseDynChannel, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_MAIL_LOADED, self.OnCloseDynChannel, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_CHAT_DYNCHANNELINFO, self.SetDynChannelInfo, self)
  self.tbGVSprChatPicId = {}
  self.tbSpeTitleImage = {}
  self.tbChannelPic = {} -- 频道内容图标
  self.tbShortTextPic = {} -- 选择频道按钮图标
  self.tbDynShortTextPic = {} -- 选择动态按钮图标
  self.tbActiveChannel = {} -- 已经打开频道的顺序表（按服务端通知的先后次序，为兼容外围其他地方调用出来的东西 :~( ）
  self.tbChannel_Name_Key_Id = {

    -- Name(Ui 频道的唯一标示)		-- szChannelKey(服务端交互KEY "\"符号是交给gc验证, 带\ 的服务端只验证第一个字母 挫啊！！)--nChannelId（和服务端的交互Id）--nChannelType 由服务端同步过来的（确定频道，这个交互机制有问题）
    [tbMsgChannel.CHANNEL_GLOBAL] = { nChannelId = -2, nCost = 0, nChannelType = 2, szShortName = "广", szMenuText = "大区频道" },
    [tbMsgChannel.CHANNEL_WORLD] = { nChannelId = -2, nCost = 0, nChannelType = 2, szShortName = "公", szMenuText = "世界频道" },
    [tbMsgChannel.CHANNEL_TEAM] = { nChannelId = -2, nCost = 0, nChannelType = 5, szShortName = "队", szMenuText = "队伍频道" },
    [tbMsgChannel.CHANNEL_FRIEND] = { nChannelId = -2, nCost = 0, nChannelType = 13, szShortName = "友", szMenuText = "好友频道" },
    [tbMsgChannel.CHANNEL_CITY] = { nChannelId = -2, nCost = 0, nChannelType = 4, szShortName = "城", szMenuText = "城市频道" },
    [tbMsgChannel.CHANNEL_NEAR] = { nChannelId = -2, nCost = 0, nChannelType = 1, szShortName = "近", szMenuText = "附近玩家" },
    [tbMsgChannel.CHANNEL_TONG] = { nChannelId = -2, nCost = 0, nChannelType = 7, szShortName = "帮", szMenuText = "帮会频道" },
    [tbMsgChannel.CHANNEL_FACTION] = { nChannelId = -2, nCost = 0, nChannelType = 9, szShortName = "派", szMenuText = "门派频道" },
    [tbMsgChannel.CHANNEL_KIN] = { nChannelId = -2, nCost = 0, nChannelType = 6, szShortName = "族", szMenuText = "家族频道" },
    [tbMsgChannel.CHANNEL_SONG] = { nChannelId = -2, nCost = 0, nChannelType = 0, szShortName = "宋", szMenuText = "宋方频道" }, -- 动态名字
    [tbMsgChannel.CHANNEL_KING] = { nChannelId = -2, nCost = 0, nChannelType = 0, szShortName = "金", szMenuText = "金方频道" }, -- 动态名字
    [tbMsgChannel.CHANNEL_SYSTEM] = { nChannelId = -2, nCost = 0, nChannelType = 3, szShortName = "GM", szMenuText = "系统频道" },
    [tbMsgChannel.CHANNEL_SERVER] = { nChannelId = -2, nCost = 0, nChannelType = 15, szShortName = "服", szMenuText = "同服频道" },
    [tbMsgChannel.CHANNEL_ME] = { nChannelId = -2 }, -- 不需要订阅
    [tbMsgChannel.CHANNEL_PERSONAL] = { nChannelId = -2 }, -- 不需要订阅
    -- 由服务端主动通知KEY为动态
    [tbMsgChannel.CHANNEL_DYN] = { szChannelKey = "Dyn", nChannelId = -2 }, -- 不需要订阅
  }

  self.tbChannelSendInterval = { -- 间隔时间			-- 最大缓存代发的数量--最后一次发送的时间 -- 存放消息的队列
    [tbMsgChannel.CHANNEL_GLOBAL] = { nMsgInterval = 6000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_WORLD] = { nMsgInterval = 60000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_TEAM] = { nMsgInterval = 800, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_FRIEND] = { nMsgInterval = 5000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_CITY] = { nMsgInterval = 20000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_NEAR] = { nMsgInterval = 2000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_TONG] = { nMsgInterval = 10000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_FACTION] = { nMsgInterval = 10000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_KIN] = { nMsgInterval = 10000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_SONG] = { nMsgInterval = 2000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_KING] = { nMsgInterval = 2000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_SYSTEM] = { nMsgInterval = 15000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_ME] = { nMsgInterval = 0, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_PERSONAL] = { nMsgInterval = 0, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_SERVER] = { nMsgInterval = 5000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} },
    [tbMsgChannel.CHANNEL_DYN] = { nMsgInterval = 20000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} }, -- 不需要订阅
  }

  self:InitSpeTitle()
  self:InitChannelInlinePic()
end

function tbMsgChannel:InitSpeTitle()
  local tbTab = Lib:LoadTabFile("\\setting\\misc\\npcspetitleimage.txt")
  for _, tbInfo in ipairs(tbTab or {}) do
    local nId = tonumber(tbInfo["ID"]) or 0
    local nShow = tonumber(tbInfo["SHOWCHAT"]) or 0
    local szSpr = tbInfo["IMAGE"]
    local nPicId = (tonumber(tbInfo["PICID"]) - 1) or 0
    if nShow == 1 then
      self.tbSpeTitleImage[nId] = szSpr
      self.tbGVSprChatPicId[nId] = nPicId
    end
  end
end
function tbMsgChannel:InitChannelInlinePic()
  local szPath = szPathName002
  if UiVersion == Ui.Version001 then
    szPath = szPathName001
  end
  -- 聊天内容对应频道显示的图标例如 ：【近】 【友】
  tbMsgChannel.tbChannelPic = { -- 还用旧图标
    [tbMsgChannel.CHANNEL_GLOBAL] = { szPathName001 .. "chanel_area" .. UiManager.IVER_szVnSpr, 0 },
    [tbMsgChannel.CHANNEL_WORLD] = { szPathName001 .. "chanel_world.spr", 0 },
    [tbMsgChannel.CHANNEL_TEAM] = { szPathName001 .. "chanel_team" .. UiManager.IVER_szVnSpr, 0 },
    [tbMsgChannel.CHANNEL_FRIEND] = { szPathName001 .. "chanel_friends.spr", 0 },
    [tbMsgChannel.CHANNEL_CITY] = { szPathName001 .. "chanel_city.spr", 0 },
    [tbMsgChannel.CHANNEL_NEAR] = { szPathName001 .. "chanel_nearby.spr", 0 },
    [tbMsgChannel.CHANNEL_TONG] = { szPathName001 .. "chanel_tong" .. UiManager.IVER_szVnSpr, 0 },
    [tbMsgChannel.CHANNEL_FACTION] = { szPathName001 .. "chanel_faction.spr", 0 },
    [tbMsgChannel.CHANNEL_KIN] = { szPathName001 .. "chat_room_flag.spr", 0 },
    [tbMsgChannel.CHANNEL_SONG] = { szPathName001 .. "chanel_song.spr", 0 },
    [tbMsgChannel.CHANNEL_KING] = { szPathName001 .. "chanel_jin.spr", 0 },
    [tbMsgChannel.CHANNEL_SYSTEM] = { szPathName001 .. "chanel_gm.spr", 0 },
    [tbMsgChannel.CHANNEL_ME] = { szPathName001 .. "chanel_me.spr", 0 },
    [tbMsgChannel.CHANNEL_PERSONAL] = { szPathName001 .. "chanel_personal.spr", 0 },
    [tbMsgChannel.CHANNEL_SERVER] = { szPathName001 .. "chanel_server.spr", 0 },
    [tbMsgChannel.CHANNEL_DYN] = { szPathName001 .. "chanel_fight" .. UiManager.IVER_szVnSpr, 0 },
  }

  -- 选择聊天频道对应的那个圆圈上写字的的图标
  tbMsgChannel.tbShortTextPic = {
    [tbMsgChannel.CHANNEL_GLOBAL] = { szPath .. "btn_chanel_area" .. UiManager.IVER_szVnSpr, 0 }, --图片由服务端指定
    [tbMsgChannel.CHANNEL_WORLD] = { szPath .. "btn_chanel_world.spr", 0 },
    [tbMsgChannel.CHANNEL_TEAM] = { szPath .. "btn_chanel_team" .. UiManager.IVER_szVnSpr, 0 },
    [tbMsgChannel.CHANNEL_FRIEND] = { szPath .. "btn_chanel_friends.spr", 0 },
    [tbMsgChannel.CHANNEL_CITY] = { szPath .. "btn_chanel_city.spr", 0 },
    [tbMsgChannel.CHANNEL_NEAR] = { szPath .. "btn_chanel_nearby.spr", 0 },
    [tbMsgChannel.CHANNEL_TONG] = { szPath .. "btn_chanel_tong" .. UiManager.IVER_szVnSpr, 0 },
    [tbMsgChannel.CHANNEL_FACTION] = { szPath .. "btn_chanel_faction.spr", 0 },
    [tbMsgChannel.CHANNEL_KIN] = { szPath .. "btn_select_chanel.spr", 0 },
    [tbMsgChannel.CHANNEL_SONG] = { szPath .. "btn_chanel_song.spr", 0 },
    [tbMsgChannel.CHANNEL_KING] = { szPath .. "btn_chanel_kin.spr", 0 },
    [tbMsgChannel.CHANNEL_PERSONAL] = { szPath .. "btn_chanel_personal.spr", 0 },
    [tbMsgChannel.CHANNEL_SYSTEM] = { szPath .. "btn_chanel_gm.spr", 0 },
    [tbMsgChannel.CHANNEL_SERVER] = { szPath .. "btn_chanel_server.spr", 0 },
    [tbMsgChannel.CHANNEL_DYN] = { szPath .. "btn_chanel_fight" .. UiManager.IVER_szVnSpr, 0 }, --图片由服务端指定
  }

  -- 选择聊天频道对应的那个圆圈上写字的的图标	（这个是动态的由服务端发送id过来，客户端显示ID对应的图标）
  tbMsgChannel.tbDynShortTextPic = {
    [0] = { szPath .. "btn_chanel_song.spr", 0 },
    [1] = { szPath .. "btn_chanel_jin.spr", 0 },
  }

  -- 以下是初始化注册图标
  for i, tbPic in pairs(self.tbChannelPic) do
    local nPicId = RegInlinePic(tbPic[1])
    tbPic[2] = nPicId
  end

  for i, tbPic in pairs(self.tbShortTextPic) do
    local nPicId = RegInlinePic(tbPic[1])
    tbPic[2] = nPicId
  end

  for i, tbPic in pairs(self.tbDynShortTextPic) do
    local nPicId = RegInlinePic(tbPic[1])
    tbPic[2] = nPicId
  end

  for szKeyId, szSpr in pairs(self.tbSpeTitleImage) do
    self.tbGVSprChat[szKeyId] = RegInlinePic(szSpr)
  end
end

-- 根据频道名查询对应聊天内容图标
function tbMsgChannel:GetPicIdByChannelName(szName)
  for szChannelName, tbPic in pairs(self.tbChannelPic) do
    if szName == szChannelName then
      return tbPic[2]
    end
  end
end

-- 查询所有频道 (进入游戏前调用)
function tbMsgChannel:LoadChannelSetting()
  --	for szName, tbKeyId in pairs(self.tbChannel_Name_Key_Id) do
  --		tbKeyId.nChannelId = -2;
  --	end
  --self:QueryAllChannel();
end

function tbMsgChannel:QueryAllChannel()
  --	self.tbActiveChannel = {};
  --	for szName, tbKeyId in pairs(self.tbChannel_Name_Key_Id) do
  --		tbKeyId.nChannelId = -2;
  --	end
  KChatChannel.UpdateChannel()
end

-- 得到已经打开的频道
function tbMsgChannel:GetActiveChannelCont()
  local tbActiveChannelName = {}
  for i, szActiveName in pairs(self.tbActiveChannel) do
    table.insert(tbActiveChannelName, szActiveName)
  end
  return tbActiveChannelName
end

-- 添加已经打开的的频道
function tbMsgChannel:AddActiveChannel(szChannelName)
  for i, szActiveName in pairs(self.tbActiveChannel) do
    if szActiveName == szChannelName then
      return
    end
  end
  table.insert(self.tbActiveChannel, szChannelName)
end

-- 删除已经打开的频道
function tbMsgChannel:DelActiveChannel(szChannelName)
  local nCurChannelIndex = GetPlayerBarCurChannelIndex()
  local szCurChannelName = self.tbActiveChannel[nCurChannelIndex + 1]

  local nDelIndex = -1
  for i, szActiveName in pairs(self.tbActiveChannel) do
    if szActiveName == szChannelName then
      nDelIndex = i
    end
  end

  if nDelIndex == -1 then
    return --- 找不到返回
  end

  local nAllCount = #self.tbActiveChannel
  if nAllCount == 0 then
    return --- 空的不用删了
  end

  if nDelIndex == nAllCount then
    self.tbActiveChannel[nAllCount] = nil
  else
    for i = nDelIndex, nAllCount do
      self.tbActiveChannel[i] = self.tbActiveChannel[i + 1]
    end
    self.tbActiveChannel[nAllCount] = nil
  end
  self.tbChannel_Name_Key_Id[szChannelName].nChannelId = -2

  if self.tbChannel_Name_Key_Id[szChannelName].szMenuText == GetPlayerBarCurChannelMenutext() then
    SetCurrentChannelName(tbMsgChannel.CHANNEL_NEAR)
  end
end

function tbMsgChannel:SetDynChannelInfo(szChannelName, nMsgInterval, szPic1, szPic2)
  self.TB_TEXT_COLOR[szChannelName] = self.TB_TEXT_COLOR[self.CHANNEL_DYN]
  self.TB_TEXT_BORDER_COLOR[szChannelName] = self.TB_TEXT_BORDER_COLOR[self.CHANNEL_DYN]
  self.TB_MENUBK_COLOR[szChannelName] = self.TB_MENUBK_COLOR[self.CHANNEL_DYN]
  self.CHANNEL_CUSTOM_PROC[szChannelName] = self.CHANNEL_CUSTOM_PROC[self.CHANNEL_DYN]

  self.tbChannel_Name_Key_Id[szChannelName] = { nChannelId = -2, nCost = 0, szShortName = szChannelName, szMenuText = szChannelName }
  self.tbChannelSendInterval[szChannelName] = { nMsgInterval = nMsgInterval * 1000, nMaxWaitCount = 2, nLastSendTime = 0, tbQueue = {} }

  if szPic1 and szPic1 ~= "" then
    self.tbChannelPic[szChannelName] = { szPic1, 1 }
  else
    self.tbChannelPic[szChannelName] = { self.tbChannelPic[self.CHANNEL_DYN][1], 1 }
  end

  if szPic2 and szPic2 ~= "" then
    self.tbShortTextPic[szChannelName] = { szPic2, 1 }
  else
    self.tbShortTextPic[szChannelName] = { self.tbShortTextPic[self.CHANNEL_DYN][1], 1 }
  end
  -- 以下是初始化注册图标
  local nPicId = RegInlinePic(self.tbChannelPic[szChannelName][1])
  self.tbChannelPic[szChannelName][2] = nPicId

  local nPicId = RegInlinePic(self.tbShortTextPic[szChannelName][1])
  self.tbShortTextPic[szChannelName][2] = nPicId

  Ui(Ui.UI_MSGPAD).tbChannelTabMgr:AddTabChannel(self.TAB_COMMON, szChannelName)
end

-- 打开频道
function tbMsgChannel:OnOpenChannel()
  local nCurChannelIndex = GetPlayerBarCurChannelIndex()

  local tbChannelInfo = KChatChannel.GetChannelInfo()

  for szName, tbKeyId in pairs(self.tbChannel_Name_Key_Id) do
    tbKeyId.nChannelId = -2
  end

  self.tbActiveChannel = {}
  for nChannelId, szChannelName in pairs(tbChannelInfo) do
    if self.tbChannel_Name_Key_Id[szChannelName] then
      self.tbChannel_Name_Key_Id[szChannelName].nChannelId = nChannelId
      self:AddActiveChannel(szChannelName)
    end
  end

  if nCurChannelIndex <= 0 then
    SetCurrentChannelName(tbMsgChannel.CHANNEL_NEAR)
  end

  Ui(Ui.UI_CHATTAB):UpdateTransferTab() --更新跨服聊天标签状态
end

-- 打开动态频道 服务端会同步频道选择图标id 频道发言消耗
function tbMsgChannel:OnOpenDynChannel(szDynChannelName, nDynChannelId, nDynTextPicIndex, nCost, nChannelType)
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].szChannelKey = szDynChannelName
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].nChannelId = nDynChannelId
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].nCost = nCost
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].nChannelType = nChannelType
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].szMenuText = szDynChannelName
  self:AddActiveChannel(self.CHANNEL_DYN)
  local nTextPicId = 0
  for i, tbTextPic in pairs(self.tbDynShortTextPic) do
    if i == nDynTextPicIndex then
      nTextPicId = tbTextPic[2]
    end
  end
  self.tbShortTextPic[tbMsgChannel.CHANNEL_DYN] = { "", nTextPicId }
  SendChannelSubscribe(nDynChannelId)
end

-- 关闭动态频道
function tbMsgChannel:OnCloseDynChannel(nDynChannelId)
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].szChannelKey = ""
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].nChannelId = -2
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].nCost = -2
  self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].nChannelType = 0
  self:DelActiveChannel(szDynChannelName)
end

-- 通过频道id 找到对应的频道名
function tbMsgChannel:GetChannelNameById(nChannelId)
  if nChannelId == -1 then -- 系统频道订阅的时候服务端给的id是8，但服务端发送系统消息过来的时候用的id却是-1 (先暂时处理一下)
    return self.CHANNEL_SYSTEM
  end
  for szName, tbKeyId in pairs(self.tbChannel_Name_Key_Id) do
    if tbKeyId.nChannelId == nChannelId then
      return szName
    end
  end
end

-- 压入一条待发消息是个队列
function tbMsgChannel:PushSendMsg(nChannelId, szMsg)
  local szChannelName = self:GetChannelNameById(nChannelId)
  if #self.tbChannelSendInterval[szChannelName].tbQueue >= self.tbChannelSendInterval[szChannelName].nMaxWaitCount then
    return -1
  end
  local nCurTime = GetCurrentTime()
  if (szChannelName == tbMsgChannel.CHANNEL_SYSTEM) or (nCurTime - self.tbChannelSendInterval[szChannelName].nLastSendTime >= self.tbChannelSendInterval[szChannelName].nMsgInterval) then
    table.insert(self.tbChannelSendInterval[szChannelName].tbQueue, { nCanSendTime = nCurTime, szSendMsg = szMsg })
    return 0
  else
    local nLeaveTime = self.tbChannelSendInterval[szChannelName].nMsgInterval - (nCurTime - self.tbChannelSendInterval[szChannelName].nLastSendTime)
    local nNextCanSendTime = self.tbChannelSendInterval[szChannelName].nLastSendTime + self.tbChannelSendInterval[szChannelName].nMsgInterval
    self.tbChannelSendInterval[szChannelName].nLastSendTime = nNextCanSendTime
    table.insert(self.tbChannelSendInterval[szChannelName].tbQueue, { nCanSendTime = nNextCanSendTime, szSendMsg = szMsg })
    return nLeaveTime
  end
end

-- 弹出一条符合条件发送的消息
function tbMsgChannel:GetSendMsg()
  local nCurTime = GetCurrentTime()
  local szSendMsg = ""
  local nChannelId = -1
  local szChannelName = ""
  local nChannelType = 0
  local nCost = 0
  for szChannel, tbChannelMsgCont in pairs(self.tbChannelSendInterval) do
    if tbChannelMsgCont.tbQueue then
      for i, tbOneMsg in pairs(tbChannelMsgCont.tbQueue) do
        if tbOneMsg.nCanSendTime <= nCurTime then
          tbChannelMsgCont.nLastSendTime = nCurTime
          szChannelName = szChannel
          nChannelId = self.tbChannel_Name_Key_Id[szChannelName].nChannelId
          szSendMsg = tbOneMsg.szSendMsg
          tbOneMsg = nil
          tbChannelMsgCont.tbQueue[i] = nil
          nCost = self.tbChannel_Name_Key_Id[szChannelName].nCost
          nChannelType = self.tbChannel_Name_Key_Id[szChannelName].nChannelType
          break
        end
      end
    end
  end

  -- 动态频道要返回真实频道名
  if szChannelName == self.CHANNEL_DYN then
    szChannelName = self.tbChannel_Name_Key_Id[self.CHANNEL_DYN].szChannelKey
  end

  if szSendMsg ~= "" then
    return 1, szChannelName, szSendMsg, nCost, nChannelType
  else
    return 0, "", "", 0, nChannelType
  end
end

-----------------------------------------------------------------------------------------------
--外接查询接口
function tbMsgChannel:IsDynChannel(nChannelId)
  if not nChannelId then
    return 0
  end

  if self.tbChannel_Name_Key_Id[tbMsgChannel.CHANNEL_DYN].nChannelId == nChannelId then
    return 1
  else
    return 0
  end
end

function tbMsgChannel:GetChannelCount()
  local nCount = 0
  for szName, tbKeyId in pairs(self.tbChannel_Name_Key_Id) do
    if tbKeyId.nChannelId ~= -2 then
      nCount = nCount + 1
    end
  end
  return nCount
end

function tbMsgChannel:GetChannelNameByIndex(nIndex)
  for nChannelIndex, szName in pairs(self.tbActiveChannel) do
    if nChannelIndex == nIndex then
      return szName
    end
  end
end

function tbMsgChannel:GetChannelNameByMenuText(szMenuText)
  for szName, tbKeyId in pairs(self.tbChannel_Name_Key_Id) do
    if tbKeyId.szMenuText == szMenuText then
      return szName
    end
  end
end

function tbMsgChannel:GetChannelIdByMenuText(szMenuText)
  for szName, tbKeyId in pairs(self.tbChannel_Name_Key_Id) do
    if tbKeyId.szMenuText == szMenuText then
      return tbKeyId.nChannelId
    end
  end
end

function tbMsgChannel:GetShortTxtPicByChannelName(szChannelName)
  for szName, tbTextPic in pairs(self.tbShortTextPic) do
    if szName == szChannelName then
      return tbTextPic[2]
    end
  end
end

-- 取得当前频道的在弹出菜单上的显示信息
function tbMsgChannel:GetChannelMenuinfo(nIndex)
  for nChannelIndex, szName in pairs(self.tbActiveChannel) do
    if nChannelIndex == nIndex then
      return szName, self.tbShortTextPic[szName][2], 20, self.TB_TEXT_COLOR[szName], self.TB_MENUBK_COLOR[szName], self.tbChannel_Name_Key_Id[szName].szMenuText
    end
  end
end

-- 取得密聊在弹出菜单上的显示信息
function tbMsgChannel:GetPersonalMenuinfo()
  return self.tbShortTextPic[tbMsgChannel.CHANNEL_PERSONAL][2], 20, self.TB_TEXT_COLOR[tbMsgChannel.CHANNEL_PERSONAL], self.TB_MENUBK_COLOR[tbMsgChannel.CHANNEL_PERSONAL]
end

function tbMsgChannel:GetChannelCostByIndex(nIndex)
  if not self.tbActiveChannel[nIndex] then
    return 0
  end
  local szChannelName = self.tbActiveChannel[nIndex]
  return self.tbChannel_Name_Key_Id[szChannelName].nCost
end

function tbMsgChannel:GetChannelIndexByChannelName(szChannelName)
  for nChannelIndex, szName in pairs(self.tbActiveChannel) do
    if szName == szChannelName then
      return nChannelIndex
    end
  end
  return -1
end

function tbMsgChannel:GetChannelMenuTextByIndex(nIndex)
  if not self.tbActiveChannel[nIndex] then
    return ""
  end
  local szChannelName = self.tbActiveChannel[nIndex]
  return self.tbChannel_Name_Key_Id[szChannelName].szMenuText
end

function tbMsgChannel:GetChannelIdByIndex(nIndex)
  local szChannelName = self.tbActiveChannel[nIndex]
  if not szChannelName then
    return -2
  end
  return self.tbChannel_Name_Key_Id[szChannelName].nChannelId
end

function tbMsgChannel:GetChannelIdByChannelName(szChannelName)
  if not szChannelName then
    return -2
  end
  return self.tbChannel_Name_Key_Id[szChannelName].nChannelId
end

function tbMsgChannel:GetChannelIndexByMenuText(szMenuText)
  local szChannelName = ""
  for szName, tbKeyId in pairs(self.tbChannel_Name_Key_Id) do
    if tbKeyId.szMenuText == szMenuText then
      szChannelName = szName
    end
  end

  if szChannelName == "" then
    return nil
  end

  for nChannelIndex, szName in pairs(self.tbActiveChannel) do
    if szName == szChannelName then
      return nChannelIndex
    end
  end
end

function tbMsgChannel:IsGmChannelByIndex(nIndex)
  local szChannelName = self.tbActiveChannel[nIndex]
  if szChannelName == tbMsgChannel.CHANNEL_SYSTEM then
    return 1
  else
    return 0
  end
end

function tbMsgChannel:AddAchievementMsgInfo(szMsg, szInfo)
  if not szMsg or not szInfo then
    return
  end

  self.tbAchievementMsgInfo = self.tbAchievementMsgInfo or {}
  if not self.tbAchievementMsgInfo[szMsg] then
    self.tbAchievementMsgInfo[szMsg] = szInfo
  end
end

function tbMsgChannel:GetAchievementMsgInfo(szMsg)
  if not szMsg or not self.tbAchievementMsgInfo then
    return
  end

  local bFind = 0
  for szIndexMsg, szInfo in pairs(self.tbAchievementMsgInfo) do
    local s, e = string.find(szMsg, szIndexMsg)
    if s and e then
      szMsg = string.gsub(szMsg, szIndexMsg, szInfo)
      bFind = 1
    end
  end

  if 1 == bFind then
    return szMsg
  end
end

---------------------------------------------------------------------------------------
--外接查询接口完毕，为兼容旧代码 :~(

----------------------------------------------------------------------
--频道消息类
Ui.tbLogic.tbMsgChannel.tbChannelMsgClass = {}
local tbChannelMsgClass = Ui.tbLogic.tbMsgChannel.tbChannelMsgClass

function tbChannelMsgClass:init()
  self.szChannelType = ""
end

function tbChannelMsgClass:Near_Custom_Proc(szSendName, szMsg)
  local szNewMsg = Ui.tbLogic.tbMessageList:FormatMsg(szMsg) -- 临时把分析装备链接放在messagelist.lua 以后要单独抽出来
  SetNpcChat(szSendName, szNewMsg)
end

function tbChannelMsgClass:Team_Custom_Proc(szSendName, szMsg)
  local tbTempData = Ui.tbLogic.tbTempData
  if tbTempData.nTeamPopMsg and tbTempData.nTeamPopMsg == 1 then
    Ui(Ui.UI_TEAMPORTRAIT):GetMemberTalk(szSendName, szMsg)
  end
end

function tbChannelMsgClass:GetResult(szSendName, szMsg, bNoCheck)
  local szFun = Ui.tbLogic.tbMsgChannel.CHANNEL_CUSTOM_PROC[self.szChannelType]
  if szFun then
    local fnFun = self[szFun]
    if type(fnFun) == "function" then
      fnFun(self, szSendName, szMsg)
    end
  end

  if bNoCheck == 1 then
    return szMsg
  end

  local szNewMsg = ""
  if self.szChannelType ~= tbMsgChannel.CHANNEL_SYSTEM then
    szNewMsg = self:CheckForbitan(szMsg)
  else
    szNewMsg = szMsg
  end
  szNewMsg = self:AddWarnning(szNewMsg)
  return szNewMsg
end

function tbChannelMsgClass:GetColor()
  return Ui.tbLogic.tbMsgChannel.TB_TEXT_COLOR[self.szChannelType]
end

function tbChannelMsgClass:GetBorderColor()
  return Ui.tbLogic.tbMsgChannel.TB_TEXT_BORDER_COLOR[self.szChannelType]
end

--检查是否有脏话，过滤
function tbChannelMsgClass:CheckForbitan(szMsg)
  if self.szChannelType == tbMsgChannel.CHANNEL_SYSTEM then
    return szMsg
  end
  return CheckForbidden(szMsg)
end

--动作解析
function tbChannelMsgClass:AddAucation(szMsg, szSendName)
  return AddAction(szMsg, szSendName)
end

--对qq，网页地址加警告
function tbChannelMsgClass:AddWarnning(szMsg)
  --	if self.szChannelType == tbMsgChannel.CHANNEL_SYSTEM then
  return szMsg
  --	end

  --	local nFlag = UiManager:CheckNeedAddWarring(szMsg);
  --	local szNewMsg = szMsg;
  --	if (nFlag ~= 0) then
  --		szNewMsg = szNewMsg.."  <color=yellow>[官方提示]非官方公告切勿相信，请注意保管好自己的财产。<color>";
  --	end
  --	return szNewMsg;
end
