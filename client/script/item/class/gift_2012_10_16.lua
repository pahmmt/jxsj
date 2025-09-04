----gift_2012_10_16.lua
----作者：孙多良
----2012-10-10
----info：【新·剑侠世界】公测豪华礼包

local tbItem = Item:GetClass("gift_2012_10_16")
tbItem.Tsk_GroupId = 2027
tbItem.Tsk_UseId = 266 --是否使用过，每个玩家只能使用一次。

tbItem.Gift_List = {
  {
    nLevel = 1,
    nBagFree = 12, --背包空间
    tbItem = {
      --类型（1,物品,2称号，3绑银，4绑金），g,d,p,l,nCount,LimitTime天
      { 2, "古墓情缘", 60, "Purple" },
      { 1, 18, 1, 1764, 1, 1, 7 }, --月光宝盒·小
      { 1, 18, 1, 1841, 1, 1, 7 }, --面具箱
      { 1, 18, 1, 394, 1, 4, 30 }, --7折优惠券
      { 1, 18, 1, 395, 1, 1, 30 }, --9折优惠券
      { 1, 18, 1, 1, 5, 4, 0 }, --5级玄晶
      { 1, 18, 1, 1842, 1, 1, 5 }, --古墓情缘印鉴（5天）
    },
  },
  {
    nLevel = 10,
    nBagBindMoney = 100000, --绑银数量
    tbItem = {
      --类型（1,物品,2称号，3绑银，4绑金），g,d,p,l,nCount,LimitTime天
      { 3, 100000 },
    },
  },
  {
    nLevel = 20,
    nBagFree = 20, --背包空间
    tbItem = {
      --类型（1,物品,2称号，3绑银，4绑金），g,d,p,l,nCount,LimitTime天
      { 4, 3000 },
      { 1, 18, 1, 71, 1, 20, 0 }, --白驹丸
    },
  },
  {
    nLevel = 30,
    nBagBindMoney = 900000, --绑银数量
    tbItem = {
      --类型（1,物品,2称号，3绑银，4绑金），g,d,p,l,nCount,LimitTime天
      { 3, 900000 },
    },
  },
  {
    nLevel = 60,
    nBagFree = 1, --背包空间
    tbItem = {
      --类型（1,物品,2称号，3绑银，4绑金），g,d,p,l,nCount,LimitTime天
      { 1, 1, 12, 69, 4, 1, 7 }, --坐骑魍魉（7天）
    },
  },
}

function tbItem:OnUse()
  local nUseFlag = it.GetGenInfo(1)
  if nUseFlag == 0 and me.GetTask(self.Tsk_GroupId, self.Tsk_UseId) ~= 0 then
    Dialog:Say("你已经使用过新·剑侠世界豪华礼包了，每个玩家只允许使用一个！")
    return 0
  end
  if nUseFlag == 0 then
    local szMsg = "每个玩家只允许使用一个该礼包，你现在可以激活使用该礼包，激活后，该礼包将会绑定并且可以使用。\n\n你是否确定现在要进行激活？"
    local tbOpt = {
      { "我确定激活使用", self.OnActionItem, self, it.dwId },
      { "我再考虑考虑" },
    }
    Dialog:Say(szMsg, tbOpt)
    return 0
  end
  self:OnGetAward(it.dwId)
  return 0
end

function tbItem:OnActionItem(nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local nUseFlag = pItem.GetGenInfo(1)
  if nUseFlag == 1 then
    return 0
  end
  if me.GetTask(self.Tsk_GroupId, self.Tsk_UseId) ~= 0 then
    return 0
  end
  pItem.Bind(1)
  me.SetTask(self.Tsk_GroupId, self.Tsk_UseId, 1)
  pItem.SetGenInfo(1, 1)
  local szMsg = "恭喜你成功激活了使用礼包资格，现在可以领取豪华礼包的奖励。"
  local tbOpt = {
    { "查询和领取礼包奖励", self.OnGetAward, self, nItemId },
    { "我再考虑考虑" },
  }
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:OnGetAward(nItemId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local szMsg = [[<color=pink>【新·剑侠世界】豪华礼包福利：<color>
【1级】 “古墓情缘”称号（60天）
        月光宝盒（7天）
        古墓面具箱（7天）
        3折7玄优惠券*4（30天）
        3折9玄优惠券*1（30天）
        5级玄晶*4、
        侠客印鉴（5天）
【10级】绑定银两10万
【20级】绑定金币3000
        白驹丸20个
【30级】绑定银两90万
【60级】坐骑魍魉（7天）
	
	请选择你想要领取的奖励。
	]]
  local tbOpt = {}
  local nItemFlag = pItem.GetGenInfo(2)
  for nId, tbItemInfo in ipairs(self.Gift_List) do
    local szColor = "yellow"
    local nUseFlag = KLib.GetBit(nItemFlag, nId)

    if me.nLevel < tbItemInfo.nLevel then
      szColor = "white"
    end
    if nUseFlag == 1 then
      szColor = "gray"
    end
    local szTitle = string.format("<color=%s>领取%s级礼包奖励<color>", szColor, tbItemInfo.nLevel)
    table.insert(tbOpt, { szTitle, self.OnGetAwardSure, self, nItemId, nId })
  end
  table.insert(tbOpt, { "结束对话" })
  Dialog:Say(szMsg, tbOpt)
end

function tbItem:OnGetAwardSure(nItemId, nId)
  local pItem = KItem.GetObjById(nItemId)
  if not pItem then
    return 0
  end
  local nUseFlag = pItem.GetGenInfo(1)
  if nUseFlag == 0 then
    return 0
  end
  if me.GetTask(self.Tsk_GroupId, self.Tsk_UseId) == 0 then
    return 0
  end
  local tbItemInfo = self.Gift_List[nId]
  if me.nLevel < tbItemInfo.nLevel then
    Dialog:Say("你的等级不足够领取该奖励，先勤奋练练级，等级达到后再来领取吧。")
    return 0
  end
  local nItemFlag = pItem.GetGenInfo(2)
  local nUseFlag = KLib.GetBit(nItemFlag, nId)
  if nUseFlag == 1 then
    Dialog:Say("该奖励已经领取过了。")
    return 0
  end
  if tbItemInfo.nBagFree and me.CountFreeBagCell() < tbItemInfo.nBagFree then
    local szAnnouce = "您的背包空间不足，请留出" .. tbItemInfo.nBagFree .. "格空间再试。"
    Dialog:Say(szAnnouce)
    return 0
  end

  if tbItemInfo.nBagBindMoney and me.GetBindMoney() + tbItemInfo.nBagBindMoney > me.GetMaxCarryMoney() then
    Dialog:Say("领取后您身上的绑定银两将会超出上限，请整理后再来。")
    return 0
  end

  local nUseFlag = KLib.SetBit(nItemFlag, nId, 1)
  pItem.SetGenInfo(2, nUseFlag)
  for _, tbAward in ipairs(tbItemInfo.tbItem) do
    --1,物品,2称号，3绑银，4绑金
    if tbAward[1] == 1 then
      for i = 1, tbAward[6] do
        local tbItemInfo = {}
        tbItemInfo.bForceBind = 1

        local pAwardItem = me.AddItemEx(tbAward[2], tbAward[3], tbAward[4], tbAward[5], tbItemInfo, Player.emKITEMLOG_TYPE_JOINEVENT)
        if pAwardItem then
          if tbAward[7] > 0 then
            me.SetItemTimeout(pAwardItem, tbAward[7] * 1440, 0)
          end
        end
      end
    end
    if tbAward[1] == 2 then
      me.AddSpeTitle(tbAward[2], GetTime() + tbAward[3] * 86400, tbAward[4])
    end
    if tbAward[1] == 3 then
      me.AddBindMoney(tbAward[2], Player.emKBINDMONEY_ADD_EVENT)
    end
    if tbAward[1] == 4 then
      me.AddBindCoin(tbAward[2], Player.emKBINDCOIN_ADD_EVENT)
    end
  end
  Dialog:Say("恭喜你成功领取了奖励。")
  local nDelItem = 1
  for nInfoId in ipairs(self.Gift_List) do
    local nFlag = KLib.GetBit(pItem.GetGenInfo(2), nInfoId)
    if nFlag == 0 then
      nDelItem = 0
      break
    end
  end

  if nDelItem == 1 then
    me.DelItem(pItem)
  end
end

function tbItem:GetTip()
  local szTip = "\n<color=green>你还可以激活并使用1个该礼包<color>"
  if me.GetTask(self.Tsk_GroupId, self.Tsk_UseId) == 1 then
    szTip = "\n<color=red>你已激活过该礼包，每个玩家只允许激活并使用1个该礼包<color>"
  end
  return szTip
end
