-------------------------------------------------------
-- 文件名　：selectgroup_nr.lua
-- 创建者　：furuilei
-- 创建时间：2010-05-04 11:31:48
-- 文件描述：第二次军团选择界面
-------------------------------------------------------

local uiSelectGroup_NR = Ui:GetClass("selectgroup_nr")

uiSelectGroup_NR.BTN_CLOSE = "BtnClose"

-- 玩家箱子分配比例
uiSelectGroup_NR.PLAYER_BOX_RADIO = {
  [1] = { 0.05, 10 },
  [2] = { 0.15, 8 },
  [3] = { 0.30, 6 },
  [4] = { 0.45, 4 },
  [5] = { 0.60, 3 },
  [6] = { 0.80, 2 },
  [7] = { 1.00, 1 },
}
uiSelectGroup_NR.BINGMONEY = 100000

-- 防守军团
uiSelectGroup_NR.TXT_DEF_JTNAME = "TxtGroupName1"
uiSelectGroup_NR.TXT_DEF_LEADERTONG = "TxtGroupTong1"
uiSelectGroup_NR.TXT_DEF_LEADERNAME = "TxtGroupCaptain1"
uiSelectGroup_NR.TXT_DEF_LEADERSERVER = "TxtGroupGate1"
uiSelectGroup_NR.TXT_DEF_SHANGJIN = "TxtShangjin1"
uiSelectGroup_NR.TXT_DEF_UNIONTONG = "TxtUnion1"
uiSelectGroup_NR.LST_DEF_TONG = "LstUnion1"
uiSelectGroup_NR.BTN_DEF_SINGLEJOIN = "BtnSingleJoin1"
uiSelectGroup_NR.BTN_DEF_TONGJOIN = "BtnTongJoin1"
uiSelectGroup_NR.BTN_DEF_SHANGJIN = "Btn_Shangjin1"

-- 进攻军团
uiSelectGroup_NR.TXT_ATT_JTNAME = "TxtGroupName2"
uiSelectGroup_NR.TXT_ATT_LEADERTONG = "TxtGroupTong2"
uiSelectGroup_NR.TXT_ATT_LEADERNAME = "TxtGroupCaptain2"
uiSelectGroup_NR.TXT_ATT_LEADERSERVER = "TxtGroupGate2"
uiSelectGroup_NR.TXT_ATT_SHANGJIN = "TxtShangjin2"
uiSelectGroup_NR.TXT_ATT_UNIONTONG = "TxtUnion2"
uiSelectGroup_NR.LST_ATT_TONG = "LstUnion2"
uiSelectGroup_NR.BTN_ATT_SINGLEJOIN = "BtnSingleJoin2"
uiSelectGroup_NR.BTN_ATT_TONGJOIN = "BtnTongJoin2"
uiSelectGroup_NR.BTN_ATT_SHANGJIN = "Btn_Shangjin2"

function uiSelectGroup_NR:OnButtonClick(szWnd, nParam)
  if not szWnd then
    return
  end

  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_DEF_SINGLEJOIN then
    self:AgreeApply(1)
  elseif szWnd == self.BTN_DEF_TONGJOIN then
    if self.nState == 1 then
      self:OnSelectGroup(2, 1)
    elseif self.nState == 2 then
      self:CancelApply(1)
    end
  elseif szWnd == self.BTN_DEF_SHANGJIN then
    self:ScanShangjin(1)
  elseif szWnd == self.BTN_ATT_SINGLEJOIN then
    self:AgreeApply(2)
  elseif szWnd == self.BTN_ATT_TONGJOIN then
    if self.nState == 1 then
      self:OnSelectGroup(2, 2)
    elseif self.nState == 2 then
      self:CancelApply(2)
    end
  elseif szWnd == self.BTN_ATT_SHANGJIN then
    self:ScanShangjin(2)
  end
end

function uiSelectGroup_NR:ScanShangjin(nGroup)
  me.CallServerScript({ "ApplyOpenMemberAward", nGroup })
end

function uiSelectGroup_NR:OnSelectGroup(nType, nGroup)
  local szCmd = ""
  local szGroupName = ""

  if nType == 1 then
    szCmd = "ApplySelectGroupSingle"
    szGroupName = self.tbInfo[nGroup].szGroupName or ""
  elseif nType == 2 then
    szCmd = "ApplySelectGroupTong"
    szGroupName = self.tbInfo[nGroup].szGroupName or ""
  else
    return 0
  end

  local tbMsg = {}
  tbMsg.szMsg = string.format("确定要申请加入%s么？", szGroupName)
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ szCmd, nGroup })
    end
  end

  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function uiSelectGroup_NR:UpdateInfo(tbInfo)
  Lst_Clear(self.UIGROUP, self.LST_DEF_TONG)
  Lst_Clear(self.UIGROUP, self.LST_ATT_TONG)

  -- 防守军团
  local tbDefenceJT = tbInfo[1] or {}
  local szDefLeaderTong = string.format("所属帮会：%s", tbDefenceJT.tbCaptain.szTongName or "")
  local szDefLeaderName = string.format("城主：%s", tbDefenceJT.tbCaptain.szPlayerName or "")
  local szDefLeaderServer = string.format("区服：%s", ServerEvent:GetServerNameByGateway(tbDefenceJT.tbCaptain.szGateway or ""))
  local nDefUninTong = string.format("联盟帮会：%s", tbDefenceJT.nTongCount)
  local szDefAwardCount = string.format("赏金：%s", Item:FormatMoney(self:CalcMemberAward(tbDefenceJT.tbAward.nAwardCount, tbDefenceJT.tbAward.nMultiple)))

  Txt_SetTxt(self.UIGROUP, self.TXT_DEF_LEADERTONG, szDefLeaderTong)
  Txt_SetTxt(self.UIGROUP, self.TXT_DEF_LEADERNAME, szDefLeaderName)
  Txt_SetTxt(self.UIGROUP, self.TXT_DEF_LEADERSERVER, szDefLeaderServer)
  Txt_SetTxt(self.UIGROUP, self.TXT_DEF_UNIONTONG, nDefUninTong)
  Txt_SetTxt(self.UIGROUP, self.TXT_DEF_SHANGJIN, szDefAwardCount)

  local nDef = 1
  for szTongName, szGateWay in pairs(tbDefenceJT.tbTong or {}) do
    Lst_SetCell(self.UIGROUP, self.LST_DEF_TONG, nDef, 0, szTongName)
    Lst_SetCell(self.UIGROUP, self.LST_DEF_TONG, nDef, 1, ServerEvent:GetServerNameByGateway(szGateWay))
    Lst_SetCell(self.UIGROUP, self.LST_DEF_TONG, nDef, 2, "已批准")
    nDef = nDef + 1
  end
  for szTongName, szGateWay in pairs(tbDefenceJT.tbPreTong or {}) do
    Lst_SetCell(self.UIGROUP, self.LST_DEF_TONG, nDef, 0, szTongName)
    Lst_SetCell(self.UIGROUP, self.LST_DEF_TONG, nDef, 1, ServerEvent:GetServerNameByGateway(szGateWay))
    Lst_SetCell(self.UIGROUP, self.LST_DEF_TONG, nDef, 2, "申请")
    Lst_SetLineColor(self.UIGROUP, self.LST_DEF_TONG, nDef, 0xffFFFF00)
    nDef = nDef + 1
  end

  -- 进攻军团
  local tbAttackJT = tbInfo[2] or {}
  local szAttLeaderTong = string.format("所属帮会：%s", tbAttackJT.tbCaptain.szTongName or "")
  local szAttLeaderName = string.format("领袖：%s", tbAttackJT.tbCaptain.szPlayerName or "")
  local szAttLeaderServer = string.format("区服：%s", ServerEvent:GetServerNameByGateway(tbAttackJT.tbCaptain.szGateway or ""))
  local nAttUninTong = string.format("联盟帮会：%s", tbAttackJT.nTongCount)
  local szAttAwardCount = string.format("赏金：%s", Item:FormatMoney(self:CalcMemberAward(tbAttackJT.tbAward.nAwardCount, tbAttackJT.tbAward.nMultiple)))

  Txt_SetTxt(self.UIGROUP, self.TXT_ATT_LEADERTONG, szAttLeaderTong)
  Txt_SetTxt(self.UIGROUP, self.TXT_ATT_LEADERNAME, szAttLeaderName)
  Txt_SetTxt(self.UIGROUP, self.TXT_ATT_LEADERSERVER, szAttLeaderServer)
  Txt_SetTxt(self.UIGROUP, self.TXT_ATT_UNIONTONG, nAttUninTong)
  Txt_SetTxt(self.UIGROUP, self.TXT_ATT_SHANGJIN, szAttAwardCount)

  local nAtt = 1
  for szTongName, szGateWay in pairs(tbAttackJT.tbTong or {}) do
    Lst_SetCell(self.UIGROUP, self.LST_ATT_TONG, nAtt, 0, szTongName)
    Lst_SetCell(self.UIGROUP, self.LST_ATT_TONG, nAtt, 1, ServerEvent:GetServerNameByGateway(szGateWay))
    Lst_SetCell(self.UIGROUP, self.LST_ATT_TONG, nAtt, 2, "已批准")
    nAtt = nAtt + 1
  end
  for szTongName, szGateWay in pairs(tbAttackJT.tbPreTong or {}) do
    Lst_SetCell(self.UIGROUP, self.LST_ATT_TONG, nAtt, 0, szTongName)
    Lst_SetCell(self.UIGROUP, self.LST_ATT_TONG, nAtt, 1, ServerEvent:GetServerNameByGateway(szGateWay))
    Lst_SetCell(self.UIGROUP, self.LST_ATT_TONG, nAtt, 2, "申请")
    Lst_SetLineColor(self.UIGROUP, self.LST_ATT_TONG, nAtt, 0xffFFFF00)
    nAtt = nAtt + 1
  end

  self:ChangeWndState()
end

function uiSelectGroup_NR:ChangeWndState()
  --军团领袖 显示同意申请按钮
  if me.szName == self.tbInfo[1].tbCaptain.szPlayerName then
    self:SetEnable(1, 0, 0, 0)
    return
  end
  if me.szName == self.tbInfo[2].tbCaptain.szPlayerName then
    self:SetEnable(0, 0, 1, 0)
    return
  end

  --帮会首领根据情况显示申请加入按钮状态
  if self.nCaptain and self.nCaptain == 1 then
    if self.tbInfo[1].tbTong[self.szTongName] then
      self:SetEnable(0, 1, 0, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_DEF_TONGJOIN, 0)
      self.nState = 1
      return
    end
    if self.tbInfo[2].tbTong[self.szTongName] then
      self:SetEnable(0, 0, 0, 1)
      Wnd_SetEnable(self.UIGROUP, self.BTN_ATT_TONGJOIN, 0)
      self.nState = 1
      return
    end
    if self.tbInfo[1].tbPreTong[self.szTongName] then
      self:SetEnable(0, 1, 0, 0)
      Btn_SetTxt(self.UIGROUP, self.BTN_DEF_TONGJOIN, "  撤销申请")
      self.nState = 2
      return
    end
    if self.tbInfo[2].tbPreTong[self.szTongName] then
      self:SetEnable(0, 0, 0, 1)
      Btn_SetTxt(self.UIGROUP, self.BTN_ATT_TONGJOIN, "  撤销申请")
      self.nState = 2
      return
    end
    self:SetEnable(0, 1, 0, 1)
    self.nState = 1
  else
    self:DisableAll()
    self:SetEnable(0, 0, 0, 0)
    return
  end
end

function uiSelectGroup_NR:OnRecvData(tbList, nCaptain, szTongName)
  if not tbList then
    return 0
  end
  self.tbInfo = tbList
  self.nCaptain = nCaptain or 0
  self.szTongName = szTongName or ""
  self:UpdateInfo(tbList)
end

function uiSelectGroup_NR:DisableAll()
  Wnd_SetEnable(self.UIGROUP, self.BTN_DEF_SINGLEJOIN, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_DEF_TONGJOIN, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_ATT_SINGLEJOIN, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_ATT_TONGJOIN, 0)
end

function uiSelectGroup_NR:SetEnable(nFirst, nSnd, nStrd, nFour)
  Wnd_SetEnable(self.UIGROUP, self.BTN_DEF_SINGLEJOIN, nFirst)
  Wnd_SetEnable(self.UIGROUP, self.BTN_DEF_TONGJOIN, nSnd)
  Wnd_SetEnable(self.UIGROUP, self.BTN_ATT_SINGLEJOIN, nStrd)
  Wnd_SetEnable(self.UIGROUP, self.BTN_ATT_TONGJOIN, nFour)
end

-- 计算投入与产出
function uiSelectGroup_NR:CalcMemberAward(nAwardCount, nMultiple)
  if nAwardCount <= 0 then
    return 0
  end
  local nCoin = 0
  local nTotal = 0
  local tbRet = {}
  for nLevel, tbInfo in ipairs(self.PLAYER_BOX_RADIO) do
    local nSort = math.floor(nAwardCount * tbInfo[1])
    local nBox = math.floor(nMultiple * tbInfo[2])
    tbRet[nLevel] = { nSort, nBox }
    nCoin = nCoin + (nSort - nTotal) * nBox * self.BINGMONEY
    nTotal = nSort
  end
  return nCoin, tbRet
end

function uiSelectGroup_NR:OnListSel(szWnd, nParam)
  if szWnd == self.LST_DEF_TONG then
    self:SelectApplayTong(1, nParam)
  elseif szWnd == self.LST_ATT_TONG then
    self:SelectApplayTong(2, nParam)
  end
end

function uiSelectGroup_NR:SelectApplayTong(nType, nParam)
  if nType == 1 then
    self.SelectTongName = Lst_GetCell(self.UIGROUP, self.LST_DEF_TONG, nParam, 0)
    if not self.tbInfo[1].tbPreTong[self.SelectTongName] then
      Wnd_SetEnable(self.UIGROUP, self.BTN_DEF_SINGLEJOIN, 0)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_DEF_SINGLEJOIN, 1)
    end
  else
    self.SelectTongName = Lst_GetCell(self.UIGROUP, self.LST_ATT_TONG, nParam, 0)
    if not self.tbInfo[2].tbPreTong[self.SelectTongName] then
      Wnd_SetEnable(self.UIGROUP, self.BTN_ATT_SINGLEJOIN, 0)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_ATT_SINGLEJOIN, 1)
    end
  end
end

function uiSelectGroup_NR:AgreeApply(nGroup)
  if not self.nCaptain or self.nCaptain == 0 then
    return
  end
  if not self.SelectTongName or self.SelectTongName == "" then
    return
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

function uiSelectGroup_NR:CancelApply(nGroup)
  if not self.nCaptain or self.nCaptain == 0 then
    return
  end
  local tbMsg = {}
  tbMsg.szMsg = "您确定要撤销申请吗？"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ "ApplyCancelGroupTong", nGroup })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end
