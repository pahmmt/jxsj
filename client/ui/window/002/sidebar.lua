-----------------------------------------------------
--文件名		：	sidebar.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间	    ：	2007-04-19
--功能描述	    ：	功能工具条脚本。
------------------------------------------------------

local uiSideBar = Ui:GetClass("sidebar")

uiSideBar.tbTongKinMenu = {
  { "  家族  ", Ui.UI_KIN },
  { "  帮会  ", Ui.UI_TONG },
  { "  战队  ", Ui.UI_GROUPPANEL },
  { "  组队  ", Ui.UI_TEAM },
}

uiSideBar.tbTongbanZhenyuanMenu = {
  { "  同伴  ", Ui.UI_PARTNER },
  { "  真元  ", Ui.UI_ZHENYUAN },
}

uiSideBar.tBtn2Group = {
  { "BtnPlayer", Ui.UI_PLAYERPANEL, "主角面板", "F1" },
  { "BtnItemBox", Ui.UI_ITEMBOX, "物品背包", "F2" },
  { "BtnSkill", Ui.UI_FIGHTSKILL, "战斗技能", "F3" },
  { "BtnLifeSkill", Ui.UI_LIFESKILL, "生活技能", "F8" },
  { "BtnTaskPanel", Ui.UI_TASKPANEL, "任务记录", "F4" },
  { "BtnRelation", Ui.UI_RELATIONNEW, "人际关系", "F5" },
  { "BtnTongban", Ui.UI_PARTNER, "同伴与真元", "F9、F10" },
  { "BtnKin", Ui.UI_KIN, "家族与帮会", "F6、F7" },
  { "BtnSystem", Ui.UI_SYSTEMEX, "系统", "F11" },
}

function uiSideBar:OnOpen()
  Ui(Ui.UI_SIDESYSBAR):UpdateSideBarExState(1)
end

function uiSideBar:OnClose()
  Ui(Ui.UI_SIDESYSBAR):UpdateSideBarExState(0)
end

function uiSideBar:OnButtonClick(szWnd, nParam)
  for _, tbPair in ipairs(self.tBtn2Group) do
    if szWnd == "BtnSystem" then
      UiManager:OnReadyEsc()
      break
    elseif szWnd == "BtnKin" then
      DisplayPopupMenu(self.UIGROUP, szWnd, 4, 0, self.tbTongKinMenu[1][1], 1, self.tbTongKinMenu[2][1], 2, self.tbTongKinMenu[3][1], 3, self.tbTongKinMenu[4][1], 4)
      break
    elseif szWnd == "BtnTongban" then
      DisplayPopupMenu(self.UIGROUP, szWnd, 2, 0, self.tbTongbanZhenyuanMenu[1][1], 1, self.tbTongbanZhenyuanMenu[2][1], 2)
      break
    elseif szWnd == tbPair[1] then
      UiManager:SwitchWindow(tbPair[2])
      break
    end
  end
end

function uiSideBar:OnMouseEnter(szWnd)
  if UiManager.IVER_nSideBarTouch == 0 then
    return
  end
  if szWnd == UiManager.WND_MAIN then
    if IVER_g_nTwVersion == 0 then
      UiManager:OpenWindow(Ui.UI_SIDEBAR_TIPS)
    end
  end
end

function uiSideBar:OnMouseLeave(szWnd)
  if UiManager.IVER_nSideBarTouch == 0 then
    return
  end
  if szWnd == UiManager.WND_MAIN then
    UiManager:CloseWindow(Ui.UI_SIDEBAR_TIPS)
  end
end

function uiSideBar:WndOpenCloseCallback(szWnd, nParam)
  for _, tbPair in ipairs(self.tBtn2Group) do
    if szWnd == tbPair[2] then
      Btn_Check(self.UIGROUP, tbPair[1], nParam)
      break
    end
  end
end

function uiSideBar:OnMenuItemSelected(szWnd, nItemId, nParam)
  if szWnd == "BtnKin" then
    if nItemId > 0 and nItemId < 5 then
      if nItemId == 1 then
        if KKin.GetSelfKin() then
          UiManager:OpenWindow(Ui.UI_KIN)
        else
          UiManager:OpenWindow(Ui.UI_KINRCM_LIST)
        end
      else
        UiManager:OpenWindow(self.tbTongKinMenu[nItemId][2])
      end
    end
  elseif szWnd == "BtnTongban" then
    if nItemId > 0 and nItemId < 3 then
      UiManager:OpenWindow(self.tbTongbanZhenyuanMenu[nItemId][2])
    end
  else
    Ui:Output("[ERR] Error! OnMenuItemSelected")
  end
end
