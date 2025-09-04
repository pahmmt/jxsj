local tbBaoShiGongJiang = Npc:GetClass("baoshigongjiang")

function tbBaoShiGongJiang:OnDialog()
  -- 剥离选项：by zhangjinpin@kingsoft
  if Item.tbStone:GetOpenDay() == 0 then
    local tbOpt = {
      { "以后再来" },
    }
    Dialog:Say("本店正在积极筹备中，暂未开放。", tbOpt)
    return
  end
  local tbOpt = {
    { "<color=yellow>装备镶嵌系统介绍<color>", self.Introduce, self },
    { "宝石商店", self.OpenStoneShop, self },
    { "打开装备镶嵌面板", me.CallClientScript, { "UiManager:OpenWindow", "UI_EQUIPHOLE", Item.HOLE_MODE_ENCHASE } },
    { "装备打孔", self.CheckPermission, self, { self.Hole, self } },
    { "原石兑换", self.CheckPermission, self, { self.ExchangeStone, self } },
    { "原石拆解", self.CheckPermission, self, { self.BreakUpStone, self } },
    { "矿石碎片换取原石", self.CheckPermission, self, { self.PreComposeStone, self } },
    { "修复龙魂装备孔等级", self.CheckPermission, self, { self.RefreshEquipHoleLevel, self, 1 } },
    { "我随便逛逛" },
  }

  local nStoneBreakUpState = Item.tbStone:GetBreakUpState(me)
  if nStoneBreakUpState == 0 then
    table.insert(tbOpt, #tbOpt, { "高级原石拆解申请", self.CheckPermission, self, { self.PreSetStoneBreakUpState, self } })
  else
    table.insert(tbOpt, #tbOpt, { "取消高级原石拆解申请", self.SetStoneBreakUpState, self, 0 })
  end

  table.insert(tbOpt, #tbOpt, { "宝石解绑", self.CheckPermission, self, { self.UnBindStone, self } })
  local nStoneUnBindState = Item.tbStone:GetUnBindState(me)
  if nStoneUnBindState == 0 then
    table.insert(tbOpt, #tbOpt, { "宝石解绑申请", self.CheckPermission, self, { self.PreUnBindStone, self } })
  else
    table.insert(tbOpt, #tbOpt, { "取消宝石解绑申请", self.SetUnBindStoneState, self, 0 })
  end

  local szMsg = "<color=yellow>镶嵌宝石<color>可以提升各个方面属性值，不过需要先进行<color=yellow>装备打孔<color>。\n我这还有一些属性一般的宝石，更高级的宝石还在运送途中。"
  Dialog:Say(szMsg, tbOpt)
end

function tbBaoShiGongJiang:CheckPermission(tbOption)
  if me.IsAccountLock() ~= 0 then
    Dialog:Say("你的账号处于锁定状态，无法进行该操作！")
    Account:OpenLockWindow(me)
    return
  end
  Lib:CallBack(tbOption)
end

function tbBaoShiGongJiang:OpenStoneShop()
  me.OpenShop(198, 1)
end
-- 装备打孔
function tbBaoShiGongJiang:Hole()
  me.OpenEquipHole(Item.HOLE_MODE_MAKEHOLE)
end

-- 宝石兑换
function tbBaoShiGongJiang:ExchangeStone()
  me.OpenStoneEnhance(Item.tbStone.emSTONE_OPERATION_EXCHANGE)
end

-- 申请原石拆解
function tbBaoShiGongJiang:PreSetStoneBreakUpState()
  local tbOpt = {
    { "申请高级原石拆解", self.SetStoneBreakUpState, self, 1 },
    { "取消" },
  }
  Dialog:Say("高级原石拆解需要<color=yellow>3小时<color>申请，之后<color=yellow>1小时<color>内可对4级及以上原石进行拆解，过时不候。", tbOpt)
end

-- 宝石拆解
function tbBaoShiGongJiang:BreakUpStone()
  me.OpenStoneEnhance(Item.tbStone.emSTONE_OPERATION_BREAKUP)
end

-- 申请高级原石拆解
function tbBaoShiGongJiang:SetStoneBreakUpState(nState)
  if nState == 1 then
    Item.tbStone:ApplyBreakUpStone(me.nId)
  else
    Item.tbStone:CancelBreakUpStone(me.nId)
  end
end

function tbBaoShiGongJiang:PreUnBindStone()
  local tbOpt = {
    { "申请宝石解绑", self.SetUnBindStoneState, self, 1 },
    { "取消" },
  }
  Dialog:Say("宝石解绑需要<color=yellow>24小时<color>申请，之后<color=yellow>24小时<color>内可对最多5个宝石进行解绑，过时不候。", tbOpt)
end

-- 宝石、原石解绑
function tbBaoShiGongJiang:UnBindStone()
  Item.tbStone:UnBindStone(me.nId)
end

-- 申请解绑宝石
function tbBaoShiGongJiang:SetUnBindStoneState(nState)
  if nState == 1 then
    Item.tbStone:ApplyUnBindStone(me.nId)
  else
    Item.tbStone:CancelUnBindStone(me.nId)
  end
end

-- 装备镶嵌系统介绍
function tbBaoShiGongJiang:Introduce()
  local szMsg = "你想知道点什么呢？"
  local tbOpt = {
    { "装备打孔", self.Information, self, 1 },
    { "宝石镶嵌", self.Information, self, 2 },
    { "宝石升级", self.Information, self, 3 },
    { "原石兑换", self.Information, self, 4 },
    { "原石分拆", self.Information, self, 5 },
    { "返回上一步", self.OnDialog, self },
    { "取消" },
  }

  Dialog:Say(szMsg, tbOpt)
end

function tbBaoShiGongJiang:Information(nType)
  local szMsg
  if nType == 1 then
    szMsg = [[             装备打孔
		
	    装备等级为8级及以上、装备品质为优秀及以上的装备可以打孔。8级装备最多可以打1个孔，9级装备最多可以打2个孔，10级装备最多可以打3个孔。
	    与宝石工匠对话，选择装备打孔选项后，放入需要打孔的装备。
	    放入装备后，点击下方的锁头可以进行打孔，优秀、精良及稀有的装备打第一个孔需要花费20w银两，第二个孔需要花费30w银两，第三个孔需要花费40w银两；装备品质卓越的装备第一个孔需要花费30w银两，第二个孔需要花费45w银两，第三个孔需要花费60w银两；装备品质史诗的装备打第一个孔需要花费40w银两，第二个孔需要花费60w银两，第三个孔需要花费80w银两。
	    10级装备的第一个孔可以升级成特殊孔，升级特殊孔需要消耗一个金刚钻，无需花费银两。
	    10级装备的第三个孔需要提升家族技能等级后在家族宝石工匠处打孔。
	    特殊孔可以镶嵌普通宝石和特殊宝石，普通孔只能镶嵌普通宝石。 ]]
  elseif nType == 2 then
    szMsg = [[             宝石镶嵌
		
	    使用Alt+鼠标左键点击需要进行镶嵌的装备可以打开该装备的镶嵌界面，或与宝石工匠对话，选择打开宝石镶嵌界面。与宝石工匠对话打开镶嵌界面需要先放入需要镶嵌的装备，然后将对应部位的宝石放入已打好的镶嵌孔中即可进行镶嵌。对已有宝石的镶嵌孔可直接进行镶嵌，镶嵌成功后会将原孔内的宝石直接放入玩家背包中。宝石剥离时，打开宝石镶嵌界面，选中需要进行剥离的宝石，点击剥离按钮，可以一次剥离多个宝石，需要对应数量的背包空间。
	    注：宝石镶嵌到装备上后会与玩家绑定，解绑需要进行申请。 ]]
  elseif nType == 3 then
    szMsg = [[             宝石升级
			
	    升级背包中的宝石时，右键点击原石，然后左键点击背包中需要升级的宝石。
	    升级装备上的宝石时，右键点击原石，然后左键点击需要升级宝石的装备，打开升级界面，再点击对应孔内的宝石。
	    稀有以下的装备最高可以镶嵌3级宝石；卓越装备最高可镶嵌4级宝石；史诗装备最高可镶嵌5级宝石。
	    注：只能用同一属性的高一级的原石进行升级。如：3级的增加冰攻抗性的原石可以升级2级的增加冰攻抗性的宝石。 ]]
  elseif nType == 4 then
    szMsg = [[             原石兑换
	
	    玩家可以通过原石兑换换取玩家所需属性的原石。
	    依次放入三块同样特征的普通原石或特殊原石，放入三块同等级的普通原石可以换取一块该等级任意属性的普通原石；放入三块同等级的特殊原石可以换取一块该等级任意属性的特殊原石。在下拉菜单中选择想要兑换的宝石的颜色，再在列表中选中希望兑换的宝石。 ]]
  elseif nType == 5 then
    szMsg = [[             原石分拆
		
	    玩家可以将高级的原石分拆成较低级的原石。3级及3级以上的原石可以进行分拆。放入宝石后，点击分拆，分拆后玩家可以得到该属性的低一个等级的三块原石。 ]]
  end

  if szMsg then
    Dialog:Say(szMsg)
  end
end

function tbBaoShiGongJiang:PreComposeStone()
  local tbOpt = {
    { "确定换取", self.ComposeStone, self },
    { "取消" },
  }
  Dialog:Say("消耗<color=yellow>30<color>个矿石碎片可以换取一个随机属性的<color=yellow>2级原石<color>。", tbOpt)
end

function tbBaoShiGongJiang:ComposeStone()
  local tbStonePatch = Item.tbStone.tbStonePatch
  local nCount = me.GetItemCountInBags(unpack(tbStonePatch))
  if nCount < Item.tbStone.nStonePatchPerStone then
    Dialog:Say("需要" .. Item.tbStone.nStonePatchPerStone .. "个矿石碎片才能换取原石。")
    return
  end
  if me.CountFreeBagCell() < 1 then
    Dialog:Say("需要<color=yellow>1格<color>背包空间，整理下再来！")
    return
  end

  local nCount = me.ConsumeItemInBags(Item.tbStone.nStonePatchPerStone, unpack(tbStonePatch))
  if nCount ~= 0 then
    Dialog:Say("不好意思，扣除碎片失败，您白损失了。")
    return
  end

  -- 产出限制 2级原石 低级产出（非技能）
  local pItem = Item.tbStone:__RandItemGetStone(1, 2, 0, 2)
  if pItem == nil then
    me.PlayerLog(Log.emKPLAYERLOG_TYPE_JOINSPORT, "矿石碎片换取随机生成原石错误")
    Dialog:Say("对不起，换取原石失败，请与客服人员联系")
    return
  end
  Item.tbStone:BrodcastMsg("矿石碎片换取", pItem)
  -- 数据埋点
  StatLog:WriteStatLog("stat_info", "baoshixiangqian", "suipianduihuan", me.nId, string.format("%d_%d_%d_%d,%d,%d_%d_%d_%d,%d", tbStonePatch[1], tbStonePatch[2], tbStonePatch[3], tbStonePatch[4], Item.tbStone.nStonePatchPerStone, pItem.nGenre, pItem.nDetail, pItem.nParticular, pItem.nLevel, 1))
end

function tbBaoShiGongJiang:RefreshEquipHoleLevel(nStep)
  nStep = nStep or 1
  if nStep == 1 then
    local szMsg = [[    修复后龙魂装备精铸后可镶嵌的宝石等级将取决于龙魂装备本身品质和精铸品质中的较大者，例如卓越品质的龙魂装备在史诗精铸后将可以镶嵌5级宝石，卓越精铸的史诗品质的龙魂装备也可镶嵌5级宝石。
			    本操作只会修复你已经装备或置于备用装备栏的龙魂装备的打孔等级。
			    请点击确定修复：]]
    local tbOpt = {
      { "确定", self.RefreshEquipHoleLevel, self, 2 },
      { "取消" },
    }
    Dialog:Say(szMsg, tbOpt)
  end

  if nStep == 2 then
    local tbPos = { Item.EQUIPPOS_BODY, Item.EQUIPPOS_AMULET, Item.EQUIPPOS_RING } -- 三优龙魂装备
    local tbRoom = { Item.ROOM_EQUIP, Item.ROOM_EQUIPEX } -- 装备栏和备用装备栏
    for _, nRoom in pairs(tbRoom) do
      for _, nPos in pairs(tbPos) do
        local pEquip = me.GetItem(nRoom, nPos, 0)
        if pEquip then
          Item:RefreshEquipHoleLevel(pEquip)
          pEquip.Sync()
        end
      end
    end

    me.Msg("修复成功！")
  end
end
