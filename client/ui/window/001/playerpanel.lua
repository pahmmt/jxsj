local tbPlayerPanel = Ui:GetClass("playerpanel")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr
local tbTempData = Ui.tbLogic.tbTempData
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

local MARRIAGE_TYPE = { "形单影只", "心有所属" }
local SEX_TYPE = { "男", "女" }
local SERIES_NAME = { "金", "木", "水", "火", "土" }

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
local BTN_EDITBLOGSAVE = "BtnEditBlogSave"
local CMB_YEAR = "ComboBoxYearEditBlog"
local CMB_MONTH = "ComboBoxMonthEditBlog"
local CMB_DATE = "ComboBoxDateEditBlog"

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
  --self.nProfileVersion = 0;
end

function tbPlayerPanel:OnDestroy()
  for _, tbCont in pairs(self.tbEquipCont) do
    tbObject:UnregContainer(tbCont)
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

  PgSet_ActivePage(self.UIGROUP, PAGESET_MAIN, PAGE_BASIC) -- 设置首页
  self:OnUpdatePreView()
  self:UpdateEquipDur()
  if Player.tbFightPower:IsFightPowerValid() == 1 then
    self:UpdateFightPower(me.GetTask(Player.tbFightPower.TASK_GROUP, Player.tbFightPower.TASK_FIGHTPOWER) / 100)
  end
end

-- 关闭
function tbPlayerPanel:OnClose()
  for _, tbCont in pairs(self.tbEquipCont) do
    tbCont:ClearRoom()
  end
  Ui(Ui.UI_SIDEBAR):WndOpenCloseCallback(self.UIGROUP, 0)
  OnSelPortrait(0) -- 参数 1 打开头像选择界面, 0 为关闭选择界面
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
  elseif BTN_SWITCH == szWnd then -- 五行装备切换
    self:OnSwitch()
  elseif BTN_SEL_PORTRAIT == szWnd then -- 打开头像选择界面
    OnSelPortrait() -- 参数 1 打开头像选择界面, 0 为关闭选择界面
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
    self:OnInactiveTitle()
  elseif BTN_EQUIP_PAGE == szWnd then
    self:SwitchEquipPage()
  elseif BTN_SWITCH_EQUIP == szWnd then
    self:ApplySwitchEquip()
  elseif BTN_HONOR == szWnd then
    self:OnRequestHonorData()
    self:OnUpdatePageHistory()
  elseif BTN_EDITBLOGEditBLOG == szWnd then
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
  elseif PAGE_EDITBLOG == szWnd then
    UiManager.bEditBlogState = 1
    PProfile:Require(me.szName)
  elseif BTN_EDITBLOGSAVE == szWnd then
    local szName = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGNAME)
    local szBlogMonicker = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGMONICKER)
    local szFaction = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGOCCUPATION)
    local szCity = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGCITY)
    local szBlogTag = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGTAG)
    local szLike = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGLIKE)
    local szBlogBlog = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGEditBLOG)
    local szDianDi = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI)
    local lingChen = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGLINGCHEN)
    local shangWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGSHANGWU)
    local zhongWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGZHONGWU)
    local xiaWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGXIAWU)
    local wanShang = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGWANSHANG)
    local wuYe = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGWUYE)
    local nOnlineTime = KPProfile.BoolOffset(lingChen, shangWu, zhongWu, xiaWu, wanShang, wuYe)
    if szName ~= nil and szName ~= "" and szBlogMonicker ~= nil and szBlogMonicker ~= "" and szFaction ~= nil and szFaction ~= "" and szCity ~= nil and szCity ~= "" and szBlogTag ~= nil and szBlogTag ~= "" and szLike ~= nil and szLike ~= "" and szLike ~= "（写下你特有的爱好吧！）" and szBlogBlog ~= nil and szBlogBlog ~= "" and szDianDi ~= nil and szDianDi ~= "" and szDianDi ~= string.format("友情提示：第一次填写此界面的话能获得奖励100绑定%s！", IVER_g_szCoinName) and nOnlineTime ~= nil and nOnlineTime ~= 0 then
      --原始代码
      --if (self.nProfileVersion == 0) then
      --self:ApplyAllBlogInfo();
      --else
      --self:ApplyBlogInfo();
      --end

      --由于SNS功能的加入，客户端取消判断nProfileVersion，统一都使用ApplyAllBlogInfo
      self:ApplyAllBlogInfo()
    else
      local tbApplyMsg = {}
      tbApplyMsg.szMsg = "您填写的内容不完整，无法保存。"
      tbApplyMsg.nOptCount = 1
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbApplyMsg)
    end
  elseif BTN_FIGHTPOWER == szWnd then
    if 1 == Player.tbFightPower:IsFightPowerValid() then
      --UiManager:OpenWindow(Ui.UI_FIGHTPOWER);
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

-- 下拉菜单改变
function tbPlayerPanel:OnComboBoxIndexChange(szWnd, nIndex)
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
  end
  if szWnd == CMB_DATE then
    self.nCurDayCmbIndex = nIndex
  end
end

------ 自定义消息处理函数 ------

function tbPlayerPanel:ApplyAllBlogInfo()
  local szName = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGNAME)

  local szBlogMonicker = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGMONICKER)

  local szFaction = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGOCCUPATION)

  local szCity = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGCITY)

  local szBlogTag = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGTAG)

  local szLike = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGLIKE)

  local szBlogBlog = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGEditBLOG)

  local szDianDi = Edt_GetTxt(self.UIGROUP, EDT_EDITBLOGDIANDI)

  local nSexID = GetComboBoxItemId(self.UIGROUP, CMB_EDITBLOGSEX, self.nCurSexCmbIndex)
  nSexID = nSexID - 1

  local nyear = GetComboBoxItemId(self.UIGROUP, CMB_YEAR, self.nCurYearCmbIndex) - 1
  local nmonth = GetComboBoxItemId(self.UIGROUP, CMB_MONTH, self.nCurMonthCmbIndex) - 1
  local nday = GetComboBoxItemId(self.UIGROUP, CMB_DATE, self.nCurDayCmbIndex) - 1
  local nBlogBirthday = TOOLS_MakeDate(nmonth, nday, nyear)

  local nMarriageType = GetComboBoxItemId(self.UIGROUP, CMB_EDITBLOGMARRIAGE, self.nCurMarriageTypeCmbIndex)

  local lingChen = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGLINGCHEN)
  local shangWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGSHANGWU)
  local zhongWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGZHONGWU)
  local xiaWu = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGXIAWU)
  local wanShang = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGWANSHANG)
  local wuYe = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGWUYE)
  local nOnlineTime = KPProfile.BoolOffset(lingChen, shangWu, zhongWu, xiaWu, wanShang, wuYe)

  local nFriendOnly = Btn_GetCheck(self.UIGROUP, BTN_EDITBLOGFRIENDONLY)

  PProfile:EditAllInfo(nSexID, nBlogBirthday, nMarriageType, nOnlineTime, nFriendOnly, szName, szBlogMonicker, szFaction, szCity, szBlogTag, szLike, szBlogBlog, szDianDi)

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

  local nyear = GetComboBoxItemId(self.UIGROUP, CMB_YEAR, self.nCurYearCmbIndex) - 1
  local nmonth = GetComboBoxItemId(self.UIGROUP, CMB_MONTH, self.nCurMonthCmbIndex) - 1
  local nday = GetComboBoxItemId(self.UIGROUP, CMB_DATE, self.nCurDayCmbIndex) - 1
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

  ClearComboBoxItem(self.UIGROUP, CMB_YEAR)
  for iyear = 1, #YEAR do
    ComboBoxAddItem(self.UIGROUP, CMB_YEAR, iyear, YEAR[iyear])
  end

  ClearComboBoxItem(self.UIGROUP, CMB_MONTH)
  for imonth = 1, #MONTH do
    ComboBoxAddItem(self.UIGROUP, CMB_MONTH, imonth, MONTH[imonth])
  end

  ClearComboBoxItem(self.UIGROUP, CMB_DATE)
  for iday = 1, #DAY do
    ComboBoxAddItem(self.UIGROUP, CMB_DATE, iday, DAY[iday])
  end
  local nmonth = 0
  local nday = 0
  local nyear = 0
  nmonth, nday, nyear = TOOLS_SpliteDate(nBlogBirthday)
  if nyear >= 0 and nyear <= (#YEAR - 1) then
    ComboBoxSelectItem(self.UIGROUP, CMB_YEAR, nyear)
  end
  if nmonth >= 0 and nmonth <= (#MONTH - 1) then
    ComboBoxSelectItem(self.UIGROUP, CMB_MONTH, nmonth)
  end
  if nday >= 0 and nday <= (#DAY - 1) then
    ComboBoxSelectItem(self.UIGROUP, CMB_DATE, nday)
  end

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
    else
      tbItemContent[4] = me.GetReputeValue(nClass, nType, nLevel) .. "/" .. tbSet[nClass][nType][nLevel].nLevelUp
    end
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
        else
          tbItemContent[4] = nValue .. "/" .. tbSet[nClass][nType][nNowLevel].nLevelUp
        end
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
            else
              tbItemContent[4] = me.GetReputeValue(i, j, nLevel) .. "/" .. tbSet[i][j][nLevel].nLevelUp
            end
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
  self:UpdateReputeName()
  local tbSet = self:GetReputePanelValue()
  if not tbSet then
    return
  end

  OutLookPanelClearAll(self.UIGROUP, OUTLOOK_REPUTE)
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_REPUTE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_REPUTE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_REPUTE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_REPUTE, "")
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_REPUTE, 0, 20)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_REPUTE, 1, 100)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_REPUTE, 2, UiManager.IVER_nPlayerPanelRepute)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_REPUTE, 3, 100)

  for i = 1, #tbSet do
    AddOutLookGroup(self.UIGROUP, OUTLOOK_REPUTE, tbSet[i].szName)
    local tbContent = tbSet[i].tbContent
    for j = 1, #tbContent do
      local nRet = AddOutLookItem(self.UIGROUP, OUTLOOK_REPUTE, i - 1, tbContent[j])
    end
    if i ~= 1 then
      SetGroupCollapseState(self.UIGROUP, OUTLOOK_REPUTE, i - 1, 0)
    end
  end

  Wnd_SetEnable(self.UIGROUP, BTN_ACTIVE_TITLE, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_INACTIVE_TITLE, 0)
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
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 0, 100)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 1, 60)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 2, 65)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_HISTORY, 3, 40)

  for nClass, tbSubList in ipairs(tbHonorSettings) do
    AddOutLookGroup(self.UIGROUP, OUTLOOK_HISTORY, tbSubList.szName)
    if tbSubList.tbHonorSubList and #tbSubList.tbHonorSubList > 0 then
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

        local nRet = AddOutLookItem(self.UIGROUP, OUTLOOK_HISTORY, nClass - 1, { tbHonor.szName, szValue, szRank, szLevel })
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

  -- Img_SetImage(self.UIGROUP, IMG_PLAYER_PORTRAIT, 1, szSpr);
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

function tbPlayerPanel:OnEditChange(szWnd, nParam)
  if EDIT_BASIC_NAME == szWnd then
    if Edt_GetTxt(self.UIGROUP, EDIT_BASIC_NAME) ~= me.szName then
      Edt_SetTxt(self.UIGROUP, EDIT_BASIC_NAME, me.szName)
    end
  end
end

function tbPlayerPanel:OnMouseEnter(szWnd)
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
  end

  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

function tbPlayerPanel:OnMouseLeave(szWnd)
  Wnd_HideMouseHoverInfo()
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

function tbPlayerPanel:OnOutLookItemSelected(szWndName, nGroupIndex, nItemIndex)
  if szWndName ~= OUTLOOK_TITLE then
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

function tbPlayerPanel:UpdateTitleOutLook()
  OutLookPanelClearAll(self.UIGROUP, OUTLOOK_TITLE)
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  AddOutLookPanelColumnHeader(self.UIGROUP, OUTLOOK_TITLE, "")
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 0, 30)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 1, 120)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 2, 120)
  SetOutLookHeaderWidth(self.UIGROUP, OUTLOOK_TITLE, 3, 30)

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
        local tOLItem = { szIsActiveTitle, tItem.szTitleName, szEndTime, tItem.byTitleRank }
        AddOutLookItem(self.UIGROUP, OUTLOOK_TITLE, i - 1, tOLItem)
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
    self:UpdateEquipment()
  else
    self.nShowEquipEx = 1
    self:UpdateEquipEx()
  end
  self:UpdateEquipDur()
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
  if self.nShowEquipEx == 1 then
    Btn_SetTxt(self.UIGROUP, BTN_EQUIP_PAGE, "当前装备")
  else
    Btn_SetTxt(self.UIGROUP, BTN_EQUIP_PAGE, "备用装备")
  end
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
  local tbRegMsg = {}
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
