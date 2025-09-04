-------------------------------------------------------
--文件名		：	tongannounce.lua
--创建者		：	fenghewen
--创建时间		：	2009-08-4
--功能描述		：	帮会公告界面
------------------------------------------------------
local uiTongAnnounce = Ui:GetClass("tongannounce")
uiTongAnnounce.EDIT_CONTENT = "EdtContent"
uiTongAnnounce.EDIT_TIMES = "EdtTimes"
uiTongAnnounce.EDIT_DISTANCE = "EdtDistance"
uiTongAnnounce.BUTTON_SEND = "BtnSend"
uiTongAnnounce.BUTTON_CLOSE = "BtnClose"
uiTongAnnounce.BUTTON_ADD_TIMES = "BtnAddTimes"
uiTongAnnounce.BUTTON_DEC_TIMES = "BtnDecTimes"
uiTongAnnounce.BUTTON_ADD_DISTANCE = "BtnAddistance"
uiTongAnnounce.BUTTON_DEC_DISTANCE = "BtnDecDistance"

function uiTongAnnounce:OnOpen(tbParam)
  Edt_SetInt(self.UIGROUP, self.EDIT_TIMES, 10)
  Edt_SetInt(self.UIGROUP, self.EDIT_DISTANCE, 30)
end

function uiTongAnnounce:OnEditChange(szWnd, nParam)
  if szWnd == self.EDIT_TIMES then
    local nTimes = Edt_GetInt(self.UIGROUP, self.EDIT_TIMES)
    if nTimes > Tong.TONGANNOUNCE_MAX_TIMES then
      Edt_SetInt(self.UIGROUP, self.EDIT_TIMES, Tong.TONGANNOUNCE_MAX_TIMES)
    end
  elseif szWnd == self.EDIT_DISTANCE then
    local nDistance = Edt_GetInt(self.UIGROUP, self.EDIT_DISTANCE)
    if nDistance > Tong.TONGANNOUNCE_MAX_DISTANCE then
      Edt_SetInt(self.UIGROUP, self.EDIT_DISTANCE, Tong.TONGANNOUNCE_MAX_DISTANCE)
    end
  end
end

function uiTongAnnounce:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_ADD_TIMES then
    local nTimes = Edt_GetInt(self.UIGROUP, self.EDIT_TIMES)
    if nTimes + 1 <= Tong.TONGANNOUNCE_MAX_TIMES and nTimes + 1 >= Tong.TONGANNOUNCE_MIN_TIMES then
      Edt_SetInt(self.UIGROUP, self.EDIT_TIMES, nTimes + 1)
    end
  elseif szWnd == self.BUTTON_DEC_TIMES then
    local nTimes = Edt_GetInt(self.UIGROUP, self.EDIT_TIMES)
    if nTimes - 1 <= Tong.TONGANNOUNCE_MAX_TIMES and nTimes - 1 >= Tong.TONGANNOUNCE_MIN_TIMES then
      Edt_SetInt(self.UIGROUP, self.EDIT_TIMES, nTimes - 1)
    end
  elseif szWnd == self.BUTTON_ADD_DISTANCE then
    local nDistance = Edt_GetInt(self.UIGROUP, self.EDIT_DISTANCE)
    if nDistance + 1 <= Tong.TONGANNOUNCE_MAX_DISTANCE and nDistance + 1 >= Tong.TONGANNOUNCE_MIN_DISTANCE then
      Edt_SetInt(self.UIGROUP, self.EDIT_DISTANCE, nDistance + 1)
    elseif nDistance > Tong.TONGANNOUNCE_MAX_DISTANCE then
      Edt_SetInt(self.UIGROUP, self.EDIT_DISTANCE, Tong.TONGANNOUNCE_MAX_DISTANCE)
    elseif nDistance < Tong.TONGANNOUNCE_MIN_DISTANCE then
      Edt_SetInt(self.UIGROUP, self.EDIT_DISTANCE, Tong.TONGANNOUNCE_MIN_DISTANCE)
    end
  elseif szWnd == self.BUTTON_DEC_DISTANCE then
    local nDistance = Edt_GetInt(self.UIGROUP, self.EDIT_DISTANCE)
    if nDistance - 1 <= Tong.TONGANNOUNCE_MAX_DISTANCE and nDistance - 1 >= Tong.TONGANNOUNCE_MIN_DISTANCE then
      Edt_SetInt(self.UIGROUP, self.EDIT_DISTANCE, nDistance - 1)
    elseif nDistance > Tong.TONGANNOUNCE_MAX_DISTANCE then
      Edt_SetInt(self.UIGROUP, self.EDIT_DISTANCE, Tong.TONGANNOUNCE_MAX_DISTANCE)
    elseif nDistance < Tong.TONGANNOUNCE_MIN_DISTANCE then
      Edt_SetInt(self.UIGROUP, self.EDIT_DISTANCE, Tong.TONGANNOUNCE_MIN_DISTANCE)
    end
  elseif szWnd == self.BUTTON_SEND then
    local nTimes = Edt_GetInt(self.UIGROUP, self.EDIT_TIMES)
    local nDistance = Edt_GetInt(self.UIGROUP, self.EDIT_DISTANCE)
    local szMsg = Edt_GetTxt(self.UIGROUP, self.EDIT_CONTENT)
    if nTimes < Tong.TONGANNOUNCE_MIN_TIMES or nTimes > Tong.TONGANNOUNCE_MAX_TIMES then
      me.Msg("你发送帮会公告的次数超过规定次数。")
      return 0
    end
    if nDistance < Tong.TONGANNOUNCE_MIN_DISTANCE or nDistance > Tong.TONGANNOUNCE_MAX_DISTANCE then
      me.Msg("你发送帮会公告的时间间隔不在额定范围之内。")
      return 0
    end
    if not szMsg or szMsg == "" then
      me.Msg("不能发送空信息")
      return 0
    end

    --是否包含敏感字串
    if IsNamePass(szMsg) ~= 1 then
      me.Msg("对不起，您输入的帮会公告包含敏感字词，请重新设定")
      return 0
    end

    me.CallServerScript({ "TongCmd", "TongAnnounce", me.dwTongId, nTimes, nDistance, szMsg })
    return 1
  end
end
