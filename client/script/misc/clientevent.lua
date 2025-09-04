--- 客户端事件

-- 所有客户端资源加载完之后执行的回调
function ClientEvent:OnStart()
  if self.tbStartFun then
    for i, tbStart in ipairs(self.tbStartFun) do
      tbStart.fun(unpack(tbStart.tbParam))
    end
  end
  MemoryMgr:Start()
end

-- 注册客户端启动函数
function ClientEvent:RegisterClientStartFunc(fnStartFun, ...)
  assert(fnStartFun)
  if not self.tbStartFun then
    self.tbStartFun = {}
  end
  table.insert(self.tbStartFun, { fun = fnStartFun, tbParam = arg })
end

function ClientEvent:OnServerCall(tbCall)
  Dbg:Output("ClientEvent", "OnServerCall", unpack(tbCall))
  Lib:CallBack(tbCall)
end

function ClientEvent:OnLoginEnd(pPlayer, bMiniClient)
  self.tbRoleLoginInfo = self.tbRoleLoginInfo or {}
  local tb = self.tbRoleLoginInfo[pPlayer.szName]

  if self.tbRecentSwitchServer and self.tbRecentSwitchServer[pPlayer.szName] then
    self.tbRecentSwitchServer[pPlayer.szName] = nil
    return
  end

  -- warning 后面的代码是只有真正登录的时候才会执行，跨服不执行

  local nClientType = bMiniClient or 0
  -- 与上次登陆时间隔天了，可以记录。。。
  if not tb or Lib:GetLocalDay(tb[1]) ~= Lib:GetLocalDay(GetTime()) then
    self.tbRoleLoginInfo[pPlayer.szName] = { GetTime(), nClientType }
    --pPlayer.CallServerScript({"WriteLoginClientInfoLog", nClientType});
  end

  MiniResource.tbDownloadInfo:OnLoginEnd()
  KLib.ReleaseScriptFreeMemory(-1)
  Player.tbLimitTime:_OnLogin()
end

function ClientEvent:OnLogout(szReason)
  self.tbRecentSwitchServer = self.tbRecentSwitchServer or {}

  if self.tbRecentSwitchServer[me.szName] then
    self.tbRecentSwitchServer[me.szName] = nil
  end

  -- 只有因为跨服下线才记录
  if szReason ~= "Logout" then
    self.tbRecentSwitchServer[me.szName] = 1
  elseif szReason == "Logout" then
    Player.tbLimitTime:_OnLogout() -- 只有下线才进行
  end
  Ui(Ui.UI_SHOP):OnSetForbidSpeRepair(0)
  KKinRepository.ClearAllRoom()

  MiniResource.tbDownloadInfo:OnLogout()
end
