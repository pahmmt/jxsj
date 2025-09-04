-----------------------------------------------------
--文件名		：	selectserver.lua
--创建者		：	zhongjunqi@kingsoft.net
--创建时间		：	2011-09-04
--功能描述		：	选择服务器面板，悲剧的界面，本来挺好的结构，可惜为了左边列表的那几个分栏搞得超级复杂
--					不太建议再修改这个界面，要改重新弄个吧，原始数据都还保留没动
------------------------------------------------------

local tbSelServer = Ui:GetClass("selectserver")
local tbLoginLogic = Ui.tbLogic.tbLogin
local tbTimer = Ui.tbLogic.tbTimer

local TIMER_TICK = 20 * Env.GAME_FPS -- 定时器最小单位，1秒

tbSelServer.REGION_LIST_VIR = "VirRegionList" -- 虚拟的区
tbSelServer.REGION_LIST_DIANXIN = "DianXinRegionList" -- 电信
tbSelServer.REGION_LIST_WANGTONG = "WangTongRegionList" -- 网通
tbSelServer.REGION_LIST_OTHER = "OtherRegionList" -- 其他
tbSelServer.IMG_DIANXIN = "ImgDianxin"
tbSelServer.IMG_WANGTONG = "ImgWangTong"
tbSelServer.IMG_OTHER = "ImgOther"
tbSelServer.IP_LIST = "IpList"
tbSelServer.BTN_OK = "Ok"
tbSelServer.BTN_CANCEL = "Cancel"
tbSelServer.BTN_CLOSE = "Close"
tbSelServer.IMG_NEWFLAG = "ImgNewFlag"
tbSelServer.EDT_FINDSERVER = "Edt_FindServer"
tbSelServer.List_SerLookup = "ListSerLookupName"
tbSelServer.Scr_SerLookup = "ScorllSerLookup"

-- 打开服务器选择界面的方式，因为要处理选择完成的后续操作
tbSelServer.MODE_NORMAL = 0 -- 正常选择服务器，不做后续操作
tbSelServer.MODE_BEGIN_LOGIN = 1 -- 登录界面点击登录后，没有服务器的时候，进行选择
tbSelServer.MODE_SELROLE = 2 -- 在选择界面进行更换服务器的模式
tbSelServer.MODE_BEGIN_YY_LOGIN = 3 -- yy模式的选择服务器

local tbColorMap = {
  ["维护"] = "gray",
  ["良好"] = "green",
  ["繁忙"] = "wheat",
  ["爆满"] = "red",
}

local tbExtDesc = {
  [1] = "新开",
  [2] = "推荐",
}

--临时服务器名设置
tbSelServer.tbTmpLimit = {
  ["【电信轩辕区 桃溪镇】"] = { nShowDate = 2012101508, szTitle = "<color=yellow>限号内测<color>" },
  ["【网通寒冰区 古墓情缘】"] = { nShowDate = 2012101508, szTitle = "<color=yellow>限号内测<color>" },
  ["【电信轩辕区 红袖缠】"] = { nShowDate = 2012101613, szTitle = "<color=gold>公测预约<color>" },
  ["【电信轩辕区 御雷决】"] = { nShowDate = 2012101613, szTitle = "<color=gold>公测预约<color>" },
  ["【电信轩辕区 飞天舞】"] = { nShowDate = 2012101613, szTitle = "<color=gold>公测预约<color>" },
  ["【网通寒冰区 冰火天堑】"] = { nShowDate = 2012101613, szTitle = "<color=gold>公测预约<color>" },
}

tbSelServer.tbFndList = {}

local REGION_VIR = 0 -- 虚拟
local REGION_DIANXIN = 1 -- 电信
local REGION_WANGTONG = 2 -- 网通
local REGION_OTHER = 3 -- 其他
function tbSelServer:Init()
  self.nVirRegion = 0
  self.tbVirRegion = nil -- 虚拟的区列表：新开推荐
  self.nRealRegion = 0
  self.tbRealRegion = nil -- 真实的区服列表
  self.nRecentSvrCount = 0
  self.tbRecentSvr = nil -- 最近登录列表
  self.nMode = 0
  self.nLastRegionIndex = 0 -- 最后选择的区

  -- 找到电信网通其它的区, 之所以这样做是为了以后排序遍历方便
  self.tbRegion = {
    [REGION_DIANXIN] = {}, -- 电信
    [REGION_WANGTONG] = {}, -- 网通
    [REGION_OTHER] = {}, -- 其他
  }
end

-- nMode: 1表示选择完成后自动登录
-- 		  0 或者 nil 表示正常模式，选择完后关闭自己
function tbSelServer:OnOpen(nMode)
  UiManager:SetExclusive(self.UIGROUP, 1) -- 独占状态
  self.nMode = nMode
  self:UpdateServerInfo()
  self.nTimerId = tbTimer:Register(TIMER_TICK, self.OnTimer, self) -- 开启定时器，定时20秒
  if MULTI_LOGINWAY then
    local uiWnd = Ui(Ui.UI_ACCOUNT_LOGIN)
    if uiWnd and tbLoginLogic:GetLoginWay() == tbLoginLogic.LOGINWAY_YY then
      uiWnd:ShowYyLoginBg(0)
    end
  end
  if SINA_CLIENT then
    Wnd_Hide(self.UIGROUP, self.BTN_CANCEL)
  end
  Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 0)
end

function tbSelServer:OnClose()
  UiManager:SetExclusive(self.UIGROUP, 0) -- 取消独占状态
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  if MULTI_LOGINWAY then
    local uiWnd = Ui(Ui.UI_ACCOUNT_LOGIN)
    if uiWnd and tbLoginLogic:GetLoginWay() == tbLoginLogic.LOGINWAY_YY then
      uiWnd:ShowYyLoginBg(1)
    end
  end
end

-- 定时更新服务器信息
function tbSelServer:OnTimer()
  self:UpdateServerInfo()
end

-- 响应按钮点击事件
function tbSelServer:OnButtonClick(szWndName, nParam)
  if szWndName == self.BTN_OK then
    local tbSvrList = self:GetSvrListByRegionIndex(self.nLastRegionIndex)
    local nSelSvr = Lst_GetCurKey(self.UIGROUP, self.IP_LIST)
    if not tbSvrList[nSelSvr] then
      local tbMsg = {}
      tbMsg.szMsg = "请先选择服务器"
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    else
      self:ConfirmSelSvr(tbSvrList[nSelSvr].Title)
    end
  elseif szWndName == self.BTN_CANCEL or szWndName == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function tbSelServer:OnListSel(szWndName, nItemIndex)
  if szWndName == self.REGION_LIST_VIR then -- 选中了虚拟区，刷新该区的服务器列表
    if nItemIndex ~= -1 then -- -1是被取消选择
      self:OnSelRegion(REGION_VIR, nItemIndex)
      local tbSvrList = self:GetSvrListByRegionKey(REGION_VIR, nItemIndex)
      self:RefreshSvrList(tbSvrList)
    end
  elseif szWndName == self.REGION_LIST_DIANXIN then
    if nItemIndex ~= -1 then -- -1是被取消选择
      self:OnSelRegion(REGION_DIANXIN, nItemIndex)
      local tbSvrList = self:GetSvrListByRegionKey(REGION_DIANXIN, nItemIndex)
      self:RefreshSvrList(tbSvrList)
    end
  elseif szWndName == self.REGION_LIST_WANGTONG then
    if nItemIndex ~= -1 then -- -1是被取消选择
      self:OnSelRegion(REGION_WANGTONG, nItemIndex)
      local tbSvrList = self:GetSvrListByRegionKey(REGION_WANGTONG, nItemIndex)
      self:RefreshSvrList(tbSvrList)
    end
  elseif szWndName == self.REGION_LIST_OTHER then
    if nItemIndex ~= -1 then -- -1是被取消选择
      self:OnSelRegion(REGION_OTHER, nItemIndex)
      local tbSvrList = self:GetSvrListByRegionKey(REGION_OTHER, nItemIndex)
      self:RefreshSvrList(tbSvrList)
    end
  elseif szWndName == self.IP_LIST then -- 选择了一个服务器
    -- 记录玩家选择
    local tbSvrList = self:GetSvrListByRegionIndex(self.nLastRegionIndex)
    local nSelSvr = Lst_GetCurKey(self.UIGROUP, self.IP_LIST)

    if not tbSvrList[nItemIndex] then
      return
    end
    SetLastSvrTitle(tbSvrList[nItemIndex].Title)
  end
end

function tbSelServer:OnListDClick(szWndName, nParam)
  if szWndName == self.IP_LIST then
    local tbSvrList = self:GetSvrListByRegionIndex(self.nLastRegionIndex)
    if not tbSvrList[nParam] then
      return
    end
    self:ConfirmSelSvr(tbSvrList[nParam].Title)
  end
end

-- 更新队友数据及界面
function tbSelServer:UpdateServerInfo()
  Lst_Clear(self.UIGROUP, self.REGION_LIST_VIR)
  Lst_Clear(self.UIGROUP, self.REGION_LIST_DIANXIN)
  Lst_Clear(self.UIGROUP, self.REGION_LIST_WANGTONG)
  Lst_Clear(self.UIGROUP, self.REGION_LIST_OTHER)
  Lst_Clear(self.UIGROUP, self.IP_LIST)
  self:HideAllImgNewFlag()

  self.nVirRegion, self.tbVirRegion = GetServerList(2)
  self.nRealRegion, self.tbRealRegion = GetServerList()
  self.nRecentSvrCount, self.tbRecentSvr = GetRecentServerList()
  self.tbRecentSvr[1].RegName = "最近登录"

  -- 找到电信网通其它的区, 之所以这样做是为了以后排序遍历方便
  self.tbRegion = {
    [REGION_VIR] = {}, -- 虚拟区，包含最近登录区
    [REGION_DIANXIN] = {}, -- 电信
    [REGION_WANGTONG] = {}, -- 网通
    [REGION_OTHER] = {}, -- 其他
  }

  for i, tbRegion in ipairs(self.tbRealRegion) do
    if string.find(tbRegion.RegName, "电信") then -- 电信
      tbRegion.RegName = string.sub(tbRegion.RegName, 1, -7)
      table.insert(self.tbRegion[REGION_DIANXIN], tbRegion)
    elseif string.find(tbRegion.RegName, "网通") then -- 网通
      tbRegion.RegName = string.sub(tbRegion.RegName, 1, -7)
      table.insert(self.tbRegion[REGION_WANGTONG], tbRegion)
    else
      table.insert(self.tbRegion[REGION_OTHER], tbRegion)
    end
  end

  for i, tbRegion in ipairs(self.tbVirRegion) do
    table.insert(self.tbRegion[REGION_VIR], tbRegion)
  end
  table.insert(self.tbRegion[REGION_VIR], self.tbRecentSvr[1])

  -- 新开/推荐/最近
  for i, tbRegion in ipairs(self.tbRegion[REGION_VIR]) do
    Lst_SetCell(self.UIGROUP, self.REGION_LIST_VIR, i, 0, tbRegion.RegName)
  end

  -- 电信
  for i, tbRegion in ipairs(self.tbRegion[REGION_DIANXIN]) do
    Lst_SetCell(self.UIGROUP, self.REGION_LIST_DIANXIN, i, 0, tbRegion.RegName)
  end

  -- 网通
  for i, tbRegion in ipairs(self.tbRegion[REGION_WANGTONG]) do
    Lst_SetCell(self.UIGROUP, self.REGION_LIST_WANGTONG, i, 0, tbRegion.RegName)
  end

  -- 其他
  for i, tbRegion in ipairs(self.tbRegion[REGION_OTHER]) do
    Lst_SetCell(self.UIGROUP, self.REGION_LIST_OTHER, i, 0, tbRegion.RegName)
  end

  -- 调整大小位置
  self:AdjustRegionPos()
  -- 得到最后选择的存盘

  self.nLastRegionIndex = GetLastSvrRegionIdx()

  self:SetSelRegion(self.nLastRegionIndex)
end

-- 确定选择服务器
function tbSelServer:ConfirmSelSvr(szSelTitle)
  SetLastSvrTitle(szSelTitle)
  if self.nMode == self.MODE_BEGIN_LOGIN then -- 点击登录后才选择服务器
    UiManager:CloseWindow(self.UIGROUP)
    local nStart, nEnd = string.find(szSelTitle, "新开")
    if nStart and nStart > 0 then
      szSvrTitle = string.sub(szSelTitle, 1, nStart - 1)
    end

    local nStart, nEnd = string.find(szSelTitle, "推荐")
    if nStart and nStart > 0 then
      szSelTitle = string.sub(szSelTitle, 1, nStart - 1)
    end
    local bRet = AccountLoginSecret(szSelTitle)
    if bRet == 0 then
      local tbMsg = { szMsg = "登录失败：未知原因", tbOptTitle = { "确定" }, Callback = tbLoginLogic.OnGameIdle, CallbackSelf = tbLoginLogic }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end
  elseif self.nMode == self.MODE_NORMAL then -- 在登录界面进行选择服务器
    UiManager:CloseWindow(self.UIGROUP)
    local uiAccountLogin = nil
    uiAccountLogin = Ui(Ui.UI_ACCOUNT_LOGIN) -- 更新选择的服务器

    if uiAccountLogin then
      uiAccountLogin:UpdateSelSvr()
    end
    -- zhouchenfei sina登陆
    if SINA_CLIENT then
      local nStart, nEnd = string.find(szSelTitle, "新开")
      if nStart and nStart > 0 then
        szSelTitle = string.sub(szSelTitle, 1, nStart - 1)
      end

      local nStart, nEnd = string.find(szSelTitle, "推荐")
      if nStart and nStart > 0 then
        szSelTitle = string.sub(szSelTitle, 1, nStart - 1)
      end
      local bRet = AccountLoginSecret(szSelTitle)
    end
  elseif self.nMode == self.MODE_SELROLE then -- 选择角色的时候进行更换服务器
    UiManager:CloseWindow(self.UIGROUP)
    local szPreSvrTitle = GetClientLoginServerName()
    if szPreSvrTitle == szSelTitle then
      return
    end
    local uiSelRole = Ui(Ui.UI_SELECT_ROLE) -- 更新选择的服务器
    if uiSelRole then
      uiSelRole:UpdateSelSvr()
    end
    local nStart, nEnd = string.find(szSelTitle, "新开")
    if nStart and nStart > 0 then
      szSelTitle = string.sub(szSelTitle, 1, nStart - 1)
    end

    local nStart, nEnd = string.find(szSelTitle, "推荐")
    if nStart and nStart > 0 then
      szSelTitle = string.sub(szSelTitle, 1, nStart - 1)
    end
    local bRet = AccountLoginSecret(szSelTitle)
  elseif self.nMode == self.MODE_BEGIN_YY_LOGIN then -- YY 模式登录
    UiManager:CloseWindow(self.UIGROUP)
    local bRet = ConnectGateway(szSelTitle)
    if bRet == 0 then
      local tbMsg = { szMsg = "登录失败：未知原因", tbOptTitle = { "确定" }, Callback = tbLoginLogic.OnGameIdle, CallbackSelf = tbLoginLogic }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end
  end
end

-- 根据列表的区索引来找到对应的服务器列表
function tbSelServer:GetSvrListByRegionKey(nListId, nRegKey)
  local tbSvrList = nil
  if nListId == REGION_VIR then -- 虚拟区列表id
    if nRegKey <= self.nVirRegion then -- 虚拟区的索引
      tbSvrList = self.tbVirRegion[nRegKey] or {}
    elseif nRegKey == self.nVirRegion + 1 then -- 最近登录区索引
      tbSvrList = self.tbRecentSvr[1] or {}
    end
  else -- 真实区索引
    if not self.tbRegion[nListId] then
      tbSvrList = {}
    else
      tbSvrList = self.tbRegion[nListId][nRegKey] or {}
    end
  end
  return tbSvrList
end

-- 隐藏所有新服标记
function tbSelServer:HideAllImgNewFlag()
  for i = 1, 30 do
    Wnd_Hide(self.UIGROUP, self.IMG_NEWFLAG .. i)
  end
end

-- 调整列表框的位置
function tbSelServer:AdjustRegionPos()
  -- 得到4个列表的高度和title图片的高度
  local _, nVirHeight = Wnd_GetSize(self.UIGROUP, self.REGION_LIST_VIR)
  local _, nDianXinHeight = Wnd_GetSize(self.UIGROUP, self.REGION_LIST_DIANXIN)
  local _, nWangTongHeight = Wnd_GetSize(self.UIGROUP, self.REGION_LIST_WANGTONG)
  local _, nOtherHeight = Wnd_GetSize(self.UIGROUP, self.REGION_LIST_OTHER)
  local _, nImgHeight = Wnd_GetSize(self.UIGROUP, self.IMG_DIANXIN)
  local nSpace = 10
  local nTitleXPos = 8
  local nListXPos = 8

  -- 设置位置
  local nCurPos = 0
  Wnd_SetPos(self.UIGROUP, self.REGION_LIST_VIR, nListXPos, nCurPos) -- 虚拟区
  nCurPos = nCurPos + nVirHeight + nSpace
  Wnd_SetPos(self.UIGROUP, self.IMG_DIANXIN, nTitleXPos, nCurPos) -- 电信title
  nCurPos = nCurPos + nImgHeight
  Wnd_SetPos(self.UIGROUP, self.REGION_LIST_DIANXIN, nListXPos, nCurPos) -- 电信区
  nCurPos = nCurPos + nDianXinHeight + nSpace
  Wnd_SetPos(self.UIGROUP, self.IMG_WANGTONG, nTitleXPos, nCurPos) -- 网通title
  nCurPos = nCurPos + nImgHeight
  Wnd_SetPos(self.UIGROUP, self.REGION_LIST_WANGTONG, nListXPos, nCurPos) -- 网通
  nCurPos = nCurPos + nWangTongHeight + nSpace
  Wnd_SetPos(self.UIGROUP, self.IMG_OTHER, nTitleXPos, nCurPos) -- 其他title
  nCurPos = nCurPos + nImgHeight
  Wnd_SetPos(self.UIGROUP, self.REGION_LIST_OTHER, nListXPos, nCurPos) -- 其他
end

-- 选择了一个区
function tbSelServer:OnSelRegion(nRegList, nRegId)
  if nRegList == REGION_VIR then -- 选择虚拟区，其他区不能选
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_DIANXIN, -1)
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_WANGTONG, -1)
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_OTHER, -1)
    self.nLastRegionIndex = nRegId
  elseif nRegList == REGION_DIANXIN then
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_VIR, -1)
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_WANGTONG, -1)
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_OTHER, -1)
    self.nLastRegionIndex = nRegId + Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_VIR)
  elseif nRegList == REGION_WANGTONG then
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_VIR, -1)
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_DIANXIN, -1)
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_OTHER, -1)
    self.nLastRegionIndex = nRegId + Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_VIR) + Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_DIANXIN)
  elseif nRegList == REGION_OTHER then
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_VIR, -1)
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_WANGTONG, -1)
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_DIANXIN, -1)
    self.nLastRegionIndex = nRegId + Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_VIR) + Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_DIANXIN) + Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_WANGTONG)
  end
  SetLastSvrRegionIdx(self.nLastRegionIndex)
end

-- 根据列表的区索引来找到对应的服务器列表，这个索引是存在客户端的索引
function tbSelServer:GetSvrListByRegionIndex(nIndex)
  -- 计算出现在所有列表的高度
  local nVirCount = Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_VIR)
  local nDianXinCount = Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_DIANXIN)
  local nWangTongCount = Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_WANGTONG)
  local nOtherCount = Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_OTHER)

  if nIndex <= nVirCount then
    return self.tbRegion[REGION_VIR][nIndex] or {}
  end
  nIndex = nIndex - nVirCount
  if nIndex <= nDianXinCount then
    return self.tbRegion[REGION_DIANXIN][nIndex] or {}
  end
  nIndex = nIndex - nDianXinCount
  if nIndex <= nWangTongCount then
    return self.tbRegion[REGION_WANGTONG][nIndex] or {}
  end
  nIndex = nIndex - nWangTongCount
  if nIndex <= nOtherCount then
    return self.tbRegion[REGION_OTHER][nIndex] or {}
  end
  return {}
end

-- 刷新服务器列表
function tbSelServer:RefreshSvrList(tbSvrList)
  Lst_Clear(self.UIGROUP, self.IP_LIST)
  self:HideAllImgNewFlag()
  local szLastSelSvrTitle = GetLastSvrTitle()
  local nLastSelIndex = 0
  for i, tbSvr in ipairs(tbSvrList) do
    if tbSvr.Title == szLastSelSvrTitle then -- 记录最后选择的服务器索引，设置选中状态
      nLastSelIndex = i
    end
    if tbSvr.ServerType == 3 then -- todo 以后新服会改成1
      Wnd_Show(self.UIGROUP, self.IMG_NEWFLAG .. i)
    end

    local szContent = string.format("<color=%s>%-24s%s<color>", tbColorMap[tbSvr.State] or "white", tbSvr.Title, tbSvr.State)
    --临时测试服务器名称修改
    if self.tbTmpLimit[tbSvr.Title] and tonumber(os.date("%Y%m%d%H", GetTime())) <= self.tbTmpLimit[tbSvr.Title].nShowDate then
      szContent = string.format("<color=%s>%-24s<color>%s", tbColorMap[tbSvr.State] or "white", tbSvr.Title, self.tbTmpLimit[tbSvr.Title].szTitle)
    end

    Lst_SetCell(self.UIGROUP, self.IP_LIST, i, 0, szContent)
  end
  if nLastSelIndex ~= 0 then -- 选择最后的服务器
    Lst_SetCurKey(self.UIGROUP, self.IP_LIST, nLastSelIndex)
  end
end

-- 设置选择的服务器区
function tbSelServer:SetSelRegion(nRegionIndex)
  -- 计算出现在所有列表的数量
  local nVirCount = Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_VIR)
  local nDianXinCount = Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_DIANXIN)
  local nWangTongCount = Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_WANGTONG)
  local nOtherCount = Lst_GetLineCount(self.UIGROUP, self.REGION_LIST_OTHER)

  if nRegionIndex <= nVirCount then -- 虚拟区
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_VIR, nRegionIndex)
    return
  end
  nRegionIndex = nRegionIndex - nVirCount
  if nRegionIndex <= nDianXinCount then -- 电信
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_DIANXIN, nRegionIndex)
    return
  end
  nRegionIndex = nRegionIndex - nDianXinCount
  if nRegionIndex <= nWangTongCount then -- 网通
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_WANGTONG, nRegionIndex)
    return
  end
  nRegionIndex = nRegionIndex - nWangTongCount
  if nRegionIndex <= nOtherCount then -- 其他
    Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_OTHER, nRegionIndex)
    return
  end
  --print("都没找到合适的区");
  Lst_SetCurKey(self.UIGROUP, self.REGION_LIST_VIR, 1)
end

function tbSelServer:OnEditChange(szWndName)
  local szFindServer = Edt_GetTxt(self.UIGROUP, self.EDT_FINDSERVER)
  MessageList_Clear(self.UIGROUP, self.List_SerLookup)
  self.tbFndList = {}
  if string.len(szFindServer) <= 1 then
    Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 0)
    return
  end
  for nRegId, tbAreaList in ipairs(self.tbRegion) do
    for nListId, tbSerList in ipairs(tbAreaList) do
      for nSId, tbInfo in ipairs(tbSerList) do
        local nFind = string.find(tbInfo.Title, szFindServer)
        if nFind and nFind > 0 then
          MessageList_AddNewLine(self.UIGROUP, self.List_SerLookup)
          MessageList_PushString(self.UIGROUP, self.List_SerLookup, 0, tbInfo.Title, "", "", 1)
          MessageList_PushOver(self.UIGROUP, self.List_SerLookup)
          table.insert(self.tbFndList, { nRegId, nListId, tbInfo.Title })
        end
      end
    end
  end
  if #self.tbFndList > 0 then
    MessageList_SetSelectedIndex(self.UIGROUP, self.List_SerLookup, 1)
    Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 1)
  else
    Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 0)
  end
end

function tbSelServer:OnEditEnter(szWndName)
  self:OnButtonClick(self.BTN_OK)
end

local szDefaultName = "搜索服务器"
function tbSelServer:OnEditFocus(szWndName)
  local szMap = Edt_GetTxt(self.UIGROUP, self.EDT_FINDSERVER)
  if szMap == szDefaultName then
    Edt_SetTxt(self.UIGROUP, self.EDT_FINDSERVER, "")
  end
end

function tbSelServer:OnMsgListLineClick(szWndName)
  local nIndex = MessageList_GetSelectedIndex(self.UIGROUP, self.List_SerLookup)
  local tbLastRegionIndex = self.tbFndList[nIndex]
  if tbLastRegionIndex then
    local szZoneServer = tbLastRegionIndex[3]
    szZoneServer = string.gsub(szZoneServer, "^【.*%s+([^ ]*)】.*$", "%1")
    szZoneServer = string.gsub(szZoneServer, "^([^ ]*)%s+%-%s+.*$", "%1")
    szZoneServer = string.gsub(szZoneServer, "^%s*(.-)%s*$", "%1")
    Edt_SetTxt(self.UIGROUP, self.EDT_FINDSERVER, szZoneServer)
  end
  self.tbFndList = {}
  Wnd_SetVisible(self.UIGROUP, self.Scr_SerLookup, 0)
end

function tbSelServer:OnMouseEnter(szWndName)
  local nIndex = MessageList_GetSelectedIndex(self.UIGROUP, self.List_SerLookup)
  local tbLastRegionIndex = self.tbFndList[nIndex]
  if tbLastRegionIndex then
    self:OnSelRegion(tbLastRegionIndex[1], tbLastRegionIndex[2])
    SetLastSvrTitle(tbLastRegionIndex[3])
    self:UpdateServerInfo()
  end
end
