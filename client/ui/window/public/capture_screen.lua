-----------------------------------------------------
--文件名		：	capture_screen.lua
--创建者		：	wangzhiguang
--创建时间		：	2011-03-22
--功能描述		：	截图操作界面
------------------------------------------------------

local uiScreen = Ui:GetClass("capture_screen") -- 这样写支持重载

local WND_MAIN = "Main"

function uiScreen:Print(...)
  Dbg:Output("Sns", unpack(arg))
end

function uiScreen:Reset()
  self.bDoubleClicked = nil
end

function uiScreen:OnOpen(tbImageInfo)
  self:Reset()
  Img_SetImage(self.UIGROUP, WND_MAIN, 0, tbImageInfo.szTempPath)
  --这里不能马上删除缩略图，否则文件在缓存中超时后就没有数据源了
  if self.szLastTempPath then
    DeleteLocalFile(self.szLastTempPath)
  end
  self.szLastTempPath = tbImageInfo.szTempPath
  self:SaveScreenFilePath(tbImageInfo.szTempPath)
  self.tbImageInfo = tbImageInfo
  UiManager:SetUiState(UiManager.UIS_CAPTURE_SCREEN_SELECTING)
end

function uiScreen:OnClose()
  UiManager:ReleaseUiState(UiManager.UIS_CAPTURE_SCREEN_SELECTING)
  UiManager:ReleaseUiState(UiManager.UIS_CAPTURE_SCREEN_DONE)
end

function uiScreen:OnButtonClick()
  local bHasRegion = ImgScreen_GetCapturedRegion(self.UIGROUP, WND_MAIN)
  if bHasRegion == 1 then
    UiManager:ReleaseUiState(UiManager.UIS_CAPTURE_SCREEN_SELECTING)
    UiManager:SetUiState(UiManager.UIS_CAPTURE_SCREEN_DONE)
  end

  if self.bDoubleClicked == 1 then
    local tb = self.tbImageInfo
    local bHasRegion, nLeft, nTop, nRight, nBottom = ImgScreen_GetCapturedRegion(self.UIGROUP, WND_MAIN)
    if bHasRegion == 1 then
      tb.szBuffer, tb.nWidth, tb.nHeight = Image_Sub(tb.szBuffer, tb.nWidth, tb.nHeight, nLeft, nTop, nRight, nBottom)
    end

    KFile.CreatePath(UiManager.szPicPath)
    tb.szPath = UiManager.szPicPath .. GetLocalDate("%Y-%m-%d_%H-%M-%S.jpg")
    Image_SaveBuffer2File(tb.szPath, tb.szBuffer, tb.nWidth, tb.nHeight, 1)
    me.Msg("截图已保存到：" .. tb.szPath)

    --发消息窗口保存截图内容
    UiManager:CloseWindow(self.UIGROUP)
    local uiSnsMain = Ui.tbWnd[Ui.UI_SNS_MAIN]
    uiSnsMain:OnSaveScreenComplete(tb, 1)
  end
end

function uiScreen:OnButtonRClick()
  UiManager:ReleaseUiState(UiManager.UIS_CAPTURE_SCREEN_DONE)
  UiManager:SetUiState(UiManager.UIS_CAPTURE_SCREEN_SELECTING)
end

function uiScreen:OnButtonDBClick(szWnd, nParam)
  self.bDoubleClicked = 1
end

function uiScreen:OnSaveScreenComplete(tbImageInfo)
  local szTempPath = GetRootPath() .. GetPlayerPrivatePath() .. GetLocalDate("%Y-%m-%d_%H-%M-%S.bmp")
  Image_SaveBuffer2File(szTempPath, tbImageInfo.szBuffer, tbImageInfo.nWidth, tbImageInfo.nHeight, 0)
  tbImageInfo.szTempPath = szTempPath
  UiManager:OpenWindow(self.UIGROUP, tbImageInfo)
end

local STATE_FILE_NAME = "screen.txt"

function uiScreen:OnEnterGame()
  local szFullPath = GetRootPath() .. GetPlayerPrivatePath() .. STATE_FILE_NAME
  self.szLastTempPath = KIo.ReadTxtFile(szFullPath)
end

function uiScreen:SaveScreenFilePath(szScreenFilePath)
  local szFullPath = GetRootPath() .. GetPlayerPrivatePath() .. STATE_FILE_NAME
  KIo.WriteFile(szFullPath, szScreenFilePath)
end
