-- 文件名　：kinplant_npc.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-10-12 19:50:27
-- 功能    ：

local tbNpc1 = Npc:GetClass("KinPlantTree1")

function tbNpc1:OnDialog()
  local szMsg = him.szName .. "：植物正在生长中，"
  local tbTemp = him.GetTempTable("Npc").tbKinPlant
  if not tbTemp then
    Dialog:Say("植物处于病态，请联系Gm！")
    return 0
  end
  local nIndex = tbTemp.nIndex
  local nUpTimeId = tbTemp.nTimerId_up
  szMsg = szMsg .. "距成长：" .. string.format("%s时%s分%s秒\n", Lib:TransferSecond2NormalTime(math.floor(Timer:GetRestTime(nUpTimeId) / 18)))
  local tbOpt = { { "我再想想" } }
  local nDredging = KinPlant.tbPlantNpcInfo[nIndex].nDredging
  --被其他人挖掘等级:1族长，2族长副族长，3正式成员，4荣誉成员，5记名成员(向上兼容)
  local tbKinFigure = { [4] = 5, [5] = 4 } --把记名和荣誉的颠倒位置
  local nKinFigure = tbKinFigure[me.nKinFigure] or me.nKinFigure
  if (nKinFigure > 0 and nKinFigure <= nDredging) or me.szName == tbTemp.szPlayerName then
    table.insert(tbOpt, 1, { "<color=red>铲除植物<color>", KinPlant.TreeDredging, KinPlant, him.dwId, me.nId })
  end
  Dialog:Say(szMsg, tbOpt)
end

local tbNpc2 = Npc:GetClass("KinPlantTree2")

function tbNpc2:OnDialog()
  local szMsg = him.szName .. "：果实已经成熟，距枯萎：%s\n果实基础数量：<color=yellow>%s/%s<color>\n家园种植技能增产：<color=yellow>%s<color>\n特殊天气增产：<color=yellow>%s<color>\n作物品质：<color=%s>%s<color>（增产：<color=yellow>%s<color>）\n作物品质由低到高依次为：<color=white>健康<color>，<color=green>饱满<color>，<color=blue>优秀<color>，<color=yellow>高产<color>，<color=pink>丰硕<color>"
  local tbTemp = him.GetTempTable("Npc").tbKinPlant
  if not tbTemp then
    Dialog:Say("树有问题！")
    return 0
  end
  local nUpTimeId = tbTemp.nTimerId_up
  local szTime = string.format("%s时%s分%s秒\n", Lib:TransferSecond2NormalTime(math.floor(Timer:GetRestTime(nUpTimeId) / 18)))
  local nNum = tbTemp.nNum
  if not KinPlant.tbPlantInfo[me.dwKinId] or not nNum or not KinPlant.tbPlantInfo[me.dwKinId][nNum] then
    return 0
  end
  local nIndex = tbTemp.nIndex
  local tbInfo = KinPlant.tbPlantNpcInfo[nIndex]
  local nMaxAward = tbInfo.nMaxAwardCount
  local nCount = KinPlant.tbPlantInfo[me.dwKinId][nNum][4]
  local nWeatherType = KinPlant.tbPlantInfo[me.dwKinId][nNum][5]
  local nWeatherCount = KinPlant:GetWeatherRate(nIndex, nWeatherType)
  local nKinCount = KinPlant:GetKinRate(me.dwKinId)
  local nHealth = KinPlant.tbPlantInfo[me.dwKinId][nNum][6]
  local szHealthTitle = ""
  local szHealthColor = ""
  for i, tb in ipairs(KinPlant.tbChangRate) do
    if tb[2] == nHealth then
      szHealthTitle, szHealthColor = unpack(KinPlant.tbHealthTitile[i])
      break
    end
  end
  szMsg = string.format(szMsg, szTime, nCount, nMaxAward, nKinCount, nWeatherCount, szHealthColor, szHealthTitle, nHealth)
  if KinPlant.nTimes > 1 then
    szMsg = szMsg .. string.format("\n\n<color=pink>家族种植活动翻倍开启，当前倍数：<color><color=yellow>%s倍<color>", KinPlant.nTimes)
  end
  local tbOpt = {
    { "<color=yellow>摘取丰硕之果<color>", KinPlant.GatherSeed, KinPlant, him.dwId, me.nId },
    { "造访侠客查询", self.Infor, self, tbTemp },
    --{"<color=red>铲除植物<color>", KinPlant.TreeDredging, KinPlant, him.dwId, me.nId},
    { "我再想想" },
  }
  local nDredging = KinPlant.tbPlantNpcInfo[nIndex].nDredging
  --被其他人挖掘等级:1族长，2族长副族长，3正式成员，4荣誉成员，5记名成员(向上兼容)
  local tbKinFigure = { [4] = 5, [5] = 4 } --把记名和荣誉的颠倒位置
  local nKinFigure = tbKinFigure[me.nKinFigure] or me.nKinFigure
  if (nKinFigure > 0 and nKinFigure <= nDredging) or me.szName == tbTemp.szPlayerName then
    table.insert(tbOpt, 3, { "<color=red>铲除植物<color>", KinPlant.TreeDredging, KinPlant, him.dwId, me.nId })
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc2:Infor(tbTemp)
  local szMsg = "造访该植物的侠客有：\n"
  for szName, _ in pairs(tbTemp.tbGatherSeed) do
    szMsg = szMsg .. "<color=yellow>" .. szName .. "<color>\n"
  end
  Dialog:Say(szMsg)
end

--公告板，查看订单和天气
local tbNpc3 = Npc:GetClass("KinPlantTaskBoard")

function tbNpc3:OnDialog()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_KINPLANTTASK" })
end

--吕丰年，种子商店和订单种子发放
local tbNpc4 = Npc:GetClass("lvfengnian")

function tbNpc4:OnDialog()
  local szMsg = "嘿，都说桃源好，我自耕耘，心自闲。年轻人要不要试试种点儿什么？\n  我这儿什么种子都有，你可以拿收成来换奖励。每天<color=yellow>09:00~23：00<color>花果园都有闲田，其他时候可种不了。不过……<color=green>专心钻研一类<color>作物才是正经，也莫贪多，<color=yellow>一天三株<color>刚好，可别怪老夫没提醒你。\n<color=red>（各位侠客可以在声望面板查看当前的各项种植声望）<color>"
  local tbOpt = {
    { "丰年种子商店", self.OpenShop, self },
    { "收成兑换奖励", self.ChangeFruit, self },
    { "<color=yellow>领取福禄树种<color>", KinPlant.GetSeedWeekly, KinPlant },
    { "我再想想" },
  }
  local cKin = KKin.GetKin(me.dwKinId)
  local tbOptEx = { { "我再想想" } }
  if KinPlant:MergeDialog(tbOptEx, him.nTemplateId) == 1 then
    table.insert(tbOpt, 1, { "<color=green>种植特别订单<color>", self.Task, self, tbOptEx })
  end
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc4:Task(tbOpt)
  local szMsg = "我这里还有一些作物订单，完成以后有丰厚的奖励，种子不需要你操心！你要不试试？我每周一发布，不要贪心，<color=green>一周只能接一次<color>。"
  Dialog:Say(szMsg, tbOpt)
end

function tbNpc4:OpenShop()
  me.OpenShop(226, 1)
end

function tbNpc4:ChangeFruit()
  Dialog:OpenGift("请放入本次想要兑换奖励的作物。\n<color=green>粮食类<color>作物奖励以<color=yellow>经验<color>为主\n<color=green>水果类<color>作物奖励以<color=yellow>玄晶<color>为主\n<color=green>鲜花类<color>作物奖励以<color=yellow>绑银<color>为主", nil, { self.OnOpenGiftOk, self })
end

function tbNpc4:OnOpenGiftOk(tbItemObj, nFlag)
  local vCount, vMsg = self:ChechItem(tbItemObj)
  if vCount == 0 then
    me.Msg(vMsg or "存在不符合的物品或物品数量不足!")
    return 0
  end
  if not nFlag then
    local szMsg = "您上交的果实可获得奖励：\n"
    local szExpMsg = ""
    local szMoneyMsg = ""
    local szXuanJInMsg = ""
    for i, v in ipairs(vMsg) do
      if i == 1 then
        szExpMsg = szExpMsg .. "经验奖励：<color=yellow>" .. math.floor(me.GetBaseAwardExp() * v) .. "<color>\n"
      elseif i == 3 then
        szMoneyMsg = szMoneyMsg .. "绑银奖励：<color=yellow>" .. v .. "<color>\n"
      elseif i == 2 then
        szXuanJInMsg = szXuanJInMsg .. "玄晶奖励："
        for nLevel, vCount in pairs(v) do
          if type(vCount) ~= "table" then
            szXuanJInMsg = szXuanJInMsg .. "<color=yellow>8级<color>玄晶<color=yellow>" .. vCount .. "<color>个\n          "
          else
            local b = 1
            for nLevelEx, tb in pairs(vCount) do
              if b == 1 then
                szXuanJInMsg = szXuanJInMsg .. "<color=yellow>" .. tb[2] .. "%几率<color>获得<color=yellow>" .. nLevelEx .. "级<color>玄晶1个\n"
                b = 0
              else
                szXuanJInMsg = szXuanJInMsg .. "          <color=yellow>" .. (100 - tb[1]) .. "%几率<color>获得<color=yellow>" .. nLevelEx .. "级<color>玄晶1个\n"
              end
            end
          end
        end
      end
    end
    szMsg = szMsg .. szExpMsg .. szMoneyMsg .. szXuanJInMsg
    Dialog:Say(szMsg, { { "确定领取", self.OnOpenGiftOk, self, tbItemObj, 1 }, { "我再想想" } })
    return 0
  end
  for _, pItem in pairs(tbItemObj) do
    local szItem = string.format("%s,%s,%s,%s", pItem[1].nGenre, pItem[1].nDetail, pItem[1].nParticular, pItem[1].nLevel)
    pItem[1].Delete(me)
  end
  --三个类型的奖励分别算
  KinPlant:ChangeFruit(vCount)
  for szItem, nCount in pairs(vCount) do
    if KinPlant.tbAcheveMent[szItem] and nCount >= 20 then
      Achievement:FinishAchievement(me, KinPlant.tbAcheveMent[szItem]) --454-462成就
    end
  end
end

function tbNpc4:ChechItem(tbItemObj)
  local tbItem = {}
  local tbCount = {}
  for _, pItem in pairs(tbItemObj) do
    local szItem = string.format("%s,%s,%s,%s", pItem[1].nGenre, pItem[1].nDetail, pItem[1].nParticular, pItem[1].nLevel)
    if not KinPlant.tbPlantFruit[szItem] then
      return 0, "请上交果实，存在其他物品"
    end
    tbCount[szItem] = tbCount[szItem] or 0
    tbCount[szItem] = tbCount[szItem] + pItem[1].nCount
  end
  local nNeedBag, tbAward = KinPlant:GetChangeFNeedBag(tbCount)
  if me.CountFreeBagCell() < nNeedBag then
    return 0, string.format("背包空间不足%s格，请清理下再来。", nNeedBag)
  end
  if tbAward[3] > 0 and me.GetBindMoney() + tbAward[3] > me.GetMaxCarryMoney() then
    return 0, "携带的银两达上限，请清理下再来。"
  end
  return tbCount, tbAward
end
