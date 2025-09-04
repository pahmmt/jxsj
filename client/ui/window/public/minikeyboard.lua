local uiMiniKeyBoard = Ui:GetClass("minikeyboard")
local KEYIMGPATH = "\\image\\ui\\002a\\minikeyboard\\"
if UiVersion == Ui.Version001 then
  KEYIMGPATH = "\\image\\ui\\001a\\protect\\key\\"
end

local BTN_KEYNAME = "BtnKey"
local BTN_CLOSE = "BtnClose"
local PWDTABLE = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }

function uiMiniKeyBoard:Init() end

function uiMiniKeyBoard:OnOpen()
  for i = 1, #PWDTABLE do
    for j = i + 1, #PWDTABLE do
      if MathRandom(2) > 1 then
        local nTemp
        nTemp = PWDTABLE[i]
        PWDTABLE[i] = PWDTABLE[j]
        PWDTABLE[j] = nTemp
      end
    end
  end

  for i = 1, 10 do
    if UiVersion == Ui.Version001 then
      Img_SetImage(self.UIGROUP, BTN_KEYNAME .. i, 1, KEYIMGPATH .. PWDTABLE[i] .. ".spr")
      Img_PlayAnimation(self.UIGROUP, BTN_KEYNAME .. i, 1)
    else
      Img_SetImage(self.UIGROUP, BTN_KEYNAME .. i, 1, KEYIMGPATH .. "btn_key" .. PWDTABLE[i] .. ".spr")
    end
  end
  if UiVersion == Ui.Version001 then
    Img_SetImage(self.UIGROUP, BTN_KEYNAME .. 11, 1, KEYIMGPATH .. "del.spr")
    Img_SetImage(self.UIGROUP, BTN_KEYNAME .. 12, 1, KEYIMGPATH .. "enter" .. UiManager.IVER_szVnSpr)
  else
    Img_SetImage(self.UIGROUP, BTN_KEYNAME .. 11, 1, KEYIMGPATH .. "btn_keyback.spr")
    Img_SetImage(self.UIGROUP, BTN_KEYNAME .. 12, 1, KEYIMGPATH .. "btn_keyok.spr")
  end
end

function uiMiniKeyBoard:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiMiniKeyBoard:OnButtonClick(szWndName, nParam)
  for i = 1, 10 do
    if szWndName == BTN_KEYNAME .. i then
      UiNotify:OnNotify(UiNotify.emUIEVENT_MINIKEY_SEND, PWDTABLE[i]) -- TODO: 临时做法
      break
    end
  end

  if szWndName == BTN_KEYNAME .. 11 then
    UiNotify:OnNotify(UiNotify.emUIEVENT_MINIKEY_SEND, -1) -- TODO: 临时做法
  end

  if (szWndName == BTN_CLOSE) or (szWndName == BTN_KEYNAME .. 12) then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiMiniKeyBoard:OnClose() end
