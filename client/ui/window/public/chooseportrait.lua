-----------------------------------------------------
--文件名		：	buffbar.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	玩家Buff
------------------------------------------------------

local uiChoosePortrait = Ui:GetClass("chooseportrait")
local tbObject = Ui.tbLogic.tbObject
local tbViewPlayerMgr = Ui.tbLogic.tbViewPlayerMgr

uiChoosePortrait.BTN_NORMAL_PORTRAIT = "BtnSelPortrait"
uiChoosePortrait.BTN_MY_PORTRAIT = "BtnSelMyPortrait"
uiChoosePortrait.IMG_NORMAL_PORTRAIT = "ImgPort"
uiChoosePortrait.IMG_MY_PORTRAIT = "ImgMyPortrait"
uiChoosePortrait.CLOSE_BUTTON = "BtnClose"

uiChoosePortrait.SPR_HIGH_IMG = "\\image\\ui\\002a\\myportrait\\highimg.spr"
uiChoosePortrait.SPR_NORMAL_IMG = "\\image\\ui\\002a\\relation\\img_frame.spr"

uiChoosePortrait.MAX_NUM_NORMAL_PORTRAIT = 10
uiChoosePortrait.MAX_NUM_MY_PORTRAIT = 2
uiChoosePortrait.tbMaxNum = {
  [Env.SEX_MALE] = 9,
  [Env.SEX_FEMALE] = 8,
}

function uiChoosePortrait:OnOpen()
  OnSelPortrait(1)
  self.nSelIndex = me.nPortrait
  self:ResetPortraitState()
  local nSex = me.nSex
  self:ShowPortraitList(nSex)
end

function uiChoosePortrait:OnClose()
  OnSelPortrait(0) -- 参数 1 打开头像选择界面, 0 为关闭选择界面
end

function uiChoosePortrait:OnButtonClick(szWnd, nParam)
  if szWnd == self.CLOSE_BUTTON then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end
  for i = 1, self.MAX_NUM_NORMAL_PORTRAIT do
    local szBtn = self.BTN_NORMAL_PORTRAIT .. i
    if szWnd == szBtn then
      self:SelNormalPortrait(i)
      UiManager:CloseWindow(self.UIGROUP)
      return
    end
  end

  for i = 1, self.MAX_NUM_MY_PORTRAIT do
    local szBtn = self.BTN_MY_PORTRAIT .. i
    if szWnd == szBtn then
      local tbSns = Sns:GetSnsObject(i)
      local szTokenKey = tbSns:GetTokenKey()
      if #szTokenKey == 0 then
        Ui(Ui.UI_SNS_ENTRANCE):OpenSNSmain()
      else
        self:SelNormalPortrait(100 + i)
      end
      UiManager:CloseWindow(self.UIGROUP)
    end
  end
end

function uiChoosePortrait:SelNormalPortrait(nSelIndex)
  SetPortraitIndex(nSelIndex)
end

function uiChoosePortrait:ResetPortraitState()
  for i = 1, self.MAX_NUM_NORMAL_PORTRAIT do
    Wnd_SetEnable(self.UIGROUP, self.BTN_NORMAL_PORTRAIT .. i, 0)
    Wnd_Hide(self.UIGROUP, self.BTN_NORMAL_PORTRAIT .. i)
    self:HighSelImg(self.IMG_NORMAL_PORTRAIT .. i, 0)
  end

  for i = 1, self.MAX_NUM_MY_PORTRAIT do
    --Wnd_SetEnable(self.UIGROUP, self.BTN_MY_PORTRAIT .. i, 0);
    self:HighSelImg(self.IMG_MY_PORTRAIT .. i, 0)
  end
end

function uiChoosePortrait:ShowPortraitList(nSex)
  if nSex < 0 or nSex > 1 then
    assert(false)
  end
  local nSelIndex = me.nPortrait
  local nSex = me.nSex
  for i = 1, self.MAX_NUM_NORMAL_PORTRAIT do
    self:SetNormalPortraitImg(i, nSex)
    if i == nSelIndex then
      self:HighSelImg(self.IMG_NORMAL_PORTRAIT .. i, 1)
    end
  end

  for i = 1, self.MAX_NUM_MY_PORTRAIT do
    self:SetMyPortraitImg(i)
    local nIndex = 100 + i
    if nIndex == nSelIndex then
      self:HighSelImg(self.IMG_MY_PORTRAIT .. i, 1)
    end
  end
end

function uiChoosePortrait:HighSelImg(szWnd, nIsHigh)
  if nIsHigh == 1 then
    Img_SetImage(self.UIGROUP, szWnd, 1, self.SPR_HIGH_IMG)
  else
    Img_SetImage(self.UIGROUP, szWnd, 1, self.SPR_NORMAL_IMG)
  end
end

function uiChoosePortrait:SetNormalPortraitImg(nIndex, nSex)
  if self.tbMaxNum[nSex] < nIndex then
    return
  end

  local szPath = GetPortraitSpr(nIndex, nSex)

  if not szPath or szPath == "" then
    return
  end

  Wnd_SetEnable(self.UIGROUP, self.BTN_NORMAL_PORTRAIT .. nIndex, 1)
  Wnd_Show(self.UIGROUP, self.BTN_NORMAL_PORTRAIT .. nIndex)
  Img_SetImage(self.UIGROUP, self.BTN_NORMAL_PORTRAIT .. nIndex, 1, szPath)
  Img_SetImgOffsetX(self.UIGROUP, self.BTN_NORMAL_PORTRAIT .. nIndex, -9)
end

function uiChoosePortrait:SetMyPortraitImg(nIndex)
  if Sns.bIsOpen == 0 then
    return
  end

  local nSelIndex = 100 + nIndex
  local szSnsPath, nType = tbViewPlayerMgr:GetMyPortraitSpr(nSelIndex, nSex)

  if 0 == nType then
    if IsDownLoadFileExist(szSnsPath) == 1 then
      Wnd_SetEnable(self.UIGROUP, self.BTN_MY_PORTRAIT .. nIndex, 1)
    end
  end

  Img_SetImage(self.UIGROUP, self.BTN_MY_PORTRAIT .. nIndex, nType, szSnsPath)
end
