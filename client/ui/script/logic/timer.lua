-- UI专用计时器，UI逻辑通常不应该直接使用Lib Timer和Player Timer，会存在各种逻辑错误。

Ui.tbLogic.tbTimer = {}
local tbTimer = Ui.tbLogic.tbTimer

function tbTimer:Init()
  self.tbRegs = {}
end

-- 清除所有Timer（bGlobal ~= 1则不清除全局Timer）
function tbTimer:Clear(bGlobal)
  for i, v in pairs(self.tbRegs) do
    if (bGlobal == 1) or (v ~= 1) then
      Timer:Close(i)
    end
  end
end

-- 注册UI计时器，两种形式：
--  Register(nWaitTime, fnCallback, tbTable, ...)			: 注册标准计时器，在角色登出时会自动关闭
--  Register(nWaitTime, bGlobal, fnCallback, tbTable, ...)	: bGlobal = 1时注册全局计时器，否则注册标准计时器
function tbTimer:Register(nWaitTime, ...)
  local bGlobal = arg[1]
  local tbEvent = {
    nWaitTime = nWaitTime,
    tbCallBack = arg,
    szRegInfo = debug.traceback("Register UI Timer", 2),
    OnDestroy = function(tbSelf, nTimerId)
      self.tbRegs[nTimerId] = nil
    end,
  }

  if type(bGlobal) ~= "function" then
    tbEvent.tbCallBack = { unpack(tbEvent.tbCallBack, 2) }
    bGlobal = (bGlobal == 1) and 1 or 0
  else
    bGlobal = 0
  end

  local nTimerId = Timer:RegisterEx(tbEvent)
  assert(not self.tbRegs[nTimerId])
  self.tbRegs[nTimerId] = bGlobal
  return nTimerId
end

-- 关闭UI计时器
function tbTimer:Close(nTimerId)
  local bGlobal = self.tbRegs[nTimerId]
  if bGlobal then
    Timer:Close(nTimerId)
    self.tbRegs[nTimerId] = nil
  end
end
