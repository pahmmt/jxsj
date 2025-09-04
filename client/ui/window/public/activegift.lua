-- 文件名　：activegift.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-11-01 09:09:03
-- 功能    ：

local uiActiveGift = Ui:GetClass("activegift")
uiActiveGift.BtnDayAward = "BtnDayAward" --累计天数奖励
uiActiveGift.TxtLoginAward = "TxtLoginAward" --累计天数领取状态
uiActiveGift.BtnActiveAward = "BtnActiveAward" --活跃度奖励
uiActiveGift.TxtActiveAward = "TxtActiveAward" --活跃度领取状态

uiActiveGift.TxtLogin = "TxtLogin" --登录天数
uiActiveGift.TxtActive = "TxtActive" --活跃度

uiActiveGift.ProActive = "ProActive" --活跃度进度条
uiActiveGift.ProLogin = "ProLogin" --登录进度条

uiActiveGift.ActiveInfoPanel = "ActiveInfoPanel" --活跃度详细
uiActiveGift.ActiveInfoList = "ActiveInfoList" --活跃度list

uiActiveGift.BtnClose = "BtnClose" --关闭按钮

uiActiveGift.ImgBntDay = "BtnDayImg" --按钮图素，特效
uiActiveGift.ImgBntActive = "BtnActiveImg" --按钮图素，特效

uiActiveGift.szEffectFileName = "\\image\\effect\\item\\white1.spr"

uiActiveGift.tbWndAward = {
  ["BtnDayAward1"] = { 1, 1 },
  ["BtnDayAward2"] = { 1, 2 },
  ["BtnDayAward3"] = { 1, 3 },
  ["BtnDayAward4"] = { 1, 4 },
  ["BtnDayAward5"] = { 1, 5 },
  ["BtnActiveAward1"] = { 2, 1 },
  ["BtnActiveAward2"] = { 2, 2 },
  ["BtnActiveAward3"] = { 2, 3 },
  ["BtnActiveAward4"] = { 2, 4 },
  ["BtnActiveAward5"] = { 2, 5 },
}

SpecialEvent.ActiveGift = SpecialEvent.ActiveGift or {}
local ActiveGift = SpecialEvent.ActiveGift

function uiActiveGift:Init()
  if self.nTimerFlag then
    Timer:Close(self.nTimerFlag)
  end
  self.nTimerFlag = Timer:Register(Env.GAME_FPS * 4, self.CheckFlag, self)
end

function uiActiveGift:OnOpen()
  self.tbShowActive = {}
  self:UpDate()
end

function uiActiveGift:OnClose()
  UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
end

function uiActiveGift:UpDate()
  self:UpProcess() --更新进度栏
  self:UpButton() --更新按钮状态
  self:UpList() --更新list
end

function uiActiveGift:UpProcess()
  local nActiveGrade = ActiveGift:GetActiveGrade()
  local nMonthActive = ActiveGift:GetMonthActive()
  Prg_SetPos(self.UIGROUP, self.ProActive, nActiveGrade / ActiveGift.nMaxActiveGrade * 1000)
  Txt_SetTxt(self.UIGROUP, self.TxtActive, string.format("今日活跃度：%s / %s", nActiveGrade, ActiveGift.nMaxActiveGrade))
  Prg_SetPos(self.UIGROUP, self.ProLogin, nMonthActive / ActiveGift.nMaxMonthActive * 1000)
  Txt_SetTxt(self.UIGROUP, self.TxtLogin, string.format("本月累计活跃度：%s / %s", nMonthActive, ActiveGift.nMaxMonthActive))
end

function uiActiveGift:UpButton()
  for i = 1, 5 do
    local BntLogin = self.BtnDayAward .. i
    local BntActive = self.BtnActiveAward .. i
    local TxtLogin = self.TxtLoginAward .. i
    local TxtActive = self.TxtActiveAward .. i
    local ImgBntActive = self.ImgBntActive .. i
    local ImgBntDay = self.ImgBntDay .. i
    --设置按钮tip
    local szLoginInfo, szActiveInfo, nLoginDay, nActiveGrade = ActiveGift:GetAwardInfo(i)
    Wnd_SetTip(self.UIGROUP, BntLogin, szLoginInfo)
    Wnd_SetTip(self.UIGROUP, BntActive, szActiveInfo)
    --设置按钮状态
    local bActive, bLogin = ActiveGift:GetAwardState(i)
    local bCanGActive = ActiveGift:CheckCanGetAward(1, i)
    local bCanGLogin = ActiveGift:CheckCanGetAward(2, i)
    if not bActive and bCanGActive == 1 then --可以领取，还没领取
      Img_SetImage(self.UIGROUP, ImgBntActive, 1, self.szEffectFileName)
      Img_PlayAnimation(self.UIGROUP, ImgBntActive, 1)
      Img_SetFrame(self.UIGROUP, BntActive, 0)
    else
      Img_StopAnimation(self.UIGROUP, ImgBntActive)
      Wnd_SetVisible(self.UIGROUP, ImgBntActive, 0)
      if bActive then
        Img_SetFrame(self.UIGROUP, BntActive, 0)
      elseif bCanGActive == 0 then
        Img_SetFrame(self.UIGROUP, BntActive, 1)
      end
    end
    if not bLogin and bCanGLogin == 1 then --可以领取，还没领取
      Img_SetImage(self.UIGROUP, ImgBntDay, 1, self.szEffectFileName)
      Img_PlayAnimation(self.UIGROUP, ImgBntDay, 1)
      Img_SetFrame(self.UIGROUP, BntLogin, 0)
    else
      Img_StopAnimation(self.UIGROUP, ImgBntDay)
      Wnd_SetVisible(self.UIGROUP, ImgBntDay, 0)
      if bLogin then
        Img_SetFrame(self.UIGROUP, BntLogin, 0)
      elseif bCanGLogin == 0 then
        Img_SetFrame(self.UIGROUP, BntLogin, 1)
      end
    end
    if not bLogin then
      if bCanGLogin == 1 then
        Txt_SetTxt(self.UIGROUP, TxtLogin, nLoginDay .. "点\n<color=0xffDFCBB7>可领取<color>")
      else
        Txt_SetTxt(self.UIGROUP, TxtLogin, nLoginDay .. "点\n<color=red>未领取<color>")
      end
    else
      Txt_SetTxt(self.UIGROUP, TxtLogin, nLoginDay .. "点\n<color=green>已领取<color>")
    end
    if not bActive then
      if bCanGActive == 1 then
        Txt_SetTxt(self.UIGROUP, TxtActive, nActiveGrade .. "点\n<color=0xffDFCBB7>可领取<color>")
      else
        Txt_SetTxt(self.UIGROUP, TxtActive, nActiveGrade .. "点\n<color=red>未领取<color>")
      end
    else
      Txt_SetTxt(self.UIGROUP, TxtActive, nActiveGrade .. "点\n<color=green>已领取<color>")
    end
  end
end

function uiActiveGift:UpList()
  local tbFinish = {} --已经完成的
  local tbUnable = {} --当前不可用
  local tbCommon = {} --正常
  for nId, tbInfo in ipairs(ActiveGift.tbActiveInfo) do
    local bFinifh = ActiveGift:CheckCanAddActive(nId)
    if bFinifh == 0 then
      tbUnable[nId] = tbInfo
    elseif bFinifh == 2 then
      tbFinish[nId] = tbInfo
    elseif bFinifh == 1 then
      tbCommon[nId] = tbInfo
    end
  end
  local nCount = 1
  for nId, tbInfo in pairs(tbCommon) do
    Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 0, tbInfo.szName)
    local szTimeState = self:GetActiveTimes(nId)
    Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 1, szTimeState)
    Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 2, ActiveGift.tbActiveInfo[nId].nGrade)
    self.tbShowActive[nCount] = nId
    nCount = nCount + 1
  end
  for nId, tbInfo in pairs(tbFinish) do
    Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 0, tbInfo.szName)
    local szTimeState = self:GetActiveTimes(nId)
    Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 1, szTimeState)
    Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 2, ActiveGift.tbActiveInfo[nId].nGrade)
    Lst_SetLineColor(self.UIGROUP, self.ActiveInfoList, nCount, 0xff00FF00)
    self.tbShowActive[nCount] = nId
    nCount = nCount + 1
  end
  for nId, tbInfo in pairs(tbUnable) do
    if ActiveGift.tbActiveInfo[nId].bOneOff == 0 then
      Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 0, tbInfo.szName)
      local szTimeState = self:GetActiveTimes(nId)
      Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 1, szTimeState)
      Lst_SetCell(self.UIGROUP, self.ActiveInfoList, nCount, 2, ActiveGift.tbActiveInfo[nId].nGrade)
      Lst_SetLineColor(self.UIGROUP, self.ActiveInfoList, nCount, 0xffFF0000)
      self.tbShowActive[nCount] = nId
      nCount = nCount + 1
    end
  end
end

function uiActiveGift:GetActiveTimes(nId)
  local tbActiveInfo = ActiveGift.tbActiveInfo[nId]
  local nDate = me.GetTask(ActiveGift.nTaskGroupId, tbActiveInfo.nActiveId)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  local nTimes = me.GetTask(ActiveGift.nTaskGroupId, tbActiveInfo.nSubId)
  if nDate ~= nNowDate then
    nTimes = 0
  end
  return nTimes .. " / " .. tbActiveInfo.nMaxCount
end

function uiActiveGift:OnButtonClick(szWnd, nParam)
  if szWnd == self.BtnClose then
    UiManager:CloseWindow(self.UIGROUP)
  else
    for i = 1, 5 do
      if szWnd == self.BtnDayAward .. i then --领取累计天数奖励
        self:GetAward(1, i, self.BtnDayAward .. i)
      elseif szWnd == self.BtnActiveAward .. i then --领取活跃度奖励
        self:GetAward(2, i, self.BtnActiveAward .. i)
      end
    end
  end
end

function uiActiveGift:OnMouseEnter(szWnd)
  if self.tbWndAward[szWnd] then
    local tbAward = {}
    if self.tbWndAward[szWnd][1] == 1 then
      tbAward = ActiveGift.tbMonthAward[self.tbWndAward[szWnd][2]].tbParam
    elseif self.tbWndAward[szWnd][1] == 2 then
      tbAward = ActiveGift.tbActiveAward[self.tbWndAward[szWnd][2]].tbParam
    end
    local _, _, nX, nY = Wnd_GetPos(self.UIGROUP, szWnd)
    UiManager:OpenWindow(Ui.UI_ACTIVEGETAWAED, tbAward)
    UiManager:MoveWindow(Ui.UI_ACTIVEGETAWAED, nX + 25, nY + 25)
  end
end

function uiActiveGift:OnMouseLeave(szWnd)
  if "Main" == szWnd then
    Timer:Register(2, self.OnTimerClose, self)
  end
end

function uiActiveGift:OnTimerClose()
  print(Ui(Ui.UI_ACTIVEGETAWAED).bEnterFlag)
  if Ui(Ui.UI_ACTIVEGETAWAED).bEnterFlag ~= 1 then
    UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
  end
  return 0
end

function uiActiveGift:OnListOver(szWnd, nIndex)
  if szWnd == self.ActiveInfoList and nIndex > 0 then
    local nId = self.tbShowActive[nIndex]
    local tbActiveInfo = ActiveGift.tbActiveInfo[nId]
    local szName = tbActiveInfo.szName
    local szInfo = tbActiveInfo.szInfo
    local nRet, szState = ActiveGift:CheckCanAddActive(nId)
    local szMsg = "\n\n" .. szInfo .. "\n"
    if nRet == 0 then
      szMsg = szMsg .. "\n<color=red>条件不足：" .. szState .. "<color>"
    elseif nRet == 2 then
      szMsg = szMsg .. "\n<color=green>已完成<color>"
    end
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, szName, szMsg)
  end
end

--领奖
function uiActiveGift:GetAward(nType, nId, szWnd)
  local bActive, bLogin = ActiveGift:GetAwardState(nId)
  local tbAward = {}
  local nFlag = 1
  if nType == 1 then
    if bLogin then
      me.Msg("您已经领取过这个奖励了。")
      UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
      return
    end
    local bCanGLogin, szErrorMsg = ActiveGift:CheckCanGetAward(2, nId)
    if bCanGLogin <= 0 then
      me.Msg(szErrorMsg)
      UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
      return
    end
    me.CallServerScript({ "GetActiveMonthAward", nId })
  elseif nType == 2 then
    if bActive then
      nFlag = 0
      me.Msg("您已经领取过这个奖励了。")
      UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
      return
    end
    local bCanGActive, szErrorMsg = ActiveGift:CheckCanGetAward(1, nId)
    if bCanGActive <= 0 then
      nFlag = 0
      me.Msg(szErrorMsg)
      UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
      return
    end
    me.CallServerScript({ "GetActiveGiftAward", nId })
  end
  UiManager:CloseWindow(Ui.UI_ACTIVEGETAWAED)
  Timer:Register(9, self.Time, self)
end

function uiActiveGift:Time()
  self:UpDate()
  return 0
end

function uiActiveGift:CheckFlag()
  local nFlag = 0
  for i = 1, 5 do
    local bCanGActive = ActiveGift:CheckCanGetAward(1, i)
    local bCanGLogin = ActiveGift:CheckCanGetAward(2, i)
    if bCanGLogin == 1 or bCanGActive == 1 then
      nFlag = 1
      break
    end
  end
  if nFlag == 1 then
    SetAwordNewFlag(1)
  else
    SetAwordNewFlag(0)
  end
  return
end
