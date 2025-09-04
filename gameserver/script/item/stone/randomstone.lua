------------------------------------------------------
-- 文件名　：stone_gs.lua
-- 创建者　：dengyong
-- 创建时间：2011-05-30 11:39:20
-- 描  述  ：宝石服务端脚本
------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

Require("\\script\\item\\stone\\define.lua")

local tbRandomStone = Item:GetClass("randomstone")

local tbRandAward = {
  { tbAward = { 18, 1, 114, 6 }, nRate = 4535 },
  { tbAward = { 18, 1, 114, 7 }, nRate = 3916 },
  { tbAward = { 18, 1, 114, 8 }, nRate = 491 },
  { tbAward = { 18, 1, 114, 9 }, nRate = 58 },
  { tbAward = "BaoShiKuang", nRate = 500 },
  { tbAward = "Level2Stone", nRate = 500 },
}
--------------------------------------------宝石业务：升级、兑换、拆解-----------------------------------------------
local tbJieYuChui = { 18, 1, 1312, 1 }

function tbRandomStone:OnUse()
  -- 检测使用条件
  --1. 解玉锤1个
  local nCount = me.GetItemCountInBags(unpack(tbJieYuChui))
  if nCount < 1 then
    local tbOpt = {
      { "购买解玉锤", self.CheckPermission, self, { self.PreBuyJieYuChui, self } },
      { "取消" },
    }

    Dialog:Say("使用物品失败，需要1个<color=yellow>解玉锤<color>。\n\n该物品可在<color=yellow>奇珍阁<color>购买或者每周第5次完成<color=yellow>侠客任务<color>时获得。", tbOpt)
    return 0
  end
  --2. 背包空间1个
  if me.CountFreeBagCell() < 2 then
    Dialog:Say("需要<color=yellow>2格<color>背包空间，整理下再来！")
    return 0
  end
  -- 统计概率
  local nTotalRate = 0
  for i, tbSingle in pairs(tbRandAward) do
    if tbSingle.nRate then
      nTotalRate = tbSingle.nRate + nTotalRate
    end
  end
  -- 计算概率
  local nRand = MathRandom(1, nTotalRate)
  local nIndex = 0
  for i, tbSingle in pairs(tbRandAward) do
    if tbSingle.nRate then
      nRand = nRand - tbSingle.nRate
      if nRand <= 0 then
        nIndex = i
        break
      end
    end
  end
  local nCount = me.ConsumeItemInBags(1, unpack(tbJieYuChui))
  if nCount ~= 0 then
    return 0
  end

  local pItem = nil -- 产生的东西
  -- 判断是否宝石
  if type(tbRandAward[nIndex].tbAward) == "string" and tbRandAward[nIndex].tbAward == "BaoShiKuang" then
    pItem = Item.tbStone:__RandItemGetStone(2, 2)
    if pItem == nil then
      me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "生成原石失败")
      return 0
    end
  elseif type(tbRandAward[nIndex].tbAward) == "string" and tbRandAward[nIndex].tbAward == "Level2Stone" then
    -- 产出限制 2级原石 低级产出（非技能）
    pItem = Item.tbStone:__RandItemGetStone(1, 2, 0, 2)
    if pItem == nil then
      me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "生成宝石失败")
      return 0
    end
  else
    pItem = me.AddItemEx(unpack(tbRandAward[nIndex].tbAward))
    if pItem == nil then
      return 0
    end
  end
  if pItem.GetStoneType() ~= 0 then -- 如果是宝石
    Item.tbStone:BrodcastMsg("宝石原矿", pItem)
  else
    if pItem.nLevel >= 9 then
      local szMsg = "在宝石原矿中获得了<color=yellow>" .. pItem.szName .. "<color>，真是鸿运当头！"
      if me.dwTongId and me.dwTongId > 0 then
        Player:SendMsgToKinOrTong(me, szMsg, 1)
      else
        Player:SendMsgToKinOrTong(me, szMsg, 0)
      end

      me.SendMsgToFriend("您的好友[<color=yellow>" .. me.szName .. "<color>]" .. szMsg)
      KDialog.NewsMsg(1, Env.NEWSMSG_NORMAL, me.szName .. szMsg)
    end
  end
  -- 数据埋点
  StatLog:WriteStatLog("stat_info", "baoshixiangqian", "open", me.nId, string.format("%d_%d_%d_%d,%d_%d_%d_%d", it.nGenre, it.nDetail, it.nParticular, it.nLevel, pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel))

  -- 送一个宝石碎片
  local tbStonePatch = Item.tbStone.tbStonePatch
  me.AddStackItem(tbStonePatch[1], tbStonePatch[2], tbStonePatch[3], tbStonePatch[4], nil, 1)
  return 1
end

function tbRandomStone:PreBuyJieYuChui()
  local tbOpt = {
    { "确定购买", self.CheckPermission, self, { self.BuyJieYuChui, self } },
    { "取消" },
  }

  Dialog:Say("您将花费<color=yellow>" .. Item.tbStone.JIEYUCHUI_PRICE .. "金币<color>购买1个解玉锤，确定吗？", tbOpt)
end

function tbRandomStone:CheckPermission(tbOption)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  if Account:Account2CheckIsUse(me, 4) == 0 then
    Dialog:Say("你正在使用副密码登陆游戏，设置了权限控制，无法进行该操作！")
    return 0
  end
  if me.nCoin < Item.tbStone.JIEYUCHUI_PRICE then
    Dialog:Say("您的金币不足。")
    return 0
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("需要<color=yellow>1格<color>背包空间，整理下再来！")
    return 0
  end
  Lib:CallBack(tbOption)
end

function tbRandomStone:BuyJieYuChui()
  local bRet = me.ApplyAutoBuyAndUse(Item.tbStone.JIEYUCHUI_WAREID, 1, 0)
  if bRet == 1 then
    Dialog:Say("购买成功。")
  else
    Dialog:Say("购买失败。")
  end
end

-- 蒙尘的宝石
local tbUnknowStone = Item:GetClass("unknowstone")

function tbUnknowStone:OnUse()
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("需要<color=yellow>1格<color>背包空间，整理下再来！")
    return 0
  end

  local pItem = Item.tbStone:__RandItemGetStone(1, 1)
  if pItem ~= nil then
    -- 数据埋点
    StatLog:WriteStatLog("stat_info", "baoshixiangqian", "open", me.nId, string.format("%d_%d_%d_%d,%d_%d_%d_%d", it.nGenre, it.nDetail, it.nParticular, it.nLevel, pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel))
    return 1
  else
    print("[ERROR]打开蒙尘宝石失败，异常了！！", me.szAccount, me.szName)
    return 0
  end
end
