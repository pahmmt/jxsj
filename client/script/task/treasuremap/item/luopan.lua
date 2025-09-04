-- 罗盘
TreasureMap.tbLuoPanGift = Gift:New()

local tbGift = TreasureMap.tbLuoPanGift
local tbTreasureMapId = {}

function tbGift:OnSwitch(pPickItem, pDropItem, nX, nY)
  if not pDropItem then
    return 1
  end

  if self:IsTreasureMap(pDropItem) ~= 1 then
    me.Msg("<color=red>罗盘里面只能放藏宝图！<color>")
    return 0
  end

  -- 同时只能有一个藏宝图
  local pFind = self:First()
  if pFind then
    me.Msg("<color=red>一次只能识别一个藏宝图！<color>")
    return 0
  end

  -- 只能放入辨认过的藏宝图
  local nIdentify = pDropItem.GetGenInfo(TreasureMap.ItemGenIdx_IsIdentify) -- 是否是辨认过的藏宝图
  if nIdentify ~= 1 then
    me.Msg("<color=red>只能放入辨认过的藏宝图！<color>")
    return 0
  end

  return 1
end

function tbGift:OnUpdate()
  self._szContent = "请放入所在地图的藏宝图。"
end

function tbGift:OnOK()
  local pTreasureMap = self:First()
  if not pTreasureMap then
    Dialog:SendInfoBoardMsg(me, "<color=red>请放入要识别的藏宝图！<color>")
    return
  end

  if self:IsTreasureMap(pTreasureMap) ~= 1 then
    Dialog:SendInfoBoardMsg(me, "<color=red>请挪走和藏宝图无关的东西！<color>")
    return
  end

  local nIdentify = pTreasureMap.GetGenInfo(TreasureMap.ItemGenIdx_IsIdentify) -- 是否是辨认过的藏宝图
  if nIdentify ~= 1 then
    Dialog:SendInfoBoardMsg(me, "<color=red>罗盘只能识别辨认过的藏宝图！<color>")
    return
  end

  local nTreasureId = pTreasureMap.GetGenInfo(TreasureMap.ItemGenIdx_nTreaaureId) -- 所对应宝藏的编号
  local tbTreasureInfo = TreasureMap:GetTreasureInfo(nTreasureId)

  local nMyMapId, nMyPosX, nMyPosY = me.GetWorldPos()
  local nDestMapId = tbTreasureInfo.MapId
  local nDestPosX = tbTreasureInfo.MapX
  local nDestPosY = tbTreasureInfo.MapY

  if nMyMapId ~= nDestMapId then
    Dialog:SendInfoBoardMsg(me, "<color=red>藏宝图上标注的宝藏不在当前地图！<color>")
    return
  end

  local szMsg, nDistance = TreasureMap:GetDirection({ nMyPosX, nMyPosY }, { nDestPosX, nDestPosY })

  if nDistance > TreasureMap.MAX_POSOFFSET then
    me.Msg("宝藏在你的<color=yellow>" .. szMsg .. "方大约 " .. math.floor(nDistance / 6) .. " 丈<color>处！")
  else
    me.Msg("宝藏就在你的脚下！")
  end
end

function tbGift:IsTreasureMap(pItem)
  if pItem.nGenre == 18 and pItem.nDetail == 1 and pItem.nParticular == 9 then
    return 1
  end

  return 0
end

local tbItem = Item:GetClass("luopan")

function tbItem:OnUse()
  Dialog:Gift("TreasureMap.tbLuoPanGift")
end
