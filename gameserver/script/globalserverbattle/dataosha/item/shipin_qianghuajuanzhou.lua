-- 文件名　：shipin_qianghuajuanzhou.lua
-- 创建者　：jiazhenwei
-- 创建时间：2009-10-29 11:24:25
-- 描  述  ：

local tbqianghuajuanzhou = Item:GetClass("shipinqianghua")
tbqianghuajuanzhou.szInfo = "饰品强化卷轴帮您加强饰品，您可以自己使用或是交易给队友。强大的伙伴是您胜利的关键！<color=yellow>最大可强化+14<color>"

function tbqianghuajuanzhou:OnUse()
  local tbOpt = {
    { "使用", self.OnUseEx, self, it.dwId },
    { "交易给队友", DaTaoSha.tbqianghuajuanzhou.Trade, DaTaoSha.tbqianghuajuanzhou, it.dwId, 3 },
    { "关闭" },
  }

  Dialog:Say(self.szInfo, tbOpt)

  return 0
end

function tbqianghuajuanzhou:OnUseEx(nId)
  local tbShiPin = { "强化护身符", "强化戒指", "强化项链", "强化腰坠" }
  local tbOpt = {}
  local nMaxQianghua = 14
  tbOpt = Lib:MergeTable(tbOpt, {
    --Item.EQUIPPOS_HEAD			= 0;		-- 头
    --Item.EQUIPPOS_BODY			= 1;		-- 衣服
    --Item.EQUIPPOS_BELT			= 2;		-- 腰带
    --Item.EQUIPPOS_WEAPON		= 3;		-- 武器
    --Item.EQUIPPOS_FOOT			= 4;		-- 鞋子
    --Item.EQUIPPOS_CUFF			= 5;		-- 护腕
    --Item.EQUIPPOS_AMULET		= 6;		-- 护身符
    --Item.EQUIPPOS_RING			= 7;		-- 戒指
    --Item.EQUIPPOS_NECKLACE		= 8;		-- 项链
    --Item.EQUIPPOS_PENDANT		= 9;		-- 腰坠
    --{"强化武器",  self.OnQiangHua, self ,3, nId},
    --{"强化头盔",  self.OnQiangHua, self, 0, nId},
    --{"强化衣服",  self.OnQiangHua, self, 1, nId},
    --{"强化腰带",  self.OnQiangHua, self, 2, nId},
    --{"强化鞋子",  self.OnQiangHua, self, 4, nId},
    --{"强化护腕",  self.OnQiangHua, self, 5, nId},
    --{"强化护身符",  DaTaoSha.tbqianghuajuanzhou.OnQiangHua, DaTaoSha.tbqianghuajuanzhou, 6, nId},
    --{"强化戒指",  DaTaoSha.tbqianghuajuanzhou.OnQiangHua, DaTaoSha.tbqianghuajuanzhou, 7, nId},
    --{"强化项链",  DaTaoSha.tbqianghuajuanzhou.OnQiangHua, DaTaoSha.tbqianghuajuanzhou, 8, nId},
    --{"强化腰坠",  DaTaoSha.tbqianghuajuanzhou.OnQiangHua, DaTaoSha.tbqianghuajuanzhou, 9, nId},
    { "关闭" },
  })
  if not DaTaoSha:GetPlayerMission(me) then
    return
  end
  if DaTaoSha:GetPlayerMission(me).nLevel ~= 1 then
    nMaxQianghua = 14
  end
  for i = 6, 9 do
    local pEquip = me.GetItem(Item.ROOM_EQUIP, i, 0)
    if pEquip and pEquip.nEnhTimes < nMaxQianghua then
      table.insert(tbOpt, 1, { tbShiPin[i - 5], DaTaoSha.tbqianghuajuanzhou.OnQiangHua, DaTaoSha.tbqianghuajuanzhou, i, nId })
    end
  end
  Dialog:Say(self.szInfo, tbOpt)
  return 0
end
