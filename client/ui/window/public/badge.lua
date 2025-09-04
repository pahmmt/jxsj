-----------------------------------------------------
--文件名	：	badge.lua
--创建者	：	FanJinsong
--创建时间：	2012-8-3
--功能描述：	家族徽章
------------------------------------------------------

local uiBadge = Ui:GetClass("badge")

uiBadge.TXT_BADGE_RULE = "TxtDirection" -- 徽章使用及购买规则说明
uiBadge.TXT_KIN_MONEY = "TxtKinMoney" -- 家族银两
uiBadge.TXT_PAGE = "TxtPage" -- 页数文本框
uiBadge.BTN_CLOSE = "BtnClose" -- 关闭按钮
uiBadge.ImageEffectBadge = "ImageEffectBadge" -- 徽章图片
uiBadge.BtnBadge = "BtnBadge" -- 徽章按钮
uiBadge.ImageBadge = "ImageBadge" --徽章底图
uiBadge.BTN_ONE = "BtnOne" -- 1级徽章
uiBadge.BTN_TWO = "BtnTwo" -- 2级徽章
uiBadge.BTN_THREE = "BtnThree" -- 3级徽章
uiBadge.BTN_PAGE_UP = "BtnUp" -- 按钮 上一页
uiBadge.BTN_PAGE_DOWN = "BtnDown" -- 按钮 下一页
uiBadge.BTN_OK = "BtnOk" -- 确定
uiBadge.BTN_CANCEL = "BtnCancel" -- 取消

uiBadge.PAGE_BADGE_BUY = "PageBadgeBuy" -- 购买小图框
uiBadge.TXT_PRICE = "TxtPrice" -- 徽章单价
uiBadge.BTN_BUY = "BtnBuy" -- 购买

uiBadge.tbButtonPagList = { uiBadge.BTN_ONE, uiBadge.BTN_TWO, uiBadge.BTN_THREE }

-- 位置相关参数
uiBadge.BeginX = 30
uiBadge.BeginY = 225
uiBadge.BlankX = 105
uiBadge.BlankY = 95

uiBadge.nPage = 0 -- 第几页，0为第一页
uiBadge.nPageBadgeNum = 15 -- 每一页15个徽章

uiBadge.nRecord1 = 1 -- 1级徽章购买记录
uiBadge.nRecord2 = 0 -- 2级徽章购买记录
uiBadge.nRecord3 = 0 -- 3级徽章购买记录

function uiBadge:OnOpen()
  -- 1 是按下，0 是未按下
  self.pKin = KKin.GetSelfKin()
  if not self.pKin then
    return 0
  end
  self:Init()
  self:UpdateBtnCheck()
  self:UpdateBadgeInfo()
  self:RefreshBadgeRule(1)
  Wnd_SetEnable(self.UIGROUP, self.BTN_PAGE_UP, 0)
  Wnd_Hide(self.UIGROUP, self.PAGE_BADGE_BUY) -- 隐藏购买小图框
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE, string.format("%d/2", self.nPage + 1))
end

function uiBadge:Init()
  self.nBadgeType = 1 -- 徽章类型： 1：1级徽章；2：2级徽章；3：3级徽章
  self.nSelectBadge = 0 -- 选择徽章
  self.nRight = 0 -- 徽章购买资格，1 满足资格；0 不满足资格
  self.nBtnState = 1 -- 按钮状态
  self:InitBtnState() -- 初始化按钮状态；定确和购买
  self.nRecord1 = 1
  self.nRecord2 = 0
  self.nRecord3 = 0
  self.nPage = 0
  self:InitBadgeRecord(1)
end

function uiBadge:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP) -- 关闭窗口
  elseif szWnd == self.BTN_CANCEL then
    UiManager:CloseWindow(self.UIGROUP) -- 关闭窗口
  elseif szWnd == self.BTN_OK then
    self:SynServer() -- 向同步服务器数据
    UiManager:CloseWindow(self.UIGROUP) -- 关闭窗口
  elseif szWnd == self.BTN_ONE then
    self.nBadgeType = 1
    self.nPage = 0
    self.nBtnState = 1
    self:RefreshBadgeRule(self.nBadgeType)
    self:InitBadgeRecord(self.nBadgeType)
    self:UpdateBadgeInfo()
    self:UpdateBtnCheck()
  elseif szWnd == self.BTN_TWO then
    self.nBadgeType = 2
    self.nPage = 0
    self.nBtnState = 2
    self:RefreshBadgeRule(self.nBadgeType)
    self:InitBadgeRecord(self.nBadgeType)
    self:UpdateBadgeInfo()
    self:UpdateBtnCheck()
  elseif szWnd == self.BTN_THREE then
    self.nBadgeType = 3
    self.nPage = 0
    self.nBtnState = 3
    self:RefreshBadgeRule(self.nBadgeType)
    self:InitBadgeRecord(self.nBadgeType)
    self:UpdateBadgeInfo()
    self:UpdateBtnCheck()
  elseif szWnd == self.BTN_PAGE_UP then
    self.nPage = self.nPage - 1
    if self.nPage <= 0 then
      self.nPage = 0
    end
    self:UpdateBadgeInfo()
    self:UpdateBtnCheck()
    Wnd_SetEnable(self.UIGROUP, self.BTN_OK, self.nRight) -- 确定按钮 可用
  elseif szWnd == self.BTN_PAGE_DOWN then
    self.nPage = self.nPage + 1
    if self.nPage >= 1 then
      self.nPage = 1
    end
    self:UpdateBadgeInfo()
    self:UpdateBtnCheck()
    Wnd_SetEnable(self.UIGROUP, self.BTN_OK, self.nRight) -- 确定按钮 可用
  elseif szWnd == self.BTN_BUY then
    Wnd_Hide(self.UIGROUP, self.PAGE_BADGE_BUY)
    Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 1) -- 确定按钮 可用
    Btn_Check(self.UIGROUP, self.BtnBadge .. self.nSelectBadge, 0)
    self:BadgeBuy()
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 0)
    Wnd_Hide(self.UIGROUP, self.PAGE_BADGE_BUY)
    for i = 1, self.nPageBadgeNum do
      local szBtnName = self.BtnBadge .. i
      if szWnd == szBtnName then
        self.nSelectBadge = i
        self:ShowBuyPage(i)
      else
        Btn_Check(self.UIGROUP, szBtnName, 0)
      end
    end
  end

  if szWnd == self.BTN_ONE or szWnd == self.BTN_TWO or szWnd == self.BTN_THREE then
    self:UpdateBtnCheck()
  end
end

function uiBadge:GetSelfKinFigure()
  return me.nKinFigure
end

function uiBadge:InitBtnState()
  local nFigure = self:GetSelfKinFigure()
  if nFigure >= Kin.FIGURE_ASSISTANT then
    Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_BUY, 0)
  end
end

function uiBadge:RefreshBadgeRule(nRate)
  if not nRate or nRate <= 0 or nRate > 3 then
    return
  end
  if not self.pKin then
    return 0
  end

  self.nRight = 1 -- 先初始化为1
  local szRule = ""
  local nRegular, nSigned, nRetire = self.pKin.GetMemberCount()
  if 1 == nRate then
    -- 1级徽章
    szRule = szRule .. "<color=239,180,52>" .. "1级徽章说明" .. "<color>\n"
    szRule = szRule .. "    购买&使用资格：<color=green>" .. "  无资格限制" .. "<color>\n"
    szRule = szRule .. "    购买后若玩家不再满足使用资格，系统会禁用该徽章直到玩家再次达到使用资格。"
  elseif 2 == nRate then
    -- 2级徽章
    szRule = szRule .. "<color=239,180,52>" .. "2级徽章说明" .. "<color>\n"
    if nRegular >= Kin.nBuyLimitPlayerCount2 then
      szRule = szRule .. "    购买&使用资格：<color=green>" .. "  正式成员达到30人" .. "<color>\n"
    else
      self.nRight = 0
      szRule = szRule .. "    购买&使用资格：<color=red>" .. "  正式成员达到30人" .. "<color>\n"
    end
    szRule = szRule .. "    购买后若玩家不再满足使用资格，系统会禁用该徽章直到玩家再次达到使用资格。"
  else
    -- 3级徽章
    szRule = szRule .. "<color=239,180,52>" .. "3级徽章说明" .. "<color>\n"
    if nRegular >= Kin.nBuyLimitPlayerCount3 then
      szRule = szRule .. "    购买&使用资格：<color=green>" .. "  正式成员达到50人" .. "<color>\n"
    else
      self.nRight = 0
      szRule = szRule .. "    购买&使用资格：<color=red>" .. "  正式成员达到50人" .. "<color>\n"
    end
    szRule = szRule .. "    购买后若玩家不再满足使用资格，系统会禁用该徽章直到玩家再次达到使用资格。"
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_BADGE_RULE, szRule)
  Wnd_SetEnable(self.UIGROUP, self.BTN_BUY, self.nRight)
  Wnd_SetEnable(self.UIGROUP, self.BTN_OK, self.nRight)
end

function uiBadge:UpdateBtnCheck()
  for i = 1, #self.tbButtonPagList do
    if self.nBtnState == i then
      Btn_Check(self.UIGROUP, self.tbButtonPagList[i], 1)
    else
      Btn_Check(self.UIGROUP, self.tbButtonPagList[i], 0)
    end
  end

  Wnd_Hide(self.UIGROUP, self.PAGE_BADGE_BUY)

  Btn_Check(self.UIGROUP, self.BtnBadge .. self.nSelectBadge, 0)

  Wnd_SetEnable(self.UIGROUP, self.BTN_PAGE_UP, self.nPage)
  Wnd_SetEnable(self.UIGROUP, self.BTN_PAGE_DOWN, 1 - self.nPage)
  Txt_SetTxt(self.UIGROUP, self.TXT_PAGE, string.format("%d/2", self.nPage + 1))
end

function uiBadge:UpdateBadgeInfo()
  if not self.pKin then
    self.pKin = KKin.GetSelfKin()
  end
  local nTemp = 1
  local nRecord = 0
  if self.nBadgeType == 1 then
    nRecord = self.nRecord1
  elseif self.nBadgeType == 2 then
    nRecord = self.nRecord2
  else
    nRecord = self.nRecord3
  end
  for nBit = self.nPage * self.nPageBadgeNum, (self.nPage + 1) * self.nPageBadgeNum - 1 do
    if Lib:LoadBits(nRecord, nBit, nBit) == 1 then
      Img_SetImage(self.UIGROUP, self.ImageEffectBadge .. nTemp, 1, Kin.tbKinBadge[self.nBadgeType * 10000 + nBit + 1].BrightBadge)
      Img_SetFrame(self.UIGROUP, self.ImageBadge .. nTemp, 1)
    else
      Img_SetImage(self.UIGROUP, self.ImageEffectBadge .. nTemp, 1, Kin.tbKinBadge[self.nBadgeType * 10000 + nBit + 1].GrayBadge)
      Img_SetFrame(self.UIGROUP, self.ImageBadge .. nTemp, 0)
    end
    if nTemp == 15 then
      break
    end
    nTemp = nTemp + 1
  end
  local nKinMoney = 0
  if self.pKin then
    nKinMoney = self.pKin.GetMoneyFund()
  end
  local szFund = Item:FormatMoney(nKinMoney)
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_MONEY, "家族资金：" .. szFund)
end

function uiBadge:SynServer()
  local nId = self.nPage * 15 + self.nSelectBadge
  me.CallServerScript({ "KinCmd", "SetKinBadge", nId, self.nBadgeType })
end

function uiBadge:ShowBuyPage(nParam)
  -- nParam 范围 1~15
  -- 根据 nParam 获取购买 徽章， 计算小图框显示的位置
  local x = (nParam - 1) % 5
  local y = (nParam - 1) / 5
  y = y - y % 1 -- 取整
  if self.nBadgeType == 1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_PRICE, "100万银两")
  elseif self.nBadgeType == 2 then
    Txt_SetTxt(self.UIGROUP, self.TXT_PRICE, "500万银两")
  elseif self.nBadgeType == 3 then
    Txt_SetTxt(self.UIGROUP, self.TXT_PRICE, "2000万银两")
  end

  local nId = self.nPage * self.nPageBadgeNum + nParam
  local nRecord = 0
  local nAddRecord = 10000
  if self.nBadgeType == 1 then
    nRecord = self.nRecord1
  elseif self.nBadgeType == 2 then
    nRecord = self.nRecord2
    nAddRecord = 20000
  else
    nRecord = self.nRecord3
    nAddRecord = 30000
  end

  if Lib:LoadBits(nRecord, nId - 1, nId - 1) == 0 and self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    Wnd_Show(self.UIGROUP, self.PAGE_BADGE_BUY) -- 购买小图框显示
    Wnd_SetPos(self.UIGROUP, self.PAGE_BADGE_BUY, self.BeginX + x * self.BlankX, self.BeginY + y * self.BlankY)
  else
    if self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
      Wnd_SetEnable(self.UIGROUP, self.BTN_OK, 1) -- 确定按钮 可用
    end
  end
  Wnd_Show(Ui.UI_KIN, Ui(Ui.UI_KIN).IMG_BADGE)
  Img_SetImage(Ui.UI_KIN, Ui(Ui.UI_KIN).IMG_BADGE, 1, Kin.tbKinBadge[nId + nAddRecord].BrightBadge)
  Wnd_Hide(Ui.UI_KIN, Ui(Ui.UI_KIN).TXT_BADGE)
end

function uiBadge:BadgeBuy()
  local nId = self.nPage * self.nPageBadgeNum + self.nSelectBadge
  me.CallServerScript({ "KinCmd", "BuyBadge", nId, self.nBadgeType })
end

function uiBadge:GetBadgeRecord(nRate)
  if not self.pKin then
    return 0
  end
  local nRecord = 1
  if nRate == 1 then
    nRecord = self.pKin.GetBadgeRecord1()
    nRecord = Lib:SetBits(nRecord, 1, 0, 0) -- 保证1级第一个徽章是无任何使用限制
  elseif nRate == 2 then
    nRecord = self.pKin.GetBadgeRecord2()
  else
    nRecord = self.pKin.GetBadgeRecord3()
  end
  return nRecord
end

function uiBadge:InitBadgeRecord(nRate)
  if nRate <= 0 or nRate > 3 then
    print("徽章等级参数错误！")
    return
  end
  local nRecord = self:GetBadgeRecord(nRate)
  if nRecord < 0 or nRecord > 1073741823 then -- 30个1 十进制整数为 1073741823
    print("徽章记录参数错误！")
    return
  end
  if nRate == 1 then
    self.nRecord1 = nRecord
  elseif nRate == 2 then
    self.nRecord2 = nRecord
  else
    self.nRecord3 = nRecord
  end
end

function uiBadge:GetGroupNumber(nGroupType)
  if not self.pKin then
    UiManager:CloseWindow(self.UIGROUP)
    return 0
  end

  local nRetCount = 0
  local nRegular, nSigned, nRetire, nCaptain, nAssistant = self.pKin.GetMemberCount()
  if nGroupType == 1 then
    nRetCount = nCaptain
  elseif nGroupType == 2 then
    nRetCount = nAssistant
  elseif nGroupType == 3 then
    nRetCount = nRegular
  elseif nGroupType == 4 then
    nRetCount = nSigned
  elseif nGroupType == 5 then
    nRetCount = nRetire
  elseif nGroupType == 6 then
    nRetCount = nSigned + nRetire + nRegular
  end
  if nGroupType == 3 then
    if me.nKinFigure <= nGroupType then
      nRetCount = nRetCount - 1
    end
  elseif me.nKinFigure == nGroupType or nGroupType == 6 then
    nRetCount = nRetCount - 1
  end
  if nRetCount < 0 then
    nRetCount = 0
  end
  return nRetCount
end

function uiBadge:RefreshFund_C2(nFund)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  local szFund = Item:FormatMoney(nFund)
  Txt_SetTxt(self.UIGROUP, self.TXT_KIN_MONEY, "家族资金：" .. szFund)
end

function uiBadge:OnClose()
  -- 更新家族徽章
  --跟新家族界面的徽章按钮
  Wnd_SetEnable(Ui.UI_KIN, Ui(Ui.UI_KIN).BTN_BADGE, 1)
  Ui(Ui.UI_KIN).nBadgeFlage = 0
  if not self.pKin then
    return
  end
  local nKinBadge = self.pKin.GetKinBadge()
  if nKinBadge and nKinBadge ~= 0 and Kin.tbKinBadge[nKinBadge] then
    Img_SetImage(Ui.UI_KIN, Ui(Ui.UI_KIN).IMG_BADGE, 1, Kin.tbKinBadge[nKinBadge].BrightBadge)
    Wnd_Hide(Ui.UI_KIN, Ui(Ui.UI_KIN).TXT_BADGE)
  else
    Wnd_Hide(Ui.UI_KIN, Ui(Ui.UI_KIN).IMG_BADGE)
    Wnd_Show(Ui.UI_KIN, Ui(Ui.UI_KIN).TXT_BADGE)
  end
end
