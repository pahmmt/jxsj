Ui.tbLogic.tbMsgInfo = {}

local tbMsgInfo = Ui.tbLogic.tbMsgInfo
local tbTimer = Ui.tbLogic.tbTimer

--[[ 范例
function xxx:MsgBoxExample(...)
	local tbMsg = {};
	tbMsg.szTitle = "范例";
	tbMsg.nOptCount = 2;
	tbMsg.tbOptTitle = { "按钮1", "按钮2" };
	tbMsg.nTimeout = 10;
	tbMsg.szMsg = "这是MsgBox的使用例子。哇哈哈";
	function tbMsg:Callback(nOptIndex, varParm1, varParam2, ...)
		if (nOptIndex == 0) then
			me.Msg("[MsgBox例子]超时了...("..varParm1..", "..varParam2..")");
		elseif (nOptIndex == 1) then
			me.Msg("[MsgBox例子]你点了按钮1...("..varParm1..", "..varParam2..")");
		elseif (nOptIndex == 2) then
			me.Msg("[MsgBox例子]你点了按钮2...("..varParm1..", "..varParam2..")");
		end
	end
	local szKey = "MsgBoxExample";		-- 用于识别重复消息和消息查找，生成规则看自己需求
	tbMsgInfo:AddMsg(szKey, tbMsg, "参数1", "参数2", "...");
end
--]]

function tbMsgInfo:Init()
  self.tbTop = nil -- 当前正在显示的项
  self.tbQueue = {} -- 待显示队列
  UiNotify:RegistNotify(UiNotify.emUIEVENT_WND_CLOSED, self.OnMsgBoxClosed, self)
end

function tbMsgInfo:Clear()
  self:Init()
  self:Update() -- 通过更新关掉UI_MSGINFO
end

function tbMsgInfo:AddMsg(szKey, tbMsg, ...) -- 添加一条消息
  if not tbMsg then
    return
  end

  local tbOrg, i = self:GetMsg(szKey)
  if szKey and (szKey ~= "") and tbOrg then -- 如果要插入的消息已存在并且不在队首，则需要把它提前到队首（升高优先级）
    if i > 1 then
      table.insert(self.tbQueue, 1, tbOrg) -- 插到队首
      table.remove(self.tbQueue, i + 1) -- 删除原来的
    end
    return
  end

  tbMsg.bExclusive = 0 -- UI_MSGINFO中的消息总是非独占的
  local tbInfo = { szKey = szKey, tbMsg = tbMsg, tbArgs = arg }
  if not self.tbTop then
    self.tbTop = tbInfo -- 插入第一条信息
  else
    table.insert(self.tbQueue, 1, tbInfo) -- 表不为空，新加到队首
  end

  if #self.tbQueue == 0 then -- 只有当第一条信息被插入时才需要立即显示（此时队列为空）
    self:Update()
  end
end

function tbMsgInfo:DelMsg(szKey) -- 删除指定消息（匹配关键字，有多少删多少）
  -- 如果队首也需要被删除，则先关闭当前窗口
  -- 注意这里是个循环，关掉当前窗口的同时，队列中的下一项会成为新的队首，仍然需要检查之
  while true do
    if not self.tbTop then
      return -- 队列已空，不需要再找了
    end
    if self.tbTop.szKey ~= szKey then
      break -- 队首不是要删除的项，退出窗口关闭检查
    end
    self:DelTopMsg() -- 删除队首
  end

  local i = 1

  -- 注意这里只能用while，任何形式的for似乎都无法得到正确结果
  while i <= #self.tbQueue do
    local tbInfo = self.tbQueue[i]
    if tbInfo.szKey == szKey then
      table.remove(self.tbQueue, i)
    else
      i = i + 1
    end
  end
end

function tbMsgInfo:GetMsg(szKey) -- 获取指定消息（匹配关键字，返回第一个）
  if not self.tbTop then
    return
  end
  if self.tbTop.szKey == szKey then
    return self.tbTop, 0
  end
  for i, tbInfo in ipairs(self.tbQueue) do
    if tbInfo.szKey == szKey then
      return tbInfo, i
    end
  end
end

function tbMsgInfo:DelTopMsg() -- 删除顶层消息
  if not self.tbTop then
    return
  end
  self.tbTop = nil
  if #self.tbQueue > 0 then
    self.tbTop = self.tbQueue[1]
    table.remove(self.tbQueue, 1)
  end
  self:Update()
end

function tbMsgInfo:Update()
  if self.tbTop then
    UiManager:OpenWindow(Ui.UI_MSGINFO, self.tbTop.tbMsg, unpack(self.tbTop.tbArgs))
  else
    UiManager:CloseWindow(Ui.UI_MSGINFO)
  end
end

function tbMsgInfo:OnMsgBoxClosed(szUiGroup)
  if szUiGroup == Ui.UI_MSGINFO then
    self:DelTopMsg()
  end
end
