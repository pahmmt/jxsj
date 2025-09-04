-----------------------------------------------------
--文件名		：	lockaccount.lua
--创建者		：	fenghewen
--创建时间		：	2009-12-2
--功能描述		：	金山帐号安全锁界面
------------------------------------------------------
local UiLockAccount = Ui:GetClass("lockaccount")

UiLockAccount.PAGESET_MAIN = "PageSetMain"
UiLockAccount.BTN_CLOSE = "BtnClose"

-- 金山密保卡
UiLockAccount.PAGE_CARD = "PageCard"
UiLockAccount.BTN_CARD_PAGE = "BtnCardPage"
UiLockAccount.BTN_CARD_PROTECT = "BtnCardProtect"
UiLockAccount.BTN_CARD_MISS = "BtnCardMiss"
UiLockAccount.BTN_CARD_DISCHARGE = "BtnCardDischarge"
UiLockAccount.BTN_CARD_CHANGE = "BtnCardChange"
UiLockAccount.BTN_CARD_CANCEL = "BtnCardCancel"
UiLockAccount.TEXTEX_CARD_NOTE = "TxtExCardNote"
UiLockAccount.TEXT_CARD_NUM1 = "TxtCardNum1"
UiLockAccount.TEXT_CARD_NUM2 = "TxtCardNum2"
UiLockAccount.TEXT_CARD_NUM3 = "TxtCardNum3"
UiLockAccount.EDT_CARD_NUM1 = "EdtCardNum1"
UiLockAccount.EDT_CARD_NUM2 = "EdtCardNum2"
UiLockAccount.EDT_CARD_NUM3 = "EdtCardNum3"
UiLockAccount.IMG_CARD_NUM1 = "ImgCardNum1"
UiLockAccount.IMG_CARD_NUM2 = "ImgCardNum2"
UiLockAccount.IMG_CARD_NUM3 = "ImgCardNum3"
UiLockAccount.TEXT_CARD_GUIDE = "TxtCardGuide"

-- 金山令牌
UiLockAccount.PAGE_LINGPAI = "PageLingPai"
UiLockAccount.BTN_LINGPAI_PAGE = "BtnLingPaiPage"
UiLockAccount.BTN_LINGPAI_PROTECT = "BtnLingPaiProtect"
UiLockAccount.BTN_LINGPAI_MISS = "BtnLingPaiMiss"
UiLockAccount.BTN_LINGPAI_DISCHARGE = "BtnLingPaiDischarge"
UiLockAccount.BTN_LINGPAI_CANCEL = "BtnLingPaiCancel"
UiLockAccount.TEXTEX_LINGPAI_NOTE = "TxtExLingPaiNote"
UiLockAccount.TEXTEX_LINGPAI_PSW = "TxtLingPaiPwd"
UiLockAccount.EDT_LINGPAI_PWD = "EdtLingPaiPwd"
UiLockAccount.IMG_LINGPAI_PWD = "ImgLingPaiPwd"
UiLockAccount.TEXT_LINGPAI_GUIDE = "TxtLingPaiGuide"

-- 金山安全锁
UiLockAccount.PAGE_ACCOUNT_LOCK = "PageAccountLock"
UiLockAccount.BTN_ACCOUNT_LOCK_PAGE = "BtnAccountLockPage"
UiLockAccount.BTN_ACCOUNT_LOCK_PROTECT = "BtnAccountLockProtect"
UiLockAccount.BTN_SETPASSWORD = "BtnAccountLockSetPassword"
UiLockAccount.BTN_ACCOUNT_LOCK_DISCHARGE = "BtnAccountLockDischarge"
UiLockAccount.BTN_ACCOUNT_LOCK_CANCEL = "BtnAccountLockCancel"
UiLockAccount.TEXTEX_ACCOUNT_LOCK_NOTE = "TxtExAccountLockNote"
UiLockAccount.TEXTEX_ACCOUNT_LOCK_PSW = "TxtAccountLockPwd"
UiLockAccount.EDT_ACCOUNT_LOCK_PWD = "EdtAccountLockPwd"
UiLockAccount.IMG_ACCOUNT_LOCK_PWD = "ImgAccountLockPwd"
UiLockAccount.TEXT_ACCOUNT_LOCK_GUIDE = "TxtAccountLockGuide"

-- 手机令牌
UiLockAccount.PAGE_KSPHONELOCK = "PageKsPhoneLock"
UiLockAccount.BTN_KSPHONELOCK_PAGE = "BtnKsPhoneLock"
UiLockAccount.BTN_KSPHONELOCK_PROTECT = "BtnKsPhoneLockProtect"
UiLockAccount.BTN_KSPHONELOCK_DISCHARGE = "BtnKsPhoneLockDischarge"
UiLockAccount.BTN_KSPHONELOCK_CANCEL = "BtnKsPhoneLockCancel"
UiLockAccount.TEXTEX_KSPHONELOCK_NOTE = "TxtExKsPhoneLockNote"
UiLockAccount.TEXTEX_KSPHONELOCK_PSW = "TxtKsPhoneLockPwd"
UiLockAccount.EDT_KSPHONELOCK_PWD = "EdtKsPhoneLockPwd"
UiLockAccount.IMG_KSPHONELOCK_PWD = "ImgKsPhoneLockPwd"
UiLockAccount.TEXT_KSPHONELOCK_GUIDE = "TxtKsPhoneLockGuide"

-- 金山密保软件
UiLockAccount.PAGE_MIBAO_LOCK = "PageMibao"
UiLockAccount.BTN_MIBAO_PAGE = "BtnMibaoPage"
UiLockAccount.BTN_MIBAO_LINK = "BtnMibaoLink"
UiLockAccount.BTN_MIBAO_CANCEL = "BtnMibaoCancel"
UiLockAccount.TEXTEX_MIBAO_NOTE = "TxtExMibaoNote"

-- 副密码
UiLockAccount.PAGE_VICE_PASSWORD = "PageVicePassword"
UiLockAccount.BTN_VICE_PASSWORD_PAGE = "BtnVicePassword"
UiLockAccount.BTN_VICE_PASSWORD_OK = "BtnSetVicePassword"
UiLockAccount.BTN_VICE_PASSWORD_CANCEL = "BtnVicePasswordCancel"
UiLockAccount.TEXTEX_VICE_PASSWORD_NOTE = "TxtExVicePasswordNote"
UiLockAccount.BTN_VICE_LIMTT = "BtnVicePassword" --权限按钮（1-8）
UiLockAccount.BTN_VICE_SAVELIMIT = "BtnSetViceLimit"

-- 台湾手机锁
UiLockAccount.PAGE_TW_PHONE_LOCK = "PageTWPhoneLock"
UiLockAccount.BTN_TW_PHONE_LOCK_PAGE = "BtnTWPhoneLockPage"
UiLockAccount.BTN_TW_PHONE_LOCK_PROTECT = "BtnTWPhoneLockProtect"
UiLockAccount.BTN_TW_PHONE_LOCK_CANCEL = "BtnTWPhoneLockCancel"
UiLockAccount.TEXTEX_TW_PHONE_LOCK_NOTE = "TxtExTWPhoneLockNote"
UiLockAccount.TEXT_TW_PHONE_LOCK_GUIDE = "TxtTWPhoneLockGuide"

UiLockAccount.VICE_PASSWORD_NOTE = [[
剑侠世界副密码是剑世新推出的功能，该密码只能用作登陆剑侠世界游戏。这项功能可以防止账号出借或者被盗号的时候被他人登陆金山通行证，从而窃取玩家的个人信息以及本公司旗下其他游戏的信息。<color=yellow>使用金山通行证登陆游戏可以对副密码进行设置，并且修改金山通行证的密码会使副密码自动失效,<color=yellow>本功能推荐经常出借账号或者看重个人信息隐私者使用。

<color=green>本公司绝对不鼓励玩家之间互相出借游戏账号！
]]

UiLockAccount.FOBBIDEN_NOTE = "角色正处于锁定保护状态。该状态下禁止下列操作：\n" .. "1.与玩家交易；             5.使用飞鸽传书；\n" .. "2.摆摊；                   6.丢弃物品；\n" .. "3.使用奇珍阁；             7.生活技能；\n" .. "4.使用金币交易所；         8.强化、剥离和玄晶合成。\n\n"

UiLockAccount.SZ_UNLOCK_NOTE = "<color=green>您已经处于解锁状态！角色在下次登陆时将自动进入锁定状态。祝您游戏愉快！<color>\n"

UiLockAccount.SZ_CARD_NOTE = "<color=yellow>您已经开启了密保卡保护功能。<color>\n\n"

UiLockAccount.SZ_CARD_OPERATION_NOTE = "<color=yellow>请查看密保卡，输入下面行和列对应的数字。<color>"

UiLockAccount.SZ_DISPROTECT_CARD_NOTE = "<color=yellow>您尚未开启金山密保卡保护功能。<color>\n\n" .. "金山密保卡是一张记录着8行10列数字矩阵的图片，开启保护后角色每次登陆都将自动进入锁定状态，只有输入密保卡上的密码后才能进行交易等财产转移操作。密保卡下载后最好打印或者存入手机，不要保存在电脑上。\n\n" .. "<color=yellow>推荐所有用户使用，免费、简单、安全性高。<color>"

UiLockAccount.SZ_GUIDE_CARD_NOTE = "<color=green>服务开通方法：\n" .. "1.点击“开启保护”进入金山密保卡官方网页；\n" .. "2.按照网页提示获取密保卡并绑定游戏帐号。<color>"

UiLockAccount.SZ_LINGPAI_NOTE = "<color=yellow>您已经开启了金山令牌保护功能。<color>\n\n"

UiLockAccount.SZ_KSPHONELOCK_NOTE = "<color=yellow>您已经开启了金山手机令牌保护功能。<color>\n\n"

UiLockAccount.SZ_LINGPAI_OPERATION_NOTE = "<color=yellow>角色每次登陆后都需要等待90秒才能进行解锁。<color>"

UiLockAccount.SZ_KSPHONELOCK_OPERATION_NOTE = "<color=yellow>角色每次登陆后都需要等待90秒才能进行解锁。<color>"

UiLockAccount.SZ_DISPROTECT_LINGPAI_NOTE = "<color=yellow>您尚未开启金山令牌保护功能。<color>\n\n" .. "金山令牌是一种高保密性的硬件产品，采用一次一密的方式，每一个令牌都被付予一组唯一的动态口令种子。开启保护后角色每次登陆都将自动进入锁定状态，只有输入令牌上的动态密码后才能进行交易等财产转移操作。\n\n" .. "<color=yellow>推荐角色上有贵重物品的用户使用，安全性最高。<color>"

UiLockAccount.SZ_GUIDE_LINGPAI_NOTE = "<color=green>服务开通方法：\n" .. "1.点击“开启保护”进入金山令牌官方网页；\n" .. "2.了解令牌的销售方式并购买；\n" .. "3.在金山令牌官方网页绑定令牌。<color>"

UiLockAccount.SZ_GUIDE_ACCOUNT_LOCK_NOTE = "<color=green>服务开通方法：\n" .. "1.点击“开启保护”，设置安全锁密码；\n" .. "2.密码可修改，如不慎遗忘密码可使用“申请解锁”取消密码。<color>"

UiLockAccount.SZ_ACCOUNT_LOCK_NOTE = "您已经开启了安全锁保护功能。<color=yellow>为了更安全的保护您的帐号，强烈建议您开启金山密保卡或金山令牌的功能。<color>\n\n"

UiLockAccount.SZ_ACCOUNT_LOCK_OPERATION_NOTE = "<color=yellow>请用随机数字键盘输入解锁密码。如忘记密码可点击“申请解锁”。<color>"

UiLockAccount.SZ_DISPROTECT_NOTE_ACCOUNT_LOCK = "<color=yellow>您尚未开启任何帐号保护功能。<color>\n\n" .. "安全锁是一种游戏内置的密码保护功能。开启保护后角色每次登陆都将自动进入锁定状态，只有输入设定的密码后才能进行交易等财产转移操作。\n\n" .. "推荐初级用户使用，但为了更安全的保护您的帐号，<color=yellow>强烈建议您开启金山密保卡或者金山令牌功能。<color>"

UiLockAccount.SZ_MIBAO_NOTE = "金山密保软件是金山毒霸与剑侠世界联合研发的“金山密保剑侠世界专用版”防盗号软件，专门针对木马盗号对电脑进行四层防护，有效拦截键盘记录，截屏，内存提取等木马常用盗号手段。是预防木马，保护电脑的重要软件工具。\n\n" .. "适合所有玩家使用，下载安装后，可以一直保护电脑环境，预防木马侵袭。\n\n" .. "<color=yellow>请点击“下载链接”到官方网站了解并下载使用。<color>"

UiLockAccount.SZ_DISPROTECT_KSPHONELOCK_NOTE = "<color=yellow>您尚未开启金山手机令牌保护功能。<color>\n\n" .. "您的账号可能存在安全隐患了，强烈建议您绑定手机令牌。目前手机令牌是安全系数较高的手机软件，操作方便，免费安全，请您尽快绑定。\n\n" .. "<color=yellow>推荐角色上有贵重物品的用户使用，免费，安全性超高。<color>"

UiLockAccount.SZ_GUIDE_KSPHONELOCK_NOTE = "<color=green>服务开通方法：\n" .. "1.点击“开启保护”进入手机令牌官方网页；\n" .. "2.下载对应手机的软件并安装到手机上；\n" .. "3.绑定手机令牌到游戏帐号上。<color>"

UiLockAccount.SZ_CARD_OPEN_URL = "http://ecard.xoyo.com/"
UiLockAccount.SZ_CARD_MISS_URL = "http://ecard.xoyo.com/?t=lost"
UiLockAccount.SZ_CARD_CHANGE_URL = "http://ecard.xoyo.com/?t=change"
UiLockAccount.SZ_CARD_DISCHARGE_URL = "http://ecard.xoyo.com/?t=games"

UiLockAccount.SZ_LINGPAI_OPEN_URL = "http://ekey.xoyo.com/"
UiLockAccount.SZ_LINGPAI_MISS_URL = "http://ekey.xoyo.com/ekeyzp/login.php?type=lost"
UiLockAccount.SZ_LINGPAI_DISCHARGE_URL = "http://ekey.xoyo.com/ekeyzp/login.php?type=setting"

UiLockAccount.SZ_KSPHONELOCK_OPEN_URL = "http://safe.xoyo.com/mkey/tongji/ClientLocal/game/jxsj/"
UiLockAccount.SZ_KSPHONELOCK_DISCHARGE_URL = "http://safe.xoyo.com/mkey/tongji/ClientLocal/game/jxsj/"

UiLockAccount.SZ_MIBAO_URL = "http://www.duba.net/zt/2009/mibao_jxsj2/"

UiLockAccount.SZ_TW_PHONE_LOCK_NOTE = [[
<color=yellow>什麼是通訊鎖？<color>
<color=green>
通訊鎖為保障遊戲帳號資料安全所設置的安全機制，以個人行動電話或市內電話來綁定遊戲帳號。當遊戲帳號登入遊戲中，首次欲進 行遊戲資料交易等財產轉移操作，都須進行通訊鎖解除鎖定方可進行 
<color>
通訊鎖專線 
台灣（含全區）解鎖號碼：0800-771-778 
香港解鎖號碼：3717-1615 
]]
UiLockAccount.SZ_TW_PHONE_LOCK_GUIDE = "通讯锁锁定状态"
UiLockAccount.SZ_TW_PHONE_LOCK_HOLDING = "請於一分鐘內撥打此帳號所綁定的通訊鎖"
UiLockAccount.SZ_TW_PHONE_UNLOCK_GUIDE = "通讯锁锁解锁状态"
UiLockAccount.SZ_NO_TW_PHONE_LOCK_GUIDE = "未申请台湾通讯锁状态"

UiLockAccount.nTWPhoneLockTimer = nil -- 台湾手机锁提示计时器

--提示绑定手机令牌功能
UiLockAccount.nShowTipTimerId = 0
UiLockAccount.nTimeShowTip = 15 * 60 * Env.GAME_FPS
UiLockAccount.nShowTipMaxDayCount = 15

function UiLockAccount:Init()
  self.bProtected = 1 -- 开通保护
  self.bAccountLock = 1 -- 安全锁
  self.bSafeKey = 1 -- 令牌
  self.bKsPhoneLock = 1 -- 金山手机令牌
  self.bSafeCard = 1 -- 密保卡
  self.bTWPhoneLock = 1 -- 台湾手机锁
  self.nPwd = 1
  self.nPos = 100000
  self:UpdatePwdShow()
end

function UiLockAccount:OnOpen()
  if 0 == UiManager:CheckLockAccountState() then
    -- 如果屏蔽密保卡，就要改安全锁说明
    self.SZ_DISPROTECT_NOTE_ACCOUNT_LOCK = [[<color=yellow>您尚未开启任何帐号保护功能。<color>

安全锁是一种游戏内置的密码保护功能。开启保护后角色每次登陆都将自动进入锁定状态，只有输入设定的密码后才能进行交易等财产转移操作。]]

    self.SZ_ACCOUNT_LOCK_NOTE = [[您已经开启了安全锁保护功能。
		
]]
  end

  Txt_SetTxt(self.UIGROUP, self.TEXT_CARD_GUIDE, self.SZ_GUIDE_CARD_NOTE)
  Txt_SetTxt(self.UIGROUP, self.TEXT_LINGPAI_GUIDE, self.SZ_GUIDE_LINGPAI_NOTE)
  Txt_SetTxt(self.UIGROUP, self.TEXT_KSPHONELOCK_GUIDE, self.SZ_GUIDE_KSPHONELOCK_NOTE)
  Txt_SetTxt(self.UIGROUP, self.TEXT_ACCOUNT_LOCK_GUIDE, self.SZ_GUIDE_ACCOUNT_LOCK_NOTE)

  self:ShowLingPaiPswLogin(0)
  self:ShowKsPhoneLockPswLogin(0)
  self:ShowCardPswLogin(0)
  self:ShowAccountLockPswLogin(0)

  self:UpdateProtect()
  --多语言版本的处理
  -- 大陆版
  if 1 == UiManager:CheckLockAccountState() then
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_PAGE, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_PAGE, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_MIBAO_PAGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_KSPHONELOCK_PAGE, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_VICE_PASSWORD_PAGE, 1)

    --按照加锁类别打开相应的分页
    --开通了令牌或密保卡时，需要把另两个分页禁止操作

    if self.bSafeKey == 1 then -- 金山令牌
      PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_LINGPAI)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CARD_PAGE, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_ACCOUNT_LOCK_PAGE, 0)
      --Wnd_SetEnable(self.UIGROUP, self.BTN_KSPHONELOCK_PAGE, 0);
    elseif self.bKsPhoneLock == 1 then -- 手机令牌
      PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_KSPHONELOCK)
      Wnd_SetEnable(self.UIGROUP, self.BTN_CARD_PAGE, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_ACCOUNT_LOCK_PAGE, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_LINGPAI_PAGE, 0)
    elseif self.bSafeCard == 1 then -- 密保卡
      PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_CARD)
      Wnd_SetEnable(self.UIGROUP, self.BTN_LINGPAI_PAGE, 0)
      Wnd_SetEnable(self.UIGROUP, self.BTN_ACCOUNT_LOCK_PAGE, 0)
      --Wnd_SetEnable(self.UIGROUP, self.BTN_KSPHONELOCK_PAGE, 0);
    elseif self.bAccountLock == 1 then -- 帐号锁
      PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_ACCOUNT_LOCK)
    else
      PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_KSPHONELOCK)
    end
  else
    Wnd_SetVisible(self.UIGROUP, self.BTN_VICE_PASSWORD_PAGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_PAGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_PAGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_MIBAO_PAGE, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_KSPHONELOCK_PAGE, 0)
    PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_ACCOUNT_LOCK)
  end

  -- 台湾版手机锁
  if self.bTWPhoneLock == 1 then
    Wnd_SetVisible(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PAGE, 1)
    -- 开启手机锁的话，其他两个锁不显示
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_PAGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_PAGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_KSPHONELOCK_PAGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_MIBAO_PAGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_ACCOUNT_LOCK_PAGE, 1) -- furuilei 手机锁和密码锁要同时开启
    PgSet_ActivePage(self.UIGROUP, self.PAGESET_MAIN, self.PAGE_TW_PHONE_LOCK)
  else
    Wnd_SetVisible(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PAGE, 0)
  end

  --Wnd_SetVisible(self.UIGROUP, self.BTN_VICE_PASSWORD_PAGE, 0); --add by hanruofei

  -- 金山安全锁
  if Player.bApplyingJiesuo == 1 then
    Btn_SetTxt(self.UIGROUP, self.BTN_ACCOUNT_LOCK_DISCHARGE, "取消解锁")
  else
    Btn_SetTxt(self.UIGROUP, self.BTN_ACCOUNT_LOCK_DISCHARGE, "申请解锁")
  end
end

function UiLockAccount:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_CARD_PROTECT then
    if self.bSafeCard == 1 and self.bProtected == 1 then
      self:SafeCardLogin() -- 解锁
    elseif self.bSafeCard == 1 and self.bProtected == 0 then
      me.Msg("您的角色已经处于解锁状态了！")
      --me.CallServerScript{"AccountCmd", Account.LOCKACC};-- 重新开启保护模式
    else
      UiManager:CloseWindow(self.UIGROUP)
      OpenWebSite(self.SZ_CARD_OPEN_URL)
    end
  end
  if szWndName == self.BTN_VICE_PASSWORD_PAGE then
    --如果打开副密码页面
    self:InitVicePassWord()
  end
  if szWndName == self.BTN_VICE_SAVELIMIT then
    --报错权限
    self:SaveVicePassWord()
  end

  if szWndName == self.BTN_LINGPAI_PROTECT then
    --		if self.bProtected == 1 and self.bSafeKey == 1 then
    if self.bProtected == 1 and self.bSafeKey == 1 and Ui.tbLogic.tbPassPodTime:IsReady() == 1 then
      self:SafeKeyLogin() -- 解锁
    elseif self.bProtected == 0 and self.bSafeKey == 1 then
      me.Msg("您的角色已经处于解锁状态了！")
      --me.CallServerScript{"AccountCmd", Account.LOCKACC};	-- 重新开启保护模式
    elseif self.bProtected == 1 and self.bSafeKey == 1 and Ui.tbLogic.tbPassPodTime:IsReady() == 0 then
      me.Msg("角色登陆90秒后才能解除金山令牌，请稍后再进行解锁操作！")
    else
      UiManager:CloseWindow(self.UIGROUP)
      OpenWebSite(self.SZ_LINGPAI_OPEN_URL)
    end
  end

  if szWndName == self.BTN_KSPHONELOCK_PROTECT then
    if self.bProtected == 1 and self.bKsPhoneLock == 1 and Ui.tbLogic.tbPassPodTime:IsReady() == 1 then
      self:KsPhoneLockLogin() -- 解锁
    elseif self.bProtected == 0 and self.bKsPhoneLock == 1 then
      me.Msg("您的角色已经处于解锁状态了！")
    elseif self.bProtected == 1 and self.bKsPhoneLock == 1 and Ui.tbLogic.tbPassPodTime:IsReady() == 0 then
      me.Msg("角色登陆90秒后才能解除手机令牌，请稍后再进行解锁操作！")
    else
      OpenWebSite(self.SZ_KSPHONELOCK_OPEN_URL)
      UiManager:CloseWindow(self.UIGROUP)
    end
  end

  if szWndName == self.BTN_ACCOUNT_LOCK_PROTECT then
    if self.bProtected == 1 and self.bAccountLock == 1 then -- 如果处于密保锁保护模式中
      if me.GetAccountLockState() == 1 then
        self:SafeAccountLockLogin() -- 解锁
      else
        me.Msg("您的角色已经处于解锁状态了！")
      end
    --			UiManager:OpenWindow(Ui.UI_UNLOCK); -- 打开解锁界面
    elseif self.bProtected == 0 and self.bAccountLock == 1 then -- 如果不在保护模式中
      me.Msg("您的角色已经处于解锁状态了！")
      --me.CallServerScript{"AccountCmd", Account.LOCKACC};-- 重新开启保护模式
    else
      UiManager:OpenWindow(Ui.UI_SETPASSWORD, 1) -- 打开初始设定密码界面
    end
  end

  if szWndName == self.BTN_SETPASSWORD then
    if self.bAccountLock ~= 1 then
      UiManager:OpenWindow(Ui.UI_SETPASSWORD, 1) -- 打开初始设定密码界面
    else
      UiManager:OpenWindow(Ui.UI_SETPASSWORD, 0) -- 打开修改密码界面
    end
  end

  if szWndName == self.BTN_ACCOUNT_LOCK_DISCHARGE then
    local tbMsg = {}
    if Player.bApplyingJiesuo == 1 then -- 取消自助解锁申请
      tbMsg.szMsg = "您确定保留账户锁吗？选择”确定“，账户锁将继续保护您的帐号安全。"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "AccountCmd", Account.JIESUO_CANCEL })
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
    else
      tbMsg.szMsg = "您确定申请取消密码保护？申请将在5天后生效。"
      tbMsg.nOptCount = 2
      function tbMsg:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "AccountCmd", Account.JIESUO_APPLY })
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
    end
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_CARD_MISS then
    OpenWebSite(self.SZ_CARD_MISS_URL)
  end

  if szWndName == self.BTN_CARD_CHANGE then
    OpenWebSite(self.SZ_CARD_CHANGE_URL)
  end

  if szWndName == self.BTN_CARD_DISCHARGE then
    OpenWebSite(self.SZ_CARD_DISCHARGE_URL)
  end

  if szWndName == self.BTN_LINGPAI_MISS then
    OpenWebSite(self.SZ_LINGPAI_MISS_URL)
  end

  if szWndName == self.BTN_LINGPAI_DISCHARGE then
    OpenWebSite(self.SZ_LINGPAI_DISCHARGE_URL)
  end

  if szWndName == self.BTN_KSPHONELOCK_DISCHARGE then
    OpenWebSite(self.SZ_KSPHONELOCK_DISCHARGE_URL)
  end

  if szWndName == self.BTN_MIBAO_LINK then
    OpenWebSite(self.SZ_MIBAO_URL)
  end

  if szWndName == self.BTN_TW_PHONE_LOCK_PROTECT then
    -- 调用打开手机锁的通知接口
    me.CallServerScript({ "AccountCmd", Account.UNLOCK_PHONELOCK })
    -- 开始倒计时
    Wnd_SetEnable(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PROTECT, 0)
    self.nOpenTWPhoneLockLeftTime = 60
    self.nTWPhoneLockTimer = Timer:Register(18, self.ShowOpenTWPhoneLockTime, self)
  end

  if szWndName == self.BTN_CLOSE or szWndName == self.BTN_ACCOUNT_LOCK_CANCEL or szWndName == self.BTN_LINGPAI_CANCEL or szWndName == self.BTN_CARD_CANCEL or szWndName == self.BTN_MIBAO_CANCEL or szWndName == self.BTN_TW_PHONE_LOCK_CANCEL or szWndName == self.BTN_VICE_PASSWORD_CANCEL then
    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_KSPHONELOCK_CANCEL then
    if self.bKsPhoneLock == 0 then
      self:CloseTimerTip(1)
    end
    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    UiManager:CloseWindow(self.UIGROUP)
  end

  if szWndName == self.BTN_VICE_PASSWORD_OK then
    UiManager:CloseWindow(self.UIGROUP)
    UiManager:OpenWindow(Ui.UI_SETVICEPASSWORD)
  end
end

function UiLockAccount:ShowOpenTWPhoneLockTime()
  self.nOpenTWPhoneLockLeftTime = self.nOpenTWPhoneLockLeftTime - 1
  if self.nOpenTWPhoneLockLeftTime > 0 then
    Txt_SetTxt(self.UIGROUP, self.TEXT_TW_PHONE_LOCK_GUIDE, self.SZ_TW_PHONE_LOCK_HOLDING .. "\n<color=yellow>拨号开锁剩余时间：<color><color=green>" .. self.nOpenTWPhoneLockLeftTime .. "秒<color>")
  else
    Txt_SetTxt(self.UIGROUP, self.TEXT_TW_PHONE_LOCK_GUIDE, self.SZ_TW_PHONE_LOCK_GUIDE)
    self.nTWPhoneLockTimer = nil
    Wnd_SetEnable(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PROTECT, 1)
    return 0
  end
end

function UiLockAccount:OnEditFocus(szWndName)
  if szWndName == self.EDT_ACCOUNT_LOCK_PWD then
    self:ShowMiniKeyBoard()
  end
end

function UiLockAccount:UpdateCardPositionText()
  local tbMatrixKey = self:ParseMatrix(me.GetMatrixPosition())
  if tbMatrixKey then
    local szTxt1 = "第 <color=yellow>" .. tbMatrixKey[1] .. "<color> 行、第 <color=yellow>" .. tbMatrixKey[2] .. "<color> 列的数字是："
    local szTxt2 = "第 <color=yellow>" .. tbMatrixKey[3] .. "<color> 行、第 <color=yellow>" .. tbMatrixKey[4] .. "<color> 列的数字是："
    local szTxt3 = "第 <color=yellow>" .. tbMatrixKey[5] .. "<color> 行、第 <color=yellow>" .. tbMatrixKey[6] .. "<color> 列的数字是："

    Txt_SetTxt(self.UIGROUP, self.TEXT_CARD_NUM1, szTxt1)
    Txt_SetTxt(self.UIGROUP, self.TEXT_CARD_NUM2, szTxt2)
    Txt_SetTxt(self.UIGROUP, self.TEXT_CARD_NUM3, szTxt3)
  end
end

function UiLockAccount:ParseMatrix(szMatrix)
  local tbKeys = {}
  for i = 1, string.len(szMatrix) do
    tbKeys[i] = string.sub(szMatrix, i, i)
  end
  if #tbKeys > 0 then
    return tbKeys
  else
    return nil
  end
end

function UiLockAccount:UpdateProtect()
  if me.IsAccountLock() == 1 then
    self.bProtected = 1
  else
    self.bProtected = 0
  end

  if me.IsAccountLockOpen() == 1 and me.GetPasspodMode() == 0 then
    self.bAccountLock = 1
  else
    self.bAccountLock = 0
  end

  if me.IsAccountLockOpen() == 1 and me.GetPasspodMode() == Account.PASSPODMODE_ZPTOKEN then
    self.bSafeKey = 1
  else
    self.bSafeKey = 0
  end

  -- 手机令牌
  if me.IsAccountLockOpen() == 1 and me.GetPasspodMode() == Account.PASSPODMODE_KSPHONELOCK then
    self.bKsPhoneLock = 1
  else
    self.bKsPhoneLock = 0
  end

  if me.IsAccountLockOpen() == 1 and me.GetPasspodMode() == Account.PASSPODMODE_ZPMATRIX then
    self.bSafeCard = 1
  else
    self.bSafeCard = 0
  end

  -- 台湾的手机锁和账号锁是并列的，不互斥
  if IVER_g_bHasPhoneLock == 1 then
    self.bTWPhoneLock = 1
  else
    self.bTWPhoneLock = 0
  end
  self:Update()
end

function UiLockAccount:Update()
  -- 金山密保卡
  if self.bSafeCard == 1 and self.bProtected == 1 then
    self:UpdateCardPositionText()
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_CARD_NOTE, self.SZ_CARD_NOTE .. self.FOBBIDEN_NOTE .. self.SZ_CARD_OPERATION_NOTE)
    self:ShowCardPswLogin(1)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_CARD_GUIDE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_DISCHARGE, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_CHANGE, 1)
    Wnd_Hide(self.UIGROUP, self.BTN_CARD_MISS)
    Btn_SetTxt(self.UIGROUP, self.BTN_CARD_PROTECT, "解除锁定")
  elseif self.bSafeCard == 1 and self.bProtected == 0 then
    self:ShowCardPswLogin(0)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_CARD_GUIDE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_DISCHARGE, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_CHANGE, 1)
    Wnd_Hide(self.UIGROUP, self.BTN_CARD_MISS)
    Btn_SetTxt(self.UIGROUP, self.BTN_CARD_PROTECT, "解除锁定")
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_CARD_NOTE, self.SZ_CARD_NOTE .. self.SZ_UNLOCK_NOTE)
  else
    self:ShowCardPswLogin(0)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_CARD_GUIDE, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_DISCHARGE, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_CARD_CHANGE, 0)
    Wnd_Hide(self.UIGROUP, self.BTN_CARD_MISS)
    Btn_SetTxt(self.UIGROUP, self.BTN_CARD_PROTECT, "开启保护")
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_CARD_NOTE, self.SZ_DISPROTECT_CARD_NOTE)
  end

  -- 金山令牌
  if self.bSafeKey == 1 and self.bProtected == 1 then
    Btn_SetTxt(self.UIGROUP, self.BTN_KSPHONELOCK_PROTECT, "解除锁定")
    if Ui.tbLogic.tbPassPodTime:GetLeaveTime() > 0 then
      TxtEx_SetText(self.UIGROUP, self.TEXTEX_LINGPAI_NOTE, self.SZ_LINGPAI_NOTE .. self.FOBBIDEN_NOTE .. self.SZ_LINGPAI_OPERATION_NOTE .. "\n<color=yellow>当前剩余等待时间：<color><color=green>" .. Ui.tbLogic.tbPassPodTime:GetLeaveTime() .. "分钟。<color>")
      Wnd_SetVisible(self.UIGROUP, self.TEXT_LINGPAI_GUIDE, 0)
    else
      TxtEx_SetText(self.UIGROUP, self.TEXTEX_LINGPAI_NOTE, self.SZ_LINGPAI_NOTE .. self.FOBBIDEN_NOTE .. "<color=yellow>请输入金山令牌上的动态密码进行解锁。<color>")
      self:ShowLingPaiPswLogin(1)
      Wnd_SetVisible(self.UIGROUP, self.TEXT_LINGPAI_GUIDE, 0)
    end
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_MISS, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_DISCHARGE, 1)
  elseif self.bSafeKey == 1 and self.bProtected == 0 then
    self:ShowLingPaiPswLogin(0)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_LINGPAI_GUIDE, 0)
    Btn_SetTxt(self.UIGROUP, self.BTN_LINGPAI_PROTECT, "解除锁定")
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_MISS, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_DISCHARGE, 1)
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_LINGPAI_NOTE, self.SZ_LINGPAI_NOTE .. self.SZ_UNLOCK_NOTE)
  else
    self:ShowLingPaiPswLogin(0)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_LINGPAI_GUIDE, 1)
    Btn_SetTxt(self.UIGROUP, self.BTN_LINGPAI_PROTECT, "开启保护")
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_MISS, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_LINGPAI_DISCHARGE, 0)
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_LINGPAI_NOTE, self.SZ_DISPROTECT_LINGPAI_NOTE)
  end

  -- 安全锁
  if self.bAccountLock == 1 and (self.bProtected == 0 or me.GetAccountLockState() == 0) then
    self:ShowAccountLockPswLogin(0)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_ACCOUNT_LOCK_GUIDE, 0)
    Btn_SetTxt(self.UIGROUP, self.BTN_ACCOUNT_LOCK_PROTECT, "解除锁定")
    Wnd_SetVisible(self.UIGROUP, self.BTN_SETPASSWORD, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_ACCOUNT_LOCK_DISCHARGE, 1)
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_ACCOUNT_LOCK_NOTE, self.SZ_ACCOUNT_LOCK_NOTE .. self.SZ_UNLOCK_NOTE)
  elseif self.bAccountLock == 1 and self.bProtected == 1 then
    self:ShowAccountLockPswLogin(1)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_ACCOUNT_LOCK_GUIDE, 0)
    Btn_SetTxt(self.UIGROUP, self.BTN_ACCOUNT_LOCK_PROTECT, "解除锁定")
    Wnd_SetVisible(self.UIGROUP, self.BTN_SETPASSWORD, 1)
    Wnd_SetVisible(self.UIGROUP, self.BTN_ACCOUNT_LOCK_DISCHARGE, 1)
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_ACCOUNT_LOCK_NOTE, self.SZ_ACCOUNT_LOCK_NOTE .. self.FOBBIDEN_NOTE .. self.SZ_ACCOUNT_LOCK_OPERATION_NOTE)
  else
    self:ShowAccountLockPswLogin(0)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_ACCOUNT_LOCK_GUIDE, 1)
    Btn_SetTxt(self.UIGROUP, self.BTN_ACCOUNT_LOCK_PROTECT, "开启保护")
    Wnd_SetVisible(self.UIGROUP, self.BTN_SETPASSWORD, 0)
    Wnd_SetVisible(self.UIGROUP, self.BTN_ACCOUNT_LOCK_DISCHARGE, 0)
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_ACCOUNT_LOCK_NOTE, self.SZ_DISPROTECT_NOTE_ACCOUNT_LOCK)
  end

  -- 手机令牌
  if self.bKsPhoneLock == 1 and self.bProtected == 1 then
    Btn_SetTxt(self.UIGROUP, self.BTN_LINGPAI_PROTECT, "解除锁定")
    Btn_SetTxt(self.UIGROUP, self.BTN_KSPHONELOCK_CANCEL, "关闭")
    if Ui.tbLogic.tbPassPodTime:GetLeaveTime() > 0 then
      TxtEx_SetText(self.UIGROUP, self.TEXTEX_KSPHONELOCK_NOTE, self.SZ_KSPHONELOCK_NOTE .. self.FOBBIDEN_NOTE .. self.SZ_KSPHONELOCK_OPERATION_NOTE .. "\n<color=yellow>当前剩余等待时间：<color><color=green>" .. Ui.tbLogic.tbPassPodTime:GetLeaveTime() .. "分钟。<color>")
      Wnd_SetVisible(self.UIGROUP, self.TEXT_KSPHONELOCK_GUIDE, 0)
    else
      TxtEx_SetText(self.UIGROUP, self.TEXTEX_KSPHONELOCK_NOTE, self.SZ_KSPHONELOCK_NOTE .. self.FOBBIDEN_NOTE .. "<color=yellow>请输入金山手机令牌上的动态密码进行解锁。<color>")
      self:ShowKsPhoneLockPswLogin(1)
      Wnd_SetVisible(self.UIGROUP, self.TEXT_KSPHONELOCK_GUIDE, 0)
    end
    Wnd_SetVisible(self.UIGROUP, self.BTN_KSPHONELOCK_DISCHARGE, 1)
  elseif self.bKsPhoneLock == 1 and self.bProtected == 0 then
    self:ShowKsPhoneLockPswLogin(0)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_KSPHONELOCK_GUIDE, 0)
    Btn_SetTxt(self.UIGROUP, self.BTN_KSPHONELOCK_PROTECT, "解除锁定")
    Btn_SetTxt(self.UIGROUP, self.BTN_KSPHONELOCK_CANCEL, "关闭")
    Wnd_SetVisible(self.UIGROUP, self.BTN_KSPHONELOCK_DISCHARGE, 1)
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_KSPHONELOCK_NOTE, self.SZ_KSPHONELOCK_NOTE .. self.SZ_UNLOCK_NOTE)
  else
    self:ShowKsPhoneLockPswLogin(0)
    Wnd_SetVisible(self.UIGROUP, self.TEXT_KSPHONELOCK_GUIDE, 1)
    Btn_SetTxt(self.UIGROUP, self.BTN_KSPHONELOCK_PROTECT, "开启保护")
    Btn_SetTxt(self.UIGROUP, self.BTN_KSPHONELOCK_CANCEL, "我不想绑定")
    Wnd_SetVisible(self.UIGROUP, self.BTN_KSPHONELOCK_DISCHARGE, 0)
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_KSPHONELOCK_NOTE, self.SZ_DISPROTECT_KSPHONELOCK_NOTE)
  end

  -- 金山密保软件
  TxtEx_SetText(self.UIGROUP, self.TEXTEX_MIBAO_NOTE, self.SZ_MIBAO_NOTE)

  -- 台湾手机锁
  TxtEx_SetText(self.UIGROUP, self.TEXTEX_TW_PHONE_LOCK_NOTE, self.SZ_TW_PHONE_LOCK_NOTE)
  if self.bTWPhoneLock == 1 and (self.bProtected == 0 or me.GetPhoneLockState() == 0) then
    Txt_SetTxt(self.UIGROUP, self.TEXT_TW_PHONE_LOCK_GUIDE, self.SZ_TW_PHONE_UNLOCK_GUIDE)
    Wnd_SetVisible(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PROTECT, 0)
    if self.nTWPhoneLockTimer then
      self.nOpenTWPhoneLockLeftTime = 0
      Timer:Close(self.nTWPhoneLockTimer)
      self.nTWPhoneLockTimer = nil
    end
  elseif self.bTWPhoneLock == 1 and self.bProtected == 1 then
    Txt_SetTxt(self.UIGROUP, self.TEXT_TW_PHONE_LOCK_GUIDE, self.SZ_TW_PHONE_LOCK_GUIDE)
    Wnd_SetVisible(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PROTECT, 1)
  else
    Txt_SetTxt(self.UIGROUP, self.TEXT_TW_PHONE_LOCK_GUIDE, self.SZ_NO_TW_PHONE_LOCK_GUIDE)
  end
  if self.nTWPhoneLockTimer == nil then
    Wnd_SetEnable(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PROTECT, 1)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PROTECT, 0)
  end

  local bIsLoginUseVicePassword = IsLoginUseVicePassword()
  if bIsLoginUseVicePassword == 0 then
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_VICE_PASSWORD_NOTE, self.VICE_PASSWORD_NOTE)
    Wnd_SetEnable(self.UIGROUP, self.BTN_VICE_PASSWORD_OK, 1)
  else
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_VICE_PASSWORD_NOTE, self.VICE_PASSWORD_NOTE .. "<enter><enter><color=red>现在是副密码登录状态，不能修改副密码。")
    Wnd_SetEnable(self.UIGROUP, self.BTN_VICE_PASSWORD_OK, 0)
  end
end

function UiLockAccount:SafeCardLogin()
  local tbKey = {}
  tbKey[1] = Edt_GetTxt(self.UIGROUP, self.EDT_CARD_NUM1)
  tbKey[2] = Edt_GetTxt(self.UIGROUP, self.EDT_CARD_NUM2)
  tbKey[3] = Edt_GetTxt(self.UIGROUP, self.EDT_CARD_NUM3)
  if not tbKey[1] or not tbKey[2] or not tbKey[3] or tbKey[1] == "" or tbKey[2] == "" or tbKey[3] == "" then
    me.Msg("密保卡指定数字还没填完！")
    return
  end
  local szPsw = tbKey[1] .. tbKey[2] .. tbKey[3]
  me.CallServerScript({ "AccountCmd", Account.UNLOCK_BYPASSPOD, szPsw })
end

function UiLockAccount:SafeKeyLogin()
  local szPass = Edt_GetTxt(self.UIGROUP, self.EDT_LINGPAI_PWD)
  if string.len(szPass) < 6 then
    me.Msg("令牌密码至少6位。")
    return 0
  end
  me.CallServerScript({ "AccountCmd", Account.UNLOCK_BYPASSPOD, szPass })
end

function UiLockAccount:KsPhoneLockLogin()
  local szPass = Edt_GetTxt(self.UIGROUP, self.EDT_KSPHONELOCK_PWD)
  if string.len(szPass) < 6 then
    me.Msg("手机令牌密码至少6位。")
    return 0
  end
  me.CallServerScript({ "AccountCmd", Account.UNLOCK_BYPASSPOD, szPass })
end

function UiLockAccount:SafeAccountLockLogin()
  local bRightPwd = self:CheckPwd()
  if bRightPwd == 1 then
    local nPsw = self:EncryptPsw()
    local nDivValue = nPsw / self.nr3
    if math.abs(nDivValue * self.nr3 - nPsw) < 1 then
      me.CallServerScript({ "AccountCmd", Account.UNLOCK, nDivValue, self.nr3 })
    end
    UiManager:CloseWindow(Ui.UI_MINIKEYBOARD)
    self.nPwd = 1
    self.nPos = 100000
    self:UpdatePwdShow()
    return
  end
  self.nPwd = 1
  self.nPos = 100000
  self:UpdatePwdShow()
end

function UiLockAccount:KeyProc(szKey)
  self:ProcessPwd(szKey)
  self:UpdatePwdShow()
end

function UiLockAccount:ProcessPwd(nKey)
  --local nKey = self.tbChar2Num[szKey];
  if UiManager:WindowVisible(self.UIGROUP) ~= 1 then
    return
  end
  if not nKey then
    return
  end
  if nKey == 0 and self.nPwd == 1 and me.GetPasspodMode() == 0 then
    me.Msg("密码不能以0开头！")
    return
  end
  if nKey ~= -1 then
    if self.nPwd >= 1000000 or self.nPos < 1 then
      return
    end
    local nNameId = KLib.String2Id(tostring(me.GetNpc().dwId))
    self.nPwd = self.nPwd * 10 + (nKey + math.floor(nNameId / self.nPos) % 10) % 10
    self.nPos = self.nPos / 10
  elseif self.nPwd >= 10 then
    self.nPwd = math.floor(self.nPwd / 10)
    self.nPos = self.nPos * 10
  end
end

function UiLockAccount:UpdatePwdShow()
  local szPwdStar = self:BuildStarByCount(math.ceil(math.log10(1 + self.nPwd)) - 1)
  Edt_SetTxt(self.UIGROUP, self.EDT_ACCOUNT_LOCK_PWD, szPwdStar)
end

function UiLockAccount:CheckPwd()
  if self.nPwd < 1000000 or self.nPwd > 1999999 then
    me.Msg("密码必须是6位！")
    return 0
  end
  return 1
end

function UiLockAccount:EncryptPsw()
  return (self.nPwd % 1000000) * 64 + 32 + self.nr2 * 67108864
end

function UiLockAccount:ShowMiniKeyBoard()
  self.nr1 = MathRandom(63)
  self.nr2 = MathRandom(63)
  self.nr3 = MathRandom(65535) / 65536
  UiManager:OpenWindow(Ui.UI_MINIKEYBOARD)
  local x, y = Wnd_GetPos(Ui.UI_MINIKEYBOARD, "Main")
  y = MathRandom(10) * 30
  Wnd_SetPos(Ui.UI_MINIKEYBOARD, "Main", x, y)
end

function UiLockAccount:BuildStarByCount(nCount)
  local szStar = ""
  if nCount > 0 then
    for i = 1, nCount do
      szStar = szStar .. "*"
    end
  end
  return szStar
end

function UiLockAccount:ShowAccountLockPswLogin(bShow)
  Wnd_SetVisible(self.UIGROUP, self.TEXTEX_ACCOUNT_LOCK_PSW, bShow)
  Wnd_SetVisible(self.UIGROUP, self.EDT_ACCOUNT_LOCK_PWD, bShow)
  Wnd_SetVisible(self.UIGROUP, self.IMG_ACCOUNT_LOCK_PWD, bShow)
end

function UiLockAccount:ShowLingPaiPswLogin(bShow)
  Wnd_SetVisible(self.UIGROUP, self.TEXTEX_LINGPAI_PSW, bShow)
  Wnd_SetVisible(self.UIGROUP, self.EDT_LINGPAI_PWD, bShow)
  Wnd_SetVisible(self.UIGROUP, self.IMG_LINGPAI_PWD, bShow)
end

function UiLockAccount:ShowKsPhoneLockPswLogin(bShow)
  Wnd_SetVisible(self.UIGROUP, self.TEXTEX_KSPHONELOCK_PSW, bShow)
  Wnd_SetVisible(self.UIGROUP, self.EDT_KSPHONELOCK_PWD, bShow)
  Wnd_SetVisible(self.UIGROUP, self.IMG_KSPHONELOCK_PWD, bShow)
end

function UiLockAccount:ShowCardPswLogin(bShow)
  Wnd_SetVisible(self.UIGROUP, self.TEXT_CARD_NUM1, bShow)
  Wnd_SetVisible(self.UIGROUP, self.TEXT_CARD_NUM2, bShow)
  Wnd_SetVisible(self.UIGROUP, self.TEXT_CARD_NUM3, bShow)
  Wnd_SetVisible(self.UIGROUP, self.EDT_CARD_NUM1, bShow)
  Wnd_SetVisible(self.UIGROUP, self.IMG_CARD_NUM1, bShow)
  Wnd_SetVisible(self.UIGROUP, self.EDT_CARD_NUM2, bShow)
  Wnd_SetVisible(self.UIGROUP, self.IMG_CARD_NUM2, bShow)
  Wnd_SetVisible(self.UIGROUP, self.EDT_CARD_NUM3, bShow)
  Wnd_SetVisible(self.UIGROUP, self.IMG_CARD_NUM3, bShow)
  Wnd_Hide(self.UIGROUP, self.BTN_CARD_MISS)
end

function UiLockAccount:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_LOCK, self.UpdateProtect },
    { UiNotify.emUIEVENT_PASSPODTIME_REFRESH, self.Update },
    { UiNotify.emUIEVENT_MINIKEY_SEND, self.KeyProc },
  }
  return tbRegEvent
end

function UiLockAccount:UpdateErrorMsg(szErrorMsg)
  -- 金山密保卡
  if self.bSafeCard == 1 and self.bProtected == 1 then
    self:UpdateCardPositionText()
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_CARD_NOTE, self.SZ_CARD_NOTE .. "<color=red>" .. szErrorMsg .. "<color>")
  end

  -- 金山令牌
  if self.bSafeKey == 1 and self.bProtected == 1 then
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_LINGPAI_NOTE, self.SZ_LINGPAI_NOTE .. "<color=red>" .. szErrorMsg .. "<color>")
  end

  -- 金山手机令牌
  if self.bKsPhoneLock == 1 and self.bProtected == 1 then
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_LINGPAI_NOTE, self.SZ_KSPHONELOCK_NOTE .. "<color=red>" .. szErrorMsg .. "<color>")
  end

  -- 安全锁
  if self.bAccountLock == 1 and self.bProtected == 1 then
    TxtEx_SetText(self.UIGROUP, self.TEXTEX_ACCOUNT_LOCK_NOTE, self.SZ_ACCOUNT_LOCK_NOTE .. "<color=red>" .. szErrorMsg .. "<color>")
  end

  -- 台湾手机锁
  if self.bTWPhoneLock == 1 and self.bProtected == 1 then
    Txt_SetTxt(self.UIGROUP, self.TEXT_TW_PHONE_LOCK_GUIDE, self.SZ_ACCOUNT_LOCK_NOTE .. "<color=red>" .. szErrorMsg .. "<color>")
  end
end

function UiLockAccount:PhoneLockResult(nRet)
  if self.bTWPhoneLock == 1 then
    -- 关计时器
    if self.nTWPhoneLockTimer then
      self.nOpenTWPhoneLockLeftTime = 0
      Timer:Close(self.nTWPhoneLockTimer)
      self.nTWPhoneLockTimer = nil
    end
    -- 如果不成功则恢复申请解锁的按纽
    if nRet ~= 1 then
      Wnd_SetEnable(self.UIGROUP, self.BTN_TW_PHONE_LOCK_PROTECT, 1)
    end
    if Account.PHONE_UNLOCK_RESULT[nRet] then
      TxtEx_SetText(self.UIGROUP, self.TEXTEX_TW_PHONE_LOCK_NOTE, Account.PHONE_UNLOCK_RESULT[nRet])
      me.Msg(Account.PHONE_UNLOCK_RESULT[nRet])
    end
  end
end

function UiLockAccount:InitVicePassWord()
  for nType, tbInfo in ipairs(Account.tbAccount2LockDef_Tsk_Id) do
    if me.GetTask(Account.nAccount2LockDef_Tsk_Group, tbInfo[1]) == 0 then
      Btn_Check(self.UIGROUP, self.BTN_VICE_LIMTT .. nType, 1)
    else
      Btn_Check(self.UIGROUP, self.BTN_VICE_LIMTT .. nType, 0)
    end
  end
end

function UiLockAccount:SaveVicePassWord()
  --保存
  local tbLimit = {}
  for nType, tbInfo in ipairs(Account.tbAccount2LockDef_Tsk_Id) do
    tbLimit[nType] = Btn_GetCheck(self.UIGROUP, self.BTN_VICE_LIMTT .. nType) or 0
  end
  me.CallServerScript({ "AccountViceSaveLimit", tbLimit })
end

function UiLockAccount:CloseTimerTip(bFlag)
  if self.nShowTipTimerId > 0 and Timer:GetRestTime(self.nShowTipTimerId) > 0 then
    Timer:Close(self.nShowTipTimerId)
  end
  if bFlag then
    me.SetTask(2216, 41, tonumber(GetLocalDate("%Y%m%d")))
  end
  if UiVersion == Ui.Version002 then
    Img_StopAnimation("UI_SIDESYSBAR", "BtnLock")
  else
    Img_StopAnimation("UI_PLAYERSTATE", "BtnLock")
  end
end

--进入游戏后开始提示
function UiLockAccount:StartOpenTimer4Tip(bFlag)
  local nStartDate = me.GetTask(2216, 40)
  local nNowDate = tonumber(GetLocalDate("%Y%m%d"))
  if nStartDate <= 0 then
    me.SetTask(2216, 40, nNowDate)
    return
  end
  local nDayCount = math.floor((Lib:GetDate2Time(nNowDate) - Lib:GetDate2Time(nStartDate)) / 24 / 3600)
  if nDayCount > self.nShowTipMaxDayCount then
    return 0
  end
  if me.IsAccountLockOpen() == 0 or me.GetPasspodMode() ~= Account.PASSPODMODE_KSPHONELOCK then
    local nCloseDate = me.GetTask(2216, 41)
    if not bFlag and nCloseDate ~= nNowDate then
      self.nShowTipTimerId = Timer:Register(self.nTimeShowTip, self.StartOpenTimer4Tip, self, 1)
      if UiVersion == Ui.Version002 then
        Img_PlayAnimation("UI_SIDESYSBAR", "BtnLock", 1, 250, 0, -1)
      else
        Img_PlayAnimation("UI_PLAYERSTATE", "BtnLock", 1, 250, 0, -1)
      end
      return 0
    end
  else
    if UiVersion == Ui.Version002 then
      Img_StopAnimation("UI_SIDESYSBAR", "BtnLock")
    else
      Img_StopAnimation("UI_PLAYERSTATE", "BtnLock")
    end
    return 0
  end
  if UiVersion == Ui.Version002 then
    Ui.tbLogic.tbPopMgr:ShowWndPopTip("UI_SIDESYSBAR", "BtnLock", "亲，您的账号可能存在安全隐患哟...", 1, 360)
  else
    Ui.tbLogic.tbPopMgr:ShowWndPopTip("UI_PLAYERSTATE", "BtnLock", "亲，您的账号可能存在安全隐患哟...", 4, 360)
  end
  return
end
