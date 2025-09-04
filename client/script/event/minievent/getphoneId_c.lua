-- 文件名　：getphoneid_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-11-08 10:06:56
-- 功能说明：??DoScript("\\script\\event\\minievent\\getphoneid_c.lua")

SpecialEvent.tbGetPhoneId_2012 = SpecialEvent.tbGetPhoneId_2012 or {}
local tbGetPhoneId_2012 = SpecialEvent.tbGetPhoneId_2012
tbGetPhoneId_2012.szOpenUrl = ""
tbGetPhoneId_2012.nRegisterId = 0
tbGetPhoneId_2012.szBtnPic = "\\image\\ui\\002a\\collectphone\\btn_phone.spr"

tbGetPhoneId_2012.nTaskGroupId = 2214
tbGetPhoneId_2012.nTaskOpenFlag = 3 --打开标志（客户端用）

--开打url按钮标志
function tbGetPhoneId_2012:OpenWindow(szUrl, nRandom)
  self.szOpenUrl = string.format(szUrl, TOOLS_EncryptBase64(string.lower(me.szAccount) .. "|" .. nRandom))
  self.nRegisterId = Ui(Ui.UI_BTNMSG):RegisterOpenBtn(self.szBtnPic, string.format([[UiManager:OpenWindow("UI_COLLECTPHONEID", "%s", 1)]], self.szOpenUrl), 1)
  if self.nTimerId and Timer:GetRestTime(self.nTimerId) >= 0 then
    Timer:Close(self.nTimerId)
  end
  self.nTimerId = Timer:Register(18, self.CheckUrl, self)
end

function tbGetPhoneId_2012:CheckUrl()
  local nOpenFlag = me.GetTask(self.nTaskGroupId, self.nTaskOpenFlag)
  if nOpenFlag ~= 1 then
    return 0
  end
  local szUrl = Ui(Ui.UI_COLLECTPHONEID):GetCurUrl()
  if self.szOpenUrl ~= szUrl and string.find(szUrl, "http://app.jxsj.xoyo.com/app/api/jxsj/prize/?") then
    me.CallServerScript({ "ApplyColloctPhone_Award", szUrl })
  end
  return
end

function tbGetPhoneId_2012:CloseWindow()
  if self.nRegisterId > 0 then
    Ui(Ui.UI_BTNMSG):UnRegisterOpenBtn(self.nRegisterId)
    UiManager:CloseWindow("UI_COLLECTPHONEID")
    self.nRegisterId = 0
  end
end
