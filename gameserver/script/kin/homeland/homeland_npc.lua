-- 文件名　：homeland_npc.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-06-14 14:44:10
-- 描  述  ：

Require("\\script\\kin\\homeland\\homeland_def.lua")

function HomeLand:OnEnterDialog()
  local szMsg = "   家是依靠的翅膀，借助她的力量，你可以翱翔蓝天，家是停泊的港湾。在每一个路口的转角，不管江湖如何躁动，这里永远是你值得留恋的地方。"
  local nKinId, nMemberId = me.GetKinMember()
  if nKinId <= 0 then
    Dialog:Say("等你加入了家族再来找我吧。")
    return 0
  end
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    Dialog:Say("等你加入了家族再来找我吧。")
    return 0
  end
  if cKin.GetIsOpenHomeLand() == 0 then
    local nRet, cKin = Kin:CheckSelfRight(nKinId, nMemberId, 1)
    if nRet ~= 1 then
      Dialog:Say("让你们族长先来开启属于你们的家族领地吧")
      return 0
    end
    local tbOpt = {
      { "开启家族领地", self.OpenHomeLand, self },
      { "随便看看" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end

  local tbOpt = {
    { "进入家族领地", self.EnterHomeLand, self },
    { "随便看看" },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 以me进入家族
function HomeLand:EnterHomeLand()
  local nKinId, nMemberId = me.GetKinMember()
  if nKinId <= 0 then
    Dialog:Say("等你加入了家族再来找我吧。")
    return 0
  end
  local nMapId, szMsg = self:GetMapIdByKinId(nKinId)
  if nMapId <= 0 then
    Dialog:Say(szMsg)
    return 0
  end
  me.NewWorld(nMapId, self.ENTER_POS[1], self.ENTER_POS[2])
end

function HomeLand:OpenHomeLand()
  local nKinId, nMemberId = me.GetKinMember()
  if nKinId <= 0 then
    Dialog:Say("等你加入了家族再来找我吧。")
    return 0
  end
  local nRet, cKin = Kin:CheckSelfRight(nKinId, nMemberId, 1)
  if nRet ~= 1 then
    Dialog:Say("让你们族长先来开启属于你们的家族领地吧")
    return 0
  end
  if not self.tbLastWeekRank then
    return 0
  end
  if self:CheckFirstWeek() == 0 then
    if not self.tbLastWeekKinId2Index[nKinId] then
      Dialog:Say(string.format("等你的家族江湖总威望达到服务器前%s名再来找我吧。", self.MAX_LADDER_RNAK))
      return 0
    end
    if self.tbLastWeekKinId2Index[nKinId] > self.MAX_LADDER_RNAK then
      Dialog:Say(string.format("等你的家族江湖总威望达到服务器前%s名再来找我吧。", self.MAX_LADDER_RNAK))
      return 0
    end
    GCExcute({ "HomeLand:OpenHomeLand_GC", nKinId, nMemberId, me.nId })
  else
    local nCount = 0
    for _, _ in pairs(self.tbKinId2MapId) do
      nCount = nCount + 1
    end
    if nCount >= self.MAX_LADDER_RNAK then -- 最多开启200个，防止无限制出地图
      Dialog:Say("你来晚了，所有的家族领地都被申请了，等家族排行榜更新之后再来开启吧。")
      return 0
    end
    GCExcute({ "HomeLand:NewServerOpenHomeLand_GC", nKinId, nMemberId, me.nId })
  end
end
