-----------------------------------------------------
--文件名		：	uigroup.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-17
--功能描述		：	加载界面。
------------------------------------------------------

Require("\\ui\\script\\define.lua")
Require("\\ui\\script\\logic\\checkplugin.lua")
Require("\\ui\\script\\plugindef.lua")

local tbMeta = {
  __call = function(self, szUiGroup)
    local tbWnd = self.tbWnd[szUiGroup]
    if not tbWnd then
      self:Output('[ERR] 指定UIGROUP "' .. tostring(szUiGroup) .. '" 未找到！')
    end
    return tbWnd
  end,
}

-- 实现UiGroup("UI_ITEMBOX")获取UI_ITEMBOX所对应Class实例
setmetatable(Ui, tbMeta)

-- 窗口列表
local UI_LIST = { -- UiGroupName				= {	IniFileName				ClassName			, tbUseableVersion},
  [Ui.UI_ITEMBOX] = { "itembox.ini", "itembox" },
  [Ui.UI_SIDEBAR] = { "sidebar.ini", "sidebar" },
  [Ui.UI_PLAYERPANEL] = { "playerpanel.ini", "playerpanel" },
  [Ui.UI_SKILLBAR] = { "skillbar.ini", "skillbar" },
  [Ui.UI_SHORTCUTBAR] = { "shortcutbar.ini", "shortcutbar" },
  [Ui.UI_PLAYERSTATE] = { "playerstate.ini", "playerstate" },
  [Ui.UI_SKILLTREE] = { "skilltree.ini", "skilltree" },
  [Ui.UI_FIGHTSKILL] = { "fightskill.ini", "fightskill" },
  [Ui.UI_LIFESKILL] = { "lifeskill.ini", "lifeskill" },
  [Ui.UI_PRODUCE] = { "produce.ini", "produce" },
  [Ui.UI_TASKPANEL] = { "taskpanel.ini", "taskpanel" },
  [Ui.UI_TEAM] = { "team.ini", "team" },
  [Ui.UI_TEAMPORTRAIT] = { "teamportrait.ini", "teamportrait" },
  [Ui.UI_TONG] = { "tong.ini", "tong" },
  [Ui.UI_DELETEKIN] = { "deletekin.ini", "deletekin" },
  [Ui.UI_SYSTEM] = { "system.ini", "system" },
  [Ui.UI_POPBAR] = { "popbar.ini", "popbar" },
  [Ui.UI_TASKTRACK] = { "tasktrack.ini", "tasktrack" },
  [Ui.UI_TASKTRACKTMP] = { "tasktracktmp.ini", "tasktracktmp" },
  [Ui.UI_BUFFBAR] = { "buffbar.ini", "buffbar" },
  [Ui.UI_SHOP] = { "shop.ini", "shop" },
  [Ui.UI_OFFER] = { "offer.ini", "offer" },
  [Ui.UI_OFFERMARKPRICE] = { "offermarkprice.ini", "offermarkprice" },
  [Ui.UI_OFFERSELL] = { "offersell.ini", "offersell" },
  [Ui.UI_RENASCENCEPANEL] = { "renascencepanel.ini", "renascencepanel" },
  [Ui.UI_SHOPBUY] = { "shopbuy.ini", "shopbuy" },
  [Ui.UI_SHOPSELL] = { "shopsell.ini", "shopsell" },
  [Ui.UI_STALL] = { "stall.ini", "stall" },
  [Ui.UI_STALLBUY] = { "stallbuy.ini", "stallbuy" },
  [Ui.UI_STALLOFFERADV] = { "stallofferadv.ini", "stallofferadv" },
  [Ui.UI_TASKTRACK] = { "tasktrack.ini", "tasktrack" },
  [Ui.UI_TRADE] = { "trade.ini", "trade" },
  [Ui.UI_MSGBOX] = { "msgbox.ini", "msgbox" },
  [Ui.UI_MSGINFO] = { "msgbox.ini", "msgbox" },
  [Ui.UI_SAYPANEL] = { "saypanel.ini", "saypanel" },
  [Ui.UI_RELATION] = { "relation.ini", "relation" },
  [Ui.UI_ITEMGIFT] = { "itemgift.ini", "itemgift" },
  [Ui.UI_SKILLPROGRESS] = { "skillprogress.ini", "skillprogress" },
  [Ui.UI_SERIESSWITCH] = { "seriesswitch.ini", "seriesswitch" },
  [Ui.UI_VIEWPLAYER] = { "viewplayer.ini", "viewplayer" },
  [Ui.UI_MAIL] = { "mail.ini", "mail" },
  [Ui.UI_MAILNEW] = { "mailnew.ini", "mailnew" },
  [Ui.UI_MAILVIEW] = { "mailview.ini", "mailview" },
  [Ui.UI_INFOBOARD] = { "infoboard.ini", "infoboard" },
  [Ui.UI_KIN] = { "kin.ini", "kin" },
  [Ui.UI_KINREQUESTLIST] = { "kinrequestlist.ini", "kinrequestlist" },
  [Ui.UI_TEXTINPUT] = { "textinput.ini", "textinput" },
  [Ui.UI_TEACHER] = { "teacher.ini", "teacher" },
  [Ui.UI_CHECKTEACHER] = { "checkteacher.ini", "checkteacher" },
  [Ui.UI_REPOSITORY] = { "repository.ini", "repository" },
  [Ui.UI_GUTMODEL] = { "gutmodel.ini", "gutmodel" },
  [Ui.UI_GUTSAY] = { "gutsay.ini", "gutsay" },
  [Ui.UI_GUTAWARD] = { "gutaward.ini", "gutaward" },
  [Ui.UI_GUTTALK] = { "guttalk.ini", "guttalk" },
  [Ui.UI_KINCREATE] = { "kincreate.ini", "kincreate" },
  [Ui.UI_CHANGEWAGE] = { "changewage.ini", "changewage" },
  [Ui.UI_TONGDISPENSE] = { "tongdispense.ini", "tongdispense" },
  [Ui.UI_TONGREQUESTLIST] = { "kinrequestlist.ini", "tongrequestlist" },
  [Ui.UI_SELECTNPC] = { "selectnpc.ini", "selectnpc" },
  [Ui.UI_SIDEBAR_TIPS] = { "sidebartips.ini", "sidebartips" },
  [Ui.UI_BATTLEREPORT] = { "battlereport.ini", "battlereport" },
  [Ui.UI_TASKTIPS] = { "tasktips.ini", "tasktips" },
  [Ui.UI_IBSHOP] = { "ibshop.ini", "ibshop" },
  [Ui.UI_IBSHOPCART] = { "ibshopcart.ini", "ibshopcart" },
  [Ui.UI_TEXTINPUT_BANNER] = { "textinput_banner.ini", "textinput_banner" },
  [Ui.UI_GROUPMAILNEW] = { "groupmailnew.ini", "groupmailnew" },
  [Ui.UI_NEWSMSG] = { "newsmsg.ini", "newsmsg" },
  [Ui.UI_LADDER] = { "ladder.ini", "ladder" },
  [Ui.UI_FACTION_SPORTCASE] = { "factionsportcase.ini", "factionsportcase" },
  [Ui.UI_WORLDMAP_GLOBAL] = { "worldmap_global.ini", "worldmap_global" },
  [Ui.UI_WORLDMAP_AREA] = { "worldmap_area.ini", "worldmap_area" },
  [Ui.UI_WORLDMAP_SUB] = { "worldmap_sub.ini", "worldmap_sub" },
  [Ui.UI_AUTOFIGHT] = { "autofight.ini", "autofight" },
  [Ui.UI_EQUIPENHANCE] = { "equipenhance.ini", "equipenhance" },
  [Ui.UI_EQUIPBREAKUP] = { "equipbreakup.ini", "equipbreakup" },
  [Ui.UI_TEXTEXEDITOR] = { "textexeditor.ini", "textexeditor" },
  [Ui.UI_HELPSPRITE] = { "helpsprite.ini", "helpsprite" },
  [Ui.UI_OPTIMIZEPANEL] = { "optimizepanel.ini", "optimizepanel" },
  [Ui.UI_TRUSTEE] = { "trustee.ini", "trustee" },
  [Ui.UI_REPORT] = { "report.ini", "report" },
  [Ui.UI_MSGBOARD] = { "msgboard.ini", "msgboard" },
  [Ui.UI_JBEXCHANGE] = { "jbexchange.ini", "jbexchange" },
  [Ui.UI_JBMARKPRICE] = { "jbmarkprice.ini", "jbmarkprice" },
  [Ui.UI_DISCONNECT] = { "disconnect.ini", "disconnect" },
  [Ui.UI_FIGHTMODE] = { "fightmode.ini", "fightmode" },
  [Ui.UI_AGREEMENT] = { "agreement.ini", "agreement" },
  [Ui.UI_EXTBAG1] = { "extbag.ini", "extbag" },
  [Ui.UI_EXTBAG2] = { "extbag.ini", "extbag" },
  [Ui.UI_EXTBAG3] = { "extbag.ini", "extbag" },
  [Ui.UI_LOGINBG] = { "loginbg.ini", "loginbg" },
  [Ui.UI_LOCKSTATE] = { "lockstate.ini", "lockstate" },
  [Ui.UI_MINIKEYBOARD] = { "minikeyboard.ini", "minikeyboard" },
  [Ui.UI_LOCKACCOUNT] = { "lockaccount.ini", "lockaccount" },
  [Ui.UI_SETPASSWORD] = { "setpassword.ini", "setpassword" },
  [Ui.UI_UNLOCK] = { "unlock.ini", "unlock" },
  [Ui.UI_SETCHANNEL] = { "setchannel.ini", "setchannel" },
  [Ui.UI_SERVERSPEED] = { "serverspeed.ini", "serverspeed" },
  [Ui.UI_PLAYERPRAY] = { "playerpray.ini", "playerpray" },
  [Ui.UI_PREVIEW] = { "preview.ini", "preview" },
  [Ui.UI_BLOGVIEWPLAYER] = { "blogviewplayer.ini", "blogviewplayer" },
  [Ui.UI_REPLAYCONSOLE] = { "replayconsole.ini", "replayconsole" },
  [Ui.UI_AUCTIONROOM] = { "auctionroom.ini", "auctionroom" },
  [Ui.UI_MSGBOXWITHOBJ] = { "msgboxwithobj.ini", "msgboxwithobj" },
  [Ui.UI_MSGBOXWITHOBJ2] = { "msgboxwithobj2.ini", "msgboxwithobj2" },
  [Ui.UI_PAYONLINE] = { "payonline.ini", "payonline" },
  [Ui.UI_DAILY] = { "daily.ini", "daily" },
  [Ui.UI_BANK] = { "bank.ini", "bank" },
  [Ui.UI_KINBUILDFLAG] = { "setbuildflagtime.ini", "kinbuildflag" },
  [Ui.UI_WORLDMAP_DOMAIN] = { "worldmap_domain.ini", "worldmap_domain" },
  [Ui.UI_DOMAINREPORT] = { "domainreport.ini", "domainreport" },
  [Ui.UI_TASKLEAVETIME] = { "taskleavetime.ini", "taskleavetime" },
  [Ui.UI_LEAGUEMATCH] = { "leaguematch.ini", "leaguematch" },
  [Ui.UI_VIEW_FIGHTSKILL] = { "viewfightskill.ini", "viewfightskill" },
  [Ui.UI_DAMAGETEST] = { "damagetest.ini", "damagetest" },
  [Ui.UI_COVER] = { "cover.ini", "cover" },
  [Ui.UI_BAIBAOXIANG] = { "baibaoxiang.ini", "baibaoxiang" }, -- 百宝箱
  [Ui.UI_ONLINEEXP] = { "onlineexp.ini", "onlineexp" },
  [Ui.UI_JINGHUOFULI] = { "jinghuofuli.ini", "jinghuofuli" },
  [Ui.UI_LOOKERESC] = { "lookeresc.ini", "lookeresc" }, --观战模式退出
  [Ui.UI_TONGANNOUNCE] = { "tongannounce.ini", "tongannounce" }, -- 帮会公告
  [Ui.UI_KINRECRUITMENT] = { "kinrecruitment.ini", "kinrecruitment" }, -- 家族招募
  [Ui.UI_KINRCM_LIST] = { "kinrcmlist.ini", "kinrcmlist" }, -- 招募家族列表
  [Ui.UI_WULINDAHUI] = { "wulindahui.ini", "wulindahui" }, --武林大会
  [Ui.UI_WLDH_BATTLE] = { "wldh_battle.ini", "wldh_battle" }, --武林大会
  [Ui.UI_GROUPPANEL] = { "grouppanel.ini", "grouppanel" }, -- 团队面板
  [Ui.UI_TIREDTIME] = { "tiredtime.ini", "tiredtime" }, --防沉迷
  [Ui.UI_MSGPAD] = { "msgpad.ini", "msgpad" },
  [Ui.UI_CHATTAB] = { "chattab.ini", "chattab" },
  [Ui.UI_YOULONGMIBAO] = { "youlongmibao.ini", "youlongmibao" }, -- 游龙秘宝
  [Ui.UI_ACCOUNTSAFE] = { "accountsafe.ini", "accountsafe" }, -- 帐号安全提示
  [Ui.UI_PARTNER] = { "partner.ini", "partner" }, -- 同伴界面
  [Ui.UI_QUESTIONS] = { "questions.ini", "questions" }, -- 调查问卷
  [Ui.UI_WLDH_BEAUTY] = { "wldh_beauty.ini", "wldh_beauty" }, -- 调查问卷
  [Ui.UI_WEDDING] = { "wedding.ini", "wedding" }, -- 结婚系统特效
  [Ui.UI_CALENDAR] = { "calendar.ini", "calendar" }, -- 剑侠日历
  [Ui.UI_HORNTIP] = { "horntip.ini", "horntip" }, -- 小喇叭提示
  [Ui.UI_MATCHTIP] = { "matchtip.ini", "matchtip" }, -- 活动提示
  [Ui.UI_SUPERSCRIPT] = { "superscript.ini", "superscript" }, -- 脚本文件列表
  [Ui.UI_GLOBALCHAT] = { "globalchat.ini", "globalchat" }, -- global chat
  [Ui.UI_GLOBALCHATEFFECT] = { "globalchateffect.ini", "globalchateffect" }, -- global chat
  [Ui.UI_GLOBALCHATBUY] = { "globalchatbuy.ini", "globalchatbuy" }, -- global chat
  [Ui.UI_LIMITPLAY] = { "limitplay.ini", "limitplay" }, -- 防沉迷补充信息
  [Ui.UI_AWORDONLINE_BACK] = { "awordonline_back.ini", "awordonline" }, -- 在线领奖
  [Ui.UI_AWORDONLINE_EX] = { "awordonline_min.ini", "awordonline_min" }, -- 在线领奖领奖小框
  [Ui.UI_DETAIN] = { "detain.ini", "detain" }, -- 玩家离开游戏的挽留界面
  [Ui.UI_GETAWORD] = { "aword.ini", "aword" }, -- 在线领奖整合
  [Ui.UI_CARDVIEW] = { "cardview.ini", "cardview" }, -- 卡片浏览界面（通用）
  [Ui.UI_COMPETITIVE] = { "competitive.ini", "competitive" }, -- 竞拍界面
  [Ui.UI_SELECTGROUP_FR] = { "selectgroup_fr.ini", "selectgroup_fr" }, -- 第一次选择军团
  [Ui.UI_SELECTGROUP_NR] = { "selectgroup_nr.ini", "selectgroup_nr" }, -- 第n次选择军团
  [Ui.UI_DISTRIBUTE] = { "distribute.ini", "distribute" }, -- 分配奖励界面
  [Ui.UI_BATTLESCORE] = { "battlescore.ini", "battlescore" }, -- 侠客岛战场即时战报
  [Ui.UI_WLLSCHOOSEWIN] = { "wllschoosewin.ini", "wllschoosewin" }, -- 拉片浏览界面（通用）
  [Ui.UI_FIGHTPOWER] = { "fightpower.ini", "fightpower" }, -- 战斗力界面
  [Ui.UI_ZHANHUNBAG] = { "zhanhunbag.ini", "zhanhunbag" }, -- 战魂包
  [Ui.UI_ZHENYUAN] = { "zhenyuan.ini", "zhenyuan" }, -- 真元
  [Ui.UI_SHANGJIN] = { "shangjin.ini", "shangjin" }, -- 赏金界面
  [Ui.UI_ACHIEVEMENT] = { "achievement.ini", "achievement" }, -- 成就界面
  [Ui.UI_FINISHACHIEVE] = { "finishachieve.ini", "finishachieve" }, -- 成就完成界面
  [Ui.UI_EXPTASK] = { "exptask.ini", "exptask" }, --经验任务平台
  [Ui.UI_FABUTASK] = { "fabutask.ini", "fabutask" }, --经验任务平台发布任务界面
  [Ui.UI_HOMELAND] = { "homeland.ini", "homeland" }, --经验任务平台发布任务界面
  [Ui.UI_FIGHTAFTER] = { "fightafter.ini", "fightafter" }, -- 战后系统
  [Ui.UI_EXITCONFIRM] = { "exitconfirm.ini", "exitconfirm" }, -- 台湾版退出确认
  [Ui.UI_BEAUTYHERO] = { "beautyhero.ini", "beautyhero" }, --
  [Ui.UI_TIEFUCHENGENROLL] = { "tiefuchengenroll.ini", "tiefuchengenroll" }, -- 新版铁浮城报名界面
  [Ui.UI_TIEFUCHENGREPORT] = { "tiefuchengreport.ini", "tiefuchengreport" }, -- 新版铁浮城战报界面
  [Ui.UI_DRIFT_MAIN] = { "drift_main.ini", "drift_main" }, -- 许愿树主界面
  [Ui.UI_DRIFT_NEW] = { "drift_new.ini", "drift_new" }, -- 许愿树新帖子
  [Ui.UI_DRIFT_PICK] = { "drift_pick.ini", "drift_pick" }, -- 许愿树摘取界面
  [Ui.UI_DRIFT_MARK] = { "drift_mark.ini", "drift_mark" }, -- 许愿树关注界面
  [Ui.UI_DRIFT_MINE] = { "drift_mine.ini", "drift_mine" }, -- 许愿树我发起
  [Ui.UI_DRIFT_REPLY] = { "drift_reply.ini", "drift_reply" }, -- 许愿树回复界面
  [Ui.UI_DRIFT_MINE_SHOW] = { "drift_mine_show.ini", "drift_mine_show" }, -- 许愿树显示界面
  [Ui.UI_DRIFT_MARK_SHOW] = { "drift_mark_show.ini", "drift_mark_show" }, -- 许愿树显示界面
  [Ui.UI_KINBATTLEREPORT] = { "kinbattlereport.ini", "kinbattlereport" }, -- 家族战战报
  [Ui.UI_ITEM_ASSIT] = { "itemassit.ini", "itemassit" }, -- 道具助手
  [Ui.UI_SNS_ENTRANCE] = { "sns_entrance.ini", "sns_entrance" }, -- 聊天栏旁的主界面入口按钮
  [Ui.UI_SNS_MAIN] = { "sns_main.ini", "sns_main" }, -- 发送主界面
  [Ui.UI_SNS_VERIFIER] = { "sns_verifier.ini", "sns_verifier" }, -- 授权码输入界面
  [Ui.UI_SNS_FOLLOW] = { "sns_follow.ini", "sns_follow" }, -- 推荐收听的界面
  [Ui.UI_SNS_AUTH_GUIDE1] = { "sns_auth_guide1.ini", "sns_auth_guide1" }, -- 授权引导界面1
  [Ui.UI_SNS_BROWSER] = { "sns_browser.ini", "sns_browser" }, -- 社交网络浏览器
  [Ui.UI_CAPTURE_SCREEN] = { "capture_screen.ini", "capture_screen" }, -- 截图操作界面
  [Ui.UI_PAYERFULI] = { "payerfuli.ini", "payerfuli" }, -- 充值优惠福利操作界面
  [Ui.UI_EQUIPHOLE] = { "equiphole.ini", "equiphole" }, -- 装备打孔操作界面
  [Ui.UI_SWITCH_PANEL] = { "switchpanel.ini", "switchpanel" }, --
  [Ui.UI_CHATFILTER] = { "chatfilter.ini", "chatfilter" }, -- 聊天频道过滤主界面
  [Ui.UI_SUPERBATTLE] = { "superbattle.ini", "superbattle" }, -- 跨服战场
  [Ui.UI_EXCHANGE_STONE] = { "exchangestone.ini", "exchangestone" }, -- 宝石兑换操作界面
  [Ui.UI_SETVICEPASSWORD] = { "setvicepassword.ini", "setvicepassword" }, -- 设置副密码
  [Ui.UI_TANABATABOOK] = { "tanabatabook.ini", "tanabatabook" }, --七夕书卷
  [Ui.UI_SPBATTLE_SIGNUP] = { "spbattle_signup.ini", "spbattle_signup" }, -- 跨服宋金报名界面
  [Ui.UI_SPBATTLE_TRANS] = { "spbattle_trans.ini", "spbattle_trans" }, -- 跨服宋金传送界面
  [Ui.UI_KIN_RECRUIT_PLAYERS] = { "kin_recruit_players.ini", "kin_recruit_players" },
  [Ui.UI_STALLSALESETTING] = { "stallsalesetting.ini", "stallsalesetting", 2 }, -- 摆摊贩卖界面
  [Ui.UI_STALLOFFERLIST] = { "stallofferlist.ini", "stallofferlist", 2 }, -- 贩卖清单
  [Ui.UI_OFFERBUYSETTING] = { "offerbuysetting.ini", "offerbuysetting", 2 }, -- 收购清单
  [Ui.UI_STALLMARKPRICE] = { "stallmarkprice.ini", "stallmarkprice", 2 },
  [Ui.UI_OTHER_EQUIP] = { "other_equip.ini", "other_equip", 2 }, -- 新UI备用/同伴装备界面
  [Ui.UI_EXPBAR] = { "expbar.ini", "expbar", 2 },
  [Ui.UI_SIDESYSBAR] = { "sidesysbar.ini", "sidesysbar", 2 },
  [Ui.UI_SCHOOLDEMO] = { "schooldemo.ini", "schooldemo" }, --门派技能展示
  [Ui.UI_ACCOUNT_LOGIN] = { "accountlogin.ini", "accountlogin" }, -- 帐号登录窗口
  [Ui.UI_MSG_PROCESSING] = { "msgprocessing.ini", "msgprocessing" }, -- 正在处理中的窗口
  [Ui.UI_SELECT_SERVER] = { "selectserver.ini", "selectserver" }, -- 选择服务器
  [Ui.UI_PKMODEL] = { "pkmodel.ini", "pkmodel", 2 }, -- pk模式
  [Ui.UI_RESTARTDOWNLOAD] = { "restartdownload.ini", "restartdownload" }, --重启download
  [Ui.UI_AUTOEQUIP] = { "autoequip.ini", "autoequip", 2 }, -- 自动穿装备
  [Ui.UI_SYSTEMEX] = { "systemex.ini", "systemex", 2 }, -- 系统设置
  [Ui.UI_XOYO_ASK] = { "xoyo_ask.ini", "xoyo_ask" }, -- 剑侠问问
  [Ui.UI_KEYTUTORIAL] = { "keytutorial.ini", "keytutorial", 2 }, -- 按键指引
  [Ui.UI_ENHANCESELECTEQUIP] = { "enhanceselectequip.ini", "enhanceselectequip", 2 }, -- 强化选择装备快捷方式
  [Ui.UI_EXITKINESCOPE] = { "exitkinescope.ini", "exitkinescope", 2 }, -- 退出观战
  [Ui.UI_LEVELUPGIFT] = { "levelupgift.ini", "levelupgift" }, -- 升级礼包
  [Ui.UI_ACTIVEGIFT] = { "activegift.ini", "activegift" }, -- 活跃礼包
  [Ui.UI_ACTIVEGETAWAED] = { "activegetaward.ini", "activegetaward" }, -- 领取活跃礼包奖励
  [Ui.UI_SELANDNEW_ROLE] = { "selectandnewrole.ini", "selectandnewrole" }, -- 选择和创建角色
  [Ui.UI_QUICK_REGISTER] = { "quickregister.ini", "quickregister" }, -- 快速注册帐号
  [Ui.UI_KINPLANTTASK] = { "kinplanttask.ini", "kinplanttask", 2 }, -- 家族种植公告板
  [Ui.UI_YY_UPDATE] = { "yyupdate.ini", "yyupdate" }, -- yy更新界面
  [Ui.UI_FULITEQUAN] = { "fulitequan.ini", "fulitequan" }, -- 福利特权
  [Ui.UI_NEWYEARBLESS] = { "newyearbless.ini", "newyearbless" }, -- 新年祝福
  [Ui.UI_THEMEMUSIC] = { "thememusic.ini", "thememusic" }, -- 主题曲面板
  [Ui.UI_PAYAWARD] = { "payaward.ini", "payaward" }, -- 充值促销活动
  [Ui.UI_KINREPOSITORY] = { "kinrepository.ini", "kinrepository" }, -- 家族仓库
  [Ui.UI_CARDAWARD] = { "cardaward.ini", "cardaward" }, -- 卡牌奖励
  [Ui.UI_SERIESKILL] = { "serieskill.ini", "serieskill" }, -- YY连斩特效
  [Ui.UI_EQUIPCOMPOSE] = { "equipcompose.ini", "equipcompose" }, -- 装备合成，整合后的装备强化等
  [Ui.UI_XUANJINGCOMPOSE] = { "xuanjingcompose.ini", "xuanjingcompose" }, -- 特权合玄独立界面
  [Ui.UI_KINREPRECORD] = { "kinreprecord.ini", "kinreprecord" }, -- 家族仓库记录
  [Ui.UI_LIMITTIME_NOTIFY] = { "limittimenotify.ini", "limittimenotify" }, -- 防沉迷通知框
  [Ui.UI_KINGAMESCREEN] = { "kingamescreen.ini", "kingamescreen" }, --家族竞技黑屏界面
  [Ui.UI_KIN_GET_SALARY] = { "kingetsalary.ini", "kingetsalary" }, --领取家族工资
  [Ui.UI_BONE_EDITOR] = { "boneeditor.ini", "boneeditor" }, -- 骨骼动画编辑器
  [Ui.UI_RELATIONNEW] = { "relationnew.ini", "relationnew" },
  [Ui.UI_CHOOSEPORTRAIT] = { "chooseportrait.ini", "chooseportrait" },
  [Ui.UI_RELATIONADDFRIEND] = { "relationaddfriend.ini", "relationaddfriend" },
  [Ui.UI_CHATNEWMSG] = { "chatnewmsg.ini", "chatnewmsg" }, --拖动滚动条时的最新消息
  [Ui.UI_GLOBAL_AREA] = { "global_area.ini", "global_area" }, --跨服战区
  [Ui.UI_AFFICHE] = { "affiche.ini", "affiche" }, -- 详细公告
  [Ui.UI_BADGE] = { "badge.ini", "badge" }, -- 家族徽章
  [Ui.UI_CHAHUA] = { "chahua.ini", "chahua" }, -- 插画
  [Ui.UI_NEWBATTLE] = { "newbattle.ini", "newbattle" }, -- 新宋金战场
  [Ui.UI_PRIMER_SHUXIN] = { "primershuxin.ini", "primershuxin" }, -- 新手任务书信
  [Ui.UI_FLASHPLAYER] = { "flashplayer.ini", "flashplayer" }, -- flash播放器
  [Ui.UI_CARRIEROFF] = { "carrieroff.ini", "carrieroff" }, --下车按钮
  [Ui.UI_VIEWWEALTHVALUE] = { "viewwealthvalue.ini", "viewwealthvalue" }, --下车按钮
  [Ui.UI_ACTIVECODE] = { "activecode.ini", "activecode" }, --填写激活码
  [Ui.UI_PLAYEREDITOR] = { "playereditor.ini", "playereditor" }, --	角色属性编辑窗口
  [Ui.UI_FUBEN_INFO] = { "fubeninfo.ini", "fubeninfo" }, -- pvp，pve界面
  [Ui.UI_EASY_PLAYERSTATE] = { "easyplayerstate.ini", "easyplayerstate", 2 }, -- 简易血条
  [Ui.UI_FULL_BACKGROUND] = { "fullbackground.ini", "fullbackground" }, -- 全屏效果ui，会覆盖整个屏幕，用户过场动画等
  [Ui.UI_ONLINEBANKPAY] = { "onlinebankpay.ini", "onlinebankpay" }, -- 活跃礼包
  [Ui.UI_NEWCALENDARVIEW] = { "newcalendarview.ini", "newcalendarview" }, -- 新日历
  [Ui.UI_NEWFUBENVIEW] = { "newfubenview.ini", "newfubenview" }, -- 新藏宝图副本
  [Ui.UI_COLLECTPHONEID] = { "collectphoneid.ini", "collectphoneid" }, -- 填写手机号
  [Ui.UI_BTNMSG] = { "btnmsg.ini", "btnmsg" }, -- 主界面按钮提示
  [Ui.UI_MESSAGEPUSHVIEW] = { "messagepushview.ini", "messagepushview" }, -- 消息推送
  [Ui.UI_TREASUREMAP] = { "treasuremap.ini", "treasuremap" }, -- 藏宝图系统UI
  [Ui.UI_REINCARNATE] = { "reincarnate.ini", "reincarnate" }, -- 重生界面
  [Ui.UI_LIVE800] = { "live800.ini", "live800" }, --live800
  [Ui.UI_JXSJKEJU] = { "jxsjkeju.ini", "jxsjkeju" }, -- 科举考试
  [Ui.UI_LUCKYFAN] = { "luckyfan.ini", "luckyfan" }, -- 幸运翻
}

function Ui:Output(...)
  print(unpack(arg))
end

function Ui:RegisterNewUiWindow(szUiGroupName, szClassName, tbUiMode1, tbUiMode2, tbUiMode3, tbUiMode4)
  if not UI_LIST then
    UI_LIST = {}
  end
  local szIniFileName = szClassName .. ".ini"
  local tbGroup = {}

  if not UI_LIST[szUiGroupName] then
    tbGroup = { szIniFileName, szClassName }
    Ui[szUiGroupName] = szUiGroupName
    UI_LIST[szUiGroupName] = tbGroup
  else
    tbGroup = UI_LIST[szUiGroupName]
  end

  LoadUiGroup(szUiGroupName, tbGroup[1])

  self:AddExWndConfig(szUiGroupName, tbUiMode1)
  self:AddExWndConfig(szUiGroupName, tbUiMode2)
  self:AddExWndConfig(szUiGroupName, tbUiMode3)
  if tbUiMode4 then -- 新加d模式，加个判断方便支持老插件
    self:AddExWndConfig(szUiGroupName, tbUiMode4)
  end
  self:LoadExWndConfig(szUiGroupName)

  if self.tbWnd[szUiGroupName] then
    self:Output('[WRN] [RegisterNewUiWindow] UIGROP "' .. szUiGroupName .. '" 重复定义！')
  end

  local tbClass = self.tbClass[tbGroup[2]]
  if not tbClass then
    self:Output('[ERR] [RegisterNewUiWindow] UIGROP "' .. szUiGroupName .. '" 类型 "' .. tbGroup[2] .. '"不存在！')
  else
    self.tbWnd[szUiGroupName] = {}
    local tbWnd = Lib:CopyTB1(tbClass) -- 创建窗口实例
    tbWnd.UIGROUP = szUiGroupName -- 为每个窗口表设置UIGROUP
    self.tbWnd[szUiGroupName] = tbWnd
    if tbWnd.Init then
      tbWnd:Init() -- 初始化
      if tbWnd.OnCreate then
        if tbWnd:OnCreate() == 0 then
          self:Output(szGroupName, "在创建OBJ时失败!")
          return
        end
      end

      if tbWnd.RegisterEvent then
        local tbReg = tbWnd:RegisterEvent()
        for _, tbEvent in pairs(tbReg) do
          UiNotify:RegistNotify(tbEvent[1], tbEvent[2], tbEvent[3] or tbWnd)
        end
      end
    end
  end
end

function Ui:AddExWndConfig(szUiGroupName, tbUiMode)
  if not self.tbExWndDia then
    self.tbExWndDia = {}
  end

  if not tbUiMode or not tbUiMode[1] then
    return
  end

  if not self.tbExWndDia[szUiGroupName] then
    self.tbExWndDia[szUiGroupName] = {}
  end
  self.tbExWndDia[szUiGroupName][tbUiMode[1]] = tbUiMode
end

function Ui:LoadExWndConfig(szUiGroupName)
  if not self.tbExWndDia or not self.tbExWndDia[szUiGroupName] then
    return 0
  end
  local szNowMode = GetUiMode()
  for szMode, tbMode in pairs(self.tbExWndDia[szUiGroupName]) do
    if szMode == szNowMode then
      if LoadWndConfig(szUiGroupName, tbMode[2], tbMode[3]) == 1 then
        return 1
      else
        self:Output('[ERROR] LoadWndConfig "' .. szUiGroupName .. '" 失败')
        return 0
      end
    end
  end
  return 0
end

function Ui:Init(nVersion, szMode) -- 程序回调接口，初始化UI
  self.nVersion = nVersion -- 设置UI版本
  self.szMode = szMode -- 设置UI模式
  self.nExitMode = self.EXITMODE_NONE -- 退出状态

  self.tbLogic = {} -- UI逻辑模块
  self.tbMgr = {} -- 窗口管理模块
  self.tbWnd = {} -- 窗口集合
  self.tbClass = {} -- 窗口类
  self.tbPluginInfoList = {} -- 插件信息
  self.tbExWndDia = {}

  --	Require(self.SCRIPT_PATH.."\\logic\\logic.lua");
  Require(self.SCRIPT_PATH .. "manager\\mgr.lua")

  local tbLogic = self.tbLogic
  local tbMgr = UiManager

  --	tbLogic:Init();
  --	tbMgr:Init();							-- 初始化UiManager
  self:PreLoad() -- 加载需要优先加载的脚本
  self:LoadPluginInfo()

  -- UI逻辑初始化，注意次序
  tbLogic.tbTempData:Init()
  tbLogic.tbTimer:Init()
  UiNotify:Init()
  tbLogic.tbObject:Init()
  tbLogic.tbSaveData:Init()
  tbLogic.tbTempItem:Init()
  tbLogic.tbMouse:Init()
  tbLogic.tbPopMgr:Init()
  tbLogic.tbMapBar:Init()
  tbLogic.tbMap:Init()
  tbLogic.tbHelp:Init()
  tbLogic.tbCalendar:Init()
  tbLogic.tbNewCalendar:Init()
  tbLogic.tbHealthy:Init()
  tbLogic.tbAgreementMgr:Init()
  tbLogic.tbPlayerState:Init()
  tbLogic.tbChannelOption:Init()
  tbLogic.tbPreViewMgr:Init()
  tbLogic.tbDaily:Init()
  tbLogic.tbAcutionLink:Init()
  tbLogic.tbViewPlayerMgr:Init()
  tbLogic.tbCoverMgr:Init()
  tbLogic.tbMsgChannel:Init()
  tbLogic.tbMusic:Init()
  tbLogic.tbMessagePush:Init()
  if self:LoadScript() ~= 1 then -- 加载所有界面逻辑功能脚本
    self:Output("[ERR] LoadScript failed!")
    return 0
  end

  self:NewWindows() -- 为成员窗口创建Lua表对象

  if self:CreateWnds() ~= 1 then -- 加载脚本中定义的所有窗口
    self:Output("[ERR] CreateWnds failed!")
    return 0
  end

  tbMgr:Init()
  tbMgr:RegistEvent() -- 注册所有事件响应函数
  self:AutoExec() -- 自动执行工作

  local tbLogin = Ui.tbLogic.tbLogin
  tbLogin:SetLoginWay(tbLogin.LOGINWAY_KS)

  return 1
end

function Ui:GetUiList()
  return UI_LIST
end

function Ui:UnInit() -- 程序回调接口，反初始化UI
  Ui.tbLogic.tbTimer:Clear(1) -- 关闭所有计时器
  self:DestoryWnds() -- 销毁所有窗口
end

function Ui:LoadScript()
  self:Output("[UI] 加载UI脚本...")
  if LoadUiScript() ~= 1 then
    return 0
  else
    self:Output("[UI] UI脚本加载成功！")
    return 1
  end
end

function Ui:CallCheckPlugin(fnFunc, ...)
  return self.tbCheckPlugin[fnFunc](self.tbCheckPlugin, ...)
end

function Ui:CallPreUpdate(fnFunc, ...)
  return self.tbLogic.tbPreUpdate[fnFunc](self.tbLogic.tbPreUpdate, ...)
end

function Ui:LoadPluginInfo()
  local tbNameList = KInterface.GetPluginNameList()
  self.tbPluginInfoList = {}
  if not tbNameList then
    return
  end
  local tbPluginInfoList = {}
  for _, szName in pairs(tbNameList) do
    local tbNameInfo = KInterface.GetPluginInfo(szName)
    tbNameInfo.szPathFileName = szName
    tbPluginInfoList[#tbPluginInfoList + 1] = tbNameInfo
  end
  self.tbPluginInfoList = tbPluginInfoList
end

function Ui:LoadPluginScript()
  if 0 == KInterface.GetPluginManagerLoadState() then
    return
  end

  for _, tbInfo in ipairs(self.tbPluginInfoList) do
    if tbInfo.nLoadState == 1 then
      if self:CheckPluginIsUse(tbInfo) == 1 then
        LoadScriptDir(tbInfo.szPluginPath)
      else
        tbInfo.nLoadState = 0
      end
    end
  end
end

function Ui:CheckPluginIsUse(tbPluginInfo)
  local tbInfo = self.tbPluginState[tbPluginInfo.szPluginName] or {}
  local nDate = tonumber(tbInfo[1]) or 0
  if nDate > 0 and nDate >= tbPluginInfo.nDate then
    -- 要求的修改时间 >= 插件修改时间
    return 0, tbInfo
  end
  return 1
end

function Ui:GetPluginDate(szDate)
  local tbDate = Lib:SplitStr(szDate, "-")
  if #tbDate ~= 3 then
    return 0
  end
  return Lib:GetDate2Time(tonumber(tbDate[1] .. tbDate[2] .. tbDate[3]))
end

function Ui:NewWindows()
  for i, v in pairs(UI_LIST) do
    if not v[3] or self:CheckVersion(v[3]) == 1 then
      if self.tbWnd[i] then
        self:Output('[WRN] UIGROP "' .. i .. '" 重复定义！')
      end
      local szClass = v[2]
      local tbClass = self.tbClass[szClass]
      if not tbClass then
        self:Output('[ERR] UIGROP "' .. i .. '" 类型 "' .. szClass .. '"不存在！')
      else
        local tbWnd = Lib:CopyTB1(tbClass) -- 创建窗口实例
        tbWnd.UIGROUP = i -- 为每个窗口表设置UIGROUP
        self.tbWnd[i] = tbWnd
        if tbWnd.Init then
          tbWnd:Init() -- 初始化
        end
      end
    end
  end
end

function Ui:CheckVersion(var)
  if type(var) == "number" then
    if var == UiVersion then
      return 1
    else
      return 0
    end
  elseif type(var) == "table" then
    for _, nVer in ipairs(var) do
      if nVer == UiVersion then
        return 1
      end
    end
  end
  return 0
end

function Ui:ReLoad(szFileName)
  DoScript(szFileName)
  if string.find(szFileName, "window\\") then
    local tbFilePath = Lib:SplitStr(szFileName, "\\")
    local szFileName = tbFilePath[#tbFilePath]

    local i, nLastPos = 0
    while true do
      i = string.find(szFileName, "%.", i + 1)
      if i == nil then
        break
      end
      nLastPos = i
    end

    local szClassName = string.sub(szFileName, 1, nLastPos - 1)

    local szGroupName = ""
    for szGroup, tbWnd in pairs(UI_LIST) do
      if tbWnd[2] == szClassName then
        szGroupName = szGroup
      end
    end

    for i, v in pairs(self.tbWnd) do
      if self.tbWnd[i] and (i == szGroupName) then
        self.tbWnd[i] = {}
        local tbClass
        for i, v in pairs(UI_LIST) do
          if i == szGroupName then
            local szClass = v[2]
            tbClass = self.tbClass[szClass]
            break
          end
        end
        local tbWnd = Lib:CopyTB1(tbClass)
        tbWnd.UIGROUP = i
        self.tbWnd[i] = tbWnd
        if tbWnd.Init then
          tbWnd:Init()
          if tbWnd.OnCreate then
            if tbWnd:OnCreate() == 0 then
              self:Output(szGroupName, "在创建OBJ时失败!")
              return 0
            end
          end

          if tbWnd.RegisterEvent then
            local tbReg = tbWnd:RegisterEvent()
            for _, tbEvent in pairs(tbReg) do
              UiNotify:RegistNotify(tbEvent[1], tbEvent[2], tbEvent[3] or tbWnd)
            end
          end
        end
        break
      end
    end
  end
  self:Output(szFileName .. "重载成功! ")
end

function Ui:CreateWnds()
  for i, tbWnd in pairs(self.tbWnd) do
    -- 遍历加载窗口
    LoadUiGroup(i, UI_LIST[i][1])
    if tbWnd.OnCreate then
      if tbWnd:OnCreate() == 0 then -- 创建
        self:Output('[ERR] 创建UIGROUP: "' .. i .. '" 失败！')
        return 0
      end
    end
  end
  if LoadWndConfig() ~= 1 then
    return 0 -- 加载wndconfig.ini失败
  end
  return 1
end

function Ui:DestoryWnds()
  for _, tbWnd in pairs(self.tbWnd) do
    if tbWnd and tbWnd.OnDestroy then
      tbWnd:OnDestroy() -- 销毁
    end
  end
end

function Ui:GetClass(szClass, bNotCreate)
  local tbClass = self.tbClass[szClass]
  if tbClass then
    return tbClass
  end
  if bNotCreate == 1 then
    return
  end
  local tbClass = {} -- 所有窗口类的基类
  self.tbClass[szClass] = tbClass
  return tbClass
end

-- 脚本的优先加载，该函数在界面初始化时由UiManager主动调用
function Ui:PreLoad()
  -- 顺序不可随意调整
  Require(self.SCRIPT_PATH .. "logic\\timer.lua")
  Require(self.SCRIPT_PATH .. "logic\\notify.lua")
  Require(self.SCRIPT_PATH .. "logic\\object.lua")
  Require(self.SCRIPT_PATH .. "logic\\mouse.lua")
  Require(self.SCRIPT_PATH .. "logic\\savedata.lua")
  Require(self.SCRIPT_PATH .. "logic\\shortcutalias.lua")
  Require(self.SCRIPT_PATH .. "logic\\tempitem.lua")
  Require(self.SCRIPT_PATH .. "logic\\tempdata.lua")
  Require(self.SCRIPT_PATH .. "logic\\msginfo.lua")
  Require(self.SCRIPT_PATH .. "logic\\confirm.lua")
  Require(self.SCRIPT_PATH .. "logic\\popmgr.lua")
  Require(self.SCRIPT_PATH .. "logic\\awardinfo.lua")
  Require(self.SCRIPT_PATH .. "logic\\mapbar.lua")
  Require(self.SCRIPT_PATH .. "logic\\map.lua")
  Require(self.SCRIPT_PATH .. "logic\\help.lua")
  Require(self.SCRIPT_PATH .. "logic\\healthy.lua")
  Require(self.SCRIPT_PATH .. "logic\\agreementmgr.lua")
  Require(self.SCRIPT_PATH .. "logic\\extbaglayout.lua")
  Require(self.SCRIPT_PATH .. "logic\\playerstate_logic.lua")
  Require(self.SCRIPT_PATH .. "logic\\previewmgr.lua")
  Require(self.SCRIPT_PATH .. "logic\\daily.lua")
  Require(self.SCRIPT_PATH .. "logic\\passpodtime.lua")
  Require(self.SCRIPT_PATH .. "logic\\auctionlink.lua")
  Require(self.SCRIPT_PATH .. "logic\\viewplayermgr.lua")
  Require(self.SCRIPT_PATH .. "logic\\covermgr.lua")
  Require(self.SCRIPT_PATH .. "logic\\msgchannel.lua")
  Require(self.SCRIPT_PATH .. "logic\\messagelist.lua")
  Require(self.SCRIPT_PATH .. "logic\\channeloption.lua")
  Require(self.SCRIPT_PATH .. "logic\\calendar.lua")
  Require(self.SCRIPT_PATH .. "logic\\login.lua")
  Require(self.SCRIPT_PATH .. "logic\\music.lua")
  Require(self.SCRIPT_PATH .. "logic\\newcalendar.lua")
  Require(self.SCRIPT_PATH .. "logic\\messagepush.lua")
end

-- 注册快捷键.....
function Ui:AutoExec()
  UiShortcutAlias:SetControlModel(1)

  RegisterFunctionAlias("join", "JoinTeam")
  RegisterFunctionAlias("加入", "JoinTeam")
  RegisterFunctionAlias("jr", "JoinTeam")
  RegisterFunctionAlias("增加", "JoinTeam")
  RegisterFunctionAlias("trade", "UiTrade")
  RegisterFunctionAlias("交易", "UiTrade")
  RegisterFunctionAlias("jy", "UiTrade")
  RegisterFunctionAlias("invite", "InviteTeam")
  RegisterFunctionAlias("邀请", "InviteTeam")
  RegisterFunctionAlias("yq", "InviteTeam")
  RegisterFunctionAlias("create", "me.CreateTeam()")
  RegisterFunctionAlias("组队", "me.CreateTeam()")
  RegisterFunctionAlias("zd", "me.CreateTeam()")

  local nSeries = 0
  SetPhrase(nSeries, "你在哪里？:S")
  nSeries = nSeries + 1
  SetPhrase(nSeries, "跟我来！:K")
  nSeries = nSeries + 1
  SetPhrase(nSeries, "大伙一起上啊，人多力量大！:F")
  nSeries = nSeries + 1
  SetPhrase(nSeries, "危险，快逃！:$")
  nSeries = nSeries + 1
  SetPhrase(nSeries, "快帮我加血！:M")
  nSeries = nSeries + 1
  if UiManager.IVER_nPhraseOpen == 0 then
    SetPhrase(nSeries, "有没有人一起组队？我还单身呢。^o^")
    nSeries = nSeries + 1
  end
  SetPhrase(nSeries, "街坊邻居快来看啊，刚出炉的装备道具大拍卖啊。:E")
  nSeries = nSeries + 1
  SetPhrase(nSeries, "你是哪里人，多少级了？:o")
  nSeries = nSeries + 1
  if UiManager.IVER_nPhraseOpen == 0 then
    SetPhrase(nSeries, "嘿，哥们姐们老少爷们！哪位手头宽裕的赏在下俩钱儿！:)")
    nSeries = nSeries + 1
  end
  SetPhrase(nSeries, "在下初到宝地，人生地不熟，还请各位关照则个！:I")
  nSeries = nSeries + 1

  RegisterFunctionAlias("88", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "7")
  RegisterFunctionAlias("an", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "34")
  RegisterFunctionAlias("bf", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "103")
  RegisterFunctionAlias("ca", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "82")
  RegisterFunctionAlias("dd", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "48")
  RegisterFunctionAlias("gf", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "105")
  RegisterFunctionAlias("gg", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "47")
  RegisterFunctionAlias("hi", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "8")
  RegisterFunctionAlias("jj", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "42")
  RegisterFunctionAlias("jx", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "39")
  RegisterFunctionAlias("lv", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "50")
  RegisterFunctionAlias("mm", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "43")
  RegisterFunctionAlias("ok", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "87")
  RegisterFunctionAlias("pk", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "36")
  RegisterFunctionAlias("beg", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "9")
  RegisterFunctionAlias("bow", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "1")
  RegisterFunctionAlias("bug", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "55")
  RegisterFunctionAlias("bye", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "5")
  RegisterFunctionAlias("cry", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "17")
  RegisterFunctionAlias("cut", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "78")
  RegisterFunctionAlias("die", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "41")
  RegisterFunctionAlias("esc", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "35")
  RegisterFunctionAlias("gao", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "109")
  RegisterFunctionAlias("han", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "38")
  RegisterFunctionAlias("hmm", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "100")
  RegisterFunctionAlias("hua", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "63")
  RegisterFunctionAlias("hug", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "79")
  RegisterFunctionAlias("inn", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "102")
  RegisterFunctionAlias("lun", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "57")
  RegisterFunctionAlias("nod", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "52")
  RegisterFunctionAlias("pat", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "27")
  RegisterFunctionAlias("pen", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "66")
  RegisterFunctionAlias("tan", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "11")
  RegisterFunctionAlias("thx", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "86")
  RegisterFunctionAlias("wen", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "44")
  RegisterFunctionAlias("zzz", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "88")
  RegisterFunctionAlias("18mo", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "28")
  RegisterFunctionAlias("aisi", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "117")
  RegisterFunctionAlias("aiyi", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "26")
  RegisterFunctionAlias("buxx", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "32")
  RegisterFunctionAlias("chou", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "108")
  RegisterFunctionAlias("gone", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "101")
  RegisterFunctionAlias("haha", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "6")
  RegisterFunctionAlias("hero", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "98")
  RegisterFunctionAlias("idle", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "70")
  RegisterFunctionAlias("jiar", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "37")
  RegisterFunctionAlias("jidu", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "15")
  RegisterFunctionAlias("joke", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "45")
  RegisterFunctionAlias("jump", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "72")
  RegisterFunctionAlias("jush", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "104")
  RegisterFunctionAlias("kick", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "4")
  RegisterFunctionAlias("kill", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "116")
  RegisterFunctionAlias("kiss", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "3")
  RegisterFunctionAlias("lean", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "2")
  RegisterFunctionAlias("lick", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "25")
  RegisterFunctionAlias("love", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "118")
  RegisterFunctionAlias("mapi", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "94")
  RegisterFunctionAlias("miss", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "56")
  RegisterFunctionAlias("poke", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "113")
  RegisterFunctionAlias("poor", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "67")
  RegisterFunctionAlias("puke", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "22")
  RegisterFunctionAlias("qiao", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "30")
  RegisterFunctionAlias("reny", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "123")
  RegisterFunctionAlias("rose", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "21")
  RegisterFunctionAlias("shiw", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "122")
  RegisterFunctionAlias("sigh", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "23")
  RegisterFunctionAlias("sing", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "121")
  RegisterFunctionAlias("slap", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "12")
  RegisterFunctionAlias("spit", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "14")
  RegisterFunctionAlias("taoy", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "81")
  RegisterFunctionAlias("wink", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "62")
  RegisterFunctionAlias("wosh", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "10")
  RegisterFunctionAlias("wuwu", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "119")
  RegisterFunctionAlias("ysis", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "89")
  RegisterFunctionAlias("zany", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "75")
  RegisterFunctionAlias("zhen", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "124")
  RegisterFunctionAlias("agree", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "92")
  RegisterFunctionAlias("baoch", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "65")
  RegisterFunctionAlias("baohu", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "53")
  RegisterFunctionAlias("bihua", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "51")
  RegisterFunctionAlias("blush", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "97")
  RegisterFunctionAlias("chuqi", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "74")
  RegisterFunctionAlias("crazy", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "84")
  RegisterFunctionAlias("dadao", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "31")
  RegisterFunctionAlias("dagun", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "106")
  RegisterFunctionAlias("dajie", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "91")
  RegisterFunctionAlias("daxia", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "58")
  RegisterFunctionAlias("doubt", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "33")
  RegisterFunctionAlias("drink", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "83")
  RegisterFunctionAlias("duish", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "59")
  RegisterFunctionAlias("dunno", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "110")
  RegisterFunctionAlias("duobu", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "115")
  RegisterFunctionAlias("fadai", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "24")
  RegisterFunctionAlias("faint", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "29")
  RegisterFunctionAlias("fangq", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "76")
  RegisterFunctionAlias("gaosh", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "111")
  RegisterFunctionAlias("gongx", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "69")
  RegisterFunctionAlias("happy", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "68")
  RegisterFunctionAlias("hengx", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "80")
  RegisterFunctionAlias("jingy", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "93")
  RegisterFunctionAlias("kaolv", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "114")
  RegisterFunctionAlias("laugh", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "46")
  RegisterFunctionAlias("lover", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "60")
  RegisterFunctionAlias("marry", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "90")
  RegisterFunctionAlias("match", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "54")
  RegisterFunctionAlias("meinv", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "96")
  RegisterFunctionAlias("paima", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "120")
  RegisterFunctionAlias("peace", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "71")
  RegisterFunctionAlias("point", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "40")
  RegisterFunctionAlias("polan", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "112")
  RegisterFunctionAlias("shuai", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "49")
  RegisterFunctionAlias("sleep", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "13")
  RegisterFunctionAlias("smell", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "19")
  RegisterFunctionAlias("smile", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "0")
  RegisterFunctionAlias("sorry", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "16")
  RegisterFunctionAlias("stuff", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "20")
  RegisterFunctionAlias("swear", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "107")
  RegisterFunctionAlias("thank", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "85")
  RegisterFunctionAlias("visit", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "95")
  RegisterFunctionAlias("wanfu", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "99")
  RegisterFunctionAlias("wangy", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "64")
  RegisterFunctionAlias("weiqu", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "73")
  RegisterFunctionAlias("wuchi", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "18")
  RegisterFunctionAlias("xiaox", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "77")
  RegisterFunctionAlias("xiezi", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "125")
  RegisterFunctionAlias("zhich", "SayEmote", 3, "GetRecentPlayerName()", "GetCurrentChannelName()", "61")
end

function Ui:GetUiGroupNameByIni(szFile) -- TODO: xyf 垃圾东西，以后要弄掉
  for i, v in pairs(UI_LIST) do
    if v[1] == szFile then
      return i
    end
  end
  local szTmpName = "UiEditor"
  LoadUiGroup(szTmpName, szFile, szTmpName) -- 列表中没有，说明为没加载
  return szTmpName
end

function Ui:EnterGame()
  self.nExitMode = self.EXITMODE_NONE
  local tbLogic = self.tbLogic
  local tbMgr = UiManager
  --	tbLogic:OnEnterGame();

  tbLogic.tbMsgInfo:Init()
  tbLogic.tbSaveData:LoadSetting()
  tbLogic.tbHealthy:OnEnterGame()
  tbLogic.tbHelp:OnEnterGame()
  tbLogic.tbCalendar:OnEnterGame()
  tbLogic.tbAutoFightData:Load()
  tbLogic.tbExtBagLayout:Init()
  tbLogic.tbPassPodTime:Init()
  tbMgr:OnEnterGame()
  Ui.tbLogic.tbChannelOption:LoadOption()
  tbLogic.tbPreUpdate:OnEnterGame()
  if Ui.tbLogic.tbInstallLog and Ui.tbLogic.tbInstallLog.ReportInstallInfo then
    Ui.tbLogic.tbInstallLog:ReportInstallInfo()
  end
end

function Ui:LeaveGame()
  local tbLogic = self.tbLogic
  local tbMgr = UiManager
  tbMgr:OnLeaveGame()
  --	tbLogic:OnLeaveGame();
  tbLogic.tbExtBagLayout:Init()
  tbLogic.tbAutoFightData:Init()
  tbLogic.tbHelp:OnLeaveGame()
  tbLogic.tbCalendar:OnLeaveGame()
  tbLogic.tbHealthy:OnLeaveGame()
  tbLogic.tbMsgInfo:Clear() -- 清除消息队列
  tbLogic.tbTempData:Init() -- 清除窗口临时数据
  tbLogic.tbMouse:Clear() -- 清除鼠标
  tbLogic.tbTempItem:Clear() -- 清除临时道具
  --	tbLogic.tbTimer:Clear();			-- 清除常规计时器
  tbLogic.tbPassPodTime:Clear()
  tbLogic.tbPopMgr:OnClear()
  self.nExitMode = self.EXITMODE_NONE
end

function Ui:SetExitMode(nExitMode)
  self.nExitMode = nExitMode
end

function Ui:Disconnect()
  local nExitMode = self.nExitMode
  self.nExitMode = self.EXITMODE_NONE
  if nExitMode == self.EXITMODE_NONE then
    UiManager:OpenWindow(Ui.UI_DISCONNECT)
  elseif nExitMode == self.EXITMODE_SELSVR then
    SetLoginStatus(self.tbLogic.tbLogin.emLOGINSTATUS_IDLE)
  elseif nExitMode == self.EXITMODE_DEAD then
    SetLoginStatus(self.tbLogic.tbLogin.emLOGINSTATUS_DEAD)
  elseif nExitMode == self.EXITMODE_RELOGIN then
    -- 开启定时器，定时1.5秒后重新登录
    self.nTimerId = Ui.tbLogic.tbTimer:Register(Env.GAME_FPS, self.OnTimer, self)
  end
end

-- TODO: xyf 临时的东东，让服务器直接调用窗口函数。。。。。
function Ui:ServerCall(szUiGroup, szFunction, ...)
  local tbClass = self(szUiGroup)
  if not tbClass then
    return
  end
  local fn = tbClass[szFunction]
  if not fn then
    return
  end
  fn(tbClass, unpack(arg))
end

function Ui:CheckLua()
  local s = "a string with \r and \n and \r\n and \n\r"
  local c = string.format("return %q", s)
  assert(assert(loadstring(c))() == s)
end

function Ui:OpenDebugMode()
  self.DebugMode = 1
end

-- add by zhangzhixiong
function Ui:SendVicePasswordToServer(szPasswordDifference)
  me.CallServerScript({ "ProcessVicePasswordSetting", szPasswordDifference })
end
-- end

-- 登录过程的事件，状态机事件
function Ui:LoginEvent(nEventId, nP1, nP2, nP3)
  self.tbLogic.tbLogin:OnEvent(nEventId, nP1, nP2, nP3)
end

-- 定时更新服务器信息
function Ui:OnTimer()
  if self.nTimerId > 0 then
    Ui.tbLogic.tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  local bRet = AccountLoginSecret()
  if bRet == 0 then
    local tbLoginLogic = Ui.tbLogic.tbLogin
    local tbMsg = { szMsg = "重新登录失败：未知原因", tbOptTitle = { "确定" }, Callback = tbLoginLogic.OnGameIdle, CallbackSelf = tbLoginLogic }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    return
  end
end

function Ui:YyUpdate_Text(szText)
  local uiWnd = Ui(Ui.UI_YY_UPDATE)
  if not uiWnd then
    return
  end
  uiWnd:YyUpdate_Text(szText)
end

function Ui:YyUpdate_State(nCurSize, nMaxSize)
  local uiWnd = Ui(Ui.UI_YY_UPDATE)
  if not uiWnd then
    return
  end
  uiWnd:YyUpdate_State(nCurSize, nMaxSize)
end

function Ui:YyUpdate_Result(nResult)
  local uiWnd = Ui(Ui.UI_YY_UPDATE)
  if not uiWnd then
    return
  end
  uiWnd:YyUpdate_Result(nResult)
end

-- yy登录前进行一些必要的检测
function Ui:PreYyLogin()
  local uiWnd = Ui(Ui.UI_ACCOUNT_LOGIN)
  if not uiWnd then
    return 0
  end
  return uiWnd:PreYyLogin()
end

-- YY登录超时
function Ui:YyLoginFail(nErrCode)
  local uiWnd = Ui(Ui.UI_ACCOUNT_LOGIN)
  if not uiWnd then
    return 0
  end
  return uiWnd:YyLoginFail(nErrCode)
end

function Ui:ApplyOpenSelectedLadder(nPage, nGenre, nSubject)
  UiManager:OpenWindow(Ui.UI_LADDER, nPage, nGenre)
  local tb = Ui(Ui.UI_LADDER)
  local bChangeSubject = 0
  for i, v in pairs(tb.tbCurSubjectMapList or {}) do
    if v == nSubject then
      tb.nCurSubjectIndex = i
      bChangeSubject = 1
      break
    end
  end

  if bChangeSubject then
    tb:UpdateSubject()
    tb:OnRefresh()
  end
end
-- 新建角色首次登录，服务器调用
function Ui:OnPlayMovie(bFirstLogin)
  local bFadeOut = 1
  if bFirstLogin == 1 then -- 第一次登陆有特殊处理
    bFadeOut = 0
  end
  UiManager:OpenWindow("UI_FLASHPLAYER", "\\image\\ui\\002a\\flash\\gamemovie_index.swf", "\\image\\ui\\002a\\flash\\mp4\\cg1.mp4", 0, 0, bFadeOut, 3000)
  local uiWnd = Ui(Ui.UI_FLASHPLAYER)
  if not uiWnd then
    return
  end
  uiWnd:RegisterCompleteCallback({ fnCallback = self.OnFlashComplete, fnSelf = self, tbArg = { bFirstLogin } })
  --uiWnd:SetCanSkip(0);
  StopMapMusic()
  SetTipsEnable(0)
end

function Ui:OnFlashComplete(bFirstLogin)
  -- 这里显示一个淡出的桃溪镇标记
  if bFirstLogin == 0 then -- 不是第一次登陆，流程完毕
    ResumeMapMusic()
    SetTipsEnable(1)
  else
    UiManager:OpenWindow("UI_FULL_BACKGROUND", "\\image\\ui\\002a\\flash\\taoxizhen.spr")
    local uiWnd = Ui(Ui.UI_FULL_BACKGROUND)
    if not uiWnd then
      return
    end
    uiWnd:RegisterCompleteCallback({ fnCallback = self.OnFullBackGroundComplete, fnSelf = self, tbArg = { bFirstLogin } })
    --uiWnd:SetCanSkip(0);
  end
end

function Ui:OnFullBackGroundComplete(bFirstLogin)
  me.CallServerScript({ "OnCompleteOpenMovie" })
  ResumeMapMusic()
  SetTipsEnable(1)
end

------------------------------------------------------------------------------------------
