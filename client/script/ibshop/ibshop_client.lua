------------------------------------------
--	文件名  ：	ibshop.lua
--	创建者  ：	ZouYing@kingsoft.net
--	创建时间：	2007-12-4 16:20
------------------------------------------

IbShop.bShowInfo = 1

if not MODULE_GAMECLIENT then
  return
end

--==========================================================================

-- 用来保存商品列表，组织形式为{[nWareZone] = {[nWareType] = {[nIndex] = nWareId}}}
IbShop.tbWareList = {}

--==========================================================================

function IbShop:Init()
  self.tbWareList = {}
end

function IbShop:UnInit()
  self.tbWareList = {}
end

-- 向tbWareList当中添加商品id
function IbShop:AddWare(nWareZone, nWareType, tbWareList)
  if nWareZone < self.GOLD_SECTION or nWareZone > self.INTEGRAL_SECTION or nWareType <= 0 or not tbWareList or #tbWareList == 0 then
    return
  end

  if not self.tbWareList[nWareZone] then
    self.tbWareList[nWareZone] = {}
  end
  if not self.tbWareList[nWareZone][nWareType] then
    self.tbWareList[nWareZone][nWareType] = {}
  end
  for _, nWareId in pairs(tbWareList) do
    local bExist = 0
    for _, nExistWareId in pairs(self.tbWareList[nWareZone][nWareType]) do
      if nWareId == nExistWareId then
        bExist = 1
        break
      end
    end
    if 0 == bExist then
      local nIndex = Lib:CountTB(self.tbWareList[nWareZone][nWareType]) + 1
      self.tbWareList[nWareZone][nWareType][nIndex] = nWareId
    end
  end
end

-- 获取商品id列表
-- 商品区，商品类型，起始索引，申请数量
function IbShop:GetWareList(nWareZone, nWareType, nFirstIndex, nCount)
  if nWareZone < self.GOLD_SECTION or nWareZone > self.INTEGRAL_SECTION or nWareType <= 0 or nFirstIndex < 0 or nCount <= 0 then
    return
  end
  if not self.tbWareList[nWareZone] or not self.tbWareList[nWareZone][nWareType] then
    return
  end
  local nMaxIndex = Lib:CountTB(self.tbWareList[nWareZone][nWareType])
  if nMaxIndex < nFirstIndex then
    return
  end

  local tbResult = {}
  local nIndex = nFirstIndex + 1
  for i = 1, nCount do
    if self.tbWareList[nWareZone][nWareType][nIndex] then
      tbResult[i] = self.tbWareList[nWareZone][nWareType][nIndex]
      nIndex = nIndex + 1
    else
      break
    end
  end

  return tbResult
end

function IbShop:ReadFile()
  self.UiSort_Bnt = {}
  local tbFile = Lib:LoadTabFile("\\setting\\ibshop\\zone_waretype.txt")
  if not tbFile then
    print("指引文件读取错误！")
    return
  end
  for nId, tbParam in ipairs(tbFile) do
    if nId >= 1 then
      local nZoneId = tonumber(tbParam["商品区ID"]) or 0
      local nTypeId = tonumber(tbParam["商品类别ID"]) or 0
      self.UiSort_Bnt[nZoneId + 1] = self.UiSort_Bnt[nZoneId + 1] or {}
      table.insert(self.UiSort_Bnt[nZoneId + 1], nTypeId)
    end
  end
end

IbShop:ReadFile()
