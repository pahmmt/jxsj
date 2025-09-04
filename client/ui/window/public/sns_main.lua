-----------------------------------------------------
--文件名		：	sns_main.lua
--创建者		：	wangzhiguang
--创建时间		：	2011-03-18
--功能描述		：	SNS功能发消息主界面
------------------------------------------------------

local uiSnsMain = Ui:GetClass("sns_main") -- 这样写支持重载

uiSnsMain.EDIT_TWEET = "EdtTweet"
uiSnsMain.TXT_COUNT = "TxtCount"
uiSnsMain.BUTTON_TWEET = "BtnTweet"
uiSnsMain.BUTTON_CLOSE = "BtnClose"
uiSnsMain.IMAGE_SCREEN = "ImgScreen"
uiSnsMain.BUTTON_SCREEN = "BtnScreen"
uiSnsMain.BUTTON_RELOAD_SCRIPT = "BtnReloadScript"

uiSnsMain.BUTTON_TTENCENT_CHECK = "BtnTTencent"
uiSnsMain.BUTTON_TTENCENT_PIC = "BtnTTencentPic"
uiSnsMain.BUTTON_TTENCENT_AUTH = "BtnTTencentAuth"

uiSnsMain.BUTTON_TSINA_CHECK = "BtnTSina"
uiSnsMain.BUTTON_TSINA_PIC = "BtnTSinaPic"
uiSnsMain.BUTTON_TSINA_AUTH = "BtnTSinaAuth"

uiSnsMain.TXT_HELP = "TxtHelp"

uiSnsMain.nPopUpTipId = 123

uiSnsMain.tbTxtList = {
  "谁主红尘，谁是英雄。",
  "酒饮一坛当胸醉，沙场江山笑谈中。",
  "清凉MM怒战群雄，瞬间hold住全场。",
  "10M客户端30秒轻松下载，教你1秒钟变大侠。",
  "天涯路漫漫，谁人与我仗剑天涯路。",
  "豪情万丈风雨路，你来或不来，我都在这儿等你。http://jxsj.xoyo.com/",
  "国内第一2D武侠巨作，仗剑、豪情、侠义、欢喜，你来我就在这里等你。",
  "这里是五千万人的江湖，萝莉御姐任你挑选，抱个妞儿回家过冬咯！",
}

function uiSnsMain:OnCreate()
  local tb = {
    [Sns.SNS_T_TENCENT] = { self.BUTTON_TTENCENT_CHECK, self.BUTTON_TTENCENT_PIC, self.BUTTON_TTENCENT_AUTH },
    [Sns.SNS_T_SINA] = { self.BUTTON_TSINA_CHECK, self.BUTTON_TSINA_PIC, self.BUTTON_TSINA_AUTH },
  }
  self.tbSnsControl = tb
end

function uiSnsMain:OnDestroy() end

function uiSnsMain:OnClose()
  self.szTweet = Edt_GetTxt(self.UIGROUP, self.EDIT_TWEET)
end

function uiSnsMain:OnOpen(szTweet, nSnsIdForPopupTip)
  if Sns.bIsOpen == 0 then
    return
  end

  if not szTweet then
    szTweet = "" --self:GetRandomTxt();		--关闭随机话语
  end

  --此按钮调试用
  Wnd_SetVisible(self.UIGROUP, self.BUTTON_RELOAD_SCRIPT, 0)

  Wnd_SetTip(self.UIGROUP, self.IMAGE_SCREEN, "点击查看原图")
  self:ShowThumb()
  Wnd_SetFocus(self.UIGROUP, self.EDIT_TWEET)
  Edt_SetTxt(self.UIGROUP, self.EDIT_TWEET, szTweet or self.szTweet)

  self:SetSnsControlState()
  self:SetTweetButtonState()

  if nSnsIdForPopupTip then
    if nSnsIdForPopupTip == Sns.SNS_T_SINA then
      Ui.tbLogic.tbPopMgr:ShowPopTip(124)
    elseif nSnsIdForPopupTip == Sns.SNS_T_TENCENT then
      Ui.tbLogic.tbPopMgr:ShowPopTip(125)
    end
  end
end

function uiSnsMain:SetTweetButtonState()
  local nEnable = 0
  if self:ProcessTweetLength() > 0 then
    for nSnsId, tbControl in ipairs(self.tbSnsControl) do
      local szCheckBox = tbControl[1]
      if Wnd_Visible(self.UIGROUP, szCheckBox) == 1 and Btn_GetCheck(self.UIGROUP, szCheckBox) == 1 then
        nEnable = 1
        break
      end
    end
  end
  Wnd_SetEnable(self.UIGROUP, self.BUTTON_TWEET, nEnable)
end

function uiSnsMain:PlayAuthButtonAnimation(nSeconds)
  Img_PlayAnimation(self.UIGROUP, self.BUTTON_TSINA_AUTH, 1, 300, 0, 1)
  local function StopAnimation()
    Img_StopAnimation(self.UIGROUP, self.BUTTON_TSINA_AUTH)
    return 0
  end
  Ui.tbLogic.tbTimer:Register(18 * nSeconds, StopAnimation)
end

function uiSnsMain:SetSnsControlState()
  local nAuthCount = 0
  for nSnsId, tbControl in ipairs(self.tbSnsControl) do
    local tbSns = Sns:GetSnsObject(nSnsId)
    local szTokenKey = tbSns:GetTokenKey()
    if #szTokenKey == 0 then
      --未授权
      Btn_Check(self.UIGROUP, tbControl[1], 0)
      Wnd_SetVisible(self.UIGROUP, tbControl[1], 0)
      Wnd_SetEnable(self.UIGROUP, tbControl[2], 0)
      Wnd_SetVisible(self.UIGROUP, tbControl[3], 1)
    else
      --已授权
      Btn_Check(self.UIGROUP, tbControl[1], 1)
      Wnd_SetVisible(self.UIGROUP, tbControl[1], 1)
      Wnd_SetEnable(self.UIGROUP, tbControl[2], 1)
      Wnd_SetVisible(self.UIGROUP, tbControl[3], 0)
      nAuthCount = nAuthCount + 1
    end
  end
  --如果都没有授权则闪烁按钮
  if nAuthCount == 0 then
    --self:PlayAuthButtonAnimation(5);

    local function ShowPopTip()
      Ui.tbLogic.tbPopMgr:ShowPopTip(self.nPopUpTipId)
      return 0
    end
    Ui.tbLogic.tbTimer:Register(5, ShowPopTip)
  end
end

function uiSnsMain:OnEditChange(szWnd, nParam)
  if szWnd == self.EDIT_TWEET then
    self:SetTweetButtonState()
  end
end

function uiSnsMain:ProcessTweetLength()
  local nLenW = Edt_GetCurrentLenW(self.UIGROUP, self.EDIT_TWEET)
  local nRemain = 130 - nLenW
  local szText = string.format("还能输入<color=yellow>%d<color>字", nRemain)
  Txt_SetTxt(self.UIGROUP, self.TXT_COUNT, szText)
  local szTweet = Edt_GetTxt(self.UIGROUP, self.EDIT_TWEET)
  --trim掉空格来限制输入，因为SNS服务端可能拒绝纯空格的内容
  szTweet = string.match(szTweet, "[^\r\n ]+")
  return szTweet == nil and 0 or nLenW
end

function uiSnsMain:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    self:Close()
  elseif szWnd == self.BUTTON_SCREEN then
    self:OnButtonScreenClick()
  elseif szWnd == self.IMAGE_SCREEN then
    self:ShowFullImage()
  elseif szWnd == self.BUTTON_TTENCENT_PIC then
    self:GoToSnsWebsite(Sns.SNS_T_TENCENT)
  elseif szWnd == self.BUTTON_TSINA_PIC then
    self:GoToSnsWebsite(Sns.SNS_T_SINA)
  elseif szWnd == self.BUTTON_TTENCENT_AUTH then
    self:AuthSns(Sns.SNS_T_TENCENT)
  elseif szWnd == self.BUTTON_TSINA_AUTH then
    self:AuthSns(Sns.SNS_T_SINA)
  elseif szWnd == self.BUTTON_TWEET then
    self:Tweet()
  elseif szWnd == self.BUTTON_TTENCENT_CHECK or szWnd == self.BUTTON_TSINA_CHECK then
    self:SetTweetButtonState()
  elseif szWnd == self.TXT_HELP then
    self:ShowHelp()
  elseif szWnd == self.BUTTON_RELOAD_SCRIPT then
    self:ReloadScript()
  end
end

function uiSnsMain:Close()
  UiManager:CloseWindow(self.UIGROUP)
end

function uiSnsMain:HasImage()
  return (self.szImagePath and self.szThumbPath) and 1 or 0
end

function uiSnsMain:OnButtonScreenClick()
  if self:HasImage() == 1 then
    Btn_SetTxt(self.UIGROUP, self.BUTTON_SCREEN, "开始截图")
    self:DeleteScreen()
  else
    Btn_SetTxt(self.UIGROUP, self.BUTTON_SCREEN, "删除截图")
    self:BeginSaveScreen()
  end
end

--开始截屏
function uiSnsMain:BeginSaveScreen()
  UiManager:CloseWindow(self.UIGROUP)
  --进入截屏状态
  UiManager:SetUiState(UiManager.UIS_CAPTURE_SCREEN)
end

--截图完成后的回调
function uiSnsMain:OnSaveScreenComplete(tbImageInfo, bOpenWindow)
  if not tbImageInfo then
    return
  end

  --相框的尺寸(参见sns_main.ini)
  local nMaxWidth = 204
  local nMaxHeight = 153

  local nFrameRatio = nMaxWidth / nMaxHeight
  local nRatio = tbImageInfo.nWidth / tbImageInfo.nHeight

  local nThumbWidth, nThumbHeight = nMaxWidth, nMaxHeight
  self.nOffsetX, self.nOffsetY = 0, 0
  --更宽，上下出现黑边，需要Y轴偏移
  if nRatio > nFrameRatio then
    nThumbHeight = nThumbWidth / nRatio
    self.nOffsetY = (nMaxHeight - nThumbHeight) / 2
  --更窄，左右出现黑边，需要X轴偏移
  elseif nRatio < nFrameRatio then
    nThumbWidth = nThumbHeight * nRatio
    self.nOffsetX = (nMaxWidth - nThumbWidth) / 2
  end

  --缩放图像，维持原比例
  local szThumbBuffer = Image_Resize(tbImageInfo.szBuffer, tbImageInfo.nWidth, tbImageInfo.nHeight, nThumbWidth, nThumbHeight, 0)

  local szThumbPath = GetPlayerPrivatePath() .. GetLocalDate("%Y-%m-%d_%H-%M-%S_thumb.jpg")
  local szThumbFullPath = GetRootPath() .. szThumbPath
  Image_SaveBuffer2File(szThumbFullPath, szThumbBuffer, nThumbWidth, nThumbHeight, 1)

  self:SetScreen(tbImageInfo.szPath, szThumbFullPath)

  if bOpenWindow == 1 then
    UiManager:OpenWindow(self.UIGROUP, self.szTweet)
  end
end

function uiSnsMain:SetScreen(szImagePath, szThumbPath)
  self.szImagePath = szImagePath
  self.szThumbPath = szThumbPath
  self:ShowThumb()
  --这里不能马上删除缩略图，否则文件在缓存中超时后就没有数据源了
  if self.szLastThumbPath then
    DeleteLocalFile(self.szLastThumbPath)
  end
  self.szLastThumbPath = szThumbPath
  self:SaveScreenFilePath(szThumbPath)
end

function uiSnsMain:DeleteTweet()
  self.szTweet = nil
  Edt_SetTxt(self.UIGROUP, self.EDIT_TWEET, "")
end

function uiSnsMain:DeleteScreen()
  self.szImagePath = nil
  self.szThumbPath = nil
  self:ShowThumb()
end

function uiSnsMain:GetImagePath()
  return self.szImagePath
end

function uiSnsMain:ShowThumb()
  if self:HasImage() == 1 then
    --设置缩略图偏移
    if self.nOffsetX and self.nOffsetY then
      Img_SetImgOffset(self.UIGROUP, self.IMAGE_SCREEN, self.nOffsetX, self.nOffsetY)
    end
    Img_SetImage(self.UIGROUP, self.IMAGE_SCREEN, 0, self.szThumbPath)
    Wnd_SetVisible(self.UIGROUP, self.IMAGE_SCREEN, 1)
    Btn_SetTxt(self.UIGROUP, self.BUTTON_SCREEN, "删除截图")
  else
    Wnd_SetVisible(self.UIGROUP, self.IMAGE_SCREEN, 0)
    Btn_SetTxt(self.UIGROUP, self.BUTTON_SCREEN, "开始截图")
  end
end

function uiSnsMain:ShowFullImage()
  local szImagePath = self:GetImagePath()
  if not szImagePath then
    return
  end
  OpenLocalFile(szImagePath)
end

function uiSnsMain:GoToSnsWebsite(nSnsId)
  local tbSns = Sns:GetSnsObject(nSnsId)
  local szAccount = Sns.tbAccount[nSnsId]
  if szAccount then
    local szUrl = tbSns:GetUrl_AccountHome(szAccount)
    Sns:GoToUrl(szUrl)
  else
    Sns:GoToUrl(tbSns.URL_HOMEPAGE)
  end
end

function uiSnsMain:AuthSns(nSnsId)
  self:Close()
  UiManager:OpenWindow(Ui.UI_SNS_VERIFIER, nSnsId)
end

function uiSnsMain:Tweet()
  local thatSelf = self
  --确认框
  local tbMsg = {
    szMsg = "确定分享吗？",
    nOptCount = 2,
    Callback = function(self, nOptIndex)
      --确定按钮
      if nOptIndex == 2 then
        thatSelf:DoTweet()
        UiManager:CloseWindow(Ui.UI_SNS_MAIN)
      end
    end,
  }
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

function uiSnsMain:DoTweet()
  local szTweet = Edt_GetTxt(self.UIGROUP, self.EDIT_TWEET)
  local szImagePath = self:GetImagePath()
  szTweet = "#剑侠世界# " .. szTweet
  for nSnsId, tbControl in ipairs(self.tbSnsControl) do
    if Btn_GetCheck(self.UIGROUP, tbControl[1]) > 0 then
      if not szImagePath then
        Sns:Tweet(nSnsId, szTweet)
      else
        Sns:TweetWithPic(nSnsId, szTweet, szImagePath)
      end
    end
  end
  Edt_SetTxt(self.UIGROUP, self.EDIT_TWEET, "")
  self:DeleteScreen()
end

function uiSnsMain:ShowHelp()
  local uiHelpSprite = Ui(Ui.UI_HELPSPRITE)
  UiManager:OpenWindow(uiHelpSprite.UIGROUP)
  uiHelpSprite:OnButtonClick("BtnHelpPage5")
  uiHelpSprite:SearchHelpList("社交网络")
  uiHelpSprite:UpdatePage(1)
end

function uiSnsMain:ReloadScript()
  DoScript("\\ui\\script\\window\\sns_main.lua")
  DoScript("\\ui\\script\\window\\sns_verifier.lua")
  print("重载完成!")
end

local STATE_FILE_NAME = "screen_thumb.txt"

function uiSnsMain:OnEnterGame()
  local szFullPath = GetRootPath() .. GetPlayerPrivatePath() .. STATE_FILE_NAME
  self.szLastThumbPath = KIo.ReadTxtFile(szFullPath)
end

function uiSnsMain:SaveScreenFilePath(szScreenFilePath)
  local szFullPath = GetRootPath() .. GetPlayerPrivatePath() .. STATE_FILE_NAME
  KIo.WriteFile(szFullPath, szScreenFilePath)
end

function uiSnsMain:GetRandomTxt()
  local szMapName = GetMapNameFormId(me.nTemplateMapId)
  local szTxt = self.tbTxtList[MathRandom(1, #self.tbTxtList)]
  return string.format("我在%s, %s，%s", GetLastSvrTitle(), szMapName, szTxt)
end
