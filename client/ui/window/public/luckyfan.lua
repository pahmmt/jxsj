-------------------------------------------------------
-- 文件名　：luckyfan.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2009-11-06 11:52:59
-- 文件描述：
-------------------------------------------------------

local tbLuckyFan = Ui:GetClass("luckyfan")
local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem
local tbAwardInfo = Ui.tbLogic.tbAwardInfo
local tbTimer = Ui.tbLogic.tbTimer

tbLuckyFan.IMG_GRID = "ImgGrid"
tbLuckyFan.BTN_CARD = "BtnCard"
tbLuckyFan.IMG_CARD_RESULT = "ImgCardResult"
tbLuckyFan.BTN_START_GAME = "BtnStartGame"
tbLuckyFan.IMG_AWARD_GRID = "ImgAwardGrid"
tbLuckyFan.OBJ_AWARD_GRID = "ObjGrid"
tbLuckyFan.BTN_CLOSE = "BtnClose"
tbLuckyFan.IMG_OBJ = "ImageObj"
tbLuckyFan.TXT_POINT_DESC = "TxtPointWords"

tbLuckyFan.nCardNum = 25
tbLuckyFan.nResultCardNum = 5

tbLuckyFan.tbPic_Card = {
  [0] = "\\image\\ui\\002a\\luckyfan\\img_nopiccard.spr",
  [1] = "\\image\\ui\\002a\\luckyfan\\img_wazi.spr",
  [2] = "\\image\\ui\\002a\\luckyfan\\img_shoutao.spr",
  [3] = "\\image\\ui\\002a\\luckyfan\\img_deer.spr",
  [4] = "\\image\\ui\\002a\\luckyfan\\img_tree.spr",
  [5] = "\\image\\ui\\002a\\luckyfan\\img_snowboy.spr",
  [6] = "\\image\\ui\\002a\\luckyfan\\img_ring.spr",
}

tbLuckyFan.szEffect = "\\image\\effect\\other\\zhuangbeishankuang.spr"
tbLuckyFan.szRandomPic = "\\image\\ui\\002a\\luckyfan\\img_random.spr"
tbLuckyFan.szNorEffect = "\\image\\effect\\other\\new_cheng2.spr"

--tbLuckyFan.tbAwardItemList = {
--	[1] = "\\image\\item\\huodong\\liwuwazi.spr",
--	[2] = "\\image\\item\\huodong\\vn_maozituxueren.spr",
--	[3] = "\\image\\item\\other\\scriptitem\\nuannuanshoutao.spr",
--	[4] = "\\image\\item\\huodong\\vn_weijintoxueren.spr",
--	[5] = "\\image\\item\\huodong\\vn_shengdantang.spr",
--	[6] = "\\image\\item\\other\\scriptitem\\xuehua.spr",
--};

tbLuckyFan.tbAwardItemList = {
  [1] = { 18, 1, 1881, 1 },
  [2] = { 18, 1, 1882, 1 },
  [3] = { 18, 1, 1883, 1 },
  [4] = { 18, 1, 1884, 1 },
  [5] = { 18, 1, 1885, 1 },
  [6] = { 18, 1, 1886, 1 },
}

function tbLuckyFan:OnOpen()
  self.nStartStep = 0
  self:UpdatePanel()
  self:UpdateAwardDesc()
end

function tbLuckyFan:OnClose()
  self:StopLuckyStartTime()
  self:StopRandomShowBigSeq()
  self.nStartStep = 0
end

function tbLuckyFan:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
    return
  elseif szWnd == self.BTN_START_GAME then
    me.CallServerScript({ "ApplyLuckyFan_ActiveGameStep" })
    return
  end

  for i = 1, self.nCardNum do
    local szBtn = self.BTN_CARD .. i
    if szBtn == szWnd then
      me.CallServerScript({ "ApplyLuckyFan_GetOneResultCard", i })
      break
    end
  end
  return
end

function tbLuckyFan:UpdatePanel()
  self:UpdateFanCard()
  self:UpdateBtnState()
end

function tbLuckyFan:UpdateFanCard()
  local tbCardBigSeq = {}
  local tbResultCard = {}
  local nStep = SpecialEvent.XmasLottery2012:GetLuckyFanOneRoundStep(me)

  if nStep == SpecialEvent.XmasLottery2012.DEF_STEP_NOGAME then
    tbCardBigSeq = SpecialEvent.XmasLottery2012:GetResultCardBigSeq(me)
    tbResultCard = SpecialEvent.XmasLottery2012:GetResultCardSmallSeq(me)
  --	elseif (nStep == SpecialEvent.XmasLottery2012.DEF_STEP_SHOW_BEGIN_CARD) then
  --		tbCardBigSeq = SpecialEvent.XmasLottery2012:GetRandomCardBigSeq(me);
  elseif nStep == SpecialEvent.XmasLottery2012.DEF_STEP_GET_CARD then
    if self.nStartStep == 1 then
      tbCardBigSeq = SpecialEvent.XmasLottery2012:GetResultCardBigSeq(me)
    elseif self.nStartStep == 2 then
      self:StartRandomShowBigSeq()
      return
    else
      tbResultCard = SpecialEvent.XmasLottery2012:GetResultCardSmallSeq(me)
      if tbResultCard then
        for i, tbInfo in pairs(tbResultCard) do
          tbCardBigSeq[tbInfo[2]] = tbInfo[1]
        end
      end
    end
  end

  self:StopRandomShowBigSeq()

  for i = 1, self.nCardNum do
    Img_SetImage(self.UIGROUP, self.BTN_CARD .. i, 1, self.tbPic_Card[0])
    Img_SetImgOffset(self.UIGROUP, self.BTN_CARD .. i, 0, 0)
    Wnd_SetEnable(self.UIGROUP, self.IMG_OBJ .. i, 0)
    Wnd_SetVisible(self.UIGROUP, self.IMG_OBJ .. i, 0)
    if nStep == SpecialEvent.XmasLottery2012.DEF_STEP_GET_CARD then
      Wnd_SetEnable(self.UIGROUP, self.BTN_CARD .. i, 1)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTN_CARD .. i, 0)
    end
  end

  for i = 1, self.nResultCardNum do
    Img_SetImage(self.UIGROUP, self.IMG_CARD_RESULT .. i, 1, self.tbPic_Card[0])
    Img_SetImgOffset(self.UIGROUP, self.IMG_CARD_RESULT .. i, 0, 0)
  end

  if tbCardBigSeq then
    for nPos, nItemIndex in pairs(tbCardBigSeq) do
      if nItemIndex > 0 then
        local szPic = self.tbPic_Card[nItemIndex]
        Wnd_SetEnable(self.UIGROUP, self.BTN_CARD .. nPos, 0)
        Img_SetImage(self.UIGROUP, self.BTN_CARD .. nPos, 1, szPic)
        Img_SetImgOffset(self.UIGROUP, self.BTN_CARD .. nPos, 2, 2)
      end
    end
  end

  if tbResultCard then
    for nPos, tbInfo in pairs(tbResultCard) do
      if tbInfo[1] > 0 then
        local szPic = self.tbPic_Card[tbInfo[1]]
        Img_SetImage(self.UIGROUP, self.IMG_CARD_RESULT .. nPos, 1, szPic)
        Img_SetImgOffset(self.UIGROUP, self.IMG_CARD_RESULT .. nPos, 2, 2)
        Wnd_SetEnable(self.UIGROUP, self.IMG_OBJ .. tbInfo[2], 1)
        Wnd_SetVisible(self.UIGROUP, self.IMG_OBJ .. tbInfo[2], 1)
        local szShowEffect = self.szNorEffect
        if tbInfo[1] == 1 then
          szShowEffect = self.szEffect
        end
        Img_SetImage(self.UIGROUP, self.IMG_OBJ .. tbInfo[2], 1, szShowEffect)
        Img_PlayAnimation(self.UIGROUP, self.IMG_OBJ .. tbInfo[2], 1)
        Img_SetImgOffset(self.UIGROUP, self.IMG_OBJ .. tbInfo[2], 2, 2)
      end
    end
  end
end

function tbLuckyFan:UpdateBtnState()
  local nStep = SpecialEvent.XmasLottery2012:GetLuckyFanOneRoundStep(me)
  local nRound = SpecialEvent.XmasLottery2012:GetPlayerTodayGameCount(me)
  local szBtnMsg = string.format("开始(%s/%s)", nRound, SpecialEvent.XmasLottery2012.LOTTERY_MAX_DALIY_COUNT)
  local szDesc = "提示：请点击“开始”按钮，开启你的【对对碰】"
  local nActiveState = 0
  if nStep == SpecialEvent.XmasLottery2012.DEF_STEP_SHOW_BEGIN_CARD then
    szBtnMsg = "进行抽牌"
    nActiveState = 1
  elseif nStep == SpecialEvent.XmasLottery2012.DEF_STEP_GET_CARD then
    szBtnMsg = "游戏中"
    szDesc = "提示：请选择5张想要的圣诞卡片"
    if self.nStartStep == 1 or self.nStartStep == 2 then
      szDesc = "提示：请等待打乱圣诞卡片顺序"
    end
  elseif nStep == SpecialEvent.XmasLottery2012.DEF_STEP_NOGAME then
    nActiveState = 1
    local nAwardFlag = SpecialEvent.XmasLottery2012:GetPlayerAwardType(me)
    if nAwardFlag > 0 then
      szDesc = "根据你选择的5张卡牌图案，可领取参照右图奖励。"
      szBtnMsg = "领取奖励"
    end
  end

  Wnd_SetEnable(self.UIGROUP, self.BTN_START_GAME, nActiveState)
  Btn_SetTxt(self.UIGROUP, self.BTN_START_GAME, szBtnMsg)
  Txt_SetTxt(self.UIGROUP, self.TXT_POINT_DESC, szDesc)
end

function tbLuckyFan:UpdateAwardDesc()
  for i, szPic in pairs(self.tbAwardItemList) do
    local ObjItem = self.OBJ_AWARD_GRID .. i
    --Img_SetImage(self.UIGROUP, ObjItem, 1, szPic);
    local tbCustomItem = self.tbAwardItemList[i]
    Wnd_SetVisible(self.UIGROUP, ObjItem, 1)
    Wnd_SetEnable(self.UIGROUP, ObjItem, 1)
    local pItem = KItem.CreateTempItem(tbCustomItem[1], tbCustomItem[2], tbCustomItem[3], tbCustomItem[4], 0)
    if pItem then
      ObjMx_AddObject(self.UIGROUP, ObjItem, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
    end
  end
end

function tbLuckyFan:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_BINDGOLD_SECTION))
  end
end

function tbLuckyFan:StartGame()
  self:StopLuckyStartTime()
  self.nStartStep = 1
  self:UpdatePanel()
  self.nTimer_PlayerLuckyStartId = tbTimer:Register(3 * 18, self.NextStep, self)
end

function tbLuckyFan:StopLuckyStartTime()
  if self.nTimer_PlayerLuckyStartId and self.nTimer_PlayerLuckyStartId ~= 0 then
    tbTimer:Close(self.nTimer_PlayerLuckyStartId)
    self.nTimer_PlayerLuckyStartId = 0
  end
end

function tbLuckyFan:NextStep()
  if not self.nStartStep or self.nStartStep <= 0 then
    return 0
  end

  self.nStartStep = self.nStartStep + 1
  self:UpdatePanel()
  if self.nStartStep == 2 then
    return
  end
  self.nStartStep = 0
  self.nTimer_PlayerLuckyStartId = 0
  return 0
end

function tbLuckyFan:StartRandomShowBigSeq()
  self:StopRandomShowBigSeq()
  self.nTimer_PlayerRandomShowId = tbTimer:Register(2, self.RandomShowBigSeq, self)
end

function tbLuckyFan:StopRandomShowBigSeq()
  if self.nTimer_PlayerRandomShowId and self.nTimer_PlayerRandomShowId > 0 then
    tbTimer:Close(self.nTimer_PlayerRandomShowId)
    self.nTimer_PlayerRandomShowId = 0
  end
end

function tbLuckyFan:RandomShowBigSeq()
  for i = 1, self.nCardNum do
    local nRandom = MathRandom(6)
    local szRandomPic = self.tbPic_Card[nRandom]
    Img_SetImage(self.UIGROUP, self.BTN_CARD .. i, 1, szRandomPic)
    Img_SetImgOffset(self.UIGROUP, self.BTN_CARD .. i, 2, 2)
    Img_PlayAnimation(self.UIGROUP, self.BTN_CARD .. i, 1)
    Wnd_SetEnable(self.UIGROUP, self.IMG_OBJ .. i, 0)
    Wnd_SetVisible(self.UIGROUP, self.IMG_OBJ .. i, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_CARD .. i, 0)
  end
  return
end
