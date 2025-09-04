-- 文件名　：cardaward_c.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-05-15 11:38:40
-- 功能    ：-- 通用卡牌奖励

if not MODULE_GAMECLIENT then
  return
end

function CardAward:StartCardAward(tbAwards, szTitle, tbMsg, tbItem, tbPayItem, nPerPayCount, nState, bStartCondition, bBack)
  if UiManager:WindowVisible("UI_CARDAWARD") == 1 then
    UiManager:CloseWindow("UI_CARDAWARD")
  end
  CardAward.tbPlayerAward = CardAward.tbPlayerAward or {}
  CardAward.tbPlayerAward.tbAwards = tbAwards
  CardAward.tbPlayerAward.szTitle = szTitle
  CardAward.tbPlayerAward.tbMsg = tbMsg
  CardAward.tbPlayerAward.tbItem = tbItem
  CardAward.tbPlayerAward.tbPayItem = tbPayItem
  CardAward.tbPlayerAward.nPerPayCount = nPerPayCount
  CardAward.tbPlayerAward.nState = nState
  CardAward.tbPlayerAward.bStartCondition = bStartCondition
  CardAward.tbPlayerAward.bBack = bBack
  UiManager:OpenWindow("UI_CARDAWARD") --显示出所有奖励
end

--获得一轮奖励
function CardAward:GetRoundAward_C(nIndex)
  if self:CheckRoundAward() == 0 then
    return 0
  end
  me.CallServerScript({ "GetRoundAward", nIndex })
end

--付费打开一个奖励
function CardAward:OpenOneCard_C(nIndex)
  if self:CheckOpenCard(nIndex) == 1 then
    me.CallServerScript({ "OpenOneCard", nIndex })
  end
end

--开始一轮抽奖
function CardAward:OnStart_C(nFlag)
  if self:CheckCanStart() == 0 then
    return 0
  end
  me.CallServerScript({ "OnCardAwardStart" })
end

--通知客户端可以开始摇奖了
function CardAward:OnStart_C2()
  if UiManager:WindowVisible("UI_CARDAWARD") == 1 then
    Ui(Ui.UI_CARDAWARD):ChangeCard2()
  end
end

--结束（展示所有卡牌，并倒计时关闭）
function CardAward:OnEnd_C(tbAwards, bContinue)
  CardAward.tbPlayerAward.tbAwards = tbAwards
  if UiManager:WindowVisible("UI_CARDAWARD") == 1 then
    Ui(Ui.UI_CARDAWARD):EndCard(bContinue)
  end
end

--展示一张打开的牌
function CardAward:GoNextPay_C(tbAwards, nIndex, bPay)
  CardAward.tbPlayerAward.tbAwards[nIndex] = tbAwards

  if bPay then
    CardAward.tbPlayerAward.nPerPayCount = CardAward.tbPlayerAward.nPerPayCount - 1
  end
  if UiManager:WindowVisible("UI_CARDAWARD") == 1 then
    Ui(Ui.UI_CARDAWARD):ViewOneCard()
  end
end

function CardAward:CheckRoundAward()
  local tbPlayerAward = CardAward.tbPlayerAward
  if tbPlayerAward.nState ~= 2 then
    UiManager:OpenWindow("UI_INFOBOARD", "还不可以翻开任何一张牌")
    me.Msg("还不可以翻开任何一张牌")
    return 0
  end
  for i, tbInfor in ipairs(tbPlayerAward.tbAwards) do
    if tbInfor.bSelected then
      UiManager:OpenWindow("UI_INFOBOARD", "已经翻开一张牌了")
      me.Msg("已经翻开一张牌了")
      return 0
    end
  end
  return 1
end

function CardAward:CheckCanStart()
  local tbPlayerAward = CardAward.tbPlayerAward
  if tbPlayerAward.nState ~= 1 then
    UiManager:OpenWindow("UI_INFOBOARD", "还不可以开始")
    me.Msg("还不可以开始")
    return 0
  end
  if tbPlayerAward.bStartCondition then
    return 1
  end
  --开奖背包
  local nMaxNeedBag = 0
  local nMaxBindMoney = 0
  local nMaxMoney = 0
  for i, tbInfor in ipairs(tbPlayerAward.tbAwards) do
    if tbInfor.szType == "item" then
      local nNeedBag = KItem.GetNeedFreeBag(tbInfor.varValue[1], tbInfor.varValue[2], tbInfor.varValue[3], tbInfor.varValue[4], { bTimeOut = tbInfor.varValue[7] }, tbInfor.varValue[6])
      if nMaxNeedBag < nNeedBag then
        nMaxNeedBag = nNeedBag
      end
    end
    if tbInfor.szType == "bindmoney" then
      if nMaxBindMoney < tbInfor.varValue then
        nMaxBindMoney = tbInfor.varValue
      end
    end
    if tbInfor.szType == "money" then
      if nMaxMoney < tbInfor.varValue then
        nMaxMoney = tbInfor.varValue
      end
    end
  end
  if me.CountFreeBagCell() < nMaxNeedBag then
    UiManager:OpenWindow("UI_INFOBOARD", string.format("背包空间不足%s格", nMaxNeedBag))
    me.Msg(string.format("背包空间不足%s格。", nMaxNeedBag))
    return 0
  end
  if me.GetBindMoney() + nMaxBindMoney > me.GetMaxCarryMoney() then
    UiManager:OpenWindow("UI_INFOBOARD", "对不起，您身上的绑定银两将达上限。")
    me.Msg("对不起，您身上的绑定银两将达上限。")
    return 0
  end
  if me.nCashMoney + nMaxMoney > me.GetMaxCarryMoney() then
    UiManager:OpenWindow("UI_INFOBOARD", "对不起，您身上的银两将达上限")
    me.Msg("对不起，您身上的银两将达上限。")
    return 0
  end
  return 1
end

function CardAward:CheckOpenCard(nIndex)
  local tbPlayerAward = CardAward.tbPlayerAward
  if tbPlayerAward.nState ~= 2 then
    UiManager:OpenWindow("UI_INFOBOARD", "还不可以打开任何一张牌")
    me.Msg("还不可以打开任何一张牌")
    return 0
  end
  if not tbPlayerAward.tbPayItem or tbPlayerAward.nPerPayCount <= 0 then
    return 0
  end
  if not tbPlayerAward.tbAwards[nIndex] then
    return 0
  end
  if tbPlayerAward.tbAwards[nIndex].bSelected then
    UiManager:OpenWindow("UI_INFOBOARD", "该张卡牌已经被选过了，请重新选一张")
    me.Msg("该张卡牌已经被选过了，请重新选一张。")
    return 0
  end
  return 1
end

--计算卡牌选定的数目
function CardAward:CaleCountSelect()
  local tbPlayerAward = CardAward.tbPlayerAward
  local nCount = 0
  for i, tbInfor in ipairs(tbPlayerAward.tbAwards) do
    if tbInfor.bSelected then
      nCount = nCount + 1
    end
  end
  return nCount
end
