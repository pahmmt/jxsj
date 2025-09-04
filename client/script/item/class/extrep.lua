--扩展储物箱
--孙多良
--2008.10.16
--用百十个位来记3种扩展箱道具。

local tbItem = Item:GetClass("extrep")

tbItem.TaskGroup = 2024
tbItem.TaskId = 17

function tbItem:OnUse()
  self:SureUse(it.dwId)
  return 0
end

function tbItem:SureUse(nItemId, nFlag)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 1
  end
  local nTask = me.GetTask(self.TaskGroup, self.TaskId)
  if math.mod(math.floor(nTask / (10 ^ (pItem.nLevel - 1))), 10) > 0 then
    Dialog:Say("您已经使用过了该类型的扩展箱分页道具。")
    return 1
  end
  if not nFlag then
    local tbOpt = {
      { "确定使用", self.SureUse, self, nItemId, 1 },
      { "我再考虑考虑" },
    }
    Dialog:Say("使用本道具将会增加一页储物箱扩展箱分页，但一种类型的储物箱扩展分页道具，<color=red>每个角色只能使用一次<color>，您确定要使用吗？", tbOpt)
    return 1
  end
  local nItemLevel = pItem.nLevel
  if me.DelItem(pItem) == 1 then
    if me.nExtRepState >= Item.EXTREPPOS_NUM then
      Dialog:Say("已达上限。")
      return 1
    end
    me.SetExtRepState(me.nExtRepState + 1)
    me.SetTask(self.TaskGroup, self.TaskId, nTask + 10 ^ (nItemLevel - 1))
    me.Msg("恭喜您获得了1页扩展箱分页。")
  end
  return 1
end

function tbItem:GetTip()
  local nTask = me.GetTask(self.TaskGroup, self.TaskId)
  local nUse = 0
  if math.mod(math.floor(nTask / (10 ^ (it.nLevel - 1))), 10) > 0 then
    nUse = 1
  end
  local szTip = string.format("<color=green>已使用%s/1个<color>", nUse)
  return szTip
end
