-- 文件名　：aword.lua
-- 创建者　：jiazhenwei
-- 创建时间：2010-05-05 16:33:19
-- 描  述  ：

SpecialEvent.tbAword = SpecialEvent.tbAword or {}
local tbAword = SpecialEvent.tbAword

tbAword.tbPicture = {
  [1] = "\\image\\ui\\001a\\zaixianlingjiang\\lj_online.spr", --礼物1
  [2] = "\\image\\icon\\task\\prize_money.spr", --银两
  [3] = "\\image\\icon\\task\\prize_money.spr", --绑定银两
  [4] = "\\image\\item\\other\\scriptitem\\jintiao_xiao.spr", --绑金
  [5] = "\\image\\ui\\001a\\zaixianlingjiang\\lj_days.spr",
} --礼物1

function tbAword:Init(tbAwordEx, tbAword_timer, tbAword_Day, nOpenTime, nCloseTime, tbOpenFlag, nOpenZaiXian)
  self.tbAword = tbAwordEx
  self.tbAword_timer = tbAword_timer
  self.tbAword_Day = tbAword_Day
  self.nOpenTime = nOpenTime
  self.nCloseTime = nCloseTime
  self.nTimerId = self.nTimerId
  self.nTimerRemain = self.nTimerRemain
  self.tbOpenFlag = tbOpenFlag
  self.nOpenZaiXian = nOpenZaiXian or 1
  if self.nTimerFlag then
    Timer:Close(self.nTimerFlag)
  end
  self.nTimerFlag = Timer:Register(Env.GAME_FPS * 5, self.CheckFlag, self)
end

function tbAword:OpenAwordOnlineTimer()
  if self.nTimerId and self.nTimerRemain and self.nTimerRemain > 0 then
    Timer:Close(self.nTimerId)
  end
  local nNum = me.GetTask(2122, 9)
  local nNowTime = GetTime()
  if self.tbAword_timer[nNum + 1] and (nNowTime - me.GetTask(2122, 11) < self.tbAword_timer[nNum + 1]) then
    self.nTimerRemain = self.tbAword_timer[nNum + 1]
    self.nTimerId = Timer:Register(Env.GAME_FPS, self.OnTimerDecrease, self)
  else
    self.nTimerRemain = 0
  end
end

function tbAword:OnTimerDecrease()
  self.nTimerRemain = self.nTimerRemain - 1
  if self.nTimerRemain <= 0 then
    return 0
  end
  return
end

-- 带开关的设置显示
function tbAword:SetAwordNewFlag(nFlag, nAwardWin)
  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[nAwardWin] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[nAwardWin]
  end
  if nOpenFlag == 0 or SpecialEvent.tbAword.nOpenZaiXian == 0 then
    return
  end
  SetAwordNewFlag(nFlag)
end

function tbAword:CheckFlag()
  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[1] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[1]
  end
  if nOpenFlag == 1 and SpecialEvent.tbAword.nOpenZaiXian == 1 then
    if me.GetTask(2122, 7) == 0 then
      SetAwordNewFlag(1)
      return
    else
      SetAwordNewFlag(0)
    end
  else
    SetAwordNewFlag(0)
  end

  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[2] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[2]
  end
  if nOpenFlag == 1 and SpecialEvent.tbAword.nOpenZaiXian == 1 then
    if self.tbAword_Day[me.GetTask(2122, 8) + 1] and self.tbAword_Day[me.GetTask(2122, 8) + 1] <= me.GetTask(2063, 20) then
      SetAwordNewFlag(1)
      return
    else
      SetAwordNewFlag(0)
    end
  else
    SetAwordNewFlag(0)
  end

  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[3] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[3]
  end
  if nOpenFlag == 1 and SpecialEvent.tbAword.nOpenZaiXian == 1 then
    local nNum = me.GetTask(2122, 9)
    local tbAwordOnline = self.tbAword[3] or {}
    if #tbAwordOnline > 0 then
      local tbAwordOnlineEx = tbAwordOnline[nNum + 1] or {}
      if #tbAwordOnlineEx > 0 then
        if SpecialEvent.tbAword.nTimerRemain and SpecialEvent.tbAword.nTimerRemain <= 0 then
          SetAwordNewFlag(1)
          return
        else
          SetAwordNewFlag(0)
        end
      end
    end
  else
    SetAwordNewFlag(0)
  end

  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[4] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[4]
  end
  if nOpenFlag == 1 and SpecialEvent.tbAword.nOpenZaiXian == 1 then
    local nNum = me.GetTask(2034, 10)
    local tbAwordUpLevel = self.tbAword[4] or {}
    if #tbAwordUpLevel > 0 then
      if nNum == 0 then
        nNum = 1
      end
      local tbAwordUpLevelEx = tbAwordUpLevel[nNum] or {}
      if #tbAwordUpLevelEx > 0 then
        if tbAwordUpLevelEx[1][8] <= me.nLevel then
          SetAwordNewFlag(1)
          return
        else
          SetAwordNewFlag(0)
        end
      end
    end
  else
    SetAwordNewFlag(0)
  end
  return
end

function tbAword:GetTips(tbAword, nFlag)
  local szMsg = ""
  for _, tbAwordEx in ipairs(tbAword) do
    if tbAwordEx[3] ~= 0 then
      local pItem = KItem.CreateTempItem(tbAwordEx[2][1], tbAwordEx[2][2], tbAwordEx[2][3], tbAwordEx[2][4], 0)
      if pItem then
        if nFlag == 0 then
          szMsg = szMsg .. tbAwordEx[3] .. "个" .. pItem.szName
        else
          szMsg = szMsg .. tbAwordEx[3] .. "个" .. pItem.szName .. "\n"
        end
      end
    end
    if tbAwordEx[4] ~= 0 then
      if nFlag == 0 then
        szMsg = szMsg .. tbAwordEx[4] .. "银两"
      else
        szMsg = szMsg .. tbAwordEx[4] .. "银两\n"
      end
    end
    if tbAwordEx[5] ~= 0 then
      if nFlag == 0 then
        szMsg = szMsg .. tbAwordEx[5] .. "绑定银两"
      else
        szMsg = szMsg .. tbAwordEx[5] .. "绑定银两\n"
      end
    end
    if tbAwordEx[6] ~= 0 then
      if nFlag == 0 then
        szMsg = szMsg .. tbAwordEx[6] .. "绑定" .. IVER_g_szCoinName
      else
        szMsg = szMsg .. tbAwordEx[6] .. "绑定" .. IVER_g_szCoinName .. "\n"
      end
    end
  end
  return szMsg
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

local uiAword = Ui:GetClass("aword")

uiAword.GetAword = "GetAword"
uiAword.Information = "Information"
uiAword.pObj = "obj"
uiAword.AwordPicture = "AwordPicture"
uiAword.Close = "Close"
uiAword.nTimes = "nTimes"

function uiAword:OnOpen(nFlag)
  self:OnOpenEx()
  self:OnOpen1()
  self:OnOpen2(nFlag)
  self:OnOpen3()
end

function uiAword:OnOpenEx()
  SpecialEvent.tbAword:CheckFlag()
  local nNum = me.GetTask(2122, 5)
  if not tbAword.tbAword[1] then
    tbAword.tbAword[1] = {}
  end
  local tbAwordLogIn = tbAword.tbAword[1][nNum] or {}
  local szMsgEx = self:GetInformationEx(tbAwordLogIn)
  TxtEx_SetText(self.UIGROUP, self.Information, szMsgEx)
  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[1] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[1]
  end
  if #tbAwordLogIn <= 0 or nOpenFlag == 0 or SpecialEvent.tbAword.nOpenZaiXian == 0 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture, 1, tbAword.tbPicture[5])
    Wnd_SetEnable(self.UIGROUP, self.pObj, 0)
    ObjMx_Clear(self.UIGROUP, self.pObj)
    TxtEx_SetText(self.UIGROUP, self.Information, "您没有可以领取的奖励！")
    return
  end

  if me.GetTask(2122, 7) == 1 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture, 1, tbAword.tbPicture[5])
    Wnd_SetEnable(self.UIGROUP, self.pObj, 0)
    ObjMx_Clear(self.UIGROUP, self.pObj)
    TxtEx_SetText(self.UIGROUP, self.Information, "您已经领取过奖励了！")
    return
  end
  if #tbAwordLogIn > 1 or (#tbAwordLogIn == 1 and tbAwordLogIn[1][1] ~= 1) then
    if #tbAwordLogIn == 1 then
      Img_SetImage(self.UIGROUP, self.AwordPicture, 1, tbAword.tbPicture[tbAwordLogIn[1][1]])
    else
      Img_SetImage(self.UIGROUP, self.AwordPicture, 1, tbAword.tbPicture[5])
    end
    Wnd_SetEnable(self.UIGROUP, self.pObj, 0)
    Wnd_SetEnable(self.UIGROUP, self.nTimes, 0)
    ObjMx_Clear(self.UIGROUP, self.pObj)
    local szMsg = tbAword:GetTips(tbAwordLogIn, 1)
    szMsg = "您可获得：" .. szMsg
    Wnd_SetTip(self.UIGROUP, self.AwordPicture, szMsg)
  else
    Wnd_Visible(self.UIGROUP, self.AwordPicture, 0)
    local pItem = KItem.CreateTempItem(tbAwordLogIn[1][2][1], tbAwordLogIn[1][2][2], tbAwordLogIn[1][2][3], tbAwordLogIn[1][2][4], 0)
    if not pItem then
      Wnd_SetEnable(self.UIGROUP, self.GetAword, 0)
      Img_PlayAnimation(self.UIGROUP, self.GetAword, 0)
      return
    end
    ObjMx_AddObject(self.UIGROUP, self.pObj, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
    Txt_SetTxt(self.UIGROUP, self.nTimes, string.format("×%s", tbAwordLogIn[1][3]))
  end
  Img_PlayAnimation(self.UIGROUP, self.GetAword, 1, Env.GAME_FPS * 30, 0, 1)
end

function uiAword:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_BINDGOLD_SECTION))
  end
end

function uiAword:GetInformationEx(tbAwordLogIn)
  local nFlag = me.GetTask(2122, 7)
  if nFlag == 1 then
    return "\n今日登录奖励已经领取过了！"
  end
  local szMsg = tbAword:GetTips(tbAwordLogIn, 0)
  return "今日登录可以获得 <color=gold>" .. szMsg .. "<color>！打开后可随机获得一份礼物！"
end

function uiAword:OnButtonClick(szWnd, nParam)
  if szWnd == self.GetAword then
    me.CallServerScript({ "AwordDaily" })
  elseif szWnd == self.GetAword1 then
    me.CallServerScript({ "AwordLogIn" })
  elseif szWnd == self.GetAword2 then
    me.CallServerScript({ "AwordOnlineEx" })
  elseif szWnd == self.GetAword3 then
    me.CallServerScript({ "AwordUpLevel" })
  elseif szWnd == self.Close then
    UiManager:CloseWindow(Ui.UI_GETAWORD)
  end
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

uiAword.GetAword1 = "GetAword1"
uiAword.Information1 = "Information1"
uiAword.pObj1 = "obj1"
uiAword.AwordPicture1 = "AwordPicture1"
uiAword.nTimes1 = "nTimes1"

function uiAword:OnOpen1()
  SpecialEvent.tbAword:CheckFlag()
  local tbAwordLogInMonth = tbAword.tbAword[2] or {}
  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[2] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[2]
  end
  if #tbAwordLogInMonth <= 0 or nOpenFlag == 0 or SpecialEvent.tbAword.nOpenZaiXian == 0 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword1, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword1, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture1, 1, tbAword.tbPicture[5])
    ObjMx_Clear(self.UIGROUP, self.pObj1)
    Wnd_SetEnable(self.UIGROUP, self.pObj1, 0)
    TxtEx_SetText(self.UIGROUP, self.Information1, "您没有可以领取的奖励！")
    return
  end
  local nNum = me.GetTask(2122, 8)
  local tbAwordLogInMonthEx = tbAwordLogInMonth[nNum + 1] or {}
  if #tbAwordLogInMonthEx <= 0 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword1, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword1, 0)
    ObjMx_Clear(self.UIGROUP, self.pObj1)
    Wnd_SetEnable(self.UIGROUP, self.pObj1, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture1, 1, tbAword.tbPicture[5])
    TxtEx_SetText(self.UIGROUP, self.Information1, "您当月的累积奖励已经领取完了！")
    return
  end
  local szMsgEx = self:GetInformation1()
  TxtEx_SetText(self.UIGROUP, self.Information1, szMsgEx)
  if #tbAwordLogInMonthEx > 1 or (#tbAwordLogInMonthEx == 1 and tbAwordLogInMonthEx[1][1] ~= 1) then
    if #tbAwordLogInMonthEx == 1 then
      Img_SetImage(self.UIGROUP, self.AwordPicture1, 1, tbAword.tbPicture[tbAwordLogInMonthEx[1][1]])
    else
      Img_SetImage(self.UIGROUP, self.AwordPicture1, 1, tbAword.tbPicture[5])
    end
    Wnd_SetEnable(self.UIGROUP, self.pObj1, 0)
    Wnd_SetEnable(self.UIGROUP, self.nTimes1, 0)
    ObjMx_Clear(self.UIGROUP, self.pObj1)
    local szMsg = tbAword:GetTips(tbAwordLogInMonthEx, 1)
    szMsg = "您可获得：" .. szMsg
    Wnd_SetTip(self.UIGROUP, self.AwordPicture1, szMsg)
  else
    Wnd_Visible(self.UIGROUP, self.AwordPicture1, 0)
    local pItem = KItem.CreateTempItem(tbAwordLogInMonthEx[1][2][1], tbAwordLogInMonthEx[1][2][2], tbAwordLogInMonthEx[1][2][3], tbAwordLogInMonthEx[1][2][4], 0)
    if not pItem then
      Wnd_SetEnable(self.UIGROUP, self.GetAword1, 0)
      Img_PlayAnimation(self.UIGROUP, self.GetAword1, 0)
      return
    end
    ObjMx_AddObject(self.UIGROUP, self.pObj1, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
    Txt_SetTxt(self.UIGROUP, self.nTimes1, string.format("×%s", tbAwordLogInMonthEx[1][3]))
  end
  if SpecialEvent.tbAword.tbAword_Day[me.GetTask(2122, 8) + 1] > me.GetTask(2063, 20) then
    Wnd_SetEnable(self.UIGROUP, self.GetAword1, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword1, 0)
    return
  end
  Img_PlayAnimation(self.UIGROUP, self.GetAword1, 1, Env.GAME_FPS * 30, 0, 1)
end

function uiAword:GetInformation1()
  local nNowLoadTime = me.GetTask(2063, 20)
  local nNeedLoadTime = SpecialEvent.tbAword.tbAword_Day[me.GetTask(2122, 8) + 1]
  if nNeedLoadTime > nNowLoadTime then
    return string.format("您本月累积的每日登录为<color=gold> %s天，还有 %s天<color>可以领取该奖励（仅当月可领取）", nNowLoadTime, nNeedLoadTime - nNowLoadTime)
  else
    return string.format("您本月已经有<color=gold> %s天<color>登录，可以获得一份奖励（仅当月可领取）", nNeedLoadTime)
  end
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

uiAword.GetAword2 = "GetAword2"
uiAword.Information2 = "Information2"
uiAword.pObj2 = "obj2"
uiAword.AwordPicture2 = "AwordPicture2"
uiAword.nTimes2 = "nTimes2"

function uiAword:OnOpen2(nFlag)
  SpecialEvent.tbAword:CheckFlag()
  local tbAwordOnline = tbAword.tbAword[3] or {}
  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[3] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[3]
  end
  if #tbAwordOnline <= 0 or nOpenFlag == 0 or SpecialEvent.tbAword.nOpenZaiXian == 0 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword2, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword2, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture2, 1, tbAword.tbPicture[5])
    ObjMx_Clear(self.UIGROUP, self.pObj2)
    Wnd_SetEnable(self.UIGROUP, self.pObj2, 0)
    Txt_SetTxt(self.UIGROUP, self.Information2, "您没有可以领取的奖励！")
    return
  end
  local nNowTime = tonumber(GetLocalDate("%Y%m%d"))
  if (SpecialEvent.tbAword.nOpenTime ~= 0 and nNowTime < SpecialEvent.tbAword.nOpenTime) or (SpecialEvent.tbAword.nCloseTime ~= 0 and nNowTime > SpecialEvent.tbAword.nCloseTime) then
    Wnd_SetEnable(self.UIGROUP, self.GetAword2, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword2, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture2, 1, tbAword.tbPicture[5])
    ObjMx_Clear(self.UIGROUP, self.pObj2)
    Wnd_SetEnable(self.UIGROUP, self.pObj2, 0)
    Txt_SetTxt(self.UIGROUP, self.Information2, "今天并没有派送礼物！")
    return
  end
  local nNum = me.GetTask(2122, 9)
  local tbAwordOnlineEx = tbAwordOnline[nNum + 1] or {}
  if #tbAwordOnlineEx <= 0 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword2, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword2, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture2, 1, tbAword.tbPicture[5])
    ObjMx_Clear(self.UIGROUP, self.pObj2)
    Wnd_SetEnable(self.UIGROUP, self.pObj2, 0)
    Txt_SetTxt(self.UIGROUP, self.Information2, "\n今天的奖励已经领取完了！")
    return
  end
  local nNowTime = GetTime()
  if nNowTime - me.GetTask(2122, 11) < SpecialEvent.tbAword.tbAword_timer[nNum + 1] then
    if nFlag and nFlag == 1 then
      tbAword:OpenAwordOnlineTimer()
    end
    if not SpecialEvent.tbAword.nTimerIdRefresh then
      SpecialEvent.tbAword.nTimerIdRefresh = Timer:Register(Env.GAME_FPS, self.OnTimer, self)
    end
    Wnd_SetEnable(self.UIGROUP, self.GetAword2, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword2, 0)
  else
    local szMsg = string.format('恭喜您获得<color=gold>第%s份<color>礼物！点击"领取奖励"按钮领奖。领取后将进入下次领奖倒计时。', me.GetTask(2122, 9) + 1)
    Txt_SetTxt(self.UIGROUP, self.Information2, szMsg)
    Img_PlayAnimation(self.UIGROUP, self.GetAword2, 1, Env.GAME_FPS * 30, 0, 1)
  end
  if #tbAwordOnlineEx > 1 or (#tbAwordOnlineEx == 1 and tbAwordOnlineEx[1][1] ~= 1) then
    if #tbAwordOnlineEx == 1 then
      Img_SetImage(self.UIGROUP, self.AwordPicture2, 1, tbAword.tbPicture[tbAwordOnlineEx[1][1]])
    else
      Img_SetImage(self.UIGROUP, self.AwordPicture2, 1, tbAword.tbPicture[5])
    end
    Wnd_SetEnable(self.UIGROUP, self.pObj2, 0)
    Wnd_SetEnable(self.UIGROUP, self.nTimes2, 0)
    ObjMx_Clear(self.UIGROUP, self.pObj2)
    local szMsg = tbAword:GetTips(tbAwordOnlineEx, 1)
    szMsg = "您可获得：" .. szMsg
    Wnd_SetTip(self.UIGROUP, self.AwordPicture2, szMsg)
  else
    Wnd_Visible(self.UIGROUP, self.AwordPicture2, 0)
    local pItem = KItem.CreateTempItem(tbAwordOnlineEx[1][2][1], tbAwordOnlineEx[1][2][2], tbAwordOnlineEx[1][2][3], tbAwordOnlineEx[1][2][4], 0)
    if not pItem then
      Wnd_SetEnable(self.UIGROUP, self.GetAword2, 0)
      Img_PlayAnimation(self.UIGROUP, self.GetAword2, 0)
      return
    end
    ObjMx_AddObject(self.UIGROUP, self.pObj2, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
    Txt_SetTxt(self.UIGROUP, self.nTimes2, string.format("×%s", tbAwordOnlineEx[1][3]))
  end
end

function uiAword:OnTimer()
  local nNum = me.GetTask(2122, 9)
  local szMsgEx = self:GetInformation2()
  if not SpecialEvent.tbAword.tbAword_timer[nNum + 1] then
    SpecialEvent.tbAword.nTimerIdRefresh = nil
    return 0
  end
  Txt_SetTxt(self.UIGROUP, self.Information2, szMsgEx)
  if SpecialEvent.tbAword.nTimerRemain <= 0 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword2, 1)
  end
  return
end

function uiAword:GetInformation2()
  if SpecialEvent.tbAword.nTimerRemain <= 0 then
    return string.format('恭喜您获得<color=gold>第%s份<color>礼物！点击"领取奖励"按钮领奖。领取后将进入下次领奖倒计时。', me.GetTask(2122, 9) + 1)
  else
    return string.format("您即将获得<color=gold>第%s份<color>礼物！距离领奖还差<color=green> %s<color>", me.GetTask(2122, 9) + 1, self:ChangeTimer())
  end
end

function uiAword:ChangeTimer()
  local szMsg = ""
  local nHour, nMinute, nSecond = Lib:TransferSecond2NormalTime(SpecialEvent.tbAword.nTimerRemain)
  if nMinute < 10 then
    szMsg = szMsg .. string.format("0%s", nMinute)
  else
    szMsg = szMsg .. string.format("%s", nMinute)
  end
  if nSecond < 10 then
    szMsg = szMsg .. string.format(":0%s", nSecond)
  else
    szMsg = szMsg .. string.format(":%s", nSecond)
  end
  return szMsg
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

uiAword.GetAword3 = "GetAword3"
uiAword.Information3 = "Information3"
uiAword.pObj3 = "obj3"
uiAword.AwordPicture3 = "AwordPicture3"
uiAword.nTimes3 = "nTimes3"

function uiAword:OnOpen3()
  SpecialEvent.tbAword:CheckFlag()
  local tbAwordUpLevel = tbAword.tbAword[4] or {}
  local nOpenFlag = 1
  if SpecialEvent.tbAword.tbOpenFlag and SpecialEvent.tbAword.tbOpenFlag[4] then
    nOpenFlag = SpecialEvent.tbAword.tbOpenFlag[4]
  end
  if #tbAwordUpLevel <= 0 or nOpenFlag == 0 or SpecialEvent.tbAword.nOpenZaiXian == 0 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword3, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword3, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture3, 1, tbAword.tbPicture[5])
    ObjMx_Clear(self.UIGROUP, self.pObj3)
    Wnd_SetEnable(self.UIGROUP, self.pObj3, 0)
    TxtEx_SetText(self.UIGROUP, self.Information3, "您没有可以领取的奖励！")
    return
  end
  local nNum = me.GetTask(2034, 10)
  if nNum == 0 then
    nNum = 1
  end
  local tbAwordUpLevelEx = tbAwordUpLevel[nNum] or {}
  if #tbAwordUpLevelEx <= 0 then
    Wnd_SetEnable(self.UIGROUP, self.GetAword3, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword3, 0)
    Img_SetImage(self.UIGROUP, self.AwordPicture3, 1, tbAword.tbPicture[5])
    ObjMx_Clear(self.UIGROUP, self.pObj3)
    Wnd_SetEnable(self.UIGROUP, self.pObj3, 0)
    TxtEx_SetText(self.UIGROUP, self.Information3, "您已经领完了所有礼物！")
    return
  end
  if tbAwordUpLevelEx[1][8] > me.nLevel then
    Wnd_SetEnable(self.UIGROUP, self.GetAword3, 0)
    Img_PlayAnimation(self.UIGROUP, self.GetAword3, 0)
    TxtEx_SetText(self.UIGROUP, self.Information3, string.format("当您升到 <color=gold>%s级<color>，可以得到一份丰厚的奖励！", tbAwordUpLevelEx[1][8]))
  else
    Img_PlayAnimation(self.UIGROUP, self.GetAword3, 1, Env.GAME_FPS * 30, 0, 1)
    TxtEx_SetText(self.UIGROUP, self.Information3, string.format("您已经达到 <color=gold>%s级<color>，可以得到一份丰厚的奖励！", tbAwordUpLevelEx[1][8]))
  end
  if #tbAwordUpLevelEx > 1 or (#tbAwordUpLevelEx == 1 and tbAwordUpLevelEx[1][1] ~= 1) then
    if #tbAwordUpLevelEx == 1 then
      Img_SetImage(self.UIGROUP, self.AwordPicture3, 1, tbAword.tbPicture[tbAwordUpLevelEx[1][1]])
    else
      Img_SetImage(self.UIGROUP, self.AwordPicture3, 1, tbAword.tbPicture[5])
    end
    Wnd_SetEnable(self.UIGROUP, self.pObj3, 0)
    Wnd_SetEnable(self.UIGROUP, self.nTimes3, 0)
    ObjMx_Clear(self.UIGROUP, self.pObj3)
    local szMsg = tbAword:GetTips(tbAwordUpLevelEx, 1)
    szMsg = "您可获得：" .. szMsg
    Wnd_SetTip(self.UIGROUP, self.AwordPicture3, szMsg)
  else
    Wnd_Visible(self.UIGROUP, self.AwordPicture3, 0)
    local pItem = KItem.CreateTempItem(tbAwordUpLevelEx[1][2][1], tbAwordUpLevelEx[1][2][2], tbAwordUpLevelEx[1][2][3], tbAwordUpLevelEx[1][2][4], 0)
    if not pItem then
      Wnd_SetEnable(self.UIGROUP, self.GetAword3, 0)
      Img_PlayAnimation(self.UIGROUP, self.GetAword3, 0)
      return
    end
    ObjMx_AddObject(self.UIGROUP, self.pObj3, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
    Txt_SetTxt(self.UIGROUP, self.nTimes3, string.format("×%s", tbAwordUpLevelEx[1][3]))
  end
end
