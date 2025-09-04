local uiFuliTequan = Ui:GetClass("fulitequan")

uiFuliTequan.PRG_MONTHPAY = "PrgMonthPay"
uiFuliTequan.PRG_MONTHCONSUME = "PrgMonthConsume"
uiFuliTequan.TXT_MONTHPAYINFO = "TxtMonthPayInfo"
uiFuliTequan.TXT_MONTHCONSUMEINFO = "TxtMonthConsumeInfo"
uiFuliTequan.TXX_CONSUMEINFO = "TxtExConsumeInfo"
uiFuliTequan.BTN_SCORESHOP = "BtnScoreShop"
uiFuliTequan.BTN_QUIKPAY = "BtnQuickPay"
uiFuliTequan.BTN_CHOUJIANG = "BtnChoujiang"
uiFuliTequan.BTN_CLOSE = "BtnClose"
uiFuliTequan.PAGE_MAINSET = "PageSetMain"
uiFuliTequan.PAGE_PAYINFO = "PagePayInfo"
uiFuliTequan.TXT_FULI = "TxtFuli"
uiFuliTequan.TXT_CONDITION = "TxtCondition"
uiFuliTequan.TXT_STATE = "TxtState"
uiFuliTequan.BTN_GET = "BtnGet"
uiFuliTequan.TXT_FULIINFO = "TxtFuliInfo"
uiFuliTequan.BTN_OPEN_PAYAWARD = "BtnOpenPayAward"
uiFuliTequan.BTN_GETLOTTORY = "BtnGetLottoryAward"
uiFuliTequan.BTN_PAGE_LOTTORY = "BtnNewLottory"
uiFuliTequan.TXT_LOTTORY_NEWS = "TxtLottoryNews"
uiFuliTequan.TXT_MY_LOTTORY_INFO = "TxtMyAwardInfo"
uiFuliTequan.BTN_ONLINE_BANK_PAY = "BtnOnlineBankPay"

uiFuliTequan.tbFuliInfo = {
  -- 更新状态函数，按钮点击响应函数
  [1] = { "UpdateFuli_Fudai" },
  [2] = { "UpdateFuli_GetCai" },
  [3] = { "UpdateFuli_GetXiulianTimes" },
  [4] = { "UpdateFuli_GetPrayTimes" },
  [5] = { "UpdateFuli_Remote1" },
  [6] = { "UpdateFuli_Remote2" },
  [7] = { "UpdateFuli_JingHuo" },
  [8] = { "UpdateFuli_JingHuo" },
  [9] = { "UpdateFuli_Prestige" },
  [10] = { "UpdateFuli_CoinExchange" },
  [11] = { "UpdateFuli_GetWage" },
  [12] = { "UpdateFuli_GetQiankunfu" },
  [13] = { "UpdateFuli_GetChuansong" },
  [14] = { "UpdateFuli_UpdateKinWage" },
}

uiFuliTequan.tbLottoryItem = {
  [1] = { -- 开放150级以前
    szName = "未开放150级上限服务器",
    tbData = {
      [1] = {
        szImage = "\\image\\item\\huodong\\yueguihua.spr",
        szName = "广寒月桂花50个",
      },
      [2] = {
        szImage = "\\image\\icon\\task\\prize_money.spr",
        szName = "50000绑金",
      },
      [3] = {
        szImage = "\\image\\item\\huodong\\vn_wuguohuangjin.spr",
        szName = "幸运抽奖铜奖章",
      },
    },
    szTongDesc = "开启后可获得秘境套装(大)1个、六韬辑注1个、五行魂石600个、绑定金币其中一种",
  },
  [2] = { -- 开放150级以后
    szName = "已开放150级上限服务器",
    tbData = {
      [1] = {
        szImage = "\\image\\item\\huodong\\dragonmoney.spr",
        szName = "游龙古币10000枚",
      },
      [2] = {
        szImage = "\\image\\item\\other\\scriptitem\\partner_chongsheng.spr",
        szName = "30000绑金<enter>1个菩提果",
      },
      [3] = {
        szImage = "\\image\\item\\huodong\\vn_wuguohuangjin.spr",
        szName = "幸运抽奖铜奖章",
      },
    },
    szTongDesc = "开启后可获得秘境套装(大)1个、特别的精魄5个、战书·游龙密室15个、穿珠银帖5个、绑定金币的其中一种",
  },
}

function uiFuliTequan:Init()
  self.nMonthPay = 0 -- 本月充值
  self.nMonthConsume = 0 -- 本月消耗积分
  self.nPrestigeActive = 0 -- 充值领威望是否激活
  self.nPrestigeRank = 0 -- 威望排名
  self.nWageWeek = 0 -- 当前服务器周数
  self.nTimerRefresh = nil -- 定时刷新器
  self.nOpenDay = 0 -- 开启界面月份
  self.nKinWageActive = 0 --本月家族工资特权是否激活
end

function uiFuliTequan:PreOpen(nOpenFlag, nPay, nConsume, nPrestigeActive, nPrestigeRank, nWageWeek, nKinWageActive)
  if not nOpenFlag or nOpenFlag == 0 then
    me.CallServerScript({ "PlayerCmd", "OpenFuliTequan", 1 })
    return 0
  end
  return 1
end

function uiFuliTequan:OnOpen(nOpenFlag, nPay, nConsume, nPrestigeActive, nPrestigeRank, nWageWeek, nKinWageActive)
  self.nOpenDay = Lib:GetLocalDay()
  self.nMonthPay = nPay or self.nMonthPay
  self.nMonthConsume = nConsume or self.nMonthConsume
  self.nPrestigeActive = nPrestigeActive or self.nPrestigeActive
  self.nPrestigeRank = nPrestigeRank or self.nPrestigeRank
  self.nWageWeek = nWageWeek or self.nWageWeek
  self.nKinWageActive = nWageWeek or self.nKinWageActive
  PgSet_ActivePage(self.UIGROUP, self.PAGE_MAINSET, self.PAGE_PAYINFO)
  self:Refresh()
  if self.nTimerRefresh then
    Timer:Close(self.nTimerRefresh)
    self.nTimerRefresh = nil
  end
  self.nTimerRefresh = Timer:Register(18, self.OnTimer_Refresh, self)
end

function uiFuliTequan:OnClose()
  if self.nTimerRefresh then
    Timer:Close(self.nTimerRefresh)
    self.nTimerRefresh = nil
  end
end

function uiFuliTequan:Refresh()
  Txt_SetTxt(self.UIGROUP, self.TXT_MONTHPAYINFO, string.format("<color=253,223,8>%s<color>元（1元=100金币）", self.nMonthPay))
  Txt_SetTxt(self.UIGROUP, self.TXT_MONTHCONSUMEINFO, string.format("<color=253,223,8>%s<color>积分", self.nMonthConsume))
  self:UpdateProgress()
  self:UpdateFuliInfoPage()
  local szMsg = "初级福利"
  if self.nMonthPay >= 100 then
    szMsg = "高级福利和高级特权"
  elseif self.nMonthPay >= 50 then
    szMsg = "高级福利和中级特权"
  elseif self.nMonthPay >= 15 then
    szMsg = "中级福利和初级特权"
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_FULIINFO, string.format("您本月充值累计为<color=224,181,100>%s<color>元，正在享受<color=224,181,100>%s<color>，当前江湖威望为<color=224,181,100>%s<color>点。", self.nMonthPay, szMsg, me.nPrestige))
end

function uiFuliTequan:Update(nPay, nConsume, nPrestigeActive, nPrestigeRank, nWageWeek)
  if UiManager:WindowVisible(Ui.UI_FULITEQUAN) ~= 1 then
    return 0
  end
  self.nMonthPay = nPay or self.nMonthPay
  self.nMonthConsume = nConsume or self.nMonthConsume
  self.nPrestigeActive = nPrestigeActive or self.nPrestigeActive
  self.nPrestigeRank = nPrestigeRank or self.nPrestigeRank
  self.nWageWeek = nWageWeek or self.nWageWeek
  self.nOpenDay = Lib:GetLocalDay()
  self:Refresh()
end

function uiFuliTequan:OnTimer_Refresh()
  if UiManager:WindowVisible(Ui.UI_FULITEQUAN) ~= 1 then
    return 0
  end
  local nDay = Lib:GetLocalDay()
  if nDay > self.nOpenDay then
    me.CallServerScript({ "PlayerCmd", "OpenFuliTequan", 0 })
  else
    self:Refresh()
  end
  self:UpdateLottoryInfo()
  return
end

function uiFuliTequan:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SCORESHOP then
    UiManager:CloseWindow(self.UIGROUP)
    if UiManager:WindowVisible(Ui.UI_IBSHOP) ~= 1 then
      UiManager:OpenWindow(Ui.UI_IBSHOP)
      Ui(Ui.UI_IBSHOP):OnButtonClick("BtnIntegralSection", 1)
    end
  elseif szWnd == self.BTN_QUIKPAY then
    self:OpenQuikPay()
  elseif szWnd == self.BTN_CHOUJIANG then
    OpenWebSite("http://jxsj.xoyo.com/zt/2011/05/04/index.shtml")
  elseif szWnd == self.BTN_OPEN_PAYAWARD then
    me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_OPEN_WND })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_GETLOTTORY then
    me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_LOTTORY })
  elseif szWnd == self.BTN_PAGE_LOTTORY then
    self:UpdateLottoryInfo()
  elseif szWnd == self.BTN_ONLINE_BANK_PAY then
    self:OpenOnlineBankPayDialog()
  else
    if string.sub(szWnd, 1, 6) == self.BTN_GET then
      local nIndex = tonumber(string.sub(szWnd, 7, string.len(szWnd)))
      if not self.tbFuliInfo[nIndex] or not self.tbFuliInfo[nIndex][2] then
        return
      end
      local nSit = string.find(self.tbFuliInfo[nIndex][2], ":")
      if nSit and nSit > 0 then
        local szFlag = string.sub(self.tbFuliInfo[nIndex][2], 1, nSit - 1)
        local szContent = string.sub(self.tbFuliInfo[nIndex][2], nSit + 1, string.len(self.tbFuliInfo[nIndex][2]))
        local fncExcute = self[szFlag]
        if fncExcute then
          fncExcute(self, szContent) -- 参数由执行函数解析
        end
      end
    end
  end
end

function uiFuliTequan:UpdateLottoryInfo()
  local tbAwardName = {
    [1] = "<color=249,246,19>金奖<color>",
    [2] = "<color=255,255,255>银奖<color>",
    [3] = "<color=190,109,3>铜奖<color>",
  }

  local szDyNewsId = Task.tbHelp.NEWSKEYID.NEWS_LOTTERY_0909
  local tbNewsInfo = Task.tbHelp.tbNewsList[szDyNewsId]

  local szMsg = ""

  if tbNewsInfo and tbNewsInfo.nEndTime > GetTime() then
    szMsg = tbNewsInfo.szMsg .. "<enter>"
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_LOTTORY_NEWS, szMsg)

  local tbNewsData = Task.tbHelp.tbLottoryData or {}

  local tbAwardList = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
  }

  for nDate, tbAward in pairs(tbNewsData) do
    for nAward, nNum in pairs(tbAward) do
      tbAwardList[nAward] = tbAwardList[nAward] + nNum
    end
  end

  szMsg = "恭喜你获得了"
  local nFlag = 0
  local nGetFlag = 0
  for nAward, nNum in pairs(tbAwardList) do
    if nNum > 0 then
      if nFlag > 0 then
        szMsg = szMsg .. "，"
      end
      szMsg = szMsg .. string.format("%s个%s", nNum, tbAwardName[nAward])
      nFlag = 1
      nGetFlag = 1
    end
  end

  if nGetFlag == 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETLOTTORY, 1)
    Txt_SetTxt(self.UIGROUP, self.TXT_MY_LOTTORY_INFO, szMsg)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETLOTTORY, 0)
    Txt_SetTxt(self.UIGROUP, self.TXT_MY_LOTTORY_INFO, "")
  end
end

function uiFuliTequan:UpdateProgress(nPay, nConsume)
  local nPrgPos = 0
  local nTotalLen = 1000
  local nLastLen = nTotalLen

  local tbKedu = {
    [1] = 15,
    [2] = 50,
    [3] = 100,
    [4] = 188,
    [5] = 588,
    [6] = 988,
    [7] = 4988,
  }
  local nPreMoney = 0
  local nAllLen = 0
  for i, nMoney in ipairs(tbKedu) do
    if nMoney >= self.nMonthPay then
      local nLen = nLastLen / 3
      if nMoney == 4988 then
        nLen = nLastLen
      end
      nPrgPos = nAllLen + math.floor(((self.nMonthPay - nPreMoney) / (nMoney - nPreMoney)) * nLen)
      break
    end
    nAllLen = nAllLen + nLastLen / 3
    nLastLen = nLastLen / 3 * 2
    nPreMoney = nMoney
  end

  if self.nMonthPay > 4988 then
    nPrgPos = 1000
  end

  Prg_SetPos(self.UIGROUP, self.PRG_MONTHPAY, nPrgPos)
  Prg_SetPos(self.UIGROUP, self.PRG_MONTHCONSUME, self.nMonthConsume / 60000 * 1000)
end

function uiFuliTequan:Link_infor_OnClick(szWnd, szLinkData)
  me.CallServerScript({ "ApplyConsumeScores" })
end

function uiFuliTequan:OpenConsumeUrl()
  OpenWebSite("http://zt.xoyo.com/jxsj/mall/")
end

-- 更新福利领取情况
function uiFuliTequan:UpdateFuliInfoPage()
  for nIndex, tbInfo in pairs(self.tbFuliInfo) do
    local fncExcute = self[tbInfo[1]]
    if fncExcute then
      fncExcute(self, nIndex)
    end
  end
end

-- 打开充值
function uiFuliTequan:OpenQuikPay()
  if IVER_g_nSdoVersion == 1 then
    OpenSDOWidget()
    return
  end
  me.CallServerScript({ "ApplyOpenOnlinePay" })
end

-- 调用特权
function uiFuliTequan:CallTequan(szType)
  me.CallServerScript({ "Tequan", szType })
end

-- 激活工资
function uiFuliTequan:ActionKinWage()
  me.CallServerScript({ "PlayerCmd", "ActionKinWage" })
end

-- 打开Window
function uiFuliTequan:OpenWindow(szName)
  if UiManager:WindowVisible(szName) ~= 1 then
    UiManager:OpenWindow(szName)
  end
end

-- 1:福袋福利
function uiFuliTequan:UpdateFuli_Fudai(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local bIsFudaiVip = 0
  if self.nMonthPay >= IVER_g_nPayLevel1 then
    bIsFudaiVip = 1
  end
  local nUsedCount = 0
  local nDate = tonumber(GetLocalDate("%y%m%d"))
  if me.GetTask(2013, 2) == nDate then
    nUsedCount = me.GetTask(2013, 1)
  end
  local szContent = ""
  if bIsFudaiVip == 1 then
    Wnd_Hide(self.UIGROUP, szBtnGetName)
    if nUsedCount < 20 then
      szContent = string.format("<color=green>%s/20<color>", nUsedCount)
    else
      szContent = string.format("<color=white>%s/20<color>", nUsedCount)
    end
  else
    Wnd_Show(self.UIGROUP, szBtnGetName)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
    self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
    szContent = string.format("<color=red>%s/10<color>", nUsedCount)
  end

  Txt_SetTxt(self.UIGROUP, szTxtStateName, szContent)
end

-- 2:领菜
function uiFuliTequan:UpdateFuli_GetCai(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local bIsGetCaiVip = 0
  if self.nMonthPay >= EventManager.IVER_nPlayerFuli_Cai then
    bIsGetCaiVip = 1
  end
  if bIsGetCaiVip == 0 then
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
    self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>未激活<color>")
  else
    local nDay = me.GetTask(2038, 10)
    local nTimes = me.GetTask(2038, 11)
    if Lib:GetLocalDay() > nDay then
      nTimes = 0
    end
    if nTimes >= 5 then
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取完毕")
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
    else
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取")
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    end
    self.tbFuliInfo[nIndex][2] = "CallTequan:getcai"
    if nTimes < 5 then
      Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=green>%s/5<color>", nTimes))
    else
      Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=white>%s/5<color>", nTimes))
    end
  end
end

-- 3:领取额外的半小时修炼时间
function uiFuliTequan:UpdateFuli_GetXiulianTimes(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local bXiulianVip = 0
  if self.nMonthPay >= IVER_g_nPayLevel2 then
    bXiulianVip = 1
  end
  if bXiulianVip == 0 then
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
    self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>1.5小时<color>")
  else
    local nCurDate = tonumber(GetLocalDate("%y%m%d"))
    self.tbFuliInfo[nIndex][2] = "CallTequan:getxiuliantime"
    if me.GetTask(2038, 6) >= nCurDate then
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=white>2小时<color>")
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取完毕")
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
    else
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取")
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>1.5小时<color>")
    end
  end
end

-- 4:祈福次数
function uiFuliTequan:UpdateFuli_GetPrayTimes(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local bPrayVip = 0
  if self.nMonthPay >= IVER_g_nPayLevel2 then
    bPrayVip = 1
  end
  local nCount = Task.tbPlayerPray:GetPrayCount(me)
  if bPrayVip == 0 then
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
    self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>未激活<color>")
  else
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "祈福")
    self.tbFuliInfo[nIndex][2] = string.format("OpenWindow:%s", Ui.UI_PLAYERPRAY)
    if nCount > 0 then
      Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=green>%s次<color>", nCount))
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    else
      Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=white>%s次<color>", nCount))
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
    end
  end
end

-- 5:远程拍卖、任务平台等
function uiFuliTequan:UpdateFuli_Remote1(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local bRemoteVip = 0
  if self.nMonthPay >= EventManager.IVER_nPlayerFuli_Paimai and self.nMonthPay >= EventManager.IVER_nPlayerFuli_Task then
    bRemoteVip = 1
  end
  if bRemoteVip == 0 then
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    Wnd_Show(self.UIGROUP, szBtnGetName)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
    self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>未激活<color>")
  else
    Wnd_Hide(self.UIGROUP, szBtnGetName)
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>已激活<color>")
    self.tbFuliInfo[nIndex][2] = nil
  end
end

-- 6:远程仓库，远程和玄
function uiFuliTequan:UpdateFuli_Remote2(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local bRemoteVip = 0
  if self.nMonthPay >= EventManager.IVER_nPlayerFuli_Hexuan and self.nMonthPay >= EventManager.IVER_nPlayerFuli_Cangku then
    bRemoteVip = 1
  end
  if bRemoteVip == 0 then
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    Wnd_Show(self.UIGROUP, szBtnGetName)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
    self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>未激活<color>")
  else
    Wnd_Hide(self.UIGROUP, szBtnGetName)
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>已激活<color>")
    self.tbFuliInfo[nIndex][2] = nil
  end
end

-- 7,8:福利精活
function uiFuliTequan:UpdateFuli_JingHuo(nIndex)
  local szTxtCondition = self.TXT_CONDITION .. nIndex
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local nType = nIndex - 6
  local nWeiWang = KGblTask.SCGetDbTaskInt(DBTASD_EVENT_PRESIGE_RESULT)
  if nWeiWang <= 0 then
    nWeiWang = 60
  end
  local nWeiWangKe = KGblTask.SCGetDbTaskInt(DBTASK_JINGHUOFULI_KE)
  if nWeiWangKe > 0 then
    nWeiWang = nWeiWangKe
  end
  Txt_SetTxt(self.UIGROUP, szTxtCondition, string.format("今日江湖威望需求：%s", nWeiWang))
  local tbPillInfo = Player.tbBuyJingHuo:GetPillInfo()
  local nCount = tbPillInfo[nType][4]
  if 2 == Player.tbBuyJingHuo:CheckBuyState(me, nType) then
    nCount = 1
  end
  if me.nPrestige >= nWeiWang then
    if nCount > 0 then
      Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=green>%s次<color>", nCount))
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "购买")
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
      self.tbFuliInfo[nIndex][2] = string.format("OpenWindow:%s", Ui.UI_JINGHUOFULI)
    else
      Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=white>%s次<color>", nCount))
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "购买完毕")
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
      self.tbFuliInfo[nIndex][2] = nil
    end
  else
    Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=red>%s次<color>", nCount))
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "购买")
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
    self.tbFuliInfo[nIndex][2] = nil
  end
end

-- 9:领取江湖威望
function uiFuliTequan:UpdateFuli_Prestige(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local nVipLevel = 0
  if self.nMonthPay >= IVER_g_nPayLevel1 then
    nVipLevel = 1
  end
  if self.nMonthPay >= IVER_g_nPayLevel2 then
    nVipLevel = 2
  end
  local tbValue = { 10, 30 }
  -- 已经被其他角色激活
  if self.nPrestigeActive == -1 then
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取")
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
    self.tbFuliInfo[nIndex][2] = nil
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=white>0/0<color>")
  else
    if nVipLevel == 0 then
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
      self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>未激活<color>")
    else
      local nTaskPre = me.GetTask(2027, 55)
      local nCurWeek = tonumber(GetLocalDate("%Y%W"))
      if nCurWeek > me.GetTask(2027, 54) then
        nTaskPre = 0
      end
      if nTaskPre >= tbValue[nVipLevel] then
        Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=white>%s/%s<color>", nTaskPre, tbValue[nVipLevel]))
        Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取完毕")
        Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
        self.tbFuliInfo[nIndex][2] = nil
      else
        Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=green>%s/%s<color>", nTaskPre, tbValue[nVipLevel]))
        Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取")
        Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
        self.tbFuliInfo[nIndex][2] = "CallTequan:getprestige"
      end
    end
  end
end

-- 10:12绑银兑换18万不绑银
function uiFuliTequan:UpdateFuli_CoinExchange(nIndex)
  local szTxtCondition = self.TXT_CONDITION .. nIndex
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local nWeiWang = KGblTask.SCGetDbTaskInt(DBTASD_EVENT_PRESIGE_RESULT)
  if nWeiWang <= 100 then
    nWeiWang = 100
  end
  Txt_SetTxt(self.UIGROUP, szTxtCondition, string.format("今日江湖威望需求：%s", nWeiWang))
  local nLastXchgWeek = me.GetTask(2080, 1)
  local nThisWeek = Lib:GetLocalWeek(GetTime()) + 1
  if nThisWeek == nLastXchgWeek then
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
    Wnd_Show(self.UIGROUP, szBtnGetName)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "兑换完毕")
    self.tbFuliInfo[nIndex][2] = nil
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=white>1/1<color>")
  else
    if me.nPrestige >= nWeiWang then
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
      Wnd_Show(self.UIGROUP, szBtnGetName)
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "兑换")
      self.tbFuliInfo[nIndex][2] = "CallTequan:coinexchange"
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>0/1<color>")
    else
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
      Wnd_Show(self.UIGROUP, szBtnGetName)
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "兑换")
      self.tbFuliInfo[nIndex][2] = nil
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>0/1<color>")
    end
  end
end

-- 11:周工资
function uiFuliTequan:UpdateFuli_GetWage(nIndex)
  local szTxtCondition = self.TXT_CONDITION .. nIndex
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local nWageQualification = 0
  if self.nPrestigeRank > 0 and self.nPrestigeRank <= 1200 then
    nWageQualification = 1
  end
  if nWageQualification == 0 then
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取")
    self.tbFuliInfo[nIndex][2] = nil
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>0/0<color>")
  else
    local nTime = GetTime()
    local nWeek = Lib:GetLocalWeek(nTime)
    local nLastTime = me.GetTask(2027, 68)
    local nLastWeek = Lib:GetLocalWeek(nLastTime)
    local nTimeOK = 0
    if nLastWeek == 0 or nWeek > nLastWeek then
      nTimeOK = 1
    end
    -- 本周工资还未领
    if nTimeOK == 1 then
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取")
      self.tbFuliInfo[nIndex][2] = "CallTequan:getsalary"
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>0/1<color>")
    else
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取完毕")
      self.tbFuliInfo[nIndex][2] = nil
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=white>1/1<color>")
    end
  end
end

-- 12:领取乾坤符
function uiFuliTequan:UpdateFuli_GetQiankunfu(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local nCurDate = tonumber(GetLocalDate("%Y%m%d"))
  Wnd_Show(self.UIGROUP, szBtnGetName)
  local tbFreeMedicine = {
    [1] = { 50, 1 },
    [2] = { 70, 2 },
    [3] = { 90, 3 },
    [4] = { 200, 4 },
  }
  local nCount = 0
  for _, tb in ipairs(tbFreeMedicine) do
    if me.nLevel < tb[1] then
      nCount = tb[2]
      break
    end
  end
  local nCountGet = me.GetTask(2199, 2)
  local nTime = me.GetTask(2199, 1)
  if nTime ~= nCurDate then
    nCountGet = 0
  end
  if nCountGet >= nCount then -- 领过了
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 0)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取完毕")
    self.tbFuliInfo[nIndex][2] = nil
    Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=white>%s/%s<color>", nCountGet, nCount))
  else
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取")
    self.tbFuliInfo[nIndex][2] = "CallTequan:getfulimedic"
    Txt_SetTxt(self.UIGROUP, szTxtStateName, string.format("<color=green>%s/%s<color>", nCountGet, nCount))
  end
end

-- 13:领取传送符
function uiFuliTequan:UpdateFuli_GetChuansong(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local bQiankunfuVip = 0
  if self.nMonthPay >= EventManager.IVER_nPlayerFuli_Chuansong then
    bQiankunfuVip = 1
  end
  if bQiankunfuVip == 0 then
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    Wnd_Show(self.UIGROUP, szBtnGetName)
    Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
    self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>未激活<color>")
  else
    local nCurDate = tonumber(GetLocalDate("%y%m%d"))
    Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
    Wnd_Show(self.UIGROUP, szBtnGetName)

    if math.floor(me.GetTask(2038, 7) / 100) >= math.floor(nCurDate / 100) and math.floor(me.GetTask(2038, 8) / 100) >= math.floor(nCurDate / 100) then -- 本月领过了
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "传送")
      self.tbFuliInfo[nIndex][2] = "CallTequan:getchuansongfu"
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=white>2/2<color>")
    elseif math.floor(me.GetTask(2038, 7) / 100) >= math.floor(nCurDate / 100) then
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取乾坤符")
      self.tbFuliInfo[nIndex][2] = "CallTequan:getqiankunfu"
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>1/2<color>")
    elseif math.floor(me.GetTask(2038, 8) / 100) >= math.floor(nCurDate / 100) then
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取传送符")
      self.tbFuliInfo[nIndex][2] = "CallTequan:getchuansongfu"
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>1/2<color>")
    else
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "领取传送符")
      self.tbFuliInfo[nIndex][2] = "CallTequan:getchuansongfu"
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>0/2<color>")
    end
  end
end

--14: 激活家族工资特权
function uiFuliTequan:UpdateFuli_UpdateKinWage(nIndex)
  local szTxtStateName = self.TXT_STATE .. nIndex
  local szBtnGetName = self.BTN_GET .. nIndex
  local bQiankunfuVip = 0
  if self.nMonthPay >= EventManager.IVER_nPlayerFuli_KinWage then
    bQiankunfuVip = 1
  end
  -- 已经被其他角色激活
  local nCurDate = tonumber(GetLocalDate("%Y%m"))

  if me.GetTask(2196, 1) >= nCurDate then -- 本月角色已经激活
    Wnd_Hide(self.UIGROUP, szBtnGetName)
    Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=green>已激活<color>")
    self.tbFuliInfo[nIndex][2] = nil
  else
    --本月角色未激活
    if bQiankunfuVip == 0 then --本月充值条件不足
      Wnd_SetEnable(self.UIGROUP, szBtnGetName, 1)
      Wnd_Show(self.UIGROUP, szBtnGetName)
      Btn_SetTxt(self.UIGROUP, szBtnGetName, "获取领取资格")
      self.tbFuliInfo[nIndex][2] = "OpenQuikPay:"
      Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>未激活<color>")
    else
      --充值条件满足
      if self.nKinWageActive >= nCurDate then
        --别的角色已激活
        Wnd_Hide(self.UIGROUP, szBtnGetName)
        Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=gray>无资格<color>")
        self.tbFuliInfo[nIndex][2] = nil
      else
        --未激活
        Btn_SetTxt(self.UIGROUP, szBtnGetName, "激活")
        self.tbFuliInfo[nIndex][2] = "ActionKinWage:"
        Txt_SetTxt(self.UIGROUP, szTxtStateName, "<color=red>未激活<color>")
      end
    end
  end
end

function uiFuliTequan:OpenOnlineBankPayDialog()
  me.CallServerScript({ "ApplyOpenOnlineBankPay" })
end
