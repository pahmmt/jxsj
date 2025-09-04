-- 泡泡提示逻辑

Ui.tbLogic.tbPopMgr = {}
local tbPopMgr = Ui.tbLogic.tbPopMgr
local tbTimer = Ui.tbLogic.tbTimer

tbPopMgr.ARROW_RIGHTDOWN = 1
tbPopMgr.ARROW_LEFTDOWN = 2
tbPopMgr.ARROW_RIGHTUP = 3
tbPopMgr.ARROW_LEFTUP = 4

tbPopMgr.SPR_RIGHTDOWN = "\\image\\ui\\001a\\main\\popo\\popo_RD.spr"
tbPopMgr.SPR_LEFTDOWN = "\\image\\ui\\001a\\main\\popo\\popo_LD.spr"
tbPopMgr.SPR_RIGHTUP = "\\image\\ui\\001a\\main\\popo\\popo_RU.spr"
tbPopMgr.SPR_LEFTUP = "\\image\\ui\\001a\\main\\popo\\popo_LU.spr"

tbPopMgr.SPR_LUP = "\\image\\ui\\001a\\main\\popo\\bg_pop_leftup.spr"
tbPopMgr.SPR_LDOWN = "\\image\\ui\\001a\\main\\popo\\bg_pop_leftdown.spr"
tbPopMgr.SPR_RUP = "\\image\\ui\\001a\\main\\popo\\bg_pop_rightup.spr"
tbPopMgr.SPR_RDOWN = "\\image\\ui\\001a\\main\\popo\\bg_pop_rightdown.spr"

function tbPopMgr:Init()
  self.tbPopTip_List = {}
  self.tbPopTimerId = {}
  local szFile = GetActualPath("poptip.txt")
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    Ui:Output("[ERR] POPTIP 配置路径不正确" .. szFile)
    return 0
  end
  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nId = pTabFile.GetInt(i, 1)
    local nArrow = pTabFile.GetInt(i, 2)
    local szPopTipTxt = pTabFile.GetStr(i, 3)
    local szWndGroup = pTabFile.GetStr(i, 4)
    local szControl = pTabFile.GetStr(i, 5)
    local nTimer = pTabFile.GetInt(i, 6)
    local bClose = pTabFile.GetInt(i, 7) or 0
    nTimer = nTimer * Env.GAME_FPS -- 秒转换成帧
    self.tbPopTip_List[nId] = { nArrow, szPopTipTxt, szWndGroup, szControl, nTimer, bClose }
  end
  KIo.CloseTabFile(pTabFile) -- 释放对象
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_SET_POPTIP, self.ShowPopTip, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_CANCEL_POPTIP, self.HidePopTip, self)
end

function tbPopMgr:OnClear()
  if self.tbPopTimerId then
    for _, nId in pairs(self.tbPopTimerId) do
      if nId and nId > 0 then
        tbTimer:Close(nId)
      end
    end
  end

  self.tbPopTimerId = {}
end

function tbPopMgr:ShowPopTip(nPopId, szCustomTip)
  for nId, tbWnd_Info in pairs(self.tbPopTip_List) do
    if nId == nPopId then
      local nArrow = tbWnd_Info[1]
      local szPopTipTxt = tbWnd_Info[2]
      local szWndGroup = tbWnd_Info[3]
      local szControl = tbWnd_Info[4]
      local nTimer = tbWnd_Info[5]
      local bClose = tbWnd_Info[6]
      local nLineWidth = 200
      if bClose == 1 then
        return
      end
      if IsWndExist(szWndGroup, szControl) ~= 1 then
        return
      end
      if szCustomTip then
        szPopTipTxt = szCustomTip
      end

      local nWnd_Width, nWnd_Height = Wnd_GetSize(szWndGroup, szControl)
      if nArrow == self.ARROW_RIGHTDOWN then
        Wnd_SetPopTip(szWndGroup, szControl, -185, -93, self.SPR_RIGHTDOWN, 15, 7, szPopTipTxt, nLineWidth)
      elseif nArrow == self.ARROW_LEFTDOWN then
        Wnd_SetPopTip(szWndGroup, szControl, nWnd_Width - 40, -93, self.SPR_LEFTDOWN, 15, 10, szPopTipTxt, nLineWidth)
      elseif nArrow == self.ARROW_RIGHTUP then
        Wnd_SetPopTip(szWndGroup, szControl, -185, nWnd_Height, self.SPR_RIGHTUP, 15, 28, szPopTipTxt, nLineWidth)
      elseif nArrow == self.ARROW_LEFTUP then
        Wnd_SetPopTip(szWndGroup, szControl, nWnd_Width - 46, nWnd_Height, self.SPR_LEFTUP, 15, 28, szPopTipTxt, nLineWidth)
      end
      if nTimer ~= 0 then
        self.tbPopTimerId[nId] = tbTimer:Register(nTimer, self.OnTimer, self, nPopId)
      end
    end
  end
end

function tbPopMgr:ShowWndPopTip(szWndGroup, szControl, szCustomTip, nArrow, nTimer, nX, nY)
  assert(szWndGroup and szControl and szCustomTip and nArrow)
  local nWnd_Width, nWnd_Height = Wnd_GetSize(szWndGroup, szControl)
  local nLineWidth = 125
  if nWnd_Width == 0 then
    nWnd_Width = 20
  end
  if nX or nY then
    nX = nX or 0
    nY = nY or 0
    if nArrow == self.ARROW_RIGHTDOWN then
      Wnd_SetPopTip(szWndGroup, szControl, nX - 125, nY - 51, self.SPR_RDOWN, 2, 2, szCustomTip, nLineWidth)
    elseif nArrow == self.ARROW_LEFTDOWN then
      Wnd_SetPopTip(szWndGroup, szControl, nX - 8, nY - 51, self.SPR_LDOWN, 2, 2, szCustomTip, nLineWidth)
    elseif nArrow == self.ARROW_RIGHTUP then
      Wnd_SetPopTip(szWndGroup, szControl, nX - 125, nY, self.SPR_RUP, 2, 14, szCustomTip, nLineWidth)
    elseif nArrow == self.ARROW_LEFTUP then
      Wnd_SetPopTip(szWndGroup, szControl, nX - 8, nY, self.SPR_LUP, 2, 14, szCustomTip, nLineWidth)
    end
  else
    if nArrow == self.ARROW_RIGHTDOWN then
      Wnd_SetPopTip(szWndGroup, szControl, -125, -51, self.SPR_RDOWN, 2, 2, szCustomTip, nLineWidth)
    elseif nArrow == self.ARROW_LEFTDOWN then
      Wnd_SetPopTip(szWndGroup, szControl, nWnd_Width - 8, -51, self.SPR_LDOWN, 2, 2, szCustomTip, nLineWidth)
    elseif nArrow == self.ARROW_RIGHTUP then
      Wnd_SetPopTip(szWndGroup, szControl, -125, nWnd_Height, self.SPR_RUP, 2, 14, szCustomTip, nLineWidth)
    elseif nArrow == self.ARROW_LEFTUP then
      Wnd_SetPopTip(szWndGroup, szControl, nWnd_Width - 8, nWnd_Height, self.SPR_LUP, 2, 14, szCustomTip, nLineWidth)
    end
  end
  if nTimer and nTimer ~= 0 then
    if self.tbPopTimerId[szWndGroup .. szControl] then
      tbTimer:Close(self.tbPopTimerId[szWndGroup .. szControl])
    end
    self.tbPopTimerId[szWndGroup .. szControl] = tbTimer:Register(nTimer, self.HideWndPopTip, self, szWndGroup, szControl)
  end
end

function tbPopMgr:HideWndPopTip(szWndGroup, szControl)
  assert(szWndGroup and szControl)
  Wnd_CancelPopTip(szWndGroup, szControl)
  if self.tbPopTimerId[szWndGroup .. szControl] then
    self.tbPopTimerId[szWndGroup .. szControl] = nil
  end
  return 0
end

function tbPopMgr:OnTimer(nPopId)
  self:HidePopTip(nPopId)
  if self.tbPopTimerId[nPopId] and self.tbPopTimerId[nPopId] > 0 then
    tbTimer:Close(self.tbPopTimerId[nPopId])
    self.tbPopTimerId[nPopId] = 0
  end
end

function tbPopMgr:HidePopTip(nPopId)
  for nId, tbWnd_Info in pairs(self.tbPopTip_List) do
    if nId == nPopId then
      local szWndGroup = tbWnd_Info[3]
      local szControl = tbWnd_Info[4]
      Wnd_CancelPopTip(szWndGroup, szControl)
    end
  end
end

function tbPopMgr:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SET_POPTIP, self.ShowPopTip },
    { UiNotify.emCOREEVENT_CANCEL_POPTIP, self.HidePopTip },
  }
  return tbRegEvent
end
