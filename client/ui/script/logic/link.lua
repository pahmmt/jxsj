-- 文件名　：link.lua
-- 创建者　：FanZai
-- 创建时间：2008-03-11 20:40:33

Require("\\ui\\script\\logic\\autopath.lua")
local tbAutoPath = Ui.tbLogic.tbAutoPath

----==== NpcPos类型 ====----
local tbNpcPosLink = {}

function tbNpcPosLink:ParseLink(szLink)
  local tbSplit = Lib:SplitStr(szLink, ",")
  local tbInfo = {
    szDesc = tbSplit[1],
    varMap = tbSplit[2],
    nNpcId = tonumber(tbSplit[3]),
  }
  if tbInfo.szDesc == "" and tbInfo.nNpcId > 0 then
    tbInfo.szDesc = KNpc.GetNameByTemplateId(tbInfo.nNpcId)
  end
  return tbInfo
end

function tbNpcPosLink:GetText(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbInfo.szDesc
end

function tbNpcPosLink:GetTip(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbAutoPath:GetLinkTip(tbInfo)
end

function tbNpcPosLink:OnClick(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbAutoPath:OnLinkClick(tbInfo, tbAutoPath.CBNpc, tbAutoPath, tbInfo.nNpcId, tbInfo.szDesc)
end

function tbNpcPosLink:OnRClick(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbAutoPath:OnLinkRClick(tbInfo, tbAutoPath.CBNpc, tbAutoPath, tbInfo.nNpcId, tbInfo.szDesc)
end

----==== Pos类型 ====----
local tbPosLink = {}

function tbPosLink:ParseLink(szLink)
  local tbSplit = Lib:SplitStr(szLink, ",")
  local tbInfo = {
    szDesc = tbSplit[1],
    varMap = tbSplit[2],
    nX = tonumber(tbSplit[3]),
    nY = tonumber(tbSplit[4]),
  }
  return tbInfo
end

function tbPosLink:GetText(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbInfo.szDesc
end

function tbPosLink:GetTip(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbAutoPath:GetLinkTip(tbInfo)
end

function tbPosLink:OnClick(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbAutoPath:OnLinkClick(tbInfo, tbAutoPath.CBNpc, tbAutoPath, tbInfo.szDesc)
end

function tbPosLink:OnRClick(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbAutoPath:OnLinkRClick(tbInfo, tbAutoPath.CBNpc, tbAutoPath, tbInfo.szDesc)
end

----==== OpenWnd类型 ====----
local tbOpenWndLink = {}

function tbOpenWndLink:ParseLink(szLink)
  local tbSplit = Lib:SplitStr(szLink, ",")
  local tbInfo = {
    szDesc = tbSplit[1],
    szGroup = tbSplit[2],
  }
  if tbSplit[3] then
    tbInfo.nParam = tonumber(tbSplit[3])
  end
  return tbInfo
end

function tbOpenWndLink:GetText(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbInfo.szDesc
end

function tbOpenWndLink:GetTip(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbInfo.szDesc
end

function tbOpenWndLink:OnClick(szLink)
  local tbInfo = self:ParseLink(szLink)
  UiManager:OpenWindow(tbInfo.szGroup, tbInfo.nParam)
end

----==== Url类型 ====----
local tbUrlLink = {}

function tbUrlLink:ParseLink(szLink)
  local tbSplit = Lib:SplitStr(szLink, ",")
  local tbInfo = {
    szText = tbSplit[1],
    szTip = tbSplit[2],
    szUrl = tbSplit[3],
  }

  return tbInfo
end

function tbUrlLink:GetText(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbInfo.szText
end

function tbUrlLink:GetTip(szLink)
  local tbInfo = self:ParseLink(szLink)
  return tbInfo.szTip
end

function tbUrlLink:OnClick(szLink)
  local tbInfo = self:ParseLink(szLink)
  OpenWebSite(tbInfo.szUrl)
end

---------------------------------------------------------------------------------------
UiManager.tbLinkClass = {
  ["pos"] = tbPosLink,
  ["npcpos"] = tbNpcPosLink,
  ["openwnd"] = tbOpenWndLink,
  ["url"] = tbUrlLink,
}
