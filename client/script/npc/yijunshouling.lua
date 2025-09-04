local tbNpc = Npc:GetClass("yijunshouling")

tbNpc.nTaskGroupId = 1021
tbNpc.nTaskValueId = 7
tbNpc.nTmpDeadline = 80204 -- 2000年2月4日以后不会再送紫装
tbNpc.nNoviceLevelLimit = 50 -- 新手buff领取等级限制
tbNpc.nNoviceBuffId = 1972 -- 新手buffid
tbNpc.nNoviceBuffTime = 90 * 60 * 18
tbNpc.tbFaction = {
  { desc = "战士", result = "<color=gold>适合战士的门派路线<color>：棍少林、枪天王、锤天王、锤明教、战天忍、指段氏。" },
  {
    desc = "术士",
    result = "<color=gold>适合术士的门派路线<color>：掌五毒、剑明教、掌峨嵋、剑翠烟、魔天忍、气武当、剑昆仑、气段氏。",
  },
  {
    desc = "游侠",
    result = "<color=gold>适合游侠的门派路线<color>：刀少林、袖箭唐门、刀五毒、掌丐帮、棍丐帮、刀昆仑。",
  },
  { desc = "刺客", result = "<color=gold>适合刺客的门派路线<color>：陷阱唐门、刀翠烟、剑武当。" },
  { desc = "辅助师", result = "<color=gold>适合辅助师的门派路线<color>：辅助峨嵋。" },
}

tbNpc.tbOperate = {
  { desc = "操作简单", result = "<color=gold>适合操作简单的门派路线<color>：辅助峨嵋。" },
  {
    desc = "讲究一定操作",
    result = "<color=gold>适合讲究一定操作的门派路线<color>：刀少林、枪天王、锤天王、袖箭唐门、刀五毒、掌五毒、锤明教、剑明教、掌峨嵋、剑翠烟、气段氏、掌丐帮、棍丐帮、战天忍、魔天忍、气武当、剑武当、刀昆仑、剑昆仑。",
  },
  { desc = "相当讲究操作", result = "<color=gold>适合相当讲究操作的门派路线<color>：棍少林、陷阱唐门、刀翠烟、指段氏。" },
}

tbNpc.tbLonely = {
  {
    desc = "独行侠",
    result = "<color=gold>适合独行侠的门派路线<color>：枪天王、锤天王、陷阱唐门、袖箭唐门、刀五毒、掌五毒、锤明教、刀翠烟、指段氏、掌丐帮、棍丐帮、战天忍。",
  },
  {
    desc = "群战高手",
    result = "<color=gold>适合群战高手的门派路线<color>：刀少林、棍少林、剑明教、掌峨嵋、辅助峨嵋、剑翠烟、气段氏、魔天忍、气武当、剑武当、刀昆仑、剑昆仑。",
  },
}

tbNpc.tbSex = {
  { desc = "男性", result = "<color=gold>适合男性的门派路线<color>：刀少林、棍少林。" },
  { desc = "女性", result = "<color=gold>适合女性的门派路线<color>：掌峨嵋、辅助峨嵋。" },
  {
    desc = "男女皆可",
    result = "<color=gold>男女皆可的门派路线<color>：枪天王、锤天王、刀翠烟、剑翠烟、陷阱唐门、袖箭唐门、刀五毒、掌五毒、锤明教、剑明教、指段氏、气段氏、掌丐帮、棍丐帮、战天忍、魔天忍、气武当、剑武当、刀昆仑、剑昆仑。",
  },
}

function tbNpc:OnDialog()
  local nTaskValue = me.GetTask(self.nTaskGroupId, self.nTaskValueId)
  local nHasPrimerTask = me.GetTask(1025, 33) --是否有试练山庄任务
  local szDialogMsg = "你好！"
  local tbDialogOpt = {}
  table.insert(tbDialogOpt, { "销毁任务道具", Dialog.Gift, Dialog, "Task.DestroyItem.tbGiveForm" })

  if nHasPrimerTask == 1 then
    table.insert(tbDialogOpt, { "<color=yellow>送我去试练山庄<color>", Task.PrimerLv10.OpenShilianshanzhuang, Task.PrimerLv10, me.nId })
  end
  if SpecialEvent.NewServerEvent:IsEventOpen() == 1 then --新服固定家族活动
    table.insert(tbDialogOpt, { "<color=yellow>开服两周乐<color>", SpecialEvent.NewServerEvent.OnNewEvent, SpecialEvent.NewServerEvent })
  end
  if nTaskValue == 1 or nTaskValue == 2 then
    szDialogMsg = "你如今已对十二大门派有所了解，不过我有些问题还是想问问你，或许对你选择一个符合自己预想的门派有所帮助。"
    table.insert(tbDialogOpt, { "门派路线指引", self.OnSelectFaction, self })
  end
  if tonumber(GetLocalDate("%y%m%d")) <= self.nTmpDeadline then
    -- TODO: ZBL	仅作内网测试用
    local tbNpcBai = Npc:GetClass("tmpnpc")
    table.insert(tbDialogOpt, { "宋金专用体验角色方案", tbNpcBai.OnDialog, tbNpcBai })
    table.insert(tbDialogOpt, { "建立家族", Kin.DlgCreateKin, Kin })
    table.insert(tbDialogOpt, { "建立帮会", Tong.DlgCreateTong, Tong })
  end
  if me.nLevel < self.nNoviceLevelLimit then
    table.insert(tbDialogOpt, { "<color=green>获得秋姨的祝福<color>", self.GainNoviceBuff, self })
  end

  if (TimeFrame:GetServerOpenDay() >= 30 or me.GetTask(2027, 230) == 1) and GetMapType(me.nMapId) == "village" then
    table.insert(tbDialogOpt, { "<color=yellow>梦回灵秀村<color>", self.ComeBackNewVillage, self })
    table.insert(tbDialogOpt, { "<color=yellow>梦回桃溪镇<color>", self.ComeBackNewVillage, self, 1 })
  end

  table.insert(tbDialogOpt, { "结束对话" })
  Dialog:Say(szDialogMsg, tbDialogOpt)
end

function tbNpc:ComeBackNewVillage(nType, nSure)
  if not nSure then
    local szMsg = "少主人，你孤身在外闯荡多年，如果想要回去灵秀村游玩的话，秋姨这里可以让义军车夫送你回到灵秀村，不过要支付车夫2000银两，您是否想现在进过去看看？"
    local tbOpt = {
      { "我想要去看看", self.ComeBackNewVillage, self, nType, 1 },
      { "不必了" },
    }
    Dialog:Say(szMsg, tbOpt)
    return
  end
  if me.nCashMoney < 2000 then
    Dialog:Say("您身上的银两不足，请筹备好2000银两吧。")
    return
  end
  if me.CostMoney(2000, Player.emKPAY_EVENT) == 1 then
    me.SetTask(2027, 230, 1)
    if not nType then
      me.NewWorld(2115, 1610, 3270)
    else
      me.NewWorld(2254, 1814, 3476)
    end
  end
end

function tbNpc:GainNoviceBuff(nSure)
  if not nSure then
    if me.nLevel >= self.nNoviceLevelLimit then
      Dialog:Say("数日不见，少主人武功居然已有小成，会排斥外来真气，难以为你注入真气护身。不过以你当下武功，在江湖上安身立命并无困难，勤加修炼，将来必可扬名立万。")
      return
    end
    local szMsg = "少主人，你孤身在外闯荡不易，秋姨虽不能随侍左右，但可为你打入一道护身真气，危急时可助你一臂之力，如何？\n是否要获得<color=gold>护身真气<color>？"
    local tbOpt = {
      { "好的，多谢秋姨", self.GainNoviceBuff, self, 1 },
      { "不必了，我要靠自己的力量闯荡" },
    }
    Dialog:Say(szMsg, tbOpt)
    return
  end
  if me.nLevel >= self.nNoviceLevelLimit then
    Dialog:Say("少主人，你内功已有小成，会排斥外来真气，难以为你注入真气护身。")
    return
  end
  local nLevel = math.ceil(me.nLevel / 10)
  me.AddSkillState(self.nNoviceBuffId, nLevel, 1, self.nNoviceBuffTime, 1, 1)
  me.Msg(string.format("你已获得<color=yellow>%s级真气护体<color>，在线<color=yellow>1.5小时<color>后便会消散，<color=yellow>50级<color>前可随时到新手村找白秋琳领取。", nLevel))
end

function tbNpc:OnSelectFaction()
  local szMainMsg = "十二大门派的绝学各有所长，你想选择一个什么类型的门派路线？"
  Dialog:Say(szMainMsg, {
    { "A：" .. self.tbFaction[1].desc, self.OnSelectOperate, self, 1 },
    { "B：" .. self.tbFaction[2].desc, self.OnSelectOperate, self, 2 },
    { "C：" .. self.tbFaction[3].desc, self.OnSelectOperate, self, 3 },
    { "D：" .. self.tbFaction[4].desc, self.OnSelectOperate, self, 4 },
    { "E：" .. self.tbFaction[5].desc, self.OnSelectOperate, self, 5 },
  })
end

function tbNpc:OnSelectOperate(nFaction)
  self.nFaction = nFaction
  local szMainMsg = "各派武技在实战中的操作难度有别，你想选择哪种类型？"
  Dialog:Say(szMainMsg, {
    { "A：" .. self.tbOperate[1].desc, self.OnSelectLonely, self, 1 },
    { "B：" .. self.tbOperate[2].desc, self.OnSelectLonely, self, 2 },
    { "C：" .. self.tbOperate[3].desc, self.OnSelectLonely, self, 3 },
  })
end

function tbNpc:OnSelectLonely(nOperate)
  self.nOperate = nOperate
  local szMainMsg = "各派武学拥有不同的生存优势，你想当一位千里独行的侠客，还是做个能在万马千军中驰骋的高手？"
  Dialog:Say(szMainMsg, {
    { "A：" .. self.tbLonely[1].desc, self.OnSelectSex, self, 1 },
    { "B：" .. self.tbLonely[2].desc, self.OnSelectSex, self, 2 },
  })
end

function tbNpc:OnSelectSex(nLonely)
  self.nLonely = nLonely
  local szMainMsg = "十二大门派创派者有男有女，其武功路线根据阴阳体质的不同而迥然相异，你想选择适合什么性别者修炼的路线？"
  Dialog:Say(szMainMsg, {
    { "A：" .. self.tbSex[1].desc, self.OnFinalyDialog, self, 1 },
    { "B：" .. self.tbSex[2].desc, self.OnFinalyDialog, self, 2 },
    { "C：" .. self.tbSex[3].desc, self.OnFinalyDialog, self, 3 },
  })
end

function tbNpc:OnFinalyDialog(nSex)
  self.nSex = nSex
  local szMainMsg = "推荐如下。将来若有疑问，可来我处通过‘门派路线推荐’再次查询：\n\n" .. self.tbFaction[self.nFaction].result .. "\n" .. self.tbOperate[self.nOperate].result .. "\n" .. self.tbLonely[self.nLonely].result .. "\n" .. self.tbSex[self.nSex].result

  Dialog:Say(szMainMsg, {
    { "我已经了解", self.OnClose, self },
  })
end

function tbNpc:OnClose()
  me.SetTask(self.nTaskGroupId, self.nTaskValueId, 2)
end
