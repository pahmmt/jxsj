-------------------------------------------------------------------
--File: popotip.lua
--Author: lbh
--Date: 2007-12-22 10:17:11
--Describe: адлЛещещбъ╪╜╫е╠╬
-------------------------------------------------------------------
local SZ_FILE_POPO_SETTING = "\\setting\\popo\\popogroup.txt" -- ещещеДжцнд╪Ч

-----------------------------

PopoTip.tbPopoGroup = {} -- ещещвИ

--------------------------- PBULIC ---------------------------

-- ╪╓╩Нещещ
function PopoTip:ShowPopo(nGroupId, szCustomTip)
  local tbPopo = self.tbPopoGroup[nGroupId]
  if not tbPopo then
    return 0
  end
  for i, v in ipairs(tbPopo) do
    local nPopId = v[1]
    local nLevel = v[2]
    if me.nLevel >= nLevel then
      if szCustomTip then
        CoreEventNotify(UiNotify.emCOREEVENT_SET_POPTIP, nPopId, szCustomTip)
      else
        CoreEventNotify(UiNotify.emCOREEVENT_SET_POPTIP, nPopId)
      end
    end
  end
  return 1
end

-- ╧ь╠уещещ
function PopoTip:HidePopo(nGroupId)
  local tbPopo = self.tbPopoGroup[nGroupId]
  if not tbPopo then
    return 0
  end
  for i, v in ipairs(tbPopo) do
    local nPopId = v[1]
    local nLevel = v[2]
    CoreEventNotify(UiNotify.emCOREEVENT_CANCEL_POPTIP, nPopId)
  end
  return 1
end

-- отй╬╣гб╪ещещ
function PopoTip:ShowLoginPopo(szCustomTip)
  if UiVserion == Ui.Version001 then
    self:ShowPopo(19, szCustomTip)
  else
    self:ShowPopo(29, szCustomTip)
  end
end

------------------------- PBULIC - END -------------------------

-- ╪стьещещиХжцнд╪Ч
function PopoTip:LoadPopoSetting(szTabFile)
  local tbPopoFile = Lib:NewClass(Lib.readTabFile, szTabFile)
  local nRow = tbPopoFile:GetRow()
  for i = 0, nRow do
    local nGroupId = tbPopoFile:GetCellInt("GroupId", i)
    if not self.tbPopoGroup[nGroupId] then
      self.tbPopoGroup[nGroupId] = {}
    end
    local nPopoId = tonumber(tbPopoFile:GetCell("PopoId", i))
    local nLevel = tonumber(tbPopoFile:GetCell("Level", i)) or 0
    table.insert(self.tbPopoGroup[nGroupId], { nPopoId, nLevel })
  end
end

PopoTip:LoadPopoSetting(SZ_FILE_POPO_SETTING)
