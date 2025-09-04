-------------------------------------------------------
-- 文件名　：selectgroup_fr.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-05-04 11:31:03
-- 文件描述：
-------------------------------------------------------

local uiSelectGroup_FR = Ui:GetClass("selectgroup_fr")

uiSelectGroup_FR.MAX_GROUP = 6

uiSelectGroup_FR.TXT_SELGROUP_NAME = "TxtSelGroupName"
uiSelectGroup_FR.TXT_SELGROUP_CREATER = "TxtSelGroupCreater"
uiSelectGroup_FR.TXT_SELGROUP_TONG = "TxtSelGroupTong"
uiSelectGroup_FR.TXT_SELGROUP_SERVER = "TxtSelGroupServer"

uiSelectGroup_FR.TXT_UNION = "TxtUnion"
uiSelectGroup_FR.LST_UNION = "LstUnion"

uiSelectGroup_FR.BTN_SINGLE_JOIN = "BtnSingleJoin"
uiSelectGroup_FR.BTN_TONG_JOIN = "BtnTongJoin"
uiSelectGroup_FR.BTN_CLOSE = "BtnClose"
uiSelectGroup_FR.BTN_SHANGJIN = "Btn_Shangjin"

uiSelectGroup_FR.tbGroups = {}
for i = 1, uiSelectGroup_FR.MAX_GROUP do
  uiSelectGroup_FR.tbGroups[i] = { "BtnGroup" .. i, "TxtGroupName" .. i, "TxtGroupCreater" .. i }
end

function uiSelectGroup_FR:Init()
  self.nSelGroup = 0
end

function uiSelectGroup_FR:OnButtonClick(szWnd, nParam)
  if self.BTN_CLOSE == szWnd then
    UiManager:CloseWindow(self.UIGROUP)
  elseif self.BTN_SINGLE_JOIN == szWnd then
    self:AgreeApply()
  elseif self.BTN_TONG_JOIN == szWnd then
    if self.nState == 1 then
      self:OnSelectGroup(2)
    elseif self.nState == 2 then
      self:CancelApply()
    end
  elseif self.BTN_SHANGJIN == szWnd then
    self:ScanShangjin()
  else
    for i = 1, self.MAX_GROUP do
      if self.tbGroups[i][1] == szWnd then
        self:UpdateDetailInfo(i)
        Btn_Check(self.UIGROUP, self.tbGroups[i][1], 1)
      else
        Btn_Check(self.UIGROUP, self.tbGroups[i][1], 0)
      end
    end
  end
end

function uiSelectGroup_FR:ScanShangjin()
  if self.nSelGroup == 0 then
    return 0
  end
  me.CallServerScript({ "ApplyOpenMemberAward", self.nSelGroup })
end

function uiSelectGroup_FR:OnSelectGroup(nType)
  if self.nSelGroup == 0 then
    return 0
  end

  local szCmd = ""
  local nRet = self.nSelGroup
  if nType == 1 then
    szCmd = "ApplySelectGroupSingle"
  elseif nType == 2 then
    szCmd = "ApplySelectGroupTong"
  else
    return 0
  end

  local tbMsg = {}
  tbMsg.szMsg = string.format("确定要加入%s么？", self.tbGroupList[nRet].szGroupName)
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ szCmd, nRet })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function uiSelectGroup_FR:UpdateDetailInfo(nIndex)
  Lst_Clear(self.UIGROUP, self.LST_UNION)

  if not self.tbGroupList then
    return 0
  end

  local tbInfo = self.tbGroupList[nIndex]
  if not tbInfo then
    self.nSelGroup = 0
    Txt_SetTxt(self.UIGROUP, self.TXT_SELGROUP_NAME, "军团名称：")
    Txt_SetTxt(self.UIGROUP, self.TXT_SELGROUP_CREATER, "创 建 者：")
    Txt_SetTxt(self.UIGROUP, self.TXT_SELGROUP_TONG, "所属帮会：")
    Txt_SetTxt(self.UIGROUP, self.TXT_SELGROUP_SERVER, "创建者所属区服：")
  else
    self.nSelGroup = nIndex
    Txt_SetTxt(self.UIGROUP, self.TXT_SELGROUP_NAME, string.format("军团名称：%s", tbInfo.szGroupName))
    Txt_SetTxt(self.UIGROUP, self.TXT_SELGROUP_CREATER, string.format("创 建 者：%s", tbInfo.tbCaptain.szPlayerName))
    Txt_SetTxt(self.UIGROUP, self.TXT_SELGROUP_TONG, string.format("所属帮会：%s", tbInfo.tbCaptain.szTongName))
    Txt_SetTxt(self.UIGROUP, self.TXT_SELGROUP_SERVER, string.format("创建者所属区服：%s", ServerEvent:GetServerNameByGateway(tbInfo.tbCaptain.szGateway)))
    Txt_SetTxt(self.UIGROUP, self.TXT_UNION, string.format("联盟帮会：%s", tbInfo.nTongCount))

    local nRow = 1
    for szTongName, szGateway in pairs(tbInfo.tbTong) do
      Lst_SetCell(self.UIGROUP, self.LST_UNION, nRow, 0, szTongName)
      Lst_SetCell(self.UIGROUP, self.LST_UNION, nRow, 1, "已批准")
      nRow = nRow + 1
    end
    for szTongName, szGateway in pairs(tbInfo.tbPreTong) do
      Lst_SetCell(self.UIGROUP, self.LST_UNION, nRow, 0, szTongName)
      Lst_SetCell(self.UIGROUP, self.LST_UNION, nRow, 1, "申请")
      Lst_SetLineColor(self.UIGROUP, self.LST_UNION, nRow, 0xffFFFF00)
      nRow = nRow + 1
    end
    self:ChangeWndState(nIndex)
  end
end

function uiSelectGroup_FR:ChangeWndState(nIndex)
  self:ResetWndState()

  local tbInfo = self.tbGroupList[nIndex]
  if me.szName == tbInfo.tbCaptain.szPlayerName then
    Wnd_SetEnable(self.UIGROUP, self.BTN_TONG_JOIN, 0)
    return
  end

  if self.nCaptain and self.nCaptain == 1 then
    self.nState = 1
    Wnd_SetEnable(self.UIGROUP, self.BTN_SINGLE_JOIN, 0)
    Btn_SetTxt(self.UIGROUP, self.BTN_TONG_JOIN, "申请加入")
    if tbInfo.tbPreTong[self.szTongName] then
      Btn_SetTxt(self.UIGROUP, self.BTN_TONG_JOIN, "撤销申请")
      self.nState = 2
    end
    return
  end

  self:DisableAll()
end

function uiSelectGroup_FR:ResetWndState()
  Wnd_SetEnable(self.UIGROUP, self.BTN_SINGLE_JOIN, 1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_TONG_JOIN, 1)
end

function uiSelectGroup_FR:OnRecvData(tbList, nCaptain, szTongName)
  if not tbList then
    return 0
  end

  self.tbGroupList = tbList
  self.nCaptain = nCaptain or 0
  self.szTongName = szTongName or ""

  for i, tbInfo in ipairs(self.tbGroupList) do
    Txt_SetTxt(self.UIGROUP, self.tbGroups[i][2], tbInfo.szGroupName)
    Txt_SetTxt(self.UIGROUP, self.tbGroups[i][3], tbInfo.tbCaptain.szPlayerName)
  end
end

function uiSelectGroup_FR:DisableAll()
  Wnd_SetEnable(self.UIGROUP, self.BTN_SINGLE_JOIN, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_TONG_JOIN, 0)
end

function uiSelectGroup_FR:OnListSel(szWnd, nParam)
  if szWnd == self.LST_UNION then
    self:SelectApplayTong(nParam)
  end
end

function uiSelectGroup_FR:SelectApplayTong(nParam)
  self.SelectTongName = Lst_GetCell(self.UIGROUP, self.LST_UNION, nParam, 0)
  if self.nSelGroup == 0 then
    return 0
  end
  if not self.tbGroupList[self.nSelGroup].tbPreTong[self.SelectTongName] then
    Wnd_SetEnable(self.UIGROUP, self.BTN_SINGLE_JOIN, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_SINGLE_JOIN, 1)
  end
end

function uiSelectGroup_FR:AgreeApply()
  if not self.nCaptain or self.nCaptain == 0 then
    return 0
  end
  if not self.SelectTongName or self.SelectTongName == "" then
    return 0
  end
  local tbMsg = {}
  tbMsg.szMsg = string.format("确定要同意<color=yellow>%s<color>申请加入么？", self.SelectTongName)
  tbMsg.nOptCount = 2
  local szSelectTongName = self.SelectTongName
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ "ApplyPermitGroupTong", szSelectTongName })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function uiSelectGroup_FR:CancelApply()
  if not self.nCaptain or self.nCaptain == 0 or self.nSelGroup == 0 then
    return 0
  end
  local tbMsg = {}
  local nSelGroup = self.nSelGroup
  tbMsg.szMsg = "您确定要撤销申请吗？"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ "ApplyCancelGroupTong", nSelGroup })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end
