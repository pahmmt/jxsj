Ui.tbLogic.tbMap = {}
local tbMap = Ui.tbLogic.tbMap

function tbMap:Init()
  self.nModel = 1 -- TODO: nModel = 1 表示玩家在该显示地图上, 0 表示不在
  self.tbContainer = {}
  self.bSocrll = 0
  self.nOrgX = 0
  self.nOrgY = 0
  self.nDestPosX = -1
  self.nDestPosY = -1
  self.tbHighLightCont = {}
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_SYNC_MAP_HIGHLIGHT, self.FillMapHighLight, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_CLEAR_MAP_HIGHLIGHTEX, self.ClearMapHightLightEx, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.DelAllHighLight, self)
end

function tbMap:CreateMapControl(nMapId, szWndGroup, szWndFrame, szWndMap, szWndMeMark)
  local nId
  local tbWndFrameCont = { nWidth = 0, nHeight = 0 }
  local tbWndMapCont = { nWidth = 0, nHeight = 0 }
  local tbWndMeMarkCont = { nWidth = 0, nHeight = 0 }
  local tbMapRect = GetMapRect(nMapId)
  local szMapName, szMapPath = GetMapPath(nMapId)

  if tbMapRect then
    local nOrgX = tbMapRect[1]
    local nOrgY = tbMapRect[2]
    Img_SetImage(szWndGroup, szWndMap, 0, szMapPath .. ".jpg")
    nId = #self.tbContainer + 1
    tbWndFrameCont.szName = szWndFrame
    tbWndFrameCont.nWidth, tbWndFrameCont.nHeight = Wnd_GetSize(szWndGroup, szWndFrame)

    tbWndMapCont.szName = szWndMap
    tbWndMapCont.nWidth, tbWndMapCont.nHeight = Wnd_GetSize(szWndGroup, szWndMap)

    tbWndMeMarkCont.szName = szWndMeMark
    tbWndMeMarkCont.nWidth, tbWndMeMarkCont.nHeight = Wnd_GetSize(szWndGroup, szWndMeMark)

    self.tbContainer[nId] = { szWndGroup, tbWndFrameCont, tbWndMapCont, tbWndMeMarkCont }
    self.tbContainer[nId].bSocrll = 0
    self.tbContainer[nId].bShowTarget = 0
    self.tbContainer[nId].nOrgX = nOrgX
    self.tbContainer[nId].nOrgY = nOrgY
    return nId
  end
  return 0
end

function tbMap:InitControl(nId, nModel)
  self.nModel = nModel
  if self.nModel == 0 then
    if self.tbContainer[nId][3].nWidth < self.tbContainer[nId][2].nWidth then
      local nX = (self.tbContainer[nId][2].nWidth - self.tbContainer[nId][3].nWidth) / 2
      self:SetWndPosX(self.tbContainer[nId][1], self.tbContainer[nId][3].szName, nX)
    else
      local nX = (self.tbContainer[nId][2].nWidth - self.tbContainer[nId][3].nWidth) / 2
      self:SetWndPosX(self.tbContainer[nId][1], self.tbContainer[nId][3].szName, nX)
    end
    if self.tbContainer[nId][3].nHeight < self.tbContainer[nId][2].nHeight then
      local nY = (self.tbContainer[nId][2].nHeight - self.tbContainer[nId][3].nHeight) / 2
      self:SetWndPosY(self.tbContainer[nId][1], self.tbContainer[nId][3].szName, nY)
    else
      local nY = (self.tbContainer[nId][2].nHeight - self.tbContainer[nId][3].nHeight) / 2
      self:SetWndPosY(self.tbContainer[nId][1], self.tbContainer[nId][3].szName, nY)
    end
  end
  if self.nModel == 1 then
    if self.tbContainer[nId][3].nWidth < self.tbContainer[nId][2].nWidth then
      local nX = (self.tbContainer[nId][2].nWidth - self.tbContainer[nId][3].nWidth) / 2
      self:SetWndPosX(self.tbContainer[nId][1], self.tbContainer[nId][3].szName, nX)
    end
    if self.tbContainer[nId][3].nHeight < self.tbContainer[nId][2].nHeight then
      local nY = (self.tbContainer[nId][2].nHeight - self.tbContainer[nId][3].nHeight) / 2
      self:SetWndPosY(self.tbContainer[nId][1], self.tbContainer[nId][3].szName, nY)
    end
    self:ResetMap(nId)
  end
end

function tbMap:SetWndPosX(szGroup, szWnd, nX)
  local _, nY = Wnd_GetPos(szGroup, szWnd)
  Wnd_SetPos(szGroup, szWnd, nX, nY)
end

function tbMap:SetWndPosY(szGroup, szWnd, nY)
  local nX, _ = Wnd_GetPos(szGroup, szWnd)
  Wnd_SetPos(szGroup, szWnd, nX, nY)
end

function tbMap:WorldPosToImgPos(nId, nWorldPosX, nWorldPosY)
  local nCurPosX, nCurPosY = 0, 0
  if nId and nWorldPosX and nWorldPosY then
    nCurPosX = (nWorldPosX - self.tbContainer[nId].nOrgX * 16) * 2
    nCurPosY = (nWorldPosY - self.tbContainer[nId].nOrgY * 32)
  end
  return nCurPosX, nCurPosY
end

function tbMap:SetMePos(nId, nWorldPosX, nWorldPosY)
  if nId and nId ~= 0 then
    local nCurPosX, nCurPosY = self:WorldPosToImgPos(nId, nWorldPosX, nWorldPosY)
    local nMarkPosX, nMarkPosY
    nMarkPosX = nCurPosX - self.tbContainer[nId][4].nWidth / 2
    nMarkPosY = nCurPosY - self.tbContainer[nId][4].nHeight / 2
    Wnd_SetPos(self.tbContainer[nId][1], self.tbContainer[nId][4].szName, nMarkPosX, nMarkPosY)
  end
end

function tbMap:ImgPosToWorldPos(nId, nImgPosX, nImgPosY)
  local nCurPosX, nCurPosY = 0, 0
  if nId and nImgPosX and nImgPosY then
    nCurPosX = nImgPosX / 2 + self.tbContainer[nId].nOrgX * 16
    nCurPosY = nImgPosY + self.tbContainer[nId].nOrgY * 32
  end
  return nCurPosX, nCurPosY
end

function tbMap:ChangeImgPos(nId, nCurImgPosX, nCurImgPosY)
  local szWndGroup, szWndFrame, szWndMap, szWndMeMark
  local nCurPosX, nCurPosY
  local nFocusPosX, nFocusPosY
  local nNewWndMapPosX, nNewWndMapPosY

  if nId and nId ~= 0 then
    nCurPosX, nCurPosY = nCurImgPosX, nCurImgPosY

    if self.tbContainer[nId].bSocrll == 1 and self.tbContainer[nId].bShowTarget == 0 then
      return
    else
      local nWndMapPosX, nWndMapPosY = Wnd_GetPos(self.tbContainer[nId][1], self.tbContainer[nId][3].szName)
      local nWndFrameWidth = self.tbContainer[nId][2].nWidth
      local nWndFrameHeight = self.tbContainer[nId][2].nHeight
      local nWndMapWidth, nWndMapHeight = Wnd_GetSize(self.tbContainer[nId][1], self.tbContainer[nId][3].szName)

      local nPosX = nWndFrameWidth / 2 - nCurPosX
      local nPosY = nWndFrameHeight / 2 - nCurPosY

      if nWndFrameWidth < nWndMapWidth then
        if nPosX < nWndFrameWidth - nWndMapWidth then
          nPosX = nWndFrameWidth - nWndMapWidth
        elseif nPosX > 0 then
          nPosX = 0
        end
        self:SetWndPosX(self.tbContainer[nId][1], self.tbContainer[nId][3].szName, nPosX)
      end
      if nWndFrameHeight < nWndMapHeight then
        if nPosY < nWndFrameHeight - nWndMapHeight then
          nPosY = nWndFrameHeight - nWndMapHeight
        elseif nPosY > 0 then
          nPosY = 0
        end
        self:SetWndPosY(self.tbContainer[nId][1], self.tbContainer[nId][3].szName, nPosY)
      end
    end
  end
end

function tbMap:ChangePos(nId, nCurWorldPosX, nCurWorldPosY)
  if nId and nId ~= 0 then
    local nCurPosX, nCurPosY
    nCurPosX, nCurPosY = self:WorldPosToImgPos(nId, nCurWorldPosX, nCurWorldPosY)
    self:ChangeImgPos(nId, nCurPosX, nCurPosY)
  end
end

function tbMap:ResetMap(nId)
  if nId then
    local nMapId, nCurWorldPosX, nCurWorldPosY = me.GetWorldPos()
    if not MODULE_GAMESERVER then
      nMapId = me.nTemplateMapId
    end
    self:ChangePos(nId, nCurWorldPosX, nCurWorldPosY)
  end
end

function tbMap:ScrollMap(nId)
  if nId then
    self.tbContainer[nId].bSocrll = 1
  end
end

function tbMap:ShowTarget(nId)
  if nId then
    self.tbContainer[nId].bShowTarget = 1
  end
end

function tbMap:StopShowTarget(nId)
  if nId then
    self.tbContainer[nId].bShowTarget = 0
  end
end

function tbMap:StopScrollMap(nId)
  if nId then
    self.tbContainer[nId].bSocrll = 0
    self:ResetMap(nId)
  end
end

function tbMap:DestroyMapControl(nId)
  if nId then
    self.tbContainer[nId] = nil
  end
end

function tbMap:GetMapHighLightCont()
  return self.tbHighLightCont
end

function tbMap:DelMapHighLightById(nNpcId)
  if nNpcId then
    self.tbHighLightCont[nNpcId] = nil
  end
end

function tbMap:DelAllHighLight()
  for i, tbPoint in pairs(self.tbHighLightCont) do -- 如果第6个参数 为0才清除,否则由服务端来控制清除不清除
    if tbPoint[6] and tbPoint == 0 then
      self.tbHighLightCont[i] = {}
    end
  end
end

function tbMap:FillMapHighLight(szMsg, nMpsX, nMpsY, nPicID, nTimeTick, nNpcId, nClear, nPriority)
  local szImagePath = GetImageByPicID(nPicID)
  -- 删除已有的点
  if nTimeTick and nTimeTick == 0 then
    for nId, tbHighLight in pairs(self.tbHighLightCont) do
      if nNpcId and (nNpcId == nId) and (szMsg == tbHighLight[1]) and (nMpsX == tbHighLight[2]) and (nMpsY == tbHighLight[3]) and (szImagePath == tbHighLight[4]) then
        self.tbHighLightCont[nId] = nil
        return
      end
    end
  end

  local nEndTime
  if nTimeTick and nTimeTick ~= -1 then
    nEndTime = GetCurrentTime() + nTimeTick
  else
    nEndTime = -1
  end

  if nNpcId then
    if self.tbHighLightCont[nNpcId] and self.tbHighLightCont[nNpcId][7] > nPriority then
      return
    end
    self.tbHighLightCont[nNpcId] = { szMsg, nMpsX, nMpsY, szImagePath, nEndTime, nClear, nPriority }
  end
end

function tbMap:ClearMapHightLightEx(nPriority)
  for nId, tbHighLight in pairs(self.tbHighLightCont) do
    if tbHighLight[7] == nPriority then
      self.tbHighLightCont[nId] = nil
    end
  end
end
