local uiSetChannel = Ui:GetClass("setchannel")
local tbChannelOption = Ui.tbLogic.tbChannelOption

uiSetChannel.BTNACCEPT = "BtnAccept"
uiSetChannel.BTNCANCEL = "BtnCancel"
uiSetChannel.BTNCLOSE = "BtnClose"
uiSetChannel.BTNFILTER = "BtnFilter"

local tbMsgChannel = Ui.tbLogic.tbMsgChannel

function uiSetChannel:Init()
  self.tbTempChannelCont = {}
end

function uiSetChannel:OnOpen()
  self:UpdateWnd()
end

function uiSetChannel:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTNACCEPT then
    self:Save()
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  if szWnd == self.BTNFILTER then
    UiManager:SwitchWindow(Ui.UI_CHATFILTER)
    return
  end
  for i, tbChannel in ipairs(tbChannelOption.CHANNELCONT) do
    if szWnd == tbChannel[1] then
      self.tbTempChannelCont[i] = nParam
    end
  end
  if szWnd == self.BTNCANCEL or szWnd == self.BTNCLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiSetChannel:UpdateWnd()
  for i, tbChannel in ipairs(tbChannelOption.CHANNELCONT) do
    if tbChannel[3] then
      if tbChannel[3] ~= 1 then
        Btn_Check(self.UIGROUP, tbChannelOption.CHANNELCONT[i][1], 0)
      else
        Wnd_SetEnable(self.UIGROUP, tbChannelOption.CHANNELCONT[i][1], 1)
        Btn_Check(self.UIGROUP, tbChannelOption.CHANNELCONT[i][1], 1)
      end
      self.tbTempChannelCont[i] = tbChannel[3]
    end
  end
end

function uiSetChannel:Save()
  local tbSaveOption = {}
  for i, tbChannel in ipairs(tbChannelOption.CHANNELCONT) do
    if self.tbTempChannelCont[i] == 1 then
      tbChannelOption.CHANNELCONT[i][3] = 1
      tbSaveOption[#tbSaveOption + 1] = { tbChannel[2] }
    else
      tbChannelOption.CHANNELCONT[i][3] = 0
    end
  end
  tbChannelOption:SaveOption(tbSaveOption)
end
