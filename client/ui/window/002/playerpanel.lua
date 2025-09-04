local tbPlayerPanel = Ui:GetClass("playerpanel")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr
local tbTempData = Ui.tbLogic.tbTempData
local tbTempItem = Ui.tbLogic.tbTempItem
local tbViewPlayerMgr = Ui.tbLogic.tbViewPlayerMgr

local HISTORY_PAGE_NORMAL = 1
local HISTORY_PAGE_TASK = 2
local HISTORY_PAGE_COMBAT = 3

local IS_RESET_ATTRIB_TASK = { 2, 1 } -- 记录玩家是否洗过点的任务变量

local szOldName = ""
local szOldBlogMonicker = ""
local szOldFaction = ""
local szOldBlogTag = ""
local szOldLike = ""
local szOldBlogBlog = ""
local szOldDianDi = ""
local szOldCity = ""
local nOldSex = 0
local nOldBlogBirthday = 0
local nOldMarriageType = 0
local nOldOnlineTime = 0
local nOldFriendOnly = 0

------ 常量定义 ------

-- 窗口标识
tbPlayerPanel.PAGE_MAIN = "Main" -- 整个窗口
local PAGESET_MAIN = "PageSetMain" -- 主角属性左侧页表
local PAGE_BASIC = "PageBasic" -- 主角基础属性页
local PAGE_REPUTE = "PageRepute" -- 主角声望页
local PAGE_TITLE = "PageTitle" -- 主角称号页
local PAGE_HISTORY = "PageHistory" -- 主角历程页
local PAGE_EDITBLOG = "BtnEditBlog"
local BTN_CLOSE = "BtnClose" -- 主窗口关闭按钮
local BTN_SWITCH = "BtnSwitch" -- 五行装备切换按钮
local BTN_BASIC_ASSAUTO = "BtnBasicAssignAuto" -- 基础属性页：潜能自动分配按钮
local BTN_BASIC_ASSOK = "BtnBasicAssignOK" -- 基础属性页：潜能分配确认按钮
local BTN_BASIC_ASSCANCEL = "BtnBasicAssignCancel" -- 基础属性页：潜能分配取消按钮
local BTN_BASIC_INCSTR = "BtnBasicIncStr" -- 基础属性页：力量分配递增按钮
local BTN_BASIC_DECSTR = "BtnBasicDecStr" -- 基础属性页：力量分配递减按钮
local BTN_BASIC_INCDEX = "BtnBasicIncDex" -- 基础属性页：身法分配递增按钮
local BTN_BASIC_DECDEX = "BtnBasicDecDex" -- 基础属性页：身法分配递减按钮
local BTN_BASIC_INCVIT = "BtnBasicIncVit" -- 基础属性页：外功分配递增按钮
local BTN_BASIC_DECVIT = "BtnBasicDecVit" -- 基础属性页：外功分配递减按钮
local BTN_BASIC_INCENG = "BtnBasicIncEng" -- 基础属性页：内功分配递增按钮
local BTN_BASIC_DECENG = "BtnBasicDecEng" -- 基础属性页：内功分配递减按钮
local BTN_SEL_PORTRAIT = "BtnSelPortrait" -- 基础属性页：主角头像
local IMG_PLAYER_PORTRAIT = "ImgPortrait" -- 基础属性页：主角头像
local BTN_ACTIVE_TITLE = "BtnActiveTitle" -- 称号页面：激活页面按钮
local BTN_INACTIVE_TITLE = "BtnInactiveTitle" -- 称号页面：取下页面按钮
local BTN_EQUIP_PAGE = "BtnEquipPage" -- 装备视图：换页按钮
local BTN_EQUIP_PARTNER = "BtnTongbanEquipPage" -- 装备视图：同伴装备页面
local BTN_SWITCH_EQUIP = "BtnSwitchEquip" -- 装备视图：确认切换
local EDIT_BASIC_STR = "EdtBasicStr" -- 基础属性页：主角力量编辑框
local EDIT_BASIC_DEX = "EdtBasicDex" -- 基础属性页：主角身法编辑框
local EDIT_BASIC_VIT = "EdtBasicVit" -- 基础属性页：主角外功编辑框
local EDIT_BASIC_ENG = "EdtBasicEng" -- 基础属性页：主角内功编辑框
local EDIT_BASIC_NAME = "EdtBasicName" -- 基础属性页：主角名字
local TEXT_BASIC_SERIES = "TxtBasicSeries" -- 基础属性页：主角五行
local TEXT_BASIC_LEVEL = "TxtBasicLevel" -- 基础属性页：主角等级
local TEXT_BASIC_FACTION = "TxtBasicFaction" -- 基础属性页：主角门派
local TEXT_BASIC_PKVALUE = "TxtBasicPKValue" -- 基础属性页：主角恶名值
local TEXT_BASIC_EXP = "TxtBasicExp" -- 基础属性页：主角经验值
local TEXT_BASIC_LIFE = "TxtBasicLife" -- 基础属性页：主角生命值
local TEXT_BASIC_MANA = "TxtBasicMana" -- 基础属性页：主角内力值
local TEXT_BASIC_STAMINA = "TxtBasicStamina" -- 基础属性页：主角体力值
local TEXT_BASIC_GTP = "TxtBasicGTP" -- 基础属性页：主角活力值
local TEXT_BASIC_MKP = "TxtBasicMKP" -- 基础属性页：主角精力值
local TEXT_BASIC_GR = "TxtBasicGeneralResist" -- 基础属性页：主角普防值
local TEXT_BASIC_PR = "TxtBasicPoisonResist" -- 基础属性页：主角毒防值
local TEXT_BASIC_CR = "TxtBasicColdResist" -- 基础属性页：主角冰防值
local TEXT_BASIC_FR = "TxtBasicFireResist" -- 基础属性页：主角火防值
local TEXT_BASIC_LR = "TxtBasicLightResist" -- 基础属性页：主角雷防值
local TEXT_BASIC_LDAMAGE = "TxtBasicLeftDamage" -- 基础属性页：主角左键攻击
local TEXT_BASIC_RDAMAGE = "TxtBasicRightDamage" -- 基础属性页：主角右键攻击
local TEXT_BASIC_AR = "TxtBasicAttackRate" -- 基础属性页：主角命中率
local TEXT_BASIC_AS = "TxtBasicAttackSpeed" -- 基础属性页：主角攻击速度
local TEXT_BASIC_DEFENSE = "TxtBasicDefense" -- 基础属性页：主角闪避率
local TEXT_BASIC_RUNSPEED = "TxtBasicRunSpeed" -- 基础属性页：主角跑动速度
local TEXT_BASIC_STR = "TxtBasicStrength" -- 基础属性页：主角力量值
local TEXT_BASIC_DEX = "TxtBasicDexterity" -- 基础属性页：主角身法值
local TEXT_BASIC_VIT = "TxtBasicVitality" -- 基础属性页：主角外功值
local TEXT_BASIC_ENG = "TxtBasicEnergy" -- 基础属性页：主角内功值
local TEXT_BASIC_REMAIN = "TxtBasicRemain" -- 基础属性页：主角剩余潜能点
local TEXT_DEADLYSTRIKE_RATE = "TxtDeadlyStrike" -- 基础属性页：主角会心一击概率
local TEXT_DEADLYSTRIKE_PREC = "TxtDeadlyStrikeDamage" -- 基础属性页：主角会心一击时伤害倍数
local TEXT_REPUTE_NAME = "TxtReputeName" -- 声望页面：主角名字
local TEXT_TITLE_NAME = "TxtTitleName" -- 称号页面：主角名字
local TEXT_TITLE_DESCRIBE = "TxtDescribeTitle" -- 称号页面：称号描述
local TEXT_HISTROY_NAME = "TxtHistroyName" -- 历程页面：主角名字
local TEXT_HISTROY = "TxtHistroy"
local BTN_HONOR = "BtnHistory" -- 荣誉界面
local OUTLOOK_REPUTE = "OutLookRepute" -- 声望界面：声望列表
local OUTLOOK_TITLE = "OutLookTitle" -- 称号页面：称号列表
local OUTLOOK_HISTORY = "OutLookHistory" -- 荣誉界面：荣誉列表
local OBJ_EQUIP_PREVIEW = "ObjPreview"
local BTN_BLOGCLOSE = "BtnEditBlogCancel"
local BTN_FIGHTPOWER = "BtnFightPower" -- 战斗力界面
local BTN_HIDE_MANTLE = "BtnHideMantle" -- 隐藏披风按钮
local BTN_BE_INVITOR = "BtnBeInvitor"
local CMB_PROPERTY_TYPE = "CmbPropertyType" -- 属性下拉框
local PROPERTY_TYPE_LIST = { "     基础属性", "       攻击", "       防御" }

local PROPERTY_TYPE_BASIC = 0 -- 基础属性
local PROPERTY_TYPE_ATTACK = 1 -- 攻击
local PROPERTY_TYPE_DEFENSE = 2 -- 防御

local MARRIAGE_TYPE = { "形单影只", "心有所属" }
local SEX_TYPE = { "男", "女" }
local SERIES_NAME = { "金", "木", "水", "火", "土" }

--	add by sutingwei
tbPlayerPanel.nTimerId = 0 -- 设置定时器定时抓取声望界面ScrollPanel的滑动条位置信息 实现记忆功能
tbPlayerPanel.UPDATETIME = 3 -- 抓取时间为3s
tbPlayerPanel.PreShowReputePopLock = 0
tbPlayerPanel.nPosReputeScroll = 0
tbPlayerPanel.BTN_PAGE_BASIC = "BtnBasic" -- 属性界面按钮
tbPlayerPanel.BTN_PAGE_NAME = "BtnTitle" -- 称号界面按钮
tbPlayerPanel.BTN_PAGE_REPUTE = "BtnRepute" -- 声望界面按钮
tbPlayerPanel.nIsOpenTheReputePopInfoWnd = 0 -- 用来记录当从声望界面切换到其他界面的时候 声望信息窗口是否打开 用于记忆功能的实现
tbPlayerPanel.WND_REPUTE_INFO = "WndReputePopTxtShow" -- 声望介绍界面中的整体显示窗口
tbPlayerPanel.BTN_VIEW_WEALTH_VALUE = "BtnViewWealthValue" -- 打开财富面板的按钮
tbPlayerPanel.BTN_FIX_ALL_EQUIPMENT = "BtnFixEquipAll" -- 一键全修的按钮
tbPlayerPanel.REPUTE_INFO_WND_SCROLL_PANEL = "ReputeInfoWndScrollPanel" -- 声望详细介绍信息的Scroll面板
tbPlayerPanel.REPUTE_INFO_WND_TXTEX_SHOW = "ReputeInfoWndTxtExShow" -- 声望详细介绍信息的显示窗口
tbPlayerPanel.REPUTE_INFO_WND_PROGRESSBAR = "ReputeInfoWndProgress" -- 声望介绍界面中的进度条控件
tbPlayerPanel.REPUTE_INFO_SHOW_WND_TITLE_TXTEX = "ReputeInfoShowWndTitleTxtEx" -- 声望介绍界面中的Title
tbPlayerPanel.REPUTE_PAGE_COMBOBOX = "ReputePageComboBox" --声望Page中的下拉框控件
tbPlayerPanel.REPUTEINFOWNDPRIZELEFT = "ReputeInfoWndPrizeLeft" -- 声望介绍界面中奖励左拉按钮
tbPlayerPanel.REPUTEINFOWNDPRIZERIGHT = "ReputeInfoWndPrizeRight" -- 声望介绍界面中奖励右拉按钮
tbPlayerPanel.BTNREPUTEINFOWNDPRIZESHOP = "BtnReputeInfoWndPrizeShop" -- 声望介绍界面中打开商店按钮
tbPlayerPanel.ReputeInfoWndBtnClose = "ReputeInfoWndBtnClose" -- 声望信息弹出窗关闭按钮
tbPlayerPanel.REPUTE_SCROLL_PANEL = "ReputeScrollPanel"

--	设置全局声望页面选择的Item信息 在打开声望物品商店时需要用这个全局变量获得相应商店的ID号
tbPlayerPanel.nReputeCurrentSelectItemParentIndex = -1 -- 当前选择声望选项的父索引
tbPlayerPanel.nReputeCurrentSelectItemChildIndex = -1 -- 当前选择声望选项的子索引

--	设置声望界面当前选择Item的可购买物品信息
--	奖励的物品保存在一个索引从1开始的有序Table中 最多视野中显示4个物品图片 所以开始显示的左右索引为 1, 4.
--	如果向右拉一格 则显示的左右索引变为 2, 5 依次类推
tbPlayerPanel.tbCurrentSelReputeItemPrize = {} -- 当前选择声望选项的可购买物品信息的Table
tbPlayerPanel.AWARD_GRID_COUNT = 10 --	可购买物品信息的Table默认大小分配为10个
tbPlayerPanel.nNumOfReputePrize = 0 -- 当前选择声望选项的可购买物品信息的个数
tbPlayerPanel.nReputePrizeShowLeftIndex = 0 -- 可购买物品显示的左边索引
tbPlayerPanel.nReputePrizeShowRightIndex = 0 -- 可购买物品显示的右边索引

tbPlayerPanel.nNumOfPrizeShowOnPage = 5 --每一个页面所显示的声望奖励物品的个数

tbPlayerPanel.tbCareBindTable = {} --	关注Group中的绑定表
tbPlayerPanel.tbNotCareBindTable = {} --	不关注Group中的绑定表
tbPlayerPanel.nGroupIndex = -1
tbPlayerPanel.nItemIndex = -1

tbPlayerPanel.INVOLVE_POP_WND = 1 --用于ResizeMainWnd函数 类似宏定义
tbPlayerPanel.NOT_INVOLVE_POP_WND = 0

--	add by sutingwei 	此处用于声望Page过滤装备类型
tbPlayerPanel.nReputeCurrentSelComboIndex = 1
tbPlayerPanel.REPUTE_AWARD_FILTER_TABLE = { "全部类型", "传说装备", "史诗装备", "卓越装备", "稀有装备", "宝物", "其他" } -- 声望奖励过滤列表 当选择相应ComboBox的选项时 更新此表

tbPlayerPanel.IMG_GRID_REPUTE_AWARD = {}
tbPlayerPanel.NUM_CONTROL_CLASS = 5 -- 控件的个数
--	图片控件 图片控件上的ObjGrid控件	[1]为Image控件 [2]为ObjGrid控件 [3]为WndText控件
for i = 1, tbPlayerPanel.NUM_CONTROL_CLASS do
  --	为了和系统整体统一 不可用的装备用红底显示 原来用于处理不可用装备的特殊显示所加的覆盖层 ReputeInfoWndAwara现在不需要使用 所涉及代码待删
  tbPlayerPanel.IMG_GRID_REPUTE_AWARD[i] = { "ReputeInfoWndAwara" .. i .. "ObjGrid", "ReputeInfoWndAwara" .. i .. "Txt" }
end

-- obj name to index	在ObjGrid MouseHover的时候会用到
tbPlayerPanel.OBJ_INDEX_REPUTE_AWARD = {}
for i = 1, tbPlayerPanel.NUM_CONTROL_CLASS do
  tbPlayerPanel.OBJ_INDEX_REPUTE_AWARD["ReputeInfoWndAwara" .. i .. "ObjGrid"] = i
end

tbPlayerPanel.tbLevelTransferToProgressShow = { -- 根据相应等级来划分进度条的刻度分配 0为不显示 1为显示
  [1] = "0,0,0,0,0,0,0,0,0", --最高级为一级时 进度条分割方式
  [2] = "0,0,0,0,1,0,0,0,0", --最高级为二级时 进度条分割方式
  [3] = "0,0,1,0,0,1,0,0,0", --最高级为三级时 进度条分割方式
  [4] = "0,1,0,1,0,0,1,0,0", --最高级为四级时 进度条分割方式
  [5] = "0,1,0,1,0,1,0,1,0", --最高级为五级时 进度条分割方式
  [6] = "1,1,0,1,0,1,0,1,0", --最高级为六级时 进度条分割方式
  [7] = "1,1,1,1,0,1,0,1,0", --最高级为七级时 进度条分割方式
  [8] = "1,1,1,1,1,1,0,1,0", --最高级为八级时 进度条分割方式
  [9] = "1,1,1,1,1,1,1,1,0", --最高级为九级时 进度条分割方式
  [10] = "1,1,1,1,1,1,1,1,1", --最高级为十级时 进度条分割方式
}

tbPlayerPanel.tbFilter = {
  "传说装备",
  "史诗装备",
  "卓越装备",
  "稀有装备",
  "宝物",
  "其他",
}

tbPlayerPanel.ReputeProgressDistance = 337 --	声望等级信息进度条总长度
tbPlayerPanel.ReputeProgressScaleDistance = 33 --	声望等级信息进度条每个刻度的长度
tbPlayerPanel.ReputeProgressScaleNum = 9 --	声望等级信息进度条上刻度的图标数目
tbPlayerPanel.tbProgressScaleReference = { --	声望等级信息进度条每个刻度相对于总长度的偏移参考表
  [1] = tbPlayerPanel.ReputeProgressScaleDistance,
  [2] = tbPlayerPanel.ReputeProgressScaleDistance * 2,
  [3] = tbPlayerPanel.ReputeProgressScaleDistance * 3,
  [4] = tbPlayerPanel.ReputeProgressScaleDistance * 4,
  [5] = tbPlayerPanel.ReputeProgressScaleDistance * 5,
  [6] = tbPlayerPanel.ReputeProgressScaleDistance * 6,
  [7] = tbPlayerPanel.ReputeProgressScaleDistance * 7,
  [8] = tbPlayerPanel.ReputeProgressScaleDistance * 8,
  [9] = tbPlayerPanel.ReputeProgressScaleDistance * 9,
  [10] = tbPlayerPanel.ReputeProgressDistance,
}

local YEAR = {
  "2008年",
  "2007年",
  "2006年",
  "2005年",
  "2004年",
  "2003年",
  "2002年",
  "2001年",
  "2000年",
  "1999年",
  "1998年",
  "1997年",
  "1996年",
  "1995年",
  "1994年",
  "1993年",
  "1992年",
  "1991年",
  "1990年",
  "1989年",
  "1988年",
  "1987年",
  "1986年",
  "1985年",
  "1984年",
  "1983年",
  "1982年",
  "1981年",
  "1980年",
  "80年以前",
}

local MONTH = {
  "1月",
  "2月",
  "3月",
  "4月",
  "5月",
  "6月",
  "7月",
  "8月",
  "9月",
  "10月",
  "11月",
  "12月",
}

local DAY = {
  "1日",
  "2日",
  "3日",
  "4日",
  "5日",
  "6日",
  "7日",
  "8日",
  "9日",
  "10日",
  "11日",
  "12日",
  "13日",
  "14日",
  "15日",
  "16日",
  "17日",
  "18日",
  "19日",
  "20日",
  "21日",
  "22日",
  "23日",
  "24日",
  "25日",
  "26日",
  "27日",
  "28日",
  "29日",
  "30日",
  "31日",
}

local STAR_MAP = {
  ["白羊座"] = { 3, 21, 4, 19 },
  ["金牛座"] = { 4, 20, 5, 20 },
  ["双子座"] = { 5, 21, 6, 21 },
  ["巨蟹座"] = { 6, 22, 7, 22 },
  ["狮子座"] = { 7, 23, 8, 22 },
  ["处女座"] = { 8, 23, 9, 22 },
  ["天秤座"] = { 9, 23, 10, 23 },
  ["天蝎座"] = { 10, 24, 11, 22 },
  ["射手座"] = { 11, 23, 12, 21 },
  ["摩羯座"] = { 12, 22, 1, 19 },
  ["水瓶座"] = { 1, 20, 2, 18 },
  ["双鱼座"] = { 2, 19, 3, 20 },
}

local PROVINCE = {
  "无",
  "直辖市",
  "河北省",
  "山西省",
  "内蒙古",
  "辽宁省",
  "吉林省",
  "黑龙江省",
  "江苏省",
  "浙江省",
  "安徽省",
  "福建省",
  "江西省",
  "山东省",
  "河南省",
  "湖北省",
  "湖南省",
  "广东省",
  "广西",
  "海南省",
  "四川省",
  "贵州省",
  "云南省",
  "西藏",
  "陕西省",
  "甘肃省",
  "青海省",
  "宁夏",
  "新疆",
  "台湾省",
  "香港澳门",
  "海外",
}

local CITY = {
  { "无" },
  { "北京市", "天津市", "上海市", "重庆市" },
  { "石家庄市", "唐山市", "秦皇岛市", "邯郸市", "邢台市", "保定市", "张家口市", "承德市", "沧州市", "廊坊市", "衡水市" },
  { "太原", "大同", "阳泉", "长治", "晋城", "朔州", "晋中", "运城", "忻州", "临汾", "吕梁" },
  {
    "呼和浩特市",
    "包头市",
    "乌海市",
    "赤峰市",
    "通辽市",
    "鄂尔多斯市",
    "呼伦贝尔市",
    "巴彦淖尔市",
    "乌兰察布市",
    "锡林郭勒盟",
    "兴安盟",
    "阿拉善盟",
  },
  {
    "沈阳市",
    "大连市",
    "鞍山市",
    "抚顺市",
    "本溪市",
    "丹东市",
    "锦州市",
    "营口市",
    "阜新市",
    "辽阳市",
    "盘锦市",
    "铁岭市",
    "朝阳市",
    "葫芦岛市",
  },
  { "长春市", "吉林市", "四平市", "辽源市", "通化市", "白山市", "松原市", "白城市", "延边自治州" },
  {
    "哈尔滨市",
    "齐齐哈尔市",
    "鹤岗市",
    "双鸭山市",
    "鸡西市",
    "大庆市",
    "伊春市",
    "牡丹江市",
    "佳木斯市",
    "七台河市",
    "黑河市",
    "绥化市",
    "大兴安岭",
  },
  {
    "南京市",
    "无锡市",
    "徐州市",
    "常州市",
    "苏州市",
    "南通市",
    "连云港市",
    "淮安市",
    "盐城市",
    "扬州市",
    "镇江市",
    "泰州市",
    "宿迁市",
  },
  { "杭州市", "宁波市", "温州市", "嘉兴市", "湖州市", "绍兴市", "金华市", "衢州市", "舟山市", "台州市", "丽水市" },
  {
    "合肥市",
    "芜湖市",
    "蚌埠市",
    "淮南市",
    "马鞍山市",
    "淮北市",
    "铜陵市",
    "安庆市",
    "黄山市",
    "滁州市",
    "阜阳市",
    "宿州市",
    "巢湖市",
    "六安市",
    "亳州市",
    "池州市",
    "宣城市",
  },
  { "福州市", "厦门市", "莆田市", "三明市", "泉州市", "漳州市", "南平市", "龙岩市", "宁德市" },
  { "南昌市", "景德镇市", "萍乡市", "九江市", "新余市", "鹰潭市", "赣州市", "吉安市", "宜春市", "抚州市", "上饶市" },
  {
    "济南市",
    "青岛市",
    "淄博市",
    "枣庄市",
    "东营市",
    "烟台市",
    "潍坊市",
    "济宁市",
    "泰安市",
    "威海市",
    "日照市",
    "莱芜市",
    "临沂市",
    "德州市",
    "聊城市",
    "滨州市",
    "菏泽市",
  },
  {
    "郑州市",
    "开封市",
    "洛阳市",
    "平顶山市",
    "安阳市",
    "鹤壁市",
    "新乡市",
    "焦作市",
    "濮阳市",
    "许昌市",
    "漯河市",
    "三门峡市",
    "南阳市",
    "商丘市",
    "信阳市",
    "周口市",
    "驻马店市",
  },
  {
    "武汉市",
    "黄石市",
    "十堰市",
    "荆州市",
    "宜昌市",
    "襄樊市",
    "鄂州市",
    "荆门市",
    "孝感市",
    "黄冈市",
    "咸宁市",
    "随州市",
    "恩施自治州",
  },
  {
    "长沙市",
    "株洲市",
    "湘潭市",
    "衡阳市",
    "邵阳市",
    "岳阳市",
    "常德市",
    "张家界市",
    "益阳市",
    "郴州市",
    "永州市",
    "怀化市",
    "娄底市",
    "湘西",
  },
  {
    "广州市",
    "深圳市",
    "珠海市",
    "汕头市",
    "韶关市",
    "佛山市",
    "江门市",
    "湛江市",
    "茂名市",
    "肇庆市",
    "惠州市",
    "梅州市",
    "汕尾市",
    "河源市",
    "阳江市",
    "清远市",
    "东莞市",
    "中山市",
    "潮州市",
    "揭阳市",
    "云浮市",
  },
  {
    "南宁市",
    "柳州市",
    "桂林市",
    "梧州市",
    "北海市",
    "防城港市",
    "钦州市",
    "贵港市",
    "玉林市",
    "百色市",
    "贺州市",
    "河池市",
    "来宾市",
    "崇左市",
  },
  { "海口市", "三亚市" },
  {
    "成都市",
    "自贡市",
    "攀枝花市",
    "泸州市",
    "德阳市",
    "绵阳市",
    "广元市",
    "遂宁市",
    "内江市",
    "乐山市",
    "南充市",
    "眉山市",
    "宜宾市",
    "广安市",
    "达州市",
    "雅安市",
    "巴中市",
    "资阳市",
    "阿坝",
    "甘孜",
    "凉山",
  },
  { "贵阳市", "六盘水市", "遵义市", "安顺市", "铜仁地区", "毕节地区", "黔西南", "黔东南", "黔南" },
  {
    "昆明市",
    "曲靖市",
    "玉溪市",
    "保山市",
    "昭通市",
    "丽江市",
    "普洱市",
    "临沧市",
    "文山",
    "红河",
    "西双版纳",
    "楚雄",
    "大理",
    "德宏",
    "怒江",
    "迪庆",
  },
  { "拉萨市", "那曲地区", "昌都地区", "山南地区", "日喀则地区", "阿里地区", "林芝地区" },
  { "西安市", "铜川市", "宝鸡市", "咸阳市", "渭南市", "延安市", "汉中市", "榆林市", "安康市", "商洛市" },
  {
    "兰州市",
    "金昌市",
    "白银市",
    "天水市",
    "嘉峪关市",
    "武威市",
    "张掖市",
    "平凉市",
    "酒泉市",
    "庆阳市",
    "定西市",
    "陇南市",
    "临夏",
    "甘南",
  },
  { "西宁市", "海东地区", "海北", "黄南", "海南", "果洛", "玉树", "海西" },
  { "银川市", "石嘴山市", "吴忠市", "固原市", "中卫市" },
  {
    "乌鲁木齐市",
    "克拉玛依市",
    "吐鲁番地区",
    "哈密地区",
    "和田地区",
    "阿克苏地区",
    "喀什地区",
    "塔城地区",
    "阿勒泰地区",
    "克州",
    "巴音郭楞",
    "昌吉",
    "博尔塔拉",
    "伊犁",
  },
  { "台北市", "高雄市", "基隆市", "台中市", "台南市", "新竹市", "嘉义市" },
  { "香港", "澳门" },
  { "海外" },
}

local OUTLOOK_ITEM_BACKGROUD_IMAGE1 = "\\image\\ui\\002a\\playerpanel\\bg_repute_01.spr"
local OUTLOOK_ITEM_BACKGROUD_IMAGE2 = "\\image\\ui\\002a\\playerpanel\\bg_repute_02.spr"
local PROGRESS_IMAGE = "\\image\\ui\\001a\\fightpower\\fightpower_progress_1.spr"
local PROGRESS_BG_IMAGE = "\\image\\ui\\001a\\fightpower\\fightpower_progress_2.spr"

-- 博客编辑分页变量
--	Edt_SetMaxLen(self.UIGROUP, EDT_EDITBLOGNAME, 12);--真实姓名最大长度
--	Edt_SetMaxLen(self.UIGROUP, EDT_EDITBLOGMONICKER, 12);--昵称最大长度
--	Edt_SetMaxLen(self.UIGROUP, EDT_EDITBLOGOCCUPATION, 8);--职业最大长度
--	Edt_SetMaxLen(self.UIGROUP, EDT_EDITBLOGTAG, 20);--口头禅
--	Edt_SetMaxLen(self.UIGROUP, EDT_EDITBLOGCITY, 8);--城市
--	Edt_SetMaxLen(self.UIGROUP, EDT_EDITBLOGLIKE, 40);--爱好
--	Edt_SetMaxLen(self.UIGROUP, EDT_EDITBLOGEditBLOG, 40);--博客地址
--	Edt_SetMaxLen(self.UIGROUP, EDT_EDITBLOGDIANDI, 200);--点滴

local EDT_EDITBLOGNAME = "EdtEditBlogName"
local EDT_EDITBLOGMONICKER = "EdtEditBlogMonicker"
local EDT_EDITBLOGOCCUPATION = "EdtEditBlogOccupation"
local CMB_EDITBLOGSEX = "ComboBoxEdtEditBlogSex"
local EDT_EDITBLOGTAG = "EdtEditBlogTag"
local BTN_EDITBLOGFRIENDONLY = "BtnEditBlogFriendOnly"
local EDT_EDITBLOGBIRTHDAY = "EdtEditBlogBirthday"
local EDT_EDITBLOGCITY = "EdtEditBlogCity"
local CMB_EDITBLOGMARRIAGE = "ComboBoxFatherEditBlog"
local EDT_EDITBLOGLIKE = "EdtEditBlogLike"
local BTN_EDITBLOGEditBLOG = "BtnEditBlogEditBlog"
local EDT_EDITBLOGEditBLOG = "EdtEditBlogEditBlog"
local EDT_EDITBLOGDIANDI = "EdtEditBlogDianDi"
local BTN_EDITBLOGLINGCHEN = "BtnEditBlogLingchen"
local BTN_EDITBLOGSHANGWU = "BtnEditBlogShangwu"
local BTN_EDITBLOGZHONGWU = "BtnEditBlogZhongwu"
local BTN_EDITBLOGXIAWU = "BtnEditBlogXiawu"
local BTN_EDITBLOGWANSHANG = "BtnEditBlogWanshang"
local BTN_EDITBLOGWUYE = "BtnEditBlogWuye"
local TXT_BLOGSTAR = "TxtStarBlog" -- 星座
local BTN_EDITBLOGSAVE = "BtnEditBlogSave"
local CMB_YEAR = "ComboBoxYearEditBlog"
local CMB_MONTH = "ComboBoxMonthEditBlog"
local CMB_DATE = "ComboBoxDateEditBlog"
local BTN_PUBLISHBLOG = "BtnPublishBlog"
local CMB_EDITBLOGPROVINCE = "ComboBoxEdtEditBlogProvince"
local CMB_EDITBLOGCITY = "ComboBoxEdtEditBlogCity"

local EDT_BoxYearEditBlog = "EdtBoxYearEditBlog"
local EDT_BoxMonthEditBlog = "EdtBoxMonthEditBlog"
local EDT_BoxDateEditBlog = "EdtBoxDateEditBlog"
local EDT_StarBlog = "EdtStarBlog"
local EDT_BoxEdtEditBlogProvince = "EdtBoxEdtEditBlogProvince"
local EDT_EdtEditBlogCity = "EdtEdtEditBlogCity"

local SELF_EQUIPMENT = -- 装备控件表
  {
    { Item.EQUIPPOS_HEAD, "ObjHead", "ImgHead" },
    { Item.EQUIPPOS_BODY, "ObjBody", "ImgBody" },
    { Item.EQUIPPOS_BELT, "ObjBelt", "ImgBelt" },
    { Item.EQUIPPOS_WEAPON, "ObjWeapon", "ImgWeapon" },
    { Item.EQUIPPOS_FOOT, "ObjFoot", "ImgFoot" },
    { Item.EQUIPPOS_CUFF, "ObjCuff", "ImgCuff" },
    { Item.EQUIPPOS_AMULET, "ObjAmulet", "ImgAmulet" },
    { Item.EQUIPPOS_RING, "ObjRing", "ImgRing" },
    { Item.EQUIPPOS_NECKLACE, "ObjNecklace", "ImgNecklace" },
    { Item.EQUIPPOS_PENDANT, "ObjPendant", "ImgPendant" },
    { Item.EQUIPPOS_HORSE, "ObjHorse", "ImgHorse" },
    { Item.EQUIPPOS_MASK, "ObjMask", "ImgMask" },
    { Item.EQUIPPOS_BOOK, "ObjBook", "ImgBook" },
    { Item.EQUIPPOS_ZHEN, "ObjZhen", "ImgZhen" },
    { Item.EQUIPPOS_SIGNET, "ObjSignet", "ImgSignet" },
    { Item.EQUIPPOS_MANTLE, "ObjMantle", "ImgMantle" },
    { Item.EQUIPPOS_CHOP, "ObjChop", "ImgChop" },
    { Item.EQUIPPOS_ZHENYUAN_MAIN, "ObjZhenYuanMain", "ImgZhenYuanMain" },
    { Item.EQUIPPOS_ZHENYUAN_SUB1, "ObjZhenYuanSub1", "ImgZhenYuanSub1" },
    { Item.EQUIPPOS_ZHENYUAN_SUB2, "ObjZhenYuanSub2", "ImgZhenYuanSub2" },
    { Item.EQUIPPOS_GARMENT, "ObjGarment", "ImgGarment" },
    { Item.EQUIPPOS_OUTHAT, "ObjOutHat", "ImgOutHat" },
  }

local SELF_EQUIPMENT_TIP = -- 装备控件表
  {
    [Item.EQUIPPOS_HEAD] = { "ObjHead", "ImgHead", "基础装备之防具，包括帽子、鞋子、衣服、腰带、护腕。" },
    [Item.EQUIPPOS_BODY] = { "ObjBody", "ImgBody", "基础装备之防具，包括帽子、鞋子、衣服、腰带、护腕。" },
    [Item.EQUIPPOS_BELT] = { "ObjBelt", "ImgBelt", "基础装备之防具，包括帽子、鞋子、衣服、腰带、护腕。" },
    [Item.EQUIPPOS_WEAPON] = {
      "ObjWeapon",
      "ImgWeapon",
      "基础装备之武器，类型包括：缠手、剑、刀、棍、枪、锤、飞刀、袖箭共8类。",
    },
    [Item.EQUIPPOS_FOOT] = { "ObjFoot", "ImgFoot", "基础装备之防具，包括帽子、鞋子、衣服、腰带、护腕。" },
    [Item.EQUIPPOS_CUFF] = { "ObjCuff", "ImgCuff", "基础装备之防具，包括帽子、鞋子、衣服、腰带、护腕。" },
    [Item.EQUIPPOS_AMULET] = {
      "ObjAmulet",
      "ImgAmulet",
      "基础装备之首饰，包括项链、腰坠（男）/香囊（女）、戒指、护身符共4种首饰。",
    },
    [Item.EQUIPPOS_RING] = {
      "ObjRing",
      "ImgRing",
      "基础装备之首饰，包括项链、腰坠（男）/香囊（女）、戒指、护身符共4种首饰。",
    },
    [Item.EQUIPPOS_NECKLACE] = {
      "ObjNecklace",
      "ImgNecklace",
      "基础装备之首饰，包括项链、腰坠（男）/香囊（女）、戒指、护身符共4种首饰。",
    },
    [Item.EQUIPPOS_PENDANT] = {
      "ObjPendant",
      "ImgPendant",
      "基础装备之首饰，包括项链、腰坠（男）/香囊（女）、戒指、护身符共4种首饰。",
    },
    [Item.EQUIPPOS_HORSE] = { "ObjHorse", "ImgHorse", "主要提供角色骑乘时的移动速度，部分坐骑外观稀有。" },
    [Item.EQUIPPOS_MASK] = { "ObjMask", "ImgMask", "面具装备到装备栏中即可变成对应NPC的样子。" },
    [Item.EQUIPPOS_BOOK] = { "ObjBook", "ImgBook", "增加角色潜能，秘籍升级到满级可激活秘籍技能。" },
    [Item.EQUIPPOS_ZHEN] = { "ObjZhen", "ImgZhen", "组队情况下能力提升，可提升自身和队友能力。" },
    [Item.EQUIPPOS_SIGNET] = { "ObjSignet", "ImgSignet", "佩戴后可解决角色相生相克之忧。" },
    [Item.EQUIPPOS_MANTLE] = { "ObjMantle", "ImgMantle", "为人物增加大量血量、抗性、攻击力、各种负面效果抗性等。" },
    [Item.EQUIPPOS_CHOP] = { "ObjChop", "ImgChop", "各种攻防能力，提升周围友方能力。" },
    [Item.EQUIPPOS_ZHENYUAN_MAIN] = {
      "ObjZhenYuanMain",
      "ImgZhenYuanMain",
      "人物100级以上可佩戴，相当于一个人物装备，增加各种强力属性。",
    },
    [Item.EQUIPPOS_ZHENYUAN_SUB1] = { "ObjZhenYuanSub1", "ImgZhenYuanSub1", "第二真元暂未开放。" },
    [Item.EQUIPPOS_ZHENYUAN_SUB2] = { "ObjZhenYuanSub2", "ImgZhenYuanSub2", "第三真元暂未开放。" },
    [Item.EQUIPPOS_GARMENT] = { "ObjGarment", "ImgGarment", "可改变侠士外形，分外帽和外衣两种。" },
    [Item.EQUIPPOS_OUTHAT] = { "ObjOutHat", "ImgOutHat", "可改变侠士外形，分外帽和外衣两种。" },
  }

local SELF_SWITCHABLE_EQUIP = {
  { Item.EQUIPEXPOS_HEAD, "ObjHead", "ImgHead" },
  { Item.EQUIPEXPOS_BODY, "ObjBody", "ImgBody" },
  { Item.EQUIPEXPOS_BELT, "ObjBelt", "ImgBelt" },
  { Item.EQUIPEXPOS_WEAPON, "ObjWeapon", "ImgWeapon" },
  { Item.EQUIPEXPOS_FOOT, "ObjFoot", "ImgFoot" },
  { Item.EQUIPEXPOS_CUFF, "ObjCuff", "ImgCuff" },
  { Item.EQUIPEXPOS_AMULET, "ObjAmulet", "ImgAmulet" },
  { Item.EQUIPEXPOS_RING, "ObjRing", "ImgRing" },
  { Item.EQUIPEXPOS_NECKLACE, "ObjNecklace", "ImgNecklace" },
  { Item.EQUIPEXPOS_PENDANT, "ObjPendant", "ImgPendant" },
}

local ATTRIB_EDIT_TABLE = {
  [Player.ATTRIB_STR] = EDIT_BASIC_STR,
  [Player.ATTRIB_DEX] = EDIT_BASIC_DEX,
  [Player.ATTRIB_VIT] = EDIT_BASIC_VIT,
  [Player.ATTRIB_ENG] = EDIT_BASIC_ENG,
}

------ 构造函数 ------

function tbPlayerPanel:Init()
  self.nRemain = 0 -- 显示剩余潜能点数（加点期间和实际点数可能不同）
  self.tbReputeSetting = nil
  self.tbTitleTable = {} -- 称号列表
  self.tbHonorData = {}
  self.nSelTitleIndex = 0 -- 所选称号索引
  self.nShowEquipEx = 0 -- 当前显示装备
  self.nShowPartnerEquip = 0
  self.nCurHistroyPage = HISTORY_PAGE_NORMAL
  self.tbDeltaAttrib = -- 该表记录加点差值
    {
      [Player.ATTRIB_STR] = 0, -- 本次所加力量点数
      [Player.ATTRIB_DEX] = 0, -- 本次所加身法点数
      [Player.ATTRIB_VIT] = 0, -- 本次所加外功点数
      [Player.ATTRIB_ENG] = 0, -- 本次所加内功点数
    }
end

-- 创建期，创建OBJ容器
function tbPlayerPanel:OnCreate()
  self.tbReputeSetting = KPlayer.GetReputeInfo() -- 获得声望配置信息
  self:ReadReputeCfg() -- 初始化读取配置文件建好声望数据表
  --	2012/8/1 15:24:28	记得在窗口Destroy的时候把注册进去的Container删除掉
  self.tbAwardGridCont = {}
  for nIndex, tbGrid in pairs(self.IMG_GRID_REPUTE_AWARD) do
    self.tbAwardGridCont[nIndex] = tbObject:RegisterContainer(self.UIGROUP, tbGrid[1], 1, 1, nil, "repute_info_award")
    self.tbAwardGridCont[nIndex].OnObjGridEnter = self.OnObjGridEnter
    self.tbAwardGridCont[nIndex].ClickMouse = self.ClickMouse
    self.tbAwardGridCont[nIndex].UpdateItem = self.UpdateItem
    self.tbAwardGridCont[nIndex].FormatItem = self.FormatItem
  end

  self.tbEquipCont = {}
  for _, tb in ipairs(SELF_EQUIPMENT) do
    local nPos = tb[1]
    self.tbEquipCont[nPos] = tbObject:RegisterContainer(self.UIGROUP, tb[2], 1, 1, { nOffsetX = nPos }, "equiproom")
  end
  self.tbObjPreView = {}
  self.tbObjPreView = tbObject:RegisterContainer(self.UIGROUP, OBJ_EQUIP_PREVIEW)
  self.nCurMarriageTypeCmbIndex = 0
  self.nCurSexCmbIndex = 0
  self.nCurYearCmbIndex = 0
  self.nCurMonthCmbIndex = 0
  self.nCurDayCmbIndex = 0
  self.nCurProvinceIndex = 0
  self.nCurCityIndex = 0
end

--读取声望配置信息
function tbPlayerPanel:ReadReputeCfg()
  local tbReputeInfoConfigOrig = Lib:LoadTabFile("\\setting\\player\\reputeiteminfo.txt") --读取txt文件
  if not tbReputeInfoConfigOrig then -- 如果读取失败则直接返回 不执行下面的步骤
    return 0
  end
  local tbReputeInfoConfigTmp = {}
  for nIndex, tbReputeCheckConfig in pairs(tbReputeInfoConfigOrig) do -- 建立商店ID的检查表	这里需要考虑前几列为说明信息的情况
    local nRecommend = tonumber(tbReputeCheckConfig.Recommend) or 0
    local nWeight = tonumber(tbReputeCheckConfig.Weight) or 0
    local nIndexParent = tonumber(tbReputeCheckConfig.IndexParent) or 0
    local nIndexChild = tonumber(tbReputeCheckConfig.IndexChild) or 0
    local szTxtInfoAddr = tbReputeCheckConfig.TxtInfoAddr
    local szFilterType = tbReputeCheckConfig.FilterType
    local szMainType = tbReputeCheckConfig.MainType
    local szAward = tbReputeCheckConfig.Award
    local szTips = tbReputeCheckConfig.Tips
    local szInfoTitle = tbReputeCheckConfig.InfoTitle
    local nHighLevel = tonumber(tbReputeCheckConfig.HighLevel) or 0

    local szShopID = tbReputeCheckConfig.ShopID
    if nIndexParent > 0 and nIndexChild > 0 then
      local tbCont = {
        ["nRecommend"] = nRecommend,
        ["nWeight"] = nWeight,
        ["nIndexParent"] = nIndexParent,
        ["nIndexChild"] = nIndexChild,
        ["szTxtInfoAddr"] = szTxtInfoAddr,
        ["szFilterType"] = szFilterType,
        ["szMainType"] = szMainType,
        ["szAward"] = szAward,
        ["szTips"] = szTips,
        ["szInfoTitle"] = szInfoTitle,
        ["nHighLevel"] = nHighLevel,
        ["szShopID"] = szShopID,
      }
      for i = 1, 10 do
        tbCont["nMAwardPic" .. i] = tbReputeCheckConfig["MAwardPic" .. i]
        tbCont["nWAwardPic" .. i] = tbReputeCheckConfig["WAwardPic" .. i]
      end
      tbReputeInfoConfigTmp[#tbReputeInfoConfigTmp + 1] = tbCont
    end
  end

  table.sort(tbReputeInfoConfigTmp, function(tbVal1, tbVal2)
    return (tbVal1.nWeight > tbVal2.nWeight)
  end)

  -- tbReputeInfoConfig中的数据 按照权重排序
  self.tbReputeInfoConfig = tbReputeInfoConfigTmp

  --	构造Table tbReputeInfoConfigSpec	用来以 [ 父索引 | 子索引 ] 的方式取得相应物品信息
  self.tbReputeInfoConfigSpec = {}
  for i = 1, #self.tbReputeInfoConfig do
    self.tbReputeInfoConfigSpec[self.tbReputeInfoConfig[i].nIndexParent] = {}
  end
  for i = 1, #self.tbReputeInfoConfig do
    self.tbReputeInfoConfigSpec[self.tbReputeInfoConfig[i].nIndexParent][self.tbReputeInfoConfig[i].nIndexChild] = self.tbReputeInfoConfig[i]
  end
end

function tbPlayerPanel:AddXMLItemToReputeCfg()
  -- 从repute.xml中读取声望信息 如果在repute.txt中没有找到相应的声望信息 则默认插入之
  for nIndexParent, tbChild in pairs(self.tbReputeSetting) do
    for nIndexChild, tbInfo in pairs(tbChild) do
      if type(tbInfo) == "table" then
        if (self.tbReputeInfoConfigSpec[nIndexParent] == nil) or (self.tbReputeInfoConfigSpec[nIndexParent][nIndexChild] == nil) then
          --如果为空说明此声望在repute.txt中不存在 更新表
          local nHighLevel = self:GetReputeMaxLevel(nIndexParent, nIndexChild)
          local tbCont = {
            ["nRecommend"] = 0,
            ["nWeight"] = 0,
            ["nIndexParent"] = nIndexParent,
            ["nIndexChild"] = nIndexChild,
            ["szTxtInfoAddr"] = "", --无
            ["szFilterType"] = "6", -- tbPlayerPanel.tbFilter   6代表其他类
            ["szMainType"] = "其他",
            ["szAward"] = "其他",
            ["szTips"] = tbInfo.szTips,
            ["szInfoTitle"] = tbInfo.szName,
            ["nHighLevel"] = nHighLevel,
            ["szShopID"] = "",
            ["tbReputeXML"] = tbCont,
          }
          for i = 1, 10 do
            tbCont["nMAwardPic" .. i] = ""
            tbCont["nWAwardPic" .. i] = ""
          end
          if self.tbReputeInfoConfigSpec[nIndexParent] == nil then
            self.tbReputeInfoConfigSpec[nIndexParent] = {}
          end
          self.tbReputeInfoConfigSpec[nIndexParent][nIndexChild] = tbCont --将Item添加到两张表中
          table.insert(self.tbReputeInfoConfig, tbCont)
        else
          if self.tbReputeInfoConfigSpec[nIndexParent][nIndexChild].tbReputeXML == nil then
            self.tbReputeInfoConfigSpec[nIndexParent][nIndexChild].tbReputeXML = tbInfo
          end
        end
      end
    end
  end
end

function tbPlayerPanel:OnDestroy()
  for _, tbCont in pairs(self.tbAwardGridCont) do
    if tbCont then
      tbObject:UnregContainer(tbCont)
    end
  end

  for _, tbCont in pairs(self.tbEquipCont) do
    if tbCont then
      tbObject:UnregContainer(tbCont)
    end
  end

  tbObject:UnregContainer(self.tbObjPreView)
end

--写log
function tbPlayerPanel:WriteStatLog()
  Log:Ui_SendLog("F1主角界面", 1)
end

-- 打开
function tbPlayerPanel:OnOpen()
  self.tbReputeSetting = KPlayer.GetReputeInfo() -- 获得声望配置信息
  self:AddXMLItemToReputeCfg()
  self.nIsCanUpdateReputePage = 1 --防止没有打开窗口时也更新声望窗口带来的CPU资源浪费

  if UiManager:WindowVisible(Ui.UI_ENHANCESELECTEQUIP) == 1 then
    UiManager:CloseWindow(Ui.UI_ENHANCESELECTEQUIP)
  end

  self:WriteStatLog()
  UiManager:CloseWindow(Ui.UI_SERIESSWITCH)
  self:SetShowEquipState()
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 1)

  --Wnd_SetEnable(self.UIGROUP,  "BtnHistory", 0);		-- 禁用历程页

  self.nRemain = me.nRemainPotential -- 获得实际剩余潜能点数

  -- 更新所有页面			-- TODO: xyf 其实只需要在此初始化当前页面，以后再改
  self:OnUpdatePageBasic()
  self:OnUpdatePageRepute()
  self:OnUpdatePageTitle()
  self:OnUpdatePageHistory()
  self:UpdateEquipment()

  self:UpdateReputeCombo()
  self:ResizeMainWnd(self.NOT_INVOLVE_POP_WND)

  PgSet_ActivePage(self.UIGROUP, PAGESET_MAIN, PAGE_BASIC) -- 设置首页
  self:OnUpdatePreView()
  self:UpdateEquipDur()
  if Player.tbFightPower:IsFightPowerValid() == 1 then
    self:UpdateFightPower(me.GetTask(Player.tbFightPower.TASK_GROUP, Player.tbFightPower.TASK_FIGHTPOWER) / 100)
  end

  for i = 1, self.NUM_CONTROL_CLASS do
    Wnd_Show(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[i][1])
    Wnd_Show(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[i][2])
  end
end

-- 关闭
function tbPlayerPanel:OnClose()
  self.nPosReputeScroll = ScrPanel_GetDocumentTopLen(self.UIGROUP, self.REPUTE_SCROLL_PANEL)
  self.nIsNewOpen = 1
  for _, tbCont in pairs(self.tbEquipCont) do
    tbCont:ClearRoom()
  end
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
  UiManager:CloseWindow(Ui.UI_OTHER_EQUIP)
  self.nShowEquipEx = 0
  self.nShowPartnerEquip = 0

  self.nIsCanUpdateReputePage = 0

  UiManager:CloseWindow(Ui.UI_CHOOSEPORTRAIT)
end

function tbPlayerPanel:OnSyncItem(nRoom, nX, nY)
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  self:OnUpdatePreView()
  self:UpdateCellTips()
end

function tbPlayerPanel:OnUpdatePreView()
  self.tbObjPreView:ClearObj()
  local tbPart = tbPreViewMgr:GetSelfPart()
  local nSex = me.nSex
  local tbObj = {}
  tbObj.nType = Ui.OBJ_NPCRES
  tbObj.nTemplateId = (nSex == 0) and -1 or -2
  tbObj.nAction = Npc.ACT_STAND1
  tbObj.tbPart = tbPart
  tbObj.nDir = 0
  tbObj.bRideHorse = 0
  self.tbObjPreView:SetObj(tbObj)
end

-- 当有按钮被按下
function tbPlayerPanel:OnButtonClick(szWnd, nParam)
  if BTN_CLOSE == szWnd or BTN_BLOGCLOSE == szWnd then -- 关闭主窗口
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:CloseWindow(Ui.UI_OTHER_EQUIP)
  elseif BTN_SWITCH == szWnd then -- 五行装备切换
    self:OnSwitch()
  elseif BTN_SEL_PORTRAIT == szWnd then -- 打开头像选择界面
    UiManager:OpenWindow(Ui.UI_CHOOSEPORTRAIT)
  elseif BTN_BASIC_ASSAUTO == szWnd then -- 自动分配潜能
    self:OnAutoAssign()
  elseif BTN_BASIC_ASSOK == szWnd then -- 确认潜能分配
    self:OnSubmitAssign()
  elseif BTN_BASIC_ASSCANCEL == szWnd then -- 取消潜能分配
    self:OnCancelAssign()
  elseif BTN_BASIC_INCSTR == szWnd then -- 力量分配递增
    self:OnIncrease(Player.ATTRIB_STR)
  elseif BTN_BASIC_DECSTR == szWnd then -- 力量分配递减
    self:OnDecrease(Player.ATTRIB_STR)
  elseif BTN_BASIC_INCDEX == szWnd then -- 身法分配递增
    self:OnIncrease(Player.ATTRIB_DEX)
  elseif BTN_BASIC_DECDEX == szWnd then -- 身法分配递减
    self:OnDecrease(Player.ATTRIB_DEX)
  elseif BTN_BASIC_INCVIT == szWnd then -- 外功分配递增
    self:OnIncrease(Player.ATTRIB_VIT)
  elseif BTN_BASIC_DECVIT == szWnd then -- 外功分配递减
    self:OnDecrease(Player.ATTRIB_VIT)
  elseif BTN_BASIC_INCENG == szWnd then -- 内功分配递增
    self:OnIncrease(Player.ATTRIB_ENG)
  elseif BTN_BASIC_DECENG == szWnd then -- 内功分配递减
    self:OnDecrease(Player.ATTRIB_ENG)
  elseif BTN_ACTIVE_TITLE == szWnd then -- 激活称号
    self:OnActiveTitle()
  elseif BTN_INACTIVE_TITLE == szWnd then -- 激活称号
    --	打开其他Page时把声望Information界面隐藏
    self:OnInactiveTitle()
  elseif BTN_EQUIP_PAGE == szWnd then
    self:SwitchEquipPage()
  elseif BTN_EQUIP_PARTNER == szWnd then
    self:ShowPartnerEquipPage()
  elseif BTN_SWITCH_EQUIP == szWnd then
    self:ApplySwitchEquip()
  elseif BTN_HONOR == szWnd then
    --	打开其他Page时把声望Information界面隐藏
    Wnd_Hide(self.UIGROUP, tbPlayerPanel.WND_REPUTE_INFO)
    self:OnRequestHonorData()
    self:OnUpdatePageHistory()
    self:ResizeMainWnd(self.NOT_INVOLVE_POP_WND)
  elseif BTN_PUBLISHBLOG == szWnd then
    Ui(Ui.UI_SNS_ENTRANCE):OpenSNSmain()
  elseif self.BTN_VIEW_WEALTH_VALUE == szWnd then
    self:ProcessViewWealth()
  elseif self.ReputeInfoWndBtnClose == szWnd then
    self:ProcessReputePopWndCloseBtn()
    self:ResizeMainWnd(self.NOT_INVOLVE_POP_WND)
  elseif self.BTN_PAGE_BASIC == szWnd then --点击属性按钮时 隐藏声望Information弹出窗
    Wnd_Hide(self.UIGROUP, self.WND_REPUTE_INFO)
    self:ResizeMainWnd(self.NOT_INVOLVE_POP_WND)
  elseif self.BTN_PAGE_NAME == szWnd then --点击称号按钮时 隐藏声望Information弹出窗
    Wnd_Hide(self.UIGROUP, self.WND_REPUTE_INFO)
    self:ResizeMainWnd(self.NOT_INVOLVE_POP_WND)
  elseif self.REPUTEINFOWNDPRIZELEFT == szWnd then --向左边拉一格
    self:ProcessReputeAwardLeft()
  elseif self.REPUTEINFOWNDPRIZERIGHT == szWnd then --向右边拉一格
    self:ProcessReputeAwardRight()
  elseif self.BTNREPUTEINFOWNDPRIZESHOP == szWnd then -- 点击购买声望物品的商店按钮
    self:OpenReputeShop()
  elseif self.BTN_PAGE_REPUTE == szWnd then -- 点击声望按钮时	如果上次的声望说明弹出窗口打开 则这次同样打开 否则关闭
    self:ProcessReputePageClick()
  elseif self.BTN_FIX_ALL_EQUIPMENT == szWnd then
    Ui(Ui.UI_PLAYERPANEL):RepairJxAll()
  elseif BTN_EDITBLOGEditBLOG == szWnd then
    --	打开其他Page时把声望Information界面隐藏
    Wnd_Hide(self.UIGROUP, tbPlayerPanel.WND_REPUTE_INFO)

    local tbBlogMsg = {}
    tbBlogMsg.szMsg = "提示：你的浏览器将自动打开访问该网址，请谨防木马病毒！"
    tbBlogMsg.nOptCount = 2
    local blogUrl = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGEditBLOG)
    function tbBlogMsg:Callback(nOptIndex, szUrl)
      if nOptIndex == 2 then
        ShellExecute(szUrl)
      end
    end
    if blogUrl ~= nil and blogUrl ~= "" then
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbBlogMsg, blogUrl)
    end
  elseif PAGE_EDITBLOG == szWnd then --	打开信息分页栏
    --	打开其他Page时把声望Information界面隐藏
    Wnd_Hide(self.UIGROUP, tbPlayerPanel.WND_REPUTE_INFO)
    self:ResizeMainWnd(self.NOT_INVOLVE_POP_WND)

    UiManager.bEditBlogState = 1
    PProfile:Require(me.szName) --	?
  elseif BTN_EDITBLOGSAVE == szWnd then
    local szName = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGNAME) --名称
    --local szBlogMonicker = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGMONICKER);
    --local szFaction = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGOCCUPATION);
    --local szCity = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGCITY); -- 城市
    local nYear = Edt_GetInt(self.UIGROUP, EDT_BoxYearEditBlog)
    local nMonth = Edt_GetInt(self.UIGROUP, EDT_BoxMonthEditBlog)
    local nDay = Edt_GetInt(self.UIGROUP, EDT_BoxDateEditBlog)
    local szProvince = Edt_GetTxt(self.UIGROUP, EDT_BoxEdtEditBlogProvince)
    local szCity = Edt_GetTxt(self.UIGROUP, EDT_EdtEditBlogCity)
    --local nBlogCity = Edt_GetTxt(self.UIGROUP, CMB_EDITBLOGCITY, self.nCurCityIndex);
    --local szBlogTag = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGTAG);
    --local szLike = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGLIKE);
    --local szBlogBlog = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGEditBLOG);
    local szDianDi = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI) -- 签名
    --local lingChen = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGLINGCHEN);
    --local shangWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGSHANGWU);
    --local zhongWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGZHONGWU);
    --local xiaWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGXIAWU);
    --local wanShang = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGWANSHANG);
    --local wuYe = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGWUYE);
    --local nOnlineTime = KPProfile.BoolOffset(lingChen, shangWu, zhongWu, xiaWu, wanShang, wuYe);
    --[[if (szName ~= nil and szName ~= "" and
				szBlogMonicker ~= nil and szBlogMonicker ~= "" and
				szFaction ~= nil and szFaction ~= "" and
				szCity ~= nil and szCity ~= "" and
				szBlogTag ~= nil and szBlogTag ~= "" and
				szLike ~= nil and szLike ~= "" and szLike ~= "（写下你特有的爱好吧！）" and
				szBlogBlog ~= nil and szBlogBlog ~= ""  and
				szDianDi ~= nil and szDianDi ~= "" and szDianDi ~= string.format("友情提示：第一次填写此界面的话能获得奖励100绑定%s！", IVER_g_szCoinName) and
				nOnlineTime ~= nil and nOnlineTime ~= 0) then]]
    --

    --原始代码
    --if (self.nProfileVersion == 0) then
    --self:ApplyAllBlogInfo();
    --else
    --self:ApplyBlogInfo();
    --end

    --由于SNS功能的加入，客户端取消判断nProfileVersion，统一都使用ApplyAllBlogInfo
    if szName ~= nil and szName ~= "" and nYear ~= "" and nYear >= 1900 and nYear <= tonumber(GetLocalDate("%Y")) and nMonth ~= "" and nMonth > 0 and nDay ~= "" and nDay > 0 and szProvince ~= "" and szCity ~= "" and szDianDi ~= nil and szDianDi ~= "" and szDianDi ~= string.format("友情提示：第一次填写此界面的话能获得奖励100绑定%s！", IVER_g_szCoinName) then
      self:ApplyAllBlogInfo()
    elseif nYear < 1900 or nYear > tonumber(GetLocalDate("%Y")) or nMonth <= 0 or nDay <= 0 then
      local tbApplyMsg = {}
      tbApplyMsg.szMsg = "您填写的日期格式不对(2011-11-11)，无法保存，(注：年份>1900)。"
      tbApplyMsg.nOptCount = 1
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbApplyMsg)
    else
      local tbApplyMsg = {}
      tbApplyMsg.szMsg = "您填写的内容不完整，无法保存。"
      tbApplyMsg.nOptCount = 1
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbApplyMsg)
    end
  elseif BTN_FIGHTPOWER == szWnd then
    if 1 == Player.tbFightPower:IsFightPowerValid() then
      UiManager:SwitchWindow(Ui.UI_FIGHTPOWER)
    else
      Ui:ServerCall("UI_TASKTIPS", "Begin", "战斗力系统还未开放，敬请期待")
    end
  elseif BTN_HIDE_MANTLE == szWnd then
    me.CallServerScript({ "PlayerCmd", "OnClickHideMantle", me.nId })
  elseif BTN_BE_INVITOR == szWnd then
    me.CallServerScript({ "BeInvitor" })
  end
end

-- 当编辑框失去焦点
function tbPlayerPanel:OnEditSubmit(szWnd)
  if EDIT_BASIC_STR == szWnd then
    self:OnEditKillFocus(Player.ATTRIB_STR) -- 力量加点编辑框失去焦点
  elseif EDIT_BASIC_DEX == szWnd then
    self:OnEditKillFocus(Player.ATTRIB_DEX) -- 身法加点编辑框失去焦点
  elseif EDIT_BASIC_VIT == szWnd then
    self:OnEditKillFocus(Player.ATTRIB_VIT) -- 外功加点编辑框失去焦点
  elseif EDIT_BASIC_ENG == szWnd then
    self:OnEditKillFocus(Player.ATTRIB_ENG) -- 内功加点编辑框失去焦点
  end
end

-- 编辑框获得焦点
function tbPlayerPanel:OnEditFocus(szWnd)
  if EDT_EDITBLOGDIANDI == szWnd then
    local szQianMing = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI)
    if szQianMing == string.format("友情提示：第一次填写此界面的话能获得奖励100绑定%s！", IVER_g_szCoinName) then
      Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI, "")
    end
  end
end

function tbPlayerPanel:OnEditChange(szWnd, nParam)
  if EDIT_BASIC_NAME == szWnd then
    if Edt_GetTxt(self.UIGROUP, EDIT_BASIC_NAME) ~= me.szName then
      Edt_SetTxt(self.UIGROUP, EDIT_BASIC_NAME, me.szName)
    end
  elseif EDT_BoxYearEditBlog == szWnd then
    local nYear = Edt_GetInt(self.UIGROUP, EDT_BoxYearEditBlog)
    local nMaxYear = math.min(nYear, tonumber(GetLocalDate("%Y")))
    local nMinYear = math.max(nYear, 1950)
    if nYear and nYear > nMaxYear then
      Edt_SetInt(self.UIGROUP, EDT_BoxYearEditBlog, nMaxYear)
    end
  elseif EDT_BoxMonthEditBlog == szWnd then
    local nMonth = Edt_GetInt(self.UIGROUP, EDT_BoxMonthEditBlog)
    local nMinMonth = math.min(nMonth, 12)
    if nMonth and nMonth > nMinMonth then
      Edt_SetInt(self.UIGROUP, EDT_BoxMonthEditBlog, nMinMonth)
    end
  elseif EDT_BoxDateEditBlog == szWnd then
    local nDay = Edt_GetInt(self.UIGROUP, EDT_BoxDateEditBlog)
    local nYear = Edt_GetInt(self.UIGROUP, EDT_BoxYearEditBlog)
    local nMonth = Edt_GetInt(self.UIGROUP, EDT_BoxMonthEditBlog)
    local nMinDay = math.min(nDay, 31)
    if nYear and nMonth and nYear > 0 and nMonth == 2 then
      if math.fmod(nYear, 4) == 0 then
        nMinDay = math.min(nMinDay, 29)
      else
        nMinDay = math.min(nMinDay, 28)
      end
    end
    if nDay and nDay > nMinDay then
      Edt_SetInt(self.UIGROUP, EDT_BoxDateEditBlog, nMinDay)
    end
  end
  local nMonth = Edt_GetInt(self.UIGROUP, EDT_BoxMonthEditBlog)
  local nDay = Edt_GetInt(self.UIGROUP, EDT_BoxDateEditBlog)
  self:UpdateStar(nMonth, nDay)
end

-- 下拉菜单改变
function tbPlayerPanel:OnComboBoxIndexChange(szWnd, nIndex)
  if UiManager:WindowVisible(Ui.UI_PLAYERPANEL) == 1 then
    if szWnd == tbPlayerPanel.REPUTE_PAGE_COMBOBOX then
      self.nReputeCurrentSelComboIndex = nIndex + 1
      self.nIsOpenTheReputePopInfoWnd = 0 --改变Combo时 关闭先前声望介绍弹出窗 并将记忆功能关闭
      self.nComboBoxChanged = 1
      self.nGroupIndex = -1
      self.nItemIndex = -1
      Wnd_Hide(self.UIGROUP, tbPlayerPanel.WND_REPUTE_INFO)
      self:ResizeMainWnd(self.NOT_INVOLVE_POP_WND)
      self:OnUpdatePageRepute()
    end
    if szWnd == CMB_PROPERTY_TYPE then
      self.nCurPropertyType = nIndex
      self:RefreshPropertyDisplay()
    end
    if szWnd == CMB_EDITBLOGMARRIAGE then
      self.nCurMarriageTypeCmbIndex = nIndex
    end
    if szWnd == CMB_EDITBLOGSEX then
      self.nCurSexCmbIndex = nIndex
    end
    if szWnd == CMB_YEAR then
      self.nCurYearCmbIndex = nIndex
    end
    if szWnd == CMB_MONTH then
      self.nCurMonthCmbIndex = nIndex
      self:UpdateStar()
    end
    if szWnd == CMB_DATE then
      self.nCurDayCmbIndex = nIndex
      self:UpdateStar()
    end
    if szWnd == CMB_EDITBLOGPROVINCE then
      self.nCurProvinceIndex = nIndex
      self:RefreshCityCombo(nIndex)
    end
    if szWnd == CMB_EDITBLOGCITY then
      self.nCurCityIndex = nIndex
    end
  end
end

function tbPlayerPanel:RefreshCityCombo(nIndex)
  ClearComboBoxItem(self.UIGROUP, CMB_EDITBLOGCITY)
  for icity = 1, #CITY[nIndex + 1] do
    ComboBoxAddItem(self.UIGROUP, CMB_EDITBLOGCITY, icity, CITY[nIndex + 1][icity])
  end
  ComboBoxSelectItem(self.UIGROUP, CMB_EDITBLOGCITY, 0)
end

function tbPlayerPanel:RefreshPropertyDisplay()
  --[[
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_LIFE);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_MANA);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_STAMINA);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_GTP);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_MKP);
	
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_AR);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_DEFENSE);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_RUNSPEED);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_AS);
	Wnd_Hide(self.UIGROUP, TEXT_DEADLYSTRIKE_RATE);
	
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_GR);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_PR);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_CR);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_FR);
	Wnd_Hide(self.UIGROUP, TEXT_BASIC_LR);
	
	if self.nCurPropertyType == PROPERTY_TYPE_BASIC then
		-- 生命、内力、体力、活力、精力
		Wnd_Show(self.UIGROUP, TEXT_BASIC_LIFE);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_MANA);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_STAMINA);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_GTP);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_MKP);			
	elseif self.nCurPropertyType == PROPERTY_TYPE_ATTACK then
		-- 命中、闪避、跑速、攻速、会心
		Wnd_Show(self.UIGROUP, TEXT_BASIC_AR);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_DEFENSE);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_RUNSPEED);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_AS);
		Wnd_Show(self.UIGROUP, TEXT_DEADLYSTRIKE_RATE);
	elseif self.nCurPropertyType == PROPERTY_TYPE_DEFENSE then
		-- 普防、冰防、毒防、火防、雷防
		Wnd_Show(self.UIGROUP, TEXT_BASIC_GR);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_PR);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_CR);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_FR);
		Wnd_Show(self.UIGROUP, TEXT_BASIC_LR);
	end
	]]
  --
end

------ 自定义消息处理函数 ------

function tbPlayerPanel:ApplyAllBlogInfo()
  local szName = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGNAME)

  --local szCity = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGCITY);

  --local nBlogProvince = GetComboBoxItemId(self.UIGROUP, CMB_EDITBLOGPROVINCE, self.nCurProvinceIndex)
  --local nBlogCity = GetComboBoxItemId(self.UIGROUP, CMB_EDITBLOGCITY, self.nCurCityIndex);
  local szCity = Edt_GetTxt(self.UIGROUP, EDT_BoxEdtEditBlogProvince) .. "\\" .. Edt_GetTxt(self.UIGROUP, EDT_EdtEditBlogCity)
  local szQianming = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI)

  local nSexID = GetComboBoxItemId(self.UIGROUP, CMB_EDITBLOGSEX, self.nCurSexCmbIndex)
  nSexID = nSexID - 1

  --local nyear = GetComboBoxItemId(self.UIGROUP, CMB_YEAR, self.nCurYearCmbIndex) - 1;
  --local nmonth = GetComboBoxItemId(self.UIGROUP, CMB_MONTH, self.nCurMonthCmbIndex) - 1;
  --local nday = GetComboBoxItemId(self.UIGROUP, CMB_DATE, self.nCurDayCmbIndex) - 1;
  local nyear = tonumber(Edt_GetInt(self.UIGROUP, EDT_BoxYearEditBlog))
  local nmonth = tonumber(Edt_GetInt(self.UIGROUP, EDT_BoxMonthEditBlog))
  local nday = tonumber(Edt_GetInt(self.UIGROUP, EDT_BoxDateEditBlog))
  local nBlogBirthday = TOOLS_MakeDate(nmonth, nday, nyear)

  local nMarriageType = GetComboBoxItemId(self.UIGROUP, CMB_EDITBLOGMARRIAGE, self.nCurMarriageTypeCmbIndex)

  local nFriendOnly = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGFRIENDONLY)

  PProfile:EditAllInfo2(szName, nSexID, nBlogBirthday, szCity, nMarriageType, szQianming, nFriendOnly)
  --self.nProfileVersion = 1;
end

function tbPlayerPanel:ApplyBlogInfo()
  local szName = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGNAME)
  if szOldName ~= szName then
    PProfile:ApplyEditStr(PProfile.emPF_BUFTASK_NAME, szName)
  end

  local szBlogMonicker = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGMONICKER)
  if szOldBlogMonicker ~= szBlogMonicker then
    PProfile:ApplyEditStr(PProfile.emPF_BUFTASK_AGNAME, szBlogMonicker)
  end

  local szFaction = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGOCCUPATION)
  if szOldFaction ~= szFaction then
    PProfile:ApplyEditStr(PProfile.emPF_BUFTASK_PROFESSION, szFaction)
  end

  local szCity = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGCITY)
  if szOldCity ~= szCity then
    PProfile:ApplyEditStr(PProfile.emPF_BUFTASK_CITY, szCity)
  end

  local szBlogTag = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGTAG)
  if szOldBlogTag ~= szBlogTag then
    PProfile:ApplyEditStr(PProfile.emPF_BUFTASK_TAG, szBlogTag)
  end

  local szLike = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGLIKE)
  if szOldLike ~= szLike then
    PProfile:ApplyEditStr(PProfile.emPF_BUFTASK_FAVORITE, szLike)
  end

  local szBlogBlog = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGEditBLOG)
  if szOldBlogBlog ~= szBlogBlog then
    PProfile:ApplyEditStr(PProfile.emPF_BUFTASK_BLOGURL, szBlogBlog)
  end

  local szDianDi = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI)
  if szOldDianDi ~= szDianDi then
    PProfile:ApplyEditStr(PProfile.emPF_BUFTASK_COMMENT, szDianDi)
  end

  local nSexID = GetComboBoxItemId(self.UIGROUP, CMB_EDITBLOGSEX, self.nCurSexCmbIndex)
  nSexID = nSexID - 1
  if nOldSex ~= nSexID then
    PProfile:ApplyEditInt(PProfile.emPF_TASK_SEX, nSexID)
  end

  --local nyear = GetComboBoxItemId(self.UIGROUP, CMB_YEAR, self.nCurYearCmbIndex) - 1;
  --local nmonth = GetComboBoxItemId(self.UIGROUP, CMB_MONTH, self.nCurMonthCmbIndex) - 1;
  --local nday = GetComboBoxItemId(self.UIGROUP, CMB_DATE, self.nCurDayCmbIndex) - 1;
  local nyear = tonumber(Edt_GetInt(self.UIGROUP, EDT_BoxYearEditBlog))
  local nmonth = tonumber(Edt_GetInt(self.UIGROUP, EDT_BoxMonthEditBlog))
  local nday = tonumber(Edt_GetInt(self.UIGROUP, EDT_BoxDateEditBlog))
  local nBlogBirthday = TOOLS_MakeDate(nmonth, nday, nyear)
  if nOldBlogBirthday ~= nBlogBirthday then
    PProfile:ApplyEditInt(PProfile.emPF_TASK_BIRTHD, nBlogBirthday)
  end

  local nMarriageType = GetComboBoxItemId(self.UIGROUP, CMB_EDITBLOGMARRIAGE, self.nCurMarriageTypeCmbIndex)
  if nOldMarriageType ~= nMarriageType then
    PProfile:ApplyEditInt(PProfile.emPF_TASK_REINS, nMarriageType)
  end

  local lingChen = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGLINGCHEN)
  local shangWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGSHANGWU)
  local zhongWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGZHONGWU)
  local xiaWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGXIAWU)
  local wanShang = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGWANSHANG)
  local wuYe = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGWUYE)
  local nOnlineTime = KPProfile.BoolOffset(lingChen, shangWu, zhongWu, xiaWu, wanShang, wuYe)
  if nOldOnlineTime ~= nOnlineTime then
    PProfile:ApplyEditInt(PProfile.emPF_TASK_ONLINE, nOnlineTime)
  end

  local nFriendOnly = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGFRIENDONLY)
  if nOldFriendOnly ~= nFriendOnly then
    PProfile:ApplyEditInt(PProfile.emPF_TASK_FRIEND_ONLY, nFriendOnly)
  end
end

function tbPlayerPanel:OnUpdatePageAllBlog(RealName, NickName, Profession, Tip, Favor, blog, diary, city, sex, birth, love, online, friendonly, first)
  if UiManager.bEditBlogState == 1 then
    self:OnUpdatePageEditBlog(RealName, NickName, Profession, Tip, Favor, blog, diary, city, sex, birth, love, online, friendonly, first)
  end
end

function tbPlayerPanel:OnUpdatePageEditBlog(szName, szBlogMonicker, szFaction, szBlogTag, szLike, szBlogBlog, szDianDi, szCity, nSex, nBlogBirthday, nMarriageType, nOnlineTime, nFriendOnly, nProfileVersion)
  --self.nProfileVersion = nProfileVersion;

  szOldName = szName
  szOldBlogMonicker = szBlogMonicker
  szOldFaction = szFaction
  szOldBlogTag = szBlogTag
  szOldLike = szLike
  szOldBlogBlog = szBlogBlog
  szOldDianDi = szDianDi
  szOldCity = szCity
  nOldSex = nSex
  nOldBlogBirthday = nBlogBirthday
  nOldMarriageType = nMarriageType
  nOldOnlineTime = nOnlineTime
  nOldFriendOnly = nFriendOnly

  -- 更新博客基本信息
  Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGNAME, szName)

  Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGMONICKER, szBlogMonicker)

  Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGOCCUPATION, szFaction)

  ClearComboBoxItem(self.UIGROUP, CMB_EDITBLOGSEX)
  for i = 1, #SEX_TYPE do
    ComboBoxAddItem(self.UIGROUP, CMB_EDITBLOGSEX, i, SEX_TYPE[i])
  end
  local nSexIdx = nSex
  if nSexIdx >= 0 and nSexIdx <= (#SEX_TYPE - 1) then
    ComboBoxSelectItem(self.UIGROUP, CMB_EDITBLOGSEX, nSexIdx)
  else
    ComboBoxSelectItem(self.UIGROUP, CMB_EDITBLOGSEX, 0)
  end

  Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGTAG, szBlogTag)

  local bCanSee = nFriendOnly
  if bCanSee == 1 then
    Btn_Check(self.UIGROUP, BTN_EDITBLOGFRIENDONLY, 1)
  else
    Btn_Check(self.UIGROUP, BTN_EDITBLOGFRIENDONLY, 0)
  end
  Wnd_SetTip(self.UIGROUP, BTN_EDITBLOGFRIENDONLY, "选中此项，只有你的好友可以看见你的信息。")

  local nmonth, nday, nyear = TOOLS_SpliteDate(nBlogBirthday)
  Edt_SetTxt(self.UIGROUP, EDT_BoxYearEditBlog, nyear)
  Edt_SetTxt(self.UIGROUP, EDT_BoxMonthEditBlog, nmonth)
  Edt_SetTxt(self.UIGROUP, EDT_BoxDateEditBlog, nday)

  local szPProvince, szPCity = self:ParseBlogCity(szCity)
  Edt_SetTxt(self.UIGROUP, EDT_BoxEdtEditBlogProvince, szPProvince)
  Edt_SetTxt(self.UIGROUP, EDT_EdtEditBlogCity, szPCity)

  self:UpdateStar(nmonth, nday)
  --[[	ClearComboBoxItem(self.UIGROUP, CMB_EDITBLOGPROVINCE);	
	for iprovince = 1, #PROVINCE do
		ComboBoxAddItem(self.UIGROUP, CMB_EDITBLOGPROVINCE, iprovince, PROVINCE[iprovince]);
	end
	
	
	ClearComboBoxItem(self.UIGROUP, CMB_YEAR);	
	for iyear = 1, #YEAR do
		ComboBoxAddItem(self.UIGROUP, CMB_YEAR, iyear, YEAR[iyear]);
	end
	
	ClearComboBoxItem(self.UIGROUP, CMB_MONTH);	
	for imonth = 1, #MONTH do
		ComboBoxAddItem(self.UIGROUP, CMB_MONTH, imonth, MONTH[imonth]);
	end	
	
	ClearComboBoxItem(self.UIGROUP, CMB_DATE);	
	for iday = 1, #DAY do
		ComboBoxAddItem(self.UIGROUP, CMB_DATE, iday, DAY[iday]);
	end		
	local nmonth = 0;
	local nday = 0;
	local nyear = 0;
	nmonth, nday, nyear = TOOLS_SpliteDate(nBlogBirthday);
	if (nyear >= 0 and nyear <= (#YEAR - 1)) then
		ComboBoxSelectItem(self.UIGROUP, CMB_YEAR, nyear);
	end
	if (nmonth >= 0 and nmonth <= (#MONTH - 1)) then
		ComboBoxSelectItem(self.UIGROUP, CMB_MONTH, nmonth);
	end
	if (nday >= 0 and nday <= (#DAY - 1)) then
		ComboBoxSelectItem(self.UIGROUP, CMB_DATE, nday);
	end	
	
	local szPProvince, szPCity = self:ParseBlogCity(szCity);
	local nProvinceIndex = 0;
	local nCityIndex = 0;
	for i = 1, #PROVINCE do
		if szPProvince == PROVINCE[i] then
			nProvinceIndex = i-1;
			break;
		end
	end
	ComboBoxSelectItem(self.UIGROUP, CMB_EDITBLOGPROVINCE, nProvinceIndex);
	self:RefreshCityCombo(nProvinceIndex);
	if nProvinceIndex > 0 then
		for i = 1, #CITY do
			if szPCity == CITY[nProvinceIndex][i] then
				ComboBoxSelectItem(self.UIGROUP, CMB_EDITBLOGCITY, i - 1);
				break;
			end
		end
	end
--]]
  Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGCITY, szCity)

  ClearComboBoxItem(self.UIGROUP, CMB_EDITBLOGMARRIAGE)
  for i = 1, #MARRIAGE_TYPE do
    ComboBoxAddItem(self.UIGROUP, CMB_EDITBLOGMARRIAGE, i, MARRIAGE_TYPE[i])
  end
  local lmt = nMarriageType - 1
  if lmt >= 0 and lmt <= (#MARRIAGE_TYPE - 1) then
    ComboBoxSelectItem(self.UIGROUP, CMB_EDITBLOGMARRIAGE, lmt)
  else
    ComboBoxSelectItem(self.UIGROUP, CMB_EDITBLOGMARRIAGE, 0)
  end

  local like = szLike
  if like == "" then
    Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGLIKE, "（写下你特有的爱好吧！）")
  else
    Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGLIKE, like)
  end

  Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGEditBLOG, szBlogBlog)
  if szBlogBlog == "" then
    Wnd_SetEnable(self.UIGROUP, BTN_EDITBLOGEditBLOG, 0)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_EDITBLOGEditBLOG, 1)
  end

  local dianDI = szDianDi
  if dianDI == "" then
    Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI, string.format("友情提示：第一次填写此界面的话能获得奖励100绑定%s！", IVER_g_szCoinName))
  else
    Edt_SetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI, dianDI)
  end

  local lingChen = 0
  local shangWu = 0
  local zhongWu = 0
  local xiaWu = 0
  local wanShang = 0
  local wuYe = 0

  lingChen, shangWu, zhongWu, xiaWu, wanShang, wuYe = KPProfile.ValueOffset(nOnlineTime)

  if lingChen == 1 then
    Btn_Check(self.UIGROUP, BTN_EDITBLOGLINGCHEN, 1)
  else
    Btn_Check(self.UIGROUP, BTN_EDITBLOGLINGCHEN, 0)
  end

  if shangWu == 1 then
    Btn_Check(self.UIGROUP, BTN_EDITBLOGSHANGWU, 1)
  else
    Btn_Check(self.UIGROUP, BTN_EDITBLOGSHANGWU, 0)
  end

  if zhongWu == 1 then
    Btn_Check(self.UIGROUP, BTN_EDITBLOGZHONGWU, 1)
  else
    Btn_Check(self.UIGROUP, BTN_EDITBLOGZHONGWU, 0)
  end

  if xiaWu == 1 then
    Btn_Check(self.UIGROUP, BTN_EDITBLOGXIAWU, 1)
  else
    Btn_Check(self.UIGROUP, BTN_EDITBLOGXIAWU, 0)
  end

  if wanShang == 1 then
    Btn_Check(self.UIGROUP, BTN_EDITBLOGWANSHANG, 1)
  else
    Btn_Check(self.UIGROUP, BTN_EDITBLOGWANSHANG, 0)
  end

  if wuYe == 1 then
    Btn_Check(self.UIGROUP, BTN_EDITBLOGWUYE, 1)
  else
    Btn_Check(self.UIGROUP, BTN_EDITBLOGWUYE, 0)
  end
end

function tbPlayerPanel:OnUpdatePageBasic()
  -- 更新所有控件
  self:UpdateBasicName()
  self:UpdateBasicSeries()
  self:UpdateBasicLevel()
  self:UpdateBasicPortrait()
  self:UpdateBasicFaction()
  self:UpdateBasicPKValue()
  self:UpdateBasicExp()
  self:UpdateBasicLife()
  self:UpdateBasicMana()
  self:UpdateBasicStamina()
  self:UpdateBasicGTP()
  self:UpdateBasicMKP()
  self:UpdateBasicResist()
  self:UpdateBasicLeftDamage()
  self:UpdateBasicRightDamage()
  self:UpdateBasicAttackRate()
  self:UpdateBasicAttackSpeed()
  self:UpdateBasicDefense()
  self:UpdateBasicRunSpeed()
  self:UpdateBasicStrength()
  self:UpdateBasicDexterity()
  self:UpdateBasicVitality()
  self:UpdateBasicEnergy()
  self:UpdateBasicRemain()
  self:UpdatePrestige()
  self:UpdateDrawMantle()
  self:UpdateDeadlyStrikeAndDamage()
  self:UpdateBeInvitorBtn()

  if me.nRemainPotential > 0 then -- 有潜能点
    self:EnableAssign()
  else
    self:DisableAssign()
  end
end

function tbPlayerPanel:UpdateBeInvitorBtn()
  local nShow = 0
  if TimeFrame:GetState("OpenLevel150") == 1 then
    if me.GetTask(2164, 4) == 0 then
      nShow = 1
    end
  end
  if me.GetTask(2164, 2) == 1 then
    if me.GetTask(2164, 3) == 0 or nShow == 1 then
      Wnd_Show(self.UIGROUP, BTN_BE_INVITOR)
    end
  else
    Wnd_Hide(self.UIGROUP, BTN_BE_INVITOR)
  end
end

function tbPlayerPanel:GetSeriesReputeValue(tbContent, tbSet, nClass, nType, nLevel)
  local tbShowSeries = { 0, 0, 0, 0, 0 }
  local nSeries = me.nSeries
  local tbFactionInfo = Faction:GetGerneFactionInfo(me)
  if nSeries <= 0 or nSeries > 5 then
    local tbItemContent = {}
    tbItemContent[1] = ""
    tbItemContent[2] = tbSet[nClass][nType].szName
    tbItemContent[3] = tbSet[nClass][nType][nLevel].szName .. "[" .. nLevel .. "级]"
    if #tbSet[nClass][nType] == nLevel then
      tbItemContent[4] = "最高级"
      tbItemContent[5] = 1000
    else
      tbItemContent[4] = me.GetReputeValue(nClass, nType, nLevel) .. "/" .. tbSet[nClass][nType][nLevel].nLevelUp
      tbItemContent[5] = me.GetReputeValue(nClass, nType, nLevel) * 1000 / tbSet[nClass][nType][nLevel].nLevelUp
    end
    tbItemContent[6] = nType
    tbContent[#tbContent + 1] = tbItemContent
    return
  end

  tbShowSeries[nSeries] = 1

  for _, nFactionId in pairs(tbFactionInfo) do
    local tbFactionInfo = KPlayer.GetFactionInfo(nFactionId)
    tbShowSeries[tbFactionInfo.nSeries] = 1
  end

  for nSeriesType = 1, #tbShowSeries do
    if tbShowSeries[nSeriesType] == 1 then
      local szFlag = ""
      local tbItemContent = {}
      local nValue = 0
      local nNowLevel = 0
      if nSeriesType == nSeries then -- 当前五行声望
        nValue = me.GetReputeValue(nClass, nType, nLevel)
        nNowLevel = nLevel
        szFlag = "★"
      else
        nValue, nNowLevel = Faction:GetRepute(me, nSeriesType, nClass, nType)
        if not nValue then
          nValue = 0
          nNowLevel = tbSet[nClass][nType].nDefLevel
        end
      end
      if nValue then
        tbItemContent[1] = szFlag
        tbItemContent[2] = tbSet[nClass][nType].szName .. "（" .. SERIES_NAME[nSeriesType] .. "）"
        tbItemContent[3] = tbSet[nClass][nType][nNowLevel].szName .. "[" .. nNowLevel .. "级]"
        if #tbSet[nClass][nType] == nNowLevel then
          tbItemContent[4] = "最高级"
          tbItemContent[5] = 1000
        else
          tbItemContent[4] = nValue .. "/" .. tbSet[nClass][nType][nNowLevel].nLevelUp
          tbItemContent[5] = nValue * 1000 / tbSet[nClass][nType][nNowLevel].nLevelUp
        end
        tbItemContent[6] = nType
        tbContent[#tbContent + 1] = tbItemContent
      end
    end
  end
end

function tbPlayerPanel:GetReputePanelValue()
  local tbSet = self.tbReputeSetting

  if not tbSet then
    return
  end

  local tbResultSet = {}
  for i = 1, #tbSet do
    if tbSet[i].nIsDisable and 0 == tbSet[i].nIsDisable then
      local tbInfo = {}
      tbInfo.szName = tbSet[i].szName
      tbInfo.nIsDisable = tbSet[i].nIsDisable or 0
      local tbContent = {}
      for j = 1, #tbSet[i] do
        local nLevel = me.GetReputeLevel(i, j)
        local nClassIsDisable = tbSet[i][j].nIsDisable
        if nLevel and 0 == nClassIsDisable then
          if 1 == i and 1 == j then -- 义军声望
            self:GetSeriesReputeValue(tbContent, tbSet, i, j, nLevel)
          elseif 2 == i then -- 宋金战场
            self:GetSeriesReputeValue(tbContent, tbSet, i, j, nLevel)
          elseif 5 == i and 1 == j then -- 白虎堂
            self:GetSeriesReputeValue(tbContent, tbSet, i, j, nLevel)
          elseif 4 == i and 1 == j then -- 家族关卡
            self:GetSeriesReputeValue(tbContent, tbSet, i, j, nLevel)
          else
            local tbItemContent = {}
            tbItemContent[1] = ""
            tbItemContent[2] = tbSet[i][j].szName
            tbItemContent[3] = tbSet[i][j][nLevel].szName .. "[" .. nLevel .. "级]"
            if #tbSet[i][j] == nLevel then
              tbItemContent[4] = "最高级"
              tbItemContent[5] = 1000
            else
              tbItemContent[4] = me.GetReputeValue(i, j, nLevel) .. "/" .. tbSet[i][j][nLevel].nLevelUp
              tbItemContent[5] = me.GetReputeValue(i, j, nLevel) * 1000 / tbSet[i][j][nLevel].nLevelUp
            end
            tbItemContent[6] = j
            tbContent[#tbContent + 1] = tbItemContent
          end
        end
      end
      tbInfo.tbContent = tbContent
      tbResultSet[#tbResultSet + 1] = tbInfo
    end
  end
  return tbResultSet
end

function tbPlayerPanel:OnUpdatePageRepute()
  local nTop = 0
  nTop = ScrPanel_GetDocumentTopLen(self.UIGROUP, self.REPUTE_SCROLL_PANEL)

  if self.nIsNewOpen == 1 then -- 如果是关闭了再重新打开角色面板 则先恢复上一次的位置
    nTop = self.nPosReputeScroll
    self.nIsNewOpen = 0
  end

  if self.nIsCanUpdateReputePage ~= 1 then
    return
  end
  self:UpdateReputeName()

  OutLookPanelClearAll(self.UIGROUP, OUTLOOK_REPUTE)

  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_REPUTE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_REPUTE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_REPUTE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_REPUTE, "")
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_REPUTE, 0, 135)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_REPUTE, 1, 60)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_REPUTE, 2, 80)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_REPUTE, 3, 30)

  AddOutLookGroup(self.UIGROUP, OUTLOOK_REPUTE, "我所关注的")
  AddOutLookGroup(self.UIGROUP, OUTLOOK_REPUTE, "我不关注的")

  --	每次刷新PageRepute界面时重置两张绑定表的值
  local nNotCareItemIndex = 0
  local nCareItemIndex = 0
  self.tbCareBindTable = {}
  self.tbNotCareBindTable = {}
  --	将声望数据插入到OutLook中 按 tbPlayerPanel.tbReputeInfoConfig
  for tmp = 1, #self.tbReputeInfoConfig do
    local i = self.tbReputeInfoConfig[tmp].nIndexParent
    local j = self.tbReputeInfoConfig[tmp].nIndexChild
    local nLevel = me.GetReputeLevel(i, j) --	结构 父类---->子类细分项目----->细分项目维护的等级信息   GetReputeLevel函数得到等级信息
    if nLevel and self.tbReputeInfoConfig[tmp].nWeight > 0 then
      local tbItemContent = {}
      if not self.tbReputeInfoConfigSpec[i][j].tbReputeXML then
        self:AddXMLItemToReputeCfg()
      end
      local nMaxLevel = 0
      tbItemContent[1] = "    " .. self.tbReputeInfoConfigSpec[i][j].tbReputeXML.szName --	前面加的空格为了排版的需要
      tbItemContent[2] = self.tbReputeInfoConfigSpec[i][j].tbReputeXML[nLevel].szName .. "[" .. nLevel .. "级]"
      if #self.tbReputeInfoConfigSpec[i][j].tbReputeXML == nLevel then
        tbItemContent[3] = "最高级"
        nMaxLevel = 1
      else
        tbItemContent[3] = me.GetReputeValue(i, j, nLevel) .. "/" .. self.tbReputeInfoConfigSpec[i][j].tbReputeXML[nLevel].nLevelUp
      end
      if self.REPUTE_AWARD_FILTER_TABLE[self.nReputeCurrentSelComboIndex] == "全部类型" then --	如果是全部类型 说明不过滤
        tbItemContent[4] = self.tbReputeInfoConfig[tmp].szMainType
        if nMaxLevel == 1 then
          for i = 1, 4 do
            tbItemContent[i] = string.format("<color=green>%s<color>", tbItemContent[i])
          end
        end
        if nLevel == 1 and me.GetReputeValue(i, j, nLevel) == 0 and self.tbReputeInfoConfigSpec[i][j].nRecommend ~= 1 then
          --	2012/7/26 15:39:31 如果等级为1并且声望值为0 加入漠不关心的Group中
          AddOutLookItem(self.UIGROUP, OUTLOOK_REPUTE, 1, tbItemContent)
          self.tbNotCareBindTable[nNotCareItemIndex] = { i, j }
          nNotCareItemIndex = nNotCareItemIndex + 1
        else
          --	2012/7/26 15:39:31 否则加入我所关注的Group中
          AddOutLookItem(self.UIGROUP, OUTLOOK_REPUTE, 0, tbItemContent)
          self.tbCareBindTable[nCareItemIndex] = { i, j }
          nCareItemIndex = nCareItemIndex + 1
        end
      else --	进入过滤阶段
        local tbFilterType = Lib:SplitStr(self.tbReputeInfoConfig[tmp].szFilterType, ",")
        local nFilterFlag = 0
        for _, ItemType in pairs(tbFilterType) do
          if self.tbFilter[tonumber(ItemType)] == self.REPUTE_AWARD_FILTER_TABLE[self.nReputeCurrentSelComboIndex] then --判断是否包含在过滤条件中
            nFilterFlag = 1
          end
        end
        tbItemContent[4] = self.tbReputeInfoConfig[tmp].szAward
        if nMaxLevel == 1 then
          for i = 1, 4 do
            tbItemContent[i] = string.format("<color=green>%s<color>", tbItemContent[i])
          end
        end
        if nFilterFlag == 1 then
          if nLevel == 1 and me.GetReputeValue(i, j, nLevel) == 0 and self.tbReputeInfoConfigSpec[i][j].nRecommend ~= 1 then
            --	2012/7/26 15:39:31 如果等级为1并且声望值为0 加入漠不关心的Group中
            AddOutLookItem(self.UIGROUP, OUTLOOK_REPUTE, 1, tbItemContent)
            self.tbNotCareBindTable[nNotCareItemIndex] = { i, j }
            nNotCareItemIndex = nNotCareItemIndex + 1
          else
            --	2012/7/26 15:39:31 否则加入我所关注的Group中
            AddOutLookItem(self.UIGROUP, OUTLOOK_REPUTE, 0, tbItemContent)
            self.tbCareBindTable[nCareItemIndex] = { i, j }
            nCareItemIndex = nCareItemIndex + 1
          end
        end
      end
    end
  end
  if self.nComboBoxChanged ~= 1 then
    self:ResumeLastTimePos(nTop)
  end
  self.nComboBoxChanged = 0
end

function tbPlayerPanel:OnUpdatePageTitle()
  self:UpdateTitleName()
  self:UpdatePlayerTitleInfo()
  self:UpdateTitleOutLook()

  Wnd_SetEnable(self.UIGROUP, BTN_ACTIVE_TITLE, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_INACTIVE_TITLE, 0)
end

function tbPlayerPanel:OnHonorRefresh()
  self.tbHonorData = PlayerHonor.tbPlayerHonorData.tbHonorData
  self:OnUpdatePageHistory()
end

function tbPlayerPanel:OnRequestHonorData()
  PlayerHonor:ApplyHonorData(me)
  self.tbHonorData = PlayerHonor.tbPlayerHonorData.tbHonorData
end

function tbPlayerPanel:OnUpdatePageHistory()
  local tbHonorSettings = self.tbHonorData
  Txt_SetTxt(self.UIGROUP, TEXT_HISTROY_NAME, me.szName)

  OutLookPanelClearAll(self.UIGROUP, OUTLOOK_HISTORY)
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_HISTORY, "")
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 0, 25)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 1, 100)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 2, 60)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 3, 65)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 4, 40)

  for nClass, tbSubList in ipairs(tbHonorSettings) do
    AddOutLookGroup(self.UIGROUP, OUTLOOK_HISTORY, tbSubList.szName)
    if tbSubList.tbHonorSubList and #tbSubList.tbHonorSubList > 0 then
      local nCount = 1
      for nType, tbHonor in ipairs(tbSubList.tbHonorSubList) do
        local nValue = tbHonor.nValue
        if tbHonor.nClass == PlayerHonor.HONOR_CLASS_FIGHTPOWER_TOTAL then
          nValue = nValue / 100 -- 战斗力纠正
        end
        if tbHonor.nClass == PlayerHonor.HONOR_CLASS_LADDER1 then
          nValue = math.floor(nValue / 10000) -- 寒武遗迹纠正
        end
        local szValue = string.format("%d 点", nValue)
        local nRank = tbHonor.nRank
        local nLevel = tbHonor.nLevel
        local szRank = ""
        local szLevel = ""
        if not nRank or 0 == nRank then
          szRank = "?"
        elseif nRank > 0 then
          szRank = string.format("第 %d 名", nRank)
          if nLevel > 0 then
            szLevel = string.format("%d级", nLevel)
          else
            szLevel = " "
          end
        end

        if nCount ~= #tbSubList.tbHonorSubList then
          AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, nClass - 1, { "", tbHonor.szName, szValue, szRank, szLevel }, "", OUTLOOK_ITEM_BACKGROUD_IMAGE1)
        else
          AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, nClass - 1, { "", tbHonor.szName, szValue, szRank, szLevel }, "", OUTLOOK_ITEM_BACKGROUD_IMAGE2)
        end
        nCount = nCount + 1
      end
    else
      SetGroupCollapseState(self.UIGROUP, OUTLOOK_HISTORY, nClass - 1, 0)
    end
  end
end

function tbPlayerPanel:OnSwitch()
  UiManager:OpenWindow(Ui.UI_SERIESSWITCH)
  UiManager:CloseWindow(self.UIGROUP)
end

function tbPlayerPanel:OnAutoAssign()
  self:OnCancelAssign()

  if 0 >= self.nRemain then -- 显示已经没有剩余潜能点了，就不允许再自动分配
    return
  end

  local tbAssign = Player:AutoAssginPotential(me.nFaction, me.nRouteId, me.nRemainPotential)

  for i = 1, #self.tbDeltaAttrib do
    self.tbDeltaAttrib[i] = tbAssign[i]
    self.nRemain = self.nRemain - self.tbDeltaAttrib[i]
  end

  self:UpdateAttribView()
end

function tbPlayerPanel:OnSubmitAssign()
  if me.ApplyAssignPotential(unpack(self.tbDeltaAttrib)) == 1 then
    return
  end
  -- 加点失败
  me.Msg("单项潜能值不能超过总数的60%，加点失败！")
  self:OnCancelAssign()
end

function tbPlayerPanel:OnCancelAssign()
  self:EnableAssign()
end

function tbPlayerPanel:OnIncrease(nAttrib)
  if self.nRemain <= 0 then
    return
  end

  self.nRemain = self.nRemain - 1
  self.tbDeltaAttrib[nAttrib] = self.tbDeltaAttrib[nAttrib] + 1

  self:UpdateAttribView(nAttrib)
end

function tbPlayerPanel:OnDecrease(nAttrib)
  if self.tbDeltaAttrib[nAttrib] <= 0 then
    return
  end

  self.nRemain = self.nRemain + 1
  self.tbDeltaAttrib[nAttrib] = self.tbDeltaAttrib[nAttrib] - 1

  self:UpdateAttribView(nAttrib)
end

function tbPlayerPanel:OnEditKillFocus(nAttrib)
  local tbBase = {
    [Player.ATTRIB_STR] = me.nStrength,
    [Player.ATTRIB_DEX] = me.nDexterity,
    [Player.ATTRIB_VIT] = me.nVitality,
    [Player.ATTRIB_ENG] = me.nEnergy,
  }

  local tbBase2 = {
    [Player.ATTRIB_STR] = me.nBaseStrength,
    [Player.ATTRIB_DEX] = me.nBaseDexterity,
    [Player.ATTRIB_VIT] = me.nBaseVitality,
    [Player.ATTRIB_ENG] = me.nBaseEnergy,
  }

  local nValue = Edt_GetInt(self.UIGROUP, ATTRIB_EDIT_TABLE[nAttrib]) - tbBase[nAttrib]
  local nOld = self.tbDeltaAttrib[nAttrib]

  -- 校正nValue
  nValue = math.max(nValue, 0)
  nValue = math.min(nValue, self.nRemain + self.tbDeltaAttrib[nAttrib])

  nValue = math.min(nValue, math.floor((me.nRemainPotential + me.nBaseStrength + me.nBaseDexterity + me.nBaseVitality + me.nBaseEnergy) * 0.6) - tbBase2[nAttrib])
  local nDetValue = nValue - self.tbDeltaAttrib[nAttrib]

  self.nRemain = self.nRemain - nDetValue
  self.tbDeltaAttrib[nAttrib] = nValue

  self:UpdateAttribView(nAttrib)
end

function tbPlayerPanel:OnSyncDamage()
  self:UpdateBasicLeftDamage()
  self:UpdateBasicRightDamage()
  --self:UpdateDeadlyStrikeDamage();
end

function tbPlayerPanel:OnSyncPotential()
  self:UpdateBasicStrength()
  self:UpdateBasicDexterity()
  self:UpdateBasicVitality()
  self:UpdateBasicEnergy()
end

function tbPlayerPanel:OnSyncRemainPotential()
  if me.nRemainPotential <= 0 then
    self:DisableAssign()
    return
  end

  self:EnableAssign()

  local nRemainDelta = self.nRemain -- 用于计算同步前后的差值
  for i = 1, #self.tbDeltaAttrib do
    nRemainDelta = nRemainDelta + self.tbDeltaAttrib[i]
  end
  nRemainDelta = me.nRemainPotential - nRemainDelta
  self.nRemain = self.nRemain + nRemainDelta
  if self.nRemain < 0 then -- 同步后显示剩余潜能点为负，复位数据
    self.nRemain = me.nRemainPotential
    self.tbDeltaAttrib[Player.ATTRIB_STR] = 0
    self.tbDeltaAttrib[Player.ATTRIB_DEX] = 0
    self.tbDeltaAttrib[Player.ATTRIB_VIT] = 0
    self.tbDeltaAttrib[Player.ATTRIB_ENG] = 0
  end

  self:UpdateAttribView()
end

function tbPlayerPanel:OnActiveTitle()
  local nX = self.m_nSelTitleX
  local nY = self.m_nSelTitleY
  local theTitleDataEx = self.tbTitleTable[nX + 1].TitleData[nY + 1]

  if theTitleDataEx == nil then
    return
  end

  if self:IsCurActiveTitle(nX + 1, nY + 1) == 1 then
    me.SetCurTitle(0, 0, 0, 0)
  else
    me.SetCurTitle(theTitleDataEx.byTitleGenre, theTitleDataEx.byTitleDetailType, theTitleDataEx.byTitleLevel, theTitleDataEx.dwTitleParam)
  end
end

function tbPlayerPanel:OnInactiveTitle()
  local nX = self.m_nSelTitleX
  local nY = self.m_nSelTitleY
  local theTitleDataEx = self.tbTitleTable[nX + 1].TitleData[nY + 1]

  if theTitleDataEx == nil then
    return
  end

  if self:IsCurActiveTitle(nX + 1, nY + 1) == 1 then
    me.SetCurTitle(0, 0, 0, 0)
  end
end

------ 私有内部处理函数 ------

-- 使能潜能加点按钮
function tbPlayerPanel:EnableAssign()
  -- 防止BUG
  if 0 >= me.nRemainPotential then
    self:DisableAssign()
    return
  end

  self.nRemain = me.nRemainPotential

  -- 复位潜能点
  self.tbDeltaAttrib[Player.ATTRIB_STR] = 0
  self.tbDeltaAttrib[Player.ATTRIB_DEX] = 0
  self.tbDeltaAttrib[Player.ATTRIB_VIT] = 0
  self.tbDeltaAttrib[Player.ATTRIB_ENG] = 0

  -- 使能控件
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_ASSAUTO, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_ASSOK, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_ASSCANCEL, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_INCSTR, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_DECSTR, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_INCDEX, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_DECDEX, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_INCVIT, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_DECVIT, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_INCENG, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_DECENG, 1)
  Edt_EnableKeyInput(self.UIGROUP, EDIT_BASIC_STR, 1)
  Edt_EnableKeyInput(self.UIGROUP, EDIT_BASIC_DEX, 1)
  Edt_EnableKeyInput(self.UIGROUP, EDIT_BASIC_VIT, 1)
  Edt_EnableKeyInput(self.UIGROUP, EDIT_BASIC_ENG, 1)

  self:UpdateAttribView()
end

-- 禁用潜能加点按钮
function tbPlayerPanel:DisableAssign()
  self.nRemain = me.nRemainPotential

  -- 复位潜能点
  self.tbDeltaAttrib[Player.ATTRIB_STR] = 0
  self.tbDeltaAttrib[Player.ATTRIB_DEX] = 0
  self.tbDeltaAttrib[Player.ATTRIB_VIT] = 0
  self.tbDeltaAttrib[Player.ATTRIB_ENG] = 0

  -- 禁用控件
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_ASSAUTO, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_ASSOK, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_ASSCANCEL, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_INCSTR, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_DECSTR, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_INCDEX, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_DECDEX, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_INCVIT, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_DECVIT, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_INCENG, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BASIC_DECENG, 0)
  Edt_EnableKeyInput(self.UIGROUP, EDIT_BASIC_STR, 0)
  Edt_EnableKeyInput(self.UIGROUP, EDIT_BASIC_DEX, 0)
  Edt_EnableKeyInput(self.UIGROUP, EDIT_BASIC_VIT, 0)
  Edt_EnableKeyInput(self.UIGROUP, EDIT_BASIC_ENG, 0)

  self:UpdateAttribView()

  -- 防止BUG
  if me.nRemainPotential > 0 then
    self:EnableAssign()
  end
end

-- 加点时更新潜能点数的显示
function tbPlayerPanel:UpdateAttribView(nAttrib)
  local tbBase = {
    [Player.ATTRIB_STR] = me.nStrength,
    [Player.ATTRIB_DEX] = me.nDexterity,
    [Player.ATTRIB_VIT] = me.nVitality,
    [Player.ATTRIB_ENG] = me.nEnergy,
  }

  if not nAttrib then
    for i = 1, #ATTRIB_EDIT_TABLE do
      Edt_SetInt(self.UIGROUP, ATTRIB_EDIT_TABLE[i], self.tbDeltaAttrib[i] + tbBase[i])
    end
  else
    Edt_SetInt(self.UIGROUP, ATTRIB_EDIT_TABLE[nAttrib], self.tbDeltaAttrib[nAttrib] + tbBase[nAttrib])
  end

  self:UpdateBasicRemain()
end

function tbPlayerPanel:UpdateDrawMantle()
  local nValue = me.GetTask(Player.TSK_GROUP_HIDE_MANTLE, Player.TSK_SUB_HIDE_MANTLE)
  if nValue == 0 then
    Btn_Check(self.UIGROUP, BTN_HIDE_MANTLE, 0)
  else
    Btn_Check(self.UIGROUP, BTN_HIDE_MANTLE, 1)
  end
end

--清空称号表的数据
function tbPlayerPanel:ResetTitleData()
  self.tbTitleTable = {}
end

--用ItemData查找称号（ItemData为List中设置的关联数据）
function tbPlayerPanel:GetTitleDataByItemData(nItemData)
  for i = 1, #self.tbTitleTable do
    if self.tbTitleTable[i] ~= nil then
      if self.tbTitleTable[i].TitleData ~= nil then
        for j = 1, #self.tbTitleTable[i].TitleData do
          if self.tbTitleTable[i].TitleData[j].nItemData == nItemData then
            return self.tbTitleTable[i].TitleData[j]
          end
        end
      end
    end
  end
end

function tbPlayerPanel:InsertTitleItem(TitleItem)
  if TitleItem == nil then
    return
  end

  for i = 1, #self.tbTitleTable do
    if self.tbTitleTable[i] == nil then
      break
    end

    if self.tbTitleTable[i].byTitleGenre == TitleItem.byTitleGenre then
      table.insert(self.tbTitleTable[i].TitleData, TitleItem)
      return
    end
  end

  local theTitleTable = {}
  theTitleTable.TitleData = {}
  theTitleTable.byTitleGenre = TitleItem.byTitleGenre
  local TitleGenreAttr = KPlayer.GetTitleGenreAttr(TitleItem.byTitleGenre)

  if TitleGenreAttr ~= nil then
    theTitleTable.szTitleGenreAttr = TitleGenreAttr.szGenreName
  end

  table.insert(theTitleTable.TitleData, TitleItem)
  table.insert(self.tbTitleTable, theTitleTable)
end

--得到当前称号结构
function tbPlayerPanel:GetCurTitleData()
  local byTitleGenre, byTitleDetailType, byTitleLevel, dwTitleParam = me.GetCurTitle()

  if (self.tbTitleTable == nil) or (byTitleGenre == nil) or (byTitleDetailType == nil) or (byTitleLevel == nil) or (dwTitleParam == nil) then
    return
  end

  if (self.tbTitleTable == 0) and (byTitleGenre == 0) and (byTitleDetailType == 0) and (byTitleLevel == 0) and (dwTitleParam == 0) then
    return
  end

  local CurTitleKey = byTitleGenre .. byTitleDetailType .. byTitleLevel .. dwTitleParam

  for i = 1, #self.tbTitleTable do
    if self.tbTitleTable[i].byTitleGenre == byTitleGenre then
      for _, v in ipairs(self.tbTitleTable[i].TitleData) do
        TitleKey = v.byTitleGenre .. v.byTitleDetailType .. v.byTitleLevel .. v.dwTitleParam
        if CurTitleKey == TitleKey then
          return self.tbTitleTable[i].TitleData[j]
        end
      end
    end
  end
end

function tbPlayerPanel:UpdateBasicName()
  Edt_SetTxt(self.UIGROUP, EDIT_BASIC_NAME, me.szName)
end

function tbPlayerPanel:UpdateBasicSeries()
  local szSeries = Env.SERIES_NAME[me.nSeries]
  if not szSeries then
    szSeries = Env.SERIES_NAME[Env.SERIES_NONE]
  end
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_SERIES, "五行：" .. szSeries)
end

function tbPlayerPanel:UpdateBasicLevel()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_LEVEL, "等级：" .. me.nLevel)
end

function tbPlayerPanel:UpdateBasicPortrait()
  local szSpr, nType = tbViewPlayerMgr:GetMyPortraitSpr(me.nPortrait, me.nSex)

  Img_SetImage(self.UIGROUP, BTN_SEL_PORTRAIT, nType, szSpr)
  if 1 == nType then
    if me.nPortrait > 100 then
      Img_SetImgOffsetX(self.UIGROUP, BTN_SEL_PORTRAIT, 0)
    else
      Img_SetImgOffsetX(self.UIGROUP, BTN_SEL_PORTRAIT, -9)
    end
  else
    Img_SetImgOffsetX(self.UIGROUP, BTN_SEL_PORTRAIT, 0)
  end
end

function tbPlayerPanel:UpdateBasicFaction()
  local szFaction = Player:GetFactionRouteName(me.nFaction)
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_FACTION, "门派：" .. szFaction)
end

function tbPlayerPanel:UpdateBasicPKValue()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_PKVALUE, "恶名值：" .. me.nPKValue)
end

function tbPlayerPanel:UpdateBasicExp()
  --	Txt_SetTxt(self.UIGROUP, TEXT_BASIC_EXP, "经验："..me.GetExp().."/"..me.GetUpLevelExp());
end

function tbPlayerPanel:UpdatePrestige()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_EXP, "江湖威望：" .. me.nPrestige)
end

function tbPlayerPanel:UpdateBasicLife()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_LIFE, "生命：" .. me.nCurLife .. "/" .. me.nMaxLife)
end

function tbPlayerPanel:UpdateBasicMana()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_MANA, "内力：" .. me.nCurMana .. "/" .. me.nMaxMana)
end

function tbPlayerPanel:UpdateBasicStamina()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_STAMINA, "体力：" .. me.nCurStamina .. "/" .. me.nMaxStamina)
end

function tbPlayerPanel:UpdateBasicGTP()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_GTP, "活力：" .. me.dwCurGTP)
end

function tbPlayerPanel:UpdateBasicMKP()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_MKP, "精力：" .. me.dwCurMKP)
end

function tbPlayerPanel:UpdateBasicResist()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_GR, "普防：" .. me.nGR)
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_PR, "毒防：" .. me.nPR)
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_CR, "冰防：" .. me.nCR)
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_FR, "火防：" .. me.nFR)
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_LR, "雷防：" .. me.nLR)
end

function tbPlayerPanel:UpdateDeadlyStrikeAndDamage()
  self:UpdateDeadlyStrikeDamage()
  self:UpdateDeadlyStrike()
end

function tbPlayerPanel:UpdateBasicLeftDamage()
  local nLeft = me.nLeftDamageMin
  local nRight = me.nLeftDamageMax
  if nLeft < 0 then
    nLeft = "-"
  end
  if nRight < 0 then
    nRight = "-"
  end
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_LDAMAGE, "左键伤害：\n    " .. nLeft .. " - " .. nRight)
end

function tbPlayerPanel:UpdateBasicRightDamage()
  local nLeft = me.nRightDamageMin
  local nRight = me.nRightDamageMax
  if nLeft < 0 then
    nLeft = 0
  end
  if nRight < 0 then
    nRight = 0
  end
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_RDAMAGE, "右键伤害：\n    " .. nLeft .. " - " .. nRight)
end

function tbPlayerPanel:UpdateDeadlyStrikeDamage()
  local szText = "会心伤害："
  szText = szText .. string.format("%d%%", me.GetDeadlyStrikeDamagePercent() + 180)
  Txt_SetTxt(self.UIGROUP, TEXT_DEADLYSTRIKE_PREC, szText)
end
function tbPlayerPanel:UpdateBasicAttackRate()
  local nLeft = me.nLeftAR
  local nRight = me.nRightAR

  if nLeft < 0 then
    nLeft = "-"
  end
  if nRight < 0 then
    nRight = "-"
  end

  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_AR, "命中：" .. nLeft .. "/" .. nRight)
end

function tbPlayerPanel:UpdateBasicAttackSpeed()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_AS, "攻速：" .. me.nAttackSpeed .. "/" .. me.nCastSpeed)
end

function tbPlayerPanel:UpdateBasicDefense()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_DEFENSE, "闪避：" .. me.nDefense)
end

function tbPlayerPanel:UpdateBasicRunSpeed()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_RUNSPEED, "跑速：" .. me.nRunSpeed)
end

function tbPlayerPanel:UpdateDeadlyStrike()
  Txt_SetTxt(self.UIGROUP, TEXT_DEADLYSTRIKE_RATE, "会心：" .. me.GetDeadlyStrike())
end

function tbPlayerPanel:UpdateBasicPotential()
  self:UpdateBasicStrength()
  self:UpdateBasicDexterity()
  self:UpdateBasicVitality()
  self:UpdateBasicEnergy()
end

function tbPlayerPanel:UpdateBasicStrength()
  Edt_SetInt(self.UIGROUP, EDIT_BASIC_STR, me.nStrength + self.tbDeltaAttrib[Player.ATTRIB_STR])
end

function tbPlayerPanel:UpdateBasicDexterity()
  Edt_SetInt(self.UIGROUP, EDIT_BASIC_DEX, me.nDexterity + self.tbDeltaAttrib[Player.ATTRIB_DEX])
end

function tbPlayerPanel:UpdateBasicVitality()
  Edt_SetInt(self.UIGROUP, EDIT_BASIC_VIT, me.nVitality + self.tbDeltaAttrib[Player.ATTRIB_VIT])
end

function tbPlayerPanel:UpdateBasicEnergy()
  Edt_SetInt(self.UIGROUP, EDIT_BASIC_ENG, me.nEnergy + self.tbDeltaAttrib[Player.ATTRIB_ENG])
end

function tbPlayerPanel:OnMouseEnter(szWnd, nParam)
  local szTip = ""
  if szWnd == TEXT_BASIC_AS then
    szTip = me.GetAttackSpeedTip()
  elseif szWnd == EDIT_BASIC_STR then
    szTip = me.GetPotentialTip(Player.ATTRIB_STR)
  elseif szWnd == EDIT_BASIC_DEX then
    szTip = me.GetPotentialTip(Player.ATTRIB_DEX)
  elseif szWnd == EDIT_BASIC_VIT then
    szTip = me.GetPotentialTip(Player.ATTRIB_VIT)
  elseif szWnd == EDIT_BASIC_ENG then
    szTip = me.GetPotentialTip(Player.ATTRIB_ENG)
  elseif szWnd == TEXT_BASIC_GR then
    szTip = me.GetResistTip(Env.SERIES_METAL)
  elseif szWnd == TEXT_BASIC_PR then
    szTip = me.GetResistTip(Env.SERIES_WOOD)
  elseif szWnd == TEXT_BASIC_CR then
    szTip = me.GetResistTip(Env.SERIES_WATER)
  elseif szWnd == TEXT_BASIC_FR then
    szTip = me.GetResistTip(Env.SERIES_FIRE)
  elseif szWnd == TEXT_BASIC_LR then
    szTip = me.GetResistTip(Env.SERIES_EARTH)
  elseif szWnd == BTN_BASIC_ASSAUTO or szWnd == TEXT_BASIC_REMAIN then
    szTip = "60级前潜能点在升级时由系统自动分配\n60级后可在<color=green>门派掌门人<color>处进入<color=green>洗髓岛<color>洗点"
  elseif szWnd == TEXT_DEADLYSTRIKE_RATE then
    -- 只保留一位小数
    local nRate = math.floor(me.GetDeadlyStrike() / (1900 + me.GetDeadlyStrike()) * 1000) / 10
    nRate = (me.GetDeadlyStrike() < 0) and 0 or nRate
    szTip = string.format("会心一击概率%0.1f%%", nRate)
  elseif szWnd == BTN_HIDE_MANTLE then
    local nValue = Player:IsHideMantle()
    if nValue == 0 then
      szTip = "点击隐藏披风"
    else
      szTip = "取消披风隐藏"
    end
  elseif szWnd == OUTLOOK_REPUTE then
    local nGroupIndex = Lib:LoadBits(nParam, 0, 15)
    local nItemIndex = Lib:LoadBits(nParam, 16, 31)
    local nCurrentHoverItemParentIndex = 0
    local nCurrentHoverItemChildIndex = 0
    if nGroupIndex == 0 then --我所关注的Group
      local tbChooseItemAddress = self.tbCareBindTable[nItemIndex] --通过关注绑定表取得点击信息的 父子索引
      if tbChooseItemAddress == nil then
        return
      end
      nCurrentHoverItemParentIndex = tbChooseItemAddress[1]
      nCurrentHoverItemChildIndex = tbChooseItemAddress[2]
    elseif nGroupIndex == 1 then --我不关注的Group
      local tbChooseItemAddress = self.tbNotCareBindTable[nItemIndex] --通过不关注绑定表取得点击信息的 父子索引
      if tbChooseItemAddress == nil then
        return
      end
      nCurrentHoverItemParentIndex = tbChooseItemAddress[1]
      nCurrentHoverItemChildIndex = tbChooseItemAddress[2]
    else
      return
    end
    szTip = self.tbReputeInfoConfigSpec[nCurrentHoverItemParentIndex][nCurrentHoverItemChildIndex].szTips
    if self.PreShowReputePopLock == 0 then
      self:OnOutLookItemSelectedShell(OUTLOOK_REPUTE, nGroupIndex, nItemIndex)
      self.nIsOpenTheReputePopInfoWnd = 0
    end
  end
  if szTip ~= "" then --	2012/7/27 10:16:50	显示指定窗口的提示信息
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

function tbPlayerPanel:OnMouseLeave(szWnd)
  Wnd_HideMouseHoverInfo()
  if self.nIsOpenTheReputePopInfoWnd == 0 then
    self:OnButtonClick(self.ReputeInfoWndBtnClose, 0)
  end
end

function tbPlayerPanel:UpdateBasicRemain()
  Txt_SetTxt(self.UIGROUP, TEXT_BASIC_REMAIN, "剩余潜能：  " .. self.nRemain)
end

function tbPlayerPanel:UpdateReputeName()
  Txt_SetTxt(self.UIGROUP, TEXT_REPUTE_NAME, me.szName)
end

function tbPlayerPanel:UpdateTitleName()
  Txt_SetTxt(self.UIGROUP, TEXT_TITLE_NAME, me.szName)
end

function tbPlayerPanel:UpdatePlayerTitleInfo()
  self:ResetTitleData()
  local theTitleTable = me.GetAllTitle()
  if theTitleTable == nil then
    return
  end
  for i = 1, #theTitleTable do
    self:InsertTitleItem(theTitleTable[i])
  end
end

function tbPlayerPanel:UpdateEquipment()
  for _, tbCont in pairs(self.tbEquipCont) do
    tbCont.nRoom = Item.ROOM_EQUIP
    tbCont:UpdateRoom()
  end
  self:SetShowEquipState() -- 设置替换装备按钮是否可用
  self:UpdateCellTips()
end

function tbPlayerPanel:UpdateEquipEx()
  for _, tbEquipType in pairs(SELF_SWITCHABLE_EQUIP) do
    local tbCont = self.tbEquipCont[tbEquipType[1]]
    tbCont.nRoom = Item.ROOM_EQUIPEX
    tbCont:UpdateRoom()
  end
  self:SetShowEquipState() -- 设置替换装备按钮是否可用
end

function tbPlayerPanel:GetEquipPos(szWnd)
  for _, tbEquipItem in ipairs(SELF_EQUIPMENT) do
    if tbEquipItem[2] == szWnd then
      return tbEquipItem[1]
    end
  end
end

function tbPlayerPanel:GetEquipWndTableItem(nPosition)
  for _, tbEquipItem in ipairs(SELF_EQUIPMENT) do
    if tbEquipItem[1] == nPosition then
      return tbEquipItem
    end
  end
end

function tbPlayerPanel:SetEquipPosHighLight(tbObj)
  local nRet = 1
  if not tbObj or tbObj.nType ~= Ui.OBJ_OWNITEM then
    self:ReleaseEquipPosHighLight()
    return
  end
  local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
  if (not pItem) or not pItem.nEquipPos or (pItem.nEquipPos >= Item.EQUIPPOS_NUM) then
    self:ReleaseEquipPosHighLight()
    return
  end

  self.tbHighLightEquipPos = {}

  -- 真元有三个格子可以放
  if pItem.nDetail == Item.EQUIP_ZHENYUAN then
    for i = Item.EQUIPPOS_ZHENYUAN_MAIN, Item.EQUIPPOS_ZHENYUAN_MAIN do
      local tbEquipWnd = self:GetEquipWndTableItem(i)
      if tbEquipWnd then
        table.insert(self.tbHighLightEquipPos, tbEquipWnd[3])
      end
    end
  else -- 其它装备只有一个格子可以放
    local nPositon = pItem.nEquipPos
    local tbEquipWnd = self:GetEquipWndTableItem(nPositon)
    if tbEquipWnd then
      table.insert(self.tbHighLightEquipPos, tbEquipWnd[3])
    end
  end

  for _, szHighLightEquipPos in pairs(self.tbHighLightEquipPos) do
    Img_SetFrame(self.UIGROUP, szHighLightEquipPos, 0)
  end
end

function tbPlayerPanel:ReleaseEquipPosHighLight()
  if self.tbHighLightEquipPos == nil then
    return
  end

  for _, szHighLightEquipPos in pairs(self.tbHighLightEquipPos) do
    Img_SetFrame(self.UIGROUP, szHighLightEquipPos, 1)
  end

  self.tbHighLightEquipPos = nil
end

function tbPlayerPanel:OnOutLookItemSelectedShell(szWndName, nGroupIndex, nItemIndex)
  if self:IsCanOpenTheReputePopWnd(nGroupIndex, nItemIndex) == 1 then
    self:OnOutLookItemSelected(szWndName, nGroupIndex, nItemIndex)
    self.PreShowReputePopLock = 0
  end
end

function tbPlayerPanel:OnOutLookItemSelected(szWndName, nGroupIndex, nItemIndex)
  if OUTLOOK_REPUTE == szWndName then
    self:ReputeOutLookItemSel(nGroupIndex, nItemIndex)
    return
  elseif szWndName ~= OUTLOOK_TITLE then
    return
  end

  self.m_nSelTitleX = nGroupIndex
  self.m_nSelTitleY = nItemIndex

  local szDesc = self.tbTitleTable[nGroupIndex + 1].TitleData[nItemIndex + 1].szTitleDesc
  Txt_SetTxt(self.UIGROUP, TEXT_TITLE_DESCRIBE, szDesc)

  if self:IsCurActiveTitle(nGroupIndex + 1, nItemIndex + 1) == 1 then -- 被选中的那行
    Wnd_SetEnable(self.UIGROUP, BTN_ACTIVE_TITLE, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_INACTIVE_TITLE, 1)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_ACTIVE_TITLE, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_INACTIVE_TITLE, 0)
  end
end

--	右键点击Outlook中的Item将选中的声望介绍窗口重置为非锁定状态
function tbPlayerPanel:OnOutLookItemRBClicked(szWndName, nGroupIndex, nItemIndex)
  if self.nIsOpenTheReputePopInfoWnd == 0 then --没有打开声望介绍窗口直接跳出执行
    return
  end
  if szWndName == OUTLOOK_REPUTE then
    local nIndexParent = -1
    local nIndexChild = -1
    if nGroupIndex == 0 then --如果点击是 我所关注的Group 则从tbCareBindTable表中查找信息
      local tbChooseItemAddress = self.tbCareBindTable[nItemIndex] --通过关注绑定表取得点击信息的 父子索引
      nIndexParent = tbChooseItemAddress[1]
      nIndexChild = tbChooseItemAddress[2]
    end
    if nGroupIndex == 1 then --如果点击是 我不关注的Group则从tbNotCareBindTable表中查找信息
      local tbChooseItemAddress = self.tbNotCareBindTable[nItemIndex] --通过不关注绑定表取得点击信息的 父子索引
      nIndexParent = tbChooseItemAddress[1]
      nIndexChild = tbChooseItemAddress[2]
    end
    if nIndexParent == self.nReputeCurrentSelectItemParentIndex and nIndexChild == self.nReputeCurrentSelectItemChildIndex then
      self:OnButtonClick(self.ReputeInfoWndBtnClose, 0)
    end
  end
end

function tbPlayerPanel:UpdateTitleOutLook()
  OutLookPanelClearAll(self.UIGROUP, OUTLOOK_TITLE)
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 0, 25)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 1, 20)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 2, 120)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 3, 120)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 4, 30)

  if self.tbTitleTable == nil then
    return
  end

  local byTitleGenre, byTitleDetailType, byTitleLevel, dwTitleParam = me.GetCurTitle()
  local szIsActiveTitle = ""

  for i = 1, #self.tbTitleTable do
    AddOutLookGroup(self.UIGROUP, OUTLOOK_TITLE, self.tbTitleTable[i].szTitleGenreAttr)
    for j = 1, #self.tbTitleTable[i].TitleData do
      local tItem = self.tbTitleTable[i].TitleData[j]
      if tItem ~= nil then
        local szEndTime = ""
        if tItem.tTitleEndTime == 0 then
          szEndTime = "--"
        else
          szEndTime = os.date("%Y/%m/%d %H:%M", tItem.tTitleEndTime)
        end
        if self:IsCurActiveTitle(i, j) == 1 then
          szIsActiveTitle = "★"
        else
          szIsActiveTitle = " "
        end
        local tOLItem = { "", szIsActiveTitle, tItem.szTitleName, szEndTime, tItem.byTitleRank }
        if j ~= #self.tbTitleTable[i].TitleData then
          AddOutLookItem(self.UIGROUP, OUTLOOK_TITLE, i - 1, tOLItem, "", OUTLOOK_ITEM_BACKGROUD_IMAGE1)
        else
          AddOutLookItem(self.UIGROUP, OUTLOOK_TITLE, i - 1, tOLItem, "", OUTLOOK_ITEM_BACKGROUD_IMAGE2)
        end
      end
    end
    if i ~= 1 then
      SetGroupCollapseState(self.UIGROUP, OUTLOOK_TITLE, i - 1, 0)
    end
  end
end

function tbPlayerPanel:IsCurActiveTitle(nX, nY)
  if (not nX) or not nY or (nX <= 0) or (nY <= 0) then
    return 0
  end

  local tGroup = self.tbTitleTable[nX]
  if type(tGroup) ~= "table" then
    return 0
  end
  local tItem = tGroup.TitleData[nY]
  if type(tItem) ~= "table" then
    return 0
  end

  local nTitleGenre, nTitleDetailType, nTitleLevel = me.GetCurTitle()
  if nTitleGenre == tItem.byTitleGenre and nTitleDetailType == tItem.byTitleDetailType and nTitleLevel == tItem.byTitleLevel then
    return 1
  else
    return 0
  end
end

function tbPlayerPanel:SwitchEquipPage()
  if self.nShowEquipEx == 1 then
    self.nShowEquipEx = 0
    UiManager:CloseWindow(Ui.UI_OTHER_EQUIP)
    --self:UpdateEquipment();
  else
    self.nShowEquipEx = 1
    if UiManager:WindowVisible(Ui.UI_OTHER_EQUIP) == 1 then
      UiManager:CloseWindow(Ui.UI_OTHER_EQUIP)
      self.nShowPartnerEquip = 0
    end
    UiManager:OpenWindow(Ui.UI_OTHER_EQUIP, 1)
    --self:UpdateEquipEx();
  end
  --self:UpdateEquipDur();
end

function tbPlayerPanel:ShowPartnerEquipPage()
  if self.nShowPartnerEquip == 1 then
    self.nShowPartnerEquip = 0
    UiManager:CloseWindow(Ui.UI_OTHER_EQUIP)
  else
    self.nShowPartnerEquip = 1
    if UiManager:WindowVisible(Ui.UI_OTHER_EQUIP) == 1 then
      UiManager:CloseWindow(Ui.UI_OTHER_EQUIP)
      self.nShowEquipEx = 0
    end
    UiManager:OpenWindow(Ui.UI_OTHER_EQUIP, 2)
  end
end

function tbPlayerPanel:ApplySwitchEquip(bReFresh)
  local tbPair = {}
  local nCount = 0
  for _, tbEquipType in ipairs(SELF_SWITCHABLE_EQUIP) do
    local nEquipPos = tbEquipType[1]
    local pEquipEx = me.GetEquipEx(nEquipPos)
    if pEquipEx then
      nCount = nCount + 1
      tbPair[nCount] = { nEquipPos, Item:EqPos2EqExPos(nEquipPos) }
    end
  end
  if nCount == 0 then
    me.Msg("您没有备用装备，无法切换！")
    return
  end
  me.SwitchEquip(nCount, tbPair)
  self.nShowEquipEx = 0
  if bReFresh then -- 快捷键加参数不刷新OBJ空间 防止弹TIP
    self:SetShowEquipState()
  else
    self:UpdateEquipment()
  end
  self:UpdateEquipDur()
end

function tbPlayerPanel:IsSwitchEquip(szEquipPos)
  for _, tbEquipType in ipairs(SELF_SWITCHABLE_EQUIP) do
    if tbEquipType[2] == szEquipPos then
      return 1
    end
  end
  return 0
end

function tbPlayerPanel:SetShowEquipState()
  --[[if self.nShowEquipEx == 1 then
		Btn_SetTxt(self.UIGROUP, BTN_EQUIP_PAGE, "当前装备");
	else
		Btn_SetTxt(self.UIGROUP, BTN_EQUIP_PAGE, "备用装备");
	end]]
  --
  Btn_SetTxt(self.UIGROUP, BTN_EQUIP_PAGE, "备用装备")
end

-- zhengyuhua: TODO 临时为聊天频道刷新加一个响应事件，以后改造聊天栏之后这里要做修改
function tbPlayerPanel:UpdateFaction()
  --	UpdateChatChanel();
  self:UpdateBasicFaction()
end

function tbPlayerPanel:UpdateEquipDur()
  for _, tbCont in pairs(self.tbEquipCont) do
    if tbCont then
      local pItem = me.GetItem(tbCont.nRoom, tbCont.nOffsetX, tbCont.nOffsetY)
      -- 真元没有耐久度，不需要显示耐久度
      if pItem and tbCont.nOffsetX < Item.EQUIPPOS_ZHENYUAN_MAIN then
        if tbCont.nOffsetX >= Item.EQUIPEXPOS_HEAD and tbCont.nOffsetX <= Item.EQUIPEXPOS_PENDANT then
          ObjGrid_ShowSubScript(tbCont.szUiGroup, tbCont.szObjGrid, 1, 0, 0)
          local nPerDur = math.ceil((pItem.nCurDur / pItem.nMaxDur) * 100)
          if nPerDur > 0 and nPerDur <= 10 then
            ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "Red")
          elseif nPerDur > 10 and nPerDur <= 60 then
            ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "yellow")
          elseif nPerDur > 60 then
            ObjGrid_ChangeSubScriptColor(tbCont.szUiGroup, tbCont.szObjGrid, "green")
          end

          local szDur = tostring(nPerDur) .. "%"
          ObjGrid_ChangeSubScript(tbCont.szUiGroup, tbCont.szObjGrid, szDur, 0, 0)
        end
      end
    end
  end
end

function tbPlayerPanel:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_SERIES, self.UpdateBasicSeries },
    { UiNotify.emCOREEVENT_SYNC_LEVEL, self.UpdateBasicLevel },
    { UiNotify.emCOREEVENT_SYNC_EXP, self.UpdateBasicExp },
    { UiNotify.emCOREEVENT_SYNC_FACTION, self.UpdateFaction },
    { UiNotify.emCOREEVENT_SYNC_PKVALUE, self.UpdateBasicPKValue },
    { UiNotify.emCOREEVENT_SYNC_LIFE, self.UpdateBasicLife },
    { UiNotify.emCOREEVENT_SYNC_MANA, self.UpdateBasicMana },
    { UiNotify.emCOREEVENT_SYNC_STAMINA, self.UpdateBasicStamina },
    { UiNotify.emCOREEVENT_SYNC_GTP, self.UpdateBasicGTP },
    { UiNotify.emCOREEVENT_SYNC_MKP, self.UpdateBasicMKP },
    { UiNotify.emCOREEVENT_SYNC_RESIST, self.UpdateBasicResist },
    { UiNotify.emCOREEVENT_SYNC_DAMAGE, self.OnSyncDamage },
    { UiNotify.emCOREEVENT_SYNC_ATTACKRATE, self.UpdateBasicAttackRate },
    { UiNotify.emCOREEVENT_SYNC_ATTACKSPEED, self.UpdateBasicAttackSpeed },
    { UiNotify.emCOREEVENT_SYNC_DEFENSE, self.UpdateBasicDefense },
    { UiNotify.emCOREEVENT_SYNC_RUNSPEED, self.UpdateBasicRunSpeed },
    { UiNotify.emCOREEVENT_SYNC_POTENTIAL, self.OnSyncPotential },
    { UiNotify.emCOREEVENT_SYNC_REMAIN, self.OnSyncRemainPotential },
    { UiNotify.emCOREEVENT_SYNC_PORTRAIT, self.UpdateBasicPortrait },
    { UiNotify.emCOREEVENT_SYNC_REPUTE, self.OnUpdatePageRepute },
    { UiNotify.emCOREEVENT_SYNC_TITLE, self.OnUpdatePageTitle },
    { UiNotify.emCOREEVENT_SYNC_ITEM, self.OnSyncItem },
    { UiNotify.emCOREEVENT_SYNC_BLOGINFO, self.OnUpdatePageAllBlog },
    { UiNotify.emCOREEVENT_SYNC_PRESTIGE, self.UpdatePrestige },
    { UiNotify.emCOREEVENT_HONORDATAREFRESH, self.OnHonorRefresh },
    { UiNotify.emCOREEVENT_CHANGE_FACTION_FINISHED, self.OnUpdatePageRepute },
    { UiNotify.emUIEVENT_EQUIP_REFRESH, self.UpdateEquipDur },
    { UiNotify.emUIEVENT_REPAIRALL_SEND, self.RepairAll },
    { UiNotify.emUIEVENT_REPAIREXALL_SEND, self.RepairExAll },
    { UiNotify.emCOREEVENT_DEALYSTRIKE_CHANGE, self.UpdateDeadlyStrikeAndDamage },
  }
  for _, tbEquip in pairs(self.tbEquipCont) do
    tbRegEvent = Lib:MergeTable(tbRegEvent, tbEquip:RegisterEvent())
  end

  tbRegEvent = Lib:MergeTable(tbRegEvent, self.tbObjPreView:RegisterEvent())

  return tbRegEvent
end

function tbPlayerPanel:RegisterMessage()
  local tbRegMsg = {
    { Ui.MSG_PAGE_SEL, "Main", self.OnPageActive, self }, -- 切换page消息
  }
  for _, tbEquip in pairs(self.tbEquipCont) do
    tbRegMsg = Lib:MergeTable(tbRegMsg, tbEquip:RegisterMessage())
  end
  tbRegMsg = Lib:MergeTable(tbRegMsg, self.tbObjPreView:RegisterMessage())
  return tbRegMsg
end

function tbPlayerPanel:GetHistroy(nPage)
  return "" -- 模拟历程文字
end

function tbPlayerPanel:RepairAll()
  local tbItemIndex = {}
  for nPos, tbCont in pairs(self.tbEquipCont) do
    tbCont.nRoom = Item.ROOM_EQUIP
    local pItem = me.GetItem(tbCont.nRoom, nPos, 0)
    if pItem and (pItem.nCurDur < pItem.nMaxDur) then
      table.insert(tbItemIndex, pItem.nIndex)
    end
  end
  if #tbItemIndex > 0 then
    me.RepairEquipment(Item.REPAIR_COMMON, #tbItemIndex, tbItemIndex)
  end
end

function tbPlayerPanel:RepairExAll()
  if tbTempData.nForbidSpeRepair and tbTempData.nForbidSpeRepair == 1 then
    me.Msg("您现在无法特修装备！")
    return 0
  end
  local tbItemIndex = {}
  for nPos, tbCont in pairs(self.tbEquipCont) do
    tbCont.nRoom = Item.ROOM_EQUIP
    local pItem = me.GetItem(tbCont.nRoom, nPos, 0)
    if pItem then
      table.insert(tbItemIndex, pItem.nIndex)
    end
  end
  if #tbItemIndex > 0 then
    me.RepairEquipment(Item.REPAIR_COMMON, #tbItemIndex, tbItemIndex)
    me.RepairEquipment(Item.REPAIR_SPECIAL, #tbItemIndex, tbItemIndex)
  end
end

function tbPlayerPanel:UpdateCellTips()
  for nPos, tbCont in pairs(self.tbEquipCont) do
    local tbTips = SELF_EQUIPMENT_TIP[nPos]
    local pItem = me.GetItem(Item.ROOM_EQUIP, nPos, 0)
    if pItem then
      Wnd_SetTip(self.UIGROUP, tbTips[2], "")
    else
      Wnd_SetTip(self.UIGROUP, tbTips[2], tbTips[3])
    end
  end
end

-- 判断是否需要修理，1 为普修，2 为特修
function tbPlayerPanel:NeedRepair(nType)
  if not nType then
    nType = 1
  end

  --for nPos, tbCont in pairs(self.tbEquipCont) do
  for nPos = 1, Item.EQUIPPOS_CHOP do
    tbCont.nRoom = Item.ROOM_EQUIP
    local pItem = me.GetItem(tbCont.nRoom, nPos, 0)
    if nType == 1 then
      if pItem and (pItem.nCurDur < pItem.nMaxDur) then
        return 1
      end
    elseif nType == 2 then
      if pItem and (pItem.nMaxDur < Item.DUR_MAX) then
        return 1
      end
    end
  end

  return 0
end

function tbPlayerPanel:UpdateFightPower(nPower)
  nPower = math.floor(nPower * 100) / 100
  local szFightPower = string.format("战斗力：%g", nPower)
  Btn_SetTxt(self.UIGROUP, BTN_FIGHTPOWER, szFightPower)
end

function tbPlayerPanel:OnPageActive(szPageSet, szActivePage)
  if szActivePage ~= PAGE_BASIC then
    UiManager:CloseWindow(Ui.UI_CHOOSEPORTRAIT)
  end
end

-- 解析城市
function tbPlayerPanel:ParseBlogCity(szBlogCity)
  local nSeparate = string.find(szBlogCity, "\\")
  if not nSeparate then
    return "无", "无"
  end
  local szProvice = string.sub(szBlogCity, 0, nSeparate - 1)
  local szCity = string.sub(szBlogCity, nSeparate + 1)
  if szProvice == "" or szCity == "" then
    return "无", "无"
  end
  return szProvice, szCity
end

-- 更新星座
function tbPlayerPanel:UpdateStar(nMonth, nDay)
  --local nMonth = GetComboBoxItemId(self.UIGROUP, CMB_MONTH, self.nCurMonthCmbIndex);
  -- nDay = GetComboBoxItemId(self.UIGROUP, CMB_DATE, self.nCurDayCmbIndex);
  local szStarName = ""
  for szName, tbInfo in pairs(STAR_MAP) do
    if (nMonth == tbInfo[1] and nDay >= tbInfo[2]) or (nMonth == tbInfo[3] and nDay <= tbInfo[4]) then -- 星座是跨月的
      szStarName = szName
      break
    end
  end
  Txt_SetTxt(self.UIGROUP, TXT_BLOGSTAR, szStarName)
  return szStarName
end

-- create temp item
function tbPlayerPanel:CreateTempItem(nGenre, nDetail, nParticular, nLevel)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, -1)
  if not pItem then
    return
  end

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem

  return tbObj
end

function tbPlayerPanel:OnObjGridEnter(szWnd, nX, nY)
  local tbObj = nil
  if self.OBJ_INDEX_REPUTE_AWARD[szWnd] then
    local nIndex = self.OBJ_INDEX_REPUTE_AWARD[szWnd]
    tbObj = self.tbAwardGridCont[nIndex]:GetObj(nX, nY)
  end

  if not tbObj then
    return 0
  end

  local pItem = tbObj.pItem
  if not pItem then
    return 0
  end
  --Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_STALL));
  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_GOODS))
end

-- 下面一键金犀特修
function tbPlayerPanel:RepairJxAll()
  local tbJinXi = me.FindClassItemInBags("jinxi")
  if #tbJinXi > 0 then
    Item:GetClass("jinxi"):OnAllRepair(tbJinXi[1].pItem)
  else
    Dialog:Say("修理的金犀值不够")
  end

  UiManager:ReleaseUiState(UiManager.UIS_ITEM_REPAIR)
  return 1
end

--	通过传入显示的左右索引号来更新可购买物品图片控件的显示
function tbPlayerPanel:UpdateReputeItemPic(nLeftIndex, nRightIndex)
  self:HideReputeItemPic()
  local nAddrTmp = 1
  local nColor = 0x60ff0000 -- 没有购买资格的物品设置半透明红色背景色
  for i = nLeftIndex, nRightIndex do
    local tbItemId = Lib:SplitStr(self.tbCurrentSelReputeItemPrize[i].szItemInfo, ",")
    -- nGenre, nDetail, nParticular, nLevel, nBind, nCount, bForceHide
    local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]))
    if tbObj then
      self.tbAwardGridCont[nAddrTmp]:SetObj(tbObj)
      Wnd_Show(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][1])
      Wnd_Show(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][2])
      local nCurrentLevel = me.GetReputeLevel(self.nReputeCurrentSelectItemParentIndex, self.nReputeCurrentSelectItemChildIndex)
      if nCurrentLevel < self.tbCurrentSelReputeItemPrize[i].nLevel then
        --	未达到购买资格红底显示
        ObjGrid_ChangeBgColor(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][1], nColor, 0, 0)
        Txt_SetTxt(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][2], "<color=230,60,60>" .. "[" .. self.tbCurrentSelReputeItemPrize[i].nLevel .. "级]" .. "<color>")
      else
        Txt_SetTxt(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][2], "<color=green>" .. "[" .. self.tbCurrentSelReputeItemPrize[i].nLevel .. "级]" .. "<color>")
      end
    end
    nAddrTmp = nAddrTmp + 1
  end
end

--	隐藏可购买物品图片控件 4个
function tbPlayerPanel:HideReputeItemPic()
  local nNumOfItemShow = self.nNumOfPrizeShowOnPage
  for i = 1, nNumOfItemShow do
    Wnd_Hide(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[i][1]) --物品图片层
    Wnd_Hide(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[i][2]) --物品图片下列文字显示
  end
end

function tbPlayerPanel:ReputeItemBrowseButtonShow()
  if self.nNumOfReputePrize < (self.nNumOfPrizeShowOnPage + 1) then
    return
  end

  if self.nReputePrizeShowLeftIndex == 1 then
    Wnd_SetEnable(self.UIGROUP, self.REPUTEINFOWNDPRIZELEFT, 0) -- 设置向左拉的图片为不可用状态
  else
    Wnd_SetEnable(self.UIGROUP, self.REPUTEINFOWNDPRIZELEFT, 1) -- 设置向左拉的图片为可用状态
  end

  if self.nReputePrizeShowRightIndex == self.nNumOfReputePrize then
    Wnd_SetEnable(self.UIGROUP, self.REPUTEINFOWNDPRIZERIGHT, 0) -- 设置向右拉的图片为不可用状态
  else
    Wnd_SetEnable(self.UIGROUP, self.REPUTEINFOWNDPRIZERIGHT, 1) -- 设置向右拉的图片为可用状态
  end
end

function tbPlayerPanel:UpdateReputeInfoPopWnd(nParentIndex, nChildIndex)
  local Progress = 0 --	需要显示的进度条情况  进度条总量为1000
  local IndexParent = nParentIndex
  local IndexChild = nChildIndex
  --	将配置文件中等级信息读取出来 再通过tbLevelTransferToProgressShow表将登记转换为具体显示放到 tbScaleShowed表中
  --	下标代表第几个刻度图片 如果值为0 则不显示 如果值为1 则显示出来
  local szScaleShowed = self.tbLevelTransferToProgressShow[self.tbReputeInfoConfigSpec[IndexParent][IndexChild].nHighLevel - 1]
  local tbScaleShowed = Lib:SplitStr(szScaleShowed, ",")
  --	建立中间解耦Table
  --	将具体等级与tbProgressScaleReference的下标关联解开 这样不同等级都可以用到tbProgressScaleReference表
  local tbBridgeScaleReferenceWithLevel = {}
  local nBrideScaleReferenceWithLevelIndex = 2
  for i = 1, self.ReputeProgressScaleNum do
    if tonumber(tbScaleShowed[i]) ~= 0 then --	这里的值为string类型 需要先转为number再跟0作比较
      tbBridgeScaleReferenceWithLevel[nBrideScaleReferenceWithLevelIndex] = i
      nBrideScaleReferenceWithLevelIndex = nBrideScaleReferenceWithLevelIndex + 1
    end
  end
  local nLevel = me.GetReputeLevel(IndexParent, IndexChild) --	当前等级数
  local nValue = me.GetReputeValue(IndexParent, IndexChild, nLevel) --	当前等级已获得的经验值
  local nStandardValue = self.tbReputeInfoConfigSpec[IndexParent][IndexChild].tbReputeXML[nLevel].nLevelUp --	当前等级升级所需的经验值
  local tbPSR = self.tbProgressScaleReference
  local tbBSRWL = tbBridgeScaleReferenceWithLevel
  --	以下部分根据等级数以及经验值计算出进度条显示出的数值
  if nLevel == self.tbReputeInfoConfigSpec[IndexParent][IndexChild].nHighLevel then -- 已经升级到最高级
    Progress = 1000
  elseif nLevel == 1 and nValue == 0 then
    Progress = 0
  elseif self.tbReputeInfoConfigSpec[IndexParent][IndexChild].nHighLevel == 2 and nLevel == 1 then
    Progress = (nValue / nStandardValue) * 1000
  elseif self.tbReputeInfoConfigSpec[IndexParent][IndexChild].nHighLevel ~= 2 and nLevel == 1 then
    local nProgressDistance = tbPSR[tbBSRWL[nLevel + 1]] * (nValue / nStandardValue)
    Progress = nProgressDistance / self.ReputeProgressDistance * 1000
  elseif nLevel > 1 and nLevel == (self.tbReputeInfoConfigSpec[IndexParent][IndexChild].nHighLevel - 1) then
    local nProgressDistance = tbPSR[tbBSRWL[nLevel]] + (self.ReputeProgressDistance - tbPSR[tbBSRWL[nLevel]]) * (nValue / nStandardValue)
    Progress = nProgressDistance / self.ReputeProgressDistance * 1000
  elseif nLevel > 1 and nLevel < (self.tbReputeInfoConfigSpec[IndexParent][IndexChild].nHighLevel - 1) then
    local nProgressDistance = tbPSR[tbBSRWL[nLevel]] + (tbPSR[tbBSRWL[nLevel + 1]] - tbPSR[tbBSRWL[nLevel]]) * (nValue / nStandardValue)
    Progress = nProgressDistance / self.ReputeProgressDistance * 1000
  end

  --	将9个ProgressBar上的刻度图标隐藏 再通过配置表的信息显示指定的图标
  for i = 1, self.ReputeProgressScaleNum do
    local szTmpName = "ReputeInfoWndProgressBarNode" .. tostring(i)
    Wnd_Hide(self.UIGROUP, szTmpName)
  end
  for i = 1, self.ReputeProgressScaleNum do
    local szTmpName = "ReputeInfoWndProgressBarNode" .. tostring(tbBridgeScaleReferenceWithLevel[i])
    Wnd_Show(self.UIGROUP, szTmpName)
  end

  Prg_SetPos(self.UIGROUP, tbPlayerPanel.REPUTE_INFO_WND_PROGRESSBAR, Progress)

  self.bIsOpenTheReputePopInfoWnd = 1 --弹开声望Info窗口 将bIsOpenTheReputePopInfoWnd设置为1

  --	处理载入可购买物品图片信息
  --	首先判断角色是男是女 分别载入不同的声望物品信息  MAwardPic or WAwardPic
  --	me.nSex	男 返回值为0 		女 返回值为1
  local nSex = me.nSex
  local tbAwardPic = {}
  local tbAwardShowData = {}
  local nNumOfAward = 1 -- 奖励物品的个数 这里用来判断是否显示左右拉的按钮
  if nSex == 0 then
    --	男的处理
    for i = 1, tbPlayerPanel.AWARD_GRID_COUNT do
      tbAwardPic[i] = self.tbReputeInfoConfigSpec[IndexParent][IndexChild]["nMAwardPic" .. i]
    end
  else
    --	女的处理
    for i = 1, tbPlayerPanel.AWARD_GRID_COUNT do
      tbAwardPic[i] = self.tbReputeInfoConfigSpec[IndexParent][IndexChild]["nWAwardPic" .. i]
    end
  end

  for i = 1, tbPlayerPanel.AWARD_GRID_COUNT do
    if tostring(tbAwardPic[i]) ~= "" then
      --如果不为空 说明此级别可以获得声望物品购买资格  构造Table 声望达到等级与可购买物品信息对应
      tbAwardShowData[nNumOfAward] = { ["nLevel"] = i, ["szItemInfo"] = tbAwardPic[i] }
      nNumOfAward = nNumOfAward + 1
    end
  end

  self.tbCurrentSelReputeItemPrize = tbAwardShowData --	全局声望资格物品Table
  self.nNumOfReputePrize = nNumOfAward - 1 --	全局声望资格物品个数
  if self.nNumOfReputePrize < (self.nNumOfPrizeShowOnPage + 1) then
    Wnd_Hide(self.UIGROUP, self.REPUTEINFOWNDPRIZELEFT)
    Wnd_Hide(self.UIGROUP, self.REPUTEINFOWNDPRIZERIGHT)
  else
    Wnd_Show(self.UIGROUP, self.REPUTEINFOWNDPRIZELEFT)
    Wnd_SetEnable(self.UIGROUP, self.REPUTEINFOWNDPRIZELEFT, 0)
    Wnd_Show(self.UIGROUP, self.REPUTEINFOWNDPRIZERIGHT)
    self.nReputePrizeShowLeftIndex = 1
    self.nReputePrizeShowRightIndex = self.nNumOfPrizeShowOnPage
  end

  local nLeftIndex = 1 -- 显示框的左边索引	物品Table不变 显示框动态变化
  local nRightIndex = self.nNumOfPrizeShowOnPage -- 显示框的右边索引
  local nAddrTmp = 1

  Wnd_Show(self.UIGROUP, "TxtExReputeAwardPic")
  for i = 1, self.NUM_CONTROL_CLASS do
    if tbAwardShowData[i] ~= nil then
      local tbItemId = Lib:SplitStr(tbAwardShowData[i].szItemInfo, ",")
      -- nGenre, nDetail, nParticular, nLevel, nBind, nCount, bForceHide
      local tbObj = self:CreateTempItem(tonumber(tbItemId[1]), tonumber(tbItemId[2]), tonumber(tbItemId[3]), tonumber(tbItemId[4]))
      local nColor = 0x60ff0000 -- 没有购买资格的物品设置半透明红色背景色
      if tbObj then
        self.tbAwardGridCont[nAddrTmp]:SetObj(tbObj)
        Wnd_Show(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][1])
        Wnd_Show(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][2])
        local nCurrentLevel = me.GetReputeLevel(self.nReputeCurrentSelectItemParentIndex, self.nReputeCurrentSelectItemChildIndex)
        if nCurrentLevel < tbAwardShowData[i].nLevel then
          ObjGrid_ChangeBgColor(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][1], nColor, 0, 0)
          Txt_SetTxt(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][2], "<color=230,60,60>" .. "[" .. tbAwardShowData[i].nLevel .. "级]" .. "<color>")
        else
          Txt_SetTxt(self.UIGROUP, self.IMG_GRID_REPUTE_AWARD[nAddrTmp][2], "<color=green>" .. "[" .. tbAwardShowData[i].nLevel .. "级]" .. "<color>")
        end
      end
      nAddrTmp = nAddrTmp + 1
    end
  end
end

function tbPlayerPanel:PreProcessShowLastTimeReputeInfoWnd()
  local ReputeInfoTxtShow = "" --	需要显示在Scroll面板中的内容

  local szReputeInfoWndTitle
  if self.tbReputeInfoConfigSpec[self.nReputeCurrentSelectItemParentIndex][self.nReputeCurrentSelectItemChildIndex].szInfoTitle ~= "" then
    szReputeInfoWndTitle = self.tbReputeInfoConfigSpec[self.nReputeCurrentSelectItemParentIndex][self.nReputeCurrentSelectItemChildIndex].szInfoTitle
  else
    szReputeInfoWndTitle = self.tbReputeInfoConfigSpec[self.nReputeCurrentSelectItemParentIndex][self.nReputeCurrentSelectItemChildIndex].tbReputeXML.szName
  end
  TxtEx_SetText(self.UIGROUP, tbPlayerPanel.REPUTE_INFO_SHOW_WND_TITLE_TXTEX, szReputeInfoWndTitle)
  ReputeInfoTxtShow = (Ui(Ui.UI_HELPSPRITE).tbHelpContent[self.tbReputeInfoConfigSpec[self.nReputeCurrentSelectItemParentIndex][self.nReputeCurrentSelectItemChildIndex].szTxtInfoAddr])[1]

  Wnd_Show(self.UIGROUP, tbPlayerPanel.WND_REPUTE_INFO)
  TxtEx_SetText(self.UIGROUP, tbPlayerPanel.REPUTE_INFO_WND_TXTEX_SHOW, ReputeInfoTxtShow)
  ScrPnl_Update(self.UIGROUP, tbPlayerPanel.REPUTE_INFO_WND_SCROLL_PANEL)

  --	声望等级进度处理部分代码
  local nIndexParent = self.nReputeCurrentSelectItemParentIndex
  local nIndexChild = self.nReputeCurrentSelectItemChildIndex
  self:UpdateReputeInfoPopWnd(nIndexParent, nIndexChild)
end

--	当重新打开角色属性面板时如果上次关闭时有记录声望页面的Item选择 则将Scroll的位置设置为上次浏览的地方
function tbPlayerPanel:ResumeLastTimePos(nLen)
  self:ResumeScrollPosOnUpdateRepute(nLen, self.REPUTE_SCROLL_PANEL)
  if (self.nGroupIndex >= 0) and (self.nItemIndex >= 0) then
    OutLookPanelSelItem(self.UIGROUP, OUTLOOK_REPUTE, self.nGroupIndex, self.nItemIndex)
  end
end

-- 	更新ComboBox控件
function tbPlayerPanel:UpdateReputeCombo()
  ClearComboBoxItem(self.UIGROUP, CMB_PROPERTY_TYPE)
  for i = 1, #PROPERTY_TYPE_LIST do
    ComboBoxAddItem(self.UIGROUP, CMB_PROPERTY_TYPE, i, PROPERTY_TYPE_LIST[i])
  end
  ComboBoxSelectItem(self.UIGROUP, CMB_PROPERTY_TYPE, 0)

  ClearComboBoxItem(self.UIGROUP, self.REPUTE_PAGE_COMBOBOX) -- 清除Combo下拉框信息
  for i = 1, #self.REPUTE_AWARD_FILTER_TABLE do -- 再依次插入ComBo下拉选项
    ComboBoxAddItem(self.UIGROUP, self.REPUTE_PAGE_COMBOBOX, i, self.REPUTE_AWARD_FILTER_TABLE[i])
  end

  ComboBoxSelectItem(self.UIGROUP, self.REPUTE_PAGE_COMBOBOX, self.nReputeCurrentSelComboIndex - 1)
end

--	设置主窗口的大小 当声望弹出窗关闭时 需要重新设置主窗口的大小 用来避免鼠标的焦点被隐藏的弹出窗屏蔽
function tbPlayerPanel:ResizeMainWnd(nInvolveReputePopWnd)
  if nInvolveReputePopWnd == 1 then
    Wnd_SetSize(self.UIGROUP, self.PAGE_MAIN, 773, 512) -- 将窗口尺寸重新设置 扩宽以显示声望介绍信息
  else
    Wnd_SetSize(self.UIGROUP, self.PAGE_MAIN, 390, 512)
  end
end

function tbPlayerPanel:ResumeScrollPosOnUpdateRepute(nLen, szScrollPanel)
  ScrPanel_SetWndDocumentAbsoluteTop(self.UIGROUP, szScrollPanel, nLen)
end

function tbPlayerPanel:GetShopID()
  local szShopID = self.tbReputeInfoConfigSpec[self.nReputeCurrentSelectItemParentIndex][self.nReputeCurrentSelectItemChildIndex].szShopID
  if szShopID == "" then
    return -1
  end
  local tbShopID = Lib:SplitStr(szShopID, ",")
  --	判断角色属于哪个五行 打开相应的商店
  local szSeries = Env.SERIES_NAME[me.nSeries]
  local nShowShopId = -1
  if szSeries == "金" then
    nShowShopId = tbShopID[1]
  elseif szSeries == "木" then
    nShowShopId = tbShopID[2]
  elseif szSeries == "水" then
    nShowShopId = tbShopID[3]
  elseif szSeries == "火" then
    nShowShopId = tbShopID[4]
  elseif szSeries == "土" then
    nShowShopId = tbShopID[5]
  else
    nShowShopId = tbShopID[1] --如果没有五行属性 默认为金
  end
  return tonumber(nShowShopId)
end

function tbPlayerPanel:ProcessReputeAwardLeft()
  if self.nNumOfReputePrize > self.nNumOfPrizeShowOnPage then
    if self.nReputePrizeShowLeftIndex > 1 then
      self.nReputePrizeShowLeftIndex = self.nReputePrizeShowLeftIndex - 1
      self.nReputePrizeShowRightIndex = self.nReputePrizeShowRightIndex - 1
      self:ReputeItemBrowseButtonShow()
      self:UpdateReputeItemPic(self.nReputePrizeShowLeftIndex, self.nReputePrizeShowRightIndex)
    end
  end
end

function tbPlayerPanel:ProcessReputeAwardRight()
  if self.nNumOfReputePrize > self.nNumOfPrizeShowOnPage then
    if self.nReputePrizeShowRightIndex < self.nNumOfReputePrize then
      self.nReputePrizeShowLeftIndex = self.nReputePrizeShowLeftIndex + 1
      self.nReputePrizeShowRightIndex = self.nReputePrizeShowRightIndex + 1
      self:ReputeItemBrowseButtonShow()
      self:UpdateReputeItemPic(self.nReputePrizeShowLeftIndex, self.nReputePrizeShowRightIndex)
    end
  end
end

function tbPlayerPanel:OpenReputeShop()
  local nShowShopId = self:GetShopID()
  if nShowShopId ~= -1 then
    local nRetVal, szInfo = Shop:IsCanOpenShop(me, nShowShopId)
    if nRetVal == 1 then
      me.CallServerScript({ "ApplyOpenShop", nShowShopId })
    elseif nRetVal == 0 then
      me.Msg(szInfo)
    end
  end
end

function tbPlayerPanel:ProcessReputePageClick()
  if self.nIsOpenTheReputePopInfoWnd == 1 then -- if value is 1  then show the window
    self:ResizeMainWnd(self.INVOLVE_POP_WND) -- 将窗口尺寸重新设置 扩宽以显示声望介绍信息
    Wnd_Show(self.UIGROUP, self.WND_REPUTE_INFO)
    local nCurX, nCurY = Wnd_GetPos(self.UIGROUP, self.PAGE_MAIN) --这里重新设置窗口是因为窗口Open的时候显示声望说明窗口时控件不显示 只有移动窗口才能显示出来 待查明原因
    Wnd_SetPos(self.UIGROUP, self.PAGE_MAIN, nCurX, nCurY)
    self:PreProcessShowLastTimeReputeInfoWnd()
  end
end

function tbPlayerPanel:ProcessViewWealth()
  if UiManager:WindowVisible(Ui.UI_VIEWWEALTHVALUE) == 1 then
    UiManager:CloseWindow(Ui.UI_VIEWWEALTHVALUE)
  else
    UiManager:OpenWindow(Ui.UI_VIEWWEALTHVALUE)
  end
end

function tbPlayerPanel:ProcessReputePopWndCloseBtn()
  self.nIsOpenTheReputePopInfoWnd = 0 -- 如果自己关闭声望说明弹出窗口 则bIsOpenTheReputePopInfoWnd重置为0
  Wnd_Hide(self.UIGROUP, self.WND_REPUTE_INFO)
  self.nGroupIndex = -1
  self.nItemIndex = -1
  self.PreShowReputePopLock = 0
end

function tbPlayerPanel:ReputeOutLookItemSel(nGroupIndex, nItemIndex)
  if self:IsCanOpenTheReputePopWnd(nGroupIndex, nItemIndex) == 0 then
    if self.nIsOpenTheReputePopInfoWnd == 1 then
      self:OnButtonClick(self.ReputeInfoWndBtnClose, 0)
    end
    return
  end
  self.PreShowReputePopLock = 1
  self.nGroupIndex = nGroupIndex
  self.nItemIndex = nItemIndex
  self.nIsOpenTheReputePopInfoWnd = 1
  self:ResizeMainWnd(self.INVOLVE_POP_WND)

  Wnd_Show(self.UIGROUP, tbPlayerPanel.WND_REPUTE_INFO)
  local nCurX, nCurY = Wnd_GetPos(self.UIGROUP, self.PAGE_MAIN) --这里重新设置窗口是因为窗口Open的时候显示声望说明窗口时控件不显示 只有移动窗口才能显示出来 待查明原因
  Wnd_SetPos(self.UIGROUP, self.PAGE_MAIN, nCurX, nCurY)

  Wnd_SetEnable(self.UIGROUP, self.REPUTEINFOWNDPRIZELEFT, 1)
  Wnd_SetEnable(self.UIGROUP, self.REPUTEINFOWNDPRIZERIGHT, 1)

  --	 切换之前 先把上次选择的图片都隐藏
  self:HideReputeItemPic()
  self.nReputeCurrentSelectItemParentIndex = -1
  self.nReputeCurrentSelectItemChildIndex = -1

  local ReputeInfoTxtShow = "" --	需要显示在Scroll面板中的内容
  --	需要显示的进度条情况  进度条总量为1000
  if nGroupIndex == 0 then --如果点击是 我所关注的Group 则从tbCareBindTable表中查找信息
    local tbChooseItemAddress = self.tbCareBindTable[nItemIndex] --通过关注绑定表取得点击信息的 父子索引
    self.nReputeCurrentSelectItemParentIndex = tbChooseItemAddress[1]
    self.nReputeCurrentSelectItemChildIndex = tbChooseItemAddress[2]

    local szReputeInfoWndTitle
    if self.tbReputeInfoConfigSpec[tbChooseItemAddress[1]][tbChooseItemAddress[2]].szInfoTitle ~= "" then
      szReputeInfoWndTitle = self.tbReputeInfoConfigSpec[tbChooseItemAddress[1]][tbChooseItemAddress[2]].szInfoTitle
    else
      szReputeInfoWndTitle = self.tbReputeInfoConfigSpec[tbChooseItemAddress[1]][tbChooseItemAddress[2]].tbReputeXML.szName
    end
    local nLevel = me.GetReputeLevel(tbChooseItemAddress[1], tbChooseItemAddress[2])
    TxtEx_SetText(self.UIGROUP, tbPlayerPanel.REPUTE_INFO_SHOW_WND_TITLE_TXTEX, szReputeInfoWndTitle)

    ReputeInfoTxtShow = (Ui(Ui.UI_HELPSPRITE).tbHelpContent[self.tbReputeInfoConfigSpec[self.nReputeCurrentSelectItemParentIndex][self.nReputeCurrentSelectItemChildIndex].szTxtInfoAddr])[1]
  end
  if nGroupIndex == 1 then --如果点击是 我不关注的Group则从tbNotCareBindTable表中查找信息
    local tbChooseItemAddress = self.tbNotCareBindTable[nItemIndex] --通过不关注绑定表取得点击信息的 父子索引
    self.nReputeCurrentSelectItemParentIndex = tbChooseItemAddress[1]
    self.nReputeCurrentSelectItemChildIndex = tbChooseItemAddress[2]

    local szReputeInfoWndTitle
    if self.tbReputeInfoConfigSpec[tbChooseItemAddress[1]][tbChooseItemAddress[2]].szInfoTitle ~= "" then
      szReputeInfoWndTitle = self.tbReputeInfoConfigSpec[tbChooseItemAddress[1]][tbChooseItemAddress[2]].szInfoTitle
    else
      szReputeInfoWndTitle = self.tbReputeInfoConfigSpec[tbChooseItemAddress[1]][tbChooseItemAddress[2]].tbReputeXML.szName
    end
    TxtEx_SetText(self.UIGROUP, tbPlayerPanel.REPUTE_INFO_SHOW_WND_TITLE_TXTEX, szReputeInfoWndTitle)
    ReputeInfoTxtShow = (Ui(Ui.UI_HELPSPRITE).tbHelpContent[self.tbReputeInfoConfigSpec[self.nReputeCurrentSelectItemParentIndex][self.nReputeCurrentSelectItemChildIndex].szTxtInfoAddr])[1]
  end

  Wnd_Show(self.UIGROUP, tbPlayerPanel.WND_REPUTE_INFO)
  TxtEx_SetText(self.UIGROUP, tbPlayerPanel.REPUTE_INFO_WND_TXTEX_SHOW, ReputeInfoTxtShow)
  ScrPnl_Update(self.UIGROUP, tbPlayerPanel.REPUTE_INFO_WND_SCROLL_PANEL)
  self:ResumeScrollPosOnUpdateRepute(0, tbPlayerPanel.REPUTE_INFO_WND_SCROLL_PANEL)

  --	声望等级进度处理部分代码
  local nIndexParent = self.nReputeCurrentSelectItemParentIndex
  local nIndexChild = self.nReputeCurrentSelectItemChildIndex
  self:UpdateReputeInfoPopWnd(nIndexParent, nIndexChild)
end

function tbPlayerPanel:GetReputeMaxLevel(nIndexParent, nIndexChild)
  -- 获得声望配置信息
  local tbRepute = self.tbReputeSetting[nIndexParent][nIndexChild]
  local nMaxLevel = 0
  for nIndex, _ in pairs(tbRepute) do
    local nIndex = tonumber(nIndex) -- 由于这里数字索引在配置文件repute.xml中是字符 所以先转换一下 如果是字符的索引则变为nil
    if nIndex ~= nil then
      nMaxLevel = nMaxLevel + 1
    end
  end
  return nMaxLevel
end

function tbPlayerPanel:IsCanOpenTheReputePopWnd(nGroupIndex, nItemIndex)
  local tbChooseItemAddress = {}
  local nParentIndex = -1
  local nChildIndex = -1
  if nGroupIndex == 0 then
    tbChooseItemAddress = self.tbCareBindTable[nItemIndex] --通过关注绑定表取得点击信息的 父子索引
    nParentIndex = tbChooseItemAddress[1]
    nChildIndex = tbChooseItemAddress[2]
  else
    tbChooseItemAddress = self.tbNotCareBindTable[nItemIndex] --通过不关注绑定表取得点击信息的 父子索引
    nParentIndex = tbChooseItemAddress[1]
    nChildIndex = tbChooseItemAddress[2]
  end
  if self.tbReputeInfoConfigSpec[nParentIndex][nChildIndex].szTxtInfoAddr == "" then
    return 0
  end
  if not Ui(Ui.UI_HELPSPRITE).tbHelpContent[self.tbReputeInfoConfigSpec[nParentIndex][nChildIndex].szTxtInfoAddr] then
    return 0
  end
  if Ui(Ui.UI_HELPSPRITE).tbHelpContent[self.tbReputeInfoConfigSpec[nParentIndex][nChildIndex].szTxtInfoAddr][1] == "" then
    return 0
  end
  return 1
end
