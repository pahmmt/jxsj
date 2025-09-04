-- 文件名  : treasuremap2_lingpai.lua
-- 创建者  : zounan
-- 创建时间: 2010-08-26 10:34:37
-- 描述    :

function TreasureMap2:OnLingpaiDialog()
  local szMsg = [[副本令牌获取途径
1.每周可以在本官这里领取两块令牌的福利。
2.开启每日登录“赐福宝箱”有机会获得“藏宝图(1星)通用令牌”。
3.连续登录12天可以获得藏宝图副本“通用挑战令牌”。
4.藏宝图挖宝也有机会获得各种挑战令牌。
5.每天可以在本官这里领取两块碧落谷一星挑战令牌。]]
  local tbOpt = {
    --{"领取碧落谷挑战令牌", TreasureMap2.AddBiluoguLingP, TreasureMap2},
    { "领取每周令牌", TreasureMap2.AddLingpai, TreasureMap2 },
    { "我再想想" },
  }
  --Dialog:Say(szMsg, tbOpt); -- 去掉每周藏宝图令牌领取
end

function TreasureMap2:CanAddLingpai()
  local nPlayerLevel = self:GetPresentLingPaiLevel(me)
  if nPlayerLevel == 0 then
    return 0, "您的等级不足，不能领取令牌。"
  end

  if me.nFaction == 0 then
    return 0, "您还未加入门派，等加入门派后再来领取吧。"
  end

  local nCurWeek = tonumber(GetLocalDate("%Y%W"))
  if me.GetTask(self.TSK_GROUP, self.TSK_ADDLINGPAI_WEEK) == nCurWeek then
    return 0, "您这周已经领取过了。"
  end

  return 1
end

function TreasureMap2:AddLingpai()
  local nRes, szMsg = self:CanAddLingpai()
  if nRes == 0 then
    Dialog:Say(szMsg)
    return
  end

  local nPlayerLevel = self:GetPresentLingPaiLevel(me)
  local tbAwardLingpai = self.LINGPAI_PRESENT[nPlayerLevel]
  local nNeedCount = 0
  for _, tbInfo in ipairs(tbAwardLingpai) do
    nNeedCount = nNeedCount + tbInfo.nCount
  end

  local nFreeCell = me.CountFreeBagCell()
  if nFreeCell < nNeedCount then
    Dialog:Say(string.format("请把背包清理出<color=yellow> %d 格或以上的空间<color>！", nNeedCount))
    return
  end

  local nCurWeek = tonumber(GetLocalDate("%Y%W"))
  me.SetTask(self.TSK_GROUP, self.TSK_ADDLINGPAI_WEEK, nCurWeek)

  local szItemName = ""
  for _, tbInfo in ipairs(tbAwardLingpai) do
    for i = 1, tbInfo.nCount do
      local pItem = me.AddItem(unpack(tbInfo.tbItem))
      if pItem then
        pItem.Bind(1)
        szItemName = pItem.szName
        -- 7天？
        --me.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/%S", GetTime() + 3600 * 24 * 7));
        pItem.Sync()
      end
    end
    -- log
    TreasureMap2:WriteLog("令牌产出情况", string.format("%s,%s,系统,%d", me.szName, szItemName, tbInfo.nCount))
  end
end

function TreasureMap2:AddBiluoguLingP()
  local nDay = Lib:GetLocalDay(GetTime())
  local nTskDay = me.GetTask(self.TSK_GROUP, self.TSK_ADDLINGPAI_DAY)
  if nTskDay == nDay then
    me.Msg("你已经领取过今天的令牌了！")
    return
  end

  local tbAwardLingpai = self.LINGPAI_PRESENT_DAY[1]
  local nNeedCount = 0
  for _, tbInfo in ipairs(tbAwardLingpai) do
    nNeedCount = nNeedCount + tbInfo.nCount
  end

  local nFreeCell = me.CountFreeBagCell()
  if nFreeCell < nNeedCount then
    Dialog:Say(string.format("请把背包清理出<color=yellow> %d 格或以上的空间<color>！", nNeedCount))
    return
  end
  me.SetTask(self.TSK_GROUP, self.TSK_ADDLINGPAI_DAY, nDay)

  local szItemName = ""
  for _, tbInfo in ipairs(tbAwardLingpai) do
    for i = 1, tbInfo.nCount do
      local pItem = me.AddItem(unpack(tbInfo.tbItem))
      if pItem then
        pItem.Bind(1)
        szItemName = pItem.szName
        -- 7天？
        --me.SetItemTimeout(pItem, os.date("%Y/%m/%d/%H/%M/%S", GetTime() + 3600 * 24 * 7));
        pItem.Sync()
      end
    end
    -- log
    TreasureMap2:WriteLog("令牌产出情况", string.format("%s,%s,系统,%d", me.szName, szItemName, tbInfo.nCount))
  end
end
