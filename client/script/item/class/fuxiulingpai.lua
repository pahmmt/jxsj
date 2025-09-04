local tbItem = Item:GetClass("fuxiulingpai") --增加洗辅修机会道具

--任务变量
tbItem.TSK_GROUP = 2027
tbItem.TSK_USETIME = 90
tbItem.CD_TIME = 7 * 24 * 60 * 60 -- 辅修令使用间隔时间7天

function tbItem:OnUse()
  --判断CD
  local nCheck, nSec = self:CheckItemCD()
  if nCheck == 0 then
    local szTime = Lib:TimeFullDesc(nSec)
    me.Msg("辅修令牌使用间隔时间需要7天，剩余时间" .. szTime)
    return
  end
  local nCount = Faction:GetMaxModifyTimes(me) - Faction:GetModifyFactionNum(me)
  local tbOpt = {}
  table.insert(tbOpt, { "我确定使用", self.UseItem, self, it.dwId })
  table.insert(tbOpt, { "我再考虑考虑" })
  local szMsg = string.format("您确定使用该道具吗？目前剩余%s次洗辅修机会", nCount)
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:UseItem(nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  if me.DelItem(pItem, Player.emKLOSEITEM_USE) ~= 1 then
    return 0
  end
  Faction:AddExtraModifyTimes(me, 1)
  local nCount = Faction:GetMaxModifyTimes(me) - Faction:GetModifyFactionNum(me)
  local szMsg = string.format("您增加了一次洗辅修机会，目前剩余%s次洗辅修机会", nCount)
  me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, string.format("[活动]增加辅修机会%s次", nCount))
  Dbg:WriteLog(string.format("[使用物品]增加辅修机会%s次", nCount), me.szName)
  me.Msg(szMsg)
  local nCurTime = GetTime()
  me.SetTask(self.TSK_GROUP, self.TSK_USETIME, nCurTime)
  return 1
end

function tbItem:GetTip(nState)
  local nCount = Faction:GetMaxModifyTimes(me) - Faction:GetModifyFactionNum(me)
  local szTip = ""
  szTip = szTip .. string.format("<color=yellow>目前剩余%s次洗辅修机会<color>", nCount)
  return szTip
end

function tbItem:CheckItemCD()
  local nEndTime = me.GetTask(self.TSK_GROUP, self.TSK_USETIME) + self.CD_TIME
  local nRemainSec = nEndTime - GetTime()
  if nRemainSec < 0 then
    return 1, 0
  end
  return 0, nRemainSec
end
