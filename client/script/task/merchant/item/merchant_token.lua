local tbItem = Item:GetClass("merchant_token")

function tbItem:InitGenInfo()
  -- 设定有效期限
  if Merchant.TASK_ITEM_FIX[it.nLevel] and Merchant.TASK_ITEM_FIX[it.nLevel].nLiveTime then
    it.SetTimeOut(1, Merchant.TASK_ITEM_FIX[it.nLevel].nLiveTime)
  end
  return {}
end

function tbItem:OnUse()
  local tbData = Merchant.TASK_ITEM_FIX[it.nLevel]
  if not tbData or tbData.hide then
    return 0
  end
  local tbFind1 = me.FindItemInBags(unpack(Merchant.MERCHANT_BOX_ITEM))
  if #tbFind1 <= 0 then
    Dialog:Say("你身上没有<color=yellow>商会令牌收集盒<color>，必须身上有收集盒才可放入令牌。")
    return 0
  end
  local nSubTaskId = tbData.nTask
  local nMaxNum = tbData.nMax
  local nCurrNum = me.GetTask(Merchant.TASK_GOURP, nSubTaskId)
  if nCurrNum >= nMaxNum then
    Dialog:Say(string.format("您收集盒中的<color=yellow>%s<color>已满", tbData.szName))
    return 0
  end
  me.SetTask(Merchant.TASK_GOURP, nSubTaskId, nCurrNum + 1)
  me.Msg(string.format("您收集了1个<color=green>%s<color>", tbData.szName))
  return 1
end
