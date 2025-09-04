if not MODULE_GAMECLIENT then
  return
end

local tbItem = Item:GetClass("youlongge_happyegg")
tbItem.TSK_GROUP = 2106
tbItem.TSK_COUNT = 4

function tbItem:GetTip()
  local nCount = me.GetTask(self.TSK_GROUP, self.TSK_COUNT)
  local szTip = string.format("今日还可使用<color=yellow>%s/7个<color>", 7 - nCount)
  szTip = string.format("%s<enter>挑战游龙阁小龙女获得的无名之蛋。据说砸开能获得绑定货币及2点江湖威望。每天可以获得<color=gold>1次<color>砸蛋机会，最多累计到<color=gold>7次<color>。<enter><color=gold>右键点击砸蛋<color>", szTip)
  return szTip
end
