-- 文件名　：guanggun_npc.lua
-- 创建者　：LQY
-- 创建时间：2012-10-30 15:17:47
-- 说　　明：光棍节NPC
if not MODULE_GAMESERVER then
  return
end
Require("\\script\\event\\jieri\\201211_guanggunjie\\guanggun_def.lua")
local tbGuangGun = SpecialEvent.GuangGun2012

--活动NPC
local tbNpcHuoDongDaShi = Npc:GetClass("2012guanggun_npc")
function tbNpcHuoDongDaShi:OnDialog()
  local szTxt = tbGuangGun.tbNpcChat[MathRandom(1, #tbGuangGun.tbNpcChat)] .. "\n"
  local n, szMsg = tbGuangGun:CheckTime()
  if n ~= 1 then
    Dialog:Say(szTxt .. "<color=yellow>" .. szMsg .. "<color>")
    return
  end
  local tbOpt = {
    { "领取爱神之箭", self.GetArrow, self },
    { "领取情缘祝福", self.GetWishItem, self },
    { "我再想想" },
  }
  Dialog:Say(szTxt, tbOpt)
end

-- 领取爱神箭
function tbNpcHuoDongDaShi:GetArrow()
  local n, szMsg = tbGuangGun:CheckPlayer(me.nId)
  if n == 0 then
    Dialog:Say(szMsg)
    return
  end
  local nGetKey = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GETLOVEARROW)
  if nGetKey == tbGuangGun:GetKey() then
    Dialog:Say("你今天已经领取过爱神之箭了，请明日再来吧。")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("请整理出一格背包再来！")
    return
  end
  --埋点 2012年光棍节活动道具领取 爱神之箭
  StatLog:WriteStatLog("stat_info", "single_2012", "get_item", me.nId, "爱神之箭")
  me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GETLOVEARROW, tbGuangGun:GetKey())
  me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LOVEARROW_COUNT, 0) --使用次数
  me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.LASTUSEARROW, 0) --上次使用的时间
  me.AddItem(unpack(tbGuangGun.LoveArrowId))
  Dialog:SendBlackBoardMsg(me, "你获得了<color=yellow>爱神之箭<color>，快寻找中意的异性开始发射吧")
end
function tbNpcHuoDongDaShi:GetWishItem()
  local n, szMsg = tbGuangGun:CheckPlayer(me.nId)
  if n == 0 then
    Dialog:Say(szMsg)
    return
  end
  if tbGuangGun:IsTimeOk() == 0 then
    Dialog:Say("2012年11月9日-11日每天<color=yellow>12:00-14:00,19:00-23:00<color>才是活动时间段。")
    return
  end
  local nGetKey = me.GetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GETSONG)
  if nGetKey == tbGuangGun:GetKey() then
    Dialog:Say("你今天已经领取过祝福歌谱了，请明日再来吧。")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("请整理出一格背包再来！")
    return
  end
  --埋点 2012年光棍节活动道具领取 歌曲
  StatLog:WriteStatLog("stat_info", "single_2012", "get_item", me.nId, "歌曲")
  me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GETSONG, tbGuangGun:GetKey())
  for _, nId in pairs(tbGuangGun.LIGHTNPC) do --点亮情况归零
    me.SetTask(tbGuangGun.TASK_GROUP, nId, 0)
  end
  me.SetTask(tbGuangGun.TASK_GROUP, tbGuangGun.GIRLGETCOUNT, 0) --女玩家领奖次数
  local tbSong = tbGuangGun.tbSongs[MathRandom(1, #tbGuangGun.tbSongs)]
  me.AddItem(unpack(tbSong[1]))
  Dialog:SendBlackBoardMsg(me, "你获得了歌谱<color=yellow>《" .. tbSong[2] .. "》<color>，快去寻找有相同歌谱的异性吧")
end
