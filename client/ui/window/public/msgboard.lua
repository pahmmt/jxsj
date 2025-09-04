-----------------------------------------------------
--文件名		：	msgboard.lua
--创建者		：	sunduoliang
--创建时间		：	2008-3-14
--功能描述		：	在线GM留言板。
------------------------------------------------------

local uiMsgBoard = Ui:GetClass("msgboard")

local TXT_HELP_DESCRIPT = "TxtHelpDescript"
local EDT_SERVER = "EditServer"
local EDT_ACCOUNT = "EditAccount"
local EDT_NAME = "EditRoleName"
local EDT_LEVEL = "EditLevel" -- 基础属性页:玩家等级
local EDT_DESCRIPT = "EditDescript"
local BTN_ACCEPT = "BtnAccept"
local BTN_CANCEL = "BtnCancel"
local BTN_CLOSE = "BtnClose"
local COMBOBOX_FATHER = "ComboBoxFather"
local COMBOBOX_CHILD = "ComboBoxChild"
local tbDate = {}
local szContact = string.format("注：如有需要，请填写您的联系方式，%s我们将为您提供真诚满意的服务！%s", UiManager.IVER_szTelNote, UiManager.IVER_szTelNum)

local INFO_TABLE = {
  {
    szName = "BUG/咨询",
    tbChild = {
      {
        szName = "任务流程咨询",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>具体任务名称，玩家咨询内容<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "技能技巧咨询",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>具体功能名称，玩家咨询内容<color>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "BUG反馈/违规举报",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>BUG描述，违规角色及角色名描述，举报内容<color><enter><enter>%s", szContact),
        szFilter = "bug",
      },
      {
        szName = "游戏活动咨询",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>活动描述，玩家咨询内容<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
    },
  },
  {
    szName = "服务器故障",
    tbChild = {
      {
        szName = "地图服务器故障",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>区服、帐号、角色名、地图名称<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "网站故障",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>系统名称、页面描述、错误提示<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
    },
  },
  {
    szName = "安装更新",
    tbChild = {
      {
        szName = "无法下载",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>更新包版本，下载位置，上网方式<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "无法安装",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>更新包版本，下载位置，错误提示<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "无法在线更新",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>客户端版本，错误提示，操作系统<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "更新后异常",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>异常情况描述<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
    },
  },
  {
    szName = "客服业务",
    tbChild = {
      {
        szName = "密码修改",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>咨询内容，帐号<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "角色恢复/转服",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>咨询内容，帐号，角色<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "物品异常消失",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号/角色/区服，物品最后拥有/发现消失时间<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "违规封停咨询",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号、角色、玩家反馈内容<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "VIP 服务",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号、玩家信息，咨询内容<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "手机绑定",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号，玩家信息，咨询内容<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
    },
  },
  {
    szName = "充值缴费",
    tbChild = {
      {
        szName = "充值查询",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>金额，一卡通号或订单号，购买方式，查询内容<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "领取兑换",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>充值帐号/金额/领取方式，领取角色/时间/领取数量，问题描述<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "无法充值",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>问题描述，充值帐号/金额/方式<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "充值咨询",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>咨询的具体信息<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
    },
  },
  {
    szName = "角色/任务异常",
    tbChild = {
      {
        szName = "人物属性异常",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号/角色/服务器、角色/帮派信息（如等级）、系统提示<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "物品使用异常",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号/角色/服务器、物品信息（名称，主要属性）、系统提示<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "物品无故消失",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号/角色/服务器、物品信息（名称，主要属性），最后正常时间/发现消失时间、物品来源<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "角色数据异常",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号、角色、服务器、异常的情况描述，出现异常的时间<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
      {
        szName = "任务交接异常",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号、角色、服务器、任务名称、系统提示、任务栏显示<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
    },
  },
  {
    szName = "投诉建议",
    tbChild = {
      {
        szName = "用户投诉",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号/角色/区服、投诉内容、个人信息/相关要求<color><enter><enter>%s", szContact),
        szFilter = "advise",
      },
      {
        szName = "用户建议",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>帐号/区服、建议内容、个人信息<color><enter><enter>%s", szContact),
        szFilter = "advise",
      },
      {
        szName = "各类内容纠正",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>错误信息具体位置，错误内容<color><enter><enter>%s", szContact),
        szFilter = "advise",
      },
    },
  },
  {
    szName = "其它类别",
    tbChild = {
      {
        szName = "其它类别",
        szDescript = string.format("<color=red>[填写信息]<color><color=white>问题详细描述<color><enter><enter>%s", szContact),
        szFilter = "manual",
      },
    },
  },
}

local PUT_INFO_TABLE = {
  {
    szName = "举报",
    tbChild = {
      {
        szName = "不良聊天信息",
        szDescript = "<color=red>举报投诉玩家姓名和信息<color><enter><enter><color=yellow>注：该项信息不能修改<color>",
        szFilter = "accuse",
      },
    },
  },
}

function uiMsgBoard:Init()
  self.nFatherClass = 0
  self.nChildClass = 0
  self.szAppealMsg = ""
  self.szSourceText = nil
  self.tbClassTemp = {}
  self.szReportRoleName = nil
end

function uiMsgBoard:UpdateServer()
  local szName = GetServerName()
  if UiManager.IVER_nMsgBoardNameSplitType == 1 then
    local nSplit = string.find(szName, "-")
    if nSplit then
      szName = string.sub(szName, 1, nSplit - 1)
    end
  else
    local nStart = string.find(szName, "【")
    local nEnd = string.find(szName, "】")
    local nSplit = string.find(szName, "-")
    if nStart and nEnd then
      szName = string.sub(szName, nStart, nEnd + 1)
    elseif nSplit then
      szName = string.sub(szName, 1, nSplit - 1)
    end
  end
  Edt_SetTxt(self.UIGROUP, EDT_SERVER, szName)
end

function uiMsgBoard:UpdateAccount()
  Edt_SetTxt(self.UIGROUP, EDT_ACCOUNT, "(当前帐号)")
end

function uiMsgBoard:UpdateName()
  Edt_SetTxt(self.UIGROUP, EDT_NAME, me.szName)
end

function uiMsgBoard:UpdateLevel()
  Edt_SetTxt(self.UIGROUP, EDT_LEVEL, me.nLevel)
end

function uiMsgBoard:UpdateDescript()
  Edt_SetTxt(self.UIGROUP, EDT_DESCRIPT, "")
end

function uiMsgBoard:OnUpdateBasic()
  -- 更新所有控件
  self:UpdateServer()
  self:UpdateAccount()
  self:UpdateName()
  self:UpdateLevel()
  self:UpdateDescript()
end
-- 填充下拉框
function uiMsgBoard:FillComboBoxFather(tbFatherClass)
  ClearComboBoxItem(self.UIGROUP, COMBOBOX_FATHER)
  local nItemCount = 0
  for nId, tbClass in pairs(tbFatherClass) do
    if ComboBoxAddItem(self.UIGROUP, COMBOBOX_FATHER, nId, tbClass.szName) == 1 then
      nItemCount = nItemCount + 1
    end
  end

  return nItemCount
end

function uiMsgBoard:FillComboBoxChild(tbFatherClass)
  ClearComboBoxItem(self.UIGROUP, COMBOBOX_CHILD)
  local nItemCount = 0

  for nId, tbClass in pairs(tbFatherClass[self.nFatherClass + 1].tbChild) do
    if ComboBoxAddItem(self.UIGROUP, COMBOBOX_CHILD, nId, tbClass.szName) == 1 then
      nItemCount = nItemCount + 1
    end
  end

  return nItemCount
end

function uiMsgBoard:OnOpen(szMsg, szSourceText, szReportRoleName)
  if IVER_g_nTwVersion == 1 then
    local szGM_TW_URL = "http://service.gameflier.com/bug/bug_intro.asp"
    OpenWebSite(szGM_TW_URL)
    return 0
  end

  -- 填充下拉菜单
  self:OnUpdateBasic()
  self.nFatherClass = 0
  self.nChildClass = 0
  self.tbClassTemp = INFO_TABLE
  self.szAppealMsg = szMsg or "" --投诉信息
  self.szSourceText = szSourceText
  if szReportRoleName then
    self.szReportRoleName = szReportRoleName
  end
  if szSourceText then
    Wnd_SetEnable(self.UIGROUP, EDT_SERVER, 0)
    Wnd_SetEnable(self.UIGROUP, EDT_ACCOUNT, 0)
    Wnd_SetEnable(self.UIGROUP, EDT_NAME, 0)
    Wnd_SetEnable(self.UIGROUP, EDT_LEVEL, 0)
    Wnd_SetEnable(self.UIGROUP, EDT_DESCRIPT, 0)
    Edt_SetTxt(self.UIGROUP, EDT_DESCRIPT, self.szAppealMsg)
    self.tbClassTemp = PUT_INFO_TABLE
  end

  local nItemCount = self:FillComboBoxFather(self.tbClassTemp)
  if nItemCount <= 0 then
    return 0
  end
  nItemCount = self:FillComboBoxChild(self.tbClassTemp)
  if nItemCount <= 0 then
    return 0
  end

  ComboBoxSelectItem(self.UIGROUP, COMBOBOX_FATHER, self.nFatherClass)
  ComboBoxSelectItem(self.UIGROUP, COMBOBOX_CHILD, self.nChildClass)
  Txt_SetTxt(self.UIGROUP, TXT_HELP_DESCRIPT, self.tbClassTemp[self.nFatherClass + 1].tbChild[self.nChildClass + 1].szDescript)
end

-- 点击快捷按键处理
function uiMsgBoard:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CANCEL then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_ACCEPT then
    local nNowDate = tonumber(GetLocalDate("%y%m%d%H%M%S"))
    if tbDate[me.nId] == nil then
      tbDate[me.nId] = 0
    end
    if (nNowDate - tbDate[me.nId]) < 10 then
      Dialog:Say("对不起，10秒内只能留言一次，请稍后再留言。")
      UiManager:CloseWindow(self.UIGROUP)
      return 0
    end

    local szServer = Edt_GetTxt(self.UIGROUP, EDT_SERVER)
    local szAccount = Edt_GetTxt(self.UIGROUP, EDT_ACCOUNT)
    local szName = Edt_GetTxt(self.UIGROUP, EDT_NAME)
    local nLevel = tonumber(Edt_GetTxt(self.UIGROUP, EDT_LEVEL))
    local szDescript = self.szSourceText or Edt_GetTxt(self.UIGROUP, EDT_DESCRIPT)

    local tbClassFather = self.tbClassTemp[self.nFatherClass + 1]
    local szClassFather = tbClassFather.szName

    local tbClassChild = tbClassFather.tbChild[self.nChildClass + 1]
    local szClassChild = tbClassChild.szName
    local szFilter = tbClassChild.szFilter

    if szAccount == "(当前帐号)" then
      szAccount = me.szAccount
    end

    if string.len(szServer) <= 2 then
      Dialog:Say("请输入正确的区服名。")
      return 0
    end
    if string.len(szAccount) <= 2 then
      Dialog:Say("请输入正确的帐号名。")
      return 0
    end
    if string.len(szName) <= 2 then
      Dialog:Say("请输入正确的角色名。")
      return 0
    end
    if type(nLevel) ~= "number" then
      Dialog:Say("等级必须是数字。")
      return 0
    end
    if string.len(szDescript) <= 10 and not self.szSourceText then
      Dialog:Say("请输入详细的描述信息。")
      return 0
    end
    print(szServer, szAccount, szName, nLevel, szClassFather, szClassChild, szFilter, szDescript, self.szReportRoleName)

    if self.szReportRoleName then
      me.SendMsgBoard(szServer, szAccount, szName, nLevel, szClassFather, szClassChild, szFilter, szDescript, self.szReportRoleName)
    else
      me.SendMsgBoard(szServer, szAccount, szName, nLevel, szClassFather, szClassChild, szFilter, szDescript)
    end
    tbDate[me.nId] = nNowDate
    UiManager:CloseWindow(self.UIGROUP)
  end
end

-- 下拉菜单改变
function uiMsgBoard:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == COMBOBOX_FATHER then
    self.nFatherClass = nIndex
    self.nChildClass = 0
    self:FillComboBoxChild(self.tbClassTemp)
    ComboBoxSelectItem(self.UIGROUP, COMBOBOX_CHILD, self.nChildClass)
    Txt_SetTxt(self.UIGROUP, TXT_HELP_DESCRIPT, self.tbClassTemp[self.nFatherClass + 1].tbChild[self.nChildClass + 1].szDescript)
  elseif szWnd == COMBOBOX_CHILD then
    self.nChildClass = nIndex
    Txt_SetTxt(self.UIGROUP, TXT_HELP_DESCRIPT, self.tbClassTemp[self.nFatherClass + 1].tbChild[self.nChildClass + 1].szDescript)
  end
end

function uiMsgBoard:OpenBoardForReport(szName, szMsg, szSourceText)
  UiManager:OpenWindow(Ui.UI_MSGBOARD, szName .. ":" .. szMsg, szName .. ":" .. szSourceText, szName)
end

function uiMsgBoard:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_REPORT_SOMEONE, self.OpenBoardForReport },
  }
  return tbRegEvent
end
