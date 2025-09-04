-----------------------------------------------------
--文件名		：	mgr.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-04-19
--功能描述		：	窗口管理
-----------------------------------------------------------------------------------------------

local tbMgr = UiManager

tbMgr.WND_MAIN = "Main"

tbMgr.VK_SHIFT = 16
tbMgr.VK_CONTROL = 17

-- Ui状态枚举
tbMgr.UIS_TRADE_PLAYER = 1 -- （与Player）交易
tbMgr.UIS_TRADE_NPC = 2 -- （与npc）交易
tbMgr.UIS_TRADE_SELL = 3 -- （与npc）交易	卖
tbMgr.UIS_TRADE_BUY = 4 -- （与npc）交易	买
tbMgr.UIS_TRADE_REPAIR = 5 -- （与npc）交易	修理
tbMgr.UIS_TRADE_REPAIR_EX = 6 -- （与npc）交易	特修
tbMgr.UIS_STALL_BUY = 7 -- 摆摊:(买方)处于买东西状态
tbMgr.UIS_STALL_SETPRICE = 8 -- 对自己的物品进行标价
tbMgr.UIS_OFFER_SELL = 9 -- 摆摊:(卖方)处于卖东西状态
tbMgr.UIS_OFFER_SETPRICE = 10 -- 对自己的物品进行标价
tbMgr.UIS_ACTION_VIEWITEM = 11
tbMgr.UIS_ACTION_FOLLOW = 12
tbMgr.UIS_ACTION_MAKEFRIEND = 13
tbMgr.UIS_ACTION_TRADE = 14
tbMgr.UIS_ITEM_REPAIR = 15 -- 使用物品修理
tbMgr.UIS_ACTION_GIFT = 16 -- 打开给与界面
tbMgr.UIS_BEGIN_STALL = 17 -- 开始叫卖
tbMgr.UIS_BEGIN_OFFER = 18 -- 开始收购
tbMgr.UIS_OPEN_REPOSITORY = 19 -- 打开储物箱
tbMgr.UIS_ITEM_SPLIT = 20 -- 道具拆分
tbMgr.UIS_MAIL_NEW = 21 -- 新建信件
tbMgr.UIS_EQUIP_BREAKUP = 22 -- 装备拆解
tbMgr.UIS_EQUIP_ENHANCE = 23 -- 装备强化
tbMgr.UIS_EQUIP_PEEL = 24 -- 玄晶剥离
tbMgr.UIS_EQUIP_COMPOSE = 25 -- 玄晶合成
tbMgr.UIS_EQUIP_UPGRADE = 26 -- 印鉴升级
tbMgr.UIS_EQUIP_REFINE = 27 -- 装备炼化
tbMgr.UIS_EQUIP_STRENGTHEN = 28 -- 装备改造
tbMgr.UIS_IBSHOP_CART = 29 -- 奇珍阁购物车
tbMgr.UIS_ZHENYUAN_XIULIAN = 30 -- 真元修炼
tbMgr.UIS_ZHENYUAN_REFINE = 31 -- 真元炼化
tbMgr.UIS_EQUIP_TRANSFER = 32 -- 强化转移
tbMgr.UIS_EQUIP_RECAST = 33 -- 装备重铸
tbMgr.UIS_CAPTURE_SCREEN = 34 -- 等待开始截图状态
tbMgr.UIS_CAPTURE_SCREEN_SELECTING = 35 -- 截图已开始，等待选择区域状态
tbMgr.UIS_CAPTURE_SCREEN_DONE = 36 -- 截图已完成，区域已选定
tbMgr.UIS_SWITCH_EQUIP_SERIES = 37 -- 转装备五行UI状态
tbMgr.UIS_HOLE_MAKEHOLE = 38 -- 装备打孔
tbMgr.UIS_HOLE_MAKEHOLEEX = 39 -- 高级装备打孔
tbMgr.UIS_HOLE_ENCHASE = 40 -- 镶嵌宝石
tbMgr.UIS_STONE_EXCHAGNE = 41 -- 宝石兑换界面状态
tbMgr.UIS_STONE_UPGRADE = 42 -- 宝石升级鼠标状态
tbMgr.UIS_STONE_BREAK_UP = 43 -- 宝石拆解
tbMgr.UIS_WEAPON_PEEL = 44 --青铜武器剥离
tbMgr.UIS_STALL_SALE = 45 -- 摆摊贩卖价格设置
tbMgr.UIS_OFFER_BUY = 46 -- 摆摊收购价格设置
tbMgr.UIS_RESTART_DOWNLOADER = 47 -- 重启downloader界面状态
tbMgr.UIS_EQUIP_CAST = 48 -- 装备精铸状态
tbMgr.UIS_OPEN_KINREPOSITORY = 49 -- 打开家族储物箱
tbMgr.UIS_KINREPITEM_SPLIT = 50 -- 拆分家族道具

-- UI状态对应的鼠标文字
tbMgr.tbMouseText = {
  [tbMgr.UIS_CAPTURE_SCREEN] = "<color=170,230,130><color=yellow>单击右键<color>开始截图",
  [tbMgr.UIS_CAPTURE_SCREEN_SELECTING] = "<color=170,230,130><color=yellow>按住左键拖动<color>选择区域",
  [tbMgr.UIS_CAPTURE_SCREEN_DONE] = "<color=170,230,130><color=yellow>双击左键<color>完成<enter><color=yellow>单击右键<color>重选",
}

-- 和UI接口ProcessSelectedNpc对应的参数
tbMgr.emACTION_CHAT = 0
tbMgr.emACTION_MAKEFRIEND = 1
tbMgr.emACTION_TRADE = 2
tbMgr.emACTION_JOINTEAM = 3
tbMgr.emACTION_INVITETEAM = 4
tbMgr.emACTION_FOLLOW = 5
tbMgr.emACTION_VIEWITEM = 6
tbMgr.emACTION_TONG = 7
tbMgr.emACTION_APPLY_TONG = 8
tbMgr.emACTION_BLACKLIST = 9
tbMgr.emACTION_REVENGE = 10
tbMgr.emACTION_GIVE_MONEY = 11
tbMgr.emACTION_FILTER_WORLD_CHANNEL = 12
tbMgr.emACTION_LEAVETEAM = 13
tbMgr.emACTION_KICKOUT = 14
tbMgr.emACTION_ORIENTATION = 15
tbMgr.emACTION_INVITEEXERCISE = 16
tbMgr.emACTION_VIEWSKILL = 21

-- .tm, .mm, .jp, tr由于和游戏元素重叠先不滤

tbMgr.tbPreFix = { "jxsj", "js", "kinsoft", "jw", "xoyo", "www" }

tbMgr.tbAccurateDomainName = { "tm", "mm", "jp", "tr", "bb", "is", "cy", "sb", "pk" }

tbMgr.tbDomainName = {
  "org",
  "edu",
  "sex",
  "com",
  "net",
  "vn",
  "cn",
  "au",
  "fr",
  "kr",
  "my",
  "us",
  "ca",
  "af",
  "al",
  "as",
  "ad",
  "ao",
  "ai",
  "aq",
  "ag",
  "ar",
  "am",
  "aw",
  "at",
  "az",
  "bs",
  "bh",
  "bd",
  "by",
  "be",
  "bz",
  "bj",
  "bm",
  "bt",
  "bo",
  "ba",
  "bw",
  "bv",
  "br",
  "io",
  "bn",
  "bg",
  "govbf",
  "bi",
  "kh",
  "cm",
  "cv",
  "ky",
  "cf",
  "td",
  "cl",
  "cx",
  "cc",
  "co",
  "cd",
  "ck",
  "cr",
  "hr",
  "cu",
  "cz",
  "dk",
  "dj",
  "dm",
  "do",
  "tp",
  "ec",
  "eg",
  "sv",
  "gq",
  "er",
  "ee",
  "et",
  "fk",
  "fo",
  "fj",
  "fi",
  "tf",
  "ga",
  "gm",
  "ge",
  "de",
  "gh",
  "gi",
  "gr",
  "gl",
  "gd",
  "gp",
  "gu",
  "gt",
  "gn",
  "gy",
  "ht",
  "hm",
  "hn",
  "hk",
  "hu",
  "in",
  "id",
  "ir",
  "iq",
  "ie",
  "il",
  "it",
  "ci",
  "jm",
  "jo",
  "kz",
  "coke",
  "ki",
  "kw",
  "kg",
  "la",
  "lv",
  "lb",
  "ls",
  "lr",
  "ly",
  "li",
  "lt",
  "lu",
  "mo",
  "mk",
  "mg",
  "mw",
  "mv",
  "ml",
  "mt",
  "mq",
  "mr",
  "mu",
  "yt",
  "mx",
  "fm",
  "md",
  "mc",
  "mn",
  "ms",
  "ma",
  "comz",
  "na",
  "nr",
  "np",
  "nl",
  "an",
  "nc",
  "conz",
  "ni",
  "ne",
  "ng",
  "nu",
  "nf",
  "mp",
  "no",
  "om",
  "pw",
  "pa",
  "pg",
  "py",
  "pe",
  "ph",
  "pn",
  "pl",
  "pf",
  "pt",
  "pr",
  "pa",
  "re",
  "ro",
  "ru",
  "rw",
  "sg",
  "sh",
  "kn",
  "lc",
  "st",
  "vc",
  "sm",
  "sa",
  "sn",
  "sc",
  "sl",
  "sg",
  "sk",
  "si",
  "so",
  "coza",
  "cokr",
  "es",
  "lk",
  "sd",
  "sr",
  "sj",
  "sz",
  "se",
  "sy",
  "tj",
  "tw",
  "tz",
  "th",
  "tg",
  "tk",
  "to",
  "tt",
  "tn",
  "tc",
  "tv",
  "ug",
  "ua",
  "uk",
  "uy",
  "uz",
  "va",
  "ve",
  "vg",
  "ws",
  "ye",
  "yu",
  "zm",
  "zw",
  "gov",
  "info",
  "biz",
  "name",
}

tbMgr.tbFrequencyDomainName = { "com", "org", "net", "cn", "cc", "info", "tv", "us", "biz", "mobi", "it" }
tbMgr.bEditBlogState = -1
tbMgr.bForceSend = 0 -- 强制映射
tbMgr.tbAfterPaintCallBack = {}

function tbMgr:Init()
  self.nAutoSelectNpc = 0 -- 自动选中Npc模式
  --  1、鼠标移动时自动选中/取消选中Npc。支持快捷键锁定。
  --  0、鼠标移动无响应。鼠标点中Npc时选中，鼠标点空时取消选中。无锁定操作。
  self.nCurLockNpc = 0 -- 当前锁定NpcIndex（自动模式时）
  self.nCurUiModel = 0
  self.nEnterTime = 0 -- 进入游戏时的时间
  self.bAgreementFlag = 0
  self.tbUiState = {} -- UI状态组

  -- 截图位置
  local tbData = Lib:LoadIniFile("\\config.ini")
  local szPicPath = ((tbData or {}).Client or {}).CapPath or "\\截图\\"
  if string.sub(szPicPath, 2, 2) ~= ":" then -- 不是绝对路径
    if string.sub(szPicPath, 1, 1) ~= "\\" then
      szPicPath = "\\" .. szPicPath
    end
    szPicPath = GetRootPath() .. szPicPath
  end
  if string.sub(szPicPath, -1) ~= "\\" then
    szPicPath = szPicPath .. "\\"
  end
  self.szPicPath = szPicPath
end

-----------------------------------------------------------------------------------------------
-- 窗口管理

-- 打开窗口
function tbMgr:OpenWindow(szUiGroup, ...)
  local tbWnd = Ui(szUiGroup)
  if not tbWnd then
    return
  end
  if self:WindowVisible(szUiGroup) == 1 then
    self:CloseWindow(szUiGroup, unpack(arg)) -- 已经打开则需要先执行关闭
  end
  local nRetCode = 1

  if tbWnd.CanOpenWnd then
    if tbWnd:CanOpenWnd() == 0 then
      return
    end
  end

  if tbWnd.PreOpen then
    nRetCode = tbWnd:PreOpen(unpack(arg)) or 1
  end

  if nRetCode ~= 1 then
    return
  else
    Tutorial:OpenWindow(szUiGroup)
  end

  if tbWnd.OnOpen then
    nRetCode = tbWnd:OnOpen(unpack(arg)) or 1 -- 打开前
  end
  if nRetCode == 1 then
    Wnd_Show(szUiGroup, self.WND_MAIN)
    UiNotify:OnNotify(UiNotify.emUIEVENT_WND_OPENED, szUiGroup)
    Tutorial:OpenWindow(szUiGroup)
    if tbWnd.PostOpen then
      nRetCode = tbWnd:PostOpen(unpack(arg)) or 1
    end
  else
    self:CloseWindow(szUiGroup, unpack(arg)) -- 打开失败要执行关闭操作
  end
  self:OnActiveWnd(szUiGroup, 1)
  UiNotify:OnNotify(UiNotify.emUIEVENT_WND_ACTIVED, szUiGroup)
  return nRetCode
end

-- 关闭窗口
function tbMgr:CloseWindow(szUiGroup, ...)
  if self:WindowVisible(szUiGroup) ~= 1 then
    return -- 已经关闭了就什么都不做
  end
  local tbWnd = Ui(szUiGroup)
  if not tbWnd then
    return
  end
  if tbWnd.OnClose then
    tbWnd:OnClose(unpack(arg)) -- 关闭前
  end
  if tbWnd.Init then
    tbWnd:Init() -- 存在初始化函数则调用之
  end
  self:WindowReset(szUiGroup) -- 复位整个窗口的控件
  if 1 ~= Ui:LoadExWndConfig(szUiGroup) then -- 复位窗口设置
    LoadWndConfig(szUiGroup)
  end
  Wnd_Hide(szUiGroup, self.WND_MAIN)
  Tutorial:CloseWindow(szUiGroup)
  UiNotify:OnNotify(UiNotify.emUIEVENT_WND_CLOSED, szUiGroup)
end

-- 切换窗口状态，开着的关掉，关着的开起来
function tbMgr:SwitchWindow(szUiGroup, ...)
  if self:WindowVisible(szUiGroup) ~= 1 then
    self:OpenWindow(szUiGroup, unpack(arg))
  else
    self:CloseWindow(szUiGroup, unpack(arg))
  end
end

-- 查看窗口是否打着
function tbMgr:WindowVisible(szUiGroup)
  return Wnd_Visible(szUiGroup, self.WND_MAIN)
end

-- 复位指定窗口
function tbMgr:WindowReset(szUiGroup)
  return Wnd_Reset(szUiGroup, self.WND_MAIN)
end

function tbMgr:MoveWindow(szUiGroup, nX, nY)
  return Wnd_SetPos(szUiGroup, self.WND_MAIN, nX, nY)
end

-- 设置某窗口为独占窗口
function tbMgr:SetExclusive(szUiGroup, bSet)
  Wnd_SetExclusive(szUiGroup, self.WND_MAIN, bSet)
end

-- 切换窗口模式
-- nModel 默认是不填，除非要指定跳到某一个模式
-- 0 正常模式； 1 迷你模式； 2 全隐藏模式
function tbMgr:SwitchUiModel(nModel)
  if nModel then
    self.nCurUiModel = nModel
  else
    self.nCurUiModel = math.mod(self.nCurUiModel + 1, 3)
  end

  --转换模式，始终关闭的界面
  if UiManager:WindowVisible(Ui.UI_CHATNEWMSG) == 1 then
    UiManager:CloseWindow(Ui.UI_CHATNEWMSG)
  end

  if self.nCurUiModel == 0 then
    local tbTempData = Ui.tbLogic.tbTempData
    Open("map", tbTempData.nMiniMapState + 5) -- TODO: huangxin +5 为了把状态0 和参数0区分开 非常龊 会整理
    --Open("chatroom", 1);
    Open("playerbar", 1)
    self:OpenWindow(Ui.UI_SIDEBAR)
    self:OpenWindow(Ui.UI_SKILLBAR)
    self:OpenWindow(Ui.UI_SHORTCUTBAR)
    self:OpenWindow(Ui.UI_PLAYERSTATE)
    self:OpenWindow(Ui.UI_BUFFBAR)
    self:OpenWindow(Ui.UI_TASKTRACK)
    self:OpenWindow(Ui.UI_SNS_ENTRANCE)
    self:OpenWindow(Ui.UI_POPBAR)
    if UiVersion == Ui.Version002 then
      self:OpenWindow(Ui.UI_EXPBAR)
      self:OpenWindow(Ui.UI_SIDESYSBAR)
      self:OpenWindow(Ui.UI_PKMODEL)
    end
    self:OpenWindow(Ui.UI_SERVERSPEED)
    if self:WindowVisible(Ui.UI_MSGPAD) ~= 1 then
      self:OpenWindow(Ui.UI_MSGPAD)
    end
    if self:WindowVisible(Ui.UI_GLOBALCHAT) ~= 1 then
      self:OpenWindow(Ui.UI_GLOBALCHAT)
    end
    self:OpenWindow(Ui.UI_MESSAGEPUSHVIEW)
    if self:WindowVisible(Ui.UI_BTNMSG) ~= 1 then
      self:OpenWindow(Ui.UI_BTNMSG)
    end
  elseif self.nCurUiModel == 1 then
    Open("map", 0)
    --Open("chatroom", 0);
    Open("playerbar", 0)
    self:OpenWindow(Ui.UI_SIDEBAR)
    self:OpenWindow(Ui.UI_SKILLBAR)
    self:OpenWindow(Ui.UI_SHORTCUTBAR)
    self:OpenWindow(Ui.UI_PLAYERSTATE)
    self:OpenWindow(Ui.UI_BUFFBAR)
    self:CloseWindow(Ui.UI_POPBAR)
    self:CloseWindow(Ui.UI_SERVERSPEED)
    if UiVersion == Ui.Version002 then
      self:OpenWindow(Ui.UI_EXPBAR)
      self:OpenWindow(Ui.UI_SIDESYSBAR)
      self:OpenWindow(Ui.UI_SERVERSPEED)
      self:CloseWindow(Ui.UI_PKMODEL)
    end
    self:CloseWindow(Ui.UI_TASKTRACK)
    self:CloseWindow(Ui.UI_GLOBALCHAT)
    self:CloseWindow(Ui.UI_SNS_ENTRANCE)
    self:CloseWindow(Ui.UI_MESSAGEPUSHVIEW)
    UiCallback:HideMsgPad()
  elseif self.nCurUiModel == 2 then
    Open("map", -1)
    --Open("chatroom", 0);
    self:CloseWindow(Ui.UI_POPBAR)
    self:CloseWindow(Ui.UI_SIDEBAR)
    self:CloseWindow(Ui.UI_SKILLBAR)
    self:CloseWindow(Ui.UI_SHORTCUTBAR)
    self:CloseWindow(Ui.UI_PLAYERSTATE)
    self:CloseWindow(Ui.UI_BUFFBAR)
    self:CloseWindow(Ui.UI_TASKTRACK)
    self:CloseWindow(Ui.UI_GLOBALCHAT)
    self:CloseWindow(Ui.UI_SNS_ENTRANCE)
    self:CloseWindow(Ui.UI_SERVERSPEED)
    if UiVersion == Ui.Version002 then
      self:CloseWindow(Ui.UI_EXPBAR)
      self:CloseWindow(Ui.UI_SIDESYSBAR)
      self:CloseWindow(Ui.UI_PKMODEL)
    end
    self:CloseWindow(Ui.UI_MESSAGEPUSHVIEW)
    UiCallback:HideMsgPad()
  end
end

-----------------------------------------------------------------------------------------------
-- 事件管理

function tbMgr:OnActiveWnd(szUiGroup, nAction)
  if nAction > 0 then
    Wnd_BringTop(szUiGroup, self.WND_MAIN)
  end
end

-- 游戏世界中左键点下时
function tbMgr:OnLButtonDown()
  local tbMouse = Ui.tbLogic.tbMouse
  if tbMouse:ThrowAway() == 1 then
    return
  end

  local nRetCode = 0

  if self:GetUiState(self.UIS_ACTION_VIEWITEM) == 1 then
    nRetCode = ProcessSelectedNpc(self.emACTION_VIEWITEM)
  elseif self:GetUiState(self.UIS_ACTION_FOLLOW) == 1 then
    nRetCode = ProcessSelectedNpc(self.emACTION_FOLLOW)
  elseif self:GetUiState(self.UIS_ACTION_MAKEFRIEND) == 1 then
    nRetCode = ProcessSelectedNpc(self.emACTION_MAKEFRIEND)
  elseif self:GetUiState(self.UIS_ACTION_TRADE) == 1 then
    nRetCode = ProcessSelectedNpc(self.emACTION_TRADE)
  elseif self:GetUiState(self.UIS_TRADE_PLAYER) == 1 then
  elseif self:GetUiState(self.UIS_TRADE_NPC) == 1 then
  elseif self:GetUiState(self.UIS_STALL_BUY) == 1 then
  elseif self:GetUiState(self.UIS_OFFER_SELL) == 1 then
  elseif self:GetUiState(self.UIS_ACTION_GIFT) == 1 then
  else
    local nNpcIndex = Mouse_Action() -- 默认鼠标左键点击事件，返回选中的nNpcIndex
    if self.nAutoSelectNpc ~= 1 then
      UiSelectNpc(nNpcIndex or 0)
    end
    --点击地面，自动战斗的时候，切回来
    local tbDate = Ui.tbLogic.tbAutoFightData:ShortKey()
    if nNpcIndex == 0 and me.nAutoFightState == 1 and tbDate.nPvpMode == 0 then -- 当前自动战斗中
      tbDate.nAutoFight = 0
      tbDate.nPvpMode = 0
      AutoAi:UpdateCfg(tbDate)
    end
  end

  if nRetCode == 1 then
    uiPopBar:ReleaseAllAction()
  end
end

-- 游戏世界中右键点下时
function tbMgr:OnRButtonDown()
  if (self:GetUiState(self.UIS_ACTION_VIEWITEM) == 1) or (self:GetUiState(self.UIS_ACTION_FOLLOW) == 1) or (self:GetUiState(self.UIS_ACTION_MAKEFRIEND) == 1) or (self:GetUiState(self.UIS_ITEM_REPAIR) == 1) or (self:GetUiState(self.UIS_ACTION_TRADE) == 1) then
    Ui(Ui.UI_POPBAR):ReleaseAllAction()
  else
    Mouse_Force1() -- 默认鼠标右键点击事件
  end
end

-- 游戏世界中按下N键
function tbMgr:OnNKeyDown()
  local tbNpc = me.GetSelectNpc() --鼠标选中NPC
  local dwId = tbNpc and tbNpc.dwId or 0
  me.CallServerScript({ "PlayerSwitchCarrier", dwId })
end

-- 按下ESC键
function tbMgr:OnPressESC()
  if self:WindowVisible(Ui.UI_CAPTURE_SCREEN) == 1 then
    self:CloseWindow(Ui.UI_CAPTURE_SCREEN)
    return
  elseif 1 == self:WindowVisible(Ui.UI_EQUIPCOMPOSE) and 1 ~= Ui(Ui.UI_EQUIPCOMPOSE):CanDirectClose() then
    -- 还不能直接关闭
    return
  elseif self:WindowVisible(Ui.UI_WORLDMAP_SUB) == 1 then
    self:CloseWindow(Ui.UI_WORLDMAP_SUB)
    return
  elseif self:WindowVisible(Ui.UI_WORLDMAP_AREA) == 1 then
    self:CloseWindow(Ui.UI_WORLDMAP_AREA)
    return
  elseif self:WindowVisible(Ui.UI_WORLDMAP_GLOBAL) == 1 then
    self:CloseWindow(Ui.UI_WORLDMAP_GLOBAL)
    return
  end

  if self:WindowVisible(Ui.UI_SCHOOLDEMO) == 1 then
    self:CloseWindow(Ui.UI_SCHOOLDEMO)
    return
  end

  if self:WindowVisible(Ui.UI_WORLDMAP_DOMAIN) == 1 then
    self:CloseWindow(Ui.UI_WORLDMAP_DOMAIN)
    return
  end

  if self:WindowVisible(Ui.UI_TEXTINPUT) == 1 then
    self:CloseWindow(Ui.UI_TEXTINPUT)
    return
  end

  if self:WindowVisible(Ui.UI_JBEXCHANGE) == 1 then
    self:CloseWindow(Ui.UI_JBEXCHANGE)
    return
  end

  if self:WindowVisible(Ui.UI_IBSHOPCART) == 1 then
    self:CloseWindow(Ui.UI_IBSHOPCART)
    return
  end

  if self:WindowVisible(Ui.UI_IBSHOP) == 1 then
    self:CloseWindow(Ui.UI_IBSHOP)
    return
  end

  if self:WindowVisible(Ui.UI_LEVELUPGIFT) == 1 then
    self:CloseWindow(Ui.UI_LEVELUPGIFT)
    return
  end

  --dengyong: 由于优惠券的使用方式改为了从Itembox中拖入到购物车中来使用，而在A模式下Itembox始终被奇珍阁覆盖着，
  --故在A模式下将Itembox的Layer改为了2，这样就不能通过使用Esc来关闭Itembox了，故在这里将Itembox从原来的关闭方式
  --中提取出来，对它做单独的判定。
  if CloseWndsInGame() == 0 and self:WindowVisible(Ui.UI_ITEMBOX) == 0 then
    if self:WindowVisible(Ui.UI_SKILLPROGRESS) == 0 then
      if UiVersion == Ui.Version001 then
        self:SwitchWindow(Ui.UI_SYSTEM)
      else
        self:SwitchWindow(Ui.UI_SYSTEMEX)
      end
    else
      me.BreakProcess()
    end
  end

  if self:WindowVisible(Ui.UI_ITEMBOX) == 1 then
    self:CloseWindow(Ui.UI_ITEMBOX)
    return
  end
end

-- 关闭所有窗口并弹出系统界面
function tbMgr:OnReadyEsc()
  local UI_WINDOW = Ui.UI_SYSTEMEX
  if UiVersion == Ui.Version001 then
    UI_WINDOW = Ui.UI_SYSTEM
  else
  end
  if self:WindowVisible(UI_WINDOW) ~= 0 then
    self:CloseWindow(UI_WINDOW)
    return
  end
  CloseWndsInGame()
  me.BreakProcess()
  self:SwitchWindow(UI_WINDOW)
end

-- 所有窗口事件的转发，转发到具体哪个表的哪个函数由参数szUiGroup和szFunc决定
function tbMgr:OnMessage(nMsg, szUiGroup, szWnd, ...)
  local tbWnd = Ui(szUiGroup)
  if (not tbWnd) or (type(tbWnd) ~= "table") then
    return
  end
  -- TODO: xyf 下面这段可能存在效率问题，考虑优化
  local fnReg = tbWnd.RegisterMessage
  if type(fnReg) == "function" then
    local tbReg = fnReg(tbWnd)
    for _, tb in ipairs(tbReg) do
      if (nMsg == tb[1]) and (szWnd == tb[2]) and tb[3] then
        tb[3](tb[4] or tbWnd, unpack(arg))
      end
    end
  end

  local szFunc = self.tbMsg[nMsg]
  if not szFunc then
    return
  end

  local fnFunc = tbWnd[szFunc]
  if type(fnFunc) == "function" then
    fnFunc(tbWnd, szWnd, unpack(arg))
  end
  Tutorial:ButtonClick(szFunc, szUiGroup, szWnd)
end

-- Add by zhangzhixiong in 2011.3.24
function tbMgr:OnClientInfoSendingProcess()
  local fGamePlayTime = GetClientPlayTime()
  local fGameActiveTime = GetClientActiveTime()
  local nMouseClickNum = GetClientMouseClickNum()
  local nKeyboardClickNum = GetClientKeyboardClickNum()
  local nClientInstanceCurrentNum = GetClientInstanceCurrentNum()

  if fGamePlayTime > 10 then
    me.CallServerScript({ "WriteClientInfoToLog", fGamePlayTime, fGameActiveTime, nMouseClickNum, nKeyboardClickNum, nClientInstanceCurrentNum })
  end

  return 1
end

-- 响应事件：进入游戏
function tbMgr:OnEnterGame()
  self:SwitchUiModel(0)
  Player.tbGlobalFriends:Init()
  ForbitGameSpace(0)
  self:OpenWindow(Ui.UI_NEWSMSG)
  self:OpenWindow(Ui.UI_SERVERSPEED)
  self:OpenWindow(Ui.UI_GLOBALCHAT)
  self:OpenWindow(Ui.UI_GLOBALCHATBUY)
  --self:OpenWindow(Ui.UI_MSGPAD);
  self.nEnterTime = GetTime()

  if self.IVER_nOpenDaily == 1 then -- 马来版不要日报
    if IsDailyOpen() == 1 then
      Ui.tbLogic.tbDaily:OnStart()
    end
  end

  Ui.tbLogic.tbPassPodTime:OnStart()
  Ladder:ClearLadder()
  Player.tbOnlineExp:OnStartCheckOnlineExpState()

  Ui(Ui.UI_SYSTEM)._no_name_or_life = 1 -- 将禁止显示血条的功能关掉
  Ui(Ui.UI_SYSTEM):Update()

  Ui(Ui.UI_SKILLBAR)._disable_switch_skill = nil
  Ui.tbLogic.tbMsgChannel:LoadChannelSetting()
  Sns:OnEnterGame()
  ChatFilter:Init()
  if me.GetTask(2063, 22) ~= UiVersion then
    me.CallServerScript({ "PlayerCmd", "WriteUiVersionLog", UiVersion })
  end
  me.UpdateEquipInvalid()
  Ui(Ui.UI_PAYAWARD):OnEnterGame()
  Ui(Ui.UI_NEWCALENDARVIEW):OnEnterGame()
  Ui(Ui.UI_JXSJKEJU):OnEnterGame()
  -- Add by zhangzhixiong in 2011.3.24
  --Ui.tbLogic.tbTimer:Register(Env.GAME_FPS * 1800, self.OnClientInfoSendingProcess, self);
end

-- 响应事件：离开游戏
function tbMgr:OnLeaveGame()
  --Add by zhangzhixiong in 2011.3.24
  --在游戏下线前调一次，以保障即使游戏时间不足定时器的间隔也能收集客户端信息
  --self:OnClientInfoSendingProcess();

  ForbitGameSpace(0)
  Open("map", -1)
  Open("chatroom", 0)
  Open("playerbar", 0)
  for i, _ in pairs(Ui.tbWnd) do
    self:CloseWindow(i) -- 关闭所有窗口
  end
  self:ClearUiState() -- 清除UI状态
  --	ClearMsg_Channel();				-- 清除聊天信息
  --	ClearChatInput();				-- 清除聊天输入框
  SetCursorImageIdx(Ui.CURSOR_NORMAL) -- 恢复鼠标形状
  Player.tbOnlineExp:OnEndCheckOnlineExpState()
  Sns:OnLeaveGame()
  Ui(Ui.UI_PAYAWARD):OnLeaveGame()
  Ui(Ui.UI_JXSJKEJU):OnLeaveGame()
end

-----------------------------------------------------------------------------------------------
-- 状态管理

-- 设置某个界面状态
function tbMgr:SetUiState(nState)
  if self.tbUiState[nState] ~= 1 then -- 有可能为nil
    self.tbUiState[nState] = 1
    Ui:Output("[INF] SetUiState(" .. nState .. ") --> " .. self.tbUiState[nState])
    if self.tbMouseText[nState] then
      SetMouseText(self.tbMouseText[nState]) -- TODO: 暂未处理叠加
    end
    self:OnSwitchUiState(nState)
  else
    Ui:Output("[INF] SetUiState(" .. nState .. ") == " .. self.tbUiState[nState])
  end
end

-- 释放某个界面状态
function tbMgr:ReleaseUiState(nState)
  if self.tbUiState[nState] == 1 then
    self.tbUiState[nState] = 0
    Ui:Output("[INF] ReleaseUiState(" .. nState .. ") --> " .. self.tbUiState[nState])
    if self.tbMouseText[nState] then
      SetMouseText("")
    end
    self:OnSwitchUiState(nState)
  end
end

function tbMgr:ClearUiState()
  self.tbUiState = {}
end

function tbMgr:IsIdleState()
  for i, v in pairs(self.tbUiState) do
    if v == 1 then
      return 0
    end
  end
  return 1
end

-- 检查是否有某个状态设置
function tbMgr:GetUiState(nState)
  if self.tbUiState[nState] == 1 then
    return 1
  end
  return 0
end

-- 释放一些和鼠标相关的状态
function tbMgr:ReleaseMouseState()
  self:ReleaseUiState(self.UIS_STALL_SETPRICE)
  self:ReleaseUiState(self.UIS_OFFER_SETPRICE)
  self:ReleaseUiState(self.UIS_ITEM_SPLIT)
  self:ReleaseUiState(self.UIS_KINREPITEM_SPLIT)
  self:ReleaseUiState(self.UIS_TRADE_SELL)
  self:ReleaseUiState(self.UIS_TRADE_BUY)
  self:ReleaseUiState(self.UIS_ITEM_REPAIR)
  self:ReleaseUiState(self.UIS_TRADE_REPAIR)
  self:ReleaseUiState(self.UIS_TRADE_REPAIR_EX)
  self:ReleaseUiState(self.UIS_STONE_UPGRADE)
  if self:GetUiState(self.UIS_CAPTURE_SCREEN) == 1 then
    -- 为了保证用户是按的PrintScreen键也能释放状态，
    -- 所以状态释放在PrintScreen中做
    self:PrintScreen()
  end
  Ui(Ui.UI_ITEMBOX):UpdateBtnState()
  Ui(Ui.UI_SHOP):UpdateBtnState()

  return self:IsIdleState()
end

-- 和SwitchWindow同理
function tbMgr:SwitchUiState(nState)
  if self:GetUiState(nState) == 1 then
    self:ReleaseUiState(nState)
  else
    self:SetUiState(nState)
  end
  return self.tbUiState[nState]
end

-- 状态逻辑，在设置或取消某种状态时要做的事情
function tbMgr:OnSwitchUiState(nState)
  if
    (self:GetUiState(self.UIS_TRADE_PLAYER) == 1)
    or (self:GetUiState(self.UIS_TRADE_NPC) == 1)
    or (self:GetUiState(self.UIS_STALL_BUY) == 1)
    or (self:GetUiState(self.UIS_STALL_SETPRICE) == 1)
    or (self:GetUiState(self.UIS_OFFER_SELL) == 1)
    or (self:GetUiState(self.UIS_OFFER_SETPRICE) == 1)
    or (self:GetUiState(self.UIS_BEGIN_STALL) == 1)
    or (self:GetUiState(self.UIS_BEGIN_OFFER) == 1)
    or (self:GetUiState(self.UIS_ACTION_GIFT) == 1)
    or (self:GetUiState(self.UIS_OPEN_REPOSITORY) == 1)
    or (self:GetUiState(self.UIS_EQUIP_ENHANCE) == 1)
    or (self:GetUiState(self.UIS_EQUIP_PEEL) == 1)
    or (self:GetUiState(self.UIS_EQUIP_COMPOSE) == 1)
    or (self:GetUiState(self.UIS_EQUIP_UPGRADE) == 1)
    or (self:GetUiState(self.UIS_EQUIP_REFINE) == 1)
    or (self:GetUiState(self.UIS_EQUIP_STRENGTHEN) == 1)
    or (self:GetUiState(self.UIS_HOLE_MAKEHOLE) == 1)
    or (self:GetUiState(self.UIS_HOLE_MAKEHOLEEX) == 1)
    or (self:GetUiState(self.UIS_STONE_EXCHAGNE) == 1)
    or (self:GetUiState(self.UIS_STONE_BREAK_UP) == 1)
    or (self:GetUiState(self.UIS_HOLE_ENCHASE) == 1)
    or (self:GetUiState(self.UIS_EQUIP_TRANSFER) == 1)
    or (self:GetUiState(self.UIS_EQUIP_RECAST) == 1)
    or (self:GetUiState(self.UIS_SWITCH_EQUIP_SERIES) == 1)
    or (self:GetUiState(self.UIS_WEAPON_PEEL) == 1)
    or (self:GetUiState(self.UIS_RESTART_DOWNLOADER) == 1)
    or (self:GetUiState(self.UIS_EQUIP_CAST) == 1)
  then
    ForbitGameSpace(1)
  else
    ForbitGameSpace(0)
  end
  Ui(Ui.UI_ITEMBOX):UpdateBtnState()
  Ui.tbLogic.tbMouse:OnStateChanged(nState)
end

function tbMgr:ChangeAutoSelect()
  if self.nAutoSelectNpc == 1 then
    self.nAutoSelectNpc = 0
  else
    self.nAutoSelectNpc = 1
  end
  self.nCurLockNpc = 0
  UiAutoSelect(self.nAutoSelectNpc)
end

function tbMgr:LockCurSelect()
  if self.nAutoSelectNpc ~= 1 then -- 非自动选中模式下不支持快捷键
    return
  end
  if self.nCurLockNpc ~= 0 then
    self.nCurLockNpc = UiSelectNpc(0)
  else
    self.nCurLockNpc = UiSelectNpc()
  end
  if self.nCurLockNpc ~= 0 then -- 锁定成功取消自动选中
    UiAutoSelect(0)
  else
    UiAutoSelect(1)
  end
end

-- UIManage初始化时，注册Notify事件
function tbMgr:RegistEvent()
  for _, tbWnd in pairs(Ui.tbWnd) do
    if tbWnd.RegisterEvent then
      local tbReg = tbWnd:RegisterEvent()
      for _, tbEvent in pairs(tbReg) do
        UiNotify:RegistNotify(tbEvent[1], tbEvent[2], tbEvent[3] or tbWnd)
      end
    end
  end
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_UI_INPUT, self.OnTextInput, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_SHOW_MAILCONTENT, self.OpenMailView, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_ITEMGIFT_OPEN, self.OpenItemGift, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_ENHANCE_OPEN, self.OpenItemEnhance, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_PREPARE_ITEMREPAIR, self.PrepareItemRepair, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_SYSTEM_MESSAGE, self.OnSystemMsg, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_STOPLOGOUT, self.OnStopLogout, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_TASK_SHOWBOARD, self.OnShowInfoBoard, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_PROGRESSBAR_TIMER, self.StartProgress, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_OPEN_KINCREATE, self.OpenKinCreate, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_OPEN_TONGCREATE, self.OpenTongCreate, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_SYNC_SELECT_NPC, self.OnSyncSelectNpc, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_CONFIRMATION, self.OnConfirm, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_HOLE_OPEN, self.OnOpenEquipHole, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_PREPARE_STONE_UPGRADE, self.PrepareUpgradeStone, self)
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_STONE_EXCHANGE_OPEN, self.OpenStoneExchange, self)
end

function tbMgr:UseItem(pItem)
  if self:IsIdleState() ~= 1 then
    return
  end

  if (pItem.IsEquip() == 1) and (me.CanUseItem(pItem) ~= 1) then
    me.UseItem(pItem) -- 不能是使用的装备也发协议，因为可能可以改变装备的
    return
  end

  if (not pItem) or (me.CanUseItem(pItem) ~= 1) then
    return -- 不能使用
  end

  if pItem.IsEquip() ~= 1 then
    me.UseItem(pItem) -- 使用的不是装备
    return
  end

  local nEquipPos = pItem.nEquipPos
  local nRoom = Item.ROOM_EQUIP
  if nEquipPos >= Item.EQUIPPOS_NUM then
    nRoom = Item.ROOM_PARTNEREQUIP
    nEquipPos = pItem.nEquipPos - Item.EQUIPPOS_NUM

    if me.nPartnerCount == 0 then
      me.Msg("你当前没有同伴，不能穿上同伴装备！")
      return
    end
  elseif nEquipPos == -1 and pItem.nDetail == Item.EQUIP_ZHENYUAN then
    nEquipPos = me.GetZhenYuanPos()
  end

  local pCurEquip = me.GetItem(nRoom, nEquipPos, 0)
  if pCurEquip then
    if me.IsAccountLock() == 1 then
      Account:OpenLockWindow()
      me.Msg("您目前处于锁定状态，不能脱下身上装备")
      return
    end
  end

  -- 是真元且是第一次被装备时，给出提示对话框
  if (pItem.nDetail == Item.EQUIP_ZHENYUAN) and (Item.tbZhenYuan:GetEquiped(pItem) == 0 or pItem.IsBind() == 0) then
    local tbMsg = {}
    if Item.tbZhenYuan:GetEquiped(pItem) == 0 then
      tbMsg.szMsg = "装备将变为护体真元，护体真元将绑定且不能作为副真元炼化，确定装备么？"
    elseif pItem.IsBind() == 0 then
      tbMsg.szMsg = "装备后护体真元自动绑定，你确定要装备吗？"
    end
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, pItem)
      if (nOptIndex == 2) and pItem then
        me.UseItem(pItem)
      end
    end
    self:OpenWindow(Ui.UI_MSGBOX, tbMsg, pItem)
    return
  end

  if (pItem.nGenre == Item.EQUIP_PARTNER) and (pItem.IsBind() == 0) then
    local tbMsg = {}
    tbMsg.szMsg = "同伴装备装备后自动绑定，你确定要装备吗？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex, pItem)
      if (nOptIndex == 2) and pItem then
        me.UseItem(pItem)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, pItem)
    return
  end

  if (pItem.nBindType == Item.BIND_NONE) or (pItem.nBindType == Item.BIND_NONE_OWN) or (pItem.IsBind() == 1) then
    me.UseItem(pItem) -- 已经绑定或不需要绑定
    return
  end

  local tbMsg = {}
  tbMsg.szMsg = "该装备将与你绑定，绑定后的装备不可丢弃和交易给其他玩家，是否确定？"
  tbMsg.nOptCount = 2
  function tbMsg:Callback(nOptIndex, pItem)
    if (nOptIndex == 2) and pItem then
      me.UseItem(pItem)
    end
  end

  self:OpenWindow(Ui.UI_MSGBOX, tbMsg, pItem)
end

function tbMgr:OnTextInput(nType, szTitle, nMax)
  local tbParam = {}
  tbParam.tbTable = nil
  tbParam.fnAccept = nil
  tbParam.szTitle = szTitle
  tbParam.varDefault = ""
  tbParam.nType = nType
  tbParam.tbRange = { 0, nMax }
  if nMax <= 0 then
    tbParam.tbRange = { 0, nil }
  end
  self:OpenWindow(Ui.UI_TEXTINPUT, tbParam)
end

function tbMgr:OpenMailView()
  self:OpenWindow(Ui.UI_MAILVIEW)
end

function tbMgr:OpenItemGift(szTable)
  local tbGift = KLib.GetValByStr(szTable)
  if (not tbGift) or (type(tbGift) ~= "table") then
    error("无效的给予界面对象！")
    self:CloseWindow(Ui.UI_ITEMGIFT)
    return
  end
  self:OpenWindow(Ui.UI_ITEMBOX)
  self:OpenWindow(Ui.UI_ITEMGIFT, tbGift)
end

function tbMgr:OpenItemEnhance(nMode, nMoneyType)
  if nMode == Item.ENHANCE_MODE_STONE_BREAKUP or nMode == Item.ENHANCE_MODE_CAST then
    self:OpenWindow(Ui.UI_EQUIPENHANCE, nMode, nMoneyType)
  elseif nMode == Item.ENHANCE_MODE_COMPOSE then -- 特殊处理了玄晶合成，特权合玄
    self:OpenWindow(Ui.UI_XUANJINGCOMPOSE, nMoneyType)
  else
    self:OpenWindow(Ui.UI_EQUIPCOMPOSE, nMode, nMoneyType)
  end
end

function tbMgr:OnOpenEquipHole(nMode, nEquipPos)
  self:OpenWindow(Ui.UI_EQUIPHOLE, nMode, nEquipPos)
end

function tbMgr:OpenStoneExchange()
  self:OpenWindow(Ui.UI_EXCHANGE_STONE)
end
function tbMgr:OnSystemMsg(szMsg)
  SysMsg(szMsg) -- 实现了 me.Msg
end

-- 超链接相关
function tbMgr:GetLinkText(szUiGroup, szWnd, szLink)
  return self:_CallLinkClassFun(szUiGroup, szWnd, szLink, "GetText") or szLink
end

function tbMgr:GetLinkTip(szUiGroup, szWnd, szLink)
  return self:_CallLinkClassFun(szUiGroup, szWnd, szLink, "GetTip") or ""
end

function tbMgr:OnLinkClick(szUiGroup, szWnd, szLink)
  self:_CallLinkClassFun(szUiGroup, szWnd, szLink, "OnClick")
end

function tbMgr:_CallLinkClassFun(szUiGroup, szWnd, szLink, szFuncName)
  local szType = szLink
  local szLinkData = ""

  local nAt = string.find(szLink, ":")

  if nAt then
    szType = string.sub(szLink, 1, nAt - 1)
    szLinkData = string.sub(szLink, nAt + 1)
  end

  -- 先检查本窗体的自定义链接
  local tbWnd = Ui(szUiGroup)
  if tbWnd then
    local fnFunc = tbWnd["Link_" .. szType .. "_" .. szFuncName]
    if fnFunc then
      return fnFunc(tbWnd, szWnd, szLinkData)
    end
  end

  -- 再检查通用链接类型
  local tbClass = self.tbLinkClass[szType]
  if not tbClass then
    return
  end

  local fnFunc = tbClass[szFuncName]
  assert(fnFunc)

  return fnFunc(tbClass, szLinkData)
end

function tbMgr:OnNoOperation()
  if Player.tbOffline:CanSleep() == 1 then
    ExitGame()
  end
end

function tbMgr:PrepareItemRepair()
  if me.nAutoFightState == 1 then
    return
  end
  self:SetUiState(self.UIS_ITEM_REPAIR)
  self:OpenWindow(Ui.UI_PLAYERPANEL)
end

function tbMgr:PrepareUpgradeStone()
  if me.nAutoFightState == 1 then
    return
  end
  local uiHole = Ui(Ui.UI_EQUIPHOLE)
  --
  if uiHole and self:WindowVisible(Ui.UI_EQUIPHOLE) then
    -- 如果已经有了升级窗口，不改变玩家操作后的结果
    if uiHole.nMode ~= Item.HOLE_MODE_STONE_UPGRADE then
      -- 模式不对，关闭窗口
      self:CloseWindow(Ui.UI_EQUIPHOLE)
      self:OpenWindow(Ui.UI_PLAYERPANEL) -- 打开辅助窗口
      self:OpenWindow(Ui.UI_ITEMBOX)
    end
  else
    -- 还没有ui窗口，打开F1 F2面板
    self:OpenWindow(Ui.UI_PLAYERPANEL)
    self:OpenWindow(Ui.UI_ITEMBOX)
  end

  self:SetUiState(self.UIS_STONE_UPGRADE)
  self:OpenWindow(Ui.UI_INFOBOARD, "<color=yellow>请点击装备或需要升级的宝石，右键取消升级状态<color>")
  me.Msg("<color=yellow>请点击装备或需要升级的宝石，右键取消升级状态<color>")
end

function tbMgr:OnStopLogout()
  Ui.nExitMode = Ui.EXITMODE_NONE
end

function tbMgr:OnShowInfoBoard(szMsg)
  self:OpenWindow(Ui.UI_INFOBOARD, szMsg)
end

function tbMgr:StartProgress()
  self:OpenWindow(Ui.UI_SKILLPROGRESS)
end

function tbMgr:OpenKinCreate()
  self:OpenWindow(Ui.UI_KINCREATE, 0)
end

function tbMgr:OpenTongCreate()
  self:OpenWindow(Ui.UI_KINCREATE, 1)
end

function tbMgr:OnSyncSelectNpc()
  local pNpc = me.GetSelectNpc()
  if pNpc then
    self:OpenWindow(Ui.UI_SELECTNPC, pNpc)
  else
    self:CloseWindow(Ui.UI_SELECTNPC)
  end
end

function tbMgr:OnConfirm(nCfmId, ...)
  local tbConfirm = Ui.tbLogic.tbConfirm
  tbConfirm:OnConfirm(nCfmId, unpack(arg))
end

-- 消息后是否需要加警告
function tbMgr:CheckNeedAddWarring(szMsg)
  szMsg = Lib:Convert2Semiangle(szMsg) -- 全角->半角
  szMsg = string.lower(szMsg) -- 大写->小写
  szMsg = self:FilterGameInfo(szMsg) -- 滤去游戏定义的特殊
  return self:__HaveDoubtfulInfo(szMsg)
end

-- 过滤游戏中定义的一些特殊字符
function tbMgr:FilterGameInfo(szMsg, tbGameInfo)
  szMsg = string.gsub(szMsg, "<item=[^>]*>", "")
  szMsg = string.gsub(szMsg, "<pic=[^>]*>", "")
  szMsg = string.gsub(szMsg, "<color=[^>]*>", "")

  return szMsg
end

--过滤无用符号，只剩字母和数字
function tbMgr:__Filter(szSrcStr)
  local nStrLen = string.len(szSrcStr)
  local szDesStr = ""
  local nIter = 1

  while nIter <= nStrLen do
    if string.byte(szSrcStr, nIter) > 128 then
      nIter = nIter + 2
    else
      local nChar = string.byte(szSrcStr, nIter)
      if (nChar >= string.byte("a") and nChar <= string.byte("z")) or (nChar >= string.byte("0") and nChar <= string.byte("9")) or nChar == string.byte(".") or nChar == string.byte("@") then
        szDesStr = szDesStr .. string.sub(szSrcStr, nIter, nIter)
      end

      nIter = nIter + 1
    end
  end

  return szDesStr
end

function tbMgr:__HaveDoubtfulInfo(szMsg)
  if self:HaveMaskInfo(szMsg) == 1 then
    return 2
  end

  if self:HaveNumberInfo(szMsg) == 1 then
    return 1
  end

  if self:HaveDomainName(szMsg) == 1 then
    return 1
  end

  szMsg = self:__Filter(szMsg) -- 过滤无用符号，只剩字母和数字
  if self:HaveSiteInfo(szMsg) == 1 then
    return 1
  end

  if self:HaveEmailInfo(szMsg) == 1 then
    return 1
  end

  return 0
end

function tbMgr:HaveMaskInfo(szMsg)
  szMsg = string.gsub(szMsg, "0", "o")
  szMsg = string.gsub(szMsg, " ", "")
  for _, szPostfix in ipairs(self.tbFrequencyDomainName) do
    if string.find(szMsg, "%w*[%.。]" .. szPostfix) then
      return 1
    end
  end
end

function tbMgr:HaveDomainName(szMsg)
  szMsg = string.gsub(szMsg, "0", "o")
  szMsg = string.gsub(szMsg, " ", "")
  if string.find(szMsg, "%a+[%.。]%a%a+") then
    return 1
  end

  for _, szPrifix in ipairs(self.tbPreFix) do
    if string.find(szMsg, szPrifix .. "%w*[%.。]") then
      return 1
    end
  end
  for _, szDomainName in ipairs(self.tbAccurateDomainName) do
    if string.find(szMsg, "[.,:_，。~]" .. szDomainName .. "%A") or string.find(szMsg, "[.,:_，。~]" .. szDomainName .. "$") then
      return 1
    end
  end
  for _, szDomainName in ipairs(self.tbDomainName) do
    if string.find(szMsg, "%A" .. szDomainName .. "%A") or string.find(szMsg, "%A" .. szDomainName .. "$") then
      return 1
    end
  end

  return 0
end

function tbMgr:HaveSiteInfo(szMsg)
  -- IP地址
  local szIP = "%d+%.%d+%.%d+%.%d+"
  if string.find(szMsg, szIP) then
    return 1
  end
  szMsg = string.gsub(szMsg, "0", "o")

  for _, szPostfix in ipairs(self.tbFrequencyDomainName) do
    if string.find(szMsg, ".+" .. szPostfix) then
      return 1
    end
  end

  return 0
end

function tbMgr:HaveNumberInfo(szSrcStr)
  -- TODO:liuchang 过滤.和@
  local szDesStr = ""
  local nIter = 1
  local nStrLen = string.len(szSrcStr)
  local nSpace = 0
  if string.len(szSrcStr) <= 2 then
    return 0
  end

  szSrcStr = string.gsub(szSrcStr, "o", "0")

  if string.find(szSrcStr, "^%d+$") and string.len(szSrcStr) >= 15 then
    return 0
  end

  while nIter <= nStrLen do
    if not string.find(szDesStr, "q") then
      -- 可能是电话
      if string.find(szDesStr, "%d%d%d%d%d%d%d%d*") then
        return 1
      end
    else
      -- 可能是QQ号码
      if string.find(szDesStr, "[1-9]%d%d%d%d%d*") then
        return 1
      end
    end

    if string.byte(szSrcStr, nIter) > 128 then
      nIter = nIter + 2
      szDesStr = ""
    else
      local nChar = string.byte(szSrcStr, nIter)
      if (nChar >= string.byte("a") and nChar <= string.byte("z")) or (nChar >= string.byte("0") and nChar <= string.byte("9")) then
        szDesStr = szDesStr .. string.sub(szSrcStr, nIter, nIter)
      elseif nChar ~= string.byte(" ") then
        nSpace = nSpace + 1
      end

      nIter = nIter + 1
    end
    if nSpace > 3 then
      szDesStr = ""
      nSpace = 0
    end
  end
end

--处理载具左右键技能
function tbMgr:SetupCarrierRightLeftSkill()
  if me.IsInCarrier() == 1 then
    local pCarrier = me.GetCarrierNpc()
    if pCarrier.CanSetLeftRightSkill() == 1 then
      local nLeftSkill = me.GetTask(Item.TSKGID_LEFTRIGHT_CARRIER, Item.TSKID_LEFT_FLAG_CARRIER)
      local nRightSkill = me.GetTask(Item.TSKGID_LEFTRIGHT_CARRIER, Item.TSKID_RIGHT_FLAG_CARRIER)
      --给载具设置左右键技能
      pCarrier.nLeftSkill = nLeftSkill or pCarrier.nLeftSkill
      pCarrier.nRightSkill = nRightSkill or pCarrier.nRightSkill
      CoreEventNotify(UiNotify.emCOREEVENT_FIGHT_SKILL_CHANGED)
    end
  end
end

function tbMgr:HaveEmailInfo(szMsg)
  local szEmail = "%w+@%w+.%w+"

  if string.find(szMsg, szEmail) then
    return 1
  end

  return 0
end

-- 大陆版本地化区域相关脚本处理函数
local localehelp = VFactory:GetClass("localehelp")
function localehelp:HaveSpecialChar(szSrcStr)
  do
    return 0
  end -- TODO: 马上改掉
  szSrcStr = Lib:Convert2Semiangle(szSrcStr)
  szSrcStr = tbMgr:FilterGameInfo(szSrcStr)
  local nStrLen = string.len(szSrcStr)
  if nStrLen < 2 then
    return 0
  end
  local nIter = 1
  while nIter <= nStrLen do
    if string.byte(szSrcStr, nIter) == 215 and (string.byte(szSrcStr, nIter + 1) >= 250 and string.byte(szSrcStr, nIter + 1) <= 254) then
      return 1
    elseif string.byte(szSrcStr, nIter) >= 176 and string.byte(szSrcStr, nIter) <= 247 and string.byte(szSrcStr, nIter + 1) >= 161 and string.byte(szSrcStr, nIter + 1) <= 254 then
      nIter = nIter + 2
    elseif string.byte(szSrcStr, nIter) >= 129 and string.byte(szSrcStr, nIter) <= 160 and string.byte(szSrcStr, nIter + 1) >= 64 and string.byte(szSrcStr, nIter + 1) <= 254 then
      nIter = nIter + 2
    elseif string.byte(szSrcStr, nIter) >= 170 and string.byte(szSrcStr, nIter) <= 254 and string.byte(szSrcStr, nIter + 1) >= 64 and string.byte(szSrcStr, nIter + 1) <= 160 then
      nIter = nIter + 2
    elseif string.byte(szSrcStr, nIter) >= 32 and string.byte(szSrcStr, nIter) <= 127 then
      nIter = nIter + 1
    elseif
      (string.byte(szSrcStr, nIter) == 161 and string.byte(szSrcStr, nIter + 1) == 164)
      or (string.byte(szSrcStr, nIter) == 161 and string.byte(szSrcStr, nIter + 1) == 190)
      or (string.byte(szSrcStr, nIter) == 161 and string.byte(szSrcStr, nIter + 1) == 191)
      or (string.byte(szSrcStr, nIter) == 161 and string.byte(szSrcStr, nIter + 1) == 171) --、号
      or (string.byte(szSrcStr, nIter) == 161 and string.byte(szSrcStr, nIter + 1) == 162) --～号
      or (string.byte(szSrcStr, nIter) == 161 and string.byte(szSrcStr, nIter + 1) == 173)
    then
      nIter = nIter + 2
    else
      return 1
    end
  end
  return 0
end

-- 判断是否需要打开和密保卡相关功能的客户端判断函数
function tbMgr:CheckLockAccountState()
  if 1 == IVER_g_nLockAccount then
    local szGateWayName = GetClientLoginGateway()
    if szGateWayName and string.sub(szGateWayName, 1, 4) == "gate" then
      return 1
    end
  end
  return 0
end

--越南版本地化区域处理相关函数
local vnlocalehelp = VFactory:GetClass("vnlocalehelp")
function vnlocalehelp:HaveSpecialChar(szSrcStr)
  -- 暂时还没做处理
  return 0
end

-- 不可见字符
function tbMgr:HaveSpecialChar(szSrcStr)
  return VFactory:New("localehelp"):HaveSpecialChar(szSrcStr)
end

-- 截图
function tbMgr:PrintScreen(bFromKeyboard, bCaptureScreenState)
  -- 处于截屏状态的处理
  if self:GetUiState(self.UIS_CAPTURE_SCREEN) == 1 then
    self:ReleaseUiState(self.UIS_CAPTURE_SCREEN)
    -- 延迟到下次绘制结束再触发，保证鼠标文字已消失
    self:RegisterAfterPaint(self.PrintScreen, self, bFromKeyboard, 1)
    return
  end

  --截取全屏至buffer中
  local szImageBuffer, nWidth, nHeight = Image_GetScreenBuffer()

  if 0 == Sns.bIsOpen then
    return
  end

  local tbImageInfo = {
    ["szBuffer"] = szImageBuffer,
    ["nWidth"] = nWidth,
    ["nHeight"] = nHeight,
  }

  --由PrintScreen键触发的，保存文件
  if bFromKeyboard == 1 then
    KFile.CreatePath(self.szPicPath)
    local szImagePath = self.szPicPath .. GetLocalDate("%Y-%m-%d_%H-%M-%S.jpg")
    Image_SaveBuffer2File(szImagePath, szImageBuffer, nWidth, nHeight, 1)
    me.Msg("截屏文件已保存到：" .. szImagePath)
    tbImageInfo.szPath = szImagePath
  end

  -- 通知SNS模块
  Sns:OnSaveScreenComplete(tbImageInfo, bFromKeyboard, bCaptureScreenState)
end

-- 注册“一次”绘制完成回调
function tbMgr:RegisterAfterPaint(...)
  table.insert(self.tbAfterPaintCallBack, arg)
  UiSetPaintCallBack()
end

-- 绘制完成回调（因为触发频率太高，只在要求回调时才会调“一次”）
function tbMgr:AfterPaint()
  local tbCallBacks = self.tbAfterPaintCallBack
  self.tbAfterPaintCallBack = {}
  for _, tb in ipairs(tbCallBacks) do
    Lib:CallBack(tb)
  end
end

function tbMgr:Update(szUiGroup, ...)
  if Ui(szUiGroup) and Ui(szUiGroup).Update then
    Ui(szUiGroup):Update(...)
  end
end

------------------------------------------------------------------------------------------------
