-----------------------------------------------------
--文件名		：	relationaddfriend.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	玩家Buff
------------------------------------------------------
local uiAddFriend = Ui:GetClass("relationaddfriend") --Ui.tbWnd[Ui.UI_RELATIONADDFRIEND] or
uiAddFriend.CLOSE_BUTTON = "BtnClose"
uiAddFriend.BTN_ADDFRIEND = "BtnAddFriend"
uiAddFriend.BTN_ADDGLOBALFRIEND = "BtnAddGlobalFriend"
uiAddFriend.BTN_OK = "BtnAccept"
uiAddFriend.BTN_CANEL = "BtnCancel"
uiAddFriend.EDT_TEXT = "EdtText"
uiAddFriend.BTN_ADDRELATIONGROUP = "BtnAddRelationGroup"

function uiAddFriend:OnOpen()
  Edt_SetType(self.UIGROUP, self.EDT_TEXT, 2)
  Btn_Check(self.UIGROUP, self.BTN_ADDFRIEND, 1)
  Btn_Check(self.UIGROUP, self.BTN_ADDGLOBALFRIEND, 0)
  local nHaveGroup = Ui(Ui.UI_RELATIONNEW):GetMyGroupCount()
  if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
    Wnd_SetEnable(self.UIGROUP, self.BTN_ADDRELATIONGROUP, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_ADDRELATIONGROUP, 0)
  end
end

function uiAddFriend:OnClose() end

function uiAddFriend:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
    return
  elseif szWnd == self.BTN_ADDFRIEND then
    Btn_Check(self.UIGROUP, self.BTN_ADDFRIEND, 1)
    Btn_Check(self.UIGROUP, self.BTN_ADDGLOBALFRIEND, 0)
  elseif szWnd == self.BTN_ADDGLOBALFRIEND then
    Btn_Check(self.UIGROUP, self.BTN_ADDFRIEND, 0)
    Btn_Check(self.UIGROUP, self.BTN_ADDGLOBALFRIEND, 1)
  elseif szWnd == self.BTN_ADDRELATIONGROUP then
    local nHaveGroup = Ui(Ui.UI_RELATIONNEW):GetMyGroupCount()
    if nHaveGroup < Relation.DEF_MAX_RELATIONGROUP_COUNT then
      Ui(Ui.UI_RELATIONNEW):CmdCreateNewGroup()
    end
  elseif szWnd == self.BTN_OK then
    local nClassicalMode = Btn_GetCheck(self.UIGROUP, self.BTN_ADDFRIEND)
    local szText = Edt_GetTxt(self.UIGROUP, self.EDT_TEXT)
    if nClassicalMode == 1 then
      self:AddFriendByName(szText, 1)
    else
      self:AddFriendByName(szText, 2)
    end
  elseif szWnd == self.BTN_CANEL then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiAddFriend:AddFriendByName(szName, nType)
  if IsValidRoleName(szName) == 0 then
    me.Msg("输入的名字不符合规范。")
  elseif nType == 1 then
    AddFriendByName(szName)
  elseif nType == 2 then
    Player.tbGlobalFriends:ApplyAddFriend(me.szName, szName)
  end
end
