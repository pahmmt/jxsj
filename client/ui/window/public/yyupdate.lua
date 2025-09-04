local tbYyUpdate = Ui:GetClass("yyupdate")

tbYyUpdate.BTN_CANCEL = "BtnCancel"
tbYyUpdate.TXT_MSG = "TxtMsg"
tbYyUpdate.IMG_MASK = "ImgMask"
tbYyUpdate.IMG_PROGRESS = "ImgProgress"

local tbLogin = Ui.tbLogic.tbLogin

function tbYyUpdate:OnOpen(nMode, nYyChannel)
  self.nUpdateTime = 0 -- 更新会有两次，第一次是个xml文件，然后才是真正的更新
  self.nUpdateMaxSize = 0 -- 由于YY没有合理的更新通知，只好通过这个来进行更新判断

  self.nProgressWidth, self.nProgressHeight = Wnd_GetSize(self.UIGROUP, self.IMG_PROGRESS)
  Wnd_SetSize(self.UIGROUP, self.IMG_MASK, 0, self.nProgressHeight)
  self.nMode = nMode or 1 -- 模式，1为登录的时候更新，2为家族面板YY的时候更新
  self.nYyChannel = nYyChannel or 0 -- YY频道
  if self.nMode == 1 then
    UiManager:SetExclusive(self.UIGROUP, 1) -- 设置为独占
  end
  if self.nMode == 2 then
    --强制设置为加载YY画中画
    SetMultiLoginWay(1)
  end
  self.nTimerId = 0
end

function tbYyUpdate:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CANCEL then
    local uiWnd = Ui(Ui.UI_ACCOUNT_LOGIN)
    if not uiWnd then
      return
    end
    uiWnd:ChangeLoginWay(tbLogin.LOGINWAY_KS) -- 返回设置金山版登录
    UiManager:CloseWindow(self.UIGROUP) -- 按下按钮关闭自己
  end
end

function tbYyUpdate:OnClose()
  if self.nMode == 1 then
    UiManager:SetExclusive(self.UIGROUP, 0) -- 设置为独占
  end
end

function tbYyUpdate:YyUpdate_Text(szText) end

function tbYyUpdate:YyUpdate_State(nCurSize, nMaxSize)
  if self.nUpdateMaxSize ~= nMaxSize then
    self.nUpdateMaxSize = nMaxSize
    self.nUpdateTime = self.nUpdateTime + 1
  end
  if self.nUpdateTime == 1 then -- 一个很小的xml文件
    Txt_SetTxt(self.UIGROUP, self.TXT_MSG, "正在更新YY配置信息...")
  elseif self.nUpdateTime == 2 then -- 画中画
    Txt_SetTxt(self.UIGROUP, self.TXT_MSG, "正在更新YY画中画...")
  elseif self.nUpdateTime == 3 then -- 更新YY客户端
    Txt_SetTxt(self.UIGROUP, self.TXT_MSG, "正在更新YY客户端...")
  end
  local nWidth = 0
  nWidth = self.nProgressWidth * nCurSize / nMaxSize
  Wnd_SetSize(self.UIGROUP, self.IMG_MASK, nWidth, self.nProgressHeight)
end

function tbYyUpdate:YyUpdate_Result(nResult)
  if self.nMode == 1 then -- 登录模式
    if not MULTI_LOGINWAY then
      return
    end
    if nResult == 1 then
      UiManager:CloseWindow(self.UIGROUP)
      local uiWnd = Ui(Ui.UI_ACCOUNT_LOGIN)
      if not uiWnd or tbLogin:GetLoginWay() ~= tbLogin.LOGINWAY_YY then
        return
      end
      uiWnd:InitYyLogin()
    else
      Txt_SetTxt(self.UIGROUP, self.TXT_MSG, "更新YY失败，请选择其他登录方式")
    end
  elseif self.nMode == 2 then -- 家族启动模式
    if 0 == UiManager:WindowVisible(self.UIGROUP) then -- 已经取消了更新
      return
    end
    UiManager:CloseWindow(self.UIGROUP)
    if nResult == 1 then -- 更新成功，打开画中画
      if InitYypip() ~= 0 then
        PopoTip:ShowLoginPopo(" 初始化YY环境异常，请手动启动YY。YY在客户端安装目录下\\YY\\yylauncher.exe")
        return
      else
        if self.nYyChannel > 0 then
          PopoTip:ShowLoginPopo(" YY语音工具已经启动，请查看桌面右下角的<color=yellow>系统任务栏的小浣熊图标<color>，双击进行登陆或注册。如果已经登录YY，我们5秒后将尝试进入家族频道。")
          self.nTimerId = Ui.tbLogic.tbTimer:Register(5 * Env.GAME_FPS, self.JoinYyChannel, self)
        else
          PopoTip:ShowLoginPopo(" YY语音工具已经启动，请查看桌面右下角的<color=yellow>系统任务栏的小浣熊图标<color>，双击进行登陆或注册。请手动进入你家族的YY频道。")
        end
        YY_SetShowMouse(0) -- 关闭鼠标显示
      end
    end
  end
end

function tbYyUpdate:JoinYyChannel()
  if self.nTimerId ~= 0 then
    Ui.tbLogic.tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  YY_JoinChannel(self.nYyChannel)
end
