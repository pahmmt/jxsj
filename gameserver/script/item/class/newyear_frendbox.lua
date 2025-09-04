-- 文件名　：newyear_frendbox.lua
-- 创建者　：jiazhenwei
-- 创建时间：2010-01-21 10:44:47
-- 描  述  ：新年同伴

local tbItem = Item:GetClass("gamefriend1")

function tbItem:OnUse()
  if Partner.bOpenPartner ~= 1 then
    Dialog:Say("现在同伴活动已经关闭，无法使用物品")
    return 0
  end

  local szInfo = "选取同伴："
  if me.nLevel < 100 then
    me.Msg("您的等级小于100级还不能使用该物品！")
    return 0
  end
  if me.nFaction == 0 then
    me.Msg("您没有门派还不能使用该物品！")
    return 0
  end
  if me.nPartnerCount >= me.nPartnerLimit then
    me.Msg("您的同伴个数已满！")
    return 0
  end
  local tbOpt = { { "选择女同伴", self.SelectTemp, self, 6802, it.dwId }, { "选择男同伴", self.SelectTemp, self, 6801, it.dwId }, { "取消" } }
  Dialog:Say(szInfo, tbOpt)
  return 0
end

function tbItem:SelectTemp(nNpcTempId, nItemId)
  local szInfo = "同伴能力值选取："
  local tbOpt = {
    { "身法50%，外功50%", self.SelectSeries, self, nNpcTempId, nItemId, 1 },
    { "外功50%，内功50%", self.SelectSeries, self, nNpcTempId, nItemId, 2 },
    { "力量30%，身法30%，外功40%", self.SelectSeries, self, nNpcTempId, nItemId, 3 },
    { "力量30%，身法20%，外功50%", self.SelectSeries, self, nNpcTempId, nItemId, 4 },
    { "力量40%，身法20%，外功40%", self.SelectSeries, self, nNpcTempId, nItemId, 5 },
    { "力量40%，身法30%，外功30%", self.SelectSeries, self, nNpcTempId, nItemId, 6 },
    { "力量40%，身法10%，外功50%", self.SelectSeries, self, nNpcTempId, nItemId, 7 },
    { "力量40%，身法10%，外功10%，内功40%", self.SelectSeries, self, nNpcTempId, nItemId, 8 },
    { "力量50%，身法20%，外功30%", self.SelectSeries, self, nNpcTempId, nItemId, 9 },
    { "取消" },
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
      EventManager:WriteLog(string.format("[使用新年同伴道具]获得一个模板Id为：%s 的同伴", nPotenTemplId), me)
      me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("[使用新年同伴道具]获得一个模板Id为：%s 的同伴", nPotenTemplId))
    end
  end
end
