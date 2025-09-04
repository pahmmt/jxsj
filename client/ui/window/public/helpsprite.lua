-- 文件名　：helpsprite.lua
-- 创建者　：张帆
-- 创建时间：2008-03-12 21:09:45

local uiHelpSprite = Ui:GetClass("helpsprite")

uiHelpSprite.TXX_TEXT = "TxtExHelpText"
uiHelpSprite.TXX_LIST = "TxtExHelpList"
uiHelpSprite.BTN_CLOSE = "BtnClose"
uiHelpSprite.PAGE_BUTTON_KEY_STR = "BtnHelpPage"
uiHelpSprite.PAGE_BUTTON_MAX_NUMBER = 6
uiHelpSprite.EDIT_SEARCH = "EditSearch"
uiHelpSprite.BTN_XOYOASK = "BtnXoyoAsk"
uiHelpSprite.BTN_SEARCH = "BtnSearch"
uiHelpSprite.TXT_SYSTIME = "TextSysTime"
uiHelpSprite.TXT_SYSTIMETAG = "TextTimeTag"
uiHelpSprite.TXT_SYSSTARTTIMETAG = "TextStartTimeTag"
uiHelpSprite.tbNewsLinkId2WholeStr = {}
uiHelpSprite.tbTuiJianLinkId2WholeStr = {}

uiHelpSprite.MAX_STAR_NUM = 10
uiHelpSprite.nCurPageIndex = 1
uiHelpSprite.tbFirstPageFold = {}
uiHelpSprite.tbSearchPageFold = {}

uiHelpSprite.MAX_FB_Enter_NUM = 6 --每周副本进入次数

uiHelpSprite.DNEWSID = {
  NEWS_LEVELUP = 1,
  NEWS_MENPAIJINGJI_NEW = 2,
  NEWS_MENPAIJINGJI_DASHIXING = 3,
}

uiHelpSprite.IMAGE_INCREASE = "<pic=\\image\\ui\\001a\\playerpanel\\increase_button.spr,0>"
uiHelpSprite.IMAGE_DECREASE = "<pic=\\image\\ui\\001a\\playerpanel\\decrease_button.spr,0>"

uiHelpSprite.IMAGE_STAR_EXP = {
  szLightStar = "<pic=\\image\\ui\\001a\\item\\itemtips\\yellow_fill_flash.spr>",
  szDarkStar = "<pic=\\image\\ui\\001a\\item\\itemtips\\yellow_empty_flash.spr>",
  szBlank = "  ",
}
uiHelpSprite.IMAGE_STAR_MONEY = {
  szLightStar = "<pic=\\image\\ui\\001a\\item\\itemtips\\yellow_fill_flash.spr>",
  szDarkStar = "<pic=\\image\\ui\\001a\\item\\itemtips\\yellow_empty_flash.spr>",
  szBlank = "  ",
}

uiHelpSprite.IMAGE_STAR_SORT = {
  szLightStar = "<pic=\\image\\ui\\001a\\item\\itemtips\\orange_fill.spr>",
  szDarkStar = "<pic=\\image\\ui\\001a\\item\\itemtips\\orange_empty.spr>",
  szBlank = "  ",
}

-- 打开帮助精灵的默认文本
uiHelpSprite.STR_DEFAULT_TEXT = "\t<bclr=blue>帮助锦囊，告诉你想知道的一切！<bclr>"

--== 最新消息 ==--
uiHelpSprite.tbNewsInfo = {
  [1010] = {
    szName = "恭喜你达到10级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到<color=yellow>10<color>级，可以使用新功能：<color=yellow><enter><tab=10>加入门派<enter><tab=10>加入家族<enter><tab=10>使用邮箱<color>",
    szMsg = "你能够<bclr=green>加入门派<bclr>了",
  },
  [1012] = {
    szName = "恭喜你达到12级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到<color=yellow>12<color>级，可以使用新功能：使用生活技能<color>",
    szMsg = "你有了新的功能可以使用了",
  },
  [1020] = {
    szName = "恭喜你达到20级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到<color=yellow>20<color>级，可以使用新功能：<color=yellow><enter><tab=10>拜师<enter><tab=10>离线托管<enter><tab=10>义军任务<enter><tab=10>使用修炼珠<enter><tab=10>探索初级藏宝图<color>",
    szMsg = "你可以<color=yellow>拜师<color>了",
  },
  [1025] = {
    szName = "恭喜你达到25级！",
    nLifeTime = 300,
    varWeight = 1,
    varContent = "你现在的等级已经达到<color=yellow>25<color>级，可以使用新功能：<color=yellow><enter><tab=10>摆摊<color>",
    szMsg = "你现在能够<bclr=green>摆摊<bclr>了",
  },
  [1030] = {
    szName = "恭喜你达到30级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到<color=yellow>30<color>级，可以使用新功能：<color=yellow><enter><tab=10>骑马<color>",
    szMsg = "你可以<bclr=green>骑马<bclr>了",
  },
  [1050] = {
    szName = "恭喜你达到50级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到<color=yellow>50<color>级，可以使用新功能：<color=yellow><enter><tab=10>探索中级藏宝图<enter><tab=10>探索藏宝图副本<enter><tab=10>建立家族<enter><tab=10>挑战初级白虎堂<enter><tab=10>参加逍遥谷活动<enter><tab=10>参加门派竞技<color>",
    szMsg = "已到达50级，可以使用新功能！",
  },
  [1060] = {
    szName = "恭喜你达到60级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到<color=yellow>60<color>级，可以使用新功能：<enter><tab=10>参加初级宋金战场<color>",
    szMsg = "已到达60级，可以使用新功能！",
  },
  [1069] = {
    szName = "恭喜你达到69级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到<color=yellow>69<color>级，可以使用新功能：<color=yellow><enter><tab=10>收徒弟<color>",
    szMsg = "你现在可以收徒弟了！",
  },
  [1070] = {
    szName = "恭喜你达到70级！",
    nLifeTime = 300,
    varWeight = 1,
    varContent = "你现在的等级已经达到<color=yellow>70<color>级，可以使用新功能：<color=yellow><enter><tab=10>建立帮会<color>",
    szMsg = "已到达70级，可以使用新功能！",
  },
  [1090] = {
    szName = "恭喜你达到90级！",
    nLifeTime = 300,
    varWeight = 1,
    varContent = "你现在的等级已经达到<color=yellow>90<color>级，可以使用新功能：<color=yellow><enter><tab=10>挑战高级白虎堂<enter><tab=10>参加中级宋金战场<color>",
    szMsg = "已到达90级，可以使用新功能！",
  },
  [1100] = {
    szName = "恭喜你达到100级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到<color=yellow>100<color>级，可以使用新功能：<color=yellow><enter><tab=10>参加武林联赛<enter><tab=10>缉拿蚀月教徒<color>",
    szMsg = "已到达100级，可以使用新功能！",
  },
  [1120] = {
    szName = "恭喜你达到120级！",
    nLifeTime = 300,
    varWeight = 10,
    varContent = "你现在的等级已经达到120级，可以使用新功能：<color=yellow><enter><tab=10>参加高级宋金战场<color>",
    szMsg = "已到达120级，可以使用新功能！",
  },
  [2001] = {
    szName = "★全新荣誉尽显侠客风采★",
    nLifeTime = -1, -- -1表示永久显示
    --领土战开放后不显示披风的消息
    varWeight = function()
      if GblTask:GetUiFunSwitch("UI_HELPSPRITE_DOMAIN") == 0 then
        return 0
      end
      return 10
    end,
    varContent = [[
　　荣誉排行榜全面更新！从即日起，只要您投身武林之中，就有机会荣登<color=yellow>领袖、武林、财富<color>三大荣誉排行榜，在荣誉排行榜上记录下您的名字。达到一定排行榜等级的玩家，不仅会获得令人羡慕的荣耀头衔和称号，更可以购买剑侠世界中的最重要装备——披风。
　　披风展示：
	  <table=0>
	  <tr=0,0,2,0,Orange><td=0,0,5,1>需要荣誉等级</td><td=0,0,5,1>披风名</td><td=0,0,5,1></td></tr>
	  <tr=0,0,1,1,hide><td>10</td><td>无双王者披风</td><td><item=1,17,1,10></td></tr>
	  <tr=0,0,1,1,gray><td>9</td><td>至尊传说披风</td><td><item=1,17,1,9></td></tr>
	  <tr=0,0,1,1,hide><td>8</td><td>潜龙吟渊披风</td><td><item=1,17,1,8></td></tr>
	  <tr=0,0,1,1,gray><td>7</td><td>雏凤翎羽披风</td><td><item=1,17,1,7></td></tr>
	  <tr=0,0,1,1,hide><td>6</td><td>混天镇元披风</td><td><item=1,17,1,6></td></tr>
	  <tr=0,0,1,1,gray><td>5</td><td>御空冯虚披风</td><td><item=1,17,1,5></td></tr>
	  <tr=0,0,1,1,hide><td>4</td><td>惊世独舞披风</td><td><item=1,17,1,4></td></tr>
	  <tr=0,0,1,1,gray><td>3</td><td>凌绝雾影披风</td><td><item=1,17,1,3></td></tr>
	  <tr=0,0,1,1,hide><td>2</td><td>出尘惊虹披风</td><td><item=1,17,1,2></td></tr>
	  <tr=0,0,1,1,gray><td>1</td><td>超凡希冀披风</td><td><item=1,17,1,1></td></tr>
	  </table>
    <color=red>特别注意<color>：荣誉等级是有最低荣誉值要求的哦，如果您虽然排名达到了要求，但是荣誉点数较少，那么您只能获得您拥有荣誉点数所能满足的最高等级所对应的头衔。
　　<color=yellow>详细内容，请留意“详细帮助”中的“荣誉系统”栏目！！千万别错过哦！！<color>]],
  },
  [3000] = {
    szName = "庆20周年—庆典包来贺喜",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200812090800 and nCurTime < 200812160000 then
        return 10
      end
      return 0
    end,
    varContent = [[
活动时间: <color=yellow>2008年12月9日更新后 — 2008年12月16日0点<color>

活动内容:
    大家同欢乐，天天都惊喜。1988年，金山成立了。一晃眼，20年过去了。金山这20年离不开大家的支持，为了进一步答谢玩家，我们决定继续出售<color=yellow>20周年庆典包<color>一周。在活动期间，大家可以在奇珍阁金币区花500金币购买“20周年庆典包”，打开庆典包能获得<color=yellow>500绑金<color>，以及一个<color=yellow>随机道具<color>奖励。
    
活动奖励:
    <color=yellow>绑金<color>，随机道具（可能是<color=yellow>玄晶<color>（绑定），<color=yellow>秘境地图<color>（绑定），<color=yellow>逍遥谷材料及神秘道具<color>中的一种哦）
]],
  },
  [3001] = {
    szName = "真情回馈玩家大礼包",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200812020000 and nCurTime < 200812160000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　为答谢广大玩家对我们的支持，应广大玩家的热烈要求，我们将延长“内测玩家真情回馈”活动并向所有玩家开放，同样的，只要您满足如下条件之一：<color=green>
　　条件一：等级达到69级，江湖威望达到100，本月累计充值达到48元。
　　条件二：等级达到69级，本月累计充值达到500元。<color>

　　就可以在各<color=yellow>新手村活动推广员<color>处领取这个价值不菲的黄金大礼包。礼包内容包括：<color=yellow>
　　  无限回城符（1周）（绑定）
　　  乾坤符1张（1月）（绑定）
　　  大白驹丸20个（1月）（绑定）
　　  传声海螺（10句）1个（1月）（绑定）
　　  金犀（2级）1个（1月）（绑定）
　　  4级玄晶20个（1月）（绑定），2000绑定金币
　　  5级玄晶20个（1月）（绑定），100000绑定银两
　　  6级玄晶10个（1月）（绑定），200000绑定银两
　　  7级玄晶10个（1月）（绑定），300000绑定银两， 5000绑定金币
　　 
	<color>
　　领取截至时间：
　　  <color=red>2009年5月31日24时<color>
  
　　注意：内测玩家真情回馈和新手卡奖励只能择一领取
　　  <color=red>必须当月充值当月领取奖励<color>
  
　　特别注意：
　　  <color=red>1、当月充值请当月领取，如果过了下个月1日0点，您必须重新充值到相应数额才能领取奖励
　　  2、已经领取过“内测玩家真情回馈”或新手卡的玩家，将不能再次领取“真情回馈玩家礼包”。<color>

　　温馨提示：必须是当月成功充值“15元充值卡”、“30元充值卡”、“48元充值卡”、“50元充值卡”、“100元充值卡”、“500元充值卡”中任意一种实卡或虚卡、银行卡，累计达到48元或者500元才有效。  
	]],
  },
  [3002] = {
    szName = "门派双修引领武技升华",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200812110800 and nCurTime < 200901160000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=red>背景<color>
    如今义军备战正在如火如荼的展开，朝野内局势动荡，宋金决战已经是箭在弦上。时逢江湖乱世，江湖之上骤然刮起了一股切磋研习武技之风气。江湖后生们人才辈出，许多后生潜心研习他路武技与心法，他们不仅仅勇于付出比常人更多的努力，更凭借着超群的悟性在极短的时间内掌握了个中武技之精华，就连武林中泰斗宗师级的人物都对此啧啧称奇。鉴于此种情况，江湖之上的武林宗师泰斗聚集一堂经商定从即日起各路门派将开放其武技心得，允许弟子进行武艺双修，即一人可以修习两个门派的武功。
    此举意在让更多武林高手得到学习和展示自我的机会，亦为笼络更多江湖奇才为朝廷效力更为永葆我朝江山！
    江湖之上各路武功路数千变万化，刀枪棍剑各领风骚。要习得其中精华还需勤于修炼方可在不同路数的武技之中顿悟和升华，江湖后生们纷纷跃跃欲试，你是否准备好了？
    
    <color=green>多修的条件<color>
    角色等级达到100级。
    已加入了门派。
    
    满足如上条件后即可从<color=yellow>当前门派的掌门<color>处进入<color=yellow>洗髓岛<color>进行门派双修。

    详细内容，请留意“最新活动”和“详细帮助”中的相关内容！！千万别错过哦！！

  ]],
  },
  [3003] = {
    szName = "十二门派中级秘籍惊现武林",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200812310800 and nCurTime < 200901310000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    新年的钟声已响起，古老悠远而宁静。闯荡江湖已久的你是否已经将本门派的秘籍心法研究透彻了？你是否也期待着新的挑战和变化？正如你所愿，剑侠世界门派中级秘籍与大家见面了^-^!!
    
    <color=green>中级秘籍的获得途径<color>
    一、任务形式获得
    当玩家达到<color=yellow>七十级<color>便可在义军首领<color=yellow>白秋琳<color>处领取关于中级秘籍的任务“百尺经”，任务完成后将得到中级秘籍，按玩家的<color=yellow>当前门派<color>发放。
    二、魂石商店购买
    中级秘籍修炼满级后，附带技能并不会满级，要想修炼满技能，可以在<color=yellow>钱庄老板处的魂石商店<color>购买相同的秘籍继续修炼，技能会保持之前的修炼度并继续增加而升级。
    
    <color=green>中级秘籍的潜能和技能<color>
    各个门派路线的秘籍附带不同的新技能，同时潜能属性也与初级秘籍相比有了全方位的提高。
    
    有志者事竟成，破釜沉舟 百二秦关终属楚，苦心人天不负卧薪尝胆三千越甲可吞吴。剑侠世界中级秘籍，你准备好了吗？七十级以上的玩家，快快行动起来吧！
这里有兄弟，与你出生入死、书写义气人生；这里有侠侣，与你同舟共济、演绎爱恨人生；这里很痛快，喝酒烤火屠奸贼，快意恩仇；这里很简单，一念间爱恨情仇灰飞烟灭 …… 剑侠世界，再战江湖，感动你自己！


  ]],
  },

  [3004] = {
    szName = "【永乐镇】开放领土争夺战！",
    nLifeTime = -1,
    varWeight = function()
      if GblTask:GetUiFunSwitch("UI_HELPSPRITE_DOMAIN") == 0 then
        return 0
      end
      return 10
    end,
    varContent = [[
    <color=green>【永乐镇】服务器率先开放领土争夺战<color>
    
    <color=green>活动时间：<color>每周五、周日，晚上20：00 ~ 21：30
    
    详细玩法介绍，请查看<color=yellow>帮助锦囊（F12）<color=yellow>中的<color=yellow>详细帮助<color>栏目
  ]],
  },

  [3006] = {
    szName = "【帮会股份制】全新推出",
    nLifeTime = 0,
    varWeight = function()
      return 10
    end,
    varContent = [[
    梦回宋末，贪官误国，盗匪横行，蛮夷入侵
    
    看生在现代的你，如何在武侠的世界掀起狂潮，在这个风起云涌,英雄辈出的乱世江湖中拥有自己的霸业。
    
    全新概念的帮会股份玩法火热推出！
    
    详细玩法介绍，请查看<color=yellow>帮助锦囊（F12）<color=yellow>中的<color=yellow>详细帮助<color>栏目及<color=yellow>最新活动<color>栏目
  ]],
  },

  [3007] = {
    szName = "★领土争夺战即将在本服开放",
    nLifeTime = -1,
    varWeight = function()
      local nDetDay, _, nShowFlag = Ui.tbLogic.tbHelp:GetDetDomainOpenDay()
      if nDetDay >= 0 then
        return 0
      end
      return 10
    end,
    varContent = function()
      local nDetDay, nWday, nShowFlag = Ui.tbLogic.tbHelp:GetDetDomainOpenDay()
      local szWeekDay = ""
      local szContext = ""
      local nOpenDay = EventManager.IVER_nDomainBattleDay + 1
      if nOpenDay > 7 then
        nOpenDay = 1
      end
      if nDetDay >= 0 then
        return szContext
      end
      if nWday == 1 then
        szWeekDay = "日"
      elseif nWday == nOpenDay then
        szWeekDay = EventManager.IVER_szDomainBattleDay
      end
      szContext = [[
    领土争夺战将在 <color=yellow>]] .. math.abs(nDetDay) .. [[ 天后的 周]] .. szWeekDay .. [[<color>在本服务器开放
    
    宋庆元二年，理学宗师朱熹被控犯有“不忠、不孝、不仁、不义、不恭、不谦”六大罪受贬出朝。次年，宰相赵汝愚被控心怀逆谋之心而流放永州，于途中暴卒。自此朝中大权旁落，外戚韩侂胄开始专权。
    
    朱熹为当朝理学之集大成者，门生遍布天下，又曾亲为皇帝侍讲，身份之尊不可比拟。赵汝愚位居宰辅，兢兢业业，且废除李后清其党羽，拥皇有功，是当朝第一大功臣，甚得民心。
    
    如今两人相继出朝，一隐一亡，此消息传出之后，朝野惊悸，民怨沸腾。朱子门生和赵氏宗亲百般调查得知这两件事均出自于韩侂胄的手笔，立誓报此深仇。他们联合各地的“反韩”势力，意欲一拼，并以大溪岛民起义为讯号，试探朝廷心意。
    
    宁宗赵扩感念赵汝愚拥立之功，为防韩侂胄一人擅专，以太皇太后吴氏之名降下圣旨：“朱韩两党，若能归顺则既往不咎；若一意孤行则决不姑息。”并以此为契机，广纳贤良。若有民间势力能够相助朝廷平息祸乱者，虽为布衣百姓，也可封王封侯。
    
    逢乱世，烽火连天战火正酣，群雄虎啸龙吟。正是：天下风云出我辈，一入江湖岁月催，宏图霸业笑谈中，不胜人生一场醉。你们有信心平定乱世称霸天下吗？你们有能力脱颖而出唯我独尊吗？
    
    <color=yellow>至强帮会，浴血鏖战。大型帮战活动“领土争夺战”即将隆重登场！<color>
    
    详细玩法介绍，请查看<color=yellow>帮助锦囊（F12）<color=yellow>中的<color=yellow>详细帮助<color>栏目及<color=yellow>最新活动<color>栏目
    
    ]]
      return szContext
    end,
  },

  [3008] = {
    szName = "★领土争夺战掀开第一章！",
    nLifeTime = -1,
    varWeight = function()
      local nDetDay, _, nShowFlag = Ui.tbLogic.tbHelp:GetDetDomainOpenDay()
      if nShowFlag <= 0 then
        return 0
      end
      return 10
    end,
    varContent = [[
    <color=yellow>《领土争夺战·第一章》<color>   
    
    <color=yellow>
    逢乱世，烽火连天战火正酣，群雄虎啸龙吟。正是：天下风云出我辈，一入江湖岁月催，宏图霸业笑谈中，不胜人生一场醉。你们有信心平定乱世称霸天下吗？你们有能力脱颖而出唯我独尊吗？
    
    领土争夺战·第一章
    
    开放了 18 块南宋国境内领土，等待各大帮会前来争夺！
    
    龙泉村、巴陵县、江津村、稻香村，4 个新手村，会是跨入领土争夺的跳板！
    
    你准备好了吗！<color>
    
    详细玩法介绍，请查看<color=yellow>帮助锦囊（F12）<color=yellow>中的<color=yellow>详细帮助<color>栏目及<color=yellow>最新活动<color>栏目
    
    <color=green>背景<color>
    
    宋庆元二年，理学宗师朱熹被控犯有“不忠、不孝、不仁、不义、不恭、不谦”六大罪受贬出朝。次年，宰相赵汝愚被控心怀逆谋之心而流放永州，于途中暴卒。自此朝中大权旁落，外戚韩侂胄开始专权。
    
    朱熹为当朝理学之集大成者，门生遍布天下，又曾亲为皇帝侍讲，身份之尊不可比拟。赵汝愚位居宰辅，兢兢业业，且废除李后清其党羽，拥皇有功，是当朝第一大功臣，甚得民心。
    
    如今两人相继出朝，一隐一亡，此消息传出之后，朝野惊悸，民怨沸腾。朱子门生和赵氏宗亲百般调查得知这两件事均出自于韩侂胄的手笔，立誓报此深仇。他们联合各地的“反韩”势力，意欲一拼，并以大溪岛民起义为讯号，试探朝廷心意。
    
    宁宗赵扩感念赵汝愚拥立之功，为防韩侂胄一人擅专，以太皇太后吴氏之名降下圣旨：“朱韩两党，若能归顺则既往不咎；若一意孤行则决不姑息。”并以此为契机，广纳贤良。若有民间势力能够相助朝廷平息祸乱者，虽为布衣百姓，也可封王封侯。
    
    		
		]],
  },

  [3009] = {
    szName = "领土官衔隆重登场！",
    nLifeTime = -1,
    varWeight = function()
      local nDetDay, _, nShowFlag = Ui.tbLogic.tbHelp:GetDetDomainOpenDay()
      if nShowFlag <= 0 then
        return 0
      end
      return 10
    end,
    varContent = [[
    <color=yellow>领土官衔隆重登场<color>   
    
    通过参加领土争夺战，帮会中的首领和股东会成员有机会获得官衔。
    获得官衔后，不仅能够获得特殊称号和效果，更有资格购买官印。官印会带有特殊的属性效果。
    如，金系的角色达到对应的官衔等级，可以购买的官印为：
        1级官衔，可以购买 <item=1,18,1,1>
        2级官衔，可以购买 <item=1,18,1,2>
        3级官衔，可以购买 <item=1,18,1,3>
        4级官衔，可以购买 <item=1,18,1,4>
        5级官衔，可以购买 <item=1,18,1,5>
        6级官衔，可以购买 <item=1,18,1,6>
        7级官衔，可以购买 <item=1,18,1,7>
        8级官衔，可以购买 <item=1,18,1,8>

    在<color=yellow>临安府的官衔官员<color>，可以申请官衔及购买官印。
    领土官衔相关详细规则，可在详细帮助页面中了解到。
		]],
  },

  [4000] = {
    szName = "元旦圣诞活动开启",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200812220000 and nCurTime < 200901060000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：<color><color=red>2008年12月23日维护后——2009年1月6日0点<color>
    又是一年春来到，值此辞旧迎新之际，《剑侠世界》隆重推出元旦圣诞系列活动，欢迎各位玩家参加，奖励多多，祝福多多！下面就告诉大家到底有哪些活动。
    
    <color=green>活动一：礼盒传情<color>
    活动期间，你每天都可以从<color=yellow>各大城市圣诞老人<color>处获得<color=yellow>圣诞袜子<color>，打开圣诞袜子不仅能获得奖励还能得到一个神秘的道具——<color=yellow>圣诞礼盒<color>！圣诞礼盒只能在组队情况下送给<color=yellow>亲密度为2以上的好友<color>,当然你也可以打开好友送给你的圣诞礼盒。同时你也可以用5个<color=yellow>“雪花”<color>去圣诞老人处换取一个圣诞袜子，“雪花”可以从雪堆上采集的“小雪团”加工制作获得。活动中每个玩家可以打开<color=yellow>100只<color>圣诞袜子，<color=yellow>10个<color>圣诞礼盒，多余的礼盒可以转送他人哦。详情可去各大城市圣诞老人处了解。
    <color=green>活动二：邂逅圣诞老人<color>
    圣诞老人无处不在啊，他会随机出现在各种<color=yellow>活动地图<color>（如逍遥谷，白虎堂，宋金战场，门派竞技场等），如果您好运遇到他，就能获得礼物——圣诞袜子。
    <color=green>活动三：巧遇圣诞树<color>
    圣诞老人在各种活动地图（如逍遥谷，白虎堂，宋金战场，门派竞技场等）种植了<color=yellow>圣诞树<color>，你能找到吗？据说上面挂满了礼物，找到的话就可能获得神秘道具<color=yellow>“小雪团”<color>或圣诞袜子哦。
    <color=green>活动四：烟花庆元旦<color>
    为了庆祝新一年的到来，在活动期间，所有野外地图怪都会掉落道具<color=yellow>“元旦喜庆烟花”<color>，玩家得到并使用 “元旦喜庆烟花” 后可以获得丰厚奖励。每个烟花可以使用5次，但一个人只能使用一次，每天每人最多使用5个烟花。各位亲爱的玩家，喊上你们的朋友，一起使用烟花庆祝这个盛典吧。 
	]],
  },
  [4001] = {
    szName = "神秘礼盒迎圣诞！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200812220000 and nCurTime < 200901060000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：<color><color=red>2008年12月23日维护后——2009年1月6日0点<color>
    活动期间，奇珍阁金币区出售“圣诞礼盒”，送给朋友的话，他会得到神秘的礼物，还可以增加亲密度哦！
  ]],
  },
  [4002] = {
    szName = "圣诞余韵——甜蜜如糖",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200901060000 and nCurTime < 200902060000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：<color><color=red>2009年1月6日维护后——2009年2月6日0点<color>
    还记得圣诞节吃的糖果吗？那浸入心肺的蜜甜，是不是久久难以忘怀？那么，在这一个月的活动期间，您可以从奇珍阁购买到<color=yellow>“圣诞糖果”<color>，再次回味，不过糖果只能吃<color=yellow>100颗<color>，多了对身体不好的。
  ]],
  },
  [4003] = {
    szName = "圣诞充值有礼",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200812230000 and nCurTime < 200901010000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：<color><color=red>2008年12月23日维护后——2009年1月1日0点<color>
    在活动期间，玩家充值<color=yellow>每次达到50元（或50的倍数）<color>都能在各<color=yellow>新手村活动推广员<color>处获得<color=yellow>20%<color>的绑金返还，在<color=yellow>第一次<color>充值满50元时更能获得相当于<color=yellow>150元<color>的绑金返还。
    注意：充值未满50元的话不能领取返还，领取返还部分的充值数额会清空，未满50元的部分会累计下去。<color=yellow>活动结束后就不能领取返还了，切记，切记！！<color>
  ]],
  },
  [4004] = {
    szName = "家族周活动目标揭晓",
    nLifeTime = 0, -- -1表示永久显示
    varWeight = function()
      if IVER_g_nTwVersion == 1 then
        return 0
      end
      return 10
    end,
    varContent = [[
    想必“兄弟同心，其利断金”的寓意大家应该知道吧，身处同一个家族却往往各做其事，这样的生活你是否也觉得有力没处使呢？不过，各扫门前雪的日子已经结束了，“家族周活动目标”揭开了它神秘的面纱。
    每周一零时，您所在家族就会获得一个周目标，包括且不仅限于白虎堂、宋金、江湖通缉任务、逍遥谷和军营副本。在这一周之内，参加家族指定周活动，并且达到一定的完成度<color=green>（详情请参考最新活动“【家族周活动目标】获得贡献度”栏中的相应内容）<color>，就可以在各大城市的武林盟主特使处领取相应奖励。
    让我们结束这个没有目标的时代吧。准备好，叫上您家族中的朋友，大家一起为家族、帮会甚至是自己谋取福利吧。
    <color=green>特别注意：成为正式成员后，只有从下周一开始，参加相应的活动才会增加贡献度。<color>
  ]],
  },
  [5000] = {
    szName = "新年活动开启",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200901140000 and nCurTime < 200902130000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：<color><color=red>2009年1月14日维护后——2009年2月13日0点<color>
    
    <color=green>活动内容：<color>
    
    <color=green>活动一：打雪仗<color>
    你总打过雪仗的吧？冰天雪地，漫天的雪球飘飞，欢声笑语破长空。
    活动期间玩家可以到<color=yellow>各新手村晏若雪<color>处，报名参加打雪仗的活动，每天能获得<color=yellow>2次<color>报名机会，最多可累计到<color=yellow>14次<color>。可以利用道具到晏若雪处兑换额外的报名次数。
    详情可询各新手村晏若雪或打开帮助锦囊（F12）查看！
    
    <color=green>活动二：礼官拜年，烟花漫天<color>
    <color=yellow>礼官<color>人老心不老，今年心血来潮，去<color=yellow>各大门派<color>拜年送礼，据说遇到他的人，都能获得奖励，还能得到一个礼官特制的<color=yellow>新年烟花<color>，据说练武之人使用可获得奇效。
    礼官老顽童脾性，拿到什么是什么，说不定，嘿嘿，就给你个稀世珍宝呢。
    详情可询各大城市新手村礼官或打开帮助锦囊（F12）查看！
    
    <color=green>活动三：拜年<color>
    在江湖漂泊多年，值此新春佳节，终于又回到了故乡，回到了那些熟悉的人身旁，亲人们对你如此思念，你觉得有必要每天去看下他们。在活动期间每天去<color=yellow>新手村白秋琳<color>处接取<color=yellow>“拜年”<color>的任务，奖励多多，赶快行动吧，长辈们一定给你准备了好多压岁钱的！
    详情可询新手村白秋琳或打开帮助锦囊（F12）查看！
    
    <color=green>活动四：击败年兽<color>
    可曾听过关于年兽的传说，爷爷辈应该经常会提起，这种怪兽在新年的时候就会出现，威胁大家的安全，但却非常害怕鞭炮的声音，这也是为什么新年总是会放鞭炮的原因，而现在你需要以你的惊世武艺教训下这野兽，打击它的嚣张气焰。
    <color=red>注意：此活动直到2009年2月20日才结束。<color>
    详情可询新手村龙五太爷或打开帮助锦囊（F12）查看！
	]],
  },
  [5001] = {
    szName = "新年充值送好礼！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200901210000 and nCurTime < 200901310000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：<color><color=red>2009年1月21日0点——2009年1月31日0点<color>
    
    <color=green>活动内容：<color>
    
    亲爱的玩家们，只要您的角色达到<color=yellow>50级<color>并且当月充值符合活动要求，就可以去<color=yellow>新手村活动推广员<color>处与其对话后，点选<color=yellow>“领取充值优惠奖励”<color>来领取您的奖励哦！
    <color=green>活动一：充值送莲花，开心打雪仗<color>
    亲爱的玩家，新年快乐！
    活动期间，只要<color=yellow>1月份<color>充值达到<color=yellow>15元<color>玩家就可去<color=yellow>新手村活动推广员<color>处领取“红粉莲花”<color=yellow>2个<color>，充值达到<color=yellow>48元可获得“红粉莲花”5个<color>。
    
    <color=red>注意：您最多只能在活动期间领取5个“红粉莲花”。<color>    
    
    <color=green>活动二：冶炼大师的回馈<color>
    一年又一年，时光匆匆，冶炼大师今年大酬宾。
    在活动期间，只要<color=yellow>1月份<color>玩家充值达到<color=yellow>48元<color>，账号下的所有角色都可以去<color=yellow>新手村活动推广员<color>处获得一个<color=yellow>祝福状态：强化费用降低20%<color>，为期<color=yellow>5天（5x24小时）<color>，请大家善加利用。
    
    <color=red>注意：活动期间，您只能获得一次该状态，所以领奖时要慎重！<color>
	]],
  },
  [5002] = {
    szName = "最快成长的秘诀——拜师",
    nLifeTime = -1,
    varWeight = function()
      local nCurLevle = me.nLevel
      if nCurLevle >= 20 and nCurLevle <= 68 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　想要更快的融入这个江湖吗？想要迅速的追上别人的等级吗？那么，请去找一位师傅吧。师傅不仅可以帮你完成各种任务、解答游戏中的各种难题，更重要的是可以进行师徒传功。
    <color=red>在师徒传功的过程中，你可以获得大量的经验，同时还可以通过完成传功任务，获得不菲的奖励。<color>（详细内容请阅读帮助锦囊中关于师徒传功的信息）
	]],
  },
  [6000] = {
    szName = "庆元宵玩家回馈活动！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200902060000 and nCurTime < 200902200000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：<color><color=red>2009年2月6日更新维护后~~2009年2月20日0点<color>
    
    <color=green>活动内容：<color>
    
    <color=green>活动一：礼官元宵送好礼<color>
    凡是当月充值达到<color=yellow>15元<color>或者江湖威望达到<color=yellow>200<color>，且等级<color=yellow>69级<color>以上的角色都可以去<color=yellow>礼官<color>处领取礼物。活动期间，每个角色都可以去礼官处领取巨额奖励，奖励共三种：<color=yellow>新春礼盒，新年红包，新春大福袋，每种可领一次。<color>奖励如下：
    <color=yellow>新春礼盒：<color>    1张秘境地图       5个7级玄晶
    <color=yellow>新年红包：<color>    288000绑定银两    2880绑定金币
    <color=yellow>新春大福袋：<color>  10个黄金福袋      大量经验

    <color=green>活动二：新春的祝福<color>
    凡是当月充值达到<color=yellow>15元<color>或者江湖威望达到<color=yellow>200<color>，且等级<color=yellow>69级<color>以上的角色都可以去<color=yellow>礼官处和好友单独组队<color>，获得其送出的祝福，并能获得奖励。
    在活动期间，每个角色有<color=yellow>10次获得亲密度3级以上的好友<color>祝福的机会，同一好友只能送出<color=yellow>1次<color>祝福，每天只能获得<color=yellow>1次<color>祝福。玩家需要与送出祝福方单独组队去和礼官对话以传达祝福。每次祝福成功后被祝福方能获得奖励。奖励如下：
    <color=yellow>玄晶：<color>     1个7级玄晶
    <color=yellow>状态效果(持续1小时)：<color> 打怪经验增加110% 
	                       幸运增加30点
	                       7级磨刀石效果
	                       7级护甲片效果
	                       7级五行石效果

    <color=green>活动三：晏若雪的礼物<color>
    新年活动结束后，在元宵活动时间内飞絮崖荣誉排行榜<color=yellow>前20名<color>的玩家能在<color=yellow>新手村晏若雪<color>处获得她送出的礼物，领奖机会仅一次。到时晏若雪离开就不能拿到礼物了。奖励如下：
    <color=yellow>第1名：<color>5个高级勾魂玉
    <color=yellow>第2~4名：<color>3个高级勾魂玉
    <color=yellow>第5~10名：<color>2个高级勾魂玉
    <color=yellow>第11~20名：<color>1个高级勾魂玉
    <color=yellow>称号（奖给前20名）：<color>飞絮崖专属称号
	]],
  },
  [7000] = {
    szName = "《剑侠世界》玩家福利领取！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200902200000 and nCurTime < 200903200000 then
        return 10
      end
      return 0
    end,
    varContent = string.format(
      [[	
　　<color=green>《剑侠世界》玩家福利领取<color>
    <color=green>介绍<color>
    从即日起，《剑侠世界》的玩家们都可以在各大城市新手村<color=yellow>礼官<color>处领取福利，这将使您的游戏生活更加轻松愉快。目前，我们将向广大玩家发放如下<color=yellow>三项福利<color>。
    
    <color=green>精活药打折卖<color>
    每天，当玩家<color=yellow>江湖威望<color>达到一定值（按玩家江湖威望排名获得），可以在礼官处以<color=yellow>4折<color>的价格买到精气散（小）与活气散（小）各<color=yellow>5瓶<color>；
    
    <color=green>绑银换银两<color>
    每周，当玩家<color=yellow>江湖威望<color>达到一定值（按玩家江湖威望排名获得），可在礼官处将<color=yellow>12万绑定银两<color>兑换为<color=yellow>12万银两<color>，不会累计到下一周，请大家尽快去兑换。
    
    <color=green>充值送威望<color>
    每月，当玩家<color=yellow>充值<color>达一定数额每周可在礼官处领取<color=yellow>江湖威望<color>。充值满%s元而不足%s元的，每周可领取<color=yellow>10点<color>江湖威望，充值达%s元每周可领取<color=yellow>20点<color>江湖威望。不会累计到下月，请充值的玩家尽快去领取。
]],
      IVER_g_nPayLevel1,
      IVER_g_nPayLevel2,
      IVER_g_nPayLevel2
    ),
  },
  [7001] = {
    szName = "元宵余庆——绑金大派送！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200902200000 and nCurTime < 200902280000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：2009年2月20日更新维护后~~2009年2月28日0点<color>
    
    <color=yellow>元宵佳节刚过，但我们快乐的心情还要延续！<color>
    为了答谢广大用户对我们的支持，只要您在奇珍阁内消费了<color=yellow>本月<color>充值所得的<color=yellow>500金币<color>，就会获得<color=yellow>100绑定金币<color>的返还，而且消费得越多获得的绑定金币就会越多。怎么样？心动了吧。
    
    特别注意：
    1.当月成功充值“15元充值卡”、“30元充值卡”、“48元充值卡”、“50元充值卡”、“100元充值卡”、“500元充值卡”中任意数量的实卡或虚卡、银行卡，所获得金币，才会计入活动范围。
    2.消费的金币只有本月充值获得的部分才会被认为有效。比如：本月充值获得1000金币，活动期间消费了1500金币，那么您只能得到200绑金的奖励，另外500金币是不算数的。
    3.在奇珍阁购物车下方的信息提示界面会实时显示您已消费的金币，请玩家注意提示信息。
  ]],
  },
  [7002] = {
    szName = "元宵余庆——强化费用直降！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200902200000 and nCurTime < 200902280000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=green>活动时间：2009年2月20日更新维护后~~2009年2月28日0点<color>
    
    <color=yellow>元宵佳期已逝，快乐的游戏生活依然继续！<color>
    活动期间，凡江湖威望不低于<color=yellow>50点<color>或者本月累计充值达<color=yellow>15元<color>的侠客，都可以到位于各新手村中的<color=yellow>活动推广员<color>处，接受这条神奇的祝福。有了这条祝福，在您强化任意装备时，强化手续费都会<color=yellow>降低20%<color>哦。
    活动奖励：强化手续费降低
    
    特别注意：当月成功充值“15元充值卡”、“30元充值卡”、“48元充值卡”、“50元充值卡”、“100元充值卡”、“500元充值卡”中任意数量的实卡或虚卡、银行卡，才会计入累计充值。
  ]],
  },
  [8000] = {
    szName = "美女节活动开启！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200903030000 and nCurTime < 200903100000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=red>美女节活动开启<color>
    <color=green>活动时间：2009年3月3日更新维护后——2009年3月10日0点<color>
    
    <color=green>活动内容：<color>
    每年3月8日，就是全天下女人的节日。在这一天，女孩们可以尽情开心，男人们嘛就要努力勤快点咯。
    
    活动期间，<color=yellow>60级<color>以上的<color=yellow>男性<color>玩家每天都有<color=yellow>1次<color>机会去<color=yellow>首饰铺老板郝漂靓<color>处领取道具<color=yellow>“美丽的花篮”<color>，共<color=yellow>5次<color>机会。利用此花篮可以对你的<color=yellow>女性好友<color>进行祝贺，从而获得奖励。
    只要你的女性好友等级达到<color=yellow>60级<color>，亲密度达<color=yellow>3级<color>且未祝贺过她，那么你可以在与其<color=yellow>组队<color>的情况下祝贺她，成功后双方都能得到奖励。
    友情提示：男玩家在完成5次祝贺及女玩家被祝贺10次后都能获得一个称号,女玩家只有前10次祝贺会得到额外奖励，10次后就只有称号奖励了!
    
    <color=green>活动奖励：<color>玄晶，银两，经验，称号,面具。
  ]],
  },
  [8001] = {
    szName = "更换辅修门派",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200903030000 and nCurTime < 200903240000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=yellow>更换辅修门派<color>
    1.每个角色有一次重新选择辅修门派的机会。
    2.角色当前已辅修了门派,可以从<color=yellow>当前门派掌门处<color>进入洗髓岛更换辅修门派。

  ]],
  },
  [8002] = {
    szName = "植树节活动开启",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200903100000 and nCurTime < 200903170000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=green>活动时间：2009年3月10日更新维护后~~2009年3月17日0点<color>
    <color=green>活动内容：<color>
    活动期间，<color=yellow>60级<color>以上的玩家可以去<color=yellow>新手村伐木小屋老板木良<color>处领取<color=yellow>“陈年树种”<color>进行植树活动。如果是<color=yellow>第一次<color>领取树种，还可以得到1个漂亮的<color=yellow>洒水壶<color>，此壶在种树时可浇水<color=yellow>10次<color>，可随时去木良处将壶装满。
    获得“陈年树种”后，在<color=yellow>新手村<color>可进行种植操作。整个种植过程分<color=yellow>5个<color>阶段，需要浇水<color=yellow>5次<color>。刚种下树种后需要在<color=yellow>1分钟<color>内浇水，两次浇水间隔时间<color=yellow>不得小于1分钟，大于2分钟<color>。超过时间未浇水，树苗死亡种树失败。最后，出现“好大一棵树”<color=yellow>2分钟<color>后可从树上摘取到<color=yellow>“饱满的树种”<color>，据此可到木良处换取奖励，每天只能种出<color=yellow>2棵<color>“好大一棵树”，且此树会在存在<color=yellow>1小时<color>后会消失，所以请尽快去摘取果实换取奖励。
    
    友情提示：树木成长过程中能获得<color=yellow>经验<color>（每天最多获得相当于72分钟篝火的经验），且队伍成所种树木的经验可<color=yellow>共享叠加<color>（自己在种树时才可获得经验），所以在种树时尽量组满队伍，同时把握好浇水的良机。
    
    <color=green>活动奖励：高级玄晶，经验；<color>
  ]],
  },
  [8003] = {
    szName = "开放三修门派",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200903110000 and nCurTime < 200903310000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=yellow>开放三修门派<color>
    1.每个角色增加一次辅修门派的机会，即目前已拥有选择两个辅修门派的机会。
    2.角色等级达到100级，并已加入了门派，即可从<color=yellow>当前门派的掌门<color>处进入<color=yellow>洗髓岛<color>进行门派辅修。

  ]],
  },
  [8004] = {
    szName = "老朋友重出江湖活动开启",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200903170000 and nCurTime < 200904160000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=green>活动时间：2009年3月17日维护后~~4月16日0点<color>
    
    <color=red>召回老朋友一起拿大奖<color>
    是否对很久不见的老朋友非常想念？是否很想和以前的老朋友一起行走江湖？2009年3月17日例行维护后，将开放老朋友重出江湖活动，快带上你多日未见的老朋友来参加活动吧，令人疯狂的奖励等着你们！
    <color=green>活动内容：<color>
    <color=yellow>一、老朋友召回<color>
    与被你召回的老朋友组队与礼官进行对话，即可形成召回关系，被召回的老朋友3个月内在奇珍阁购买道具并消耗后自己可获得高额绑金奖励。
    <color=yellow>二、带老朋友游剑世<color>
    等级不小于89级，江湖威望不小于100点的玩家，可以在礼官处领取“帮助老朋友回归”任务，奖励丰厚！
    <color=yellow>三、祝福老朋友<color>
    与亲密度大于2级的老朋友组队去礼官处祝福对方，即可获得7级玄晶1个，共5次机会。
    
    <color=red>老朋友回归好礼送不停<color>
    朋友一生一起走，一句话一辈子，2009年3月17日例行维护后，将开放老朋友重出江湖活动，上线即送七重大礼，还有好友带你游剑世，让你轻松搞定等级和装备，尽快融入朋友圈，如果你是我们的老朋友，那可一定要来参加哦~
    <color=green>活动内容：<color>
    <color=yellow>一、上线即送七重大礼<color>
    1.7级玄晶10个、黄金福袋50个、秘境地图2张、门派竞技高级令牌10个、白虎堂高级令牌10个、家族令牌（高级）10个、义军令牌20个和战场令牌（凤翔）20个；
    2.离开天数*0.5小时的额外4倍修炼时间； 
    3.离开天数*10次的额外开黄金福袋的机会；
    4.离开天数*5个的额外使用精气散（小）和活气散（小）的机会；
    5.离开天数*1次的额外祈福机会； 
    6.强化费用降低20%，奇珍阁金币消费满500金币送100绑金的优惠（领取后效果持续7天）；
    7.老朋友回归，上线即可获得“重出江湖”的荣誉称号，尊贵专享。
    <color=yellow>二、好友带你游剑世<color>
    老朋友回归后在各大城市新手村礼官处可以领取“回归”任务，获取丰厚奖励。
    <color=yellow>三、老朋友的欢迎祝福<color>
    老朋友回归后可与亲密度大于2级的好友组队去礼官处接受对方的祝福，即可获得特殊状态效果，对练功打宝均有助益！
    <color=yellow>四、全面参与家族活动<color>
    1.重出江湖的的老朋友即使是荣誉成员，一周内也可以正常参加家族关卡和旗子
    2.重出江湖的的老朋友有一次立刻叛离家族，加入新家族的机会。此时离开家族不扣威望，加入新家族后立刻成为正式成员，不需要经过考验期。
    <color=red>以上活动详情请询各大城市新手村礼官或查看帮助锦囊（F12）最新消息栏！<color>
  ]],
  },
  [8005] = {
    szName = "资料片新玩法体验活动——真元",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201009200000 and nCurTime < 201010032400 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=red>资料片新玩法体验活动——真元系统<color>
    <color=green>活动时间：2010年9月20日更新维护后~~2010年10月3日24点<color>
    
    <color=green>领奖地点：叶芷琳<color>
    <color=green>活动内容：<color>
        为了鼓励玩家体验资料片的新玩法，在活动期间凡是体验真元系统到一定程度的大侠均能获得丰厚奖励！
        当你装备到身上的护体真元任一属性资质达到6星或7星以上时，去和叶芷琳对话均能获得<item=18,1,541,2>和<item=18,1,524,1>及神秘称号！
        
    <color=red>特别提示：<color>
        资质达到6星和7星均可领奖一次，共2次哦。
        想了解真元系统的详细帮助信息请查阅帮助锦囊（F12）的详细帮助栏！
  ]],
  },

  [8006] = {
    szName = "资料片新玩法体验活动——成就",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201009280000 and nCurTime < 201010042400 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=red>资料片新玩法体验活动——成就系统<color>
    <color=green>活动时间：2010年9月28日更新维护后~~2010年10月4日24点<color>
    
    <color=green>领奖地点：叶芷琳<color>
    <color=green>活动内容：<color>
        为了鼓励玩家体验资料片的新玩法，在活动期间凡是体验成就系统到一定程度的大侠均能获得丰厚奖励！
        当你获得的成就点数达到<color=yellow>160点<color>时，去和叶芷琳对话均能获得<item=18,1,114,9>，大量绑定银两及神秘称号！
        
    <color=red>特别提示：<color>
        想了解成就系统的详细帮助信息请查阅帮助锦囊（F12）的详细帮助栏！
  ]],
  },

  [8007] = {
    szName = "神秘阵法秘本横空出世！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200903310000 and nCurTime < 200904310000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=red>神秘阵法秘本<color>
    《剑侠世界》又开放了<color=yellow>10本<color>新阵法，将令您的游戏旅程更加有趣生动。它们分别是：
    <color=yellow>阵法图：五行阵
    阵法图：八卦阵·离
    阵法图：八卦阵·兑
    阵法图：八卦阵·艮
    阵法图：八卦阵·坎
    阵法图：八卦阵·巽
    阵法图：八卦阵·乾
    阵法图：青龙阵
    阵法图：玄武阵
    阵法图：白虎阵
    阵法图：朱雀阵<color>
    从即日起，各大城市新手村<color=yellow>钱庄魂石商店<color>处出售中级阵法册——<color=yellow>六韬辑注<color>，可以从该阵法册中不限制的取出这10本阵法，不用的阵法书页可以放回到阵法册中。
    新的阵法包含近距离效果和远距离效果2套，当队伍内的成员距离队长较近时可以同时享受到近距离效果和远距离效果的加成，但如果和队长距离较远就只能受到远距离效果的作用。
    详情请参阅帮助锦囊（F12）“最新活动”栏！
  ]],
  },
  [9000] = {
    szName = "【逍遥谷】新玩点——逍遥录！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200903310000 and nCurTime < 200904312400 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=red>具体内容<color>
    每个月可以找<color=yellow>逍遥谷报名点的晓菲<color>领取一本<color=yellow>逍遥录<color>，收集逍遥录内需要的卡片。如果你收集的卡片数量达到了一定要求，下个月就可获得丰厚奖励。具体奖励如下：
    <color=green>1-10名                       1个绑定的10玄+2个9玄
    11-100名                     3个绑定的9级玄晶
    101-500名                    1个绑定的9玄+2个8玄
    501-1500名                   3个绑定的8级玄晶
    1501-3000名或收集至少24张卡  1个绑定的8玄+2个7玄<color>

    此外，还可以在<color=yellow>排行榜的活动排行<color>中查看排名情况
  ]],
  },
  [9001] = {
    szName = "增加一次更换辅修门派的机会",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200904100000 and nCurTime < 200904240000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=yellow>更换辅修门派<color>
    1.增加一次更换辅修门派的机会，目前已开放了两次更换辅修门派。
    2.角色当前已辅修了门派,可以从<color=yellow>当前门派掌门处<color>进入洗髓岛更换辅修门派。

  ]],
  },
  [9002] = {
    szName = "在线托管功能发布！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200906020000 and nCurTime < 200906170000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=yellow>在线托管介绍<color>
    
    1.20级或以上角色，不是满级满经验、今日剩余托管时间和剩余白驹时间都大于为0的，均可以在<color=yellow>城市、新手村或联赛会场内<color>点击<color=yellow>"系统设置"<color>的<color=yellow>"在线托管"<color>按钮进入在线托管状态。如果满足以上条件的话，<color=yellow>5分钟<color>没有移动，也会自动进入在线托管。
    2.进入在线托管状态后不可移动，<color=yellow>每5秒<color>会获得一次托管经验，右侧任务跟踪面板会提示相关托管信息。如果托管过程中变成不可托管状态或者离开了开始托管的地方，就会自动退出托管。
    3.在线托管状态下，点击<color=yellow>“系统设置”<color>的<color=yellow>“结束托管”<color>或<color=yellow>角色下方的“结束托管”<color>按钮即可退出在线托管。
    
    另外，由于角色在摆摊状态下不能做除了聊天或结束摆摊外的任何行为，所以，想要一边在线托管，一边摆摊的话需要先开启在线托管，再开启在线摆摊，之后想要结束在线托管也必须先结束摆摊才能结束在线托管。
  ]],
  },

  [9003] = {
    szName = "霸主之战活动即将开启",
    nLifeTime = -1,
    varWeight = function()
      --领土争夺战已开启满18场，并且霸主任务活动尚未开始
      local nDetDay, _, nShowFlag = Ui.tbLogic.tbHelp:GetDetDomainOpenDay()
      if nShowFlag > 0 then
        return 0
      end

      local nCureNo = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_NO)
      local nBaFlag = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_STEP)
      if nCureNo >= 18 and nBaFlag < 2 then
        return 10
      end
      return 0
    end,
    varContent = function()
      local nCureNo = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_NO)
      if nCureNo < 18 then
        return ""
      end
      local nStartTime = GetTime()

      local szMsg = [[
    <color=yellow>霸主活动简介：<color>
    <color=green>活动时间：<color>]]
      if nCureNo < 20 then
        local nDetTimes = 20 - nCureNo
        if nDetTimes < 0 then
          return ""
        end
        local nNeedDay = EventManager.IVER_nDomainBattleDay + 1
        for i = 1, nDetTimes, 1 do
          local tbTemp = os.date("*t", nStartTime)
          if tbTemp.wday > 1 and tbTemp.wday < nNeedDay then
            nStartTime = nStartTime + 3600 * 24 * (nNeedDay - tbTemp.wday)
          elseif tbTemp.wday == 1 then
            nStartTime = nStartTime + 3600 * 24 * (nNeedDay - tbTemp.wday)
          elseif tbTemp.wday == 7 then
            nStartTime = nStartTime + 3600 * 24 * 1
          end
        end
        nStartTime = nStartTime + 3066 * 24 * 1
      end

      if nStartTime < 1245859200 then
        nStartTime = 1245859200
      end

      local nEndTime = nStartTime + 3600 * 24 * 15
      local tbStart = os.date("*t", nStartTime)
      local tbEnd = os.date("*t", nEndTime)
      local szStartDay = string.format("%d月%d日", tbStart.month, tbStart.day)
      local szEndDay = string.format("%d月%d日", tbEnd.month, tbEnd.day)

      szMsg = string.format("%s\n    %s~%s\n", szMsg, szStartDay, szEndDay)

      szMsg = szMsg .. [[    逢周一~周五：16：00~17：00；21：00~22：00；
    逢周六~周日：16：00~17：00
    <color=green>活动内容：<color>
    每天，在一些大宋国境内的领土上，会出现持有霸主之印残片的领土守卫者。击败他们！可获得霸主之印的残片。
    使用生活技能，可以将霸主之印的残片加工制作成“霸主之印”，交予临安府的<link=npcpos:礼部侍郎,0,4470>，可以获得一定的奖励，上交的数量越多，奖励越丰厚！]]

      local nEndAwardDay = nEndTime
      local tbEndAwardDay = os.date("*t", nEndAwardDay)
      local szEndAwardDay = string.format("%d月%d日", tbEndAwardDay.month, tbEndAwardDay.day)

      szMsg = string.format("%s\n    缴纳霸主之印的时间为：\n        <color=yellow>%s 23：00~%s 23：00<color>\n    相应奖励在%s 23：00后领取\n", szMsg, szStartDay, szEndAwardDay, szEndAwardDay)

      szMsg = szMsg .. [[ 
    活动结束后，上交霸主之印数量最多者，将获得朝廷钦赐的<color=yellow>树立本人雕像<color>的机会！更有机会获得<color=yellow>120级特殊坐骑！<color>
    霸主任务结束后，领土争夺战将开启第二章，开放金国境内的<color=yellow>11<color>块领土地图！
  ]]

      return szMsg
    end,
  },

  [9004] = {
    szName = "霸主之战震撼开战！",
    nLifeTime = -1,
    varWeight = function()
      --在霸主任务开启的15天内显示
      local nDetDay, _, nShowFlag = Ui.tbLogic.tbHelp:GetDetDomainOpenDay()
      if nShowFlag > 0 then
        return 0
      end

      local nBaFlag = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_STEP)

      if 2 == nBaFlag then
        return 10
      end

      return 0
    end,
    varContent = function()
      local szMsg = [[
    霸主之战震撼开战！
    霸主之战简介：
    <color=green>活动时间：<color>]]

      local nStarTime = KGblTask.SCGetDbTaskInt(DBTASK_DOMAINTASK_OPENTIME)
      if nStarTime <= 0 then
        return ""
      end
      local nEndTime = nStarTime + 3600 * 24 * 15
      local tbStart = os.date("*t", nStarTime)
      local tbEnd = os.date("*t", nEndTime)

      local szStartDay = string.format("%d月%d日", tbStart.month, tbStart.day)
      local szEndDay = string.format("%d月%d日", tbEnd.month, tbEnd.day)

      szMsg = string.format("%s\n    %s~%s\n", szMsg, szStartDay, szEndDay)

      szMsg = szMsg .. [[    逢周一~周五：16：00~17：00；21：00~22：00；
    逢周六~周日：16：00~17：00
    <color=green>活动内容：<color>
    每天，在一些大宋国境内的领土上，会出现持有霸主之印残片的领土守卫者。击败他们！可获得霸主之印的残片。
    霸主之印的残片，可以用来加工制作成霸主之印。交予临安府的<link=npcpos:礼部侍郎,0,4470>，可以获得一定的奖励，上交的数量越多，奖励越丰厚！]]

      local nEndAwardDay = nEndTime
      local tbEndAwardDay = os.date("*t", nEndAwardDay)
      local szEndAwardDay = string.format("%d月%d日", tbEndAwardDay.month, tbEndAwardDay.day)

      szMsg = string.format("%s\n    缴纳霸主之印的时间为：\n        <color=yellow>%s 23：00~%s 23：00<color>\n    相应奖励在%s 23：00后领取\n", szMsg, szStartDay, szEndAwardDay, szEndAwardDay)

      szMsg = szMsg
        .. [[
        个人收集                       奖励
        每收集500个              可兑换1个<color=yellow>10级玄晶<color>
        每收集140个              可兑换1个<color=yellow>9级玄晶<color>
        每收集40个               可兑换1个<color=yellow>8级玄晶<color>
        每收集10个               可兑换1个<color=yellow>7级玄晶<color>
        每收集3个                可兑换1个<color=yellow>6级玄晶<color>
        收集数量排名第1          <color=yellow>树立雕像、120级特殊坐骑<color>
	
        帮会总收集                            奖励
        收集总数排名第1                 增加<color=yellow>6000万<color>帮会建设资金
        收集总数排名第2                 增加<color=yellow>4000万<color>帮会建设资金
        收集总数排名第3                 增加<color=yellow>3000万<color>帮会建设资金
        收集总数排名第4                 增加<color=yellow>2000万<color>帮会建设资金
        收集总数排名第5~10且收集数量>=500个 增加<color=yellow>1000万帮会<color>建设资金
    个人当前累计收集数量，及帮会收集数量，可以在临安府的<link=npcpos:礼部侍郎,0,4470>处查询得到。
    每日上交霸主之印的排名，可在排行榜中查询到。
    <color=green>霸主任务结束后，领土争夺战将开启第二章，开放金国区域下11块领土地图！<color>
  ]]

      return szMsg
    end,
  },

  [9005] = {
    szName = "领土争夺战开启《第二章》",
    nLifeTime = -1,
    varWeight = function()
      --	领土争霸活动的第16天（结束后的第1天）
      --	显示持续15天
      local nDetDay, _, nShowFlag = Ui.tbLogic.tbHelp:GetDetDomainOpenDay()
      if nShowFlag > 0 then
        return 0
      end

      local nBaFlag = KGblTask.SCGetDbTaskInt(DBTASK_DOMAIN_BATTLE_STEP)

      if 2 < nBaFlag then
        return 10
      end

      return 0
    end,
    varContent = [[
        随着各路英雄豪杰，击退了领土守卫者，捍卫了大宋国的边疆。领土争夺战，掀开了崭新的《第二章》。
        在《第二章》中，新开放了金国境内的<color=yellow>11<color>块新的领土地图，和<color=yellow>2<color>个新手村。
        11块领土包括：<color=yellow>
   大散关   伏牛山    华山    阿房宫废墟  太行古径
   风陵渡   龙门石窟  蜀岗山  蜀岗秘境    大禹台  梁山泊
        <color>2个新手村包括：<color=yellow>
   永乐镇   云中镇<color>
  ]],
  },

  [9006] = {
    szName = "秦始皇陵重见天日！",
    nLifeTime = -1,
    varWeight = function()
      local nDetDay, nShowFlag = Ui.tbLogic.tbHelp:GetDetQinTombOpenDay()
      if nShowFlag <= 0 then
        return 0
      end
      return 10
    end,
    varContent = [[
<color=red>神秘皇陵重见天日，始皇现世山河变色！<color>

    根据一伙名为发丘门的盗墓团伙来报，于<color=yellow>阿房宫废墟的东北侧<color>发现了传说中<color=yellow>秦始皇陵<color>的进入方法，江湖各路人士无不为之震惊，同时也对里面封存了千年的宝物垂涎三尺。

    更听闻有人曾在里面看到了史书上所记载的千古一帝<color=yellow>秦始皇<color>的幻影！

    如果您自认为自己武艺已经修炼达到一定火候，如果您觉得鞘里的刀剑已经在嗜血低鸣，那么去吧，无尽的杀戮和财宝在等待着您！
    
    <color=green>详细请查阅F12帮助锦囊的最新活动。<color>
		]],
  },

  [9007] = {
    szName = "110级技能开放",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200907290000 and nCurTime < 200908180000 then
        return 10
      end
      return 0
    end,
    varContent = [[
    <color=red>110级技能开放<color>
    
    110级武功技能华丽登场，各大职业之间的互动更加丰富，战斗更加激烈，各个职业之间的配合也将产生更多组合变化，这将为宋金战场、武林联赛、领土争夺战、秦始皇陵等活动带来更多变数，为玩家带去更多乐趣和挑战！
    1.增加一次更改辅修门派的机会。
    2.在自己当前门派的<color=yellow>门派接引弟子<color>处接取<color=yellow>110级技能任务<color>，完成后即可为该门派两条路线的110级技能投点升级。
  ]],
  },
  [9008] = {
    szName = "【铁浮城危 谁人称王】",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201010260000 and nCurTime < 201011250000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=red>【铁浮城危 谁人称王】<color>

    世人从古图《清明上河图》中，发现了一座藏宝甚丰的古城，这座城池名叫“<color=yellow>铁浮城<color>”。一时间，江湖风云突变，英雄骤起，都只为这传说中的<color=yellow>铁浮城王座<color>而来……
    
    铁浮城争夺战已经拉开帷幕，<color=yellow>全区<color>的各路英雄豪杰们，请不要错过良机，各大主城的<color=yellow>铁浮城远征大将<color>将带您揭开跨服城战之序幕！
    
    <color=green>城战时间：<color>
    <color=yellow>报名：<color>周四00：00--周六19：29
    <color=yellow>准备：<color>周六19：30--周六19：59
    <color=yellow>战斗：<color>周六20：00--周六21：29
    <color=yellow>领奖：<color>周六21：30--下周三23：59
    
    <color=green>参战方法：<color>
    1、拥有超过30名装备有<color=yellow>雏凤<color>或雏凤以上披风的任意玩家的帮会，由帮会首领前往<color=yellow>铁浮城远征大将<color>处选择“帮会申请”，即为帮会报名。
    2、在报名期间内，该帮会必须有<color=yellow>30名以上<color>装备有<color=yellow>雏凤<color>或者更高等级披风、且等级大于100并加入门派的玩家前来登记，才可使帮会获得参战资格。过期若人数不满30，则报名无效。
    3、参战帮会上限为<color=yellow>45个<color>，若符合条件帮会超过45个，则之后报名无效。
    4、获得参战资格帮会的帮众，等级大于100且加入门派并装备有雏凤或雏凤以上披风即可动身前往铁浮城参战。
    
    <color=green>相关NPC：<color><color=yellow>铁浮城远征大将<color>（城市）

    <color=red>注意：<color>开启150等级上限后，开启跨服城战。
    
    <color=gold>详情请查阅F12帮助锦囊-详细帮助-跨服城战<color>

	]],
  },

  [9009] = {
    szName = "帐号安全保护服务全面升级！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200911270000 and nCurTime < 200912312359 and UiManager:CheckLockAccountState() == 1 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=red>帐号安全保护服务全面升级！<color>

    在病毒木马横行的今天，网络环境已经变的危险重重，是否还在为自己的游戏账号安全担心不已，是否一直在寻找能够安全进行游戏的办法？<color=yellow>金山密保卡、金山令牌、金山密保软件<color>联手登场，给你多一份保障，给你多一分安心，让你对盗号黑手说不！

<color=yellow>一、金山令牌<color>
    金山令牌是一种个人账户保护产品，采用一次一密的方式，每一个令牌都被付予一组唯一的电子序列号，以及一组唯一的动态口令种子，以确保令牌本身的唯一性。无须安装任何驱动或是客户端软件，随时的进行强固的身份认证。
    <color=yellow>适合角色上有贵重物品的玩家使用。<color>
    金山令牌可以在各地经销商处，以及金山淘宝官方旗舰店购买。
    金山令牌官方网站：<link=url:http://ekey.xoyo.com,官方网址,http://ekey.xoyo.com>
    金山令牌基础教程：<link=url:http://jxsj.xoyo.com/news/129914,官方网址,http://jxsj.xoyo.com/news/129914>


<color=yellow>二、金山密保卡<color>
    金山密保卡是一个记录着8行10列数字矩阵的图片，您绑定密保卡后，执行敏感操作（解除帐号密码锁进行交易、奇珍阁购买、操作金币交易所等）时会增加动态密码验证，大大提高您的账号安全。
    <color=yellow>适合所有玩家使用，免费使用，方便简单。<color>
    金山密保卡的官方网站提供免费领取下载密保卡的服务，不过要提醒大家，密保卡下载后最好打印出来或者存入手机，不要保存在电脑上，否则机器中了木马，一样会有危险哦。
    金山密保卡官方网站：<link=url:http://ecard.xoyo.com,官方网址,http://ecard.xoyo.com>
    金山密保卡基础教程：<link=url:http://jxsj.xoyo.com/news/1008115,官方网址,http://jxsj.xoyo.com/news/1008115>


<color=yellow>三、金山密保软件<color>
    金山密保软件是金山毒霸与剑侠世界联合研发的“金山密保剑侠世界专用版”防盗号软件，专门针对木马盗号对电脑进行四层防护，有效拦截键盘记录，截屏，内存提取等木马常用盗号手段。是预防木马，保护电脑的重要软件工具。
    适合所有玩家使用，下载安装后，可以一直保护电脑环境，预防木马侵袭。
    金山密保软件官方网站：<link=url:http://www.duba.net/zt/2009/mibao_jxsj,官方网址,http://www.duba.net/zt/2009/mibao_jxsj>

	]],
  },

  [9010] = {
    szName = "收个同伴在身边，逍遥江湖不孤单！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 200912220000 and nCurTime < 201001222359 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=red>收个同伴在身边，逍遥江湖不孤单！<color>

    人生所贵在知已，四海相逢骨肉亲。大侠们在独行江湖时，是不是有些寂寞，如果有个同伴陪你一起出生入死，笑傲江湖，独自闯荡的日子是不是也变得热闹一些了呢？
     
    12月22日，<color=yellow>同伴功能隆重推出，游戏中的NPC有机会成为你的同伴了<color>，与你同游江湖，笑傲群雄。
    
    <color=yellow>角色满100级后，可到各大新手村的龙五太爷处接受寻找同伴的任务。<color>龙五太爷会详细的告诉你寻找同伴的方法。赶快行动吧！
    
    详细说明请查阅F12帮助锦囊的<color=green>最新活动<color>，以及<color=green>详细帮助<color>栏目。

	]],
  },

  [9011] = {
    szName = "高级秘籍横空出世  虎虎生威笑傲江湖",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201002020000 and nCurTime < 201003030000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　<color=red>高级秘籍横空出世！虎虎生威笑傲江湖！<color>

    江湖十二门派高级秘籍横空出世！各个门派除了增加新的技能以外，潜能点也有了全方位的提高！
    
    <color=yellow>一、无字天书藏秘法，秋姨有本秘籍藏。<color>
    达到100级已入门派的玩家，在各新手村白秋琳处完成“无字天书”任务后，可以获得一本对应职业和路线的高级秘籍！
    <color=yellow>二、游龙秘宝现古币，龙五古币换秘籍。<color>
    一本秘籍无法将技能修满，您还可以去游龙阁寻找游龙古币，用游龙古币在新手村龙五太爷处兑换更多高级秘籍。
    <color=green>详情请查看“F12最新活动”【高级秘籍】横空出世·虎虎生威。<color>
    
    值得注意的是中级秘籍被替换后，附带的中级秘籍技能并不会消失，还可以继续使用！大侠们快点换上高级秘籍，踏上新的征程吧！
    在虎年到来之际，高级秘籍一定会让您虎虎生威，笑傲江湖！

	]],
  },

  [9012] = {
    szName = "★强？更强！全新战斗力上线★",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201009140000 and nCurTime < 201010130000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　伴随此次更新，全新战斗力、真元系统上线。开放<color=yellow>150等级<color>上限的服务器玩家将会获得新的属性——<color=yellow>战斗力<color>。
    
    <color=green>何为战斗力？<color>
    打开F1界面，将会在人物属性下方查看到您的战斗力数值。战斗力数值由<color=yellow>装备、同伴、角色等级等<color>因素决定。
    <color=yellow>战斗力差值在PK中会影响玩家之间的伤害加成以及受到的伤害减免<color>，分别最多同时影响三位对手。
    
    <color=green>何为真元？<color>
    部分特定同伴可在F9同伴界面中<color=yellow>凝聚<color>为真元，真元自身具有的魔法属性可提升玩家能力。同时通过真元炼化，提高真元排名，可提升玩家战斗力。
    
    <color=green>何为成就？<color>
    玩家通过完成游戏中<color=yellow>特定任务目标<color>而获得<color=yellow>成就及成就点数<color>。总成就点数<color=yellow>每天更新排名<color>，依据排名，玩家角色会获得不同的<color=yellow>战斗力加成<color>。

    <color=green>何为经验任务发布平台？<color>
    <color=yellow>钱庄老板<color>处新设<color=yellow>经验任务发布平台<color>，可以发布并接受经验任务。经验任务通过<color=yellow>全新的心得书<color>系统来完成，更加合理的使玩家快速各取所需，获得<color=yellow>经验、银两或者绑金<color>。

    <color=green>战斗力排行榜<color>
    打开战斗力排行榜（Ctrl+C），可查看您当前的战斗力排名，以及影响战斗力排名各因素的单项排名。<color=yellow>排行榜每天更新一次<color>。
    
    关于战斗力与真元的更详细信息请查阅F12-详细帮助-战斗力/真元。

	]],
  },

  [9013] = {
    szName = "★全新藏宝图副本上线★",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201009140000 and nCurTime < 201010130000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
    全新藏宝图副本闪亮登场，全新玩法、丰富奖励、更强难度，等你来挑战。
    
    <color=green>如何进入副本？<color>
    等级大于50级之后，持有副本相应令牌，与<color=yellow>义军军需官<color>对话即可选择副本以及合适的难度进行挑战。
    
    <color=green>如何领取奖励？<color>
    众侠士可<color=yellow>击败副本最终boss<color>后传入<color=yellow>得悦舫<color>领取奖励，亦可与副本中<color=yellow>关小刀<color>对话，<color=yellow>提前结束副本<color>，依据副本进度在<color=yellow>得悦舫<color>领取奖励。

    <color=green>奖励依据哪些标准发放？<color>
    1、副本通关时间；
    2、在副本中击败敌人的数量；
    3、副本难度；
    4、队伍其他成员与您的社会关系；
    5、您当前的等级。

    关于藏宝图副本更详细信息请查阅F12-详细帮助-藏宝图。

	]],
  },

  [9014] = {
    szName = "★活动评价系统★",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201009140000 and nCurTime < 201010130000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　诸位侠士完成游戏中活动后，可依据活动中表现在得悦舫与蒋一萍对话获得奖励。
    
    <color=green>如何领取奖励？<color>
    与<color=yellow>义军军需官<color>对话进入<color=yellow>得悦舫<color=>，与舫中NPC<color=yellow>蒋一萍<color>对话可查看、领取您在之前活动中获得的奖励（<color=yellow>奖励会为侠士保留24小时，请在此时间内领取<color>）。
    
    关于评价系统更详细信息请查阅<color=yellow>F12-详细帮助-评价系统<color>。

	]],
  },

  [9015] = {
    szName = "★更强挑战，缉拿蚀月教徒★",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201009200000 and nCurTime < 201010130000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　近日各地出现不少蚀月教徒，传播邪说异端，民众被其蛊惑。等级达到<color=yellow>100<color>级的侠士可在刑部捕头处领取官府通缉任务，挑战更强BOSS。
    
    <color=green>更多玩法更多挑战！<color>
    通过完成官府通缉任务，缉拿蚀月教徒，侠士可将刑部捕头奖励的<color=yellow>碎片合成为召唤更强BOSS的道具<color>。
    
    <color=green>更多惊喜！<color>
    击败召唤BOSS后不仅可以获得奖励，众侠士还可把握机会将部分BOSS劝说为同伴。
    
    关于缉拿蚀月教徒更详细信息请查阅F12-详细帮助-任务系统-官府通缉任务-缉拿蚀月教徒。

	]],
  },

  [9016] = {
    szName = "宋金战火一触即发",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201009200000 and nCurTime < 201010130000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　服务器开放150等级上限后156天，各位侠士可参加凤翔战场新模式——战神元帅模式，宋金大战一触即发。
    
    <color=green>更多玩法<color>
    凤翔战场中新增<color=yellow>战神元帅模式<color>，更刺激玩法尽在宋金战场之凤翔战场！
           
    关于宋金战场更详细信息请查阅F12-详细帮助-宋金战场。

	]],
  },

  [9017] = {
    szName = "★华丽外装上线★",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201009280000 and nCurTime < 201010270000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　更靓丽的外观，更个性的搭配，一切尽在外装系统中体验。
    
    <color=green>如何获得外装？<color>
    防具商<color=yellow>沈荷叶<color>处新进一批外装货物，众侠士可以用<color=yellow>月影之石<color>与其兑换到外装来装扮自己。不同的外装需要众侠士<color=yellow>战斗力排名<color>达到一定名次。
    
    <color=green>外装有何作用？<color>
    1、外装没有任何属性加成只有外形效果。
	2、装备外装后，外装效果会覆盖当前装备外形，但是会被变身效果和面具覆盖。
	3、沈荷叶处现有帽子和衣服两种外装贩卖，分别改变众侠士头部和身体部位的外形效果。
    
    关于外装系统更详细信息请查阅F12-详细帮助-外装系统。

	]],
  },
  [9018] = {
    szName = "巾帼英雄赛开幕！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201010120000 and nCurTime < 201011050000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　武林风云再起，红颜一笑倾城。巾帼英雄赛拉开帷幕。

    <color=green>活动时间：<color>10月12日0:00~11月5日24:00

    <color=green>活动介绍：<color>
	1、在<color=yellow>10月12日0:00~10月26日24:00<color>期间，《剑侠世界》中所有女玩家（<color=yellow>等级大于60<color>）皆可在临安海选大使“丁丁”处报名参加巾帼英雄美女海选，并获得“巾帼英雄候选人”称号。在此期间，所有玩家可使用金珠玉翠为心目中的巾帼英雄投票。
	2、10月19日和23日将举行“<color=yellow>同系单人赛<color>”，26日、28日、30日和31日将举行“<color=yellow>混合单人赛<color>”，届时所有巾帼英雄候选人皆可报名参赛或者擂台观战。为候选人投票亦可获得观战机会。
	3、11月2日，各服“同系单人赛”、“混合单人赛”积分前十的候选人，可前往<color=yellow>跨服巾帼英雄赛场进行跨服决赛<color>。决赛采取混合单人赛的形式。决出全区全服的巾帼英雄。
	4、台上参赛选手角逐的同时，台下玩家可参与“<color=yellow>护花使者<color>”游戏为台上选手加油。在每日比赛中的16强、8强赛后也有<color=yellow>抢宝箱<color>活动。每场比赛冠军获胜后点击旗帜将会刷新宝箱。

    <color=green>活动奖励：<color>
	1、票数499以上候选人可获得称号、面具、两枚10级玄晶等奖品，票数前十名可获得称号：<color=yellow>绝代佳人<color>，最新款的外装<color=yellow>暮光鎏霞<color>，以及<color=yellow>11级玄晶<color>一枚。各服票数第一名候选人获得称号：<color=yellow>国色天香<color>，最新款的外装<color=yellow>暮光鎏霞<color>，并且还有<color=yellow>白马以及12级玄晶<color>奖励。
	2、参加各服单人赛的16强选手可获得巾帼英雄赛礼包奖励，跨服联赛中的优胜者将有将有<color=yellow>面具、特效、24格背包、五色石<color>等待着你。
    3、赛后七大区冠军选手中获得金珠玉翠最多的一位美女将成为游戏中NPC。

    更多详细信息请查阅F12-最新活动-巾帼英雄赛相关内容。

	]],
  },
  [9019] = {
    szName = "★家族资金上线★",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201011230000 and nCurTime < 201012220000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
　　本次更新后家族界面中新增<color=yellow>家族资金<color>管理分页，家族长可依据家族自身需求更方便的管理和发放家族福利。
    同时家族资金可与帮会资金实现<color=yellow>无税款转换<color>，方便帮会资金的管理和使用。

    详情请查阅F12帮助锦囊-详细帮助-家族帮会系统-家族-家族资金。

	]],
  },
  [9020] = {
    szName = "第五届跨服联赛开启",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201101070000 and nCurTime < 201101300000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
    <color=green>活动时间：<color>2011年1月7日——2011年1月29日
    
    <color=green>活动形式：<color>
    本届联赛采取<color=yellow>相克双人赛<color>模式，与联赛相克双人赛类似。
    
    <color=green>活动奖励：<color>
    1、单场比赛无论胜负，皆有<color=yellow>经验、江湖威望、联赛声望、荣誉，胜利的队伍还会获得礼包<color>奖励。
    2、依据联赛名次可获得更多经验、联赛荣誉奖励，以及<color=yellow>武林联赛声望令牌<color>。并且还有<color=yellow>五色石<color>奖励。五色石加工后可在跨服联赛商店购买<color=yellow>白玉、同伴装备<color>。白玉可换取跨服联赛声望。
    
    <color=green>场外活动：
    1、<color=yellow>江湖威望<color>达到本服<color=yellow>前5000<color>的玩家可在临安跨服联赛官员旁为选手助威，并获得<color=yellow>玄晶、绑金<color>奖励。每天限一次。
    2、大区内所有选手总积分最多的四个服务器可获得明星服务器称号，财富前5000玩家共享祝福。
    
    更多介绍请查看详细帮助、最新活动中第五届跨服联赛内容！

	]],
  },
  [9021] = {
    szName = "家族战功能上线",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201012210000 and nCurTime < 201101200000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
    本次更新后，侠士可以在<color=yellow>公平子<color>处选择家族战选项。只要<color=yellow>双方族长组队<color>前来预订家族战，并确认后即可开启。
    开战后双方成员可通过公平子进入战斗场地参与战斗。战斗结束后，各侠士可在公平子查询自己的战绩。

    更多详细信息请查阅帮助锦囊详细帮助家族帮会系统—家族—家族战相关内容。
    
	]],
  },
  [9022] = {
    szName = "白虎堂惊现名录，跨服的较量！",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201012290000 and nCurTime < 201103310000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
<color=red>白虎堂惊现名录，跨服的较量！<color>

    黄金白虎堂又爆出新的惊天秘闻！据说有位大侠发现了通往密室的通道，传说中的神秘名录已经浮出水面。
    <color=gold>又是一次跨服的较量！<color>
    
    侠士们在完成黄金白虎堂之后，有可能发现密室，与其它服务器的侠士们一较高下，争夺名录。<color=yellow>各区开放情况请留意官网。<color> 
    <item=18,1,1120,1>
    您有机会获得<color=green>7~10级的高级玄晶（绑定）、昏暗封印·真元（不绑定）、五色石（不绑定）<color>
    诱人的奖励等你来拿！

    小提示：跨服活动时，需要使用<color=yellow>跨服绑银<color>买药买菜。您在进入密道前可根据提示准备跨服绑银。
    详情请查阅：<color=gold>F12-详细帮助/最新活动-跨服白虎堂<color>
    
	]],
  },
  [9023] = {
    szName = "家族战开启观战功能",
    nLifeTime = -1,
    varWeight = function()
      local nCurTime = tonumber(os.date("%Y%m%d%H%M", GetTime()))
      if nCurTime > 201102220000 and nCurTime < 201103220000 then
        return 10
      end
      return 0
    end,
    varContent = [[	
<color=red>家族战开启观战功能<color>

    除参战家族成员以外，其他侠士可以在<color=yellow>公平子<color>处选择观战了。
    1、预订家族战时双方族长“<color=yellow>允许观战<color>”；
    2、开战后找公平子点击“<color=yellow>观看家族战<color>”，选择想看的家族战即可进入。

    注：每场家族战最多允许<color=yellow>15人<color>同时观看；
        家族战进行中时，您可<color=yellow>随时离开和进入<color>。
    
	]],
  },
  --!!!!!!! [10000,20000) Id段为活动系统使用;
  --!!!!!!!不要浪费Id,尽量+1递增使用,不要+1000递增,过期公告可删除回收Id!!;
}

--== 系统推荐 ==--
uiHelpSprite.tbRecInfo = {
  {
    szName = "剧情任务",
    varExpStar = function()
      local nTaskRunCount = Task:GetMyRunTaskCount()
      local nTaskAcceptCount = Task:GetCanAcceptTaskCount()
      if nTaskRunCount == 0 or me.nLevel >= 90 then
        return 0
      else
        return 9
      end
    end,
    varMoneyStar = function()
      local nTaskRunCount = Task:GetMyRunTaskCount()
      local nTaskAcceptCount = Task:GetCanAcceptTaskCount()
      if nTaskRunCount == 0 or me.nLevel >= 90 then
        return 0
      else
        return 8
      end
    end,

    varSortStar = function()
      if me.nLevel < 90 then
        local nStar = 2
        return nStar
      else
        local nStar = 0
        return nStar
      end
    end,
    varRemain = function()
      local nTaskRunCount = Task:GetMyRunTaskCount()
      local nTaskAcceptCount = Task:GetCanAcceptTaskCount()
      return string.format("你当前接了 <color=yellow>%d<color> 个任务没有完成", nTaskRunCount)
    end,
    varShowType = 0,
    varPopMsg = function()
      local szMsg
      szMsg = ""
      return szMsg
    end,
    varAward = "经验、装备、玄晶",
    varGuide = "看看有哪些<tab><link=openwnd:任务,UI_TASKPANEL>可以做",
    tbQA = {
      {
        "如何接任务和交任务？",
        "　　NPC头顶有“！”标示的，表示在该NPC处有任务可以接\r头顶有“？”标示的，表示可以在该NPC处交任务",
      },
      {
        "找不到NPC或找不到地方怎么办？",
        "　 　打开“任务面板(F4)”，点击带有下划线的NPC的名字或是地理位置名字，即会自动跑到该NPC或某地理位置",
      },
    },
  },
  {
    szName = "宋金战场",
    varExpStar = function()
      if me.nLevel < 60 then
        return 0
      else
        return 8
      end
    end,
    varMoneyStar = function()
      local nJunXu = Battle:GetRemainJunXu()
      if me.nLevel < 60 then
        return 0
      elseif nJunXu <= 0 then
        return 2
      else
        return 5
      end
    end,
    varSortStar = function()
      if me.nLevel < 60 then
        return 0
      else
        return 6
      end
    end,
    varRemain = function()
      local nJunXuCount = Battle:GetRemainJunXu()
      local szJunXuInfo = string.format("你今天还有 <color=yellow>%d<color> 份免费军需可以领取", nJunXuCount)
      local nNowTime = tonumber(GetLocalDate("%H%M"))
      local nNowWeek = tonumber(GetLocalDate("%w"))
      local bReadyTime = 0
      local bBattleTime = 0
      local nNextBattle = 0
      local bWeekEnd = 0
      local szNextBattle = ""

      local tbBattleTime = {
        { 0050, 0100, 0200 },
        { 1050, 1100, 1200 },
        { 1250, 1300, 1400 },
        { 1450, 1500, 1600 },
        { 1650, 1700, 1800 },
        { 1850, 1900, 2000 },
        { 2050, 2100, 2200 },
        { 2250, 2300, 2400 },
      }
      for _, tbTime in ipairs(tbBattleTime) do
        if nNowTime >= tbTime[1] and nNowTime < tbTime[2] then
          bReadyTime = 1
          bBattleTime = 0
          break
        elseif nNowTime > tbTime[2] and nNowTime <= tbTime[3] then
          bBattleTime = 1
          bReadyTime = 0
          break
        elseif nNowTime < tbTime[1] then
          nNextBattle = tbTime[1]
          szNextBattle = string.format("%d:%d", nNextBattle / 100, math.mod(nNextBattle, 100))
          break
        end
      end

      local szBattleInfo = ""
      if bReadyTime == 1 then
        szBattleInfo = string.format("宋金报名已经开始了！尽快去报名吧！")
      elseif bBattleTime == 1 then
        szBattleInfo = string.format("宋金战场已经打响！尽快加入进去吧！")
      else
        szBattleInfo = string.format("下一场宋金战场将在 <color=yellow>%s<color> 开始报名", szNextBattle)
      end

      if nJunXuCount > 0 then
        return string.format("%s\r%s", szJunXuInfo, szBattleInfo)
      else
        return string.format("你今天的免费军需已经领完了\r%s", szBattleInfo)
      end
    end,
    varShowType = 1,
    varPopMsg = function()
      local szMsg = "宋金战场就要开始了！你可以准备参加了！"
      return szMsg
    end,
    varAward = "腰带、经验",
    varGuide = "到 杂货铺 购买 <color=yellow>宋金诏书<color> \r或在各城市找 <link=npcpos:宋军招募使,0,2607>或 <link=npcpos:金军招募使,0,2608>",
    tbQA = {
      { "宋金战场是什么？", "宋金是每天定时定点开启的战场\r你可以选择加入宋、金中的任意一方参加战斗！" },
      {
        "宋金战场什么时候开启？",
        "每天<color=yellow>00：50、10：50、12：50、14：50、16：50、18：50、20：50、22：50<color>开始报名<color=red>注意：在开放150级等级上限后的156天后14：50分、20：50分时段战场将不开放。<color>",
      },
      {
        "如何参加宋金战场？",
        "可以到杂货铺购买“宋金诏书”使用后即可进入宋金报名点；或找各城市宋/金军招募使，也可进入宋金报名点",
      },
      {
        "宋金战场分多少种类型？",
        "角色等级在60级到89级之间可以参加初级宋金战场\r角色在90级到150级之间可以参加中级宋金战场",
      },
      {
        "满足哪些条件才能开启战场？",
        "必须在报名时间内（开战前十分钟），宋金双方同时满足参加人数的下限（即，各方至少要4人（初级）、4人（中级）、4人（高级）以上）才能正常开启",
      },
      { "参加宋金战场之前要做哪些准备？", "准备好最好的PK装备；找好合适的战友；准备好银两购买药品道具" },
      {
        "什么是免费的军需？",
        "每天每个角色会获得3次领取免费的军需的机会，军需提供了战场中所需要消耗的药品；在战场的军需官处可以领取；每天3份，领完为止，最多只能累计14份军需！",
      },
      {
        "战场中有提供了哪些服务？",
        "在战场的军需官处，可以领取今天的免费的军需品（只能在宋金战场中使用）；可以购买普通的药品；可以修理损坏的装备",
      },
    },
  },
  {
    szName = "打怪修炼",
    varExpStar = function()
      local nXlItem, nXlTime, nXlBuff = Item:GetClass("xiulianzhu"):GetXiuLianZhuInfo()
      if me.nLevel < 20 then
        return 0
      else
        return 9
      end
    end,
    varMoneyStar = function()
      local nXlItem, nXlTime, nXlBuff = Item:GetClass("xiulianzhu"):GetXiuLianZhuInfo()
      if me.nLevel < 20 then
        return 0
      else
        return 3
      end
    end,
    varSortStar = function()
      local nXlItem, nXlTime, nXlBuff = Item:GetClass("xiulianzhu"):GetXiuLianZhuInfo()
      if me.nLevel < 20 or nXlItem == 0 then
        return 0
      else
        return 7
      end
    end,
    varRemain = function()
      local nXlItem, nXlTime, nXlBuff = Item:GetClass("xiulianzhu"):GetXiuLianZhuInfo()
      local szXlBuffInfo = " "
      local szXlTimeInfo = " "
      local bBuff = 0
      if nXlBuff > 0 then
        bBuff = 1
      end
      if nXlItem > 0 then
        if bBuff == 1 then
          szXlBuffInfo = "你当前正处在修炼状态！去打怪修炼吧！"
        else
          szXlBuffInfo = "你当前还没有开启修炼状态"
        end

        if nXlTime < 14 then
          szXlTimeInfo = string.format("你还有 <color=yellow>%.1f<color> 个小时修炼时间可以使用", nXlTime)
        else
          szXlTimeInfo = "你当前修炼时间已累积达到上限14小时，如果再不使用将不会再累积"
        end

        return string.format("%s\r%s", szXlBuffInfo, szXlTimeInfo)
      else
        return string.format("你现在身上还没有带修炼珠")
      end
    end,
    varShowType = 0,
    varPopMsg = function()
      local szMsg = ""
      return szMsg
    end,
    varAward = "经验值、装备、玄晶",
    varGuide = function()
      local nXlItem, nXlTime, nXlBuff = Item:GetClass("xiulianzhu"):GetXiuLianZhuInfo()
      if nXlItem <= 0 then
        local nFactionID = me.nFaction
        if nFactionID == 1 then
          return string.format("先到<link=npcpos:少林寺主持,9,3512>那里领取修炼珠")
        elseif nFactionID == 2 then
          return string.format("先到<link=npcpos:天王帮帮主,22,3506>那里领取修炼珠")
        elseif nFactionID == 3 then
          return string.format("先到<link=npcpos:唐门门主,18,3518>那里领取修炼珠")
        elseif nFactionID == 4 then
          return string.format("先到<link=npcpos:五毒教教主,20,3524>那里领取修炼珠")
        elseif nFactionID == 5 then
          return string.format("先到<link=npcpos:峨眉派掌门,16,3530>那里领取修炼珠")
        elseif nFactionID == 6 then
          return string.format("先到<link=npcpos:翠烟门门主,17,3536>那里领取修炼珠")
        elseif nFactionID == 7 then
          return string.format("先到<link=npcpos:丐帮帮主,15,3542>那里领取修炼珠")
        elseif nFactionID == 8 then
          return string.format("先到<link=npcpos:天忍教教主,10,3548>那里领取修炼珠")
        elseif nFactionID == 9 then
          return string.format("先到<link=npcpos:武当客座主持,14,3554>那里领取修炼珠")
        elseif nFactionID == 10 then
          return string.format("先到<link=npcpos:昆仑派掌门,12,3560>那里领取修炼珠")
        elseif nFactionID == 11 then
          return string.format("先到<link=npcpos:明教教主,224,3479>那里领取修炼珠")
        elseif nFactionID == 12 then
          return string.format("先到<link=npcpos:大理段氏家主,28,3500>那里领取修炼珠")
        else
          return string.format("你无门无派，无法领取修炼珠")
        end
      else
        return "你可以和朋友一起组队去野外打怪修炼"
      end
    end,
    tbQA = {
      { "要哪些准备？", "先到掌门人处领取修炼珠\r组好队伍，人越多经验也越多" },
      {
        "有什么危险性？",
        "打怪过程偶尔会出现很强的精英和首领怪，要小心提防\r当然，还要提防其他玩家抢夺物品和恶意屠杀！",
      },
      {
        "修炼时间有什么好处？",
        "在修炼时间内，角色打怪的经验值会增加3倍（即为原来的4倍）；同时，在修炼时间内角色的幸运值会额外增加10点！",
      },
      { "修炼时间如何获得？", "使用修炼珠，开启你所需要的修炼时间" },
      { "修炼时间如何增加？", "修炼珠内的可用修炼时间，每天会自动增加1.5小时" },
      { "修炼时间上限是多少？", "修炼珠内的修炼时间最多可以累计14小时，超过14小时就再不会增加" },
    },
  },
  {
    szName = "门派竞技",
    varExpStar = function()
      local nNowWeek = tonumber(GetLocalDate("%w"))
      local nTime = tonumber(GetLocalDate("%H%M"))
      local nFaction = me.nFaction
      local bJingJiDay = 0
      local bJingjiTime = 0

      if nNowWeek == 2 or nNowWeek == EventManager.IVER_nSecFactionDay then
        bJingJiDay = 1
      end

      if nTime >= 1930 and nTime < 2120 then
        bJingjiTime = 1
      end

      if bJingJiDay == 1 and bJingjiTime == 1 and nFaction ~= 0 then
        return 8
      else
        return 0
      end
    end,
    varMoneyStar = function()
      local nNowWeek = tonumber(GetLocalDate("%w"))
      local nTime = tonumber(GetLocalDate("%H%M"))
      local nFaction = me.nFaction
      local bJingJiDay = 0
      local bJingjiTime = 0

      if nNowWeek == 2 or nNowWeek == EventManager.IVER_nSecFactionDay then
        bJingJiDay = 1
      end

      if nTime >= 1930 and nTime < 2130 then
        bJingjiTime = 1
      end

      if bJingJiDay == 1 and bJingjiTime == 1 and nFaction ~= 0 then
        return 7
      else
        return 0
      end
    end,
    varSortStar = function()
      local nNowWeek = tonumber(GetLocalDate("%w"))
      local nTime = tonumber(GetLocalDate("%H%M"))
      local nFaction = me.nFaction
      local bJingJiDay = 0
      local bJingjiTime = 0

      if nNowWeek == 2 or nNowWeek == EventManager.IVER_nSecFactionDay then
        bJingJiDay = 1
      end

      if nTime >= 1930 and nTime < 2130 then
        bJingjiTime = 1
      end

      if bJingJiDay == 1 and bJingjiTime == 1 and nFaction ~= 0 and me.nLevel >= 50 then
        return 9
      else
        return 0
      end
    end,
    varRemain = function()
      local nTime = tonumber(GetLocalDate("%H%M"))
      if nTime >= 1930 and nTime < 2000 then
        return string.format("当前门派竞技比赛正接受报名")
      else
        return string.format("门派竞技比赛已经开始，如果你还没有报名，将无法参加比武，但仍然可以参加场内的其他活动")
      end
    end,
    varShowType = 1,
    varPopMsg = function()
      local szMsg = "<bclr=green>门派竞技<bclr>就要开始，准备参加吧！"
      return szMsg
    end,
    varAward = "衣服、玄晶、经验",
    varGuide = function()
      local nFactionID = me.nFaction
      if nFactionID == 1 then
        return string.format("<link=npcpos:少林寺主持,9,3512>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 2 then
        return string.format("<link=npcpos:天王帮帮主,22,3506>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 3 then
        return string.format("<link=npcpos:唐门门主,18,3518>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 4 then
        return string.format("<link=npcpos:五毒教教主,20,3524>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 5 then
        return string.format("<link=npcpos:峨眉派掌门,16,3530>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 6 then
        return string.format("<link=npcpos:翠烟门门主,17,3536>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 7 then
        return string.format("<link=npcpos:丐帮帮主,15,3542>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 8 then
        return string.format("<link=npcpos:天忍教教主,10,3548>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 9 then
        return string.format("<link=npcpos:武当客座主持,14,3554>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 10 then
        return string.format("<link=npcpos:昆仑派掌门,12,3560>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 11 then
        return string.format("<link=npcpos:明教教主,224,3479>会指引你前往门派竞技场，进入场内后到报名官处报名")
      elseif nFactionID == 12 then
        return string.format("<link=npcpos:大理段氏家主,28,3500>会指引你前往门派竞技场，进入场内后到报名官处报名")
      else
        return string.format("你无门无派，无法参加门派竞技比赛")
      end
    end,
    tbQA = {
      {
        "门派竞技是什么？",
        "门派竞技赛是各个门派内部组织的一场比武盛会，在群战和一对一的对战过程中，决胜出本门派最强的武者",
      },
      {
        "什么时候召开？",
        string.format("每周二、周%s晚上19：30开始报名，20：00正式开始", Lib:Transfer4LenDigit2CnNum(EventManager.IVER_nSecFactionDay)),
      },
      { "如何参加？", "只要加入了门派，50级以上玩家即可参加本门派的门派竞技赛" },
      {
        "怎么玩？",
        "门派竞技比赛分为群战淘汰赛和一对一淘汰赛两个阶段，在群战淘汰赛中击败对手数最多的16人，才有资格参加一对一的淘汰赛",
      },
      { "在场内还能参加哪些其他的活动？", "可以在场内中央的练武场切磋\r在比赛过程中可以参加寻旗夺宝活动" },
    },
  },
  {
    szName = "挑战武林高手",
    varExpStar = function()
      local nNowTime = tonumber(GetLocalDate("%H%M"))
      local bBossTime = 0
      local tbBossTime = {
        { 0130, 0215 },
        { 0900, 0945 },
        { 1500, 1545 },
        { 1900, 1945 },
        { 2200, 2245 },
      }
      for _, tbTime in ipairs(tbBossTime) do
        if nNowTime >= tbTime[1] and nNowTime < tbTime[2] then
          bBossTime = 1
          break
        end
      end

      if me.nLevel > 40 and bBossTime == 1 then
        return 5
      else
        return 0
      end
    end,
    varMoneyStar = function()
      local nNowTime = tonumber(GetLocalDate("%H%M"))
      local bBossTime = 0
      local tbBossTime = {
        { 0130, 0215 },
        { 0900, 0945 },
        { 1500, 1545 },
        { 1900, 1945 },
        { 2200, 2245 },
      }
      for _, tbTime in ipairs(tbBossTime) do
        if nNowTime >= tbTime[1] and nNowTime < tbTime[2] then
          bBossTime = 1
          break
        end
      end

      if me.nLevel > 40 and bBossTime == 1 then
        return 10
      else
        return 0
      end
    end,
    varSortStar = function()
      local nNowTime = tonumber(GetLocalDate("%H%M"))
      local bBossTime = 0
      local tbBossTime = {
        { 0130, 0215 },
        { 0900, 0945 },
        { 1500, 1545 },
        { 1900, 1945 },
        { 2200, 2245 },
      }
      for _, tbTime in ipairs(tbBossTime) do
        if nNowTime >= tbTime[1] and nNowTime < tbTime[2] then
          bBossTime = 1
          break
        end
      end

      if me.nLevel > 40 and bBossTime == 1 then
        return 7
      else
        return 0
      end
    end,
    varRemain = function()
      if me.nLevel > 70 and me.nLevel <= 89 then
        return string.format("以你当前的实力，适合挑战75级的武林高手：<enter><tab=15><color=yellow>神枪方晚、赵应仙、香玉仙<enter><tab=15>蛮僧不戒和尚、南郭儒<color>")
      elseif me.nLevel > 89 and me.nLevel < 120 then
        return string.format("以你当前的实力，适合挑战95级的武林高手：<enter><tab=15><color=yellow>柔小翠、张善德、贾逸山<enter><tab=15>乌山青、陈无命<color>")
      else
        return string.format("以你当前的实力，适合挑战55级的武林高手：<enter><tab=15><color=yellow>云雪山、刑捕头、万老癫<enter><tab=15>高士贤、拓拔山渊、杨柳<color>")
      end
    end,
    varShowType = 1,
    varPopMsg = function()
      local szMsg = "<bclr=green>武林高手<bclr>即将现身江湖，准备好前去挑战吧！"
      return szMsg
    end,
    varAward = "武器、经验、玄晶",
    varGuide = function()
      local szBossInfo55 = " "
      local szBossInfo75 = " "
      local szBossInfo95 = " "
      szBossInfo55 = "55级武林高手的隐藏地：<enter><tab=15>燕子坞中段、芦苇荡西北部、原始森林西部<enter><tab=15>九老洞二层、百花阵内阵、湖畔竹林西部<enter><tab=15>塔林西部、金国皇陵二层、龙虎幻境西部<enter>"
      szBossInfo75 = "75级武林高手的隐藏地：<enter><tab=15>段氏皇陵、沙漠迷宫、风陵渡<enter><tab=15>九嶷溪、剑阁蜀道、蜀冈山、鸡冠洞<enter>"
      szBossInfo95 = "95级武林高手的隐藏地：<enter><tab=15>嘉峪关、敕勒川、蜀冈秘境、华山<enter><tab=15>丰都鬼城、武陵山、苗岭、武夷山<enter>"
      if me.nLevel > 70 and me.nLevel <= 89 then
        return string.format("%s", szBossInfo75)
      elseif me.nLevel > 89 and me.nLevel < 120 then
        return string.format("%s", szBossInfo95)
      else
        return string.format("%s", szBossInfo55)
      end
    end,
    tbQA = {
      { "什么是武林高手？", "武林高手是一些在江湖中有头有脸的人物，他们个个武艺精湛" },
      { "什么时候可以挑战？", "当武林高手现身后才有机会击败他们" },
      {
        "战胜武林高手可以得到什么？",
        "击败武林高手除了可以获得丰厚经验以外，还有机会获得很好的装备和道具，击败95级武林高手可以获得武林高手令来换取武器",
      },
      {
        "怎样才能击败武林高手？",
        "要想击败武林高手，除了要提升自己的等级以外，还有准备好最好的装备，多人一起组队胜算更大一些",
      },
      { "挑战武林高手要注意什么？", "对武林高手造成伤害最多的队伍，被认为是挑战成功者，才有资格获得奖励" },
    },
  },
  {

    szName = "挑战白虎堂",
    varExpStar = function()
      local TSKG_PVP_ACT = 2009
      local TSK_BaiHuTang_PKTIMES = 1
      local nTimes = me.GetTask(TSKG_PVP_ACT, TSK_BaiHuTang_PKTIMES)
      if nTimes == nil then
        return 0
      end
      local nResult = 0
      local szNowDate = GetLocalDate("%y%m%d")
      local nDate = math.floor(nTimes / 10)
      local nPKTimes = nTimes % 10
      local nNowDate = tonumber(szNowDate)

      if nDate == nNowDate then
        nResult = nPKTimes
      end
      if nResult < 3 and me.nLevel >= 50 then
        return 5
      else
        return 0
      end
    end,
    varMoneyStar = function()
      local TSKG_PVP_ACT = 2009
      local TSK_BaiHuTang_PKTIMES = 1
      local nTimes = me.GetTask(TSKG_PVP_ACT, TSK_BaiHuTang_PKTIMES)
      if nTimes == nil then
        return 0
      end
      local nResult = 0
      local szNowDate = GetLocalDate("%y%m%d")
      local nDate = math.floor(nTimes / 10)
      local nPKTimes = nTimes % 10
      local nNowDate = tonumber(szNowDate)

      if nDate == nNowDate then
        nResult = nPKTimes
      end
      if nResult < 3 and me.nLevel >= 50 then
        return 8
      else
        return 0
      end
    end,
    varSortStar = function()
      local TSKG_PVP_ACT = 2009
      local TSK_BaiHuTang_PKTIMES = 1
      local nTimes = me.GetTask(TSKG_PVP_ACT, TSK_BaiHuTang_PKTIMES)
      if nTimes == nil then
        return 0
      end
      local nResult = 0
      local szNowDate = GetLocalDate("%y%m%d")
      local nDate = math.floor(nTimes / 10)
      local nPKTimes = nTimes % 10
      local nNowDate = tonumber(szNowDate)

      if nDate == nNowDate then
        nResult = nPKTimes
      end
      if nResult < 3 and me.nLevel >= 50 then
        return 7
      else
        return 0
      end
    end,
    varRemain = function()
      local TSKG_PVP_ACT = 2009
      local TSK_BaiHuTang_PKTIMES = 1
      local nTimes = me.GetTask(TSKG_PVP_ACT, TSK_BaiHuTang_PKTIMES)
      if nTimes == nil then
        return 0
      end
      local nResult = 0
      local szNowDate = GetLocalDate("%y%m%d")
      local nDate = math.floor(nTimes / 10)
      local nPKTimes = nTimes % 10
      local nNowDate = tonumber(szNowDate)

      if nDate == nNowDate then
        nResult = nPKTimes
      end
      return string.format("你每天最多挑战 <color=yellow>3<color> 次白虎堂\r今天你已经参加了 <color=yellow>%d<color> 次", nResult)
    end,
    varShowType = 0,
    varPopMsg = function()
      local szMsg = "挑战白虎堂，扫除祸害恶贼"
      return szMsg
    end,
    varAward = "项链、玄晶、经验",
    varGuide = function()
      return string.format("在各大城市找<link=npcpos:白虎堂护卫,0,2654>进入白虎堂大殿，进入大殿后找各处的“白虎堂门人”报名")
    end,
    tbQA = {
      {
        "白虎堂活动如何进行？",
        "白虎堂共分3层\r每一层会有一个BOSS把守，这些BOSS会在活动开始后一段时间出现，杀掉一层的BOSS才能进下一层\r你的目标就是把这些BOSS杀掉。",
      },
      {
        "白虎堂里有什么危险？",
        "白虎堂内有一些敌对NPC他们会攻击你，不过这些不是主要的危险，真正的危险来自于其它玩家！\r由于白虎堂里是个强制PK的地方，所以别的玩家都有可能对你造成伤害，想顺利的进行下去的话就要尽量组队，或者跟本家族或帮会的人一起来。",
      },
      {
        "在白虎堂活动里我能获得什么？",
        "每一层的BOSS被击杀的话都会掉落大量玄晶，层数越高的话掉落玄晶的品质就会越好。并且凡是参加白虎堂的人均能获得白虎堂声望，打倒每一层的BOSS与通过一层都会得到额外的声望！有足够声望的话你便能购买相应的声望装备了",
      },
      {
        "什么时候可以进入白虎堂？",
        "日间：每天的8：30~17：30（按报名时间算，17：30为最后一场开始报名时间）共计10场；夜间：每天的21：30~次日6：30（按报名时间算，6：30为最后一场开始报名时间）共10场；活动半点开始报名，整点正式开始；活动报名时间为30分钟，正式活动时间30分钟，共计1小时",
      },
      {
        "进入白虎堂需要满足何种条件？",
        "50~89级、并且已经加入家族的玩家可以挑战初级白虎堂；90级以上的可以挑战高级白虎堂。在报名时自动根据你的当前等级，把你传送到适合等级的活动场地",
      },
      {
        "背景故事",
        "盐帮前代帮主晁显在白虎堂被一白衣剑客刺杀，遗落了一本价值万金的书录。以至于最近白虎堂内贼人为患，白虎堂堂主无技可施，只好请江湖上的各位侠客帮忙除贼",
      },
    },
  },
  {

    szName = "剑侠辞典",
    varExpStar = function()
      local tbQuestions, nCount = HelpQuestion:GetTitleTable(me, nGroupId)
      if nCount > 0 then
        return 1
      else
        return 0
      end
    end,
    varMoneyStar = function()
      local tbQuestions, nCount = HelpQuestion:GetTitleTable(me, nGroupId)
      if nCount > 0 then
        return 10
      else
        return 0
      end
    end,
    varSortStar = function()
      local tbQuestions, nCount = HelpQuestion:GetTitleTable(me, nGroupId)
      if nCount > 0 then
        return 9
      else
        return 0
      end
    end,
    varRemain = function()
      local tbQuestions = HelpQuestion:GetTitleTable(me, nGroupId)
      local szText = ""
      for nGroupId, szGroupTitle in pairs(tbQuestions) do
        szText = szText .. string.format("<tab=15>我想回答<tab><a=question:%d>%s<a>\n", nGroupId, szGroupTitle)
      end
      return szText
    end,
    varShowType = 1,
    varPopMsg = function()
      local szMsg = "<bclr=green>剑侠辞典<bclr>又有新题目了！"
      return szMsg
    end,
    varAward = IVER_g_szCoinName,
    varGuide = function()
      local tbQuestions = HelpQuestion:GetTitleTable(me, nGroupId)
      local szText = ""
      for nGroupId, szGroupTitle in pairs(tbQuestions) do
        szText = szText .. string.format("<tab=15>我想回答<tab><a=question:%d>%s<a>\n", nGroupId, szGroupTitle)
      end
      return szText
    end,
    tbQA = {
      {
        "什么是剑侠辞典？",
        string.format("剑侠辞典能帮你更好的了解剑侠世界的各个系统。随着你等级的提升，题组会越来越多。只要你能正确回答每组问题，都能获得%s奖励", IVER_g_szCoinName),
      },
    },
  },
  {

    szName = "藏宝图",
    varExpStar = function()
      if me.nLevel >= 20 then
        return 4
      else
        return 0
      end
    end,
    varMoneyStar = function()
      if me.nLevel >= 20 then
        return 9
      else
        return 0
      end
    end,
    varSortStar = 3,
    varRemain = function()
      if me.nLevel >= 20 and me.nLevel < 50 then
        return string.format("以你当前的等级，可以使用藏宝图挖掘宝藏")
      elseif me.nLevel >= 50 and me.nLevel <= 150 then
        return string.format("以你当前的等级，可以通过探索藏宝图副本获得奖励")
      else
        return string.format("以你当前的等级，可以通过探索藏宝图副本获得奖励")
      end
    end,
    varShowType = 0,
    varPopMsg = function()
      local szMsg = "藏宝图，发掘未知的秘密"
      return szMsg
    end,
    varAward = "绑定的银两\r<tab=10>帽子、玄晶、经验",
    varGuide = "要得到藏宝图，需要完成包万同的义军任务才会获得的奖励",
    tbQA = {
      {
        "什么是藏宝图活动？",
        "当你获得了藏宝图后，可以去杂货铺购买罗盘，通过罗盘可以找到藏宝地，就有机会挖掘出宝藏。另外，25级以上的玩家每日可点开推荐活动页面领取藏宝图副本挑战机会，人人有份永不落空。",
      },
      { "挖宝会挖到什么？", "当你在挖宝过程中，可能会挖到宝箱，更有机会获得大量玄晶哟。" },
      {
        "如何获得藏宝图？",
        "按K键打开推荐活动页面，每周可领取2次藏宝图通用挑战机会；每日可领取1次藏宝图机会。",
      },
    },
  },
  {

    szName = "花灯猜谜",
    varExpStar = function()
      local nNowTime = tonumber(GetLocalDate("%H%M"))
      local nNowWeek = tonumber(GetLocalDate("%w"))
      local bGuessDay = 0
      local bGuessTime = 0
      local nGetAward, nAllCount = GuessGame:GetAnswerCount(me)

      --20091117调整灯谜时间（kenmasterwu）
      if EventManager.IVER_bGuessGame == 1 then
        --大陆版，时间点全开
        if nNowTime >= 1230 and nNowTime <= EventManager.IVER_nGuessGameEndTime then
          bGuessTime = 1
        end
      else
        if nNowTime >= 2030 and nNowTime <= 2130 then
          bGuessTime = 1
        end
      end
      if (EventManager.IVER_bGuessGame == 1) or (nNowWeek == 1 or nNowWeek == 3 or nNowWeek == 4) then
        bGuessDay = 1
      end

      if me.nLevel >= 10 and bGuessTime == 1 and bGuessDay == 1 and nAllCount < 30 then
        return 9
      else
        return 0
      end
    end,
    varMoneyStar = function()
      local nNowTime = tonumber(GetLocalDate("%H%M"))
      local nNowWeek = tonumber(GetLocalDate("%w"))
      local bGuessDay = 0
      local bGuessTime = 0
      local nGetAward, nAllCount = GuessGame:GetAnswerCount(me)

      if EventManager.IVER_bGuessGame == 1 then
        --大陆版，时间点全开
        if nNowTime >= 1230 and nNowTime <= EventManager.IVER_nGuessGameEndTime then
          bGuessTime = 1
        end
      else
        if nNowTime >= 2030 and nNowTime <= 2130 then
          bGuessTime = 1
        end
      end
      if (EventManager.IVER_bGuessGame == 1) or (nNowWeek == 1 or nNowWeek == 3 or nNowWeek == 4) then
        bGuessDay = 1
      end

      if me.nLevel >= 10 and bGuessTime == 1 and bGuessDay == 1 and nAllCount < 30 then
        return 1
      else
        return 0
      end
    end,
    varSortStar = function()
      local nNowTime = tonumber(GetLocalDate("%H%M"))
      local nNowWeek = tonumber(GetLocalDate("%w"))
      local bGuessDay = 0
      local bGuessTime = 0
      local nGetAward, nAllCount = GuessGame:GetAnswerCount(me)

      if EventManager.IVER_bGuessGame == 1 then
        --大陆版，时间点全开
        if nNowTime >= 1230 and nNowTime <= EventManager.IVER_nGuessGameEndTime then
          bGuessTime = 1
        end
      else
        if nNowTime >= 2030 and nNowTime <= 2130 then
          bGuessTime = 1
        end
      end
      if (EventManager.IVER_bGuessGame == 1) or (nNowWeek == 1 or nNowWeek == 3 or nNowWeek == 4) then
        bGuessDay = 1
      end

      if me.nLevel >= 10 and bGuessTime == 1 and bGuessDay == 1 and nAllCount < 30 then
        return 9
      else
        return 0
      end
    end,
    varRemain = function()
      local nGetAward, nAllCount = GuessGame:GetAnswerCount(me)
      return string.format("你每天最多可以答对 <color=yellow>30<color> 题，你今天答对了 <color=yellow>%d<color> 题了", nAllCount)
    end,
    varShowType = 1,
    varPopMsg = function()
      local szMsg = "<bclr=green>花灯猜谜<bclr>即将开始，准备参加吧！"
      return szMsg
    end,
    varAward = "经验",
    varGuide = "前往新手村，寻找花灯",
    tbQA = {
      {
        "什么是花灯猜谜活动？",
        "在每周的固定的时间，在新手村会出现花灯，你找到这些花灯后，可以回答里面的灯谜，答对的会获得奖励",
      },
      { "要参加花灯猜谜需要满足什么条件？", "只要你的等级不低于30级，并且已经加入了门派，就可以参加了" },
      { "花灯猜谜活动什么时候开始？", UiManager.IVER_szGuessGameHelpMsg },
      { "花灯猜谜活动有哪些限制条件？", "每人每轮最多可以猜对6个灯谜\r每人每天最多可以猜对30个灯谜" },
    },
  },
  {

    szName = "下线休息",
    varExpStar = function()
      local nOnlineTime = GetTime() - UiManager.nEnterTime
      if nOnlineTime >= 3600 * 6 then
        return 10
      else
        return 1
      end
    end,
    varMoneyStar = function()
      local nOnlineTime = GetTime() - UiManager.nEnterTime
      if nOnlineTime >= 3600 * 6 then
        return 1
      else
        return 1
      end
    end,
    varSortStar = function()
      local nOnlineTime = GetTime() - UiManager.nEnterTime
      if nOnlineTime >= 3600 * 6 then
        return 10
      else
        return 1
      end
    end,
    varRemain = function()
      local nOnlineTime = GetTime() - UiManager.nEnterTime
      local nOfflineTime = Player.tbOffline:GetTodayRestOfflineTime() / 3600
      if nOnlineTime >= 3600 * 6 then
        return string.format("你已经在剑侠世界中连续征战了 <color=yellow>%.1f<color> 小时，为了你的健康，可以离线休息了\r你今天还有可以离线托管 <color=yellow>%.1f<color> 小时", nOnlineTime / 3600, nOfflineTime)
      else
        return string.format("你今天还可以离线托管 <color=yellow>%.1f<color> 小时（每天最多离线托管 <color=yellow>16<color> 小时）", nOfflineTime)
      end
    end,
    varShowType = 0,
    varPopMsg = function()
      local szMsg = "你已经在剑侠世界中连续征战多时，可以离线休息了！"
      return szMsg
    end,
    varAward = "健康！",
    varGuide = "打开系统界面，选择离开游戏\r下一次再上线时，你可以购买白驹丸获取离线托管经验",
    tbQA = {
      { "为什么要下线休息？", "如果你连续征战时间太久了，会影响你身体健康" },
      {
        "下线休息后我有损失吗？",
        "当你下线休息一段时间，再重新上线后，通过购买使用白驹丸，可以获得额外的经验",
      },
    },
  },
  {

    szName = "义军任务",
    varExpStar = function()
      local nNowDate = tonumber(GetLocalDate("%Y%m%d")) -- 获取日期：XXXX/XX/XX 格式
      local nOldDate = LinkTask:GetTask(LinkTask.TSK_DATE)
      local nQuestTime = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_NUM_PERDAY)

      if nNowDate ~= nOldDate then
        nQuestTime = 0
      end

      if nQuestTime < 10 and me.nLevel >= 20 then
        return 6
      elseif nQuestTime >= 10 then
        return 4
      else
        return 0
      end
    end,
    varMoneyStar = function()
      local nNowDate = tonumber(GetLocalDate("%Y%m%d")) -- 获取日期：XXXX/XX/XX 格式
      local nOldDate = LinkTask:GetTask(LinkTask.TSK_DATE)
      local nQuestTime = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_NUM_PERDAY)

      if nNowDate ~= nOldDate then
        nQuestTime = 0
      end
      if nQuestTime < 10 and me.nLevel >= 20 then
        return 9
      elseif nQuestTime >= 10 then
        return 5
      else
        return 0
      end
    end,
    varSortStar = function()
      local nNowDate = tonumber(GetLocalDate("%Y%m%d")) -- 获取日期：XXXX/XX/XX 格式
      local nOldDate = LinkTask:GetTask(LinkTask.TSK_DATE)
      local nQuestTime = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_NUM_PERDAY)

      if nNowDate ~= nOldDate then
        nQuestTime = 0
      end
      if nQuestTime < 10 and me.nLevel >= 20 then
        return 7
      elseif nQuestTime >= 10 then
        return 0
      else
        return 0
      end
    end,
    varRemain = function()
      local nNowDate = tonumber(GetLocalDate("%Y%m%d")) -- 获取日期：XXXX/XX/XX 格式
      local nOldDate = LinkTask:GetTask(LinkTask.TSK_DATE)
      local nQuestTime = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_NUM_PERDAY)

      if nNowDate ~= nOldDate then
        nQuestTime = 0
      end
      return string.format("每天连续完成前 <color=yellow>10<color> 次义军任务会获得丰厚奖励\r你今天完成了 <color=yellow>%d<color> 次义军任务", nQuestTime)
    end,
    varShowType = 0,
    varPopMsg = function()
      local szMsg = "义军任务，每天为国家出一份力"
      return szMsg
    end,
    varAward = "绑定的银两\r<tab=10>腰坠、玄晶、经验",
    varGuide = "在新手村 <link=npcpos:包万同,0,3573> 处可以领取义军任务",
    tbQA = {
      { "什么是义军任务？", "义军任务是新手村包万同处可以领取的任务，完成其给予的任务后，可以获得不错奖励" },
      {
        "领取义军任务有什么规则？",
        "你每天可以在任意时间领取义军任务，完成后均会获得奖励，但是只有连续完成当日的前10次任务，奖励最为丰厚",
      },
    },
  },
  {

    szName = "拜师学艺",
    varExpStar = 10,
    varMoneyStar = 6,
    varSortStar = function()
      local nStudent, nTeacher, nMiyou = me.GetRelationNum()
      local bLevelRequire = 0
      if me.nLevel >= 20 and me.nLevel <= 50 then
        bLevelRequire = 1
      end

      if nTeacher == 0 and bLevelRequire == 1 then
        return 8
      else
        return 0
      end
    end,

    varRemain = function()
      local nStudent, nTeacher, nMiyou = me.GetRelationNum()
      if nTeacher == 0 then
        return string.format("你现在还没有<color=yellow>师傅<color>带你哦\r拜一位好师父可以帮助你升级，给你提供各种帮助")
      else
        return string.format("你已经有师傅了")
      end
    end,
    varShowType = 1,
    varPopMsg = function()
      local szMsg = "你可以拜师学艺了！"
      return szMsg
    end,
    varAward = "经验",
    varGuide = "只能拜69级（包括69）以上的玩家为师",
    tbQA = {
      {
        "拜师有什么好处？",
        "有了一个师父，就有了一个答疑的导师，一个帮忙做任务的打手，一个被欺负后的靠山。师父有一个师徒传送符可以随时飞到弟子身边，所以，当弟子的千万不要客气，有什么需要帮忙的就向师父求教吧\r如果你的师父总是不帮助你，并不是一个合格的师父，那么弟子也可以不去叶芷琳处报道，和他断绝师徒关系。这样做弟子是不会有任何损失的",
      },
      {
        "如何拜师？",
        "只能拜<color=yellow>69级（包括69）<color>以上的玩家为师\r通过好友面板里的<color=yellow>师徒信息<color>或者键盘上的<color=yellow>“H”<color>键打开师徒面板勾选<color=yellow>“想要拜师”<color>可以方便地帮您寻找师父\r拜师的操作：徒弟在好友列表中右键点击师父名称，可以建立师徒关系",
      },
      { "五天报道机制", "徒弟拜师以后，如果连续5天没有叶芷琳处报道，师徒关系将解除，你们将不能再成为密友" },
    },
  },
  {

    szName = "收徒传道",
    varExpStar = 1,
    varMoneyStar = 8,
    varSortStar = function()
      local nStudent, nTeacher, nMiyou = me.GetRelationNum()
      local bLevelRequire = 0
      if me.nLevel >= 69 then
        bLevelRequire = 1
      end

      if nStudent == 0 and bLevelRequire == 1 then
        return 8
      else
        return 0
      end
    end,

    varRemain = function()
      local nStudent, nTeacher, nMiyou = me.GetRelationNum()
      if nStudent == 0 then
        return string.format("你现在还没有带徒弟哦\r小小付出，终生回报")
      else
        return string.format("你已经有徒弟了")
      end
    end,
    varShowType = 1,
    varPopMsg = function()
      local szMsg = "你可以招徒弟了！"
      return szMsg
    end,
    varAward = "经验",
    varGuide = "只能收等级20至50级的玩家为徒",
    tbQA = {
      {
        "收徒弟有什么好处？",
        string.format("徒弟成功出师，就可以成为您的密友\r密友每次在奇珍阁消费，您都能获得他的消费额<color=yellow>5％<color>的赠送绑定%s\r如果您有很多密友，什么都不做，数%s也能数到手抽筋", IVER_g_szCoinName, IVER_g_szCoinName),
      },
      { "收徒限制", "师父同时能收3个弟子\r师父每个月最多收3个弟子" },
      {
        "如何收徒弟？",
        "通过好友面板里的<color=yellow>师徒信息<color>或者键盘上的<color=yellow>“H”<color>键打开师徒面板，勾选<color=yellow>“想要收徒”<color>可以方便地帮您寻找徒弟\r拜师的操作：徒弟在好友列表中右键点击师父名称，可以建立师徒关系",
      },
      {
        "五天报道机制",
        " 收了徒弟以后，如果你的徒弟连续5天没有叶芷琳处报道，你们之间的师徒关系将解除你们将不能再成为密友\r请多通过<color=yellow>师徒面板<color>查看报道时间，督促徒弟去报道",
      },
    },
  },
  {

    szName = "密友系统",
    varExpStar = 1,
    varMoneyStar = 9,
    varSortStar = function()
      local nStudent, nTeacher, nMiyou = me.GetRelationNum()
      if nMiyou == 0 then
        return 6
      else
        return 0
      end
    end,

    varRemain = string.format("建立密友，天天有飞来横财\r<color=yellow>%s来得就这么简单<color>\r\r<tab=15>招收徒弟，介绍别人进入游戏，他们就会成为您的密友\r<tab=15>密友在奇珍阁的每次消费，您都能获得5％的分成！\r<tab=15>花2，3周教导一位徒弟，您将获得长达一年的密友消费奖励\r<tab=15>花几分钟帮助您的朋友进入剑侠世界，您将获得长达一年的密友消费奖励\r<tab=15>如果您的徒弟同时还是您介绍而来，您将获得高达10％的双倍密友消费奖励！！！", IVER_g_szCoinName),
    varShowType = 0,
    varPopMsg = function()
      local szMsg = ""
      return szMsg
    end,
    varAward = "密友系统，简单投入，千倍回报！",
    varGuide = "花2，3周教导一位徒弟，您将获得长达一年的密友消费奖励\r花几分钟帮助您的朋友进入剑侠世界，您将获得长达一年的密友消费奖励\r如果您的徒弟同时还是您介绍而来，您将获得高达10%的双倍密友消费奖励！！！",
    tbQA = {
      {
        "如何建立密友？",
        "建立密友有两种方式：\r1 介绍别人进入剑侠世界\r把剑侠世界介绍给你的朋友，然后在他11级以前一起组队到叶芷琳处确认你们的介绍关系即可\r介绍人必须比被介绍人级别至少高30级才能建立关系\r2 培养徒弟\r招收弟子，当弟子69级成功出师就可以成为你的密友",
      },
    },
  },
  {
    szName = "推荐入驻奖励",
    varExpStar = 0,
    varMoneyStar = 0,
    varSortStar = function()
      if SpecialEvent.RecommendServer:CheckRecommend() == 1 then
        return 0
      else
        return 0
      end
    end,

    varRemain = function()
      local szDate = os.date("%Y-%m-%d %H:%M:%S", (me.GetTask(SpecialEvent.RecommendServer.TASK_GOURP_ID, SpecialEvent.RecommendServer.TASK_REGISTER_ID) + SpecialEvent.RecommendServer.TIME_LAST * 86400))
      return string.format("  欢迎您入驻本推荐服务器，在您达到对应等级时，可以在各新手村活动推广员处领取以上奖励。\n\n<color=red>注意<color>：您只有在<color=yellow>%s天<color>内，即<color=yellow>%s<color>前达到上述等级后才可以获得相应奖励；如果您目前等级已经超过上述等级，可以立即领取。", SpecialEvent.RecommendServer.TIME_LAST, szDate)
    end,
    varShowType = 0,
    varPopMsg = "欢迎您入驻本推荐服务器\n丰厚奖励等着您！",
    varAward = function()
      if tonumber(os.date("%Y%m%d", GetTime())) < 20090625 then
        return string.format("\n  30级：1000绑定%s\n  40级：12格背包\n  50级：3000绑定%s\n  60级：6000绑定%s", IVER_g_szCoinName, IVER_g_szCoinName, IVER_g_szCoinName)
      else
        return string.format("\n  30级：100000绑定银两\n  40级：1000绑定%s\n  50级：3000绑定%s\n  60级：5000绑定%s", IVER_g_szCoinName, IVER_g_szCoinName, IVER_g_szCoinName)
      end
    end,
    varGuide = "欢迎您入驻本推荐服务器\n丰厚奖励等着您！",
    tbQA = {},
  },
  {

    szName = "官府通缉任务",
    varExpStar = 4,
    varMoneyStar = 9,
    varSortStar = function()
      local nTaskNum = me.GetTask(2040, 2)
      if nTaskNum > 0 and me.GetTask(1022, 107) == 1 then
        return 4
      else
        return 0
      end
    end,

    varRemain = function()
      local nTaskNum = me.GetTask(2040, 2)
      return string.format("你今天还可以接 <color=yellow>%d<color> 次官府通缉任务", nTaskNum)
    end,
    varShowType = 0,
    varPopMsg = function()
      local szMsg = ""
      return szMsg
    end,
    varAward = "武林秘籍、洗髓经、装备",
    varGuide = function()
      local nTaskNum = me.GetTask(2040, 2)
      return string.format("你今天还可以接 <color=yellow>%d<color> 次官府通缉任务", nTaskNum)
    end,
    tbQA = {
      {
        "什么是官府通缉任务？",
        "官府通缉任务是七大城市中刑部捕头处可以领取的任务，完成其给予的任务后，可以获得不错奖励",
      },
      {
        "领取官府通缉任务需要满足什么条件？",
        "只要你达到50级，完成了50级的主线任务，同时江湖威望达到20，就可以在刑部捕头处领取官府通缉任务",
      },
      { "领取缉拿蚀月教徒需要满足什么条件？", "需要等级达到100级，其他同官府通缉任务限制" },
      {
        "每天可以领取多少个官府通缉任务？",
        "你达到50级后，每天会获得6次接任务的限额，接任务限额可以累积，最多可以累积到36次",
      },
      {
        "如何取消官府通缉任务？",
        "接任务后，你可以在刑部捕头处选择取消官府通缉任务，但取消会消耗你1次接任务的限额",
      },
      {
        "什么是武林秘籍和洗髓经？",
        "研习武林秘籍可以增加你的技能点，研习洗髓经可以增加你的潜能点。\r武林秘籍和洗髓经可以在刑部捕头处用一定数量的名捕令兑换",
      },
      { "如何获得名捕令？", "完成任务后，可以在刑部捕头处领取名捕令的奖励" },
      { "如何获得封印碎片？", "完成缉拿蚀月教徒后，可以在刑部捕头处领取随机五行属性封印碎片" },
      {
        "封印碎片有何作用？",
        "凑齐一套五行属性碎片后消耗1200精活可合成一枚昏暗封印，解开封印召唤出强力BOSS，部分BOSS可说服为同伴",
      },
    },
  },
  {

    szName = "商会任务",
    varExpStar = 4,
    varMoneyStar = 10,
    varSortStar = function()
      if me.GetTask(1022, 107) == 1 then
        return 3
      else
        return 0
      end
    end,

    varRemain = "商会任务，丰厚奖励",
    varShowType = 0,
    varPopMsg = function()
      local szMsg = ""
      return szMsg
    end,
    varAward = "不绑定的银两、绑定银两、玄晶",
    varGuide = "到<color=yellow>商会老板<color>处领取商会任务",
    tbQA = {
      {
        "什么是商会任务？",
        "商会任务是七大城市商会老板处可以领取的任务，完成其给予的任务后，可以获得大量的银两奖励；",
      },
      {
        "领取商会任务需要满足什么条件？",
        "需要你达到60级，完成了50级的主线任务，同时江湖威望达到50，就可以在商会老板处领取到商会任务",
      },
      { "每周可以领取多少个商会任务？", "每周只能最多领取一次" },
    },
  },
  {

    szName = "军营任务",
    varExpStar = function()
      local nGutTaskTimes = Task.tbArmyCampInstancingManager:GetGutTaskTimesThisWeek(1, me.nId)
      local nDailyTask = Task.tbArmyCampInstancingManager:GetDailyTaskTimesThisWeek(1, me.nId)
      if me.nLevel >= 90 then
        if nGutTaskTimes < 4 then
          return 9
        elseif nDailyTask < 28 then
          return 8
        else
          return 0
        end
      else
        return 0
      end
    end,
    varMoneyStar = function()
      local nGutTaskTimes = Task.tbArmyCampInstancingManager:GetGutTaskTimesThisWeek(1, me.nId)
      local nDailyTask = Task.tbArmyCampInstancingManager:GetDailyTaskTimesThisWeek(1, me.nId)
      if me.nLevel >= 90 then
        if nGutTaskTimes < 4 then
          return 9
        elseif nDailyTask < 28 then
          return 8
        else
          return 0
        end
      else
        return 0
      end
    end,
    varSortStar = function()
      local nGutTaskTimes = Task.tbArmyCampInstancingManager:GetGutTaskTimesThisWeek(1, me.nId)
      local nDailyTask = Task.tbArmyCampInstancingManager:GetDailyTaskTimesThisWeek(1, me.nId)
      if me.nLevel >= 90 and nGutTaskTimes < 4 then
        return 10
      elseif me.nLevel >= 90 and nDailyTask < 28 then
        return 9
      else
        return 0
      end
    end,

    varRemain = function()
      local nWaitTime = Task.tbArmyCampInstancingManager:GetRegisterWaitTime(1)
      local nGutTaskTimes = Task.tbArmyCampInstancingManager:GetGutTaskTimesThisWeek(1, me.nId)
      local nDailyTask = Task.tbArmyCampInstancingManager:GetDailyTaskTimesThisWeek(1, me.nId)
      local nBingShuTimes = Task.tbArmyCampInstancingManager:GetBingShuReadTimesThisDay(me.nId)
      local nJiGuanShuTimes = Task.tbArmyCampInstancingManager:JiGuanShuReadedTimesThisDay(me.nId)

      local tbYesOrNo = {
        [0] = "否",
        [1] = "是",
      }

      local sWaitTime = string.format("距离下次副本开启的时间还有：<color=yellow>%d<color> 分钟", nWaitTime)
      local sGuiTaskTimes = string.format("本周接取的副本剧情任务次数为： <color=yellow>%d/4<color>", nGutTaskTimes)
      local sDailyTask = string.format("本周接取的副本日常任务次数为： <color=yellow>%d/28<color>", nDailyTask)
      local sBingShuTimes = string.format("今日是否完成孙子兵法任务： <color=yellow>%s<color>", tbYesOrNo[nBingShuTimes] or "未知")
      local sJiGuanShuTimes = string.format("今日是否完成墨家机关术任务： <color=yellow>%s<color>", tbYesOrNo[nJiGuanShuTimes] or "未知")

      return string.format("  %s\r  %s\r  %s\r  %s\r  %s", sWaitTime, sGuiTaskTimes, sDailyTask, sBingShuTimes, sJiGuanShuTimes)
    end,
    varShowType = 0,
    varPopMsg = function()
      local szMsg = ""
      return szMsg
    end,
    varAward = "经验、装备、银两、精力、活力",
    varGuide = "",
    tbQA = {
      {
        "怎样进入军营地图？",
        "    通过无限传送符上的军营传送到三大城市中的军营报名官附近。\r    自行前往临安、襄阳、凤翔三大城市军营。\r    去杂货铺找不动先生购买一块军营令牌，右键点击使用可以传入军营地图。\r    在奇珍阁的道具中购买一块无限军营令牌，就可以在一个月内不限次的传入军营地图了。",
      },
      {
        "怎样获得军营声望？",
        "    您每周都可以在军营中找大将军卢必克接到副本剧情任务，然后与各位江湖侠客共同在副本中完成任务；\r    或者找到军需官徐祥鹅，从他那里领取阅读兵书的任务，一个人阅读完成。\r    两种方式都可以获得军营声望以及其他丰厚奖励。",
      },
      {
        "怎样修炼机关箱？",
        "    您每周都可以在军营中找大将军卢必克接到副本日常任务，然后与各位江湖侠客共同在副本中完成任务；\r    或者找到机关大师天机子，从他那里领取阅读机关书的任务，一个人阅读完成。\r    两种方式都可以获得修炼机关箱所需要的机关经验和机关耐久度。",
      },
      {
        "怎样进入副本？",
        "    您可以在游戏世界规定的时间内，找到副本传送官，通过他们进入副本。现有的传送官是郑八姑。她就在临安、襄阳、凤翔三大城市军营内。",
      },
      {
        "副本的开启、关闭时间？",
        "    军营副本从每日的0点到24点，逢整点开放，如早晨8点，9点。\r    报名时间为整点之后的35分钟，如早晨8点开放的副本报名，截止时间到8：10。\r    每个副本最长存在90分钟，一旦副本存在时间达到，副本将被自动关闭。\r    在每次副本开启过程中，您最多只能进入1个副本。",
      },
    },
  },
  {

    szName = "祈福",
    varExpStar = function()
      local nResult = 2
      return nResult
    end,
    varMoneyStar = function()
      return 2
    end,
    varSortStar = function()
      if me.nLevel < 50 then
        return 0
      end

      local nResult = 0
      local nPrayCount = Task.tbPlayerPray:GetPrayCount(me)
      local nInDirFlag = me.GetTask(Task.tbPlayerPray.TSKGROUP, Task.tbPlayerPray.TSK_INDIRAWARDFLAG)

      if 0 < nPrayCount then
        nResult = 10
      end

      if 1 == nInDirFlag then
        nResult = 10
      end
      return nResult
    end,

    varRemain = function()
      local szMsg = "无祈福机会和奖励"
      local nInDirFlag = me.GetTask(Task.tbPlayerPray.TSKGROUP, Task.tbPlayerPray.TSK_INDIRAWARDFLAG)
      local nPrayTimes = Task.tbPlayerPray:GetPrayCount(me)
      if 1 == nInDirFlag then
        szMsg = "你还有祈福奖励未领，<a=openpray:>进入祈福<a>"
        return szMsg
      else
        if 0 < nPrayTimes then
          return string.format("你当前还有<color=yellow> %d <color>次祈福机会，<a=openpray:>进入祈福<a>", nPrayTimes)
        end
      end
      return szMsg
    end,
    varShowType = 1,
    varPopMsg = function()
      local szMsg = "你今天可以<bclr=green>祈福<bclr>了"
      return szMsg
    end,
    varAward = "运气\r\r  <color=white>祈福声望达到一定条件后，可以到<color=yellow>汴京府的逍遥谷客商<color>处购买祈福装备道具\r        当祈福声望到达<color=yellow>尊敬[3级]<color>后，可以购买的装备示例:    <item=18,1,216,1>\r        当祈福声望到达<color=yellow>显赫[4级]<color>后，可以购买的装备示例:    <item=2,6,252,10>\r        当祈福声望到达<color=yellow>传说[5级]<color>后，可以购买的装备示例:    <item=2,6,257,10><color>",
    varGuide = "我要开始今日的祈福",
    tbQA = {
      { "什么是祈福？", "祈福就是算算你今日的运程" },
      { "祈福会有什么结果？", "看你今天的运气，会得到神秘的祝福！" },
      { "祈福声望有什么用？", "当满足一定声望条件后，就可以购买声望道具和装备" },
      { "祈福声望道具和装备在哪里购买？", "在汴京府的逍遥谷客商处可以购买" },
      {
        "可以祈福多少次？",
        "每天你会自动获得1次祈福机会。每天的00：00更新。当日的祈福机会不会累计到第2天。如果使用祈福令牌可以获得额外的祈福机会",
      },
    },
  },

  {
    szName = "逍遥谷",
    varExpStar = function()
      local nResult = 5
      return nResult
    end,
    varMoneyStar = function()
      return 5
    end,
    varSortStar = function()
      local nTimes = XoyoGame:GetPlayerTimes(me)
      if me.nLevel < 50 then
        return 0
      elseif nTimes <= 0 then
        return 0
      else
        return 10
      end
    end,

    varRemain = function()
      local nCurTime = 0
      local nRestTime = 0
      local nCurTime = tonumber(os.date("%H%M", GetTime()))
      local nRestTime1 = 0
      local szXXX = ""
      local nTimes = XoyoGame:GetPlayerTimes(me)
      if EventManager.IVER_nXoyoGameDateType == 1 then
        if nCurTime >= 730 and nCurTime < 2230 then
          nRestTime = 30 - (nCurTime % 100) % 30
        end

        if nCurTime >= 2330 and nCurTime < 2400 then
          nRestTime = 30 - (nCurTime % 100) % 30
        end

        if nCurTime >= 0 and nCurTime < 130 then
          nRestTime = 30 - (nCurTime % 100) % 30
        end

        --20091117逍遥谷时间调整（kenmasterwu）
        if nCurTime >= 730 and nCurTime < 2230 then
          szXXX = string.format("距离<color=yellow>关卡报名开始<color>时间还有 <color=yellow>%d<color> 分钟。", nRestTime)
        end
        if nCurTime >= 0 and nCurTime < 130 then
          szXXX = string.format("距离<color=yellow>关卡报名开始<color>时间还有 <color=yellow>%d<color> 分钟。", nRestTime)
        end

        if nCurTime >= 2330 and nCurTime < 2400 then
          szXXX = string.format("距离<color=yellow>关卡报名开始<color>时间还有 <color=yellow>%d<color> 分钟。", nRestTime)
        end

        if nCurTime >= 800 and nCurTime < 2330 then
          szXXX = szXXX .. string.format("\r距离下一次<color=yellow>关卡开始<color>时间还有 <color=yellow>%d<color> 分钟。\r你当前还有<color=yellow> %d/14 <color>次闯谷机会。", nRestTime, nTimes)
        end

        if nCurTime >= 0 and nCurTime < 230 then
          szXXX = szXXX .. string.format("\r距离下一次<color=yellow>关卡开始<color>时间还有 <color=yellow>%d<color> 分钟。\r你当前还有<color=yellow> %d/14 <color>次闯谷机会。", nRestTime, nTimes)
        end
      else
        if nCurTime >= 1130 and nCurTime < 2300 then
          nRestTime = 30 - (nCurTime % 100) % 30
        end
        if nCurTime >= 1130 and nCurTime < 2230 then
          szXXX = string.format("距离<color=yellow>关卡报名开始<color>时间还有 <color=yellow>%d<color> 分钟。", nRestTime)
        end
        if nCurTime >= 1200 and nCurTime < 2300 then
          szXXX = szXXX .. string.format("\r距离下一次<color=yellow>关卡开始<color>时间还有 <color=yellow>%d<color> 分钟。\r你当前还有<color=yellow> %d/14 <color>次闯谷机会。", nRestTime, nTimes)
        end
      end
      return szXXX
    end,
    varShowType = 0,
    varPopMsg = "",
    varAward = "<color=white>在闯关过程中可以获得<color=yellow>玄晶，经验，逍遥谷套装<color>。\r    每个月可以找逍<color=yellow>遥谷报名点的晓菲<color>领取一本逍遥录，收集逍遥录内需要的<color=yellow>卡片<color>，然后在本月结束前将逍遥录交还给晓菲，如果你收集的卡片数量达到了一定要求，下个月就可获得丰厚奖励。具体奖励如下：\r    1-10名                       1个绑定的10玄+2个9玄\r    11-100名                     3个绑定的9级玄晶\r    101-500名                    1个绑定的9玄+2个8玄\r    501-1500名                   3个绑定的8级玄晶\r    1501-3000名或收集至少24张卡  1个绑定的8玄+2个7玄<color=yellow>\r    部分逍遥谷套装属性展示<color>如下:\r    当逍遥谷声望达到<color=yellow>亲密[2级]<color>后，可炼化出的护腕示例:    <item=4,10,1,10>\r    当逍遥谷声望达到<color=yellow>亲密[2级]<color>后，可炼化出的手镯示例:    <item=4,10,10,10>\r    当逍遥谷声望达到<color=yellow>敬重[3级]<color>后，可炼化出的腰坠示例:    <item=4,11,1,10>\r    当逍遥谷声望达到<color=yellow>钦佩[4级]<color>后，可炼化出的鞋子示例:    <item=4,7,1,10>",
    varGuide = "",
    tbQA = {
      { "如何进入逍遥谷？", "没有人知道如何去逍遥谷，只有通过汴京的逍遥谷引路人--赵侃的指引，方可进入。" },
      { "进入逍遥谷的条件？", "玩家等级达到30级且已加入门派。" },
      { "逍遥谷报名时间？", UiManager.IVER_szXoyoGameHelpMsg },
    },
  },
}

-- 日常信息
uiHelpSprite.tbDailyInfo = {
  {
    szName = "福利事项<goto=150><color=green>点击查看<color>",
    varShowType = 1,
    varContext = function()
      local szListText = ""

      szListText = szListText .. "<color=red>今日福利：<color>\r"

      local nFuCount, nFuLimit = uiHelpSprite:GetFuDaiCountAndLimit() -- 福袋使用上限
      szListText = szListText .. "<goto=20>今日已开福袋次数：<goto=300>" .. string.format("<color=yellow>%d/%d<color>", nFuCount, nFuLimit) .. "<linegap=10>\n"

      if me.nLevel >= 60 then
        local nNowDay = tonumber(GetLocalDate("%Y%m%d"))

        local nJingCount = me.GetTask(2024, 10)
        local nDay = me.GetTask(2024, 9)
        if nNowDay > nDay then
          nJingCount = 0
        end
        szListText = szListText .. string.format("<goto=20>今日使用优惠价格购买小精气散： <goto=300><color=yellow>%d/5<color>", nJingCount) .. "<linegap=10>\n"
        nDay = me.GetTask(2024, 11)
        local nHuoCount = me.GetTask(2024, 12)
        if nNowDay > nDay then
          nHuoCount = 0
        end
        szListText = szListText .. string.format("<goto=20>今日使用优惠价格购买小活气散： <goto=300><color=yellow>%d/5<color>", nHuoCount) .. "<linegap=10>\n"
      end

      if me.nLevel >= 80 then
        local nTime = tonumber(os.date("%Y%m%d", GetTime()))
        local nLastTime = me.GetTask(2050, 53)
        if nTime == nLastTime then
          szListText = szListText .. string.format("<goto=20>今日是否领过逍遥谷药品： <goto=300><color=yellow>是<color>") .. "<linegap=10>\n"
        else
          szListText = szListText .. string.format("<goto=20>今日是否领过逍遥谷药品： <goto=300><color=yellow>否<color>") .. "<linegap=10>\n"
        end
      end

      local nLastXchgWeek = me.GetTask(2080, 1)
      local nThisWeek = Lib:GetLocalWeek(GetTime()) + 1

      szListText = szListText .. "<color=red>本周福利：<color>\r"
      if nLastXchgWeek == nThisWeek then
        szListText = szListText .. string.format("<goto=20>本周是否绑定银两兑换过银两：<goto=300><color=yellow>是<color>") .. "<linegap=10>\n"
      else
        szListText = szListText .. string.format("<goto=20>本周是否绑定银两兑换过银两：<goto=300><color=yellow>否<color>") .. "<linegap=10>\n"
      end

      local nTime = GetTime()
      local nWeek = Lib:GetLocalWeek(nTime)
      local nLastTime = me.GetTask(2027, 68)
      local nLastWeek = Lib:GetLocalWeek(nLastTime)
      if nWeek == nLastWeek then
        szListText = szListText .. string.format("<goto=20>本周是否从礼官处领取过工资：<goto=300><color=yellow>是<color>") .. "<linegap=10>\n"
      else
        szListText = szListText .. string.format("<goto=20>本周是否从礼官处领取过工资：<goto=300><color=yellow>否<color>") .. "<linegap=10>\n"
      end

      if me.nLevel >= 60 then
        local nWeiwang = me.GetTask(2027, 55)
        local nCurWeek = tonumber(GetLocalDate("%Y%W"))
        if nCurWeek > me.GetTask(2027, 54) then
          nWeiwang = 0
        end

        szListText = szListText .. string.format("<goto=20>本周从礼官处领取的江湖威望：<goto=300><color=yellow>%d<color>", nWeiwang) .. "<linegap=10>\n"

        local nJunXuCount = Battle:GetRemainJunXu()
        szListText = szListText .. string.format("<goto=20>本周免费领取的宋金军需剩余：<goto=300><color=yellow>%d箱<color>", nJunXuCount) .. "<linegap=10>\n"
      end

      if me.nLevel >= 50 then
        local nAddWeek = me.GetTask(2132, 8)
        local nCurWeek = tonumber(GetLocalDate("%Y%W"))
        if nAddWeek == nCurWeek then
          szListText = szListText .. string.format("<goto=20>本周是否从义军军需官处领取副本令牌：<goto=300><color=yellow>是<color>") .. "<linegap=10>\n"
        else
          szListText = szListText .. string.format("<goto=20>本周是否从义军军需官处领取副本令牌：<goto=300><color=yellow>否<color>") .. "<linegap=10>\n"
        end
      end

      szListText = szListText .. "\n"
      return szListText
    end,
  },

  {
    szName = "今日事项<goto=150><color=green>点击查看<color>",
    varShowType = 1,
    varContext = function()
      local szListText = ""
      szListText = szListText .. "<color=red>今日杂项：<color>\r"
      if me.nLevel >= 50 then
        local nPrayTimes = Task.tbPlayerPray:GetPrayCount(me)
        szListText = szListText .. "<goto=20>今日还可祈福次数：<goto=300>" .. string.format("<color=yellow>%d<color>", nPrayTimes) .. "<linegap=10>\n"
      end

      if me.nLevel >= 20 then
        local nBaoCount = uiHelpSprite:GetBaoCount()
        szListText = szListText .. "<goto=20>今日已完成义军任务次数：<goto=300>" .. string.format("<color=yellow>%d/10<color>", nBaoCount) .. "<linegap=10>\n"
      end

      if me.nLevel >= 50 then
        local nBaiCount = uiHelpSprite:GetBaihutangCount()
        szListText = szListText .. "<goto=20>今日已挑战白虎堂次数：<goto=300>" .. string.format("<color=yellow>%d/3<color>", nBaiCount) .. "<linegap=10>\n"
      end

      if me.nLevel >= 50 then
        local nTaskNum = me.GetTask(2040, 2)
        szListText = szListText .. "<goto=20>今日还可领取官府通缉任务次数：<goto=300>" .. string.format("<color=yellow>%d<color>", nTaskNum) .. "<linegap=10>\n"
      end

      if me.nLevel >= 80 then
        local nTimes = XoyoGame:GetPlayerTimes(me)
        szListText = szListText .. "<goto=20>今日还可参加逍遥谷次数：<goto=300>" .. string.format("<color=yellow>%d<color>", nTimes) .. "<linegap=10>\n"
      end

      if me.nLevel >= 50 then
        local nTimes = 0
        local nCurDate = tonumber(GetLocalDate("%Y%m%d"))
        local nTskDate = me.GetTask(2136, 2)
        if nTskDate == nCurDate then
          nTimes = me.GetTask(2136, 1)
        end
        nTimes = 10 - nTimes
        szListText = szListText .. "<goto=20>今日还可参加藏宝图副本次数：<goto=300>" .. string.format("<color=yellow>%d<color>", nTimes) .. "<linegap=10>\n"
      end

      szListText = szListText .. "<color=red>今日托管：<color>\r"
      if me.nLevel >= 20 then
        local nOfflineTime = Player.tbOffline:GetTodayRestOfflineTime() / 3600
        szListText = szListText .. "<goto=20>今日剩余离线时间：<goto=130>" .. string.format("<color=yellow>%.1f小时<color>", nOfflineTime) .. "<linegap=10>\n"

        for key, tbBaiju in ipairs(Player.tbOffline.BAIJU_DEFINE) do
          if tbBaiju.nShowFlag == 1 then
            local nRestTime = me.GetTask(5, tbBaiju.nTaskId)
            szListText = szListText .. "<goto=20><color=yellow>" .. tbBaiju.szName .. "<color>剩余托管<goto=130>" .. Player.tbOffline:GetDTimeDesc(nRestTime) .. "<linegap=10>\n"
          end
        end
      end

      if me.nLevel >= 80 then
        local nWaitTime = Task.tbArmyCampInstancingManager:GetRegisterWaitTime(1)
        local nBingShuTimes = Task.tbArmyCampInstancingManager:GetBingShuReadTimesThisDay(me.nId)
        local nJiGuanShuTimes = Task.tbArmyCampInstancingManager:JiGuanShuReadedTimesThisDay(me.nId)
        local nDayEnterFB = Task.tbArmyCampInstancingManager:EnterInstancingThisDay(1, me.nId)

        local tbYesOrNo = {
          [0] = "否",
          [1] = "是",
        }
        szListText = szListText .. "<color=red>今日军营：<color>\r"
        szListText = szListText .. string.format("<goto=20>今日还可进入副本的次数： <goto=300><color=yellow>%d<color>", nDayEnterFB) .. "<linegap=10>\n"
        szListText = szListText .. string.format("<goto=20>距离下次副本开启的时间还有：<goto=300><color=yellow>%d<color> 分钟", nWaitTime) .. "<linegap=10>\n"
        if me.nLevel < 110 then
          szListText = szListText .. string.format("<goto=20>今日是否完成孙子兵法任务： <goto=300><color=yellow>%s<color>", tbYesOrNo[nBingShuTimes] or "未知") .. "<linegap=10>\n"
          szListText = szListText .. string.format("<goto=20>今日是否完成墨家机关术任务： <goto=300><color=yellow>%s<color>", tbYesOrNo[nJiGuanShuTimes] or "未知") .. "<linegap=10>\n"
        elseif me.nLevel < 130 then
          szListText = szListText .. string.format("<goto=20>今日是否完成武穆遗书任务： <goto=300><color=yellow>%s<color>", tbYesOrNo[nBingShuTimes] or "未知") .. "<linegap=10>\n"
          szListText = szListText .. string.format("<goto=20>今日是否完成鬼谷道术任务： <goto=300><color=yellow>%s<color>", tbYesOrNo[nJiGuanShuTimes] or "未知") .. "<linegap=10>\n"
        else
          szListText = szListText .. string.format("<goto=20>今日是否完成兵法三十六计任务： <goto=300><color=yellow>%s<color>", tbYesOrNo[nBingShuTimes] or "未知") .. "<linegap=10>\n"
          szListText = szListText .. string.format("<goto=20>今日是否完成缺一门任务： <goto=300><color=yellow>%s<color>", tbYesOrNo[nJiGuanShuTimes] or "未知") .. "<linegap=10>\n"
        end
      end

      szListText = szListText .. "\n"
      return szListText
    end,
  },
  {
    szName = "本周事项<goto=150><color=green>点击查看<color>",
    varShowType = 1,
    varContext = function()
      local szListText = ""
      szListText = szListText .. "<color=red>本周副本：<color>\r"
      local tbYesOrNo = {
        [0] = "否",
        [1] = "是",
      }

      local nOpenTreaBoxTimes = 30 - me.GetTask(2015, 40)
      szListText = szListText .. "<goto=20>本周还可开藏宝图箱子：<goto=300>" .. string.format("<color=yellow>%d<color>", nOpenTreaBoxTimes) .. "<linegap=10>\n"

      szListText = szListText .. "<color=red>本周军营：<color>\r"
      if me.nLevel >= 80 then
        local nGutTaskTimes = Task.tbArmyCampInstancingManager:GetGutTaskTimesThisWeek(1, me.nId)
        szListText = szListText .. string.format("<goto=20>本周接取的副本剧情任务次数为：<goto=300><color=yellow>%d/4<color>", nGutTaskTimes) .. "<linegap=10>\n"
      end

      if me.nLevel >= 80 then
        local nDailyTask = Task.tbArmyCampInstancingManager:GetDailyTaskTimesThisWeek(1, me.nId)
        szListText = szListText .. string.format("<goto=20>本周接取的副本日常任务次数为： <goto=300><color=yellow>%d/22<color>", nDailyTask) .. "<linegap=10>\n"
      end
      if me.nLevel >= 80 then
        local nWujin = me.GetTask(1022, 187)
        local szDesc = "是"
        if nWujin ~= 0 then
          szDesc = "否"
        end
        szListText = szListText .. string.format("<goto=20>本周是否完成无尽的征程任务：<goto=300><color=yellow>%s<color>", szDesc) .. "<linegap=10>\n"
      end

      local nTradeMoney = me.GetTask(2022, 3)
      local nPlayerTaxJour = me.GetTask(2022, 4)
      local nCurTaxJour = KGblTask.SCGetDbTaskInt(DBTASK_TRADE_TAX_JOUR_NUM)
      if nCurTaxJour ~= nPlayerTaxJour then
        nTradeMoney = 0
      end

      szListText = szListText .. "<color=red>本周杂项：<color>\r"
      szListText = szListText .. string.format("<goto=20>本周累计交易额为：<goto=300><color=yellow>%d两<color>", nTradeMoney) .. "<linegap=10>\n"

      if me.nLevel >= 60 then
        local nShanghui = me.GetTask(2036, 1)
        szListText = szListText .. string.format("<goto=20>本周是否完成商会任务：<goto=300><color=yellow>%s<color>", tbYesOrNo[nShanghui]) .. "<linegap=10>\n"
      end

      szListText = szListText .. "\n"
      return szListText
    end,
  },
  {
    szName = "角色信息<goto=150><color=green>点击查看<color>",
    varShowType = 1,
    varContext = function()
      local szListText = ""

      local nSmallXisui = me.GetTask(2040, 6)
      local nMidXisui = me.GetTask(2040, 9)
      local nSmallWulin = me.GetTask(2040, 5)
      local nMidWulin = me.GetTask(2040, 8)
      local nBigWulin = me.GetTask(2040, 10)
      local nBigXisui = me.GetTask(2040, 11)
      local nBig2Xisui = me.GetTask(2040, 20)
      local nBig2Wulin = me.GetTask(2040, 21)
      szListText = szListText .. string.format("<goto=20>你研习了初级洗髓经： <goto=300><color=yellow>%d/5<color>", nSmallXisui) .. "<linegap=10>\n"
      szListText = szListText .. string.format("<goto=20>你研习了中级洗髓经： <goto=300><color=yellow>%d/5<color>", nMidXisui) .. "<linegap=10>\n"
      szListText = szListText .. string.format("<goto=20>你研习了初级武林秘籍： <goto=300><color=yellow>%d/5<color>", nSmallWulin) .. "<linegap=10>\n"
      szListText = szListText .. string.format("<goto=20>你研习了中级武林秘籍： <goto=300><color=yellow>%d/5<color>", nMidWulin) .. "<linegap=10>\n"
      szListText = szListText .. string.format("<goto=20>你食用了八宝粽： <goto=300><color=yellow>%d/2<color>", nBigXisui) .. "<linegap=10>\n"
      szListText = szListText .. string.format("<goto=20>你食用了什锦百果粽： <goto=300><color=yellow>%d/2<color>", nBigWulin) .. "<linegap=10>\n"
      szListText = szListText .. string.format("<goto=20>你食用了彩云追月： <goto=300><color=yellow>%d/2<color>", nBig2Xisui) .. "<linegap=10>\n"
      szListText = szListText .. string.format("<goto=20>你食用了沧海月明： <goto=300><color=yellow>%d/2<color>", nBig2Wulin) .. "<linegap=10>\n"

      szListText = szListText .. "\n"
      return szListText
    end,
  },
  {
    szName = "联赛信息<goto=150><color=green>点击查看<color>",
    varShowType = function()
      local nShow = 0
      if KGblTask.SCGetDbTaskInt(DBTASD_WIIS_SESSION) > 0 and me.nLevel >= 100 then
        nShow = 1
      end
      return nShow
    end,
    varContext = function()
      local szListText = ""
      local nSession = me.GetTask(Wlls.TASKID_GROUP, Wlls.TASKID_HELP_SESSION)
      local nTotle = me.GetTask(Wlls.TASKID_GROUP, Wlls.TASKID_HELP_TOTLE)
      local nWin = me.GetTask(Wlls.TASKID_GROUP, Wlls.TASKID_HELP_WIN)
      local nTie = me.GetTask(Wlls.TASKID_GROUP, Wlls.TASKID_HELP_TIE)
      local szSession = "<goto=300>未参赛"
      if nSession > 0 and Wlls.SEASON_TB[nSession] then
        szSession = string.format("第%s届%s", Lib:Transfer4LenDigit2CnNum(nSession), Wlls.SEASON_TB[nSession][4])
      end
      szListText = szListText .. string.format("<goto=20>你最近参加的武林联赛：<goto=155><color=yellow>%s<color><linegap=10>\n", szSession)

      szListText = szListText .. string.format("<goto=20>你的总共参赛场次：<goto=300><color=yellow>%s/36<color><linegap=10>\n", nTotle)

      szListText = szListText .. string.format("<goto=20>你的胜场数：<goto=300><color=yellow>%s<color><linegap=10>\n", nWin)

      szListText = szListText .. string.format("<goto=20>你的平场数：<goto=300><color=yellow>%s<color><linegap=10>\n", nTie)

      szListText = szListText .. string.format("<goto=20>你的负场数：<goto=300><color=yellow>%s<color><linegap=10>\n", (nTotle - nWin - nTie))

      szListText = szListText .. "\n"
      return szListText
    end,
  },
  {
    szName = "家族竞技活动信息<goto=150><color=green>点击查看<color>",
    varShowType = function()
      local nShow = 0
      if KGblTask.SCGetDbTaskInt(DBTASD_EVENT_SESSION) > 0 and me.nLevel > 60 then
        nShow = 1
      end

      return nShow
    end,
    varContext = function()
      local szListText = ""
      local nSession = KGblTask.SCGetDbTaskInt(DBTASD_EVENT_SESSION)
      local szSession = "<goto=300>无家族竞技活动"
      if nSession > 0 and EPlatForm.SEASON_TB[nSession] then
        szSession = string.format("第%s届%s", Lib:Transfer4LenDigit2CnNum(nSession), EPlatForm.SEASON_TB[nSession][3])
      end
      szListText = szListText .. string.format("<goto=20>近期家族竞技活动：<goto=155><color=yellow>%s<color><linegap=10>\n", szSession)

      szListText = szListText .. "\n"
      return szListText
    end,
  },
}

--== 窗体逻辑 ==--
uiHelpSprite.tbQaFold = {} -- 问题折叠标记

local function fnStrValue(szVal)
  local varType = loadstring("return " .. szVal)()
  if type(varType) == "function" then
    return varType()
  else
    return varType
  end
end

--写log
function uiHelpSprite:WriteStatLog()
  --Log:Ui_SendLog("F12帮助系统界面", 1);
  Log:Ui_SendLog("点击帮助锦囊首页", 1)
  me.CallServerScript({ "HelpManCmd", me.szName })
end

-- 加载开发计划txt
function uiHelpSprite:LoadPlanData()
  self.tbPlanFileData = {}
  local tbData = Ui.tbLogic.tbHelp:LoadHelpTabFile("\\setting\\task\\help\\plan.txt")
  if tbData then
    self.tbPlanFileData = tbData
  end
end

-- 加载最新活动txt
function uiHelpSprite:LoadNewActionData()
  self.tbNewsActFileData = {}
  local tbData = Ui.tbLogic.tbHelp:LoadHelpTabFile("\\setting\\task\\help\\newaction.txt")
  if tbData then
    self.tbNewsActFileData = tbData
  end
end

-- 加载详细帮助txt
function uiHelpSprite:LoadHelpData()
  self.tbHelpFileData = {}
  self.tbHelpContent = {}
  self.tbHelpFoldState = {}
  local tbData = Ui.tbLogic.tbHelp:LoadHelpTabFile("\\setting\\task\\help\\help.txt")
  if tbData then
    local tbFlitDate = {}
    for i, tbTempDate in ipairs(tbData) do
      local nIsNoUse = tonumber(self:GetStrVal(tbTempDate[3])) or 0
      if nIsNoUse ~= 1 then
        table.insert(tbFlitDate, tbTempDate)
      end
    end
    tbData = tbFlitDate
    local tbTempData = {}
    local tbTempContent = {}
    tbTempData.nSubCount = 0
    tbTempData.nFoldFlag = 1
    tbTempData.tbSubData = {}
    for i = 2, #tbData do
      local tbRow = tbData[i]
      local szContentKey = self:GetStrVal(tbRow[1])
      local tbTitlePart = Lib:SplitStr(tbRow[1], "\\")
      local tbSubData = tbTempData

      for j = 1, #tbTitlePart do
        local szSubTitle = tbTitlePart[j]

        local tbTemp = nil

        if not tbSubData.tbSubData then
          tbSubData.tbSubData = {}
        end

        -- 找寻关键字是否存在
        for t = 1, #tbSubData.tbSubData do
          if tbSubData.tbSubData[t].szTitle == szSubTitle then
            tbTemp = tbSubData.tbSubData[t]
            break
          end
        end

        if not tbTemp then
          tbTemp = {}
          tbTemp.nSubCount = 0
          tbTemp.nFoldFlag = 0
          tbTemp.szTitle = szSubTitle
          tbTemp.tbSubData = {}
          tbSubData.tbSubData[#tbSubData.tbSubData + 1] = tbTemp
          tbSubData.nSubCount = tbSubData.nSubCount + 1
        end

        -- 当到达最后一层将具体数据保存
        if j == #tbTitlePart then
          local tbContent = {}
          for k = 2, #tbRow do
            tbContent[#tbContent + 1] = tbRow[k]
          end
          tbTemp.szContentKey = szContentKey
          tbTempContent[szContentKey] = tbContent
          break
        end
        tbSubData = tbTemp
      end
    end
    self.tbHelpContent = tbTempContent
    self.tbHelpFileData = tbTempData
  end
end

function uiHelpSprite:InitFoldFlag()
  self.tbFoldFlag = {}
end

function uiHelpSprite:InitHelpData()
  self:InitFoldFlag()
  self:LoadPlanData()
  self:LoadHelpData()
  self:LoadNewActionData()
end

function uiHelpSprite:OnOpen()
  if GblTask:GetUiFunSwitch("UI_HELPSPRITE_ZHIDAO") == 0 then
    Wnd_Hide(self.UIGROUP, self.PAGE_BUTTON_KEY_STR .. 7) -- 暂不开放此功能
  end
  self.tbFirstPageFold[1] = 1 -- 最新消息是否展开的标记
  self.tbFirstPageFold[2] = 1 -- 今日事项是否展开的标记
  self.tbFirstPageFold[3] = 1 -- 离线托管是否展开的标记
  self.tbFirstPageFold[4] = 1 -- 联赛事项是否展开的标记
  self.tbSearchResultBuf = {}
  self:WriteStatLog()
  if UiVersion == Ui.Version001 then
    Ui(Ui.UI_PLAYERSTATE):OnHelpOpen()
  end
  self.nCurPageIndex = 1
  self:UpdatePage(1)
  self:SetStaticTxt()
  self:SetContentText(self.STR_DEFAULT_TEXT)
  self:UpdateSysTime()
end

-- 获得激活标签页 如果有新消息则首页为激活页，如果没有则是推荐活动为激活页
function uiHelpSprite:GetActivePage()
  local nActivePage = 2
  local tbNeedInfo = {}
  for key, nId in pairs(self.DNEWSID) do
    self.tbNewsInfo[-nId] = nil
  end
  for nNewsId, tbNInfo in pairs(self.tbNewsInfo) do
    tbNeedInfo[#tbNeedInfo + 1] = self:GetNewsInfo(nNewsId)
  end
  if Task.tbHelp.tbNewsList then
    for key, tbDMews in pairs(Task.tbHelp.tbNewsList) do
      if tbDMews.nEndTime > GetTime() and tbDMews.nEndTime > 0 then
        tbNeedInfo[#tbNeedInfo + 1] = {
          bReaded = Task.tbHelp:GetDNewsReaded(key),
        }
      end
    end
  end

  for _, tb in ipairs(tbNeedInfo) do
    if tb.bReaded ~= 1 then
      nActivePage = 1
      break
    end
  end
  return nActivePage
end

function uiHelpSprite:OnClose()
  if UiVersion == Ui.Version001 then
    Ui(Ui.UI_PLAYERSTATE):OnHelpClose()
  end
  Wnd_SetExclusive(self.UIGROUP, "Main", 0)
end

function uiHelpSprite:GetVar(var, varDefault)
  if type(var) == "function" then
    local bOk, varRet = Lib:CallBack({ var })
    if bOk then
      var = varRet
    else
      var = nil
    end
  end
  return var or varDefault
end

function uiHelpSprite:GetStarStr(nStar, tbImage)
  local szStar = ""
  for i = 1, self.MAX_STAR_NUM / 2 do
    if nStar >= i * 2 then -- 满星
      szStar = szStar .. tbImage.szLightStar
    elseif nStar >= i * 2 - 1 then -- 半星
      szStar = szStar .. tbImage.szDarkStar
    else -- 无星
      szStar = szStar .. tbImage.szBlank
    end
  end
  return szStar
end

function uiHelpSprite:GetNewsInfo(nNewsId)
  local tbNInfo = self.tbNewsInfo[nNewsId]
  if tbNInfo.nLifeTime ~= -1 then -- -1表示永久显示
    local nTime = Task.tbHelp:GetSNewsTime(nNewsId)
    if nTime <= 0 then
      return
    end

    local nNowTime = GetTime()

    if nNowTime - nTime > tbNInfo.nLifeTime then
      return
    end
  end

  local nWeight = self:GetVar(tbNInfo.varWeight, 0)
  if nWeight <= 0 then
    return
  end

  local bReaded = Task.tbHelp:GetSNewsReaded(nNewsId)

  local tbRet = {
    szName = tbNInfo.szName,
    nWeight = nWeight,
    nId = nNewsId,
    bReaded = bReaded,
    szMsg = tbNInfo.szMsg,
  }

  return tbRet
end

function uiHelpSprite:OnEditEnter(szWnd)
  if szWnd == self.EDIT_SEARCH then
    self:OnSearch()
  end
end

function uiHelpSprite:OnSearch()
  local szKey = Edt_GetTxt(self.UIGROUP, self.EDIT_SEARCH)
  if not szKey or szKey == "" then
    return
  end
  self.nCurPageIndex = 5
  self.szSearchKey = szKey
  self:SearchHelpList(szKey)
  self:UpdatePage(1)
end

function uiHelpSprite:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SEARCH then
    self:OnSearch()
  elseif szWnd == self.BTN_XOYOASK then
    UiManager:OpenWindow(Ui.UI_XOYO_ASK)
    UiManager:CloseWindow(self.UIGROUP)
  else
    local _, _, szBtnIndex = string.find(szWnd, self.PAGE_BUTTON_KEY_STR .. "(%d+)")
    if szBtnIndex then
      self.nCurPageIndex = tonumber(szBtnIndex)
      self:UpdatePage(1)
      return
    end
  end
end

-- 通过关键字搜索内容列表，直接搜索内容的标题，而不是内容搜索
function uiHelpSprite:SearchHelpList(szKey)
  self.tbSearchPageFold = {}
  self.tbSearchResultBuf = {}
  self.tbSearchResultBuf.tbSubData = {}
  self:FindHelpList(self.tbHelpFileData, szKey)
end

-- 用深度优先搜索算法搜索关键字
function uiHelpSprite:FindHelpList(tbSubData, szKey)
  for i = 1, #tbSubData.tbSubData do
    local tbData = tbSubData.tbSubData[i]

    if KLib.FindStr(tbData.szTitle, szKey) then
      self.tbSearchResultBuf.tbSubData[#self.tbSearchResultBuf.tbSubData + 1] = tbData
    else
      self:FindHelpList(tbData, szKey)
    end
  end
end

--设置静态文字
function uiHelpSprite:SetStaticTxt()
  local nTime = KGblTask.SCGetDbTaskInt(DBTASD_SERVER_STARTTIME)
  local nOpenDay = TimeFrame:GetServerOpenDay()
  local szTime = os.date("开服时间：<color=yellow>%Y年%m月%d日<color>", nTime) .. string.format("\n开服天数：<color=yellow>%s天<color>", nOpenDay)
  Txt_SetTxt(self.UIGROUP, self.TXT_SYSSTARTTIMETAG, szTime)
end
-- 显示列表内容
function uiHelpSprite:SetListText(szListText)
  szListText = self:GetStrVal(szListText)
  Ui.tbLogic.tbTimer:Register(1, self.OnTimer_SetText, self, self.TXX_LIST, szListText)
end

-- 显示文字内容
function uiHelpSprite:SetContentText(szText)
  szText = self:GetStrVal(szText)
  Ui.tbLogic.tbTimer:Register(1, self.OnTimer_SetText, self, self.TXX_TEXT, szText)
end

-- 延迟修改文本（修改文本会导致窗体销毁，如果在窗体事件中销毁窗体可能引起宕机）
function uiHelpSprite:OnTimer_SetText(szWnd, szText)
  if szText and string.len(szText) > 0 then
    TxtEx_SetText(self.UIGROUP, szWnd, szText)
  end
  return 0
end

-- 更新系统时间，每2秒更新一次
function uiHelpSprite:UpdateSysTime()
  local nNowDate = GetTime()
  local nWeekDay = tonumber(os.date("%w", nNowDate))
  local szWeekDay = "日"
  if nWeekDay ~= 0 then
    szWeekDay = Lib:Transfer4LenDigit2CnNum(nWeekDay)
  end
  local szTime = os.date("%H:%M", nNowDate)
  local szDate = os.date("%Y年%m月%d日 星期" .. szWeekDay, nNowDate)
  Txt_SetTxt(self.UIGROUP, self.TXT_SYSTIME, szTime)
  Wnd_SetTip(self.UIGROUP, self.TXT_SYSTIME, szDate)
  Wnd_SetTip(self.UIGROUP, self.TXT_SYSTIMETAG, szDate)
end

-- 更新标签页，nRefreshFlag表示是否清空右侧内容文字，1表示清空
function uiHelpSprite:UpdatePage(nRefreshFlag)
  for i = 1, self.PAGE_BUTTON_MAX_NUMBER do
    local nChecked = 0
    if i == self.nCurPageIndex then
      self["OnUpdatePage_Page" .. string.format("%d", self.nCurPageIndex)](self)
      nChecked = 1
    end
    Btn_Check(self.UIGROUP, self.PAGE_BUTTON_KEY_STR .. i, nChecked)
  end
  if nRefreshFlag == 1 then
    self:SetContentText("")
  end
  if self.nCurPageIndex ~= 7 then
    Wnd_SetExclusive(self.UIGROUP, "Main", 0)
  else
    Wnd_SetExclusive(self.UIGROUP, "Main", 1)
  end
end

local function OnSortByName(tb1, tb2)
  if tb1.nWeight ~= tb2.nWeight then
    return tb1.nWeight > tb2.nWeight
  end
  return tb1.nId < tb2.nId
end
-- 首页标签页
function uiHelpSprite:OnUpdatePage_Page1()
  local tbNeedInfo = {}
  for key, nId in pairs(self.DNEWSID) do
    self.tbNewsInfo[-nId] = nil
  end
  for nNewsId, tbNInfo in pairs(self.tbNewsInfo) do
    tbNeedInfo[#tbNeedInfo + 1] = self:GetNewsInfo(nNewsId)
  end
  if Task.tbHelp.tbNewsList then
    for key, tbDMews in pairs(Task.tbHelp.tbNewsList) do
      local nTime = GetTime()
      if tbDMews.nEndTime > nTime and tbDMews.nEndTime > 0 and nTime >= tbDMews.nAddTime then
        tbNeedInfo[#tbNeedInfo + 1] = {
          szName = tbDMews.szTitle,
          nWeight = 50000 - key,
          nId = -1 * key,
          nKey = key,
          bReaded = Task.tbHelp:GetDNewsReaded(key),
        }
        self.tbNewsInfo[-1 * key] = {
          szName = tbDMews.szTitle,
          nLifeTime = 0,
          varWeight = 100,
          varContent = tbDMews.szMsg,
        }
      end
    end
  end

  -- 马来没有最新消息
  if UiManager.IVER_nReciveNews ~= 1 then
    tbNeedInfo = {}
  end
  -- 按照权重排序
  table.sort(tbNeedInfo, OnSortByName)
  local szListText = string.format("<bgclr=250,250,120,80><goto=10><a=firstfold:%d><div=230,20,0,0,0>最新消息</div><a><bgclr><linegap=10>\n", 1)
  if self.tbFirstPageFold[1] == 1 then
    for _, tb in ipairs(tbNeedInfo) do
      if tb.bReaded ~= 1 then
        szListText = szListText .. "<pic=\\image\\effect\\other\\new" .. UiManager.IVER_szVnSpr .. "><linegap=-16>\n<linegap=10>"
      else
        szListText = szListText .. "   "
      end
      local szCanShowInfo = GetLimitiStr(tb.szName, 190, 12)
      self.tbNewsLinkId2WholeStr[tb.nId] = tb.szName
      szListText = szListText .. string.format("<goto=60><a=news:%d>%s<a>\n<linegap=10>", tb.nId, szCanShowInfo)
    end
    szListText = szListText .. "\n"
  end

  for nId, tbInfo in pairs(self.tbDailyInfo) do
    local nShow = self:GetVar(tbInfo.varShowType)
    if 1 == nShow then
      szListText = szListText .. string.format("<bgclr=250,250,120,80><goto=10><a=dailyinfo:%d><div=230,20,0,0,0>%s</div><a><bgclr><linegap=10>\n", nId, tbInfo.szName)
    end
  end

  szListText = szListText .. "\n"
  self:SetListText(szListText)
end

function uiHelpSprite:GetStrVal(szText)
  local szListText = ""
  if szText then
    szListText = string.gsub(szText, "<%%(.-)%%>", fnStrValue)
  end
  return szListText
end

-- 首页展开链接，点击那行的空白地方都能展开
function uiHelpSprite:Link_firstfold_OnClick(szWnd, szFoldFlag)
  local nFoldFlag = tonumber(szFoldFlag)

  if self.tbFirstPageFold[nFoldFlag] == 0 then
    self.tbFirstPageFold[nFoldFlag] = 1
  else
    self.tbFirstPageFold[nFoldFlag] = 0
  end
  self:UpdatePage()
end

function uiHelpSprite:GetFuDaiCountAndLimit()
  local nFuCount = me.GetTask(2013, 1) -- 如果id改了记得一定要改
  local nFuDate = me.GetTask(2013, 2) -- 获得福袋使用日期
  local nFuLimit = me.GetTask(2013, 3) -- 福袋使用上限

  local nNowDate = GetTime()
  local nDay = tonumber(os.date("%y%m%d", nNowDate))

  if nFuDate < nDay then
    nFuCount = 0
  end

  if nFuLimit <= 0 then
    nFuLimit = 10
  end
  return nFuCount, nFuLimit
end

-- 获得已经参加了白虎堂次数
function uiHelpSprite:GetBaihutangCount()
  local TSKG_PVP_ACT = 2009
  local TSK_BaiHuTang_PKTIMES = 1
  local nTimes = me.GetTask(TSKG_PVP_ACT, TSK_BaiHuTang_PKTIMES)
  if nTimes == nil then
    return 0
  end
  local nResult = 0
  local szNowDate = GetLocalDate("%y%m%d")
  local nDate = math.floor(nTimes / 10)
  local nPKTimes = nTimes % 10
  local nNowDate = tonumber(szNowDate)

  if nDate == nNowDate then
    nResult = nPKTimes
  end
  return nResult
end

-- 获得已经完成包万同任务次数
function uiHelpSprite:GetBaoCount()
  local nNowDate = tonumber(GetLocalDate("%Y%m%d")) -- 获取日期：XXXX/XX/XX 格式
  local nOldDate = LinkTask:GetTask(LinkTask.TSK_DATE)
  local nQuestTime = me.GetTask(LinkTask.TSKG_LINKTASK, LinkTask.TSK_NUM_PERDAY)

  if nNowDate ~= nOldDate then
    nQuestTime = 0
  end
  return nQuestTime
end

-- 热点推荐
function uiHelpSprite:OnUpdatePage_Page2()
  Log:Ui_SendLog("点击活动推荐页", 1)
  local tbNeedInfo = {}
  local szListText = ""

  for nId, tbMInfo in pairs(self.tbRecInfo) do
    local nExpStar = self:GetVar(tbMInfo.varExpStar, 0)
    local nMoneyStar = self:GetVar(tbMInfo.varMoneyStar, 0)
    local nStar = nExpStar + nMoneyStar -- 星级和
    local nSort = self:GetVar(tbMInfo.varSortStar, 0)
    if nSort > 0 then
      tbNeedInfo[#tbNeedInfo + 1] = {
        szName = tbMInfo.szName,
        nExpStar = nExpStar,
        nMoneyStar = nMoneyStar,
        nStar = nStar,
        nId = nId,
        nSort = nSort,
      }
    end
  end

  -- 最适合参加
  table.sort(tbNeedInfo, function(tb1, tb2)
    return tb1.nSort > tb2.nSort
  end)

  szListText = szListText .. "<goto=10>最适合参加的活动<linegap=10>\n"
  for nRank = 1, math.min(3, #tbNeedInfo) do
    local tb = tbNeedInfo[nRank]
    if tb.nSort <= 0 then
      break
    end

    local szCanShowInfo = GetLimitiStr(tb.szName, 87, 12)
    local szId = string.format("%d,0", tb.nId)
    self.tbTuiJianLinkId2WholeStr[szId] = tb.szName
    szListText = szListText .. string.format("<goto=60><a=tuijian:%d,0>%s<a><goto=150>%s<linegap=10>\n", tb.nId, szCanShowInfo, self:GetStarStr(tb.nSort, self.IMAGE_STAR_SORT))
  end

  -- 最能赚钱
  table.sort(tbNeedInfo, function(tb1, tb2)
    return tb1.nMoneyStar > tb2.nMoneyStar
  end)

  szListText = szListText .. "<goto=10>最赚钱的活动<linegap=10>\n"
  for nRank = 1, math.min(4, #tbNeedInfo) do
    local tb = tbNeedInfo[nRank]
    if tb.nMoneyStar <= 0 then
      break
    end

    local szCanShowInfo = GetLimitiStr(tb.szName, 87, 12)
    local szId = string.format("%d,0", tb.nId)
    self.tbTuiJianLinkId2WholeStr[szId] = tb.szName
    szListText = szListText .. string.format("<goto=60><a=tuijian:%d,0>%s<a><goto=150>%s<linegap=10>\n", tb.nId, szCanShowInfo, self:GetStarStr(tb.nMoneyStar, self.IMAGE_STAR_SORT))
  end

  -- 经验
  table.sort(tbNeedInfo, function(tb1, tb2)
    return tb1.nExpStar > tb2.nExpStar
  end)

  szListText = szListText .. "<goto=10>最涨经验的活动<linegap=10>\n"
  for nRank = 1, math.min(4, #tbNeedInfo) do
    local tb = tbNeedInfo[nRank]
    if tb.nExpStar <= 0 then
      break
    end

    local szCanShowInfo = GetLimitiStr(tb.szName, 87, 12)
    local szId = string.format("%d,0", tb.nId)
    self.tbTuiJianLinkId2WholeStr[szId] = tb.szName
    szListText = szListText .. string.format("<goto=60><a=tuijian:%d,0>%s<a><goto=150>%s<linegap=10>\n", tb.nId, szCanShowInfo, self:GetStarStr(tb.nExpStar, self.IMAGE_STAR_SORT))
  end

  self:SetListText(szListText)
end

-- 最新活动
function uiHelpSprite:OnUpdatePage_Page3()
  local szListText = ""

  --活动帮助Id从10000开始
  self.EventManagerNewsData = EventManager.News:GetNewsData()
  for n, tbData in ipairs(self.EventManagerNewsData) do
    local nId = EventManager.News.NEWSID + n
    szListText = szListText .. string.format("<goto=20><a=newaction:%d>%s<a><linegap=10>\n", nId, tbData[1])
  end

  for nId, tbData in ipairs(self.tbNewsActFileData) do
    local nIsNoUse = tonumber(self:GetStrVal(tbData[3])) or 0
    if nIsNoUse ~= 1 then
      if nId > 1 then
        szListText = szListText .. string.format("<goto=20><a=newaction:%d>%s<a><linegap=10>\n", nId, tbData[1])
      end
    end
  end
  self:SetListText(szListText)
end

-- 详细帮助
function uiHelpSprite:OnUpdatePage_Page4()
  Log:Ui_SendLog("点击详细帮助页", 1)
  local szListText = ""
  local nCol = 0
  --	szListText = self:OpenSubData(self.tbHelpFileData, szListText, nCol);
  self.tbCurFoldList = {
    tbData = self.tbHelpFileData,
    tbFoldState = self.tbHelpFoldState,
    szSearchKey = nil,
    nDefaultFold = 0,
  }
  szListText = self:CreateList(self.tbHelpFileData, self.tbHelpFoldState, szListText, -20, 0)
  self:SetListText(szListText)
end

-- 搜索结果
function uiHelpSprite:OnUpdatePage_Page5()
  -- Log:Ui_SendLog("点击搜索按钮", 1);
  local szListText = ""
  self.tbCurFoldList = {
    tbData = self.tbSearchResultBuf,
    tbFoldState = self.tbSearchPageFold,
    szSearchKey = self.szSearchKey,
    nDefaultFold = 1,
  }
  szListText = self:CreateList(self.tbSearchResultBuf, self.tbSearchPageFold, szListText, -20, 1, self.szSearchKey)
  if szListText == "" then
    szListText = " "
  end
  self:SetListText(szListText)
end

-- 获得搜索结果列表，默认全展开
function uiHelpSprite:CreateList(tbData, tbFoldFlag, szListText, nCol, nDefaultState, szSearchKey)
  if not tbData.tbSubData or #tbData.tbSubData <= 0 then
    return szListText
  end
  for i = 1, #tbData.tbSubData do
    local tbSubData = tbData.tbSubData[i]
    local szKey = tbSubData.szTitle
    local szContentKey = tbSubData.szContentKey
    if not szContentKey or szContentKey == "" then
      szContentKey = "nil"
    end

    if not tbFoldFlag[i] then
      tbFoldFlag[i] = {}
      tbFoldFlag[i].nFoldFlag = nDefaultState
      if #tbSubData.tbSubData <= 0 then
        tbFoldFlag[i].nFoldFlag = 0
      end
      tbFoldFlag[i].tbSubFlag = {}
    end

    local szFoldFlag = ""
    if #tbSubData.tbSubData > 0 then
      if tbFoldFlag[i].nFoldFlag == 1 then
        szFoldFlag = self.IMAGE_DECREASE
      else
        szFoldFlag = self.IMAGE_INCREASE
      end
      szFoldFlag = string.format("<a=search:%s>%s<a>  ", szKey, szFoldFlag)
    else
      szFoldFlag = "  "
    end

    if szSearchKey and KLib.FindStr(szKey, szSearchKey) then
      szKey = Lib:ReplaceStrS(szKey, szSearchKey, string.format("<bgclr=128,244,255,80> %s <bgclr>", szSearchKey))
    end

    if self.tbHelpContent[szContentKey] then
      szListText = szListText .. string.format("<goto=%d>", nCol + 30) .. szFoldFlag .. string.format("<a=helps:%s>%s<a><linegap=10>\n", szContentKey, szKey)
    else
      szListText = szListText .. string.format("<goto=%d>", nCol + 30) .. szFoldFlag .. string.format("%s<linegap=10>\n", szKey)
    end

    if tbFoldFlag[i].nFoldFlag >= 1 then
      szListText = self:CreateList(tbSubData, tbFoldFlag[i].tbSubFlag, szListText, nCol + 30, nDefaultState, szSearchKey)
    end
  end

  return szListText
end

-- 开发计划
function uiHelpSprite:OnUpdatePage_Page6()
  local szListText = ""
  for nId, tbData in ipairs(self.tbPlanFileData) do
    local nIsNoUse = tonumber(self:GetStrVal(tbData[3])) or 0
    if nIsNoUse ~= 1 then
      if nId > 1 then
        szListText = szListText .. string.format("<goto=40><a=plan:%d>%s<a><linegap=10>\n", nId, tbData[1])
      elseif nId == 1 then
        szListText = szListText .. string.format("<goto=15><color=white>《剑侠世界》下阶段发布计划：<color><linegap=20>\n")
      end
    end
  end
  self:SetListText(szListText)
end

--== 超链接响应 ==--

-- 超链接 —— 开发计划
function uiHelpSprite:Link_plan_OnClick(szWnd, szRecId)
  local nRecId = tonumber(szRecId)
  local tbData = self.tbPlanFileData[nRecId]
  self:SetContentText(tbData[2])
end

-- 超链接 —— 系统推荐
function uiHelpSprite:Link_tuijian_OnClick(szWnd, szLink)
  local tbSplit = Lib:SplitStr(szLink)
  local nRecId = tonumber(tbSplit[1])
  local nQaIdx = tonumber(tbSplit[2])
  local tbMInfo = self.tbRecInfo[nRecId]
  local nSortStar = self:GetVar(tbMInfo.varSortStar, 0)
  local nExpStar = self:GetVar(tbMInfo.varExpStar, 0)
  local nMoneyStar = self:GetVar(tbMInfo.varMoneyStar, 0)
  local szText = "<linegap=-10>\n"
  szText = szText .. "<font=14><bclr=purple>获得经验<bclr><font><linegap=-19>\n<goto=160><linegap=5>" .. self:GetStarStr(nExpStar, self.IMAGE_STAR_EXP) .. "\n"
  szText = szText .. "<font=14><bclr=purple>获得财富<bclr><font><linegap=-19>\n<goto=160><linegap>" .. self:GetStarStr(nMoneyStar, self.IMAGE_STAR_MONEY) .. "\n\n"
  szText = szText .. "<bclr=green><font=14>奖励<font><bclr>\n<color=yellow><tab=10>" .. self:GetVar(tbMInfo.varAward, "") .. "<color>\n"
  szText = szText .. "\n<color=white>" .. self:GetVar(tbMInfo.varRemain, "") .. "<color><linegap=8>\n"
  szText = szText .. "\n<color=white><font=14>常见问题<font><color>\n"

  local tbQaFold = self.tbQaFold
  if nQaIdx == 0 then
    tbQaFold = {}
    self.tbQaFold = tbQaFold
  elseif tbQaFold[nQaIdx] then
    tbQaFold[nQaIdx] = nil
  else
    tbQaFold[nQaIdx] = 1
  end

  for nIdx, tb in pairs(tbMInfo.tbQA) do
    szText = szText .. string.format("<a=tuijian:%d,%d>%s<a>\n", nRecId, nIdx, tb[1])
    if tbQaFold[nIdx] then
      szText = szText .. tb[2] .. "\n\n"
    end
  end

  self:SetContentText(szText)
end

-- 超链接 —— 最新消息
function uiHelpSprite:Link_news_OnClick(szWnd, szNewsId)
  local nNewsId = tonumber(szNewsId)
  local tbNInfo = self.tbNewsInfo[nNewsId]
  local szText = self:GetVar(tbNInfo.varContent)
  if nNewsId > 0 then
    Task.tbHelp:SetSNewsReaded(nNewsId)
  else
    Task.tbHelp:SetDNewsReaded(-nNewsId)
  end
  self:UpdatePage()
  self:SetContentText(szText)
end

function uiHelpSprite:Link_dailyinfo_OnClick(szWnd, szInfoId)
  local nInfoId = tonumber(szInfoId)
  local tbInfo = self.tbDailyInfo[nInfoId]
  local szText = self:GetVar(tbInfo.varContext)
  self:UpdatePage()
  self:SetContentText(szText)
end

-- 超链接 -- 搜索列表
function uiHelpSprite:Link_search_OnClick(szWnd, szKey)
  self:SetListState(szKey, self.tbCurFoldList.tbData, self.tbCurFoldList.tbFoldState)
  self:UpdatePage()
end

function uiHelpSprite:Link_news_GetTip(szWnd, szInfoId)
  local nInfoId = tonumber(szInfoId)
  return self.tbNewsLinkId2WholeStr[nInfoId]
end

function uiHelpSprite:Link_tuijian_GetTip(szWnd, szInfoId)
  return self.tbTuiJianLinkId2WholeStr[szInfoId]
end

-- 通过关键字查找标题位置
function uiHelpSprite:SetListState(szKey, tbHelpFileData, tbFoldState)
  for i = 1, #tbHelpFileData.tbSubData do
    local tbData = tbHelpFileData.tbSubData[i]
    if tbData.szTitle == szKey then
      if tbFoldState[i].nFoldFlag == 0 then
        tbFoldState[i].nFoldFlag = 1
      else
        tbFoldState[i].nFoldFlag = 0
      end
      return 1
    else
      if not tbFoldState[i] then
        tbFoldState[i] = {}
        tbFoldState[i].nFoldFlag = self.tbCurFoldList.nDefaultFold
        tbFoldState[i].tbSubFlag = {}
      end
      local nFind = self:SetListState(szKey, tbData, tbFoldState[i].tbSubFlag)
      if nFind == 1 then
        tbFoldState[i].nFoldFlag = 1
        return nFind
      end
    end
  end
  return 0
end

-- 超链接 —— 详细帮助
function uiHelpSprite:Link_helps_OnClick(szWnd, szContentKey)
  local szContent = ""
  if self.tbHelpContent[szContentKey] then
    szContent = self.tbHelpContent[szContentKey][1]
  end
  self:SetContentText(szContent)
end

-- 详细帮助展开链接
function uiHelpSprite:Link_helpsfold_OnClick(szWnd, szKey)
  self:SetListState(szKey, self.tbHelpFileData, self.tbHelpFoldState)
  self:UpdatePage()
end

-- 查找详细帮助链接的标题
function uiHelpSprite:FindTitleContent(szKey, tbHelpFileData)
  for i = 1, #tbHelpFileData.tbSubData do
    local tbData = tbHelpFileData.tbSubData[i]
    if tbData.szTitle == szKey then
      return tbData
    else
      local tbFileData = self:FindTitleContent(szKey, tbData)
      if tbFileData then
        return tbFileData
      end
    end
  end
  return nil
end

-- 打开祈福界面
function uiHelpSprite:Link_openpray_OnClick(szWnd, szGroupId)
  UiManager:CloseWindow(self.UIGROUP)
  UiManager:SwitchWindow(Ui.UI_PLAYERPRAY)
end

-- 超链接 —— 帮助问答
function uiHelpSprite:Link_question_OnClick(szWnd, szGroupId)
  local nGroupId = tonumber(szGroupId)
  UiManager:CloseWindow(self.UIGROUP)
  me.CallServerScript({ "HlpQue", nGroupId })
end

-- 超链接 —— 最新活动
function uiHelpSprite:Link_newaction_OnClick(szWnd, szRecId)
  local nRecId = tonumber(szRecId)
  local tbData = self.tbNewsActFileData[nRecId]
  if nRecId > EventManager.News.NEWSID then
    tbData = self.EventManagerNewsData[math.floor(nRecId - EventManager.News.NEWSID)]
  end
  self:SetContentText(tbData[2])
end

function uiHelpSprite:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end
