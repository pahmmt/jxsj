------------------------------------------------------
-- 文件名　：reincarnate.lua
-- 创建者　：dengyong
-- 创建时间：2012-11-06 10:03:15
-- 描  述  ：角色重生界面
------------------------------------------------------
local tbUiReincarnate = Ui:GetClass("reincarnate")
local tbSelAndNewRole = Ui:GetClass("selectandnewrole")

-- 两个界面共用控件
local BTN_REINCARNATE = "BtnConfirm"
local BTN_CLOSE = "BtnClose"

-- 提示界面专有控件
local TXT_SEXTIP = "TxtSexTip"
local TXT_NAMETIP = "TxtNameTip"

-- 操作界面专有控件
local BTN_RANDNAME = "BtnRandName"
local BTN_MALE = "BtnMale"
local BTN_FEMALE = "BtnFemale"
local TXT_ROLENAME = "TxtRoleName"
local TXT_SEX = "TxtSex"
local EDT_ROLENAME = "EditRoleName"
local WND_CHECKRESULT = "WndCheckResult"
local LST_CHECKRESULT = "LstCheckResult"
local TXTEX_BUYITEM = "TxtBuyItem"

local BTN_WAIT_TIME = 10

local tbWndGroup = {
  { TXT_SEXTIP, TXT_NAMETIP },
  { BTN_RANDNAME, BTN_MALE, BTN_FEMALE, TXT_ROLENAME, TXT_SEX, EDT_ROLENAME, WND_CHECKRESULT, LST_CHECKRESULT },
}

local tbTipText = {
  [[<color=239,180,52>1.<color>当前装备、备用装备、战魂装备，及背包、仓库内所有绑定的10级装备，都自动转为异性装备
	<color=239,180,52>2.<color>女性角色的美女资格及相关buff清空]],
  [[<color=239,180,52>1.<color>退出本届联赛（本服/跨服）战队并清空个人数据
	<color=239,180,52>2.<color>正在进行中的跨服城战个人数据清空
	<color=239,180,52>3.<color>钓鱼活动排行及领取背包个人资格清空
	<color=239,180,52>4.<color>藏宝图个人通关累积宝箱清空
	<color=239,180,52>5.<color>若曾邀请新玩家，个人获得绑金返还资格失效
	<color=239,180,52>6.<color>若为铁浮城主，个人额外购买宝箱资格失效
	<color=239,180,52>7.<color>一旦改名后，之前已使用角色名不可再次使用
	<color=239,180,52>8.<color>若在合服后10天内改名，从服玩家不能再领取合服奖励	]],
}

local tbBackImage = {
  "\\image\\ui\\002a\\reincarnate\\bg1.spr",
  "\\image\\ui\\002a\\reincarnate\\bg2.spr",
}

local tbButtonImage = {
  "\\image\\ui\\002a\\reincarnate\\btn_test.spr",
  "\\image\\ui\\002a\\reincarnate\\btn_reincarnate.spr",
}

local tbSexColor = {
  [0] = "0,241,227",
  [1] = "246,85,233",
}

local szResImage = "\\image\\ui\\002a\\reincarnate\\judge.spr"
local tbResImageFrame = {
  [0] = { 1, 1, 1, 1 },
  [1] = { 0, 0, 0, 0 },
}

function tbUiReincarnate:OnOpen()
  self.nMode = 1
  self.nBtnState = 1
  self.nBtnWaitTime = 0
  self:UpdateTipText()
  self:UpdateWindow()
end

function tbUiReincarnate:OnClose()
  self.nMode = 1
  self.nBtnState = 1
  self.nBtnWaitTime = 0
end

function tbUiReincarnate:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_REINCARNATE then
    self:ReincarnateClicked()
  elseif szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_RANDNAME then
    self:RandName()
  elseif szWnd == BTN_MALE or szWnd == BTN_FEMALE then
    Btn_Check(self.UIGROUP, szWnd, 1)
    Btn_Check(self.UIGROUP, BTN_MALE == szWnd and BTN_FEMALE or BTN_MALE, 0)
    self.nBtnState = 1
    self:UpdateWindow()
  end
end

function tbUiReincarnate:ReincarnateClicked()
  if self.nMode == 1 then
    self.nMode = 2
    self.nBtnState = 1
    self:UpdateWindow(1)
    return
  end

  local szName = Edt_GetTxt(self.UIGROUP, EDT_ROLENAME)
  local nSex = self:GetSex()
  if szName and szName ~= "" then
    if CheckRoleNameValid(szName) ~= 1 or IsNamePass(szName) ~= 1 then
      me.Msg("对不起，你输入的名字长度不对或包含敏感字词，请重新填写。")
      return
    end
  end

  if (not szName or szName == me.szName or szName == "") and (nSex == -1 or nSex == me.nSex) then
    me.Msg("你填写的重生信息和原角色信息一致，无法进行重生。")
    return
  end

  if self.nBtnState == 1 then -- 验身
    Lst_Clear(self.UIGROUP, LST_CHECKRESULT)
    me.CallServerScript({ "PlayerCmd", "ReincarnateCheck", szName, nSex })
    Wnd_SetEnable(self.UIGROUP, BTN_REINCARNATE, 0)
    self.nBtnWaitTime = BTN_WAIT_TIME
    Btn_SetTxt(self.UIGROUP, BTN_REINCARNATE, string.format("验身间隔%s秒", BTN_WAIT_TIME))
    Timer:Register(Env.GAME_FPS, self.OnBtnWaitTimer, self)
  else -- 重生
    local tbMsg = {}
    tbMsg.szMsg = "以下是你本次的重生信息：\n角色名"

    if not szName or szName == "" or szName == me.szName then
      tbMsg.szMsg = tbMsg.szMsg .. "：<color=red>无变更<color>\n"
    else
      tbMsg.szMsg = tbMsg.szMsg .. string.format("变为：<color=239,180,52>%s<color>\n", szName)
    end

    tbMsg.szMsg = tbMsg.szMsg .. "性别"
    if nSex == -1 or nSex == me.nSex then
      tbMsg.szMsg = tbMsg.szMsg .. "：<color=red>无变更<color>\n"
    else
      tbMsg.szMsg = tbMsg.szMsg .. string.format("变为：<color=%s>%s<color>\n", tbSexColor[nSex], Env.SEX_NAME[nSex])
    end

    tbMsg.szMsg = tbMsg.szMsg .. "<color=green>（确认并等待读条结束后，将自动退出，重新登录方能生效）<color>\n"

    tbMsg.nTimeout = 30
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, szName, nSex)
      if nOptIndex == 2 then
        me.CallServerScript({ "PlayerCmd", "ApplyReincarnate", szName, nSex })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, szName, nSex)
  end
end

function tbUiReincarnate:UpdateTipText()
  Txt_SetTxt(self.UIGROUP, TXT_SEXTIP, tbTipText[1])
  Txt_SetTxt(self.UIGROUP, TXT_NAMETIP, tbTipText[2])
end

function tbUiReincarnate:UpdateWindow(nFlag)
  nFlag = nFlag or 0
  Img_SetImage(self.UIGROUP, "Main", 1, tbBackImage[self.nMode])

  -- 隐藏不属于本界面的控件
  for nMode, tbWnds in pairs(tbWndGroup) do
    for _, szWnd in pairs(tbWnds) do
      if nMode == self.nMode then
        -- 要显示的
        Wnd_Show(self.UIGROUP, szWnd)
      else
        -- 要隐藏的
        Wnd_Hide(self.UIGROUP, szWnd)
      end
    end
  end

  -- 重生按钮状态
  if self.nMode == 2 then
    local szBtnImg = tbButtonImage[self.nBtnState]
    Img_SetImage(self.UIGROUP, BTN_REINCARNATE, 1, szBtnImg)
  end

  -- 填充默认数据
  if nFlag == 1 then
    Edt_SetTxt(self.UIGROUP, EDT_ROLENAME, me.szName)
    Btn_Check(self.UIGROUP, BTN_FEMALE, me.nSex)
    Btn_Check(self.UIGROUP, BTN_MALE, 1 - me.nSex)
  end
end

function tbUiReincarnate:GetSex()
  local nSex = -1 -- 没选性别
  if Btn_GetCheck(self.UIGROUP, BTN_MALE) == 1 then
    nSex = 0
  end

  if Btn_GetCheck(self.UIGROUP, BTN_FEMALE) == 1 then
    nSex = 1
  end

  return nSex
end

function tbUiReincarnate:RandName()
  local nSex = self:GetSex()
  if nSex < 0 then
    me.Msg("请先选择性别！")
    return
  end

  local szRand = tbSelAndNewRole:GetRandomName(nSex)
  Edt_SetTxt(self.UIGROUP, EDT_ROLENAME, szRand)
end

function tbUiReincarnate:OnCheckResult(tbCheckRes)
  local nResult = 1
  for i, tbRes in pairs(tbCheckRes or {}) do
    local szMsg = ""
    if type(tbRes[2]) == "table" then
      szMsg = tbRes[2][1]
      TxtEx_SetText(self.UIGROUP, TXTEX_BUYITEM, "<a=infor>奇珍阁购买<a>")
      if tbRes[1] == 0 then
        Wnd_Show(self.UIGROUP, TXTEX_BUYITEM)
      else
        Wnd_Hide(self.UIGROUP, TXTEX_BUYITEM)
      end
    else
      szMsg = tbRes[2]
    end

    Lst_SetImageCell(self.UIGROUP, LST_CHECKRESULT, i, 0, szResImage, unpack(tbResImageFrame[tbRes[1]]))
    Lst_SetCell(self.UIGROUP, LST_CHECKRESULT, i, 1, szMsg)

    if tbRes[1] == 0 then
      Lst_SetLineColor(self.UIGROUP, LST_CHECKRESULT, i, 0x00FF0000)
    else
      Lst_SetLineColor(self.UIGROUP, LST_CHECKRESULT, i, 0x0000FF00)
    end

    nResult = nResult * tbRes[1]
  end

  if nResult ~= 0 then -- 如果验身成功，把按钮切换至重生状态
    self.nBtnState = 2
    self:UpdateWindow()
    Wnd_SetEnable(self.UIGROUP, BTN_REINCARNATE, 1)
    self.nBtnWaitTime = 0
    Btn_SetTxt(self.UIGROUP, BTN_REINCARNATE, "")
  elseif self.nBtnState == 2 then
    self.nBtnState = 1
    self:UpdateWindow()
  end
end

function tbUiReincarnate:OnAlterResult(nResult)
  if nResult == 0 then
    self.nBtnState = 1
    self:UpdateWindow()
  end
end

function tbUiReincarnate:Link_infor_OnClick(szWnd, szLinkData)
  me.CallServerScript({ "PlayerCmd", "ApplyBuyAlterItem" })
end

function tbUiReincarnate:OnEditChange(szWnd, nParam)
  if szWnd == EDT_ROLENAME then
    self.nBtnState = 1 -- 名字改了，要重置按钮状态
    self:UpdateWindow()
  end
end

function tbUiReincarnate:OnBtnWaitTimer()
  self.nBtnWaitTime = self.nBtnWaitTime - 1

  if self.nBtnWaitTime <= 0 then
    Btn_SetTxt(self.UIGROUP, BTN_REINCARNATE, "")
    Wnd_SetEnable(self.UIGROUP, BTN_REINCARNATE, 1)
    return 0
  end

  local szText = string.format("验身间隔%d秒", self.nBtnWaitTime)
  Btn_SetTxt(self.UIGROUP, BTN_REINCARNATE, szText)
end
