Require("\\ui\\script\\logic\\logindef.lua")
local tbLogin = Ui.tbLogic.tbLogin or {}
Ui.tbLogic.tbLogin = tbLogin
local tbTimer = Ui.tbLogic.tbTimer
local TIMER_TICK = Env.GAME_FPS -- 定时器最小单位，1秒

tbLogin.tbLimitLogin_YY = {
  { "北斗区", "百晓楼" },
  { "如意区", "征战江湖" },
  { "吉祥区", "龙魂聚" },
  { "朱雀区", "西风烈" },
  { "紫薇区", "西域龙魂" },
}
tbLogin.tbPreCreateServer = nil --预约新服表
tbLogin.nUpdateDate = 0 --更新记录时间

function tbLogin:Init()
  self.nAutoReloginTimerId = 0

  self.nLoginWay = self.LOGINWAY_KS -- 登录方式，默认KS
end

function tbLogin:IsPreCreateServer()
  local szSelServer = GetLastSvrTitle()
  --初始化或5分钟更新一次
  if not self.tbPreCreateServer or GetTime() >= (self.nUpdateDate + 300) then
    self.nUpdateDate = GetTime()
    local _, tbRealRegion = GetServerList(2)
    self.tbPreCreateServer = {}
    for _, tbInfoList in pairs(tbRealRegion or {}) do
      for _, tbInfo in pairs(tbInfoList) do
        if KLib.BitOperate(tbInfo.ServerType, "&", 1) == 1 then
          self.tbPreCreateServer[tbInfo.Title] = 1
        end
      end
    end
  end
  if self.tbPreCreateServer[szSelServer] then
    return 1
  end
  return 0
end

function tbLogin:OnEvent(nEventId, nP1, nP2, nP3)
  if nEventId == self.emKOBJEVENTTYPE_STATUS_CHANGE then
    if self:LimitLogin(nP1, nP2) == 0 then
      return
    end
    self:OnStatuChange(nP1, nP2)
  elseif nEventId == self.emKOBJEVENTTYPE_LOGIN_CONNECT then -- 链接到网关结果
    --print("连接到bishop结果：", nP1);
    if self.nLoginWay == self.LOGINWAY_YY then
      if nP1 == 1 then -- 连接网关成功
        local nRet = YY_Login()
        if nRet == 0 then
          local tbMsg = { szMsg = "登录失败：未知原因", tbOptTitle = { "确定" }, Callback = self.OnGameIdle, CallbackSelf = self }
          UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
          return
        end
      elseif nP1 == 0 then
        local tbMsg = { szMsg = "服务器登录繁忙或正在维护，请稍候再试。", tbOptTitle = { "返回" }, Callback = self.OnGameIdle, CallbackSelf = self }
        UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
        return
      end
    else
      if nP1 == 1 then -- 自动流程不进入这里，会导致ui流程混乱
        print("should not be here!")
        return
      elseif nP1 == 0 then
        self.nAutoReloginTimerId = tbTimer:Register(TIMER_TICK * 10, self.AutoRelogin, self)
        local tbMsg = {
          szMsg = "服务器登录繁忙或正在维护，系统将自动为您重新连接服务器....",
          tbOptTitle = { "返回" },
          Callback = self.OnCancelAutoRelogin,
          CallbackSelf = self,
        }
        UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
        return
      end
    end
  elseif nEventId == self.emKOBJEVENTTYPE_LOGIN_RESULT then -- 登录结果
    if nP1 == 1 then -- 登录成功
      local tbMsg = { szMsg = "正在获取角色列表...", Callback = self.CancelConnectBishop, CallbackSelf = self }
      UiManager:OpenWindow(Ui.UI_LOGINBG, 3)
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    elseif nP1 == 33 then -- 补填防沉迷信息
      local tbMsg = { szMsg = "您需要补填防沉迷信息才能继续游戏", tbOptTitle = { "确定" }, Callback = self.LimitEmpty, CallbackSelf = self }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    elseif nP1 == 10 then -- 协议不正确
      --local tbMsg = { szMsg = "您的版本与当前服务器不符，是否使用自动更新程序切换版本？", tbOptTitle={"确定", "取消"}, nOptCount=2, Callback=self.OnSelUpdate, CallbackSelf=self};
      --UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg, nP2);
      return self:OnSelUpdate(1, nP2)
    elseif nP1 == 3 then
      local tbMsg = {
        szMsg = "登录失败：" .. self.tbLoginErrorMsg[nP1] or "服务器忙",
        tbOptTitle = { "确定", "账号自助冻结" },
        nOptCount = 2,
        Callback = self.OnSelFreeze,
        CallbackSelf = self,
      }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    elseif nP1 == 11 then
      local tbMsg = {
        szMsg = "登录失败：" .. self.tbLoginErrorMsg[nP1] or "服务器忙",
        tbOptTitle = { "确定", "自助解冻" },
        nOptCount = 2,
        Callback = self.OnSelUnFreeze,
        CallbackSelf = self,
      }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    elseif nP1 == 4 then
      local tbMsg = {
        szMsg = "登录失败：" .. self.tbLoginErrorMsg[nP1] or "服务器忙",
        tbOptTitle = { "确定", "自助踢号" },
        nOptCount = 2,
        Callback = self.OnKickFreeze,
        CallbackSelf = self,
      }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    elseif nP1 == 34 then -- 帐号需要激活
      if self.nLoginWay == self.LOGINWAY_YY then -- 登录流程太多潜规则，只好放这里判断
        local tbMsg = { szMsg = "本服务器未开放yy通行证登录游戏", tbOptTitle = { "确定" }, Callback = self.CancelConnectBishop, CallbackSelf = self }
        UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
        return
      end
      local tbMsg = { szMsg = "您需要激活帐号才能登录游戏", tbOptTitle = { "确定" }, Callback = self.ActiveCode, CallbackSelf = self }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    else
      local tbMsg = { szMsg = "登录失败：" .. self.tbLoginErrorMsg[nP1] or "服务器忙", tbOptTitle = { "确定" }, Callback = self.OnGameIdle, CallbackSelf = self }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    end
  elseif nEventId == self.emKOBJEVENTTYPE_CREATE_ROLE_RESULT then
    if nP1 == 1 then
    else
      local tbMsg = { szMsg = self.tbCreateRoleErrorMsg[nP2] or "未知错误", tbOptTitle = { "确定" }, Callback = self.InvalidName, self }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end
  elseif nEventId == self.emKOBJEVENTTYPE_LOGIN_DISCONNECT then -- 与bishop断开连接
    if nP1 == 0 then -- 被动断开，需要提示与服务器断开连接
      local tbMsg = { szMsg = "与服务器断开连接", tbOptTitle = { "确定" }, Callback = self.OnGameIdle, CallbackSelf = self }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end
  elseif nEventId == self.emKOBJEVENTTYPE_YY_BIND then -- yy帐号绑定
    --print("要求绑定yy帐号");
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    local bRet = YY_BindAccount(1) -- 这里不会让玩家绑定，直接帮助玩家创建帐号了，如果以后有需要，可以制作绑定界面
    if bRet == 0 then
      local tbMsg = { szMsg = "验证失败：未知错误", tbOptTitle = { "确定" } }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    else
      local tbMsg = { szMsg = "正在创建帐号数据...", nOptCount = 0 }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end
  elseif nEventId == self.emKOBJEVENTTYPE_YY_LOGIN then -- yy登录
    local uiWnd = Ui(Ui.UI_ACCOUNT_LOGIN)
    if not uiWnd then
      return
    end
    uiWnd:YyBeginLogin()
  else
    --print("为啥不对",  self.emKOBJEVENTTYPE_STATUS_CHANGE, nEventId, nP1, nP2, nP3);
  end
  --UiManager:OpenWindow("UI_TEST_FLASH");
end

-- 游戏初始化完毕，开始显示登录框
function tbLogin:OnGameIdle()
  -- todo 需要关闭角色选择/创建角色/服务器列表等窗口
  UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
  UiManager:CloseWindow(Ui.UI_SELANDNEW_ROLE)
  UiManager:CloseWindow(Ui.UI_LIMITPLAY)
  UiManager:CloseWindow(Ui.UI_SELANDNEW_ROLE)
  local bNeedAgree = 0
  if IVER_g_nTwVersion == 1 then
    bNeedAgree = UiManager.bAgreementFlag or 0
  end
  local bAgree = Ui.tbLogic.tbAgreementMgr:IsAgree()
  if bAgree == 0 then -- 需要同意协议才能继续
    SetLoginStatus(self.emLOGINSTATUS_AGREE)
  else
    UiManager:OpenWindow(Ui.UI_LOGINBG, 3)
    if SINA_CLIENT then
      if IsHaveThirdAccountAndPsw() == 0 then
        OpenSinaLoginWindow()
        Exit()
        return 0
      end
      local szSvrTitle = GetLastSvrTitle() -- 如果没有字符串怎么办，弹出选择框
      if not szSvrTitle or szSvrTitle == "" then
        UiManager:OpenWindow(Ui.UI_SELECT_SERVER, 0)
      else
        local nStart, nEnd = string.find(szSvrTitle, "新开")
        if nStart and nStart > 0 then
          szSvrTitle = string.sub(szSvrTitle, 1, nStart - 1)
        end
        local nStart, nEnd = string.find(szSvrTitle, "推荐")
        if nStart and nStart > 0 then
          szSvrTitle = string.sub(szSvrTitle, 1, nStart - 1)
        end

        bRet = AccountLoginSecret(szSvrTitle)
      end
      return
    end
    UiManager:OpenWindow(Ui.UI_ACCOUNT_LOGIN, self.nLoginWay)
  end
end

-- 状态转换
-- 每个状态进入的时候，都要关闭相关联状态的界面，保证正确性
function tbLogin:OnStatuChange(nOldStatu, nNewStatu)
  if nNewStatu == self.emLOGINSTATUS_IDLE then
    if
      nOldStatu == self.emLOGINSTATUS_NULL -- 刚进入游戏
      --nOldStatu == self.emLOGINSTATUS_SELROLE or 					-- 选择角色状态返回
      or nOldStatu == self.emLOGINSTATUS_AGREE -- 服务条款状态返回
      or nOldStatu == self.emLOGINSTATUS_LIMIT -- 防沉迷状态返回
      or nOldStatu == self.emLOGINSTATUS_ENTERED_GAME
    then -- 游戏状态返回
      self:OnGameIdle()
      return
    elseif nOldStatu == self.emLOGINSTATUS_ENTERING_GAME then -- 正在进入游戏中断线，显示服务器忙
      local szMsg = "服务器人满，请稍候再试！"
      if self:IsPreCreateServer() == 1 then
        szMsg = "您的角色已经创建并成功预约新服，请等待开服当天再进入游戏！\n开服时间请留意官网开服新闻。"
      end
      local tbMsg = { szMsg = szMsg, tbOptTitle = { "返回" }, Callback = self.OnGameIdle, CallbackSelf = self }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end
  elseif nNewStatu == self.emLOGINSTATUS_LOGGING then -- 连接bishop中
    UiManager:CloseWindow(Ui.UI_ACCOUNT_LOGIN)
    UiManager:CloseWindow(Ui.UI_SELANDNEW_ROLE)
    local tbMsg = { szMsg = "连接服务器中...", Callback = self.CancelConnectBishop, CallbackSelf = self }
    UiManager:OpenWindow(Ui.UI_LOGINBG, 3)
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
  elseif nNewStatu == self.emLOGINSTATUS_AGREE then -- 服务条款
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    UiManager:OpenWindow(Ui.UI_LOGINBG, 1)
    UiManager:OpenWindow(Ui.UI_AGREEMENT)
  elseif nNewStatu == self.emLOGINSTATUS_LIMIT then -- 防沉迷
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    UiManager:OpenWindow(Ui.UI_LOGINBG, 1)
    if self.nLoginWay == self.LOGINWAY_YY then
      UiManager:OpenWindow(Ui.UI_LIMITPLAY, GetYyLimitUrl())
    else
      UiManager:OpenWindow(Ui.UI_LIMITPLAY, GetLimitUrl())
    end
  elseif nNewStatu == self.emLOGINSTATUS_ACTIVECODE then -- 需要激活帐号
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    UiManager:OpenWindow(Ui.UI_LOGINBG, 1)
    if self.nLoginWay == self.LOGINWAY_YY then
      UiManager:OpenWindow(Ui.UI_ACTIVECODE, GetYyActiveCodeUrl())
    else
      UiManager:OpenWindow(Ui.UI_ACTIVECODE, GetActiveCodeUrl())
    end
  elseif nNewStatu == self.emLOGINSTATUS_SELROLE then -- 选择角色状态
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    UiManager:CloseWindow(Ui.UI_ACCOUNT_LOGIN)
    --UiManager:CloseWindow(Ui.UI_NEW_ROLE);
    --UiManager:OpenWindow(Ui.UI_LOGINBG, 4);
    --UiManager:OpenWindow(Ui.UI_SELECT_ROLE);
    if nOldStatu ~= self.emLOGINSTATUS_OPT_CREATEROLE then -- 新建角色和选择角色公用界面
      UiManager:OpenWindow(Ui.UI_SELANDNEW_ROLE)
    end
  elseif nNewStatu == self.emLOGINSTATUS_OPT_CREATEROLE then -- 新建角色状态
    --UiManager:CloseWindow(Ui.UI_SELECT_ROLE);
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    --UiManager:OpenWindow(Ui.UI_LOGINBG, 5);
    --UiManager:OpenWindow(Ui.UI_NEW_ROLE);
  elseif nNewStatu == self.emLOGINSTATUS_WAIT_CREATEROLE then -- 正在新建角色状态
    UiManager:CloseWindow(Ui.UI_SELANDNEW_ROLE)
    local tbMsg = { szMsg = "正在创建角色...", nOptCount = 0 }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
  elseif nNewStatu == self.emLOGINSTATUS_ENTERING_GAME then -- 正在进入游戏
    UiManager:CloseWindow(Ui.UI_SELANDNEW_ROLE)
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    local tbMsg = { szMsg = "正在进入游戏...", nOptCount = 0 }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
  elseif nNewStatu == self.emLOGINSTATUS_ENTERED_GAME then -- 成功进入游戏
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    UiManager:CloseWindow(Ui.UI_LOGINBG)
  end
end

function tbLogin:CancelConnectBishop()
  --print("取消链接bishop");
  DisConnectGateWay()
  if SINA_CLIENT then
    ClearThirdInfo()
  end
  self:OnGameIdle()
end

function tbLogin:LimitEmpty()
  SetLoginStatus(self.emLOGINSTATUS_LIMIT)
end

function tbLogin:ActiveCode()
  SetLoginStatus(self.emLOGINSTATUS_ACTIVECODE)
end

-- 自动重新登录
function tbLogin:AutoRelogin()
  if self.nAutoReloginTimerId > 0 then
    tbTimer:Close(self.nAutoReloginTimerId)
    self.nAutoReloginTimerId = 0
  end
  AccountLoginSecret(GetClientLoginServerName())
end

-- 取消自动重新登录
function tbLogin:OnCancelAutoRelogin()
  if self.nAutoReloginTimerId > 0 then
    tbTimer:Close(self.nAutoReloginTimerId)
    self.nAutoReloginTimerId = 0
  end
  self:OnGameIdle()
end

-- 选择是否升级
function tbLogin:OnSelUpdate(nSel, nWantVersion)
  if nSel == 1 then
    Exit()
    StartJxOnline(nWantVersion)
  else
    self:OnGameIdle()
  end
end

function tbLogin:InvalidName()
  UiManager:OpenWindow(Ui.UI_SELANDNEW_ROLE)
end

function tbLogin:SetLoginWay(nLoginWay, bNoInitYy)
  self.nLoginWay = nLoginWay
  if nLoginWay == self.LOGINWAY_YY and bNoInitYy then -- 暂时不初始化YY，有些地方会这么用
    return 0
  end
  return SetLoginWay(nLoginWay)
end

function tbLogin:GetLoginWay()
  return self.nLoginWay
end

function tbLogin:LimitLogin(nP1, nP2)
  local szTitle = GetLastSvrTitle()
  local nFlag = 0
  for _, tbTitle in ipairs(self.tbLimitLogin_YY) do
    if string.find(szTitle, tbTitle[1]) and string.find(szTitle, tbTitle[2]) then
      nFlag = 1
      break
    end
  end
  if nFlag == 0 and self.nLoginWay == self.LOGINWAY_YY and nP1 == self.emLOGINSTATUS_LOGGING and nP2 == self.emLOGINSTATUS_SELROLE then
    local tbMsg = { szMsg = "本服务器未开放yy通行证登录游戏", tbOptTitle = { "确定" }, Callback = self.CancelConnectBishop, CallbackSelf = self }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    return 0
  end
  return 1
end

function tbLogin:OnSelFreeze(nSel)
  if nSel == 1 then
    self:OnGameIdle()
  else
    ShellExecute(self.szLockUrl)
    self:OnGameIdle()
  end
end

function tbLogin:OnSelUnFreeze(nSel)
  if nSel == 1 then
    self:OnGameIdle()
  else
    ShellExecute(self.szUnLockUrl)
    self:OnGameIdle()
  end
end

function tbLogin:OnKickFreeze(nSel)
  if nSel == 1 then
    self:OnGameIdle()
  else
    ShellExecute(self.szKickUrl)
    self:OnGameIdle()
  end
end
