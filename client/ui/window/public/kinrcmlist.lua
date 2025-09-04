-------------------------------------------------------
--文件名		：	kinrcmlist.lua
--创建者		：	zhangjinpin
--创建时间		：	2009-08-20
--功能描述		：	家族招募界面
------------------------------------------------------

local uiKinRcmlist = Ui:GetClass("kinrcmlist")

uiKinRcmlist.LST_KIN = "LstKin"
uiKinRcmlist.BTN_CLOSE = "BtnClose"
uiKinRcmlist.BTN_JOIN = "BtnJoin"
uiKinRcmlist.BTN_REFRESH = "BtnRefresh"
uiKinRcmlist.BTN_CHECK = "BtnCheckbox"
uiKinRcmlist.BTN_DETAIL = "BtnDetail"
uiKinRcmlist.BTN_RUNYY = "BtnRunYy"

uiKinRcmlist.MENU_ITEM = { " 密聊族长 " }
uiKinRcmlist.tbKinRecruitmentList = uiKinRcmlist.tbKinRecruitmentList or {}

function uiKinRcmlist:OnOpen(tbParam)
  self:Refresh()
end

function uiKinRcmlist:Refresh()
  KKin.ApplyAllRecruitmentKin()
end

function uiKinRcmlist:UpdateKinlist()
  self.tbKinRecruitmentList = KKin.GetAllRecruitmentKin()
  table.sort(self.tbKinRecruitmentList, function(a, b)
    return a.nTotalRepute > b.nTotalRepute
  end)
  Lst_Clear(self.UIGROUP, self.LST_KIN)
  for i, tbKinInfo in ipairs(self.tbKinRecruitmentList) do
    self:UpdateCell(i, tbKinInfo)
  end
end

function uiKinRcmlist:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_JOIN then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LST_KIN)
    if self.tbKinRecruitmentList[nKey] then
      me.CallServerScript({ "KinCmd", "JoinRecruitment", self.tbKinRecruitmentList[nKey].nKinId })
    end
  elseif szWnd == self.BTN_REFRESH then
    self:Refresh()
  elseif szWnd == self.BTN_CHECK then
    self:Match()
  elseif szWnd == self.BTN_DETAIL then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LST_KIN)
    if self.tbKinRecruitmentList[nKey] then
      me.CallServerScript({ "KinCmd", "ShowKinDetail", self.tbKinRecruitmentList[nKey].nKinId })
      UiManager:CloseWindow(self.UIGROUP)
    end
  elseif szWnd == self.BTN_RUNYY then
    local nYyNumber = 0
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LST_KIN)
    if self.tbKinRecruitmentList[nKey] then
      nYyNumber = self.tbKinRecruitmentList[nKey].nYYNumber
      if not nYyNumber or nYyNumber <= 0 then
        nYyNumber = 0
      end
    end
    if YY_Update() == 0 then
      -- 返回金山登录
      local tbMsg = { szMsg = "更新YY失败，请手动下载YY", tbOptTitle = { "确定" } }
      return
    end
    -- 显示更新界面
    UiManager:OpenWindow(Ui.UI_YY_UPDATE, 2, nYyNumber)
  end
end

function uiKinRcmlist:Match()
  Lst_Clear(self.UIGROUP, self.LST_KIN)
  if Btn_GetCheck(self.UIGROUP, self.BTN_CHECK) == 1 then
    for i, tbKinInfo in ipairs(self.tbKinRecruitmentList) do
      local nLevel = tbKinInfo.nRecruitmentLevel or 0
      local nHonor = tbKinInfo.nRecruitmentHonour or 0
      local nCurHonor = PlayerHonor:GetHonorLevel(me, PlayerHonor.HONOR_CLASS_MONEY)
      if me.nLevel >= nLevel and nCurHonor >= nHonor then
        self:UpdateCell(i, tbKinInfo)
      end
    end
  else
    for i, tbKinInfo in ipairs(self.tbKinRecruitmentList) do
      self:UpdateCell(i, tbKinInfo)
    end
  end
end

function uiKinRcmlist:UpdateCell(i, tbKinInfo)
  Lst_SetCell(self.UIGROUP, self.LST_KIN, i, 0, tbKinInfo.szKinName or "")
  Lst_SetCell(self.UIGROUP, self.LST_KIN, i, 1, tbKinInfo.nMemberCount or 0)
  Lst_SetCell(self.UIGROUP, self.LST_KIN, i, 2, tbKinInfo.szCaptainName or "")
  Lst_SetCell(self.UIGROUP, self.LST_KIN, i, 3, tbKinInfo.szBelongTongName or "")
  Lst_SetCell(self.UIGROUP, self.LST_KIN, i, 4, tbKinInfo.nTotalRepute or 0)
  Lst_SetCell(self.UIGROUP, self.LST_KIN, i, 5, tbKinInfo.nRecruitmentLevel or 0)
  Lst_SetCell(self.UIGROUP, self.LST_KIN, i, 6, tbKinInfo.nRecruitmentHonour or 0)
  local szYYNumber = "-"
  if tbKinInfo.nYYNumber and tbKinInfo.nYYNumber > 0 then
    szYYNumber = tbKinInfo.nYYNumber
  end
  szYYNumber = Lib:StrFillC(szYYNumber, 10)
  Lst_SetCell(self.UIGROUP, self.LST_KIN, i, 7, szYYNumber)
end

function uiKinRcmlist:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_KINRECRUITMENT_LIST, self.UpdateKinlist },
  }
  return tbRegEvent
end

-- 右键菜单处理
function uiKinRcmlist:OnListRClick(szWnd, nParam)
  if szWnd and nParam then
    Lst_SetCurKey(self.UIGROUP, szWnd, nParam)
    DisplayPopupMenu(self.UIGROUP, szWnd, #self.MENU_ITEM, 0, self.MENU_ITEM[1], 1)
  end
end

-- 弹出菜单处理
function uiKinRcmlist:OnMenuItemSelected(szWnd, nItemId, nParam)
  if szWnd == self.LST_KIN then
    local nKey = Lst_GetCurKey(self.UIGROUP, self.LST_KIN)
    if nKey < 0 then
      return 0
    end
    if self.tbKinRecruitmentList[nKey] then
      local szCaptainName = self.tbKinRecruitmentList[nKey].szCaptainName
      if szCaptainName and nItemId > 0 and nItemId <= #self.MENU_ITEM then
        if nItemId == 1 then
          if me.szName == szCaptainName then
            me.Msg("不能密聊自己!")
            return 0
          end
          ChatToPlayer(szCaptainName)
        end
      end
    end
  end
end

-- 鼠标掠过
function uiKinRcmlist:OnListOver(szWnd, nItemIndex)
  if (szWnd == self.LST_KIN) and nItemIndex >= 0 and self.tbKinRecruitmentList[nItemIndex] then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, self.tbKinRecruitmentList[nItemIndex].szRecAnnounce, "")
  end
end
