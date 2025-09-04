-----------------------------------------------------
--文件名		：	schooldemo.lua
--创建者		：	zhouchenfei
--创建时间		：	2011/9/27 21:45:10
--功能描述		：	门派加入界面
------------------------------------------------------

local uiFlash = Ui:GetClass("schooldemo")

uiFlash.BTN_CLOSE = "BtnClose"
uiFlash.WND_FLASH = "Flash"
uiFlash.BTN_JOINFACTION = "BtnJoin"
uiFlash.BTN_SERIES = "BtnPageSkill"
uiFlash.BTN_SERIES1 = "BtnPageSkill1"
uiFlash.BTN_SERIES2 = "BtnPageSkill2"
uiFlash.TXT_DES_FACTION = "TxtSchoolContent"
uiFlash.TXT_TITLE = "TxtSchoolName"
uiFlash.TXT_FRIENDTEXT = "Txt_Loading"
local tbTimer = Ui.tbLogic.tbTimer

uiFlash.nTimerId = 0
uiFlash.TIMER_SHOW = 2 -- 2秒刷一次？

uiFlash.tbColor = {
  [1] = "<color=225,203,91>%s（金系）<color>",
  [2] = "<color=117,230,146>%s（木系）<color>",
  [3] = "<color=117,229,230>%s（水系）<color>",
  [4] = "<color=241,72,72>%s（火系）<color>",
  [5] = "<color=184,133,24>%s（土系）<color>",
}

uiFlash.FACTION_INFO = {
  [1] = {
    szSeries = uiFlash.tbColor[1],
    szDesc = "    少林乃中华武学泰斗，以禅入武，习武修禅。佛曰慈悲，渡世人劫。少林武学实战威猛，也讲究因果循环、报应不爽，多以普攻为主、多反弹效果。\n\n" .. "<color=224,181,100>【刀少林】<color><enter>骑马战斗、全面、中庸、灵活、反弹。孰说无情，唯斩业障。\n\n" .. "<color=224,181,100>【棍少林】<color><enter>群战、强反弹、强控制、强生存能力。以身应劫，以身度人。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\daoshaolin.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\gunshaolin.swf",
    },
  },
  [2] = {
    szSeries = uiFlash.tbColor[1],
    szDesc = "    天王帮为两湖武林之领袖，前身为钟、杨义军，原本只收男弟子，且避世隐居、不问世事。现如今，在现任帮主授意下，竟广招贤良、不拘男女，投身到这乱世纷争之中……\n\n" .. "<color=224,181,100>【枪天王】<color><enter>强单体攻击、高爆发、快速、高生存能力。枪走游龙，瞬息万变。\n\n" .. "<color=224,181,100>【锤天王】<color><enter>超强生存能力、小范围快速攻击。冲锋陷阵，谁是英雄。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\qiangtianwang.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\chuitianwang.swf",
    },
  },
  [3] = {
    szSeries = uiFlash.tbColor[2],
    szDesc = "    饮誉武林的唐门，以暗器和毒药雄踞蜀中。唐门人行事诡秘，遇事不按常理出牌，却尊崇其遗训：“统率百毒，以解民厄。”，让人琢磨不透。\n\n" .. "<color=224,181,100>【袖箭唐】<color><enter>骑马战斗、灵活、高机动闪避、爆发力强。引而不发，从势而动。\n\n" .. "<color=224,181,100>【陷阱唐】<color><enter>群战、狡猾诡秘、考验意识操作。避其锋芒，引君入瓮。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\xianjingtang.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\xiujiantang.swf",
    },
  },
  [4] = {
    szSeries = uiFlash.tbColor[2],
    szDesc = "    自宋廷绝杀令后，逃入西南蛮荒毒瘴之地的五毒，又卷土重来，逐渐壮大。江湖都道，苗疆五毒，善施毒制毒，不分是非正邪，让人防不胜防。\n\n" .. "<color=224,181,100>【刀五毒】<color><enter>骑马战斗、伤害光环、高会心、造成多种负面状态。毒不自知，尚虚则亡。\n\n" .. "<color=224,181,100>【掌五毒】<color><enter>叠毒攻击、群战、自爆、让敌人进退两难。毒雾层叠，难探深浅。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\daowudu.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\zhangwudu.swf",
    },
  },
  [5] = {
    szSeries = uiFlash.tbColor[3],
    szDesc = "    峨眉武功亦柔亦刚，内外相重，长短并用。其门下女弟子更是沉鱼落雁、以柔克刚，迷倒众路英豪。峨嵋弟子行走江湖，巾帼之姿，无不受人敬仰。\n\n" .. "<color=224,181,100>【掌峨嵋】<color><enter>跟踪攻击、回复生命、辅助光环、提升内攻。冰飞雪落，却识君。\n\n" .. "<color=224,181,100>【辅助峨嵋】<color><enter>全面辅助、恢复生命、复活友方、骑马战斗。清莲开落，沁心脾。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\zhangemei.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\fuzhuemei.swf",
    },
  },
  [6] = {
    szSeries = uiFlash.tbColor[3],
    szDesc = "    翠烟门遗世独立，武功精妙，弟子原皆为绝色非常的女子，碍于门规诡奇，让江湖男子又爱又怕。自尹筱雨接管掌门后，从此翠烟门便不再只有女子。\n\n" .. "<color=224,181,100>【剑翠烟】<color><enter>远程穿透攻击、多种战斗辅助、群体隐身。衣袂翩跹，剑舞朦心。\n\n" .. "<color=224,181,100>【刀翠烟】<color><enter>隐身、出招极快、一旦近身瞬间高爆发。宛若飞花，暗藏杀机。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\jiancuiyan.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\daocuiyan.swf",
    },
  },
  [7] = {
    szSeries = uiFlash.tbColor[4],
    szDesc = "    丐帮弟子，外抵强虏，内抗朝廷，往往具备一种令人折服的英雄气概。生逢乱世，丐帮更是举旗抗金，以民族大义为重，使之终成为武林泰斗。\n\n" .. "<color=224,181,100>【掌丐帮】<color><enter>跟踪攻击、高爆发、单攻群战兼具。笑对沧桑，醉尽炎凉。\n\n" .. "<color=224,181,100>【棍丐帮】<color><enter>跟踪攻击、机动游斗、阵地防御、偷取状态。谁问英雄，宁有种乎？",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\zhanggaibang.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\gungaibang.swf",
    },
  },
  [8] = {
    szSeries = uiFlash.tbColor[4],
    szDesc = "    天忍教教中高手无数，信奉金国国教萨满教，本身并无正邪之分，但其浓重的政治背景，使得天忍教成为金国对付大宋武林门派的主要力量。\n\n" .. "<color=224,181,100>【战天忍】<color><enter>骑马战斗、诅咒、能力全面、强控制、爆发较强。神灵之火，魂归来兮。\n\n" .. "<color=224,181,100>【魔天忍】<color><enter>群战主要火力输出、多攻击技能配合输出、诅咒控制。万物屠戮，天火自降。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\zhantianren.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\motianren.swf",
    },
  },
  [9] = {
    szSeries = uiFlash.tbColor[5],
    szDesc = "    “武当”之名取自“非真武不足当之”，其武功源远流长，玄妙飘灵，不主进攻，然而亦不可轻易侵犯。武当派弟子更是以侠义名满天下，同门之间极重情义。\n\n" .. "<color=224,181,100>【剑武当】<color><enter>攻击飘逸、高眩晕、高闪避、快速连续。鹤归青岫，飞云流水。\n\n" .. "<color=224,181,100>【气武当】<color><enter>大范围攻击、内力抵消伤害、提升队友内功攻击。万山来朝，涧水长鸣。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\qiwudang.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\jianwudang.swf",
    },
  },
  [10] = {
    szSeries = uiFlash.tbColor[5],
    szDesc = "    昆仑派崇尚武勇，远处西域，很少履及中原。后昆仑派不断壮大，其渐渐成为江湖上一大门派，雄据西域，与中原各大门派分庭抗礼。\n\n" .. "<color=224,181,100>【刀昆仑】<color><enter>远程范围攻击、群战控制强、范围大。风行万里，道远周游。\n\n" .. "<color=224,181,100>【剑昆仑】<color><enter>群战、高爆发、眩晕效果强、伤害化解。昆仑磅礴，气冲天地。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\daokunlun.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\jiankunlun.swf",
    },
  },
  [11] = {
    szSeries = uiFlash.tbColor[2],
    szDesc = "    明教教义以万民疾苦为己任，拯救众生同入大光明轮回的教义，在乱世中得到了民众们的膜拜。其教众却由于行事乖张诡秘，遭到中原正派的误解。\n\n" .. "<color=224,181,100>【锤明教】<color><enter>木系中的冲锋者、高攻击、灵活、高生存能力。谁怜世人，浴火重生。\n\n" .. "<color=224,181,100>【剑明教】<color><enter>多攻击技能配合输出、群战、诅咒、闪避内功系攻击。自敛光明，行善屠恶。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\chuimingjiao.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\jianmingjiao.swf",
    },
  },
  [12] = {
    szSeries = uiFlash.tbColor[3],
    szDesc = "    段氏为皇家血脉，品格高贵，富可敌国。世代相传的武学被称为武林三大绝学之一。段氏武学大开大阖，气派宏伟，均为上乘实战武学。\n\n" .. "<color=224,181,100>【指段氏】<color><enter>飘逸、高机动、完全闪避攻击、来去自如。玄机变幻，难琢其一。\n\n" .. "<color=224,181,100>【气段氏】<color><enter>单攻与群战完美结合、造成多种负面状态、防御光环。六脉回转，气吞河山。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\zhiduanshi.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\qiduanshi.swf",
    },
  },
  [13] = {
    szSeries = uiFlash.tbColor[5],
    szDesc = "    古墓派为一代武学奇才林朝英所创。古墓弟子大多冷若寒冰，静如深潭。其武功路数却甚是刁钻，一半克制一半必杀，令武林人士甚为忌惮。\n\n" .. "<color=224,181,100>【剑古墓】<color><enter>远程回旋攻击，多控制，强爆发，高血量，重策略。剑回流转，一语成谶。\n\n" .. "<color=224,181,100>【针古墓】<color><enter>集奇诡于一身，短距离强负面攻击，令人防不胜防。素针芊芊，摄魂夺魄。",
    tbFlashFile = {
      [1] = "\\image\\ui\\002a\\common\\factionflash\\jiangumu.swf",
      [2] = "\\image\\ui\\002a\\common\\factionflash\\zhengumu.swf",
    },
  },
}

function uiFlash:OnOpen(nFaction)
  self.nRoute = 1
  self.nFaction = nFaction
  local tbFileName = self.FACTION_INFO[self.nFaction]
  local tbFlashList = tbFileName.tbFlashFile
  local szFlashName = tbFlashList[self.nRoute]

  local szFaction = Player:GetFactionRouteName(nFaction)
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, string.format(tbFileName.szSeries, szFaction))
  for i = 1, 2 do
    local szSeriesName = Player:GetFactionRouteName(nFaction, i)
    Btn_SetTxt(self.UIGROUP, self.BTN_SERIES .. i, szSeriesName)
  end

  self.szFlashName = szFlashName
  Flash_StopMovie(self.UIGROUP, self.WND_FLASH)
  self:OnPlayFlash()

  Txt_SetTxt(self.UIGROUP, self.TXT_DES_FACTION, tbFileName.szDesc)
  Btn_Check(self.UIGROUP, self.BTN_SERIES1, 1)
  Btn_Check(self.UIGROUP, self.BTN_SERIES2, 0)
  if me.nFaction > 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_JOINFACTION, 0)
    Btn_SetTxt(self.UIGROUP, self.BTN_JOINFACTION, "已入门派")
  end
  --新手任务指引
  Tutorial:CheckSepcialEvent("schooldemo")
end

function uiFlash:OnClose()
  if self.nTimerId and self.nTimerId ~= 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  Flash_ReleaseMovie(self.UIGROUP, self.WND_FLASH, self.szFlashName)
end

function uiFlash:OnPlayFlash()
  if not self.szFlashName then
    return 0
  end

  local nPer = IsDownLoadFileExist(self.szFlashName)
  if 1 ~= nPer then
    Wnd_Hide(self.UIGROUP, self.WND_FLASH)
    Wnd_Show(self.UIGROUP, self.TXT_FRIENDTEXT)
    RequestOnePackFile(self.szFlashName, 0)
    if not self.nTimerId or self.nTimerId <= 0 then
      self.nTimerId = tbTimer:Register(Env.GAME_FPS * self.TIMER_SHOW, self.OnPlayFlash, self)
    end
    return
  end
  Wnd_Show(self.UIGROUP, self.WND_FLASH)
  Wnd_Hide(self.UIGROUP, self.TXT_FRIENDTEXT)
  Flash_LoadMovie(self.UIGROUP, self.WND_FLASH, self.szFlashName)
  Flash_PlayMovie(self.UIGROUP, self.WND_FLASH)
  self.nTimerId = 0
  return 0
end

function uiFlash:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_JOINFACTION then
    me.CallServerScript({ "ApplyJoinFaction", self.nFaction })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SERIES1 then
    self.nRoute = 1
    local tbFileName = self.FACTION_INFO[self.nFaction]
    local tbFlashList = tbFileName.tbFlashFile
    local szFlashName = tbFlashList[self.nRoute]
    self.szFlashName = szFlashName
    Flash_StopMovie(self.UIGROUP, self.WND_FLASH)
    self:OnPlayFlash()
    Btn_Check(self.UIGROUP, self.BTN_SERIES1, 1)
    Btn_Check(self.UIGROUP, self.BTN_SERIES2, 0)
  elseif szWnd == self.BTN_SERIES2 then
    self.nRoute = 2
    local tbFileName = self.FACTION_INFO[self.nFaction]
    local tbFlashList = tbFileName.tbFlashFile
    local szFlashName = tbFlashList[self.nRoute]
    self.szFlashName = szFlashName
    Flash_StopMovie(self.UIGROUP, self.WND_FLASH)
    self:OnPlayFlash()
    Btn_Check(self.UIGROUP, self.BTN_SERIES1, 0)
    Btn_Check(self.UIGROUP, self.BTN_SERIES2, 1)
  end
end
