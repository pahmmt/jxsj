-- 文件名　：kingamescreen.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-06-28 11:58:49
-- 功能    ：

local uiKinGameScreen = Ui:GetClass("kingamescreen")

uiKinGameScreen.Img_Time1 = "Img_Time1"
uiKinGameScreen.Img_Time2 = "Img_Time2"
uiKinGameScreen.Img_Time3 = "Img_Time3"
uiKinGameScreen.Txt_Msg = "Txt_Msg"

uiKinGameScreen.nUpTime = 0

uiKinGameScreen.szTimePath = "\\image\\effect\\info\\sk\\"
--打开界面
function uiKinGameScreen:OnOpen(nTime, szMsg)
  self.nUpTime = nTime
  if szMsg then
    Txt_SetTxt(self.UIGROUP, self.Txt_Msg, szMsg)
  end
  Wnd_Hide(self.UIGROUP, self.Img_Time1)
  Wnd_Hide(self.UIGROUP, self.Img_Time2)
  Wnd_Hide(self.UIGROUP, self.Img_Time3)
  if nTime <= 0 or nTime > 999 then
    return
  end
  self.nTimeUp = Timer:Register(Env.GAME_FPS, self.UpTime, self)
end

function uiKinGameScreen:UpTime()
  local nG = math.fmod(self.nUpTime, 10)
  local nS = math.fmod(math.floor(self.nUpTime / 10), 10)
  local nB = math.fmod(math.floor(self.nUpTime / 100), 10)
  Wnd_Show(self.UIGROUP, self.Img_Time1)
  Img_SetImage(self.UIGROUP, self.Img_Time1, 1, self.szTimePath .. nB .. ".spr")
  Img_PlayAnimation(self.UIGROUP, self.Img_Time1)
  Wnd_Show(self.UIGROUP, self.Img_Time2)
  Img_SetImage(self.UIGROUP, self.Img_Time2, 1, self.szTimePath .. nS .. ".spr")
  Img_PlayAnimation(self.UIGROUP, self.Img_Time2)
  Wnd_Show(self.UIGROUP, self.Img_Time3)
  Img_SetImage(self.UIGROUP, self.Img_Time3, 1, self.szTimePath .. nG .. ".spr")
  Img_PlayAnimation(self.UIGROUP, self.Img_Time3)
  self.nUpTime = self.nUpTime - 1
  if self.nUpTime < 0 then
    UiManager:CloseWindow(self.UIGROUP)
    return 0
  end
  return
end

function uiKinGameScreen:Close()
  if Timer:GetRestTime(self.UpTime) > 0 then
    Timer:Close(self.UpTime)
  end
end
