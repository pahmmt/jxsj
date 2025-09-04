local uiWorldMap_Domain = Ui:GetClass("worldmap_domain")
local tbMapBar = Ui.tbLogic.tbMapBar
local DOMAIN_SET_PATH = "worldmap\\domainsetting\\"

local DOMAIN_SPR_PATH = "\\image\\ui\\001a\\domainbattle\\"
local EMPTY_DOMAIN_SPR_NAME = "0domain.spr"
local DOMAIN_SPR_NAME = "domain.spr"
local FORBIDDEN_DOMAIN_SPR_NAME = "forbiddomain.spr"
local VILLAGE_DOMAIN_SPR_NAME = "domain_village.spr"
local IMG_REACT = "ImgReact"
local IMG_REACT_SPR_NAME = "\\image\\ui\\001a\\worldmap\\npc_attack.spr"
local DOMAIN_CANVAS = "ImgDomainMap"
local TONGMAINDOMAIN = "TongMainDomain"
local TONGDOMAINCOUNT = "TongDomainCount"
local BTN_CLOSE = "BtnClose"
local IMG_MYTONGCOLOR = "ImgMyTongColor"
local BTN_WORLDMAP_GlOBAL = "BtnWorldMap_Global"
local BTN_WORLDMAP_AREA = "BtnWorldMap_Area"
local BTN_WORLDMAP_SUB = "BtnWorldMap_Sub"
local TXT_TONGSORT = "TongDomainColor"
local IMG_TONGSORT = "ImgTongColor"
local WORLDMAPSETPATH = "worldmap\\domainsetting\\domain_pos.txt"
local IMAGE_MARK = "ImgMark"
local SPR_WIDTH = 23
local SPR_HEIGHT = 23
local MARKOFFSETPOSX = 0
local MARKOFFSETPOSY = 25

local FILL_STAR = "<pic=155>"
local EMPTY_STAR = "<pic=154>"

local COLORID2SPR = {
  [1] = "1domain.spr",
  [2] = "2domain.spr",
  [3] = "3domain.spr",
  [4] = "4domain.spr",
  [5] = "5domain.spr",
  [6] = "6domain.spr",
  [7] = "7domain.spr",
  [8] = "8domain.spr",
  [9] = "9domain.spr",
  [10] = "10domain.spr",
  [11] = "11domain.spr",
  [12] = "12domain.spr",
}
uiWorldMap_Domain.nServerCount = 0
uiWorldMap_Domain.tbWorldsetType = {}

function uiWorldMap_Domain:Init()
  self.tbDomainInfo = {} --领土信息表：nDomainId, szDomainName, nCenterPosX, nCenterPosY, nFightMapId, szTongOwnerName, szUnionOwnerName
  self.tbCanFightDomain = {}
  self.tbMainDomain = {}
  self.tbTongDomainCont = {}
  self.tbUnionDomainCont = {}
  self.ColorSetting = {}
  self.IsUnion = {}
  self.CanvasButtonIdCont = {}
  self.tbCtlId2TongName = {}
  self.szMyTongMainDomian = nil
  self.szMyTongName = nil
  self.szMyUnionName = nil
  self.tbForbiddenDomain = {}
  self.tbTongSortList = {}
  self.tbVillage = {}
  self.bSelfInHeadList = 0
  self.tbDomainSettingFile = DOMAIN_SET_PATH .. "domain_stage1.txt"
  self:LoadPosSetting()
  self.tbAnimation = {}
  self.nShowMapId = 0
end

function uiWorldMap_Domain:ApplyData()
  self:LoadWorldSetType()
  Domain:ApplyData()
end

function uiWorldMap_Domain:LoadWorldSetType()
  local nServerCount = KGblTask.SCGetDbTaskInt(DBTASK_GAMESERVER_COUNT) or 0
  if self.nServerCount ~= nServerCount and nServerCount ~= 0 then
    self.tbWorldsetType = {}
    for nMapId, tbSet in pairs(Map.tbMapWorldsetList) do
      local szType = GetMapType(nMapId) or ""
      self.tbWorldsetType[szType] = self.tbWorldsetType[szType] or {}
      self.tbWorldsetType[szType][nMapId] = tbSet[nServerCount] or 0
    end
    self.nServerCount = nServerCount
  end
end

function uiWorldMap_Domain:GetDomainInfo(nDomainId)
  local tbDomainInfo = Domain:GetDomainInfo(nDomainId)
  return tbDomainInfo
end

function uiWorldMap_Domain:LoadPosSetting()
  self.tbMapInfo = {}
  local szFile = GetActualPath(WORLDMAPSETPATH)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    return 0
  end

  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nMapId = pTabFile.GetInt(i, 1)
    local nXpos = pTabFile.GetInt(i, 2)
    local nYpos = pTabFile.GetInt(i, 3)
    self.tbMapInfo[i - 1] = { nMapId, nXpos, nYpos }
  end
  KIo.CloseTabFile(pTabFile) -- 释放对象
end

function uiWorldMap_Domain:GetBorderDomains(nDomainId)
  local nDomainVersion = Domain:GetDomainVersion_C()
  local tbBorderDomains = Domain:GetBorderDomains(nDomainVersion, nDomainId)
  return tbBorderDomains
end

function uiWorldMap_Domain:UpdateTongBar()
  local szMainDomian = ""
  if self.szMyTongMainDomian then
    szMainDomian = "领土主城：" .. self.szMyTongMainDomian
  else
    szMainDomian = "领土主城：无"
  end
  Txt_SetTxt(self.UIGROUP, TONGMAINDOMAIN, szMainDomian)

  local nMyDomianCount = 0
  if self.szMyTongName then
    if self.tbTongDomainCont[self.szMyTongName] then
      nMyDomianCount = self.tbTongDomainCont[self.szMyTongName]
    end
    if nMyDomianCount > 0 then
      if self.szMyUnionName and self.szMyUnionName ~= 0 then
        if self.ColorSetting[self.szMyUnionName][1] then
          Img_SetImage(self.UIGROUP, IMG_MYTONGCOLOR, 1, DOMAIN_SPR_PATH .. COLORID2SPR[self.ColorSetting[self.szMyUnionName][1]])
        end
      elseif self.szMyTongName then
        if self.ColorSetting[self.szMyTongName][1] then
          Img_SetImage(self.UIGROUP, IMG_MYTONGCOLOR, 1, DOMAIN_SPR_PATH .. COLORID2SPR[self.ColorSetting[self.szMyTongName][1]])
        end
      end
    end
  end
  Txt_SetTxt(self.UIGROUP, TONGDOMAINCOUNT, "领土数量：" .. tostring(nMyDomianCount))
end

function uiWorldMap_Domain:UpdateDomainInfo()
  if self.tbDomainInfo then
    self.szMyTongName = nil
    self.szMyTongMainDomian = nil
    self.tbTongDomainCont = {}
    self.tbUnionDomainCont = {}
    self.tbMainDomain = {}
    self.tbCanFightDomain = {}
    self.tbTongSortList = {}
    for i = 1, #self.tbAnimation do
      Canvas_DestroyAnimation(self.UIGROUP, IMG_REACT, self.tbAnimation[i])
    end
    self.tbAnimation = {}
    self.IsUnion = {}
    self.bSelfInHeadList = 0
    for i = 1, #self.tbDomainInfo do
      local nDomainId = self.tbDomainInfo[i][1]
      local tbOneDomainInfo = self:GetDomainInfo(nDomainId)

      if not tbOneDomainInfo then
        self.tbCanFightDomain[nDomainId] = 0 -- 没有被占领的领土从可攻打表中删除
      end

      if self.tbDomainInfo[i][6] then
        self.tbDomainInfo[i][6] = nil
      end
      if self.tbDomainInfo[i][7] then
        self.tbDomainInfo[i][7] = nil
      end

      if tbOneDomainInfo then
        local szTongOwnerName = tbOneDomainInfo[1]
        local nOwnerTongId = 0 -- 该领土所属帮会ID
        if szTongOwnerName and szTongOwnerName ~= 0 then
          nOwnerTongId = KLib.String2Id(szTongOwnerName) -- 根据名字得到hash值 帮会ID
        end
        local nColorId = tbOneDomainInfo[2]
        local bCaptical = tbOneDomainInfo[3]
        local bReact = tbOneDomainInfo[4]
        local szUnionOwnerName = tbOneDomainInfo[5]

        local nOwnerUnionId = 0 -- 该领土所属联盟ID
        if szUnionOwnerName and szUnionOwnerName ~= 0 then
          nOwnerUnionId = KLib.String2Id(szUnionOwnerName) -- 根据名字得到hash值 帮会ID
        end

        local szColorOwner = 0
        local bIsUnion = 0
        if szTongOwnerName and szTongOwnerName ~= 0 then
          szColorOwner = szTongOwnerName
        end
        if szUnionOwnerName and szUnionOwnerName ~= 0 and szUnionOwnerName ~= "" then
          szColorOwner = szUnionOwnerName
          bIsUnion = 1
        end
        if nColorId == 0 then -- 如果ColorId 是 0 则不在前10名
          self.ColorSetting[szColorOwner] = { 11 }
          self.IsUnion[szColorOwner] = bIsUnion
        else
          self.ColorSetting[szColorOwner] = { nColorId }
          self.IsUnion[szColorOwner] = bIsUnion
        end

        self.tbDomainInfo[i][6] = szTongOwnerName
        self.tbDomainInfo[i][7] = szUnionOwnerName
        -- 建立帮会所拥有的领土表
        local nDomainCount = 0
        if self.tbTongDomainCont[szTongOwnerName] then
          nDomainCount = self.tbTongDomainCont[szTongOwnerName]
        end
        self.tbTongDomainCont[szTongOwnerName] = nDomainCount + 1
        -- 建立联盟所拥有的领土表
        local nUnionDomainCont = 0
        if self.tbUnionDomainCont[szUnionOwnerName] then
          nUnionDomainCont = self.tbUnionDomainCont[szUnionOwnerName]
        end
        self.tbUnionDomainCont[szUnionOwnerName] = nUnionDomainCont + 1
        -- 建立是主城的领土表
        if bCaptical and bCaptical == 1 then
          self.tbMainDomain[nDomainId] = 1
          if me.dwTongId and me.dwTongId ~= 0 and me.dwTongId == nOwnerTongId then
            self.szMyTongMainDomian = self.tbDomainInfo[i][2]
          end
        end

        -- 建立是可攻打领土表
        if me.dwUnionId and me.dwUnionId ~= 0 then
          if me.dwUnionId == nOwnerUnionId and me.dwUnionId ~= 0 then -- 如果此领土是自己的地盘,判断它附近的领土和它的关系
            self.szMyUnionName = szUnionOwnerName or 0
            self.szMyTongName = szTongOwnerName or 0
            local tbBorderDomains = self:GetBorderDomains(nDomainId)
            if tbBorderDomains then
              for nBorderDomainId, nValue in pairs(tbBorderDomains) do -- 把自己周边的领土加入
                if nDomainId and nValue and nValue ~= 0 then
                  if self.tbCanFightDomain[nBorderDomainId] ~= 0 then
                    self.tbCanFightDomain[nBorderDomainId] = 1
                  end
                end
              end
            end
            self.tbCanFightDomain[nDomainId] = 0 -- 已经被占领的领土从可攻打表中删除
          end
        end

        if me.dwTongId and me.dwTongId ~= 0 then
          if me.dwTongId == nOwnerTongId then -- 如果此领土是自己的地盘,判断它附近的领土和它的关系
            self.szMyTongName = szTongOwnerName or 0
            self.szMyUnionName = szUnionOwnerName or 0
            local tbBorderDomains = self:GetBorderDomains(nDomainId)
            if tbBorderDomains then
              for nBorderDomainId, nValue in pairs(tbBorderDomains) do -- 把自己周边的领土加入
                if nDomainId and nValue and nValue ~= 0 then
                  if self.tbCanFightDomain[nBorderDomainId] ~= 0 then
                    self.tbCanFightDomain[nBorderDomainId] = 1
                  end
                end
              end
            end
            self.tbCanFightDomain[nDomainId] = 0 -- 已经被占领的领土从可攻打表中删除
          end
        end

        -- 反扑提示
        if bReact == 1 then
          local nFlagWidth, nFlagHeight = Canvas_GetImageSize(self.UIGROUP, IMG_REACT, IMG_REACT_SPR_NAME)
          local nX = self.tbDomainInfo[i][3] - nFlagWidth / 2
          local nY = self.tbDomainInfo[i][4] - nFlagHeight / 2
          local nAnimationId = Canvas_CreateAnimation(self.UIGROUP, IMG_REACT, nX, nY, IMG_REACT_SPR_NAME, 1)
          table.insert(self.tbAnimation, nAnimationId)
        end
      end
    end

    -- 设置自己的帮会颜色
    for szOwnerName, tbColor in pairs(self.ColorSetting) do
      if self.szMyTongName and szOwnerName == self.szMyTongName and self.szMyTongName ~= 0 then
        if tbColor[1] ~= 11 then
          self.bSelfInHeadList = 1
        end
        self.ColorSetting[szOwnerName] = { 12 } -- 自己设定为第12种颜色
      end
      if self.szMyUnionName and szOwnerName == self.szMyUnionName and self.szMyUnionName ~= 0 then
        if tbColor[1] ~= 11 then
          self.bSelfInHeadList = 1
        end
        self.ColorSetting[szOwnerName] = { 12 } -- 自己设定为第12种颜色
      end
    end
  end
end

function uiWorldMap_Domain:GetStarTip(nLevel)
  local szTip = ""
  for i = 1, math.floor(nLevel / 2) do
    szTip = szTip .. FILL_STAR
    if i % 3 == 0 then
      szTip = szTip .. " "
    end
  end
  if nLevel % 2 ~= 0 then
    szTip = szTip .. EMPTY_STAR
  end
  return szTip
end

function uiWorldMap_Domain:CreateButton()
  if self.tbDomainInfo then
    local tbSort = {}
    local i = 1
    for szTongName, nDomainCount in pairs(self.tbTongDomainCont) do
      local tbTemp = {}
      tbTemp.szKey = szTongName
      tbTemp.nCount = nDomainCount
      table.insert(tbSort, tbTemp)
    end

    -- 按帮会拥有领土数由大到小排序
    table.sort(tbSort, function(a, b)
      return (a.nCount > b.nCount)
    end)

    self.tbTongSortList = tbSort

    for i = 1, #self.tbDomainInfo do
      local szDomainOwner = self.tbDomainInfo[i][6]
      local szDomainUnionOwner = self.tbDomainInfo[i][7]
      local nDomainId = self.tbDomainInfo[i][1]
      local szMapName = GetMapPath(self.tbDomainInfo[i][5])
      local nLevel = Domain:GetReputeParam(nDomainId)
      local szStarTip = self:GetStarTip(nLevel)
      if not szDomainOwner and not szDomainUnionOwner then
        local szTipTitle = "<color=Gold>" .. self.tbDomainInfo[i][2] .. "<color> 领土区<enter><enter> " .. szStarTip .. "<enter><color=Green>"
        if self.tbForbiddenDomain[nDomainId] and self.tbForbiddenDomain[nDomainId] == 1 then
          local szTip = "<color=Gold>" .. self.tbDomainInfo[i][2] .. "<color> 领土区<enter><color=Green>" .. "未开放领土<color>" .. self:GetSaveInfoTips(self.tbDomainInfo[i][5])
          local nButtonId = Canvas_CreateButton(self.UIGROUP, DOMAIN_CANVAS, self.tbDomainInfo[i][3] - SPR_WIDTH / 2, self.tbDomainInfo[i][4] - SPR_HEIGHT / 2, SPR_WIDTH, SPR_HEIGHT, szTip, DOMAIN_SPR_PATH .. FORBIDDEN_DOMAIN_SPR_NAME, 1)
          self.CanvasButtonIdCont[#self.CanvasButtonIdCont + 1] = nButtonId
        elseif self.tbVillage[nDomainId] and self.tbVillage[nDomainId] == 1 then -- 如果是没有被占领的新手村 用不同图标
          local szTip = szTipTitle .. "新手村<color><enter>争夺地图 " .. szMapName .. self:GetSaveInfoTips(self.tbDomainInfo[i][5])
          local nButtonId = Canvas_CreateButton(self.UIGROUP, DOMAIN_CANVAS, self.tbDomainInfo[i][3] - SPR_WIDTH / 2, self.tbDomainInfo[i][4] - SPR_HEIGHT / 2, SPR_WIDTH, SPR_HEIGHT, szTip, DOMAIN_SPR_PATH .. VILLAGE_DOMAIN_SPR_NAME, 1)
          self.CanvasButtonIdCont[#self.CanvasButtonIdCont + 1] = nButtonId
          Canvas_SetButtonFrame(self.UIGROUP, DOMAIN_CANVAS, nButtonId, 12) -- 设为对应帧数的颜色
        else
          local szMapName = GetMapPath(self.tbDomainInfo[i][5])
          local szTip = szTipTitle .. "没有被占领<color><enter>争夺地图 " .. szMapName .. self:GetSaveInfoTips(self.tbDomainInfo[i][5])
          local nButtonId = Canvas_CreateButton(self.UIGROUP, DOMAIN_CANVAS, self.tbDomainInfo[i][3] - SPR_WIDTH / 2, self.tbDomainInfo[i][4] - SPR_HEIGHT / 2, SPR_WIDTH, SPR_HEIGHT, szTip, DOMAIN_SPR_PATH .. EMPTY_DOMAIN_SPR_NAME, 1)
          self.CanvasButtonIdCont[#self.CanvasButtonIdCont + 1] = nButtonId
        end
      elseif szDomainOwner or szDomainUnionOwner then -- 已经被占领的领土
        local bIsMainDomain = nil
        if self.tbMainDomain[nDomainId] and self.tbMainDomain[nDomainId] == 1 then
          bIsMainDomain = 1
        end
        local szMainDomain = ""

        if bIsMainDomain and bIsMainDomain == 1 then
          szMainDomain = "领土区主城<enter>"
        end
        local szColorOwner = 0
        local szTipOwner = "未分配帮会"
        if szDomainOwner and szDomainOwner ~= 0 then
          szColorOwner = szDomainOwner
          szTipOwner = "<color=Green>" .. szDomainOwner .. "<color>占领"
        end

        if szDomainUnionOwner and szDomainUnionOwner ~= 0 then
          szColorOwner = szDomainUnionOwner
          szTipOwner = "<color=blue>" .. szDomainUnionOwner .. "<color><enter>" .. szTipOwner
        end

        local szTip = "<color=Gold>" .. self.tbDomainInfo[i][2] .. "<color> 领土区<enter><enter> " .. szStarTip .. "<enter>" .. szTipOwner .. "<color> <enter><color=Yellow>" .. szMainDomain .. "<color>争夺地图 " .. szMapName .. self:GetSaveInfoTips(self.tbDomainInfo[i][5])

        if self.tbVillage[nDomainId] and self.tbVillage[nDomainId] == 1 then -- 如果是被占领的新手村 用不同图标
          local nButtonId = Canvas_CreateButton(self.UIGROUP, DOMAIN_CANVAS, self.tbDomainInfo[i][3] - SPR_WIDTH / 2, self.tbDomainInfo[i][4] - SPR_HEIGHT / 2, SPR_WIDTH, SPR_HEIGHT, szTip, DOMAIN_SPR_PATH .. VILLAGE_DOMAIN_SPR_NAME, 1)
          self.CanvasButtonIdCont[#self.CanvasButtonIdCont + 1] = nButtonId
          Canvas_SetButtonFrame(self.UIGROUP, DOMAIN_CANVAS, nButtonId, self.ColorSetting[szColorOwner][1] - 1) -- 设为对应帧数的颜色
        else
          local nButtonId = Canvas_CreateButton(self.UIGROUP, DOMAIN_CANVAS, self.tbDomainInfo[i][3] - SPR_WIDTH / 2, self.tbDomainInfo[i][4] - SPR_HEIGHT / 2, SPR_WIDTH, SPR_HEIGHT, szTip, DOMAIN_SPR_PATH .. COLORID2SPR[self.ColorSetting[szColorOwner][1]], 1)
          self.CanvasButtonIdCont[#self.CanvasButtonIdCont + 1] = nButtonId

          if bIsMainDomain and bIsMainDomain == 1 then
            Canvas_SetButtonFrame(self.UIGROUP, DOMAIN_CANVAS, nButtonId, 1) -- 设为主城帧
          end

          if self.tbCanFightDomain[nDomainId] and self.tbCanFightDomain[nDomainId] == 1 then
            Canvas_SetButtonFrame(self.UIGROUP, DOMAIN_CANVAS, nButtonId, 2) -- 可攻领土
            if bIsMainDomain and bIsMainDomain == 1 then
              Canvas_SetButtonFrame(self.UIGROUP, DOMAIN_CANVAS, nButtonId, 3) -- 既是主城,也是可攻领土
            end
          end
        end
      end
    end
  end
end

function uiWorldMap_Domain:GetSaveInfoTips(nMapId)
  local nServerCount = self.nServerCount
  if nServerCount == 0 then
    return ""
  end
  local nServerId = Map.tbMapWorldsetList[nMapId][nServerCount] or 0
  local szTips = "\n\n<color=green>最佳征战重生点设置<color>\n"
  local tbMapSave = {
    { "city", "城  市：" },
    { "village", "新手村：" },
    { "faction", "门  派：" },
  }

  for _, tbInfo in ipairs(tbMapSave) do
    local nUseMapId = 0
    for nKeyMapId, nSerId in pairs(self.tbWorldsetType[tbInfo[1]] or {}) do
      if nSerId == nServerId then
        nUseMapId = nKeyMapId
        break
      end
    end
    if nUseMapId > 0 then
      local szMapName = GetMapPath(nUseMapId)
      szTips = szTips .. string.format("<color=yellow>%s%s<color>\n", tbInfo[2], szMapName)
    else
      szTips = szTips .. string.format("<color=gray>%s无<color>\n", tbInfo[2])
    end
  end
  return szTips
end

function uiWorldMap_Domain:OnCanvasRectClick(szWnd, nButtonId)
  for i = 1, #self.CanvasButtonIdCont do
    if self.CanvasButtonIdCont[i] == nButtonId then
      UiManager:OpenWindow(Ui.UI_WORLDMAP_SUB, self.tbDomainInfo[i][5])
      UiManager:CloseWindow(self.UIGROUP)
      break
    end
  end
end

function uiWorldMap_Domain:DestoryButton()
  Canvas_DestroyAllButton(self.UIGROUP, DOMAIN_CANVAS)
  self.CanvasButtonIdCont = {}
end

function uiWorldMap_Domain:OnOpen(nMapId)
  Wnd_SetEnable(self.UIGROUP, BTN_WORLDMAP_AREA, 1)
  local szMapName, szCountry = Ui(Ui.UI_WORLDMAP_SUB):GetMapNameByMapId(nMapId)
  if szCountry == "" then
    Wnd_SetEnable(self.UIGROUP, BTN_WORLDMAP_AREA, 0)
  else
    self.nShowMapId = nMapId
  end
  self:ApplyData()
  local nStage = Domain:GetDomainVersion_C()
  self:UpdateAll(nStage)
  self:MarkPos()
end

function uiWorldMap_Domain:ClearList()
  for i = 1, 11 do
    Wnd_Hide(self.UIGROUP, TXT_TONGSORT .. i)
    Wnd_Hide(self.UIGROUP, IMG_TONGSORT .. i)
  end
end

function uiWorldMap_Domain:UpdateAll(nStage)
  if nStage then
    self.tbDomainSettingFile = DOMAIN_SET_PATH .. "domain_stage" .. nStage .. ".txt"
    self:ReadDomainInfo(self.tbDomainSettingFile)
    self:LoadForbiddenDomain()
    self:UpdateDomainInfo()
    self:DestoryButton()
    self:CreateButton()
    self:UpdateTongBar()
    self:UpdateSortList()
  end
end

function uiWorldMap_Domain:ShowList(nCtlId, szTongName, nColorId, szUnion)
  local nDoMainCount = self.tbTongDomainCont[szTongName] or self.tbUnionDomainCont[szTongName] or -1
  table.insert(self.tbShowListSortTong, { szTongName, szUnion, nColorId, nDoMainCount })
end

local function OnColorSort(tbA, tbB)
  return tbA[4] > tbB[4]
end

function uiWorldMap_Domain:ShowListColorSort()
  if #self.tbShowListSortTong <= 0 then
    return 0
  end
  if #self.tbShowListSortTong >= 2 then
    table.sort(self.tbShowListSortTong, OnColorSort)
  end
  for nCtlId, tbInfo in ipairs(self.tbShowListSortTong) do
    local szTongName = tbInfo[1]
    local szUnion = tbInfo[2]
    local nColorId = tbInfo[3]
    self.tbCtlId2TongName[nCtlId] = szTongName
    szTongName = szTongName .. szUnion
    Wnd_Show(self.UIGROUP, TXT_TONGSORT .. nCtlId)
    Wnd_Show(self.UIGROUP, IMG_TONGSORT .. nCtlId)
    Txt_SetTxt(self.UIGROUP, TXT_TONGSORT .. nCtlId, szTongName)
    Img_SetImage(self.UIGROUP, IMG_TONGSORT .. nCtlId, 1, DOMAIN_SPR_PATH .. COLORID2SPR[nColorId])
  end
end

function uiWorldMap_Domain:UpdateSortList()
  local nColorId = 0
  self:ClearList()

  local i = 0
  self.tbCtlId2TongName = {}
  self.tbShowListSortTong = {}
  for szTongName, tbColorId in pairs(self.ColorSetting) do
    if tbColorId[1] ~= 11 then
      if tbColorId[1] == 12 then -- 如果是自身帮会颜色
        if self.bSelfInHeadList == 1 then -- 如果是自身帮会在前10名则占一个显示位置
          i = i + 1
          local szUnion = ""
          if self.IsUnion[szTongName] == 1 then
            szUnion = "<color=blue>盟<color>"
          end
          self:ShowList(i, szTongName, tbColorId[1], szUnion)
        end
      else
        i = i + 1
        local szUnion = ""
        if self.IsUnion[szTongName] == 1 then
          szUnion = "<color=blue>盟<color>"
        end
        self:ShowList(i, szTongName, tbColorId[1], szUnion)
      end
    end
  end

  i = i + 1
  for szTongName, tbColorId in pairs(self.ColorSetting) do
    if tbColorId[1] == 11 then
      self:ShowList(i, "其他帮会", tbColorId[1], "")
      break
    end
  end
  self:ShowListColorSort()
end

function uiWorldMap_Domain:OnButtonClick(szWndName, nParam)
  if szWndName == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == BTN_WORLDMAP_GlOBAL then
    UiManager:OpenWindow(Ui.UI_WORLDMAP_GLOBAL, self.nShowMapId)
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == BTN_WORLDMAP_AREA then
    tbMapBar:SelectCurItem(self.UIGROUP)
  end

  if szWndName == BTN_WORLDMAP_SUB then
    UiManager:OpenWindow(Ui.UI_WORLDMAP_SUB, me.nTemplateMapId)
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiWorldMap_Domain:OnMouseEnter(szWnd)
  for nCtlId = 1, 11 do
    if szWnd == IMG_TONGSORT .. nCtlId then
      local szTongName = self.tbCtlId2TongName[nCtlId] or ""
      local szTip = "领土数量："
      if self.tbTongDomainCont[szTongName] then
        szTip = szTip .. self.tbTongDomainCont[szTongName]
      else
        if self.tbUnionDomainCont[szTongName] then
          szTip = szTip .. self.tbUnionDomainCont[szTongName]
        else
          szTip = szTip .. "未知"
        end
      end
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
      break
    end
  end
end

function uiWorldMap_Domain:ReadDomainInfo(szSettingFile)
  local szFile = GetActualPath(szSettingFile)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    Ui:Output("[ERR] uiWorldMap_Domain Domain 配置路径不正确: " .. szFile)
    return 0
  end
  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nDomainId = pTabFile.GetInt(i, 1)
    local szDomainName = pTabFile.GetStr(i, 2)
    local nCenterPosX = pTabFile.GetInt(i, 3)
    local nCenterPosY = pTabFile.GetInt(i, 4)
    local nFightMapId = pTabFile.GetInt(i, 5)
    self.tbDomainInfo[i - 1] = { nDomainId, szDomainName, nCenterPosX, nCenterPosY, nFightMapId }
  end
  KIo.CloseTabFile(pTabFile)
  return 1
end

function uiWorldMap_Domain:LoadForbiddenDomain()
  local szFile = GetActualPath(self.tbDomainSettingFile)
  local pTabFile = KIo.OpenTabFile(szFile)
  if not pTabFile then
    Ui:Output("[ERR] uiWorldMap_Domain Forbidden Domain 配置路径不正确: " .. szFile)
    return 0
  end
  local nHeight = pTabFile.GetHeight()
  for i = 2, nHeight do
    local nDomainId = pTabFile.GetInt(i, 1)
    local szMapType = pTabFile.GetStr(i, 6)
    if szMapType then
      if szMapType == "faction" or szMapType == "city" then
        self.tbForbiddenDomain[nDomainId] = 1
      end

      if szMapType == "village" then
        self.tbVillage[nDomainId] = 1
      end
    end
  end
  KIo.CloseTabFile(pTabFile)
  return 1
end

function uiWorldMap_Domain:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiWorldMap_Domain:OnClose()
  for i = 1, #self.tbAnimation do
    Canvas_DestroyAnimation(self.UIGROUP, IMG_REACT, self.tbAnimation[i])
  end
  self.szMyTongName = nil
  self.szMyUnionName = nil
  self.tbTongSortList = {}
  self.ColorSetting = {}
  self.IsUnion = {}
  self.tbAnimation = {}
end

function uiWorldMap_Domain:MarkPos()
  local nNowMap = me.GetWorldPos()
  if not MODULE_GAMESERVER then
    nNowMap = me.nTemplateMapId
  end
  if self.tbMapInfo then
    for i = 1, #self.tbMapInfo do
      if nNowMap == self.tbMapInfo[i][1] then
        Wnd_SetPos(self.UIGROUP, IMAGE_MARK, self.tbMapInfo[i][2] - MARKOFFSETPOSX, self.tbMapInfo[i][3] - MARKOFFSETPOSY)
        Img_PlayAnimation(self.UIGROUP, IMAGE_MARK, 1)
      end
    end
  end
end

function uiWorldMap_Domain:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_DOMAININFO, self.UpdateAll },
    { UiNotify.emCOREEVENT_SYNC_CURRENTMAP, self.MarkPos },
  }
  return tbRegEvent
end
