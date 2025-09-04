-- 文件名　：repute_seller.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-09-07 15:26:46
-- 描述：统一的声望装备购买npc

---稀有装备购买npc
local tbXiyouEquipNpc = Npc:GetClass("xiyouequip_npc")

local tbXiyoEquipShopId = {
  [1] = 201,
  [2] = 202,
  [3] = 203,
  [4] = 204,
  [5] = 205,
  [6] = 206,
  [7] = 238,
}

function tbXiyouEquipNpc:OnDialog()
  local szMsg = "    我这里卖的是稀有装备。若要想要更低等的装备，我可以介绍几人。\n<color=yellow>武器<color>:临安府特制武器贩卖商\n<color=yellow>衣服<color>:各门派掌门\n<color=yellow>腰坠<color>:义军军需官\n<color=yellow>腰带<color>:宋金招募使\n<color=yellow>护腕<color>:家族关卡接引人\n<color=yellow>项链<color>:白虎堂护卫"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "购买稀有武器", self.OnBuyXiyouEquip, self, 1, me.nId }
  tbOpt[#tbOpt + 1] = { "购买稀有衣服", self.OnBuyXiyouEquip, self, 2, me.nId }
  tbOpt[#tbOpt + 1] = { "购买稀有腰坠", self.OnBuyXiyouEquip, self, 3, me.nId }
  tbOpt[#tbOpt + 1] = { "购买稀有腰带", self.OnBuyXiyouEquip, self, 4, me.nId }
  tbOpt[#tbOpt + 1] = { "购买稀有护腕", self.OnBuyXiyouEquip, self, 5, me.nId }
  tbOpt[#tbOpt + 1] = { "购买稀有项链", self.OnBuyXiyouEquip, self, 6, me.nId }
  tbOpt[#tbOpt + 1] = { "购买稀有鞋子", self.OnBuyXiyouEquip, self, 7, me.nId }
  tbOpt[#tbOpt + 1] = { "我再想一想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbXiyouEquipNpc:OnBuyXiyouEquip(nType, nId)
  local pPlayer = KPlayer.GetPlayerObjById(nId)
  if not pPlayer then
    return 0
  end
  if not nType or not tbXiyoEquipShopId[nType] then
    return 0
  end
  pPlayer.OpenShop(tbXiyoEquipShopId[nType], 1)
end

----炼化图纸npc
local tbRefinePicNpc = Npc:GetClass("refinepic_npc")

local tbRefinePicShopId = {
  [1] = 207,
  [2] = 208,
  [3] = 209,
  [4] = 210,
  [5] = 197,
}

function tbRefinePicNpc:OnDialog()
  local szMsg = "    哟！这位少侠，又见面了，缘分呐！我这有几件宝物的制作方子，喜欢就拿去吧。"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "购买逍遥套装炼化图谱", self.OnBuyRefinePic, self, 1, me.nId }
  tbOpt[#tbOpt + 1] = { "购买联赛套装炼化图谱", self.OnBuyRefinePic, self, 2, me.nId }
  tbOpt[#tbOpt + 1] = { "购买逐鹿套装炼化图谱", self.OnBuyRefinePic, self, 3, me.nId }
  tbOpt[#tbOpt + 1] = { "购买始皇套装炼化图谱", self.OnBuyRefinePic, self, 4, me.nId }
  tbOpt[#tbOpt + 1] = { "购买忠魂腰带炼化图谱", self.OnBuyRefinePic, self, 5, me.nId }
  tbOpt[#tbOpt + 1] = { "兑换青铜武器炼化图谱", self.ChangeQingtongWeaponPic, self, me.nId }
  tbOpt[#tbOpt + 1] = { "我再想一想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbRefinePicNpc:ChangeQingtongWeaponPic()
  local bGreenServer = KGblTask.SCGetDbTaskInt(DBTASK_TIMEFRAME_OPEN)
  local nType = Ladder:GetType(0, 2, 1, 0) or 0 -- 由于ladder的tbconfig没有gs副本，所有特殊处理，获取战斗力等级排行榜的type
  local tbInfo = GetHonorLadderInfoByRank(nType, 50) -- 等级排行榜第50名
  local nLadderLevel = 0
  if tbInfo then
    nLadderLevel = tbInfo.nHonor
  end
  if Boss.Qinshihuang:_CheckState() ~= 1 then
    Dialog:Say("对不起，秦始皇陵系统暂时关闭，无法兑换青铜武器炼化图谱", { "我知道了" })
    return
  end
  if bGreenServer == 1 then --绿色服务器限制
    if nLadderLevel < 100 then
      Dialog:Say("对不起，皇陵还未开放，无法兑换青铜武器炼化图谱。", { "我知道了" })
      return
    end
  end
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    Dialog:Say("对不起，皇陵还未开放，无法兑换青铜武器炼化图谱。", { "我知道了" })
    return
  end
  local szMsg = "    可以用声望或者和氏璧兑换青铜武器炼化图谱。"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "我要兑换青铜武器炼化图谱", Npc:GetClass("qinling_safenpc2_1").ChangeRefine, Npc:GetClass("qinling_safenpc2_1") }
  tbOpt[#tbOpt + 1] = { "声望兑换青铜武器炼化图谱", Npc:GetClass("qinling_safenpc2_1").OnChangeReputeToRefine, Npc:GetClass("qinling_safenpc2_1") }
  tbOpt[#tbOpt + 1] = { "我再想一想" }
  Dialog:Say(szMsg, tbOpt)
  return 1
end

function tbRefinePicNpc:OnBuyRefinePic(nType, nId)
  if not nType or not tbRefinePicShopId[nType] then
    return 0
  end
  me.OpenShop(tbRefinePicShopId[nType], 1)
end

----声望防具npc
local tbReputeAromrNpc = Npc:GetClass("shengwangaromr_npc")

local tbReputeAromrShopId = {
  [1] = 211,
  [2] = 212,
  [3] = 213,
  [4] = 214,
  [5] = 215,
}

function tbReputeAromrNpc:OnDialog()
  local szMsg = "    我这个人喜欢结交天下朋友。我最喜欢的那句诗便是劝君更尽一杯酒，西出阳关无故人。"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "购买领土声望帽子", self.OnBuyReputeAromr, self, 1, me.nId }
  tbOpt[#tbOpt + 1] = { "购买联赛声望衣服", self.OnBuyReputeAromr, self, 2, me.nId }
  tbOpt[#tbOpt + 1] = { "购买2008盛夏声望腰带", self.OnBuyReputeAromr, self, 3, me.nId }
  tbOpt[#tbOpt + 1] = { "购买寒武遗迹声望护腕", self.OnBuyReputeAromr, self, 4, me.nId }
  tbOpt[#tbOpt + 1] = { "购买民族大团圆声望鞋子", self.OnBuyReputeAromr, self, 5, me.nId }
  tbOpt[#tbOpt + 1] = { "我再想一想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbReputeAromrNpc:OnBuyReputeAromr(nType, nId)
  if not nType or not tbReputeAromrShopId[nType] then
    return 0
  end
  me.OpenShop(tbReputeAromrShopId[nType], 1)
end

----声望首饰npc
local tbReputeJewelryNpc = Npc:GetClass("shengwangjewelry_npc")

local tbReputeJewelryShopId = {
  [1] = 216,
  [2] = 217,
  [3] = 218,
  [4] = 219,
}

function tbReputeJewelryNpc:OnDialog()
  local szMsg = "    男子带玉佩，女子挂香囊。小女子铺子内新到一批极品手工艺品，走过路过不要错过哟！"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "购买2010盛夏声望项链", self.OnBuyReputeJewelry, self, 1, me.nId }
  tbOpt[#tbOpt + 1] = { "购买武林大会声望戒指", self.OnBuyReputeJewelry, self, 2, me.nId }
  tbOpt[#tbOpt + 1] = { "购买跨服联赛声望腰坠", self.OnBuyReputeJewelry, self, 3, me.nId }
  tbOpt[#tbOpt + 1] = { "购买祈福声望护身符", self.OnBuyReputeJewelry, self, 4, me.nId }
  tbOpt[#tbOpt + 1] = { "我再想一想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbReputeJewelryNpc:OnBuyReputeJewelry(nType, nId)
  if not nType or not tbReputeJewelryShopId[nType] then
    return 0
  end
  me.OpenShop(tbReputeJewelryShopId[nType], 1)
end

----白银，黄金武器npc
local tbReputeWeaponNpc = Npc:GetClass("shengwangweapon_npc")

local tbReputeWeaponShopId = {
  [1] = 220,
  [2] = 221,
  [3] = 222,
  [4] = 223,
  [5] = 224,
}

function tbReputeWeaponNpc:OnDialog()
  local bGreenServer = KGblTask.SCGetDbTaskInt(DBTASK_TIMEFRAME_OPEN)
  local nType = Ladder:GetType(0, 2, 1, 0) or 0 -- 由于ladder的tbconfig没有gs副本，所有特殊处理，获取战斗力等级排行榜的type
  local tbInfo = GetHonorLadderInfoByRank(nType, 50) -- 等级排行榜第50名
  local nLadderLevel = 0
  if tbInfo then
    nLadderLevel = tbInfo.nHonor
  end
  if Boss.Qinshihuang:_CheckState() ~= 1 then
    Dialog:Say("对不起，秦始皇陵系统暂时关闭，无法购买120级武器", { "我知道了" })
    return
  end
  if bGreenServer == 1 then --绿色服务器限制
    if nLadderLevel < 100 then
      Dialog:Say("对不起，皇陵还未开放，无法购买120级武器。", { "我知道了" })
      return
    end
  end
  if TimeFrame:GetState("OpenBoss120") ~= 1 then
    Dialog:Say("对不起，皇陵还未开放，无法购买120级武器。", { "我知道了" })
    return
  end
  local szMsg = "    前夜我做了一场梦，梦中一个叫白苗苗的女子给了我一大批武器，托我交与有缘人。第二天醒来我居然发现屋内尽是武器，如梦中所见一般。据说这都是从各个帝王古墓里收集来的神兵利器，你可是那有缘人？"
  local tbOpt = {}
  tbOpt[#tbOpt + 1] = { "购买120级武器<color=gold>（金）<color>", self.OnBuyReputeWeapon, self, 1, me.nId }
  tbOpt[#tbOpt + 1] = { "购买120级武器<color=gold>（木）<color>", self.OnBuyReputeWeapon, self, 2, me.nId }
  tbOpt[#tbOpt + 1] = { "购买120级武器<color=gold>（水）<color>", self.OnBuyReputeWeapon, self, 3, me.nId }
  tbOpt[#tbOpt + 1] = { "购买120级武器<color=gold>（火）<color>", self.OnBuyReputeWeapon, self, 4, me.nId }
  tbOpt[#tbOpt + 1] = { "购买120级武器<color=gold>（土）<color>", self.OnBuyReputeWeapon, self, 5, me.nId }
  tbOpt[#tbOpt + 1] = { "我再想一想" }
  Dialog:Say(szMsg, tbOpt)
end

function tbReputeWeaponNpc:OnBuyReputeWeapon(nType, nId)
  if not nType or not tbReputeWeaponShopId[nType] then
    return 0
  end
  me.OpenShop(tbReputeWeaponShopId[nType], 1)
end
