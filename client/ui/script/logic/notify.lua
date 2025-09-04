-----------------------------------------------------
--文件名		：	uinotify.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-06-25
--功能描述		：	界面事件。
------------------------------------------------------

-- 消息类型枚举，与Coreshell.h中的KE_COREEVENT枚举值必须一致，
-- 否则界面不能正确响应Core抛出的事件
UiNotify.emCOREEVENT_SYNC_SERIES = 0
UiNotify.emCOREEVENT_SYNC_LEVEL = 1
UiNotify.emCOREEVENT_SYNC_FACTION = 2
UiNotify.emCOREEVENT_SYNC_PKVALUE = 3
UiNotify.emCOREEVENT_SYNC_EXP = 4
UiNotify.emCOREEVENT_SYNC_LIFE = 5
UiNotify.emCOREEVENT_SYNC_MANA = 6
UiNotify.emCOREEVENT_SYNC_STAMINA = 7
UiNotify.emCOREEVENT_SYNC_GTP = 8
UiNotify.emCOREEVENT_SYNC_MKP = 9
UiNotify.emCOREEVENT_SYNC_RESIST = 10
UiNotify.emCOREEVENT_SYNC_DAMAGE = 11
UiNotify.emCOREEVENT_SYNC_ATTACKRATE = 12
UiNotify.emCOREEVENT_SYNC_ATTACKSPEED = 13
UiNotify.emCOREEVENT_SYNC_DEFENSE = 14
UiNotify.emCOREEVENT_SYNC_RUNSPEED = 15
UiNotify.emCOREEVENT_SYNC_POTENTIAL = 16
UiNotify.emCOREEVENT_SYNC_REMAIN = 17
UiNotify.emCOREEVENT_SYNC_REPUTE = 18
UiNotify.emCOREEVENT_SYNC_TITLE = 19
UiNotify.emCOREEVENT_SYNC_PORTRAIT = 20
UiNotify.emCOREEVENT_SYNC_RUNSTATUS = 21
UiNotify.emCOREEVENT_SYNC_RIDEHORSE = 22
UiNotify.emCOREEVENT_SYNC_DOING = 23
UiNotify.emCOREEVENT_SYNC_STATE = 24
UiNotify.emCOREEVENT_SYNC_LIFESKILL = 25
UiNotify.emCOREEVENT_SYNC_RECIPE = 26
UiNotify.emCOREEVENT_SYNC_ITEM = 27
UiNotify.emCOREEVENT_DORECIPE_SUCCESS = 28
UiNotify.emCOREEVENT_DORECIPE_FAIL = 29
UiNotify.emCOREEVENT_MAIL_LOADED = 30
UiNotify.emCOREEVENT_MAIL_SENDOK = 31
UiNotify.emCOREEVENT_MAIL_SENDFAIL = 32
UiNotify.emCOREEVENT_MAIL_NEWMAIL = 33
UiNotify.emCOREEVENT_TALK = 34
UiNotify.emCOREEVENT_PROGRESSBAR_TIMER = 35
UiNotify.emCOREEVENT_BUFF_CHANGE = 36
UiNotify.emCOREEVENT_FIGHT_SKILL_CHANGED = 37 -- 左右键技能改变
UiNotify.emCOREEVENT_FIGHT_SKILL_POINT = 38 -- 战斗技能点改变
UiNotify.emCOREEVENT_ACTIVE_WINDOW = 39
UiNotify.emCOREEVENT_DISCONNECTED_SERVER = 40
UiNotify.emCOREEVENT_SYNC_PK_MODEL = 44
UiNotify.emCOREEVENT_PREPARE_ITEMREPAIR = 45
UiNotify.emCOREEVENT_TRADE_REQUEST = 46
UiNotify.emCOREEVENT_TRADE_RESPONSE = 47
UiNotify.emCOREEVENT_TRADE_TRADING = 48
UiNotify.emCOREEVENT_TRADE_LOCK = 49
UiNotify.emCOREEVENT_TRADE_CONFIRM = 50
UiNotify.emCOREEVENT_TRADE_END = 51
UiNotify.emCOREEVENT_OPEN_REPOSITORY = 55
UiNotify.emCOREEVENT_EXTREPSTATE_CHANGED = 56
UiNotify.emCOREEVENT_MONEY_CHANGED = 57
UiNotify.emCOREEVENT_SYNC_TEACHER_LIST = 58
UiNotify.emCOREEVENT_SYNC_STUDENT_LIST = 59
UiNotify.emCOREEVENT_SYNC_RELATION_LIST = 62
UiNotify.emCOREEVENT_DELETE_RELATION = 63
UiNotify.emCOREEVENT_SYNC_RELATION_INFO = 64
UiNotify.emCOREEVENT_SYNC_TRAINING_OPTION = 65
UiNotify.emCOREEVENT_SYNC_MAIL_LIST = 66
UiNotify.emCOREEVENT_SELF_CHECKIN_TIME = 67
UiNotify.emCOREEVENT_STUDENT_CHECKIN_TIME = 68
UiNotify.emCOREEVENT_KIN_BASE_INFO = 69
UiNotify.emCOREEVENT_KIN_MEMBER_DATA = 70
UiNotify.emCOREEVENT_PROGRESSBAR_ACROSSPERCENT = 71
UiNotify.emCOREEVENT_SYNC_SELECT_NPC = 72
UiNotify.emCOREEVENT_TRAINING_APPLYFORTEACHER = 73
UiNotify.emCOREEVENT_TEAM_MEMBER_CHANGED = 74
UiNotify.emCOREEVENT_TONG_BASE_INFO = 75
UiNotify.emCOREEVENT_TONG_ALL_KIN_INFO = 76
UiNotify.emCOREEVENT_TONG_FIGURE_INFO = 77
UiNotify.emCOREEVENT_TONG_ANNOUNCE_INFO = 78
UiNotify.emCOREEVENT_IBSHOP_SYNWARELIST = 79
UiNotify.emCOREEVENT_IBSHOP_SYNWARECOUNT = 80
UiNotify.emCOREEVENT_IBSHOP_BUYFAILURE = 81
UiNotify.emCOREEVENT_IBSHOP_BUYSUCCESS = 82
UiNotify.emCOREEVENT_IBSHOP_OPENWINDOW = 83
UiNotify.emCOREEVENT_IBSHOP_CLOSEWINDOW = 84
UiNotify.emCOREEVENT_IBSHOP_REDUCEPAGECOUNT = 85
UiNotify.emCOREEVENT_MAIL_FETCHITEMOK = 86 -- 成功获取信件物品
UiNotify.emCOREEVENT_MAIL_FETCHMONEYOK = 87 -- 成功获取信件金钱
UiNotify.emCOREEVENT_RELATION_UPDATEPANEL = 88 -- 好友列表的更新
UiNotify.emCOREEVENT_RELATION_REFRESHTRAIN = 89 -- 师徒关系列表更新
UiNotify.emCOREEVENT_RELATION_ONLINE = 90 -- 通知好友上线
UiNotify.emCOREEVENT_RELATION_DELFRIENDFAVOR = 91 -- 删除好友好感度
UiNotify.emCOREEVENT_SHOW_MAILCONTENT = 95 -- 显示信件内容
UiNotify.emCOREEVENT_SYNC_CDTYPE = 96 -- CD时间类型状态改变
UiNotify.emCOREEVENT_CAST_FIGHTSKILL = 98 -- 释放一个战斗技能
UiNotify.emCOREEVENT_GET_CURE = 99 -- 有人企图使自己复活
UiNotify.emCOREEVENT_ITEMGIFT_OPEN = 100 -- 打开给予界面
UiNotify.emCOREEVENT_ADDLIFESKILL = 101 -- 添加一个新的生活技能
UiNotify.emCOREEVENT_DELLIFESKILL = 102 -- 删除指定生活技能
UiNotify.emCOREEVENT_CHANGELIFESKILLLEVEL = 103 -- 改变生活技能等级
UiNotify.emCOREEVENT_CHANGELIFESKILLEXP = 104 -- 改变生活技能经验
UiNotify.emCOREEVENT_ADDRECIPE = 105 -- 增加一个配方
UiNotify.emCOREEVENT_DELRECIPE = 106 -- 删除一个配方
UiNotify.emCOREEVENT_TASK_ACCEPT = 107 -- 接收到一个任务
UiNotify.emCOREEVENT_TASK_AWARD = 108 -- 接收到一个任务奖励
UiNotify.emCOREEVENT_TASK_REFRESH = 109 -- 更新任务
UiNotify.emCOREEVENT_TASK_TRACK = 110 -- 追踪任务
UiNotify.emCOREEVENT_TASK_SHOWBOARD = 111 -- 触发任务大标题公告
UiNotify.emCOREEVENT_TASK_SKIP = 112 -- 跳过一个任务 param1=nTaskId param2=nRefId
UiNotify.emCOREEVENT_TASK_SKIPAWARD = 113 --
UiNotify.emCOREEVENT_SET_POPTIP = 120 -- 设置泡泡显示
UiNotify.emCOREEVENT_CANCEL_POPTIP = 121 -- 取消泡泡显示
UiNotify.emCOREEVENT_NEWS_MSG = 122 -- 世界新闻
UiNotify.emCOREEVENT_SYNC_POSITION = 123 -- 坐标发生变化（角色移动）
UiNotify.emCOREEVENT_SYNC_CURRENTMAP = 124 -- 角色所在地图发生变化
UiNotify.emCOREEVENT_SYNC_CAMPAIGN_DATE = 125 -- 同步活动数据（如宋金等）
UiNotify.emCOREEVENT_SYNC_SEX = 126 -- 角色性别变化
UiNotify.emCOREEVENT_SYNC_ROUTE = 127 -- 路线发生改变
UiNotify.emCOREEVENT_ENHANCE_OPEN = 130 -- 打开强化界面
UiNotify.emCOREEVENT_ENHANCE_RESULT = 131 -- 强化结果通知
UiNotify.emCOREEVENT_BREAKUP_RESULT = 132 -- 拆解结果通知
UiNotify.emCOREEVENT_UPDATE_PLAYERBILLINFO = 133 -- 更新角色自己的信息
UiNotify.emCOREEVENT_UPDATE_SHOWBILLLIST = 134 -- 更新交易所交易单列表
UiNotify.emCOREEVENT_PLAYER_DEATH = 135
UiNotify.emCOREEVENT_STOPLOGOUT = 136
UiNotify.emCOREEVENT_KINHISTORY = 137 -- 更新家族历史
UiNotify.emCOREEVENT_TONGHISTORY = 138 -- 更新帮会历史
UiNotify.emCOREEVENT_KINRECRUITMENT = 139 -- 更新家族招募申请人数据
UiNotify.emCOREEVENT_KINRECRUITMENT_STATE = 140 -- 更新家族招募状态
UiNotify.emCOREEVENT_KINRECRUITMENT_LIST = 141 -- 更新招募的家族列表
UiNotify.emCOREEVENT_TEAM = 181
UiNotify.emCOREEVENT_TEAM_SEARCH_INFO = 182
UiNotify.emCOREEVENT_SELF_SEARCH_INFO = 183
UiNotify.emCOREEVENT_TEAM_DISABLE_STATE = 184
UiNotify.emCOREEVENT_NPC_TRADE = 185
UiNotify.emCOREEVENT_UI_ACTION_NOTIFY = 186
UiNotify.emCOREEVENT_BUY_FROM_STALL = 187
UiNotify.emCOREEVENT_SELL_FROM_OFFER = 188
UiNotify.emCOREEVENT_SWITCH_STALL = 189
UiNotify.emCOREEVENT_SWITCH_OFFER = 190
UiNotify.emCOREEVENT_STALL_INPUT_ADV = 191
UiNotify.emCOREEVENT_OFFER_INPUT_ADV = 192
UiNotify.emCOREEVENT_CLOSE_STALL = 193
UiNotify.emCOREEVENT_CLOSE_OFFER = 194
UiNotify.emCOREEVENT_TEAM_SHARE_RESPONSE = 195
UiNotify.emCOREEVENT_PLAYER_REVIVE = 196
UiNotify.emCOREEVENT_SYNCLIFE_SKILL = 197
UiNotify.emCOREEVENT_DORECIPE_RESULT = 198
UiNotify.emCOREEVENT_STOPPRODUCE = 199
UiNotify.emCOREEVENT_STOPPROCESSTAG = 200
UiNotify.emCOREEVENT_STOPGENERALPROCESS = 201
UiNotify.emCOREEVENT_UI_INPUT = 202 -- 打开输入界面
UiNotify.emCOREEVENT_JBCOIN_CHANGED = 203 -- 金币数改变
UiNotify.emCOREEVENT_VIEWPLAYER = 204 -- 打开查看他人信息界面
UiNotify.emCOREEVENT_ANGEREVENT = 205 -- 同步怒气事件
UiNotify.emCOREEVENT_SETANGEREVENT = 206 -- 绘制怒气槽
UiNotify.emCOREEVENT_LADDERREFRESH = 207 -- 排行榜刷新
UiNotify.emCOREEVENT_OPEN_KINCREATE = 208 -- 打开创建家族界面
UiNotify.emCOREEVENT_OPEN_TONGCREATE = 209 -- 打开创建帮会界面
UiNotify.emCOREEVENT_CONFIRMATION = 210 -- 确认消息
UiNotify.emCOREEVENT_SYSTEM_MESSAGE = 211 -- 系统消息
UiNotify.emCOREEVENT_SYSTEM_MESSAGE = 211 -- 系统消息
UiNotify.emCOREEVENT_STOP_AUTOPATH = 212 -- 场景中响应了自动寻路
UiNotify.emCOREEVENT_SYNC_MAKEPRICE = 213 -- 标过价之后刷新背包
UiNotify.emCOREEVENT_SYNC_BINDCOINANDMONEY = 214 -- 绑定金币或银两的刷新
UiNotify.emCOREEVENT_CHANGEWAITGETITEMSTATE = 215 -- 改变等待获取物品的状态
UiNotify.emCOREEVENT_SYNC_LOCK = 216 -- 同步帐号锁定事件
UiNotify.emCOREEVENT_START_AUTOPATH = 217 -- 开始自动寻路事件
UiNotify.emCOREEVENT_SYNC_PRESTIGE = 218

UiNotify.emCOREEVENT_REPORT_SOMEONE = 219 -- 举报某人
UiNotify.emCOREEVENT_SYNC_MAP_HIGHLIGHT = 220 -- 发送特殊显示的NPC亮点 如宋金大将
UiNotify.emCOREEVENT_SYNC_BLOGINFO = 221
UiNotify.emCOREEVENT_SYNC_AUCTION_RET = 222
UiNotify.emCOREEVENT_HONORDATAREFRESH = 223 -- 刷新荣誉值
UiNotify.emCOREEVENT_LADDERSEARCHREFRESH = 224
UiNotify.emCOREEVENT_UPDATEBANKINFO = 225 -- 更新钱庄的金币区和银两区信息
UiNotify.emCOREEVENT_KIN_ACTION_INFO = 226 -- 更新家族活动信息
UiNotify.emCOREEVENT_CHANGE_FACTION_FINISHED = 227 -- 转门派成功
UiNotify.emCOREEVENT_SYNC_DOMAININFO = 228 -- 刷新领土争夺信息
UiNotify.emCOREEVENT_SYNC_DOMAINREPORT = 229
UiNotify.emCOREEVENT_CHANGEACTIVEAURA = 230
UiNotify.emCOREEVENT_LADDERPLANREFRESH = 231
UiNotify.emCOREEVENT_VIEW_NPC_SKILL = 232
UiNotify.emCOREEVENT_COVER_BEGIN = 233
UiNotify.emCOREEVENT_COVER_END = 234
UiNotify.emCOREEVENT_UPDATEONLINEEXPSTATE = 235
UiNotify.emCOREEVENT_IBSHOP_PAYURL = 236 -- zjq add 09.2.23	GS给client的付费URL 盛大模式用
UiNotify.emCOREEVENT_KIN_PLATFORM_INFO = 237 -- 更新家族平台
UiNotify.emCOREEVENT_GROUP_UPDATE = 238 --战队列表更新
UiNotify.emCOREEVENT_USESKLL_FAILED = 239 --使用技能失败

UiNotify.emCOREEVENT_CHAT_CHANNEL = 240
UiNotify.emCOREEVENT_OPEN_CHANNEL = 241
UiNotify.emCOREEVENT_CHAT_SEND_MSG_CHANNEL = 242
UiNotify.emCOREEVENT_CHAT_SOMEONE = 243
UiNotify.emCOREEVENT_CHAT_OPEN_DYNCHANNEL = 244
UiNotify.emCOREEVENT_CHAT_DYNCHANNEL = 245
UiNotify.emCOREEVENT_CHAT_CLOSE_DYNCHANNEL = 246
UiNotify.emCOREEVENT_SYNC_TIREDTIME = 247 -- wdb, 防沉迷
UiNotify.emCOREEVENT_SYNC_ACHIEVEMENTINFO = 248 -- 同步成就信息
UiNotify.emCOREEVENT_CHAT_DYNCHANNELINFO = 249
UiNotify.emCOREEVENT_SYNC_PARTNER = 250

UiNotify.emCOREEVENT_VIEW_PLAYERPARTNER = 251 -- 查看别人界面时的同伴信息
UiNotify.emCOREEVENT_UI_MINIMAP_CLICK = 252 -- 小地图被点击（右上角小地图以及世界地图）
UiNotify.emCOREEVENT_SYNC_TRANS_POSITION = 253 -- 主角被传送（和emCOREEVENT_SYNC_POSITION不同）

UiNotify.emCOREEVENT_SYNC_BATTLESCORE = 254 -- 跨服城战即时战报
UiNotify.emCOREEVENT_ENHANCE_ZHENYUAN_RESULT = 255 -- 真元强化操作结果返回
UiNotify.emCOREEVENT_DEALYSTRIKE_CHANGE = 256 -- 会心一击值或者会心伤害百分发生改变
UiNotify.emCOREEVENT_RECAST_RESULT = 257 -- 重铸结果通知
UiNotify.emCOREEVENT_SKILL_USEPOINT = 258 -- 技能可用次数
UiNotify.emCOREEVENT_HOLE_OPEN = 259 -- 装备打孔界面
UiNotify.emCOREEVENT_MAKEHOLE_RESULT = 260 -- 装备打孔结果
UiNotify.emCOREEVENT_ENCHASESTONE_RESULT = 261 -- 宝石镶嵌/剥离结果

UiNotify.emCOREEVENT_PREPARE_STONE_UPGRADE = 262 -- 宝石升级准备
UiNotify.emCOREEVENT_STONE_EXCHANGE_OPEN = 263 -- 打开宝石兑换界面
UiNotify.emCOREEVENT_STONE_UPGRADE_RESULT = 264 -- 宝石升级结果
UiNotify.emCOREEVENT_STONE_EXCHANGE_REUSTL = 265 -- 宝石兑换结果
UiNotify.emCOREEVENT_CLEAR_MAP_HIGHLIGHTEX = 266 -- 删除所有特殊显示的NPC亮点
UiNotify.emCOREEVENT_ITEM_COLLATEROOM_REUSTL = 267 -- 整理背包结束
UiNotify.emCOREEVENT_AUTO_FIGHT_STATE = 268 -- 自动战斗设置改变通知
UiNotify.emCOREEVENT_STALL_BUY_SUCCESS = 269 -- 购买摆摊物品成功
UiNotify.emCOREEVENT_STALL_SALE_INFO = 270 -- 摆摊贩卖成功物品信息
UiNotify.emCOREEVENT_OFFER_BUY_INFO = 271 -- 摆摊收购成功物品信息

UiNotify.emCOREEVENT_MINI_DONWLOAD_BEGIN = 272 -- 开始mini客户端资源的下载
UiNotify.emCOREEVENT_MINI_DONWLOAD_BREAK = 273 -- mini客户端下载失败/停止

UiNotify.emCOREEVENT_AUTOPATH_DELAYLOAD_SUCC = 274 -- mini客户端切换地图时资源加载完成通知自动寻路回调
UiNotify.emCOREEVENT_CHECK_DOWNLOADINFO_4_RESTART = 275 -- mini客户端下载失败

UiNotify.emCOREEVENT_STALL_SELL_SUCCESS = 276 -- 出售摆摊物品成功
UiNotify.emCOREEVENT_UPDATE_HOMETOWN_LIST = 277 -- 更新新手村信息
UiNotify.emCOREEVENT_CHAGNE_SKILLCD = 278 -- 技能cd改变
UiNotify.emCOREEVENT_KINREPOSITORY_CHANGE = 279 -- 家族仓库改变了

-- TODO: xyf UI事件，临时放这里，以后提供独立机制
UiNotify.emUIEVENT_SELECT_SKILL = 1000
UiNotify.emUIEVENT_IBSHOP_SWITCH_BUTTON = 1001
UiNotify.emUIEVENT_WND_OPENED = 1002 -- 窗口被打开后
UiNotify.emUIEVENT_WND_CLOSED = 1003 -- 窗口被关闭后
UiNotify.emUIEVENT_MINIKEY_SEND = 1004 -- 窗口被关闭后
UiNotify.emUIEVENT_PREVIEW_CHANGED = 1006 -- 装备预览改变
UiNotify.emUIEVENT_EQUIP_REFRESH = 1007 -- 装备耐久刷新
UiNotify.emUIEVENT_PASSPODTIME_REFRESH = 1008 -- 密保时间刷新
UiNotify.emUIEVENT_OBJ_STATE_USE = 1009 -- OBJ 特殊状态下的右键
UiNotify.emUIEVENT_CHAT_SEND_MSG_CHANNEL = 1010 -- 发送一条消息到指定频道
UiNotify.emUIEVENT_CHAT_ONACTIVE_TAB = 1011 -- 激活某一标签页

UiNotify.emUIEVENT_REPAIRALL_SEND = 1012 -- 全普修装备
UiNotify.emUIEVENT_REPAIREXALL_SEND = 1013 -- 全特修装备
UiNotify.emUIEVENT_WND_ACTIVED = 1014 -- 窗口被激活事件

-- 以下为确认消息提示的子枚举（emCOREEVENT_CONFIRMATION）与 KE_CONFIRMATION 宏对应
UiNotify.CONFIRMATION_TEAM_RECEIVE_INVITE = 10 -- 收到加入队伍邀请
UiNotify.CONFIRMATION_TEAM_APPLY_ADD = 11 -- 收到玩家入队申请
UiNotify.CONFIRMATION_TRADE_RECEIVE_REQUEST = 20 -- 收到交易申请
UiNotify.CONFIRMATION_TRADE_SEND_REQUEST = 21 -- 发送了交易申请
UiNotify.CONFIRMATION_KIN_INVITE_ADD = 30 -- 被邀请加入家族
UiNotify.CONFIRMATION_KIN_INTRODUCE = 31 -- 被推荐加入家族
UiNotify.CONFIRMATION_KIN_CONVECTION = 32 -- 收到家族成员传送召唤
UiNotify.CONFIRMATION_TONG_APPLY_JOIN = 40 -- 收到帮会加入申请
UiNotify.CONFIRMATION_TONG_INVITE_ADD = 41 -- 收到帮会加入邀请
UiNotify.CONFIRMATION_RELATION_TMPFRIEND = 50 -- 收到好友申请
UiNotify.CONFIRMATION_RELATION_BLACKLIST = 51 -- 收到被加入黑名单的消息
UiNotify.CONFIRMATION_RELATION_BINDFRIEND = 52 -- 被添加为双向好友
UiNotify.CONFIRMATION_TEACHER_APPLY_TEACHER = 60 -- 收到拜师申请
UiNotify.CONFIRMATION_TEACHER_APPLY_STUDENT = 61 -- 收到拜师申请
UiNotify.CONFIRMATION_TEACHER_CONVECTION = 62 -- 收到师傅传送请求
UiNotify.CONFIRMATION_COUPLE_CONVECTION = 63 -- 收到夫妻传送请求
UiNotify.CONFIRMATION_PK_EXERCISE_INVITE = 70 -- 收到切磋请求

function UiNotify:Init()
  self.tbCallback = {} -- 注册函数表
end

-- 注册事件函数，当有nEvent事件产生时，回调tbTable的fnProc函数
function UiNotify:RegistNotify(nEvent, fnProc, tbTable)
  assert(tbTable, string.format("nEvent:%s,", tostring(nEvent)))
  assert(nEvent, string.format("UiGroup:%s, nEvent:%s,", tostring(tbTable.UIGROUP), tostring(nEvent)))
  assert(fnProc)

  local tbCallback = self.tbCallback[nEvent]
  if not tbCallback then
    tbCallback = {}
    self.tbCallback[nEvent] = tbCallback
  else
    for _, v in pairs(tbCallback) do
      if (v.fnProc == fnProc) and (v.tbSelf == tbTable) then
        return -- 重复注册，忽略
      end
    end
  end
  if type(tbTable) == "table" then
    table.insert(tbCallback, { tbSelf = tbTable, fnProc = fnProc })
  end
end

-- 反注册事件函数
function UiNotify:UnRegistNotify(nEvent, fnProc, tbTable)
  assert(tbTable, string.format("nEvent:%s,", tostring(nEvent)))
  assert(nEvent, string.format("UiGroup:%s, nEvent:%s,", tostring(tbTable.UIGROUP), tostring(nEvent)))
  assert(fnProc)
  local tbCallback = self.tbCallback[nEvent]
  if not tbCallback then
    return
  end
  for nIndex, v in pairs(tbCallback) do
    if (v.fnProc == fnProc) and (v.tbSelf == tbTable) then
      tbCallback[nIndex] = nil
      return -- 重复注册，忽略
    end
  end
end

-- Core事件接口，有任何事件程序都会调用该函数，并将参数传入
function UiNotify:OnNotify(nEvent, ...)
  if self.tbCallback[nEvent] then
    for _, tb in pairs(self.tbCallback[nEvent]) do -- 遍历注册函数的表，调用注册了的函数
      local szUiGroup = tb.tbSelf.UIGROUP
      --			if (not szUiGroup) or UiManager:WindowVisible(szUiGroup) == 1 then	-- 如果不是窗口或者窗口被打开才接消息
      tb.fnProc(tb.tbSelf, unpack(arg))
      --			end
    end
  end
end
