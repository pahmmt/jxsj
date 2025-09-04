local uiPayAward = Ui:GetClass("payaward")

local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem
local tbAwardInfo = Ui.tbLogic.tbAwardInfo

uiPayAward.BTN_50CLASS = "BtnChongClass1"
uiPayAward.BTN_188CLASS = "BtnChongClass2"
uiPayAward.BTN_588CLASS = "BtnChongClass3"
uiPayAward.BTN_988CLASS = "BtnChongClass4"
uiPayAward.BTN_1000BACKCLASS = "BtnChongClass5"
uiPayAward.BTN_1988CLASS = "BtnChongClass6"
uiPayAward.BTN_4988CLASS = "BtnChongClass7"
uiPayAward.BTN_CLASS = "BtnChongClass"

uiPayAward.BTN_CLOSE = "BtnClose"
uiPayAward.TXT_CHONGZHIRECORD = "TxtChongZhiRecord"
uiPayAward.TXT_CHONGZHICLASSNAME = "TxtChongZhiClassName"
uiPayAward.BTN_ACTIVE = "BtnActive"
uiPayAward.BTN_CHONGZHI = "BtnChongZhi"
uiPayAward.BTN_LEFT_BASEAWARD = "BtnBaseAwardPageLeft"
uiPayAward.BTN_RIGHT_BASEAWARD = "BtnBaseAwardPageRight"
uiPayAward.BTN_LEFT_MULONE = "BtnMulOneAwardPageLeft"
uiPayAward.BTN_RIGHT_MULONE = "BtnMulOneAwardPageRight"
uiPayAward.BTN_LEFT_BUYITEM = "BtnBuyPageLeft"
uiPayAward.BTN_RIGHT_BUYITEM = "BtnBuyPageRight"
uiPayAward.TXT_PAGE_NUM_BASEAWARD = "TxtBaseAwardPageNum"
uiPayAward.TXT_PAGE_NUM_MULONE = "TxtMulOnePageNum"
uiPayAward.TXT_PAGE_NUM_BUYITEM = "TxtBuyPageNum"
uiPayAward.BTN_GETBASEAWARD = "BtnGetItemAward"
uiPayAward.BTN_GETMULONEAWARD = "BtnGetMulOneItem"
uiPayAward.BTN_BUYITEM = "BtnBuyItem"
uiPayAward.TXT_BASE_AWARD_NAME = "TxtBaseAward"
uiPayAward.TXT_MUL_ONE_NAME = "TxtMulOneAward"
uiPayAward.BTN_MUL_ONE_CHECK = "BtnMulOneCheck"
uiPayAward.WND_ONEBUY = "WndOneBuy"
uiPayAward.TXT_BUY_NAME = "TxtBuyName"
uiPayAward.TXT_BUY_DESC = "TxtButDesc"
uiPayAward.TXT_BUY_COUNT = "TxtBuyCount"
uiPayAward.BTN_CHANGE_YUEGUI = "BtnChangeYueGui"
uiPayAward.BTN_CHANGE_PUTI = "BtnChangePuti"
uiPayAward.TXT_SPE_MULONE_NAME = "Txt6SpeName"
uiPayAward.TXT_SPE_BASE_NAME = "Txt6BaseSpeName"
uiPayAward.BTN_BUY_PIAO_HAO = "BtnBuyPiaoHao"

uiPayAward.IMG_FILE_CLASS = "\\image\\ui\\002a\\payaward\\img_heightlight.spr"
uiPayAward.IMG_BIND_ITEM = "\\image\\ui\\002a\\payaward\\bg_icon.spr"
uiPayAward.IMG_NOTBIND_ITEM = "\\image\\ui\\002a\\payaward\\bg_icon2.spr"
uiPayAward.COUNT_BTN_CLASS = 7
uiPayAward.GRID_COUNT = 12
uiPayAward.GRID_COUNT_BUY = 4

-- 12 grid
uiPayAward.IMG_GRID_BASEAWARD = {}
for i = 1, uiPayAward.GRID_COUNT do
  uiPayAward.IMG_GRID_BASEAWARD[i] = { "ImgGrid" .. i, "ObjGrid" .. i }
end

-- obj name to index
uiPayAward.OBJ_INDEX_BASEAWARD = {}
for i = 1, uiPayAward.GRID_COUNT do
  uiPayAward.OBJ_INDEX_BASEAWARD["ObjGrid" .. i] = i
end

uiPayAward.IMG_GRID_MULONEAWARD = {}
for i = 1, uiPayAward.GRID_COUNT do
  uiPayAward.IMG_GRID_MULONEAWARD[i] = { "ImgMulOneGrid" .. i, "ObjMulOneGrid" .. i }
end

-- obj name to index
uiPayAward.OBJ_INDEX_MULONEAWARD = {}
for i = 1, uiPayAward.GRID_COUNT do
  uiPayAward.OBJ_INDEX_MULONEAWARD["ObjMulOneGrid" .. i] = i
end

uiPayAward.IMG_GRID_BUYITEMAWARD = {}
for i = 1, uiPayAward.GRID_COUNT_BUY do
  uiPayAward.IMG_GRID_BUYITEMAWARD[i] = { "ImgOneBuyGrid" .. i, "ObjOneBuyGrid" .. i }
end

-- obj name to index
uiPayAward.OBJ_INDEX_BUYITEMAWARD = {}
for i = 1, uiPayAward.GRID_COUNT_BUY do
  uiPayAward.OBJ_INDEX_BUYITEMAWARD["ObjOneBuyGrid" .. i] = i
end

uiPayAward.nCurPayClass = 1
uiPayAward.nCurPage_BaseAward = 1
uiPayAward.nTotalPage_BaseAward = 1
uiPayAward.nCurPage_MulOneAward = 1
uiPayAward.nTotalPage_MulOneAward = 1
uiPayAward.nCurMulOne_CheckAward = 0

uiPayAward.nCurPage_BuyItemAward = 1
uiPayAward.nTotalPage_BuyItemAward = 1
uiPayAward.nMonthPay = 0
uiPayAward.COLOR_GREEN = "22,243,43"
uiPayAward.COLOR_GREEN_HEX = 0xFF16F32B
uiPayAward.COLOR_RED = "243,50,77"
uiPayAward.COLOR_RED_HEX = 0xFFF3324D
uiPayAward.COLOR_DYELLOW = "255,236,209"
uiPayAward.COLOR_DYELLOW_HEX = 0xFFFFECD1
uiPayAward.COLOR_GRAY = "150,147,142"
uiPayAward.COLOR_GRAY_HEX = 0xFF96938E
uiPayAward.COLOR_WHITE = "255,255,255"
uiPayAward.COLOR_WHITE_HEX = 0xFFFFFFFF

uiPayAward.tbImgGrid = {
  [1] = "\\image\\ui\\002a\\payaward\\bg_icon.spr",
  [2] = "\\image\\icon\\fightskill\\public\\rage_gold.spr",
  [3] = "\\image\\icon\\task\\prize_money.spr",
}

uiPayAward.TYPE_AWARD_BASE = 1 -- 奖励类型：基本奖励
uiPayAward.TYPE_AWARD_MULONE = 2 -- 奖励类型：多选一
uiPayAward.TYPE_AWARD_BUYITEM = 3 -- 奖励类型：购买资格
uiPayAward.TYPE_AWARD_MONEYBACK = 4 -- 奖励类型：绑金返还

uiPayAward.nEventOpen = 0
uiPayAward.nTimerCount = 0

uiPayAward.tbSendBaseAward = {}

uiPayAward.tbBuyItemList = {}

uiPayAward.tbClassBtnState = {
  [1] = {
    szName = "幸福礼包（50元）",
    nActiveState = 0,
    szBtnName = uiPayAward.BTN_50CLASS,
  },
  [2] = {
    szName = "极致礼包（188元）",
    nActiveState = 0,
    szBtnName = uiPayAward.BTN_188CLASS,
  },
  [3] = {
    szName = "尊贵礼包（588元）",
    nActiveState = 0,
    szBtnName = uiPayAward.BTN_588CLASS,
  },
  [4] = {
    szName = "荣耀礼包（988元）",
    nActiveState = 0,
    szBtnName = uiPayAward.BTN_988CLASS,
  },
  [5] = {
    szName = "绑金返还（1000元以上）",
    nActiveState = 0,
    szBtnName = uiPayAward.BTN_1000BACKCLASS,
  },
  [6] = {
    szName = "尊享礼包（1988元）",
    nActiveState = 0,
    szBtnName = uiPayAward.BTN_1988CLASS,
  },
  [7] = {
    szName = "无价至尊大礼包（4988元）",
    nActiveState = 0,
    szBtnName = uiPayAward.BTN_4988CLASS,
  },
}

function uiPayAward:ProcessCheckPayAward()
  if self.nTimerFlag then
    Timer:Close(self.nTimerFlag)
  end
  self.nTimerFlag = Timer:Register(Env.GAME_FPS * 5, self.CheckPlayAnimation, self)
  return
end

function uiPayAward:OnEnterGame()
  self.nClickWindowStep = 0
end

function uiPayAward:OnLeaveGame()
  self.nPlayerActiveState = nil
  Task.tbHelp.tbLottoryData = {}
  self.nTimerCount = nil
end

function uiPayAward:PayAwardPlayAnimation()
  SetFulitequanNewFlag(1)
  Wnd_SetAnimation(Ui.UI_PAYERFULI, "BtnFulitequan", 1)
  Wnd_SetAnimation(Ui.UI_FULITEQUAN, "BtnOpenPayAward", 1)
  Img_PlayAnimation(Ui.UI_PAYERFULI, "BtnFulitequan", 1, 400, 0, 1)
  Img_PlayAnimation(Ui.UI_FULITEQUAN, "BtnOpenPayAward", 1, 400, 0, 1)
end

function uiPayAward:PayAwardStopAnimation()
  SetFulitequanNewFlag(0)
  Wnd_SetAnimation(Ui.UI_PAYERFULI, "BtnFulitequan", 0)
  Wnd_SetAnimation(Ui.UI_FULITEQUAN, "BtnOpenPayAward", 0)
  Img_StopAnimation(Ui.UI_PAYERFULI, "BtnFulitequan")
  Img_StopAnimation(Ui.UI_FULITEQUAN, "BtnOpenPayAward")
end

function uiPayAward:CheckPlayAnimation()
  local nResult = nil
  if not self.nTimerCount then
    self.nTimerCount = 0
  end
  self.nTimerCount = self.nTimerCount + 1

  self:PayAwardStopAnimation()

  if self.nTimerCount > 6 then
    self.nTimerFlag = nil
    return 0
  end

  if not self.tbPayAwardList then
    return nResult
  end

  -- 如果活动开启了，且未激活角色，那么久一直闪
  if self.nEventOpen == 0 then
    return nResult
  end

  if self.nClickWindowStep and self.nClickWindowStep == 1 then
    return nResult
  end

  local nPlayerActiveState = self.nPlayerActiveState or 5
  if nPlayerActiveState == 0 then
    self:PayAwardPlayAnimation()
    return nResult
  end

  if nPlayerActiveState ~= 1 then
    return nResult
  end

  for nClass, tbClass in pairs(self.tbPayAwardList) do
    local nFlag = self:CheckGetAllAward(nClass)
    if 0 == nFlag then
      self:PayAwardPlayAnimation()
      return nResult
    end
  end
  return nResult
end

function uiPayAward:PreOpen(bServer)
  if not bServer then
    return 1
  end

  me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_OPEN_WND })
  return 0
end

-- 在新手村和城市才能打开
function uiPayAward:OnOpen()
  self.nClickWindowStep = 1
  self.nCurMulOne_CheckAward = 0
  self.nEventOpen = 0
  self.tbSendBaseAward = {}
  self.tbPayAwardList = EventManager.tbChongZhiEvent.tbChongZhiAward
  self.nCurPayClass = 1
  self.nCurPage_BaseAward = 1
  self.nCurPage_MulOneAward = 1
  self.nCurPage_BuyItemAward = 1
  Txt_SetTxt(self.UIGROUP, self.TXT_CHONGZHIRECORD, "")
  me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_UPDATEMONEY })
  me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_UPDATEDATA })
  self:UpdatePayAward()
end

function uiPayAward:OnClose()
  self:ClearBaseAwardGrid()
  self:ClearMulOneGrid()
  self:ClearBuyItemGrid()
end

function uiPayAward:UpdateActiveMsg()
  local nActive = self.nPlayerActiveState or 0 -- 是否激活充值领奖
  local szMsg = "您当月累计充值%s元，当前角色"
  if nActive == 0 then
    szMsg = string.format(szMsg .. "<color=%s>未激活领奖资格<color>", self.nMonthPay, self.COLOR_RED)
  elseif nActive == 1 then
    szMsg = string.format(szMsg .. "<color=%s>已激活了资格<color>", self.nMonthPay, self.COLOR_GREEN)
  elseif nActive == 2 then
    szMsg = string.format(szMsg .. "<color=%s>账号下其他角色已激活了资格<color>", self.nMonthPay, self.COLOR_RED)
  else
    szMsg = string.format(szMsg .. "<color=%s>激活资格异常<color>", self.nMonthPay, self.COLOR_RED)
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_CHONGZHIRECORD, szMsg)
  if 0 == nActive then
    Wnd_SetEnable(self.UIGROUP, self.BTN_ACTIVE, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_ACTIVE, 0)
  end
end

-- 更新基础奖励界面
function uiPayAward:UpdateBaseAward()
  self:ClearBaseAwardGrid()
  Wnd_SetEnable(self.UIGROUP, self.BTN_GETBASEAWARD, 0)
  Btn_SetTxt(self.UIGROUP, self.BTN_GETBASEAWARD, "已领取")
  Wnd_SetEnable(self.UIGROUP, self.BTN_LEFT_BASEAWARD, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_RIGHT_BASEAWARD, 0)
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_BASEAWARD, string.format("0/0"))

  for i = 1, self.GRID_COUNT do
    Txt_SetTxt(self.UIGROUP, self.TXT_BASE_AWARD_NAME .. i, "")
    Wnd_Hide(self.UIGROUP, self.TXT_SPE_BASE_NAME .. i)
    Txt_SetTxt(self.UIGROUP, self.TXT_SPE_BASE_NAME .. i, "")
  end

  local nStart = 1
  local nEnd = self.GRID_COUNT

  local nBaseType = self.TYPE_AWARD_BASE
  local tbClass = self.tbPayAwardList[self.nCurPayClass]

  if not tbClass then
    return 0
  end

  if not tbClass.tbAwardList then
    return 0
  end

  local tbType = tbClass.tbAwardList[nBaseType]
  if not tbType then
    return 0
  end

  local tbItemList = tbType.tbList
  local tbEventType = tbType.tbAwardEventType

  for i, tbItem in pairs(tbItemList) do
    tbItem.nAwardState = tbEventType[tbItem.nEventType].nAwardState or 1
  end

  nStart = (self.nCurPage_BaseAward - 1) * self.GRID_COUNT + 1
  nEnd = nStart + self.GRID_COUNT - 1

  if nEnd > #tbItemList then
    nEnd = #tbItemList
  end

  local nGetCount = 0

  for i = nStart, nEnd do
    local tbItem = tbItemList[i]
    local nIndex = math.fmod(i, self.GRID_COUNT)
    if nIndex == 0 then
      nIndex = self.GRID_COUNT
    end

    local szTxtName = self.TXT_BASE_AWARD_NAME .. nIndex
    if self.nCurPayClass == 7 then
      szTxtName = self.TXT_SPE_BASE_NAME .. nIndex
      Wnd_Show(self.UIGROUP, szTxtName)
    end
    if self.nCurPayClass == 5 then
      Txt_SetTxt(self.UIGROUP, szTxtName, tbItem.szName)
      if tbItem.nAwardState and tbItem.nAwardState == 0 then
        Txt_SetTxtColor(self.UIGROUP, szTxtName, self.COLOR_WHITE_HEX)
      else
        Txt_SetTxtColor(self.UIGROUP, szTxtName, self.COLOR_GRAY_HEX)
        nGetCount = nGetCount + 1
      end
    else
      if tbItem.nAwardState and tbItem.nAwardState == 0 then
        Txt_SetTxt(self.UIGROUP, szTxtName, tbItem.szName)
        Txt_SetTxtColor(self.UIGROUP, szTxtName, self.COLOR_WHITE_HEX)
      else
        if self.nCurPayClass == 7 then
          szTxtName = self.TXT_BASE_AWARD_NAME .. nIndex
        end
        Txt_SetTxt(self.UIGROUP, szTxtName, "已领取")
        Txt_SetTxtColor(self.UIGROUP, szTxtName, self.COLOR_GREEN_HEX)
        nGetCount = nGetCount + 1
      end
    end

    Wnd_SetTip(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], "")

    if tbItem.szAwardType == "AddItem" then
      local tbItemId = Lib:SplitStr(tbItem.szAward, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[6]) or 0, tonumber(tbItemId[5]))
      if tbObj then
        self.tbBaseAwardGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[6]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
    elseif tbItem.szAwardType == "AddSkillBuff" then
      Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][2], 1, self.tbImgGrid[2])
      Wnd_Show(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1])
    elseif tbItem.szAwardType == "CoinBuyItem" then
      local tbItemId = Lib:SplitStr(tbItem.szImgItem, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[5]) or 0)
      if tbObj then
        self.tbBaseAwardGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[5]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
    elseif tbItem.szAwardType == "CoinBuyHeShiBi" then
      local tbItemId = Lib:SplitStr(tbItem.szImgItem, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[5]) or 0)
      if tbObj then
        self.tbBaseAwardGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[5]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
    elseif tbItem.szAwardType == "AddBuyItemSum" then
      local tbItemId = Lib:SplitStr(tbItem.szImgItem, ",")
      local tbParam = Lib:SplitStr(tbItem.szAward, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[5]) or 0, tonumber(tbItemId[6]))
      if tbObj then
        self.tbBaseAwardGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[5]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
    elseif tbItem.szAwardType == "BindCoinBack" then
      Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][2], 1, self.tbImgGrid[3])
      Wnd_Show(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1])
      Wnd_SetTip(self.UIGROUP, self.IMG_GRID_BASEAWARD[nIndex][1], tbItem.szTip)
    end
  end

  local nBtnGetState = self.tbClassBtnState[self.nCurPayClass].nActiveState or 0
  if nBtnGetState == 1 and nGetCount < #tbItemList then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETBASEAWARD, 1)
    Btn_SetTxt(self.UIGROUP, self.BTN_GETBASEAWARD, "全部领取")
  elseif nBtnGetState == 0 then
    Btn_SetTxt(self.UIGROUP, self.BTN_GETBASEAWARD, "全部领取")
  end

  local nTotPage = math.floor(#tbItemList / self.GRID_COUNT)
  local nNowPage = math.fmod(#tbItemList, self.GRID_COUNT)
  if nNowPage > 0 then
    nTotPage = nTotPage + 1
  end

  self.nTotalPage_BaseAward = nTotPage

  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_BASEAWARD, string.format("%s/%s", self.nCurPage_BaseAward, self.nTotalPage_BaseAward))

  if self.nCurPage_BaseAward > 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEFT_BASEAWARD, 1)
  end

  if self.nCurPage_BaseAward < self.nTotalPage_BaseAward then
    Wnd_SetEnable(self.UIGROUP, self.BTN_RIGHT_BASEAWARD, 1)
  end
end

function uiPayAward:UpdateMulOneCheck()
  for i = 1, self.GRID_COUNT do
    Btn_Check(self.UIGROUP, self.BTN_MUL_ONE_CHECK .. i, 0)
    local nIndex = math.fmod(self.nCurMulOne_CheckAward, self.GRID_COUNT)

    if nIndex == 0 then
      nIndex = self.GRID_COUNT
    end

    local nPage = math.floor(self.nCurMulOne_CheckAward / self.GRID_COUNT) + 1
    if nPage == self.nCurPage_MulOneAward and nIndex == i then
      Btn_Check(self.UIGROUP, self.BTN_MUL_ONE_CHECK .. i, 1)
    end
  end
  self:UpdateMulOneAward()
end

-- 更新多选一奖励界面
function uiPayAward:UpdateMulOneAward()
  self:ClearMulOneGrid()
  Wnd_SetEnable(self.UIGROUP, self.BTN_GETMULONEAWARD, 0)
  Btn_SetTxt(self.UIGROUP, self.BTN_GETMULONEAWARD, "已领取")
  Wnd_SetEnable(self.UIGROUP, self.BTN_LEFT_MULONE, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_RIGHT_MULONE, 0)
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_MULONE, string.format("0/0"))

  for i = 1, self.GRID_COUNT do
    Txt_SetTxt(self.UIGROUP, self.TXT_MUL_ONE_NAME .. i, "")
    Wnd_Hide(self.UIGROUP, self.BTN_MUL_ONE_CHECK .. i)
    Wnd_SetEnable(self.UIGROUP, self.BTN_MUL_ONE_CHECK .. i, 0)
    Wnd_Hide(self.UIGROUP, self.TXT_SPE_MULONE_NAME .. i)
    Txt_SetTxt(self.UIGROUP, self.TXT_SPE_MULONE_NAME .. i, "")
  end

  local nStart = 1
  local nEnd = self.GRID_COUNT

  local nBaseType = self.TYPE_AWARD_MULONE
  local tbClass = self.tbPayAwardList[self.nCurPayClass]

  if not tbClass then
    return 0
  end

  if not tbClass.tbAwardList then
    return 0
  end

  local tbType = tbClass.tbAwardList[nBaseType]
  if not tbType then
    return 0
  end

  local tbItemList = tbType.tbList
  local tbEventType = tbType.tbAwardEventType

  for i, tbItem in pairs(tbItemList) do
    tbItem.nAwardState = tbEventType[tbItem.nEventType].nAwardState or 1
  end

  nStart = (self.nCurPage_MulOneAward - 1) * self.GRID_COUNT + 1
  nEnd = nStart + self.GRID_COUNT - 1

  if nEnd > #tbItemList then
    nEnd = #tbItemList
  end
  local nGetCount = 0
  for i = nStart, nEnd do
    local tbItem = tbItemList[i]
    local nIndex = math.fmod(i, self.GRID_COUNT)
    if nIndex == 0 then
      nIndex = self.GRID_COUNT
    end

    local szTxtName = self.TXT_MUL_ONE_NAME .. nIndex
    if self.nCurPayClass == 7 then
      szTxtName = self.TXT_SPE_MULONE_NAME .. nIndex
      Wnd_Show(self.UIGROUP, szTxtName)
    end

    Txt_SetTxt(self.UIGROUP, szTxtName, tbItem.szName)
    Wnd_Show(self.UIGROUP, self.BTN_MUL_ONE_CHECK .. nIndex)
    if tbItem.nAwardState and tbItem.nAwardState == 0 then
      Txt_SetTxtColor(self.UIGROUP, szTxtName, self.COLOR_WHITE_HEX)
      Wnd_SetEnable(self.UIGROUP, self.BTN_MUL_ONE_CHECK .. nIndex, 1)
    else
      Txt_SetTxtColor(self.UIGROUP, szTxtName, self.COLOR_GRAY_HEX)
      Wnd_SetEnable(self.UIGROUP, self.BTN_MUL_ONE_CHECK .. nIndex, 0)
      nGetCount = nGetCount + 1
    end

    if tbItem.szAwardType == "AddItem" then
      local tbItemId = Lib:SplitStr(tbItem.szAward, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[6]) or 0, tonumber(tbItemId[5]))
      if tbObj then
        self.tbMulOneGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[6]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
    elseif tbItem.szAwardType == "AddSkillBuff" then
      Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][2], 1, self.tbImgGrid[2])
      Wnd_Show(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1])
    elseif tbItem.szAwardType == "CoinBuyItem" then
      local tbItemId = Lib:SplitStr(tbItem.szImgItem, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[5]) or 0)
      if tbObj then
        self.tbMulOneGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[5]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
    elseif tbItem.szAwardType == "AddBuyItemSum" then
      local tbItemId = Lib:SplitStr(tbItem.szImgItem, ",")
      local tbParam = Lib:SplitStr(tbItem.szAward, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[5]) or 0, tonumber(tbItemId[6]))
      if tbObj then
        self.tbMulOneGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[5]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
    elseif tbItem.szAwardType == "AddBuyHeShiBiSum" then
      local tbItemId = Lib:SplitStr(tbItem.szAward, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[5]) or 0, tonumber(tbItemId[6]))
      if tbObj then
        self.tbMulOneGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[5]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
    end
  end

  local nBtnGetState = self.tbClassBtnState[self.nCurPayClass].nActiveState or 0
  if nBtnGetState == 1 and nGetCount <= 0 and self.nCurMulOne_CheckAward > 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GETMULONEAWARD, 1)
    Btn_SetTxt(self.UIGROUP, self.BTN_GETMULONEAWARD, "领取")
  elseif nBtnGetState == 0 or nGetCount <= 0 then
    Btn_SetTxt(self.UIGROUP, self.BTN_GETMULONEAWARD, "领取")
  end

  local nTotPage = math.floor(#tbItemList / self.GRID_COUNT)
  local nNowPage = math.fmod(#tbItemList, self.GRID_COUNT)
  if nNowPage > 0 then
    nTotPage = nTotPage + 1
  end

  self.nTotalPage_MulOneAward = nTotPage

  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_MULONE, string.format("%s/%s", self.nCurPage_MulOneAward, self.nTotalPage_MulOneAward))

  if self.nCurPage_MulOneAward > 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEFT_MULONE, 1)
  end

  if self.nCurPage_MulOneAward < self.nTotalPage_MulOneAward then
    Wnd_SetEnable(self.UIGROUP, self.BTN_RIGHT_MULONE, 1)
  end
end

-- 更新购买区界面
function uiPayAward:UpdateBuyItemAward()
  self:ClearBuyItemGrid()
  for i = 1, self.GRID_COUNT_BUY do
    Wnd_Hide(self.UIGROUP, self.WND_ONEBUY .. i)
    Wnd_SetEnable(self.UIGROUP, self.BTN_BUYITEM .. i, 0)
    Txt_SetTxt(self.UIGROUP, self.TXT_BUY_COUNT .. i, "")
  end
  Wnd_SetEnable(self.UIGROUP, self.BTN_LEFT_BUYITEM, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_RIGHT_BUYITEM, 0)
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_BUYITEM, string.format("0/0"))

  local nStart = 1
  local nEnd = self.GRID_COUNT_BUY

  nStart = (self.nCurPage_BuyItemAward - 1) * self.GRID_COUNT_BUY + 1
  nEnd = nStart + self.GRID_COUNT_BUY - 1

  local tbItemList = self.tbBuyItemList

  if nEnd > #tbItemList then
    nEnd = #tbItemList
  end
  for i = nStart, nEnd, 1 do
    local tbItem = tbItemList[i]
    local nIndex = math.fmod(i, self.GRID_COUNT_BUY)
    if nIndex == 0 then
      nIndex = self.GRID_COUNT_BUY
    end
    Wnd_Show(self.UIGROUP, self.WND_ONEBUY .. nIndex)
    Txt_SetTxt(self.UIGROUP, self.TXT_BUY_NAME .. nIndex, tbItem.szName)
    Txt_SetTxt(self.UIGROUP, self.TXT_BUY_DESC .. nIndex, tbItem.szTip)
    if tbItem.nAwardState and tbItem.nAwardState == 0 then
      Wnd_SetEnable(self.UIGROUP, self.BTN_BUYITEM .. nIndex, 1)
    end

    if tbItem.szAwardType == "CoinBuyItem" then
      local tbItemId = Lib:SplitStr(tbItem.szImgItem, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[5]) or 0, nil, 1)
      if tbObj then
        self.tbBuyItemGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_BUYITEMAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[5]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BUYITEMAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BUYITEMAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
      local nCount = tbItem.nParam or 0
      Txt_SetTxt(self.UIGROUP, self.TXT_BUY_COUNT .. nIndex, string.format("可购买数量：%s", nCount))
      if not tbItem.nParam or tbItem.nParam <= 0 then
        Wnd_SetEnable(self.UIGROUP, self.BTN_BUYITEM .. nIndex, 0)
      end
    elseif tbItem.szAwardType == "CoinBuyHeShiBi" then
      local tbItemId = Lib:SplitStr(tbItem.szAward, ",")
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]), tonumber(tbItemId[5]) or 0, nil, 1)
      if tbObj then
        self.tbBuyItemGridCont[nIndex]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_BUYITEMAWARD[nIndex][1])
        local nBind = tonumber(tbItemId[5]) or 0
        if nBind == 0 then
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BUYITEMAWARD[nIndex][1], 1, self.IMG_NOTBIND_ITEM)
        else
          Img_SetImage(self.UIGROUP, self.IMG_GRID_BUYITEMAWARD[nIndex][1], 1, self.IMG_BIND_ITEM)
        end
      end
      local nCount = tbItem.nParam or 0
      Txt_SetTxt(self.UIGROUP, self.TXT_BUY_COUNT .. nIndex, string.format("可购买数量：%s", nCount))
      if not tbItem.nParam or tbItem.nParam <= 0 then
        Wnd_SetEnable(self.UIGROUP, self.BTN_BUYITEM .. nIndex, 0)
      end
    end
  end

  local nTotPage = math.floor(#tbItemList / self.GRID_COUNT_BUY)
  local nNowPage = math.fmod(#tbItemList, self.GRID_COUNT_BUY)
  if nNowPage > 0 then
    nTotPage = nTotPage + 1
  end

  self.nTotalPage_BuyItemAward = nTotPage
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_BUYITEM, string.format("%s/%s", self.nCurPage_BuyItemAward, self.nTotalPage_BuyItemAward))

  if self.nCurPage_BuyItemAward > 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_LEFT_BUYITEM, 1)
  end

  if self.nCurPage_BuyItemAward < self.nTotalPage_BuyItemAward then
    Wnd_SetEnable(self.UIGROUP, self.BTN_RIGHT_BUYITEM, 1)
  end
end

-- 更新充值按钮
function uiPayAward:UpdatePayAwardClass()
  Img_SetImage(self.UIGROUP, self.BTN_CLASS .. self.nCurPayClass, 1, self.IMG_FILE_CLASS)
  for nIndex, tbInfo in pairs(self.tbClassBtnState) do
    if self.nCurPayClass ~= nIndex then
      Img_SetImage(self.UIGROUP, self.BTN_CLASS .. nIndex, 1, "")
    else
      Txt_SetTxt(self.UIGROUP, self.TXT_CHONGZHICLASSNAME, tbInfo.szName)
    end
    if tbInfo.nActiveState == 0 then
      Btn_SetTextColor(self.UIGROUP, tbInfo.szBtnName, self.COLOR_RED_HEX)
    else
      local nFlag = self:CheckGetAllAward(nIndex)
      if 0 == nFlag then
        Btn_SetTextColor(self.UIGROUP, tbInfo.szBtnName, self.COLOR_DYELLOW_HEX)
      else
        Btn_SetTextColor(self.UIGROUP, tbInfo.szBtnName, self.COLOR_GRAY_HEX)
      end
    end
    Btn_SetTxt(self.UIGROUP, self.BTN_CLASS .. nIndex, tbInfo.szName)
  end

  if self.nMonthPay < 138 then
    Wnd_SetVisible(self.UIGROUP, self.BTN_BUY_PIAO_HAO, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_BUY_PIAO_HAO, 1)
  else
    Wnd_SetVisible(self.UIGROUP, self.BTN_BUY_PIAO_HAO, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_BUY_PIAO_HAO, 0)
  end
end

function uiPayAward:CheckGetAllAward(nClass)
  local tbClass = self.tbPayAwardList[nClass]
  local nGetCount = 0

  if not tbClass then
    return 1
  end

  if not tbClass.tbAwardList then
    return 1
  end

  local nBaseType = self.TYPE_AWARD_BASE

  local tbType = tbClass.tbAwardList[nBaseType]
  if tbType then
    local tbItemList = tbType.tbList
    local tbEventType = tbType.tbAwardEventType

    for i, tbItem in pairs(tbItemList) do
      tbItem.nAwardState = tbEventType[tbItem.nEventType].nAwardState or 1
    end

    for i, tbItem in pairs(tbItemList) do
      if tbItem.nAwardState and tbItem.nAwardState == 0 then
        return 0
      end
    end
  end

  nBaseType = self.TYPE_AWARD_MULONE

  local tbType = tbClass.tbAwardList[nBaseType]
  if tbType then
    local tbItemList = tbType.tbList
    local tbEventType = tbType.tbAwardEventType

    for i, tbItem in pairs(tbItemList) do
      tbItem.nAwardState = tbEventType[tbItem.nEventType].nAwardState or 1
    end

    for i, tbItem in pairs(tbItemList) do
      if tbItem.nAwardState and tbItem.nAwardState == 1 then
        return 1
      end
    end
    return 0
  end

  return 1
end

function uiPayAward:UpdatePayAward()
  -- 更改档次按钮显示图画
  self:UpdatePayAwardClass()
  self:UpdateBaseAward()
  self:UpdateMulOneAward()
  self:UpdateBuyItemAward()
end

function uiPayAward:ApplyBuyItem(nIndex)
  if not nIndex or nIndex <= 0 then
    return
  end

  local tbSendInfo = {}
  local tbItem = self.tbBuyItemList[nIndex]
  local tbInfo = { tbItem.nEventId, tbItem.nPartId }
  table.insert(tbSendInfo, tbInfo)
  me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_PROCESS_AWARD, tbSendInfo })
end

function uiPayAward:ApplyGetAward(nCurPayClass, nBaseType, nIndex)
  local tbClass = self.tbPayAwardList[nCurPayClass]

  if not tbClass then
    return 0
  end

  if not tbClass.tbAwardList then
    return 0
  end

  local tbType = tbClass.tbAwardList[nBaseType]
  if not tbType then
    return 0
  end

  local tbItemList = tbType.tbList
  local tbEventType = tbType.tbAwardEventType

  local tbSendInfo = {}

  if nIndex and nIndex > 0 then
    local tbItem = tbType.tbList[nIndex]
    local nAwardState = tbEventType[tbItem.nEventType].nAwardState or 1
    local tbInfo = { tbEventType[tbItem.nEventType].nEventId, tbEventType[tbItem.nEventType].nPartId }
    table.insert(tbSendInfo, tbInfo)
  else
    for i, tbItem in pairs(tbType.tbAwardEventType) do
      local tbInfo = { tbItem.nEventId, tbItem.nPartId }
      table.insert(tbSendInfo, tbInfo)
    end
  end

  me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_PROCESS_AWARD, tbSendInfo })
end

function uiPayAward:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
    return
  elseif szWnd == self.BTN_LEFT_BASEAWARD then
    self.nCurPage_BaseAward = self.nCurPage_BaseAward - 1
    if self.nCurPage_BaseAward <= 0 then
      self.nCurPage_BaseAward = 1
    end
    self:UpdateBaseAward()
    return
  elseif szWnd == self.BTN_RIGHT_BASEAWARD then
    self.nCurPage_BaseAward = self.nCurPage_BaseAward + 1
    if self.nCurPage_BaseAward > self.nTotalPage_BaseAward then
      self.nCurPage_BaseAward = self.nTotalPage_BaseAward
    end
    self:UpdateBaseAward()
    return
  elseif szWnd == self.BTN_LEFT_MULONE then
    self.nCurPage_MulOneAward = self.nCurPage_MulOneAward - 1
    if self.nCurPage_MulOneAward <= 0 then
      self.nCurPage_MulOneAward = 1
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_MULONE, string.format("%s/%s", self.nCurPage_MulOneAward, self.nTotalPage_MulOneAward))
    self:UpdateMulOneCheck()
    self:UpdateMulOneAward()
    return
  elseif szWnd == self.BTN_RIGHT_MULONE then
    self.nCurPage_MulOneAward = self.nCurPage_MulOneAward + 1
    if self.nCurPage_MulOneAward > self.nTotalPage_MulOneAward then
      self.nCurPage_MulOneAward = self.nTotalPage_MulOneAward
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_MULONE, string.format("%s/%s", self.nCurPage_MulOneAward, self.nTotalPage_MulOneAward))
    self:UpdateMulOneCheck()
    self:UpdateMulOneAward()
    return
  elseif szWnd == self.BTN_LEFT_BUYITEM then
    self.nCurPage_BuyItemAward = self.nCurPage_BuyItemAward - 1
    if self.nCurPage_BuyItemAward <= 0 then
      self.nCurPage_BuyItemAward = 1
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_BUYITEM, string.format("%s/%s", self.nCurPage_BuyItemAward, self.nTotalPage_BuyItemAward))
    self:UpdateBuyItemAward()
    return
  elseif szWnd == self.BTN_RIGHT_BUYITEM then
    self.nCurPage_BuyItemAward = self.nCurPage_BuyItemAward + 1
    if self.nCurPage_BuyItemAward > self.nTotalPage_BuyItemAward then
      self.nCurPage_BuyItemAward = self.nTotalPage_BuyItemAward
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_PAGE_NUM_BUYITEM, string.format("%s/%s", self.nCurPage_BuyItemAward, self.nTotalPage_BuyItemAward))
    self:UpdateBuyItemAward()
    return
  elseif szWnd == self.BTN_ACTIVE then
    me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_ACTIVE })
    return
  elseif szWnd == self.BTN_CHONGZHI then
    if IVER_g_nSdoVersion == 1 then
      OpenSDOWidget()
      return
    end
    me.CallServerScript({ "ApplyOpenOnlinePay" })
    return
  elseif szWnd == self.BTN_GETBASEAWARD then
    self:ApplyGetAward(self.nCurPayClass, self.TYPE_AWARD_BASE)
    return
  elseif szWnd == self.BTN_GETMULONEAWARD then
    if self.nCurMulOne_CheckAward > 0 then
      self:ApplyGetAward(self.nCurPayClass, self.TYPE_AWARD_MULONE, self.nCurMulOne_CheckAward)
    end
    return
  --	elseif (szWnd == self.BTN_CHANGE_PUTI) then
  --		me.CallServerScript({"ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_CHANGE_PUTI});
  --		return;
  elseif szWnd == self.BTN_CHANGE_YUEGUI then
    me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_CHANGE_YUEGUI })
    return
  elseif szWnd == self.BTN_BUY_PIAO_HAO then
    me.CallServerScript({ "ApplyProcessPayAward", EventManager.tbChongZhiEvent.PROT_BUY_PIAOHAO })
    return
  end

  for i = 1, self.GRID_COUNT do
    local szBtnCheck = self.BTN_MUL_ONE_CHECK .. i
    if szBtnCheck == szWnd then
      self.nCurMulOne_CheckAward = (self.nCurPage_MulOneAward - 1) * self.GRID_COUNT + i
      self:UpdateMulOneCheck()
      return
    end
  end

  for i = 1, self.GRID_COUNT_BUY do
    local szBtnBuy = self.BTN_BUYITEM .. i
    if szBtnBuy == szWnd then
      local nIndex = (self.nCurPage_BuyItemAward - 1) * self.GRID_COUNT_BUY + i
      self:ApplyBuyItem(nIndex)
      return
    end
  end

  for i = 1, self.COUNT_BTN_CLASS do
    local szBtnClass = self.BTN_CLASS .. i
    if szBtnClass == szWnd then
      self.nCurPayClass = i
      self:UpdatePayAward()
      return
    end
  end
end

function uiPayAward:OnMouseEnter(szWnd)
  for i = 1, self.COUNT_BTN_CLASS do
    local szBtn = self.BTN_CLASS .. i
    if szBtn == szWnd and i ~= self.nCurPayClass then
      Img_SetImage(self.UIGROUP, szBtn, 1, self.IMG_FILE_CLASS)
      break
    end
  end
end

function uiPayAward:OnMouseLeave(szWnd)
  for i = 1, self.COUNT_BTN_CLASS do
    local szBtn = self.BTN_CLASS .. i
    if szBtn == szWnd and i ~= self.nCurPayClass then
      Img_SetImage(self.UIGROUP, szBtn, 0, self.IMG_FILE_CLASS)
      break
    end
  end
end

function uiPayAward:Update(nPay, nPlayerActiveState)
  if UiManager:WindowVisible(Ui.UI_PAYAWARD) ~= 1 then
    return 0
  end

  self.nMonthPay = nPay or self.nMonthPay
  self.nPlayerActiveState = nPlayerActiveState
  for i, tbInfo in pairs(self.tbClassBtnState) do
    local tbClass = self.tbPayAwardList[i]
    if tbClass then
      local nMonthPay = tbClass.nMonthPay
      tbInfo.nActiveState = 0
      if nMonthPay <= self.nMonthPay and self.nPlayerActiveState == 1 then
        tbInfo.nActiveState = 1
      end
    end
  end
  self:UpdateActiveMsg()
  self:UpdatePayAwardClass()
end

function uiPayAward:UpdatePayAwardData(nPlayerActiveState, tbClassState, nTodayFirstLogin)
  if not self.tbPayAwardList then
    self.tbPayAwardList = EventManager.tbChongZhiEvent.tbChongZhiAward
  end

  self.nTodayFirstLogin = nTodayFirstLogin or 0

  if 1 == self.nTodayFirstLogin then
    self:ProcessCheckPayAward()
  end

  for i, tbInfo in pairs(tbClassState) do
    local tbClass = self.tbPayAwardList[tbInfo[1]]
    local tbAwardList = tbClass.tbAwardList
    if tbAwardList then
      local tbType = tbAwardList[tbInfo[2]]
      if tbType then
        local tbEventType = tbType.tbAwardEventType[tbInfo[3]]
        if tbEventType then
          tbEventType.nAwardState = tbInfo[4]
          if tbInfo[5] then
            for j, tbItem in pairs(tbType.tbList) do
              if tbInfo[5][tbItem.szAward] then
                tbItem.nParam = tbInfo[5][tbItem.szAward]
              end
            end
          end
        end
      end
    end
  end
  self.nPlayerActiveState = nPlayerActiveState

  local tbTemp = {}
  self.tbBuyItemList = {}

  for nClass, tbClass in pairs(self.tbPayAwardList) do
    if tbClass.tbAwardList then
      local tbType = tbClass.tbAwardList[self.TYPE_AWARD_BUYITEM]
      if tbType and tbType.tbList then
        for nItem, tbItem in pairs(tbType.tbList) do
          local nEventType = tbItem.nEventType
          local tbEventType = tbType.tbAwardEventType[nEventType]
          local tbInfo = tbItem
          tbInfo.nEventId = tbEventType.nEventId
          tbInfo.nPartId = tbEventType.nPartId
          tbInfo.nAwardState = tbEventType.nAwardState
          table.insert(tbTemp, tbInfo)
        end
      end
    end
  end

  self.tbBuyItemList = tbTemp
  self.nEventOpen = 1

  self:UpdatePayAward()
end

---------------------------------------------------------------------------------------------------
-- Grid part
---------------------------------------------------------------------------------------------------

-- on create
function uiPayAward:OnCreate()
  self.tbBaseAwardGridCont = {}
  self.tbMulOneGridCont = {}
  self.tbBuyItemGridCont = {}

  for i, tbGrid in pairs(self.IMG_GRID_BASEAWARD) do
    self.tbBaseAwardGridCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbGrid[2], 1, 1, nil, "payaward_base")
    self.tbBaseAwardGridCont[i].OnObjGridEnter = self.OnObjGridEnter
    self.tbBaseAwardGridCont[i].ClickMouse = self.ClickMouse
    self.tbBaseAwardGridCont[i].UpdateItem = self.UpdateItem
    self.tbBaseAwardGridCont[i].FormatItem = self.FormatItem
  end

  for i, tbGrid in pairs(self.IMG_GRID_MULONEAWARD) do
    self.tbMulOneGridCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbGrid[2], 1, 1, nil, "payaward_mulone")
    self.tbMulOneGridCont[i].OnObjGridEnter = self.OnObjGridEnter
    self.tbMulOneGridCont[i].UpdateItem = self.UpdateItem
    self.tbMulOneGridCont[i].FormatItem = self.FormatItem
  end

  for i, tbGrid in pairs(self.IMG_GRID_BUYITEMAWARD) do
    self.tbBuyItemGridCont[i] = tbObject:RegisterContainer(self.UIGROUP, tbGrid[2], 1, 1, nil, "payaward_buyitem")
    self.tbBuyItemGridCont[i].OnObjGridEnter = self.OnObjGridEnter
    self.tbBuyItemGridCont[i].UpdateItem = self.UpdateItem
    self.tbBuyItemGridCont[i].FormatItem = self.FormatItem
  end
end

-- on destroy
function uiPayAward:OnDestroy()
  for _, tbCont in pairs(self.tbBaseAwardGridCont) do
    tbObject:UnregContainer(tbCont)
  end

  for _, tbCont in pairs(self.tbMulOneGridCont) do
    tbObject:UnregContainer(tbCont)
  end

  for _, tbCont in pairs(self.tbBuyItemGridCont) do
    tbObject:UnregContainer(tbCont)
  end
end

-- clear all grid obj
function uiPayAward:ClearBaseAwardGrid()
  for i = 1, self.GRID_COUNT do
    local tbObj = self.tbBaseAwardGridCont[i]:GetObj()
    tbAwardInfo:DelAwardInfoObj(tbObj)
    self.tbBaseAwardGridCont[i]:SetObj(nil)
    Img_SetImage(self.UIGROUP, self.IMG_GRID_BASEAWARD[i][2], 1, "")
    Wnd_Hide(self.UIGROUP, self.IMG_GRID_BASEAWARD[i][1])
  end
end

-- clear all grid obj
function uiPayAward:ClearMulOneGrid()
  for i = 1, self.GRID_COUNT do
    local tbObj = self.tbMulOneGridCont[i]:GetObj()
    tbAwardInfo:DelAwardInfoObj(tbObj)
    self.tbMulOneGridCont[i]:SetObj(nil)
    Img_SetImage(self.UIGROUP, self.IMG_GRID_MULONEAWARD[i][2], 1, "")
    Wnd_Hide(self.UIGROUP, self.IMG_GRID_MULONEAWARD[i][1])
  end
end

-- clear all grid obj
function uiPayAward:ClearBuyItemGrid()
  for i = 1, self.GRID_COUNT_BUY do
    local tbObj = self.tbBuyItemGridCont[i]:GetObj()
    tbAwardInfo:DelAwardInfoObj(tbObj)
    self.tbBuyItemGridCont[i]:SetObj(nil)
    Wnd_Hide(self.UIGROUP, self.IMG_GRID_BUYITEMAWARD[i][1])
  end
end

function uiPayAward:ClickMouse(tbObj, nX, nY) end

function uiPayAward:OnObjGridEnter(szWnd, nX, nY)
  local tbObj = nil
  if self.OBJ_INDEX_BASEAWARD[szWnd] then
    local nIndex = self.OBJ_INDEX_BASEAWARD[szWnd]
    tbObj = self.tbBaseAwardGridCont[nIndex]:GetObj(nX, nY)
  elseif self.OBJ_INDEX_MULONEAWARD[szWnd] then
    local nIndex = self.OBJ_INDEX_MULONEAWARD[szWnd]
    tbObj = self.tbMulOneGridCont[nIndex]:GetObj(nX, nY)
  elseif self.OBJ_INDEX_BUYITEMAWARD[szWnd] then
    local nIndex = self.OBJ_INDEX_BUYITEMAWARD[szWnd]
    tbObj = self.tbBuyItemGridCont[nIndex]:GetObj(nX, nY)
  end

  if not tbObj then
    return 0
  end

  local pItem = tbObj.pItem
  if not pItem then
    return 0
  end

  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_NORMAL, tbObj.szBindType))
end

function uiPayAward:FormatItem(tbItem)
  local tbObj = {}
  local pItem = tbItem.pItem
  if not pItem then
    return
  end
  local tbImageParam = GetImageParam(pItem.szIconImage, 1)
  if not tbImageParam then --如果道具图素不存在，则用默认资源替代
    tbObj.szBgImage = self.UNKNOW_ITEM_IMAGE
  else
    tbObj.szBgImage = pItem.szIconImage
  end
  tbObj.szCdSpin = self.CDSPIN_MEDIUM
  tbObj.szCdFlash = self.CDFLASH_MEDIUM

  tbObj.bShowSubScript = 1 -- 如果是可叠加物品则显示下标数字
  if tbItem.bForceHide and tbItem.bForceHide == 1 then
    tbObj.bShowSubScript = 0
  end

  return tbObj
end

function uiPayAward:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem

  -- 不管是否显示叠加数目都把下标设上，以免一些需要中途显示的情况，因为数据同步造成的显示错误
  ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(tbItem.nCount), nX, nY)

  -- 显示背景色
  local nColor = (me.CanUseItem(pItem) ~= 1) and 0x60ff0000 or 0 -- 不可使用道具设置半透明红色背景色
  if me.GetStallPrice(pItem) then
    nColor = 0x30ff8000
    if UiManager:GetUiState(UiManager.UIS_BEGIN_STALL) == 1 then
      nColor = 0x60ffff00 -- 摆摊物品背景色
    end
  elseif me.GetOfferReq(pItem) then
    nColor = 0x3080c0ff
    if UiManager:GetUiState(UiManager.UIS_BEGIN_OFFER) == 1 then
      nColor = 0x60ffff00 -- 收购物品背景色
    end
  end
  ObjGrid_ChangeBgColor(self.szUiGroup, self.szObjGrid, nColor, nX, nY)

  -- TODO: 设置光环

  ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, pItem.szTransparencyIcon, nX, nY) -- 设置透明图层
  ObjGrid_SetMaskLayer(self.szUiGroup, self.szObjGrid, pItem.szMaskLayerIcon, nX, nY) -- 设置掩膜图层

  --设置道具特效
  if pItem.nObjEffect and self.tbEffect[pItem.nObjEffect] then
    ObjGrid_SetTransparency(self.szUiGroup, self.szObjGrid, self.tbEffect[pItem.nObjEffect], nX, nY)
  end
  --	self:UpdateItemCd(pItem.nCdType);		-- 更新CD时间特效	-- TODO: xyf 因为效率问题先注释掉
  -- TODO: xyf 这段代码效率比较高，但是会造成多次打开关闭后不同步
  local nCdTime = Lib:FrameNum2Ms(GetCdTime(pItem.nCdType)) -- 总CD时间
  if nCdTime > 0 then
    local nCdPass = Lib:FrameNum2Ms(me.GetCdTimePass(pItem.nCdType)) -- 已经过CD时间
    ObjGrid_PlayCd(self.szUiGroup, self.szObjGrid, nCdTime, nCdPass, nX, nY)
  end
end

-- create temp item
function uiPayAward:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nBind, nCount, bForceHide)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, -1)
  if not pItem then
    return
  end

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.nCount = nCount or 1

  if nBind == 1 then
    tbObj.szBindType = "获取绑定"
  end

  if bForceHide and bForceHide == 1 then
    tbObj.bForceHide = bForceHide
  end

  return tbObj
end

-- register event
function uiPayAward:RegisterEvent()
  local tbRegEvent = {}
  for i, tbWnd in ipairs(self.IMG_GRID_BASEAWARD) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbBaseAwardGridCont[i]:RegisterEvent())
  end

  for i, tbWnd in ipairs(self.IMG_GRID_MULONEAWARD) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbMulOneGridCont[i]:RegisterEvent())
  end

  for i, tbWnd in ipairs(self.IMG_GRID_BUYITEMAWARD) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbBuyItemGridCont[i]:RegisterEvent())
  end
  return tbRegEvent
end

-- register message
function uiPayAward:RegisterMessage()
  local tbRegMsg = {}
  for i, tbWnd in ipairs(self.IMG_GRID_BASEAWARD) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbBaseAwardGridCont[i]:RegisterEvent())
  end

  local tbRegMsg = {}
  for i, tbWnd in ipairs(self.IMG_GRID_MULONEAWARD) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbMulOneGridCont[i]:RegisterEvent())
  end

  local tbRegMsg = {}
  for i, tbWnd in ipairs(self.IMG_GRID_BUYITEMAWARD) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbBuyItemGridCont[i]:RegisterEvent())
  end

  return tbRegMsg
end
