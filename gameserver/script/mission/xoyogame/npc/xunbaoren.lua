local tbNpc = Npc:GetClass("xunbaoren")

local tbShop = {
  { 132 }, -- 兑换物品
}

function tbNpc:OnDialog()
  Dialog:Say("  听说这逍遥谷中有几件稀世珍宝，我本想入谷去探寻一番，可找不到伙伴，这赵老头死活不让我进去。看你好像身手不凡，要是能入谷帮我找到那些宝贝，我这几件随身家当随便你挑！如何？\n    哦，对了！听说只有谷中的一位大师才知晓这几件宝贝的制作方法，我也不知道他叫啥……你们还是进去以后慢慢找吧……", {
    { "看看这是不是你要的宝物", Dialog.Gift, Dialog, "XoyoGame.tbGift" },
    { "看看你这有啥好东西", self.OpenShop, self },
    { "领取今日免费药品", SpecialEvent.tbMedicine_2012.GetMedicine, SpecialEvent.tbMedicine_2012 },
    { "查看逍遥谷通关纪录", XoyoGame.WatchRecord, XoyoGame },
    { "查看地狱关卡家族积分", XoyoGame.WatchKinRecord, XoyoGame },
    --{"测试查看", XoyoGame.TestWatch, XoyoGame};
    { "结束对话" },
  })
end

function tbNpc:OpenShop()
  me.OpenShop(132)
end
