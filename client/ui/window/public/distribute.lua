-------------------------------------------------------
-- 文件名　：distribute.lua
-- 创建者　：furuilei
-- 创建时间：2010-05-04 11:32:18
-- 文件描述：跨服军团战奖励分配
-------------------------------------------------------

local uiDistribute = Ui:GetClass("distribute")

uiDistribute.NUM_PERPAGE = 10 -- 每页显示10记录
uiDistribute.MAX_PAGE = 2 -- 最多显示两页
uiDistribute.MAX_POINT = 100000000 -- 最多分配1亿
uiDistribute.MAX_NUM = uiDistribute.NUM_PERPAGE * uiDistribute.MAX_PAGE -- 最多显示 10 * 2 条信息
uiDistribute.nCurPage = 1
uiDistribute.tbAllInfo = {} -- 客户端缓存的所有数据

uiDistribute.BTN_CLOSE = "BtnClose"
uiDistribute.TXT_TITLE = "TxtTitle"
uiDistribute.PAGE_DISTRIBUTE = "Page_Distribute"
uiDistribute.TXT_DISTRIBUTETITLE = "Txt_DistributeTitle"
uiDistribute.TXT_CURPAGENUM = "Txt_CurPageNum"
uiDistribute.BTN_PREPAGE = "Btn_PrePage"
uiDistribute.BTN_NEXTPAGE = "Btn_NextPage"
uiDistribute.TXT_CURSTATE = "Txt_CurState"
uiDistribute.BTN_RESET = "Btn_Reset"
uiDistribute.BTN_ACCEPT = "Btn_Accept"
uiDistribute.TXT_JUNTUANINFO = "Txt_JunTuanInfo"
uiDistribute.TXT_ATTENTION = "Txt_Attention"
uiDistribute.TXT_ATTENTION = "Txt_Attention"

uiDistribute.TONGINFO = 1
uiDistribute.TXT_NAME = 2
uiDistribute.TXT_SERVER = 3
uiDistribute.BTN_ADD = 4
uiDistribute.TXT_NUM = 5
uiDistribute.BTN_SUB = 6

uiDistribute.PAGE_SET = {}
for i = 1, uiDistribute.NUM_PERPAGE do
  uiDistribute.PAGE_SET[i] = {}
  uiDistribute.PAGE_SET[i][uiDistribute.TONGINFO] = "List_TongInfo" .. i
  uiDistribute.PAGE_SET[i][uiDistribute.TXT_NAME] = "Txt_TongName" .. i
  uiDistribute.PAGE_SET[i][uiDistribute.TXT_SERVER] = "Txt_Server" .. i
  uiDistribute.PAGE_SET[i][uiDistribute.BTN_ADD] = "Btn_Add" .. i
  uiDistribute.PAGE_SET[i][uiDistribute.TXT_NUM] = "Txt_Num" .. i
  uiDistribute.PAGE_SET[i][uiDistribute.BTN_SUB] = "Btn_Sub" .. i
end

function uiDistribute:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_ACCEPT then
    self:AcceptDlg()
  elseif szWnd == self.BTN_RESET then
    self:Reset()
  elseif szWnd == self.BTN_PREPAGE then
    self:Prepage()
  elseif szWnd == self.BTN_NEXTPAGE then
    self:NextPage()
  else
    for i, tbInfo in pairs(self.PAGE_SET) do
      if szWnd == tbInfo[self.BTN_ADD] then
        self:AddPoint(i)
      elseif szWnd == tbInfo[self.BTN_SUB] then
        self:DesPoint(i)
      end
    end
  end
end

function uiDistribute:OnEditChange(szWnd, nParam)
  if not szWnd then
    return
  end

  for i, tbInfo in pairs(self.PAGE_SET) do
    if szWnd == tbInfo[self.TXT_NUM] then
      local nCurNum = Edt_GetInt(self.UIGROUP, szWnd)
      if nCurNum > self.MAX_POINT then
        nCurNum = self.MAX_POINT
      end
      if nCurNum <= 0 then
        nCurNum = 0
      end

      local nRealIndex = self:GetRealIndex(i)
      if not nRealIndex then
        return
      end
      if not self.tbAllInfo.tbTongInfo[nRealIndex] then
        return
      end
      local nTotalPoint = self.tbAllInfo.nTotalPoint
      local nOrgPoint = self.tbAllInfo.tbTongInfo[nRealIndex].nCurPoint or 0
      if nCurNum == self.tbBeforNum[nRealIndex].nBeforNum or nCurNum == 0 then
        return
      end

      local bModify = 0

      if nCurNum > nOrgPoint then
        if nTotalPoint <= 0 then
          Edt_SetTxt(self.UIGROUP, szWnd, tostring(nOrgPoint))
          self.tbBeforNum[nRealIndex].nBeforNum = nOrgPoint
          return
        end
        local nDiff = nCurNum - nOrgPoint
        if nDiff > nTotalPoint then
          nDiff = nTotalPoint
          nCurNum = nOrgPoint + nDiff
        end
        self.tbAllInfo.nTotalPoint = nTotalPoint - nDiff
        bModify = 1
      elseif nCurNum < nOrgPoint then
        local nDiff = nOrgPoint - nCurNum
        self.tbAllInfo.nTotalPoint = nTotalPoint + nDiff
        bModify = 1
      else
        return
      end

      self.tbBeforNum[nRealIndex].nBeforNum = nCurNum
      if 1 == bModify then
        self.tbAllInfo.tbTongInfo[nRealIndex].nCurPoint = nCurNum
        if self.tbAllInfo.nType == 1 then
          Txt_SetTxt(self.UIGROUP, self.TXT_CURSTATE, string.format("城主剩余箱子个数：%s", self.tbAllInfo.nTotalPoint))
        else
          Txt_SetTxt(self.UIGROUP, self.TXT_CURSTATE, string.format("城主剩余令牌个数：%s", self.tbAllInfo.nTotalPoint))
        end
        Edt_SetTxt(self.UIGROUP, szWnd, tostring(nCurNum))
      end

      return
    end
  end
end

-- 上一页
function uiDistribute:Prepage()
  if self.nCurPage <= 1 then
    return
  end
  self.nCurPage = self.nCurPage - 1
  self:UpdateInfo()
end

-- 下一页
function uiDistribute:NextPage()
  if self.nCurPage >= self.MAX_PAGE then
    return
  end
  self.nCurPage = self.nCurPage + 1
  self:UpdateInfo()
end

-- 增加分配点
function uiDistribute:AddPoint(nIndex)
  local nRealIndex = self:GetRealIndex(nIndex)
  if not nRealIndex then
    return
  end
  if not self.tbAllInfo.tbTongInfo[nRealIndex] then
    return
  end
  local nTotalPoint = self.tbAllInfo.nTotalPoint
  if nTotalPoint <= 0 then
    return
  end
  local nCurPoint = self.tbAllInfo.tbTongInfo[nRealIndex].nCurPoint or 0
  self.tbAllInfo.tbTongInfo[nRealIndex].nCurPoint = nCurPoint + 1
  self.tbAllInfo.nTotalPoint = nTotalPoint - 1
  self:UpdateInfo()
end

-- 减少分配点
function uiDistribute:DesPoint(nIndex)
  local nRealIndex = self:GetRealIndex(nIndex)
  if not nRealIndex then
    return
  end
  if not self.tbAllInfo.tbTongInfo[nRealIndex] then
    return
  end
  local nTotalPoint = self.tbAllInfo.nTotalPoint
  if nTotalPoint < 0 then
    return
  end
  local nCurPoint = self.tbAllInfo.tbTongInfo[nRealIndex].nCurPoint or 0
  if nCurPoint <= 0 then
    return
  end
  self.tbAllInfo.tbTongInfo[nRealIndex].nCurPoint = nCurPoint - 1
  self.tbAllInfo.nTotalPoint = nTotalPoint + 1
  self:UpdateInfo()
end

-- 确定分配
function uiDistribute:AcceptDlg()
  local nLeftPoint = self.tbAllInfo.nTotalPoint
  local tbMsg = {}
  tbMsg.szMsg = "你确定按照当前方案分配奖励吗？"
  if nLeftPoint > 0 then
    tbMsg.szMsg = tbMsg.szMsg .. string.format("\n注意：还有<color=red>%s<color>个未分配奖励，将归您所有。", nLeftPoint)
  end
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  local tbTmp = self.tbAllInfo
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      uiDistribute:OnAccept(tbTmp)
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nGoldDrawCount)
end

function uiDistribute:OnAccept(tbTmp)
  me.CallServerScript({ "ApplyDistributeResult", tbTmp })
end

-- 重置
function uiDistribute:Reset()
  self:OnRecvData(self.tbOrgInfo)
end

-- 获取真实的帮会的索引
-- 传入参数是当前帮会在页面中显示的第几个
-- 返回的是在self.tbAllInfo.tbTongInfo中真实的索引
function uiDistribute:GetRealIndex(nIndex)
  if not nIndex or nIndex <= 0 or nIndex > self.NUM_PERPAGE then
    return
  end
  local nRealIndex = (self.nCurPage - 1) * self.NUM_PERPAGE + nIndex
  return nRealIndex
end

-- 更新页面
function uiDistribute:UpdateInfo()
  local tbAllInfo = self.tbAllInfo
  local tbTongInfo = tbAllInfo.tbTongInfo
  if not tbAllInfo or not tbTongInfo then
    return
  end

  local sort_cmp = function(tb1, tb2)
    if tb1.nCurPoint and tb2.nCurPoint then
      return tb1.nCurPoint > tb2.nCurPoint
    else
      return false
    end
  end
  table.sort(self.tbAllInfo.tbTongInfo, sort_cmp)

  for i = 1, self.NUM_PERPAGE do
    Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.TONGINFO])
  end

  for i = 1, self.NUM_PERPAGE do
    local nRealIndex = self:GetRealIndex(i)
    if not nRealIndex then
      break
    end
    local tbCurTongInfo = tbTongInfo[nRealIndex]
    if not tbCurTongInfo then
      break
    end

    local szTongName = tbCurTongInfo.szTongName
    local szServer = ServerEvent:GetServerNameByGateway(tbCurTongInfo.szServer)
    local nCurPoint = tbCurTongInfo.nCurPoint or 0
    if not szTongName or not szServer or not nCurPoint then
      break
    end

    Txt_SetTxt(self.UIGROUP, self.PAGE_SET[i][self.TXT_NAME], szTongName)
    Txt_SetTxt(self.UIGROUP, self.PAGE_SET[i][self.TXT_SERVER], szServer)
    Edt_SetTxt(self.UIGROUP, self.PAGE_SET[i][self.TXT_NUM], nCurPoint)
    Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.TONGINFO])
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_CURPAGENUM, string.format("第%s页", self.nCurPage))
  if tbAllInfo.nType == 1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_CURSTATE, string.format("城主剩余箱子个数：%s", tbAllInfo.nTotalPoint))
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_CURSTATE, string.format("城主剩余令牌个数：%s", tbAllInfo.nTotalPoint))
  end
  local szJunTuanInfo = "\n"
  if tbAllInfo.szLingXiuName and tbAllInfo.nHoldTime then
    szJunTuanInfo = szJunTuanInfo .. string.format("占领军团领袖：%s\n", tbAllInfo.szLingXiuName)
  end
  local szAttention = ""
  if tbAllInfo.nType == 1 then
    szAttention = "注意：\n\n  1. 在此分配的箱子需要各帮会成员回到原服务器的跨服城战接头人处领取。\n\n  2. 奖励一旦确认分配，不可更改。\n\n  <color=red>3. 分配完成后，剩余的奖励归城主个人所有。<color>"
  else
    szAttention = "注意：\n\n  1. 在此分配的令牌需要各帮会成员回到原服务器的跨服城战接头人处领取。\n\n  2. 奖励一旦确认分配，不可更改。\n\n  <color=red>3. 分配完成后，剩余的奖励归城主个人所有。<color>"
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_ATTENTION, szAttention)
  Txt_SetTxt(self.UIGROUP, self.TXT_JUNTUANINFO, szJunTuanInfo)
end

function uiDistribute:OnRecvData(tbData)
  if not tbData then
    return 0
  end

  self.tbOrgInfo = {}
  self.tbOrgInfo.szLingXiuName = tbData.szLingXiuName
  self.tbOrgInfo.nHoldTime = tbData.nHoldTime
  self.tbOrgInfo.nTotalPoint = tbData.nTotalPoint
  self.tbOrgInfo.nType = tbData.nType
  self.tbOrgInfo.tbTongInfo = {}
  for _, tbInfo in pairs(tbData.tbTongInfo or {}) do
    table.insert(self.tbOrgInfo.tbTongInfo, { szTongName = tbInfo.szTongName, szServer = tbInfo.szServer })
  end

  self.tbAllInfo = tbData or {}

  -- 只显示前20记录，超出部分不显示
  local tbTongInfo = self.tbAllInfo.tbTongInfo
  self.tbBeforNum = {}
  for i = 1, #tbTongInfo do
    self.tbBeforNum[i] = {}
    self.tbBeforNum[i].nBeforNum = 0
  end

  if #tbTongInfo == 0 then
    self.MAX_PAGE = 1
  else
    self.MAX_PAGE = math.ceil(#tbTongInfo / self.NUM_PERPAGE)
  end
  self.nCurPage = 1
  self:UpdateInfo()
end

function uiDistribute:DisableAll()
  Wnd_SetEnable(self.UIGROUP, self.BTN_RESET, 0)
  Wnd_SetEnable(self.UIGROUP, self.BTN_ACCEPT, 0)
  for _, tbInfo in pairs(self.PAGE_SET) do
    Wnd_SetEnable(self.UIGROUP, tbInfo[self.BTN_ADD], 0)
    Wnd_SetEnable(self.UIGROUP, tbInfo[self.BTN_SUB], 0)
  end
end
