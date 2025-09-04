-----------------------------------------------------
--文件名		：	affiche.lua
--创建者		：	FanJinsong
--创建时间	：	2012-8-2
--功能描述	：	家族 详细公告
------------------------------------------------------

local uiAffiche = Ui:GetClass("affiche")

uiAffiche.BTN_CLOSE = "BtnClose" -- 关闭按钮
uiAffiche.TXT_TITLE = "TxtTitle" -- 文本标题
uiAffiche.BTN_EDIT = "BtnEdit" -- 编辑按钮
uiAffiche.BTN_SAVE = "BtnSave" -- 记录按钮
uiAffiche.EDT_AFFICHE = "EdtAffiche" -- 编辑文本框

function uiAffiche:OnOpen()
  local cKin = KKin.GetSelfKin()
  if cKin then
    Edt_SetTxt(self.UIGROUP, self.EDT_AFFICHE, cKin.GetAnnounce())
  end
  Wnd_SetEnable(self.UIGROUP, self.EDT_AFFICHE, 0)

  if self:GetSelfKinFigure() > Kin.FIGURE_ASSISTANT then
    Wnd_SetEnable(self.UIGROUP, self.BTN_EDIT, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SAVE, 0)
  end
end

function uiAffiche:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_EDIT then
    -- 家族公告编辑按钮
    Wnd_SetEnable(self.UIGROUP, self.EDT_AFFICHE, 1)
  elseif szWnd == self.BTN_SAVE then
    -- 家族公告记录按钮
    local szAffiche = Edt_GetTxt(self.UIGROUP, self.EDT_AFFICHE)
    if #szAffiche > Kin.ANNOUNCE_MAX_LEN then
      me.Msg("公告字数大于允许的最大长度")
      return 0
    end
    local tbMsg = {}
    tbMsg.szMsg = "确定要保存公告吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, szAffiche)
      if nOptIndex == 2 then
        me.CallServerScript({ "KinCmd", "SetAnnounce", szAffiche })
      elseif nOptIndex == 1 then
        local cKin = KKin.GetSelfKin()
        if cKin then
          Edt_SetTxt(Ui.UI_AFFICHE, Ui(Ui.UI_AFFICHE).EDT_AFFICHE, cKin.GetAnnounce())
        end
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, szAffiche)
    Wnd_SetEnable(self.UIGROUP, self.EDT_AFFICHE, 0)
  elseif szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP) -- 关闭窗口
  end
end

function uiAffiche:GetSelfKinFigure()
  return me.nKinFigure
end

function uiAffiche:OnClose()
  if self:GetSelfKinFigure() <= Kin.FIGURE_ASSISTANT then
    local cKin = KKin.GetSelfKin()
    if cKin then
      Ui(Ui.UI_KIN):UpdateAddiche(cKin.GetAnnounce())
    end
  end
end
