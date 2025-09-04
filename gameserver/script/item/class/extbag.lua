-- 背包脚本
-- zhengyuhua

local tbBag = Item:GetClass("extbag")
tbBag.tbMsg = {
  ["21,7,12,1"] = "<color=orange>殿试科举状元：%s<color>",
  ["21,6,12,1"] = "<color=orange>殿试科举三甲：%s<color>",
}

function tbBag:GetTip()
  local szMsg = ""
  if it.szCustomString and it.szCustomString ~= "" and self.tbMsg[it.SzGDPL()] then
    szMsg = string.format(self.tbMsg[it.SzGDPL()], it.szCustomString)
  end
  if it.GetBagPosLimit() > 0 then
    return szMsg .. string.format("<color=gold>该背包只能放在第%d个背包栏里！", it.GetBagPosLimit())
  end
  return szMsg
end
