-- 文件名　：playerpray.lua
-- 创建者　：zhouchenfei
-- 创建时间：2008-09-02 15:59:24

local uiPlayerPray = Ui:GetClass("playerpray")
local tbTimer = Ui.tbLogic.tbTimer

uiPlayerPray.TXT_PRYAWORDS = "TxtElementSay" -- 祈福结果标题
uiPlayerPray.TXT_ELERESULT = "TxtElementResult" -- 祈福结果
uiPlayerPray.TXT_ELEEFFECTTITLE = "TxtEffectTitle" -- 祈福效果标题
uiPlayerPray.TXTEX_PRAYEFFECT = "TxtExEffect" -- 祈福效果文字
uiPlayerPray.TXT_AWARDTITLE = "TxtAwardTitle" -- 祈福奖励标题
uiPlayerPray.TXTEX_AWARD = "TxtExAward" -- 祈福奖励
uiPlayerPray.TXTEX_AWARD1 = "TxtExAward1"
uiPlayerPray.TXTEX_AWARD2 = "TxtExAward2"
uiPlayerPray.TXTEX_AWARD3 = "TxtExAward3"
uiPlayerPray.BTN_CLOSE = "BtnClose" -- 关闭祈福界面
uiPlayerPray.BTN_CONTROL = "BtnControlPray" -- 控制开始祈福和停止转盘
uiPlayerPray.BTN_GETAWARD = "BtnGetAward" -- 领取奖励按钮
uiPlayerPray.IMG_MOVEHAND = "ImgMoveHand" -- 运动针
uiPlayerPray.IMG_PLATE = "ImgPlate" -- 祈福底盘
uiPlayerPray.TXT_PRAYTIMES = "TxtPrayTimes" -- 祈福剩余次数
uiPlayerPray.TXT_PRAYRESULTINTRODUCE = "TxtPrayResultIntroduce" -- 祈福结果说明					--

-- 祈福效果图标
uiPlayerPray.IMG_AWARD_MONEY = "\\image\\icon\\task\\prize_money.spr" -- 钱
uiPlayerPray.IMG_AWARD_EXP = "\\image\\icon\\task\\prize_expens.spr" -- 经验
uiPlayerPray.IMG_AWARD_EFFECT = "\\image\\icon\\task\\prize_energy.spr" -- 效果buf
uiPlayerPray.IMG_AWARD_PLAYERTITLE = "\\image\\icon\\task\\prize_name.spr"
uiPlayerPray.IMG_AWARD_REPUTE = "\\image\\icon\\task\\prize_repute.spr" -- 奖励声望

uiPlayerPray.tbAwardImg = {
  ["money"] = uiPlayerPray.IMG_AWARD_MONEY,
  ["exp"] = uiPlayerPray.IMG_AWARD_EXP,
  ["effect"] = uiPlayerPray.IMG_AWARD_EFFECT,
  ["playertitle"] = uiPlayerPray.IMG_AWARD_PLAYERTITLE,
  ["repute"] = uiPlayerPray.IMG_AWARD_REPUTE,
}

uiPlayerPray.MAXFRAME = 36 -- 指针有36帧
uiPlayerPray.FLAG_HANDMOVE = 0 -- 标识指针运动状态
uiPlayerPray.NORMALSPEED = 7 -- 指针最快速度是每帧画7帧
uiPlayerPray.nEndPoint = 0 -- 结束帧的位置

uiPlayerPray.ELEMENTNAME = { "<color=orange>金<color>", "<color=green>木<color>", "<color=blue>水<color>", "<color=salmon>火<color>", "<color=wheat>土<color>" }

function uiPlayerPray:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_CONTROL then -- 控制
    self:SetHandMoveState()
  elseif szWnd == self.BTN_GETAWARD then
    me.CallServerScript({ "ApplyGetPrayAward" })
  end
end

function uiPlayerPray:OnOpen()
  self.nTimer_HandMoveId = 0
  self.nTimer_StopDelayId = 0
  self.nMoveTime = 0
  self.nPlateFrame = 0
  self.FLAG_HANDMOVE = 0
  self.nNowSpeed = 0
  self.nSlowStep = 0
  self.nNowFrame = 0
  self.nMaxSlowStep = 0
  self.tbSlowTime = {}
  self:UpdateWnd()
  self:UpdateButton()
  self:UpdateControlButtonTxt()
end

-- 更新窗口文字内容
function uiPlayerPray:UpdateWnd()
  local szTxt = ""
  local tbElement = {}

  self.nNowFrame = self.nEndPoint
  Img_SetFrame(self.UIGROUP, self.IMG_MOVEHAND, self.nNowFrame)
  if self.nNowFrame > 0 then
    self:SetPlateFrame(self.nNowFrame)
  end

  local tbElement = {}
  for i = 1, 5 do
    tbElement[#tbElement + 1] = Task.tbPlayerPray:GetPrayElement(me, i)
  end

  -- 设置祈福结果文字
  for i = 1, 5 do
    local nElement = Task.tbPlayerPray:GetPrayElement(me, i)
    if nElement <= 0 then
      break
    end
    if UiVerion == Ui.Version001 then
      szTxt = szTxt .. self.ELEMENTNAME[nElement] .. "  "
    else
      szTxt = szTxt .. self.ELEMENTNAME[nElement] .. " "
    end
  end

  -- 祈福奖励
  local tbAward = Task.tbPlayerPray:GetAward(me, tbElement)
  local szAwardTxt = ""
  local szTitle = ""
  local nAwardIndex = 0
  for i = 1, 3 do
    TxtEx_SetText(self.UIGROUP, self.TXTEX_AWARD .. i, " ")
  end
  for i = 1, #tbAward do
    if tbAward[i].szType == "item" then
      local tbValue = Lib:SplitStr(tbAward[i].szAward, ",")
      local szItem = ""
      for i = 1, #tbValue do
        if i > 1 then
          szItem = szItem .. ","
        end
        szItem = szItem .. tbValue[i]
      end
      szAwardTxt = string.format("<item=%s>", szItem)
      nAwardIndex = nAwardIndex + 1
      if nAwardIndex <= 3 then
        TxtEx_SetText(self.UIGROUP, self.TXTEX_AWARD .. nAwardIndex, szAwardTxt)
      end
    elseif tbAward[i].szType == "exp" or tbAward[i].szType == "money" then
      local tbValue = Lib:SplitStr(tbAward[i].szAward, ",")
      local szMsg = ""
      if tbAward[i].szType == "exp" then
        szMsg = "经验"
      elseif tbAward[i].szType == "money" then
        szMsg = "银两"
      elseif tbAward[i].szType == "repute" then
        szMsg = "声望"
      end
      szAwardTxt = string.format("<a=award:%s><pic=%s><a>", tbValue[1] .. szMsg, self.tbAwardImg[tbAward[i].szType])
      nAwardIndex = nAwardIndex + 1
      TxtEx_SetText(self.UIGROUP, self.TXTEX_AWARD .. nAwardIndex, szAwardTxt)
    elseif tbAward[i].szType == "playertitle" then
      local tbValue = Lib:SplitStr(tbAward[i].szAward, ",")
      local nSex = tonumber(tbValue[5])
      tbValue[5] = nil
      if nSex == 2 then
        szTitle = szTitle .. "获得一个新称号\n"
      elseif nSex == me.nSex then
        szTitle = szTitle .. "获得一个新称号\n"
      end
    elseif tbAward[i].szType == "repute" then
      local tbValue = Lib:SplitStr(tbAward[i].szAward, ",")
      szTitle = szTitle .. string.format("获得%s点声望\n", tbValue[3])
    end
  end

  -- 祈福效果
  local szEffect = ""
  local tbEffect = Task.tbPlayerPray:GetEffect(me, tbElement)
  if #tbEffect > 0 or szTitle ~= "" then
    local szTip = ""
    for i = 1, #tbEffect do
      local tbValue = Lib:SplitStr(tbEffect[i].szAward, ",")
      local nLevel = tonumber(tbValue[2])
      local szSkillName = KFightSkill.GetSkillName(tonumber(tbValue[1])) .. string.format("[%d级]", nLevel)
      local nOrgTime = tonumber(tbValue[4])
      local nHour = (nOrgTime / 18) / 3600
      local nMin = ((nOrgTime / 18) - nHour * 3600) / 60
      local szTime = "持续时间: "
      if nHour > 0 then
        szTime = szTime .. string.format("%d 小时", nHour)
      end

      if nMin > 0 then
        szTime = szTime .. string.format("%d 分钟", nMin)
      end
      szTip = szTip .. szSkillName .. "\n" .. szTime .. "\n"
    end
    if string.len(szTitle) > 0 then
      szTip = szTip .. szTitle .. "说明：祈福效果不与药品及修炼珠状态叠加\n"
    end
    if string.len(szTip) > 0 then
      szEffect = string.format("<a=award:%s><pic=%s><a>", szTip, self.IMG_AWARD_EFFECT)
    end
  end
  TxtEx_SetText(self.UIGROUP, self.TXTEX_PRAYEFFECT, szEffect)

  local tbWords = Task.tbPlayerPray:GetPrayWords(me, tbElement)
  if UiVersion == Ui.Version002 then
    Txt_SetTxt(self.UIGROUP, self.TXT_PRAYRESULTINTRODUCE, tbWords.szPrayWords)
    Txt_SetTxt(self.UIGROUP, self.TXT_PRYAWORDS, tbWords.szPrayThing)
  elseif UiVersion == Ui.Version001 then
    local szWords = "    " .. tbWords.szPrayWords .. "\n" .. "\r<color=170,230,130>今日事宜<color>\r    " .. tbWords.szPrayThing .. "\n "
    Txt_SetTxt(self.UIGROUP, self.TXT_PRYAWORDS, szWords)
  end
  if #tbAward <= 0 and #tbEffect <= 0 then
    szTxt = szTxt .. " ？"
  end
  szTxt = szTxt .. "\n"
  Txt_SetTxt(self.UIGROUP, self.TXT_ELERESULT, szTxt)

  -- by zhangjinpin@kingsoft
  Txt_SetTxt(self.UIGROUP, self.TXT_PRAYTIMES, string.format("祈福次数(%s)", Task.tbPlayerPray:GetPrayCount(me)))
end

-- 更新按钮状态
function uiPlayerPray:UpdateButton()
  -- 没有祈福机会，或者有直接领取的奖励，没领
  if 0 < Task.tbPlayerPray:CheckAllowPray(me) then
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONTROL, 0)
    Btn_Check(self.UIGROUP, self.BTN_CONTROL, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONTROL, 1)
    Btn_Check(self.UIGROUP, self.BTN_CONTROL, 0)
  end

  local nAwardFlag = Task.tbPlayerPray:CheckAllowGetAward(me)
  -- 返回2表示背包空间不足，这个由服务端去做判断
  if 0 < nAwardFlag and nAwardFlag ~= 2 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETAWARD, 0)
    Btn_Check(self.UIGROUP, self.BTN_GETAWARD, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETAWARD, 1)
    Btn_Check(self.UIGROUP, self.BTN_GETAWARD, 0)
  end
end

-- 更新控制按钮文字
function uiPlayerPray:UpdateControlButtonTxt()
  local nAllElement = me.GetTask(Task.tbPlayerPray.TSKGROUP, Task.tbPlayerPray.TSK_SAVEELEMENT)
  local szMsg = ""
  if self.FLAG_HANDMOVE == 1 then
    szMsg = "停止"
  else
    local nPrayFlag = Task.tbPlayerPray:CheckAllowPray(me)
    if nPrayFlag == 0 then
      szMsg = "开始祈福"
      local tbElement = self:GetPrayResultElement()
      local tbAward = Task.tbPlayerPray:GetAward(me, tbElement)
      local nInDirFlag = me.GetTask(Task.tbPlayerPray.TSKGROUP, Task.tbPlayerPray.TSK_INDIRAWARDFLAG)
      if #tbAward <= 0 then
        if nAllElement > 0 then
          szMsg = "继续祈福"
        end
      else
        if nInDirFlag >= 1 then
          szMsg = "祈福结束"
        end
      end
    elseif nPrayFlag > 0 then
      szMsg = "祈福结束"
    end
  end
  Btn_SetTxt(self.UIGROUP, self.BTN_CONTROL, szMsg)
end

-- 设置运动针的状态
function uiPlayerPray:SetHandMoveState()
  if self.FLAG_HANDMOVE == 0 then -- 原来是不动的
    self:StartHandMove()
    self.FLAG_HANDMOVE = 1
    self:UpdateControlButtonTxt()
  elseif self.FLAG_HANDMOVE == 1 then -- 原来是动的
    Wnd_SetEnable(self.UIGROUP, self.BTN_CONTROL, 0)
    Btn_Check(self.UIGROUP, self.BTN_CONTROL, 0)
    me.CallServerScript({ "PlayerPrayCmd" })
  end
end

-- 开始转动
function uiPlayerPray:StartHandMove()
  if self.nTimer_HandMoveId <= 0 then
    self.nMoveTime = 1
    self.nNowSpeed = self.NORMALSPEED
    self.nTimer_HandMoveId = tbTimer:Register(self.nMoveTime, self.OnTimer_HandMove, self)
  end
end

-- 停止转动
function uiPlayerPray:StopHandMove()
  if self.nTimer_HandMoveId and self.nTimer_HandMoveId > 0 then
    tbTimer:Close(self.nTimer_HandMoveId)
    self.nTimer_HandMoveId = 0
  end
  self.nNowSpeed = 0
end

function uiPlayerPray:OnClose()
  self:StopHandMove()
  if self.nTimer_StopDelayId and self.nTimer_StopDelayId > 0 then
    tbTimer:Close(self.nTimer_StopDelayId)
    self.nTimer_StopDelayId = 0
  end
end

function uiPlayerPray:OnTimer_HandMove()
  self:SetHandFrame(self.nNowSpeed)
  return self.nMoveTime
end

function uiPlayerPray:OnTime_DelayStop()
  self.nSlowStep = self.nSlowStep + 1
  if self.nSlowStep <= self.nMaxSlowStep then
    if self.tbSlowTime[self.nSlowStep] then
      if (self.nSlowStep - 1) == 1 then
        self.nNowFrame = self.tbSlowTime[1][3]
      end
      self.nNowSpeed = self.tbSlowTime[self.nSlowStep][1]
      return self.tbSlowTime[self.nSlowStep][2]
    end
  end
  self:StopHandMove()
  Img_SetFrame(self.UIGROUP, self.IMG_MOVEHAND, self.nEndPoint)
  self:SetPlateFrame(self.nEndPoint)
  self.nNowFrame = self.nEndPoint
  self:UpdateButton()
  self:UpdateWnd()
  self.FLAG_HANDMOVE = 0
  self.tbSlowTime = {}
  self.nSlowStep = 0
  self.nMaxSlowStep = 0
  self.nTimer_StopDelayId = 0
  self:UpdateControlButtonTxt()

  return 0
end

-- 设置针的位置
function uiPlayerPray:SetHandFrame(nCount)
  self.nNowFrame = self.nNowFrame + nCount
  if self.nNowFrame > self.MAXFRAME then
    self.nNowFrame = self.nNowFrame - self.MAXFRAME
  end
  Img_SetFrame(self.UIGROUP, self.IMG_MOVEHAND, self.nNowFrame)
  self:SetPlateFrame(self.nNowFrame)
end

-- 设置底盘的位置
function uiPlayerPray:SetPlateFrame(nNowFrame)
  local nPlateFrame = math.floor((nNowFrame - 1) / 7) + 1
  if nPlateFrame > 6 then
    nPlateFrame = 1
  end
  Img_SetFrame(self.UIGROUP, self.IMG_PLATE, nPlateFrame)
end

-- 接收到服务端发送结果的消息
function uiPlayerPray:OnRecPrayResult(nEleResult)
  local nTotalFrame = self.MAXFRAME
  local nNowFrame = self.nNowFrame
  local nElePonit = Random(math.floor(nTotalFrame / 5)) + 1
  local nResultPoint = (nEleResult - 1) * math.floor(nTotalFrame / 5) + nElePonit
  self.nEndPoint = nResultPoint
  self.tbSlowTime = self:CaculateTime(nNowFrame, nResultPoint)
  self.nSlowStep = 1
  self.nTimer_StopDelayId = tbTimer:Register(self.tbSlowTime[self.nSlowStep][2], self.OnTime_DelayStop, self)
end

-- 获取五行元素
function uiPlayerPray:GetPrayResultElement()
  local nAllElement = me.GetTask(Task.tbPlayerPray.TSKGROUP, Task.tbPlayerPray.TSK_SAVEELEMENT)
  local tbElement = {}
  for i = 1, 5 do
    tbElement[#tbElement + 1] = Task.tbPlayerPray:GetPrayElement(me, i)
  end
  return tbElement
end

function uiPlayerPray:Link_award_GetTip(szWnd, szMsg)
  return szMsg
end

function uiPlayerPray:OnUpdatePrayState()
  self:UpdateWnd()
  self:UpdateButton()
  self:UpdateControlButtonTxt()
end

-- 根据其实针位置和末尾针位置估算停止的时间返回的时间单位是帧
function uiPlayerPray:CaculateTime(nBeginPoint, nEndPoint)
  local tbSlowTime = {
    { self.NORMALSPEED, 1 },
    { 4, 6 },
    { 3, 8 },
    { 2, 8 },
    { 1, 16 },
  }
  local nNeedMoveFrame = (self.MAXFRAME - nBeginPoint) + nEndPoint + 4 * self.MAXFRAME - 80
  local nNormalSpeedTime = math.floor(nNeedMoveFrame / self.NORMALSPEED)
  tbSlowTime[1][2] = nNormalSpeedTime
  tbSlowTime[1][3] = math.fmod(nBeginPoint + nNeedMoveFrame, self.MAXFRAME)
  self.nMaxSlowStep = #tbSlowTime
  return tbSlowTime
end
