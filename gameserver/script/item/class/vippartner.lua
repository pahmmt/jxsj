-- 文件名　：vippartner.lua
-- 创建者　：zounan
-- 创建时间：2010-01-13 10:23:55
-- 描  述  ：

local tbItem = Item:GetClass("gamefriend2")
tbItem.nPotenId = 241
tbItem.nNpcTempId = 6803

function tbItem:OnUse()
  if Partner.bOpenPartner ~= 1 then
    Dialog:Say("现在同伴活动已经关闭，无法使用物品")
    return 0
  end

  --先检测100级 再查看是否开服150
  if me.nLevel < 100 then
    me.Msg("您未有召唤同伴的实力，还是等100级再试吧。")
    return
  end

  if TimeFrame:GetStateGS("OpenLevel150") ~= 1 then
    me.Msg("当前服务器还不能使用同伴")
    return
  end

  if me.nFaction == 0 then
    me.Msg("你无门无派召唤不了同伴。")
    return
  end

  if me.nPartnerCount >= me.nPartnerLimit then
    me.Msg("您的同伴个数已满！")
    return 0
  end

  local szInfo = "同伴能力值选取："
  local tbOpt = {
    { "身法50%，外功50%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 1 },
    { "外功50%，内功50%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 2 },
    { "力量30%，身法30%，外功40%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 3 },
    { "力量30%，身法20%，外功50%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 4 },
    { "力量40%，身法20%，外功40%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 5 },
    { "力量40%，身法30%，外功30%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 6 },
    { "力量40%，身法10%，外功50%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 7 },
    { "力量40%，身法10%，外功10%，内功40%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 8 },
    { "力量50%，身法20%，外功30%", self.SelectSeries, self, self.nNpcTempId, it.dwId, 9 },
    { "我再想想" },
  }
  Dialog:Say(szInfo, tbOpt)
  return 0
end

function tbItem:SelectSeries(nNpcTempId, nItemId, nPotenTemplId)
  local szInfo = "同伴五行值选取：\n  推荐<color=yellow>选择和自己五行值一样<color>的，否则同伴的某些技能或是属性可能会没有用处。"
  local tbOpt = {
    { "金系", self.Select, self, nNpcTempId, nItemId, 1, nPotenTemplId },
    { "木系", self.Select, self, nNpcTempId, nItemId, 2, nPotenTemplId },
    { "水系", self.Select, self, nNpcTempId, nItemId, 3, nPotenTemplId },
    { "火系", self.Select, self, nNpcTempId, nItemId, 4, nPotenTemplId },
    { "土系", self.Select, self, nNpcTempId, nItemId, 5, nPotenTemplId },
    { "取消" },
  }
  Dialog:Say(szInfo, tbOpt)
  return 0
end

function tbItem:Select(nNpcTempId, nItemId, nSeries, nPotenTemplId)
  local pItem = KItem.GetObjById(nItemId)
  if pItem then
    local nRes = Partner:AddPartner(me.nId, nNpcTempId, nSeries, nPotenTemplId)
    if nRes ~= 0 then
      pItem.Delete(me)
      EventManager:WriteLog(string.format("[使用贴心同伴道具]获得一个模板Id为：%s 的同伴", nPotenTemplId), me)
      me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("[使用贴心同伴道具]获得一个模板Id为：%s 的同伴", nPotenTemplId))
    end
  end
end
