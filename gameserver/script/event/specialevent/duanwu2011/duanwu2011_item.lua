-- 文件名　：duanwu2011_item.lua
-- 创建者　：huangxiaoming
-- 创建时间：2011-05-17 09:46:10
-- 描  述  ：

Require("\\script\\event\\specialevent\\duanwu2011\\duanwu2011_def.lua")
SpecialEvent.DuanWu2011 = SpecialEvent.DuanWu2011 or {}
local tbDuanWu2011 = SpecialEvent.DuanWu2011 or {}

-- 材料
local tbMaterial = Item:GetClass("duanwu2011_material")

function tbMaterial:OnUse()
  local nRet, szMsg = tbDuanWu2011:CheckCanUse(me)
  if nRet ~= 1 then
    me.Msg(szMsg)
    return 0
  end
  local nTodayRemainNum = tbDuanWu2011:CheckTodayMakeRemainNum(me)
  local szMsg = string.format("你今天一共还能制作<color=yellow>%s个<color>粽子。\n\n确定制作？", nTodayRemainNum)
  local tbOpt = {
    { "确定制作", self.MakeDumpling, self, nTodayRemainNum },
    { "我再想想" },
  }
  Dialog:Say(szMsg, tbOpt)
  return 0
end

function tbMaterial:MakeDumpling(nNum)
  Dialog:AskNumber("请输入制作的数量：", nNum, tbDuanWu2011.MakeDumplingDlg, tbDuanWu2011)
end

-- 粽子
local tbDumpling = Item:GetClass("duanwu2011_dumpling")

function tbDumpling:OnUse()
  local nRet, szMsg = tbDuanWu2011:CheckCanUse(me)
  if nRet ~= 1 then
    me.Msg(szMsg)
    return 0
  end
  nRet, szMsg = tbDuanWu2011:CheckCanFish(me)
  if nRet ~= 1 then
    me.Msg(szMsg)
    return 0
  end
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SITE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_DEATH,
  }

  GeneralProcess:StartProcess("投粽喂食中", 10 * Env.GAME_FPS, { SpecialEvent.DuanWu2011.FeedingFish, SpecialEvent.DuanWu2011, me.nId }, nil, tbEvent)
  return 0
end

-- 勋章
local tbMedals = Item:GetClass("duanwu2011_medals")

function tbMedals:OnUse()
  local nRet, szMsg = tbDuanWu2011:CheckCanUse(me)
  if nRet ~= 1 then
    me.Msg(szMsg)
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  if nKinId == 0 or nMemberId == 0 then
    me.Msg("必须加入家族才能使用勋章。")
    return 0
  end
  local cKin = KKin.GetKin(nKinId)
  if not cKin then
    me.Msg("必须加入家族才能使用勋章。")
    return 0
  end
  GCExcute({ "SpecialEvent.DuanWu2011:AddMedals_GC", nKinId, tbDuanWu2011.MEDALS_POINT, me.nId })
  Dbg:WriteLog("duanwu2011", "usemedals", me.szName, nKinId)
  me.Msg("使用成功，您为自己的家族增加了5点家族端午忠魂积分。")
  return 1
end

-- 忠魂令牌
local tbLingPai = Item:GetClass("duanwu2011_lingpai")

function tbLingPai:OnUse()
  local nDate = tonumber(GetLocalDate("%Y%m%d"))
  if nDate < tbDuanWu2011.RANK_OPEN_DAY then
    Dialog:Say("活动都还没开始，你的令牌哪里来的？")
    return 0
  end
  if nDate > tbDuanWu2011.RANK_CLOSE_DAY then
    Dialog:Say("本次活动已结束。")
    return 0
  end
  local nKinId, nMemberId = me.GetKinMember()
  if Kin:CheckSelfRight(nKinId, nMemberId, 2) ~= 1 then
    Dialog:Say("只有族长和副族长才能使用该令牌哦。")
    return 0
  end
  if GetMapType(me.nMapId) ~= "fight" then
    Dialog:Say("该道具只能在野外地图使用。")
    return 0
  end
  local tbNpcList = KNpc.GetAroundNpcList(me, 10)
  for _, pNpc in ipairs(tbNpcList) do
    if pNpc.nTemplateId == tbDuanWu2011.NPC_QUYUAN_ID then
      Dialog:Say("这里已经有了屈原的忠魂，还是换个地方再进行召唤吧。")
      return 0
    end
  end
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SITE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
    Player.ProcessBreakEvent.emEVENT_DEATH,
  }

  GeneralProcess:StartProcess("召唤BOSS中", 5 * Env.GAME_FPS, { SpecialEvent.DuanWu2011.AddDuanWuZhongHun, SpecialEvent.DuanWu2011, me.nId }, nil, tbEvent)
  return 0
end

-- 霸王鱼
local tbBaWangYu = Item:GetClass("duanwu2011_bawangyu")

function tbBaWangYu:OnUse()
  if me.CountFreeBagCell() < 2 then
    Dialog:Say("背包空间不足，至少需要<color=yellow>2个<color>背包空间。")
    return 0
  end
  local tbRandomItem = Item:GetClass("randomitem")
  local nRet = tbRandomItem:OnUse()
  if nRet ~= 1 then
    return 0
  end
  -- 没有背包直接返回
  if me.CountFreeBagCell() < 1 then
    return 1
  end
  local nHonorRank = PlayerHonor:GetPlayerHonorRankByName(me.szName, PlayerHonor.HONOR_CLASS_MONEY, 0)
  local nType = 1
  if not nHonorRank or nHonorRank <= 0 or nHonorRank > tbDuanWu2011.MIN_WEALTHORDER then
    nType = 2
  end
  if tbDuanWu2011:RandFragment(nType) ~= 1 then
    return 1
  end
  local pItem = me.AddItem(unpack(tbDuanWu2011.ITEM_FRAGMENT_ID))
  StatLog:WriteStatLog("stat_info", "duanwujie_2011", "repute_item", me.nId, 1)
  if not pItem then
    Dbg:WriteLog("tbDuanWu201", "add_suipian_failure", me.szName, nHonorRank)
  end
  return 1
end

-- 碎片
local tbFragment = Item:GetClass("duanwu2011_fragment")

function tbFragment:OnUse()
  local nFlag = Player:AddRepute(me, 13, 1, tbDuanWu2011.DUANWU_REPUTE)

  if 0 == nFlag then
    return
  elseif 1 == nFlag then
    me.Msg("您已经达到端午忠魂声望最高等级，将无法使用端午忠魂石碎片。")
    return
  end

  me.Msg(string.format("您获得<color=yellow>%s点<color>端午忠魂声望.", tbDuanWu2011.DUANWU_REPUTE))
  return 1
end
