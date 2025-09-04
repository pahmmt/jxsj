------------------------------------------------------
-- 文件名　：2012_xmas_npc.lua
-- 创建者　：dengyong
-- 创建时间：2012-12-10 16:04:43
-- 描  述  ：
------------------------------------------------------
local tbStartNpc = Npc:GetClass("xmas12_race_dialog_start")

function tbStartNpc:OnDialog(nParam, nFlag)
  nFlag = nFlag or 0

  if nFlag == 0 then
    local szMsg = "<color=pink>圣诞礼物大派送<color><enter><enter>2012年12月18日至2013年1月3日，<color=yellow>每天11:00-23:00<color>,可在我这里化身为圣诞老人，前往固定地点派送礼物，并且收集黄色小星星。途中有可能会遇到其他颜色星星，一定要注意躲开哦。<enter><enter>绿星星--加速      红星星--减速<enter>蓝星星--冰冻      紫星星--传回"
    local tbOpt = {
      { "开始派送", self.OnDialog, self, nParam, 1 },
      { "领取奖励", self.OnDialog, self, nParam, 10000 }, -- 够大！
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
  elseif nFlag == 1 then
    local szMsg = "派送开始后，将变身为圣诞老人，并<color=green>开始计时<color>。<enter><enter>你需要在规定时间内派送完礼物，并<color=green>尽可能多的收集黄色小星星<color>。收集的星星越多，派送的时间越短，最后奖励越丰厚哦。<enter><color=red>注意：切换地图或下线后任务将失败<color><enter><enter>确定要开始派送吗？"
    local tbOpt = {
      { "确定派送", self.OnDialog, self, nParam, 2 },
      { "我再想想" },
    }
    Dialog:Say(szMsg, tbOpt)
  elseif nFlag == 2 then
    local nRet, var = SpecialEvent.Xmas2012:CheckCanRace(me)
    if nRet == 0 then
      Dialog:Say(var)
      return
    end

    SpecialEvent.Xmas2012:StartRaceOnPlayer(me)
  else
    local tbEndNpc = Npc:GetClass("xmas12_race_dialog_end")
    tbEndNpc:OnDialog(0, 0)
  end
end

local tbEndNpc = Npc:GetClass("xmas12_race_dialog_end")
function tbEndNpc:OnDialog(nParam, bSure)
  bSure = bSure or 0

  if bSure == 0 then
    local szMsg = "恭喜你到达了最后的终点！<enter>我这里有以下奖励:<enter><color=pink>【一等奖励】圣诞狂欢礼包<color><enter>完成派送任务并积分达到90分<enter><color=pink>【二等奖励】圣诞其乐礼包<color><enter>完成派送任务积分没有达到90<enter><enter>个人总积分=收集黄星星+剩余时间/5"
    local tbOpt = {
      { "领取奖励", self.OnDialog, self, nParam, 1 },
    }
    Dialog:Say(szMsg, tbOpt)
  else
    SpecialEvent.Xmas2012:GetAward(me)
  end
end
