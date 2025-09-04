-- 文件名　：wuqi_qianghuajuanzhou.lua
-- 创建者　：jiazhenwei
-- 创建时间：2009-10-29 11:29:01
-- 描  述  ：

local tbqianghuajuanzhou = Item:GetClass("wuqiqianghua")
tbqianghuajuanzhou.szInfo = "武器强化卷轴帮您加强武器，您可以自己使用或是交易给队友，打造一个超级强力的队友！<color=yellow>最大可强化+%s<color>"

function tbqianghuajuanzhou:OnUse()
  local nMaxQianghua = 14
  local tbOpt = {
    { "交易给队友", DaTaoSha.tbqianghuajuanzhou.Trade, DaTaoSha.tbqianghuajuanzhou, it.dwId, 1 },
    { "关闭" },
  }
  local pEquip = me.GetItem(Item.ROOM_EQUIP, 3, 0)
  if not DaTaoSha:GetPlayerMission(me) then
    return
  end
  if DaTaoSha:GetPlayerMission(me).nLevel ~= 1 then
    nMaxQianghua = 14
  end
  if pEquip and pEquip.nEnhTimes < nMaxQianghua then
    table.insert(tbOpt, 1, { "强化武器", DaTaoSha.tbqianghuajuanzhou.OnQiangHua, DaTaoSha.tbqianghuajuanzhou, 3, it.dwId })
  end
  Dialog:Say(string.format(self.szInfo, nMaxQianghua), tbOpt)

  return 0
end
