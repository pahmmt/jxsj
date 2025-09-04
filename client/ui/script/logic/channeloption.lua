Ui.tbLogic.tbChannelOption = {}
local tbChannelOption = Ui.tbLogic.tbChannelOption
local tbSaveData = Ui.tbLogic.tbSaveData
local tbMsgChannel = Ui.tbLogic.tbMsgChannel

local DATA_KEY = "ChannelOption"

-- 	CHANNELCONT[1] 频道对应的控件,
--	CHANNELCONT[2] 频道的名字,
--  CHANNELCONT[3] 频道的状态（-1 表示未打开）
tbChannelOption.CHANNELCONT = {
  { "BtnTeam", tbMsgChannel.CHANNEL_TEAM, 0 },
  { "BtnWorld", tbMsgChannel.CHANNEL_WORLD, 0 },
  { "BtnFaction", tbMsgChannel.CHANNEL_FACTION, 0 },
  { "BtnNear", tbMsgChannel.CHANNEL_NEAR, 0 },
  { "BtnSystem", tbMsgChannel.CHANNEL_SYSTEM, 0 },
  { "BtnCity", tbMsgChannel.CHANNEL_CITY, 0 },
  { "BtnFriend", tbMsgChannel.CHANNEL_FRIEND, 0 },
  { "BtnTong", tbMsgChannel.CHANNEL_TONG, 0 },
  { "BtnKin", tbMsgChannel.CHANNEL_KIN, 0 },
  { "BtnPersonal", tbMsgChannel.CHANNEL_PERSONAL, 0 },
  { "BtnServer", tbMsgChannel.CHANNEL_SERVER, 0 },
  { "BtnLeague", "帮会联盟", 0 },
}

function tbChannelOption:Init()
  self.tbChannelOption = {}
end

function tbChannelOption:SaveOption(tbOption)
  tbSaveData:Save(DATA_KEY, tbOption)
  self:ExeCuteOption(tbOption)
end

function tbChannelOption:LoadOption()
  for i, tbChannel in ipairs(tbChannelOption.CHANNELCONT) do
    tbChannel[3] = 0
  end
  self.tbChannelOption = tbSaveData:Load(DATA_KEY)
  if self.tbChannelOption then
    self:ExeCuteOption(self.tbChannelOption)
  end
end

function tbChannelOption:ExeCuteOption(tbOption)
  Ui(Ui.UI_MSGPAD):ResetCustomTab()
  for i, tbOptionChannel in ipairs(tbOption) do
    if tbOptionChannel[1] then
      for i, tbChannel in ipairs(tbChannelOption.CHANNELCONT) do
        if tbOptionChannel[1] == tbChannel[2] then
          tbChannel[3] = 1
        end
      end
      if tbMsgChannel.CHANNEL_PERSONAL == tbOptionChannel[1] then
        Ui(Ui.UI_MSGPAD):AddChannelToCustom(tbMsgChannel.CHANNEL_ME)
      end
      Ui(Ui.UI_MSGPAD):AddChannelToCustom(tbOptionChannel[1])
    end
  end
end
