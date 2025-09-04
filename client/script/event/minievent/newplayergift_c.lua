local tbGift = Item:GetClass("newplayergift")

function tbGift:GetTip()
  return string.format("你到达<color=orange>%d级<color>后就可以领取礼物。", it.GetGenInfo(1))
end
